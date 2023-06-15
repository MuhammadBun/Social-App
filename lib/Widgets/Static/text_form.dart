import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class CostumTextFormFields extends StatelessWidget {
  CostumTextFormFields(
      {Key? key,
      required this.hintText,
      required this.icon,
      required this.onChanged,
      required this.onSaved,
      required this.validator,
      required this.controller,
      this.foucsNode})
      : super(key: key);
  final String hintText;
  final Icon? icon;
  final void Function(String?)? onSaved;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  FocusNode? foucsNode;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: TextFormField(
        focusNode: foucsNode,
        cursorWidth: 3,
        cursorColor: Colors.grey,
        controller: controller,
        onSaved: onSaved,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
          contentPadding: EdgeInsets.all(23),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 2, color: Colors.transparent)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 2, color: Colors.transparent)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 2, color: Colors.transparent)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(width: 2, color: Colors.transparent)),
          fillColor: Colors.grey.withOpacity(0.4),
          filled: true,
        ),
      ),
    );
  }
}
