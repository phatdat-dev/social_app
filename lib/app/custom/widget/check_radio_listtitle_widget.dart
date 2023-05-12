import 'package:flutter/material.dart';

class CheckRadioListTileWidget<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final Widget title;
  final ValueChanged<T?> onChanged;
  final Widget? leading;
  final Widget? subtitle;
  final bool isThreeLine;

  const CheckRadioListTileWidget({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.leading,
    this.subtitle,
    this.isThreeLine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return ListTile(
      onTap: () => onChanged(value),
      leading: leading,
      title: title,
      subtitle: subtitle,
      isThreeLine: isThreeLine,
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
    );
  }
}
