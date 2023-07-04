// ignore_for_file: invalid_use_of_protected_member

import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/openai_controller.dart';

class OpenAIMessageSettingBotView extends StatefulWidget {
  const OpenAIMessageSettingBotView({super.key});

  @override
  State<OpenAIMessageSettingBotView> createState() => _OpenAIMessageSettingBotViewState();
}

class _OpenAIMessageSettingBotViewState extends State<OpenAIMessageSettingBotView> {
  late final OpenAIController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.find<OpenAIController>();
    if (controller.responseModels.status != RxStatus.success()) controller.getAllModel();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => WidgetsBinding.instance.focusManager.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Setting Bot'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
            children: [
              const ListTile(
                leading: Text('Lưu ý: '),
                title: Text(
                  'Chỉnh chế độ khác ngoài mạc định có thể dẫn đến Bot nó \"không được thông minh cho lắm\" (Ngu)',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              const Divider(),
              Obx(
                () => InkWell(
                  onTap: () async {
                    final result = await HelperWidget.showSearchDropDown(context: context, data: controller.responseModels.state!);
                    if (result != null) {}
                  },
                  child: Ink(
                    // width: context.width * 0.5,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(controller.modelSelectDropDown.value.queryName),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: '''
The maximum number of tokens to 
generate. Requests can use up to 2,048 
or 4,000 tokens shared between 
prompt and completion. The exact limit 
varies by model. (One token is roughly 4 
characters for normal English text)
''',
                child: ListTile(
                    leading: const Text('Max Tokens'),
                    title: TextField(
                      controller: controller.maxTokensController,
                      onTap: () => controller.maxTokensController.selectionAll(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          // suffixText: suffixText,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          // labelText: "Max Tokens",
                          hintText: '1,000'),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        LimitRangeTextInput(minRange: 1, maxRange: 4000)
                      ],
                      // onChanged: (newValue) {
                      //   if (newValue.isEmpty) {
                      //     controller.maxTokensController.text = "1";
                      //     controller.maxTokensController.selection = const TextSelection.collapsed(offset: 1);
                      //   }
                      // },
                    )),
              ),
              Tooltip(
                message: ''' 
Controls randomness: Lowering results 
in less random completions. As the 
temperature approaches zero, the 
model will become deterministic and 
repetitive.
                ''',
                child: ListTile(
                  leading: const Text('Temperature'),
                  title: StatefulBuilder(
                      builder: (context, setState) => Slider(
                            value: controller.temperature,
                            onChanged: (newValue) {
                              setState(() => controller.temperature = newValue);
                            },
                            min: 0,
                            max: 1,
                            label: '${controller.temperature}',
                            activeColor: Colors.green,
                            divisions: 20,
                          )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
