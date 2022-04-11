import 'package:circle/app/app.dart';
import 'package:circle/modal/modal.dart';
import 'package:circle/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditBroadcast extends StatefulWidget {
  @override
  State<EditBroadcast> createState() => _EditBroadcastState();
}

class _EditBroadcastState extends State<EditBroadcast> {
  QueryDocumentSnapshot<BroadcastModal>? snapshot;
  var modal = BroadcastModal();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      var args = ModalRoute.of(context)?.settings.arguments;
      snapshot = args as QueryDocumentSnapshot<BroadcastModal>;
      modal = snapshot?.data() ?? BroadcastModal();
      setState(() => true);
    });
  }

  @override
  Widget build(BuildContext context) {
    var profile = context.read<ProfileModal>();

    return Scaffold(
      appBar: AppBar(title: Text('Edit Broadcast'.toUpperCase())),
      body: ListView(padding: EdgeInsets.all(18), children: [
        ImagePickerWidget(
          photo: modal.photo,
          name: modal.documentId,
          upload: Upload.BROADCAST,
          assets: 'assets/default/broadcast.png',
          updated: (String? path) => setState(() {
            modal.photo = path;
            print('BROADCAST done ${modal.photo}');
          }),
        ),
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
        ElevatedButton(
          onPressed: () async {
            if (modal.hasError) {
              setState(() => print('error => $modal'));
              return;
            }

            await snapshot?.reference.set(modal);

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
