import 'package:flutter/material.dart';

typedef validationFunction = String? Function(String?);

class Customformfield extends StatefulWidget {
  final String label;
  final int? maxLines;
  final TextInputType keyboard;
  final TextEditingController controller;
  final bool isPassword;
  final validationFunction Validator;

  const Customformfield({
    required this.label,
    required this.keyboard,
    required this.controller,
    this.isPassword = false,
    required this.Validator,
    this.maxLines=1,
  });

  @override
  State<Customformfield> createState() => _CustomformfieldState();
}

class _CustomformfieldState extends State<Customformfield> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      minLines: 1,
      validator: widget.Validator,
      obscuringCharacter: "*",
      obscureText: widget.isPassword ? isVisible : false,
      keyboardType: widget.keyboard,
      controller: widget.controller,
      style: Theme.of(context).textTheme.titleSmall,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                icon: Icon(
                  isVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                color: Theme.of(context).primaryColor,
              )
            : null,
        labelText: widget.label,
        labelStyle: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
