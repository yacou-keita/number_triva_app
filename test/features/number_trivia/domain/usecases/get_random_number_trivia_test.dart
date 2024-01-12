import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_triva_app/core/usecases/usecase.dart';
import 'package:number_triva_app/features/number_trivia/domain/entities/number_trivia.entity.dart';
import 'package:number_triva_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';




void main(){

 late MockNumberTrivaRepository mockNumberTriviaRepository;
 late GetRandomNumberTrivia usecase; 

 setUp(() {
  mockNumberTriviaRepository = MockNumberTrivaRepository();
  usecase = GetRandomNumberTrivia(repository: mockNumberTriviaRepository);
 });

const testNumberTrivia =  NumberTriviaEntity(text: 'test', number: 1);

test(
  'should get trivia form the repository', () async {
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
    .thenAnswer((_) async => const Right(testNumberTrivia));

    final result = await usecase(NoParams());

    expect(result, const Right(testNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());

  });

}