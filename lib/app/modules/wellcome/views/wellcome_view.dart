import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:social_app/app/modules/wellcome/controller/wellcome_controller.dart';

class WellcomeView extends StatefulWidget {
  const WellcomeView({super.key});

  @override
  State<WellcomeView> createState() => _WellcomeViewState();
}

class _WellcomeViewState<T extends WellComeController> extends State<WellcomeView> {
  late final T controller;

  @override
  void initState() {
    controller = context.read<T>();
    controller.onInitData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WellcomeView'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('You have pushed the button this many times:'),
          Text('PleaseWait'.tr()),
          Consumer<WellComeController>(
            builder: (context, controller, child) {
              return Text(
                '${controller.counter}',
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: "1",
                onPressed: () {
                  controller.increment();
                },
                tooltip: 'Increment',
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                heroTag: "2",
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
              context.push("/");
            },
            icon: Icon(Icons.dangerous),
            label: Text("fetchData"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: "+84388002837",
                verificationCompleted: (phoneAuthCredential) {},
                verificationFailed: (error) {},
                codeSent: (verificationId, forceResendingToken) {},
                codeAutoRetrievalTimeout: (verificationId) {},
              );
            },
            icon: Icon(Icons.sms_outlined),
            label: Text("SMS OTP send"),
          ),
        ],
      ),
    );
  }
}
