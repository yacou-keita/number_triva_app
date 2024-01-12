import 'package:number_triva_app/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConreteNumberTrivia(int number);
   Future<NumberTriviaModel> getRandomNumberTrivia();
}