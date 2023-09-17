import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final Function(String val) onChanged;
  bool? obscure;

  CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.onChanged,
    this.obscure,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: (val) {
          if (val == null || val.isEmpty) return 'This field is required';
        },
        obscureText: widget.obscure ?? false,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          label: Text(widget.label),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.purpleAccent,
              width: 2.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Colors.purple,
              width: 2.0,
            ),
          ),
          suffixIcon: (widget.obscure != null)
              ? widget.obscure!
                  ? IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () => setState(() => widget.obscure = false),
                    )
                  : IconButton(
                      icon: const Icon(Icons.visibility_off),
                      onPressed: () => setState(() => widget.obscure = true),
                    )
              : null,
        ),
      ),
    );
  }
}
