import '../../../../core/base/base_project.dart';

class OpenAiCompletionResponse extends BaseModel<OpenAiCompletionResponse> {
  String? id;
  String? object;
  int? created;
  String? model;
  List<Choices>? choices;
  Usage? usage;

  OpenAiCompletionResponse({this.id, this.object, this.created, this.model, this.choices, this.usage});

  @override
  OpenAiCompletionResponse fromJson(Map<String, dynamic> json) => OpenAiCompletionResponse(
        id: json['id'],
        object: json['object'],
        created: (json['created'] as num?)?.toInt(),
        model: json['model'],
        choices: json['choices'] != null ? List<Choices>.from((json['choices'] as List).map((x) => Choices().fromJson(x))) : null,
        usage: json['usage'] != null ? Usage().fromJson(json['usage']) : null,
      );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    (id != null) ? data['id'] = id : null;
    (object != null) ? data['object'] = object : null;
    (created != null) ? data['created'] = created : null;
    (model != null) ? data['model'] = model : null;
    (choices != null) ? data['choices'] = choices!.map((v) => v.toJson()).toList() : null;

    (usage != null) ? data['usage'] = usage?.toJson() : null;

    return data;
  }

  OpenAiCompletionResponse copyWith({
    String? id,
    String? object,
    int? created,
    String? model,
    List<Choices>? choices,
    Usage? usage,
  }) =>
      OpenAiCompletionResponse(
        id: id ?? this.id,
        object: object ?? this.object,
        created: created ?? this.created,
        model: model ?? this.model,
        choices: choices ?? this.choices,
        usage: usage ?? this.usage,
      );
}

class Choices extends BaseModel<Choices> {
  String? text;
  int? index;
  dynamic logprobs;
  String? finishReason;

  Choices({this.text, this.index, this.logprobs, this.finishReason});

  @override
  Choices fromJson(Map<String, dynamic> json) => Choices(
        text: json['text'],
        index: (json['index'] as num?)?.toInt(),
        logprobs: json['logprobs'],
        finishReason: json['finish_reason'],
      );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    (text != null) ? data['text'] = text : null;
    (index != null) ? data['index'] = index : null;
    (logprobs != null) ? data['logprobs'] = logprobs : null;
    (finishReason != null) ? data['finish_reason'] = finishReason : null;
    return data;
  }

  Choices copyWith({
    String? text,
    int? index,
    dynamic logprobs,
    String? finishReason,
  }) =>
      Choices(
        text: text ?? this.text,
        index: index ?? this.index,
        logprobs: logprobs ?? this.logprobs,
        finishReason: finishReason ?? this.finishReason,
      );
}

class Usage extends BaseModel<Usage> {
  int? promptTokens;
  int? totalTokens;

  Usage({this.promptTokens, this.totalTokens});

  @override
  Usage fromJson(Map<String, dynamic> json) => Usage(
        promptTokens: (json['prompt_tokens'] as num?)?.toInt(),
        totalTokens: (json['total_tokens'] as num?)?.toInt(),
      );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    (promptTokens != null) ? data['prompt_tokens'] = promptTokens : null;
    (totalTokens != null) ? data['total_tokens'] = totalTokens : null;
    return data;
  }

  Usage copyWith({
    int? promptTokens,
    int? totalTokens,
  }) =>
      Usage(
        promptTokens: promptTokens ?? this.promptTokens,
        totalTokens: totalTokens ?? this.totalTokens,
      );
}
