import 'package:circle/app/app.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddBroadcast extends StatefulWidget {
  @override
  State<AddBroadcast> createState() => _AddBroadcastState();
}

class _AddBroadcastState extends State<AddBroadcast> {
  BroadcastModal modal = BroadcastModal();
  var db = FirestoreService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var profile = context.read<ProfileModal>();
    var args = ModalRoute.of(context)?.settings.arguments;
    var snapshot = args as QueryDocumentSnapshot<CircleModal>;
    debugPrint('${profile.name}');

    return Scaffold(
      appBar: AppBar(title: Text('Add Broadcast'.toUpperCase())),
      body: ListView(padding: EdgeInsets.all(18), children: [
        SizedBox(height: 18),
        TextFormField(
          decoration: InputDecoration(
            errorText: modal.errorName,
            labelText: 'Title',
            helperText: '',
          ),
          keyboardType: TextInputType.name,
          onChanged: (String value) => modal.name = value,
          controller: TextEditingController(text: modal.name),
        ),
        SizedBox(height: 6),
        TextFormField(
          minLines: 3,
          maxLines: 6,
          decoration: InputDecoration(
            errorText: modal.errorDescription,
            labelText: 'Text',
            helperText: '',
          ),
          keyboardType: TextInputType.multiline,
          onChanged: (String value) => modal.description = value,
          controller: TextEditingController(text: modal.description),
        ),
        SizedBox(height: 18),
        if (false)
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(children: [
              ImagePickerWidget(
                radius: 60,
                photo: modal.photo,
                name: modal.documentId,
                upload: Upload.BROADCAST,
                assets: 'assets/default/broadcast.png',
                updated: (String? path) => setState(() {
                  modal.photo = path;
                  print('BROADCAST done ${modal.photo}');
                }),
              ),
              Text(
                "Attach Image",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blue),
              ),
            ]),
          ]),
        FilePickerWidget(
          name: modal.documentId,
          upload: Upload.BROADCAST,
          updated: (String? path) => setState(() {
            modal.file = path;
            print('BROADCAST DONE ${modal.file}');
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('File'),
                content: Text('File attached successfully'),
                actions: [
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            );
          }),
        ),
        SizedBox(height: 18),
        ElevatedButton(
          onPressed: () async {
            if (modal.hasError) {
              setState(() => print('error => $modal'));
              return;
            }

            await db
                .broadcast(snapshot.reference)
                .doc(modal.documentId)
                .set(modal);

            db.sendBroadNotifications(snapshot);

            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('BROADCAST'),
                content: Text('BROADCAST Add successfully'),
                actions: [
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            );

            Navigator.of(context, rootNavigator: true).pop(true);
            print('BROADCAST => $modal');
          },
          child: Container(
            alignment: Alignment.center,
            height: 50,
            child: Text(
              'SUBMIT',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ]),
    );
  }
}
