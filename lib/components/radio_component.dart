import 'package:flutter/material.dart';

class Dom24x7Radio<T> extends StatefulWidget {
  final T value;
  final T? groupValue;
  final String label;
  final ValueChanged<T?>? onChanged;
  const Dom24x7Radio({Key? key, required this.value, required this.groupValue, required this.label, required this.onChanged}) : super(key: key);

  @override
  _Dom24x7RadioState<T> createState() => _Dom24x7RadioState<T>();
}

class _Dom24x7RadioState<T> extends State<Dom24x7Radio<T>> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [Radio<T>(value: widget.value, groupValue: widget.groupValue, onChanged: widget.onChanged), Text(widget.label)]);
  }
}
