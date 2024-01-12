import 'package:dartz/dartz.dart';
import 'package:number_triva_app/core/error/failures.dart';
import 'package:number_triva_app/features/number_trivia/domain/entities/number_trivia.entity.dart';

abstract class NumberTrivaRepository {
   Future<Either<Failure, NumberTriviaEntity>> getConreteNumberTrivia(int number);
   Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia();
}

