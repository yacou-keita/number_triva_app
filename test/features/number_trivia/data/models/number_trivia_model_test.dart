import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_triva_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_triva_app/features/number_trivia/domain/entities/number_trivia.entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const testNumberTriviaModel = NumberTriviaModel(number: 1, text: "test Text");

  test(
    'should be a subclass of NumberTriviaEntity',
    () async {
      expect(testNumberTriviaModel, isA<NumberTriviaEntity>());
    },
  );

  group(
    'fromJson',
    () {
      test(
        'shoul return a valid model when the JSON number is an integer',
        () async {
          final Map<String, dynamic> jsonMap =
              json.decode(fixtureReader("trivia.json"));
          final result = NumberTriviaModel.fromJson(jsonMap);
          expect(result, testNumberTriviaModel);
        },
      );

      test(
        'shoul return a valid model when the JSON number is regarder as a double',
        () async {
          final Map<String, dynamic> jsonMap =
              json.decode(fixtureReader("trivia_double.json"));
          final result = NumberTriviaModel.fromJson(jsonMap);
          expect(result, testNumberTriviaModel);
        },
      );
    },
  );

  group(
    'toJson',
    () {
      test(
        'should return a JSON map containing the proper data ',
        () async {
          final result = testNumberTriviaModel.toJson();
          const expectedMap = {
            "text": "test Text",
            "number": 1.0,
          };
          expect(result, expectedMap);
        },
      );
    },
  );
}
