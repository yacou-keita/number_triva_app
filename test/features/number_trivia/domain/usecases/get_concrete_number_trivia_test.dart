import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:number_triva_app/features/number_trivia/domain/entities/number_trivia.entity.dart';
import 'package:number_triva_app/features/number_trivia/domain/repositories/number_trivia.repository.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_triva_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';



@GenerateNiceMocks([MockSpec<NumberTrivaRepository>()])


void main(){
 late GetConcreteNumberTrivia usecase;
 late MockNumberTrivaRepository mockNumberTriviaRepository;

  setUp(() {
      mockNumberTriviaRepository = MockNumberTrivaRepository();
      usecase = GetConcreteNumberTrivia(repository: mockNumberTriviaRepository);
  });

  const int testNumber = 1;
  const testNumberTrivia = NumberTriviaEntity(text: 'test',number: 1);

  test("should  get trivia for the number from the repository", () async {
    
    when(mockNumberTriviaRepository.getConreteNumberTrivia(any))
      .thenAnswer((_) async => const Right(testNumberTrivia));

    final result = await usecase(const Params(number: testNumber));

    expect(result, const Right(testNumberTrivia));
    verify(mockNumberTriviaRepository.getConreteNumberTrivia(testNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);

  });


}