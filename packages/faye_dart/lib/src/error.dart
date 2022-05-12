import 'package:faye_dart/src/grammar.dart' as grammar;

class FayeClientError {
  const FayeClientError({
    this.code,
    this.params = const [],
    required this.errorMessage,
  });

  factory FayeClientError.parse(String? errorMessage) {
    errorMessage = errorMessage ?? '';
    if (!RegExp(grammar.error).hasMatch(errorMessage)) {
      return FayeClientError(errorMessage: errorMessage);
    }

    final parts = errorMessage.split(':');
    final code = int.parse(parts[0]);
    final params = parts[1].split(',');
    final message = parts[2];

    return FayeClientError(code: code, params: params, errorMessage: message);
  }

  final int? code;
  final List<String> params;
  final String errorMessage;

  @override
  String toString() => '$code : ${params.join(',')} : $errorMessage';
}
