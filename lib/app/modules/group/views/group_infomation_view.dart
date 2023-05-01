import 'package:flutter/material.dart';

class GroupInfomationView extends StatefulWidget {
  const GroupInfomationView({super.key});

  @override
  State<GroupInfomationView> createState() => _GroupInfomationViewState();
}

class _GroupInfomationViewState extends State<GroupInfomationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('GroupInfomationView'),
      ),
      body: const Center(
        child: Text(
          'GroupInfomationView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
