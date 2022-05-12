import 'package:faye_dart/src/client.dart';
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements FayeClient {
  @override
  bool operator ==(Object? other) => true;

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
