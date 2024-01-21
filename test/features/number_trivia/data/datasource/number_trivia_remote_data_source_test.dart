import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_triva_app/core/error/exceptions.dart';
import 'package:number_triva_app/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:number_triva_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockClient);
  });

  void setUpMockHttpSuccess200() {
    when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(fixtureReader('trivia.json'), 200));
  }

  void setUpMockHttpFailure404() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group(
    'getConreteNumberTrivia',
    () {
      const testNumber = 1;
      final numberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixtureReader("trivia.json")));

      test(
        '''should perform a get request on a URL with number
         being the endpoint and with application/json header''',
        () async {
          setUpMockHttpSuccess200();

          dataSource.getConreteNumberTrivia(testNumber);

          verify(await mockClient.get(Uri.parse('http://numbersapi.com/$testNumber'),
              headers: {'Content-Type': 'application/json'}));
        },
      );

      test(
        'should return NumberTrivia when the response code is 200 (success)',
        () async {
          setUpMockHttpSuccess200();

          final result = await dataSource.getConreteNumberTrivia(testNumber);

          expect(result, equals(numberTriviaModel));
        },
      );

      test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
          setUpMockHttpFailure404();

          final call = dataSource.getConreteNumberTrivia;
          expect(() => call(testNumber),
              throwsA(const TypeMatcher<ServerException>()));
        },
      );
    },
  );

  group(
    'getRandomNumberTrivia',
    () {
      final testNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixtureReader("trivia.json")));

      test(
        '''should perform a get request on a URL with number
         being the endpoint and with application/json header''',
        () async {
          setUpMockHttpSuccess200();

          dataSource.getRandomNumberTrivia();

          verify(mockClient.get(Uri.parse('http://numbersapi.com/random'),
              headers: {'Content-Type': 'application/json'}));
        },
      );

      test(
        'should return NumberTrivia when the response code is 200 (success)',
        () async {
          setUpMockHttpSuccess200();

          final result = await dataSource.getRandomNumberTrivia();

          expect(result, equals(testNumberTriviaModel));
        },
      );

      test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
          setUpMockHttpFailure404();

          final call = dataSource.getRandomNumberTrivia;
          expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
        },
      );
    },
  );
}
