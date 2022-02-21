import 'package:flutter/material.dart';

class Dom24x7Checkbox extends StatefulWidget {
  final bool? value;
  final String label;
  final ValueChanged<bool?>? onChanged;

  const Dom24x7Checkbox({Key? key, required this.value, required this.label, required this.onChanged}) : super(key: key);

  @override
  State<Dom24x7Checkbox> createState() => _Dom24x7CheckboxState();
}

class _Dom24x7CheckboxState extends State<Dom24x7Checkbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: widget.value, onChanged: widget.onChanged),
        Expanded(
          child: Text(widget.label, overflow: TextOverflow.ellipsis, maxLines: 2,)
        )
      ]
    );
  }
}