import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_triva_app/core/error/failures.dart';
import 'package:number_triva_app/core/usecases/usecase.dart';
import 'package:number_triva_app/features/number_trivia/domain/entities/number_trivia.entity.dart';
import 'package:number_triva_app/features/number_trivia/domain/repositories/number_trivia.repository.dart';

class GetConcreteNumberTrivia implements Usecase<NumberTriviaEntity, Params> {
  final NumberTrivaRepository repository;

  GetConcreteNumberTrivia({required this.repository});

  @override
  Future<Either<Failure, NumberTriviaEntity>> call(Params params) async {
    return await repository.getConreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
