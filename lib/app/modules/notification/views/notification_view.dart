

import 'package:flutter/material.dart';



import '../controllers/notification_controller.dart';


import 'package:get/get.dart'; 

class NotificationView extends GetView<NotificationController> {
 const NotificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotificationView'),
        centerTitle: true,
      ),
      body:const Center(
        child: Text(
          'NotificationView is working', 
          style: TextStyle(fontSize:20),
        ),
      ),
    );
  }
}
  