import 'package:dartz/dartz.dart';
import 'package:number_triva_app/core/error/exceptions.dart';
import 'package:number_triva_app/core/error/failures.dart';
import 'package:number_triva_app/core/network/network_info.dart';
import 'package:number_triva_app/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:number_triva_app/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:number_triva_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_triva_app/features/number_trivia/domain/entities/number_trivia.entity.dart';
import 'package:number_triva_app/features/number_trivia/domain/repositories/number_trivia.repository.dart';

typedef Future<NumberTriviaModel> _ConcreteOrRandomChooser();

class NumberTriviarepositoryImpl implements NumberTrivaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo netWorkInfo;

  NumberTriviarepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.netWorkInfo,
  });

  @override
  Future<Either<Failure, NumberTriviaEntity>> getConreteNumberTrivia(
      int number) async {
    return _getTrivia(() => remoteDataSource.getConreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTriviaEntity>> getRandomNumberTrivia() async {
    return _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTriviaEntity>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await netWorkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.chacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    }

    try {
      final localTrivia = await localDataSource.getLastNumberTrivia();
      return Right(localTrivia);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
