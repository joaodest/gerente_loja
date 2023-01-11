import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/blocs/category_bloc.dart';
import 'package:gerente_loja/widgets/image_source_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditCategoryDialog extends StatefulWidget {
  const EditCategoryDialog({Key? key, this.category}) : super(key: key);

  final DocumentSnapshot? category;

  @override
  State<EditCategoryDialog> createState() =>
      _EditCategoryDialogState(category: category);
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  _EditCategoryDialogState({DocumentSnapshot? category})
      : _categoryBloc = CategoryBloc(category: category),
        _controller = TextEditingController(
            text: category != null ? category.get("title") : "");

  final CategoryBloc _categoryBloc;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) =>
                          ImageSourceSheet(onImageSelected: (image) {
                            Navigator.of(context).pop();
                            // _categoryBloc.setImage(image);
                          }));
                },
                child: StreamBuilder(
                    stream: _categoryBloc.outImage,
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return CircleAvatar(
                          child: snapshot.data is File?
                              ? Image.file(snapshot.data, fit: BoxFit.cover)
                              : Image.network(snapshot.data, fit: BoxFit.cover),
                          backgroundColor: Colors.transparent,
                        );
                      } else {
                        return Container(
                            child: Icon(
                          Icons.image,
                          size: 40,
                        ));
                      }
                    }),
              ),
              title: StreamBuilder<String>(
                  stream: _categoryBloc.outTitle,
                  builder: (context, snapshot) {
                    return TextField(
                      controller: _controller,
                      onChanged: _categoryBloc.setTitle,
                      decoration: InputDecoration(
                          errorText: snapshot.hasError
                              ? (snapshot.error as String)
                              : null),
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder<bool>(
                    stream: _categoryBloc.outDelete,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        return TextButton(
                          onPressed: snapshot.data! ? () {
                            _categoryBloc.delete();
                            Navigator.of(context).pop();
                          } : null,
                          child: Text(
                            "Excluir",
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }
                    }),
                StreamBuilder<bool>(
                    stream: _categoryBloc.submitValid,
                    builder: (context, snapshot) {
                      return TextButton(
                          onPressed: snapshot.hasData ? () async {
                           await _categoryBloc.saveData();
                            Navigator.of(context).pop();
                          } : null,
                          child: Text("Salvar",
                              style: TextStyle(color: Colors.black)));
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}
