import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final Icon icon;
  const CustomTextField(
      {super.key, required this.controller, required this.icon});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: icon,
        prefixIconColor:
            MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.focused)) {
            return Colors.blue;
          }
          if (states.contains(MaterialState.error)) {
            return Colors.red;
          }
          return Colors.white;
        }),
      ),
    );
  }
}

class CustomPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final Icon icon;
  const CustomPasswordField(
      {super.key, required this.controller, required this.icon});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: icon,
        prefixIconColor:
            MaterialStateColor.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.focused)) {
            return Colors.blue;
          }
          if (states.contains(MaterialState.error)) {
            return Colors.red;
          }
          return Colors.white;
        }),
      ),
    );
  }
}
