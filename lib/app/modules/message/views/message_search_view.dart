//random chơi

// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:social_app/app/core/utils/utils.dart';

class MessageSearchView extends StatelessWidget {
  MessageSearchView({super.key});
  final TextEditingController txtSearch = TextEditingController();
  final Debouncer debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  @override
  Widget build(BuildContext context) {
    // final controller = context.read<MessageController>();
    return GestureDetector(
      //huy keyboard khi bam ngoai man hinh
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: const Scaffold(
        //Hide
        //drawer: const NavigationDrawer(),
        body: Text('asdasd'),
      ),
    );
  }
}
