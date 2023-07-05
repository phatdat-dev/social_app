// ignore_for_file: invalid_use_of_protected_member

import 'package:ckc_social_app/app/core/utils/utils.dart';
import 'package:ckc_social_app/app/modules/message/open_ai/connect/openai_connect.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/base/base_project.dart';
import '../model/openai_completion_request_model.dart';
import '../model/openai_completion_response_model.dart';
import '../model/openai_model_response.dart';

class OpenAIController extends BaseController {
  @override
  OpenAiConnect get apiCall => Get.put(OpenAiConnect());

  final ListDataState<OpenAiModelResponse> responseModels = ListDataState([]);
  late Rx<OpenAiModelResponse> modelSelectDropDown;
  late final TextEditingController maxTokensController;
  double temperature = 1;

  @override
  Future<void> onInitData() async {
    modelSelectDropDown = OpenAiModelResponse(id: 'text-davinci-003').obs;
    maxTokensController = TextEditingController(text: '1,000');
  }

  Future<OpenAiCompletionResponse?> sendCompletion(String inputText) async {
    final res = await apiCall.onRequest(
      '/completions',
      RequestMethod.POST,
      body: OpenAiCompletionRequest(
        model: modelSelectDropDown.value.id,
        prompt: inputText,
        maxTokens: maxTokensController.text.toInt(),
        temperature: temperature,
      ),
      baseModel: OpenAiCompletionResponse(),
    );
    if (res != null) {
      // responseChat.value = res;

      // change(responseChat, status: RxStatus.success());
      return res;
    }
    return null;
  }

  Future<void> getAllModel() async {
    final json = await apiCall.onRequest('/models', RequestMethod.GET);
    if (json != null) {
      responseModels.change(
        List<OpenAiModelResponse>.from((json['data'] as List).map((x) => OpenAiModelResponse().fromJson(x))),
        status: RxStatus.success(),
      );

      for (var element in responseModels.state!) {
        switch (element.id) {
          case 'text-davinci-003':
            element.description = ''' 
text-davinci-003 
Most capable model in the GPT-3 series. Can perform any task the other GPT-3 models can, often with higher quality,
longer output and better instruction-following. It can process up to 4,000 tokens per request. 

STRENGTHS 
Complex intent, cause and effect, creative generation, search, summarization for audience ''';
            break;

          case 'text-curie-001':
            element.description = ''' 
text-curie-001 
Formerly curie-instruct-beta-v2 
Very capable, but faster and lower 
cost than text-davinci-003. 

STRENGTHS 
Language translation, complex 
classification, sentiment, 
summarization
 ''';
            break;

          case 'text-babbage-001':
            element.description = ''' 
text-babbage-001 
Formerly babbage-instruct-beta 
Capable of straightforward tasks, 
very fast, and lower cost. 

STRENGTHS 
Moderate classification, semantic 
search
 ''';
            break;

          case 'text-ada-001':
            element.description = ''' 
text-ada-001 
Formerly ada-instruct-beta 
Capable of simple tasks, usually 
the fastest model in the GPT-3 
series, and lowest cost. 

STRENGTHS 
Parsing text, simple classification, 
address correction, keywords
 ''';
            break;

          case 'code-davinci-002':
            element.description = ''' 
code-davinci-002 
Most capable model in the Codex 
series, which can understand and 
generate code, including 
translating natural language to 
code. It can process up to 4,000 
tokens per request. 
Our JavaScript Sandbox demo 
application uses this model to 
translate instructions into JS.
 ''';
            break;

          case 'code-cushman-001':
            element.description = ''' 
code-cushman-001 
Formerly cushman-codex 
Almost as capable as code- 
davinci-002, but slightly faster. 
Part of the Codex series, which 
can understand and generate 
code. 
Our JavaScript Sandbox demo 
application uses this model to 
translate instructions into JS. 

STRENGTHS 
Real-time applications where low 
latency is preferable
 ''';
            break;

          case 'text-davinci-002':
            element.description = ''' 
text-davinci-002 
Second generation model in the 
GPT-3 series. Can perform any 
task the earlier GPT-3 models can, 
often with less context. It can 
process up to 4,000 tokens per 
request. 

STRENGTHS 
Complex intent, cause and effect, 
creative generation, search, 
summarization for audience
 ''';
            break;

          case 'text-davinci-001':
            element.description = ''' 
text-davinci-001 
Formerly davinci-instruct-beta-v3 
Older version of the most capable 
model in the GPT-3 series. Can 
perform any task the other GPT-3 
models can, often with less 
context. 

STRENGTHS 
Complex intent, cause and effect, 
creative generation, search, 
summarization for audience
 ''';
            break;

          case 'davinci-instruct-beta':
            element.description = ''' 
davinci-instruct-beta 
This is an older model. We 
recommend using our latest GPT-3 
models instead. 

STRENGTHS 
Shorter and more naturally 
phrased prompts, complex intent, 
cause and effect
''';
            break;
          case 'davinci':
            element.description = ''' 
davinci 
This model is part of our original, 
base GPT-3 series. We recommend 
using our latest GPT-3 models 
instead. Learn more. 

STRENGTHS 
Complex intent, cause and effect, 
creative generation, search, 
summarization for audience
''';
            break;

          case 'curie-instruct-beta':
            element.description = ''' 
curie-instruct-beta 
This is an older model. We 
recommend using our latest GPT-3 
models instead. 

STRENGTHS 
Shorter and more naturally 
phrased prompts, language 
translation, complex 
classification, sentiment
''';
            break;

          case 'curie':
            element.description = ''' 
curie 
This model is part of our original, 
base GPT-3 series. We recommend 
using our latest GPT-3 models 
instead. Learn more. 

STRENGTHS 
Language translation, complex 
classification, sentiment, 
summarization
''';
            break;

          case 'babbage':
            element.description = ''' 
babbage 
This model is part of our original, 
base GPT-3 series. We recommend 
using our latest GPT-3 models 
instead. Learn more. 

STRENGTHS 
Moderate classification, semantic 
search
''';
            break;
          case 'ada':
            element.description = ''' 
ada 
This model is part of our original, 
base GPT-3 series. We recommend 
using our latest GPT-3 models 
instead. Learn more. 

STRENGTHS 
Parsing text, simple classification, 
address correction, keywords
''';
            break;
          default:
            element.description = '';
            break;
        }
      }

      // modelSelectDropDown.value = responseModels.state!.first;
    }
  }

  Future<List<Map<String, dynamic>>> generateImage({required String prompt, int n = 1, String size = '512x512'}) async {
    final res = await apiCall.onRequest(
      '/images/generations',
      RequestMethod.POST,
      body: {'prompt': prompt, 'n': n, 'size': size},
    );

    return Helper.convertToListMap(res['data']);
  }
}
