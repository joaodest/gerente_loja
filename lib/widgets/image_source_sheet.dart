import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatefulWidget {
  ImageSourceSheet({Key? key, required this.onImageSelected}) : super(key: key);

  final Function(File?) onImageSelected;

  @override
  State<ImageSourceSheet> createState() => _ImageSourceSheetState();
}

class _ImageSourceSheetState extends State<ImageSourceSheet> {
  File? _image;

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      setState((){
        _image = img;
        Navigator.of(context).pop;
      });
      img = await _cropImage(imageFile: img);
    } on PlatformException catch (e){
      print(e);
      Navigator.of(context).pop();
    }

    widget.onImageSelected(_image);
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () async {
                  _pickImage(ImageSource.camera);
                },
                child: Text("Camera"),
                style: TextButton.styleFrom(foregroundColor: Colors.black),
              ),
              TextButton(
                  onPressed: () async {
                    _pickImage(ImageSource.gallery);
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                  child: Text("Galeria"))
            ],
          );
        });
  }
}
