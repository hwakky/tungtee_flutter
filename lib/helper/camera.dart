import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tangteevs/helper/random.dart';

class Camera {
  final ImagePicker _picker = ImagePicker();
  var imagefile;
  final onUpload;
  String? locatation;
  Camera({this.onUpload});

  Camera.profile({this.onUpload}) {
    locatation = "profile";
  }

  Camera.messages({this.onUpload}) {
    locatation = "messages";
  }

  Camera.idcard({this.onUpload}) {
    locatation = "idcard";
  }

  void _takeImageFromCamera() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    imagefile = File(image!.path);
    _uploadFile();
  }

  void _takeImageFromGallery() async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    imagefile = File(image!.path);
    _uploadFile();
  }

  _uploadFile() {
    if (imagefile == null) return;
    final storageRef = FirebaseStorage.instance.ref();
    var filename = '${generateRandomString(7)}.jpg';
    var path =
        '${FirebaseAuth.instance.currentUser?.uid}/${locatation}/${filename}';
    final imagesRef = storageRef.child(path);

    imagesRef.putFile(imagefile).snapshotEvents.listen((event) {
      switch (event.state) {
        case TaskState.success:
          imagesRef.getDownloadURL().then((url) => onUpload(url));
          break;
        case TaskState.paused:
          //
          break;
        case TaskState.running:
          //
          break;
        case TaskState.canceled:
          //
          break;
        case TaskState.error:
          //
          break;
      }
    });
  }
  showModal (BuildContext context){
    return showCupertinoModalPopup(
      context: context,
       builder: (BuildContext context) => CupertinoActionSheet(  
        title: const Text('New Media'),
        message: const Text('Choose where to pick a new media'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: (){
              _takeImageFromGallery();
              (context);
            }, child: const Text('Gallery')),
            CupertinoActionSheetAction(
            onPressed: () => {}, child: const Text('Camera')),
            CupertinoActionSheetAction(
            onPressed: () => {}, child: const Text('Cancel')),
        ],
       ));
  }
}
