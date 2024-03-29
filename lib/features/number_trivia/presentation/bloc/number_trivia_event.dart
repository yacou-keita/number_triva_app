part of 'number_trivia_bloc.dart';

sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  const GetTriviaForConcreteNumber({required this.numberString});
}

class GetTriviaForRandonNumber extends NumberTriviaEvent {}
