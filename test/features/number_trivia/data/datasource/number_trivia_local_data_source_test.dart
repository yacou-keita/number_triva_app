import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_triva_app/core/error/exceptions.dart';
import 'package:number_triva_app/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:number_triva_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SharedPreferences>(),
])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group(
    'getLastNumberTrivia',
    () {
      final testNumberTriviaModel = NumberTriviaModel.fromJson(
          json.decode(fixtureReader('trivia_cached.json')));
      test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
          when(mockSharedPreferences.getString(any))
              .thenReturn(fixtureReader('trivia_cached.json'));

          final result = await dataSource.getLastNumberTrivia();
          verify(mockSharedPreferences.getString(cachedNumberTrivia));
          expect(result, equals(testNumberTriviaModel));
        },
      );
      test(
        'should throw a CacheExeption when there is not a cached value',
        () async {
          when(mockSharedPreferences.getString(any)).thenReturn(null);
          final call = dataSource.getLastNumberTrivia;
          expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
        },
      );
    },
  );

  group(
    'cacheNumberTrivia',
    () {
      const testNumberTriviaModel =
          NumberTriviaModel(number: 1, text: "test trivia");
      test(
        'schould call SharedPreferences to cache the data',
        () async {
          dataSource.chacheNumberTrivia(testNumberTriviaModel);
          final expectedJsonString = json.encode(testNumberTriviaModel.toJson());
          verify(mockSharedPreferences.setString(
              cachedNumberTrivia, expectedJsonString));
        },
      );
    },
  );
}
