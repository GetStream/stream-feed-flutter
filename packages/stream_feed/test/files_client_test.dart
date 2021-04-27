import 'package:dio/dio.dart';
import 'package:file/memory.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_feed/src/client/file_storage_client.dart';
import 'package:stream_feed/src/core/http/token.dart';
import 'package:stream_feed/src/core/models/attachment_file.dart';
import 'package:test/test.dart';

import 'mock.dart';

void main() {
  group('FileStorageClient', () {
    final api = MockFilesAPI();
    const token = Token('dummyToken');
    final mockFs = MockFileSystem();
    final mockFile = MockFile();

    final client = FileStorageClient(api, userToken: token, fs: mockFs);
    test('upload', () async {
      const path = '.metadata';

      const attachment = AttachmentFile(path: path);

      when(() => mockFs.file(attachment.path)).thenReturn(mockFile);
      when(() => mockFile.path).thenReturn(path);
      
      final multipart = await MultipartFile.fromFile(path);
      when(() => api.upload(token, multipart))
          .thenAnswer((invocation) async => 'whateverurl');

      await client.upload(attachment);
      verify(() => api.upload(token, multipart)).called(1);
    });

    test('refreshUrl', () async {
      const targetUrl = 'targetUrl';

      when(() => api.refreshUrl(token, targetUrl))
          .thenAnswer((invocation) async => targetUrl);

      expect(await client.refreshUrl(targetUrl), targetUrl);
      verify(() => api.refreshUrl(token, targetUrl)).called(1);
    });

    test('delete', () async {
      const targetUrl = 'targetUrl';
      when(() => api.delete(token, targetUrl)).thenAnswer((_) async => Response(
          data: {},
          requestOptions: RequestOptions(
            path: '',
          ),
          statusCode: 200));
      await client.delete(targetUrl);
      verify(() => api.delete(token, targetUrl)).called(1);
    });
  });
}
