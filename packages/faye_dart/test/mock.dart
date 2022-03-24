import 'package:faye_dart/src/client.dart';
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements FayeClient {
  bool operator ==(Object? other) => true;
}
