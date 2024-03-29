import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_triva_app/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group(
    'stringToUnsignedInteger',
    () {
      test(
        'should return a integer when the string represents an unsigned integer',
        () async {
          String string = "123";
          final result = inputConverter.stringToUnsignedInteger(string);
          expect(result, const Right(123));
        },
      );
      test(
        'should return a failure when the string is not an integer',
        () async {
          String string = "abc";
          final result = inputConverter.stringToUnsignedInteger(string);
          expect(result, Left(InvalidInputFailure()));
        },
      );
      test(
        'should return a failure when the string is a negative integer',
        () async {
          String string = "-123";
          final result = inputConverter.stringToUnsignedInteger(string);
          expect(result, Left(InvalidInputFailure()));
        },
      );
    },
  );
}
