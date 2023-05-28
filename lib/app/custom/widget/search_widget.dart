// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/utils/utils.dart';

class SearchWidget extends StatelessWidget {
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextEditingController? controller;
  final Color? backgroundColor;
  final double? elevation;

  SearchWidget({
    Key? key,
    this.hintText,
    this.onChanged,
    this.onTap,
    this.controller,
    this.readOnly = false,
    this.backgroundColor,
    this.elevation,
  }) : super(key: key);

  final Debouncer debouncer = Debouncer(delay: const Duration(milliseconds: 200));

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(25);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      // decoration: BoxDecoration(
      //   borderRadius: borderRadius,
      //   color: Theme.of(context).colorScheme.surface,
      // ),
      // width: MediaQuery.of(context).size.width * 0.9,
      // height: 55,
      elevation: elevation,
      color: backgroundColor,
      child: TextField(
        readOnly: readOnly,
        controller: controller,
        textInputAction: TextInputAction.search,
        style: const TextStyle(fontSize: 20),
        decoration: InputDecoration(
          // filled: true,
          border: OutlineInputBorder(borderRadius: borderRadius, borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
          hintText: hintText ?? '${LocaleKeys.Search.tr}...',
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 16),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColor),
          suffixIcon: Material(
            elevation: 0.5,
            borderRadius: borderRadius,
            child: InkWell(
              onTap: () {
                controller?.clear();
                onChanged != null ? onChanged!('') : null;
              },
              borderRadius: borderRadius,
              child: const Icon(Icons.close),
            ),
          ),
        ),
        onChanged: (value) {
          if (onChanged != null) debouncer(() async => onChanged!(value));
        },
        onTap: onTap,
      ),
    );
  }
}
