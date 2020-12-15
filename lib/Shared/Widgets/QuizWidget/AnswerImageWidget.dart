import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnswerImageWidget extends StatefulWidget 
{
  final Function (File pickedImage) onImagePick;

  AnswerImageWidget(this.onImagePick);

  @override
  _AnswerImageWidgetState createState() => _AnswerImageWidgetState();
}

class _AnswerImageWidgetState extends State<AnswerImageWidget> 
{
  File _pickedImageFile;

  Future<void> _pickedImage() async
  {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150
    );

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onImagePick(_pickedImageFile);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 150,
              backgroundColor: Colors.grey,
              backgroundImage: _pickedImageFile != null ? FileImage(_pickedImageFile) : null,
            ),
            FlatButton.icon(
              icon: Icon(
                Icons.image,
                color: Theme.of(context).primaryColor,
              ),
              label: Text(
                'Adicionar Imagem',
                style: TextStyle(
                  color: Theme.of(context).primaryColor
                ),
              ),
              onPressed: _pickedImage,
            )
          ],
        ),
      ),
    );
  }
}