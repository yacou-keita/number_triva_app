import 'package:dartz/dartz.dart';
import 'package:number_triva_app/core/error/failures.dart';
import 'package:number_triva_app/core/usecases/usecase.dart';
import 'package:number_triva_app/features/number_trivia/domain/entities/number_trivia.entity.dart';
import 'package:number_triva_app/features/number_trivia/domain/repositories/number_trivia.repository.dart';

class GetRandomNumberTrivia implements Usecase<NumberTriviaEntity,NoParams>{
  final NumberTrivaRepository repository;

  GetRandomNumberTrivia({required this.repository});

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
