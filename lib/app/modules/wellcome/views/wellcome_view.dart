import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ckc_social_app/app/modules/wellcome/controller/wellcome_controller.dart';
import 'package:ckc_social_app/generated/locales.g.dart';

import '../../../routes/app_pages.dart';

class WellcomeView extends GetView<WellComeController> {
  const WellcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WellcomeView'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('You have pushed the button this many times:'),
          Text(LocaleKeys.PleaseWait.tr),
          Text(
            '${controller.counter}',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: '1',
                onPressed: () {
                  controller.increment();
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                heroTag: '2',
                onPressed: () {
                  controller.decrement();
                },
                tooltip: 'Decrement',
                child: const Icon(Icons.remove),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {
              Get.offAllNamed(Routes.HOME());
            },
            icon: const Icon(Icons.dangerous),
            label: const Text('fetchData'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: '+84388002837',
                verificationCompleted: (phoneAuthCredential) {},
                verificationFailed: (error) {},
                codeSent: (verificationId, forceResendingToken) {},
                codeAutoRetrievalTimeout: (verificationId) {},
              );
            },
            icon: const Icon(Icons.sms_outlined),
            label: const Text('SMS OTP send'),
          ),
        ],
      ),
    );
  }
}
