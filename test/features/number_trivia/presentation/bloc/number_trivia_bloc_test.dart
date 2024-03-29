import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_triva_app/core/error/failures.dart';
import 'package:number_triva_app/core/usecases/usecase.dart';
import 'package:number_triva_app/core/util/input_converter.dart';
import 'package:number_triva_app/features/number_trivia/domain/entities/number_trivia.entity.dart';
import 'package:number_triva_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_triva_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_triva_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetConcreteNumberTrivia>(),
  MockSpec<GetRandomNumberTrivia>(),
  MockSpec<InputConverter>(),
])
void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaBloc bloc;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test(
    'initialState should be Empty',
    () async {
      expect(bloc.initialState, equals(Empty()));
    },
  );

  group(
    'getTriviaForConcreteNumber',
    () {
      const testNumberString = '1';
      const testNumberParsed = 1;
      const testNumberTriviaEntity =
          NumberTriviaEntity(text: "test text", number: 1);

      void setUpMockinputConverterSuccess() =>
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(const Right(testNumberParsed));
      test(
        'should call the InputConverter to validate and convert the string to unsigned integer',
        () async {
          setUpMockinputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => const Right(testNumberTriviaEntity));
          bloc.add(
              const GetTriviaForConcreteNumber(numberString: testNumberString));
          await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
          verify(mockInputConverter.stringToUnsignedInteger(testNumberString));
        },
      );

      test(
        'should emit [Empty, Error] when the input is invalid',
        () async {
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Left(InvalidInputFailure()));

          final expected = [
            Empty(),
            const Error(message: invalidInputFailureMessage)
          ];

          bloc.add(
              const GetTriviaForConcreteNumber(numberString: testNumberString));

          expectLater(bloc.stream, emitsInOrder(expected));
        },
      );

      test(
        'should get data from the concrete use case',
        () async {
          setUpMockinputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => const Right(testNumberTriviaEntity));

          bloc.add(
              const GetTriviaForConcreteNumber(numberString: testNumberString));
          await untilCalled(mockGetConcreteNumberTrivia(any));

          verify(mockGetConcreteNumberTrivia(
              const Params(number: testNumberParsed)));
        },
      );

      test(
        'should emit [Empty, loading, loaded] when data is gotten successfully',
        () async {
          setUpMockinputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => const Right(testNumberTriviaEntity));

          bloc.add(
              const GetTriviaForConcreteNumber(numberString: testNumberString));

          final expected = [
            Empty(),
            Loading(),
            const Loaded(trivia: testNumberTriviaEntity)
          ];

          expectLater(bloc.stream, emitsInOrder(expected));
        },
      );

      test(
        'should emit [Empty, loading, Error] when getting fails',
        () async {
          setUpMockinputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));

          bloc.add(
              const GetTriviaForConcreteNumber(numberString: testNumberString));

          final expected = [
            Empty(),
            Loading(),
            const Error(message: serverFailureMessage)
          ];

          expectLater(bloc.stream, emitsInOrder(expected));
        },
      );
    },
  );

  group(
    'getTriviaForRandomNumber',
    () {
      const testNumberTriviaEntity =
          NumberTriviaEntity(text: "test text", number: 1);

      test(
        'should get data from the random use case',
        () async {
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => const Right(testNumberTriviaEntity));

          bloc.add(GetTriviaForRandonNumber());
          await untilCalled(mockGetRandomNumberTrivia(any));

          verify(mockGetRandomNumberTrivia(NoParams()));
        },
      );

      test(
        'should emit [Empty, loading, loaded] when data is gotten successfully',
        () async {
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => const Right(testNumberTriviaEntity));

          bloc.add(GetTriviaForRandonNumber());

          final expected = [
            Empty(),
            Loading(),
            const Loaded(trivia: testNumberTriviaEntity)
          ];

          expectLater(bloc.stream, emitsInOrder(expected));
        },
      );

      test(
        'should emit [Empty, loading, Error] when getting fails',
        () async {
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));

          bloc.add(GetTriviaForRandonNumber());

          final expected = [
            Empty(),
            Loading(),
            const Error(message: serverFailureMessage)
          ];

          expectLater(bloc.stream, emitsInOrder(expected));
        },
      );
    },
  );
}
