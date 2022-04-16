import 'dart:io';

import 'package:circle/app/app.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilePickerWidget extends StatefulWidget {
  final Function(String? path) updated;
  final Upload upload;
  final String? name;

  const FilePickerWidget({
    Key? key,
    this.name,
    required this.upload,
    required this.updated,
  }) : super(key: key);

  @override
  State<FilePickerWidget> createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  Future<bool> onPressed() async {
    var result = await FilePicker.platform.pickFiles(
      onFileLoading: (value) => print('status $value'),
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
      type: FileType.custom,
    );
    if (result != null) {
      File file = File(result.files.single.path ?? '');
      if (result.files.single.path != null) {
        int bytes = await file.length();
        final kb = bytes / 1024;
        final mb = kb / 1024;

        debugPrint('kb => $kb, mb => $mb');
        if (mb > 2) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('File'),
              content: const Text('File is large 2MB'),
              actions: [
                TextButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          );
          return false;
        }
        setState(() => showLoading = true);
        var storage = StorageService();
        var path = await storage.uploadImage(
          upload: widget.upload,
          name: widget.name,
          file: file,
        );
        widget.updated(path);
        setState(() => showLoading = false);
      }
    }
    return true;
  }

  var showLoading = false;

  @override
  Widget build(BuildContext context) {
    return showLoading
        ? Container(
            child: CupertinoActivityIndicator(),
            alignment: Alignment.center,
            height: 60,
          )
        : TextButton.icon(
            onPressed: onPressed,
            icon: Icon(Icons.attach_file),
            label: Text('Attach File'),
          );
  }
}

class ImagePickerWidget extends StatefulWidget {
  final Function(String? path) updated;
  final Upload upload;

  final double radius;
  final Widget? child;

  final String? name;
  final String? photo;
  final String? assets;

  const ImagePickerWidget({
    Key? key,
    this.name,
    this.child,
    this.photo,
    this.assets,
    required this.upload,
    required this.updated,
    this.radius = 120,
  }) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Future<bool> uploadImage(bool isCamera) async {
    var picker = ImageCropPicker();
    var file = await picker.pickImage(isCamera: isCamera);
    if (file != null) {
      setState(() => showLoading = true);
      var storage = StorageService();
      var path = await storage.uploadImage(
        upload: widget.upload,
        name: widget.name,
        file: file,
      );

      widget.updated(path);
      setState(() => showLoading = false);
    }
    return true;
  }

  var showLoading = false;

  @override
  Widget build(BuildContext context) {
    var asset = widget.assets ?? 'assets/default/default.jpg';
    //var photo = 'https://firebasestorage.googleapis.com/v0/b/konnect-my-circle-app.appspot.com/o/Circles%2Fabd249a0-319b-11ec-884c-65d49ec78a72.jpg?alt=media&token=aa5ccecc-407c-4d51-8c57-75555daad994';
    var photo = widget.photo;
    return InkWell(
      onTap: () async {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text('Camera'),
                    onPressed: () {
                      Navigator.pop(context, true);
                      uploadImage(true);
                    },
                  ),
                  Divider(),
                  TextButton.icon(
                      icon: Icon(Icons.image),
                      label: Text('Gallery'),
                      onPressed: () {
                        Navigator.pop(context, true);
                        uploadImage(false);
                      }),
                  Divider(),
                  TextButton.icon(
                      icon: Icon(Icons.delete),
                      label: Text('Remove'),
                      onPressed: () {
                        Navigator.pop(context, false);
                        widget.updated(null);
                      }),
                  Divider(),
                  Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        child: Text('CLOSE'),
                        onPressed: () async {
                          Navigator.pop(context, false);
                        }),
                  ),
                ]),
          ),
        );
      },
      child: showLoading
          ? Container(
              child: CupertinoActivityIndicator(),
              alignment: Alignment.center,
              height: widget.radius,
            )
          : widget.child == null
              ? Container(
                  width: widget.radius,
                  height: widget.radius,
                  clipBehavior: Clip.hardEdge,
                  child: photo == null
                      ? Image.asset(
                          asset,
                          fit: BoxFit.contain,
                        )
                      : Image.network(
                          photo,
                          fit: BoxFit.contain,
                        ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.red)),
                )
              : widget.child,
    );
  }
}
