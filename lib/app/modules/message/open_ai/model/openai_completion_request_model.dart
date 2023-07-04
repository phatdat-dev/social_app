import '../../../../core/base/base_project.dart';

class OpenAiCompletionRequest extends BaseModel<OpenAiCompletionRequest> {
  String? model;
  String? prompt;
  String? suffix;
  int? maxTokens;
  double? temperature;
  int? topP;
  int? n;
  bool? stream;
  int? logprobs;
  bool? echo;
  String? stop;
  double? presencePenalty;
  double? frequencyPenalty;
  int? bestOf;
  Map<String, dynamic>? logitBias;
  String? user;

  OpenAiCompletionRequest(
      {this.model,
      this.prompt,
      this.suffix,
      this.maxTokens,
      this.temperature,
      this.topP,
      this.n,
      this.stream,
      this.logprobs,
      this.echo,
      this.stop,
      this.presencePenalty,
      this.frequencyPenalty,
      this.bestOf,
      this.logitBias,
      this.user});

  @override
  OpenAiCompletionRequest fromJson(Map<String, dynamic> json) => OpenAiCompletionRequest(
        model: json['model'],
        prompt: json['prompt'],
        suffix: json['suffix'],
        maxTokens: (json['max_tokens'] as num?)?.toInt(),
        temperature: (json['temperature'] as num?)?.toDouble(),
        topP: (json['top_p'] as num?)?.toInt(),
        n: (json['n'] as num?)?.toInt(),
        stream: json['stream'],
        logprobs: (json['logprobs'] as num?)?.toInt(),
        echo: json['echo'],
        stop: json['stop'],
        presencePenalty: (json['presence_penalty'] as num?)?.toDouble(),
        frequencyPenalty: (json['frequency_penalty'] as num?)?.toDouble(),
        bestOf: (json['best_of'] as num?)?.toInt(),
        logitBias: json['logit_bias'],
        user: json['user'],
      );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    (model != null) ? data['model'] = model : null;
    (prompt != null) ? data['prompt'] = prompt : null;
    (suffix != null) ? data['suffix'] = suffix : null;
    (maxTokens != null) ? data['max_tokens'] = maxTokens : null;
    (temperature != null) ? data['temperature'] = temperature : null;
    (topP != null) ? data['top_p'] = topP : null;
    (n != null) ? data['n'] = n : null;
    (stream != null) ? data['stream'] = stream : null;
    (logprobs != null) ? data['logprobs'] = logprobs : null;
    (echo != null) ? data['echo'] = echo : null;
    (stop != null) ? data['stop'] = stop : null;
    (presencePenalty != null) ? data['presence_penalty'] = presencePenalty : null;
    (frequencyPenalty != null) ? data['frequency_penalty'] = frequencyPenalty : null;
    (bestOf != null) ? data['best_of'] = bestOf : null;
    (logitBias != null) ? data['logit_bias'] = logitBias : null;

    (user != null) ? data['user'] = user : null;
    return data;
  }

  OpenAiCompletionRequest copyWith({
    String? model,
    String? prompt,
    String? suffix,
    int? maxTokens,
    double? temperature,
    int? topP,
    int? n,
    bool? stream,
    int? logprobs,
    bool? echo,
    String? stop,
    double? presencePenalty,
    double? frequencyPenalty,
    int? bestOf,
    Map<String, dynamic>? logitBias,
    String? user,
  }) =>
      OpenAiCompletionRequest(
        model: model ?? this.model,
        prompt: prompt ?? this.prompt,
        suffix: suffix ?? this.suffix,
        maxTokens: maxTokens ?? this.maxTokens,
        temperature: temperature ?? this.temperature,
        topP: topP ?? this.topP,
        n: n ?? this.n,
        stream: stream ?? this.stream,
        logprobs: logprobs ?? this.logprobs,
        echo: echo ?? this.echo,
        stop: stop ?? this.stop,
        presencePenalty: presencePenalty ?? this.presencePenalty,
        frequencyPenalty: frequencyPenalty ?? this.frequencyPenalty,
        bestOf: bestOf ?? this.bestOf,
        logitBias: logitBias ?? this.logitBias,
        user: user ?? this.user,
      );
}
