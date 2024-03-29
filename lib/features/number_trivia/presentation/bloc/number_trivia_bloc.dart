import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_triva_app/core/error/failures.dart';
import 'package:number_triva_app/core/usecases/usecase.dart';
import 'package:number_triva_app/core/util/input_converter.dart';
import 'package:number_triva_app/features/number_trivia/domain/entities/number_trivia.entity.dart';
import 'package:number_triva_app/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_triva_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = "Server failure";
const String cacheFailureMessage = "Cache failure";
const String invalidInputFailureMessage =
    "Invalid Input - The number must be a positive integer or zero";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  NumberTriviaState get initialState => Empty();

  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty()) {
    
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumberEvent);
    on<GetTriviaForRandonNumber>(_onGetTriviaForRandonNumberEvent);
  }



  Future<void> _onGetTriviaForConcreteNumberEvent(event, emit) async {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);

    emit(Empty());

    inputEither.fold((failure) {
      emit(const Error(message: invalidInputFailureMessage));
    }, (integer) async {
      emit(Loading());
      final failureOrTrivia =
          await getConcreteNumberTrivia(Params(number: integer));
      _eitherLoadedOrErrorState(failureOrTrivia, emit);
    });
  }

  Future<void> _onGetTriviaForRandonNumberEvent(event, emit) async {
    emit(Empty());
    emit(Loading());
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    _eitherLoadedOrErrorState(failureOrTrivia, emit);
  }

  void _eitherLoadedOrErrorState(
      Either<Failure, NumberTriviaEntity> failureOrTrivia, emit) {
    failureOrTrivia.fold(
        (failure) => emit(Error(message: _mapFailureToMessage(failure))),
        (trivia) => emit(Loaded(trivia: trivia)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return "Unexpected error";
    }
  }
}
