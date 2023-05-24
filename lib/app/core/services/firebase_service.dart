import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:social_app/firebase_options.dart';

import '../../modules/authentication/controllers/authentication_controller.dart';
import '../utils/utils.dart';

part 'firestore_service.dart';
part 'notification_service.dart';

class FireBaseService extends GetxService with FireStoreService, NotificationService {}
