import 'dart:convert';
import 'dart:math';

import '../get_utils.dart';

extension StringExtension on String {
  // bool get isEmail => RegExp(r'\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*').hasMatch(this);
  bool get isHexColor => RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(this);

  int toInt() => int.tryParse(replaceAll(',', '')) ?? 0;

  double toDouble() => double.tryParse(replaceAll(',', '')) ?? 0;

  num? toNumber() => num.tryParse(replaceAll(',', ''));
  //random String
  static String randomString(int length) {
    var random = Random();
    var values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64UrlEncode(values);
  }

  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');

  // from GetX
  bool get isNum => GetUtils.isNum(this);

  bool get isNumericOnly => GetUtils.isNumericOnly(this);

  bool get isAlphabetOnly => GetUtils.isAlphabetOnly(this);

  bool get isBool => GetUtils.isBool(this);

  bool get isVectorFileName => GetUtils.isVector(this);

  bool get isImageFileName => GetUtils.isImage(this);

  bool get isAudioFileName => GetUtils.isAudio(this);

  bool get isVideoFileName => GetUtils.isVideo(this);

  bool get isTxtFileName => GetUtils.isTxt(this);

  bool get isDocumentFileName => GetUtils.isWord(this);

  bool get isExcelFileName => GetUtils.isExcel(this);

  bool get isPPTFileName => GetUtils.isPPT(this);

  bool get isAPKFileName => GetUtils.isAPK(this);

  bool get isPDFFileName => GetUtils.isPDF(this);

  bool get isHTMLFileName => GetUtils.isHTML(this);

  bool get isURL => GetUtils.isURL(this);

  bool get isEmail => GetUtils.isEmail(this);

  bool get isPhoneNumber => GetUtils.isPhoneNumber(this);

  bool get isDateTime => GetUtils.isDateTime(this);

  bool get isMD5 => GetUtils.isMD5(this);

  bool get isSHA1 => GetUtils.isSHA1(this);

  bool get isSHA256 => GetUtils.isSHA256(this);

  bool get isBinary => GetUtils.isBinary(this);

  bool get isIPv4 => GetUtils.isIPv4(this);

  bool get isIPv6 => GetUtils.isIPv6(this);

  bool get isHexadecimal => GetUtils.isHexadecimal(this);

  bool get isPalindrom => GetUtils.isPalindrom(this);

  bool get isPassport => GetUtils.isPassport(this);

  bool get isCurrency => GetUtils.isCurrency(this);

  bool get isCpf => GetUtils.isCpf(this);

  bool get isCnpj => GetUtils.isCnpj(this);

  bool isCaseInsensitiveContains(String b) => GetUtils.isCaseInsensitiveContains(this, b);

  bool isCaseInsensitiveContainsAny(String b) => GetUtils.isCaseInsensitiveContainsAny(this, b);

  String? get capitalize => GetUtils.capitalize(this);

  String? get capitalizeFirst => GetUtils.capitalizeFirst(this);

  String get removeAllWhitespace => GetUtils.removeAllWhitespace(this);

  String? get camelCase => GetUtils.camelCase(this);

  String? get paramCase => GetUtils.paramCase(this);

  String numericOnly({bool firstWordOnly = false}) => GetUtils.numericOnly(this, firstWordOnly: firstWordOnly);

  String createPath([Iterable? segments]) {
    final path = startsWith('/') ? this : '/$this';
    return GetUtils.createPath(path, segments);
  }
}
