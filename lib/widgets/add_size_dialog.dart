import 'package:flutter/material.dart';


class AddSizeDialog extends StatelessWidget {
   AddSizeDialog({Key? key}) : super(key: key);

  final _controller = TextEditingController();



  @override
  Widget build(BuildContext context) {

    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).primaryColor)));
    }

    return Dialog(
      backgroundColor: Colors.black87,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: Colors.white70)
        ),
        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min ,
          children: [
            TextField(
              controller: _controller,
              decoration: _buildDecoration("Adicione o tamanho do produto"),
              style: TextStyle(color: Colors.white),
            ),
            Container(

              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text("Add"),
                style: TextButton.styleFrom(foregroundColor: Colors.pinkAccent),
                onPressed: () {
                  Navigator.of(context).pop(_controller.text);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
