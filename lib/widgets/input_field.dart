import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  InputField(
      {Key? key,
      required this.icon,
      required this.obscure,
      required this.hint,
      required this.stream,
      required this.onChanged})
      : super(key: key);

  final TextEditingController controller = TextEditingController();

  final IconData icon;
  final String hint;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return TextField(
            keyboardType: TextInputType.emailAddress,
            onChanged: onChanged,
            controller: controller,
            obscureText: obscure,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              errorText: snapshot.error?.toString(),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white, fontSize: 15),
              icon: Icon(
                icon,
                color: Colors.white,
              ),
              contentPadding: const EdgeInsets.only(
                  top: 22, bottom: 22, left: 8, right: 22),
            ),
          );
        });
  }
}
