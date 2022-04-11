import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

FirebaseStorage _instance = FirebaseStorage.instance;

enum Upload {
  OFFER,
  BANNER,
  CIRCLE,
  PROFILE,
  CATALOGUE,
  BROADCAST,
}

class StorageService {
  Future<String> uploadImage({
    required Upload upload,
    required File file,
    String? path,
    String? name,
  }) async {
    Reference reference;

    switch (upload) {
      case Upload.OFFER:
        reference = _instance.ref('Offer');
        break;
      case Upload.BANNER:
        reference = _instance.ref('Banner');
        break;
      case Upload.CIRCLE:
        reference = _instance.ref('Circles');
        break;
      case Upload.PROFILE:
        reference = _instance.ref('Profile');
        break;
      case Upload.CATALOGUE:
        reference = _instance.ref('Catalogue');
        reference = reference.child('$path');
        break;
      case Upload.BROADCAST:
        reference = _instance.ref('Broadcast');
        break;
      default:
        reference = _instance.ref('default');
        break;
    }

    var filePath = file.path;

    String fileShowText = '';
    String title = '';
    String type = '';

    int i = filePath.lastIndexOf('/');
    if (i <= -1) {
      fileShowText = filePath;
    } else {
      fileShowText = filePath.substring(i + 1);
    }

    int j = fileShowText.lastIndexOf('.');

    if (j > -1) {
      title = fileShowText.substring(0, j);
      type = fileShowText.substring(j + 1).toLowerCase();
    }

    reference = reference.child(name == null ? '$title.$type' : '$name.$type');

    await reference.putFile(file);
    return await reference.getDownloadURL();
  }

// Delete
/*
  StorageReference photoRef = mFirebaseStorage.getReferenceFromUrl(mImageUrl);
  Then delete as you were:

  photoRef.delete().addOnSuccessListener(new OnSuccessListener<Void>() {
      @Override
      public void onSuccess(Void aVoid) {
          // File deleted successfully
          Log.d(TAG, "onSuccess: deleted file");
      }
      }).addOnFailureListener(new OnFailureListener() {
      @Override
      public void onFailure(@NonNull Exception exception) {
          // Uh-oh, an error occurred!
          Log.d(TAG, "onFailure: did not delete file");
      }
  });
  */
}
