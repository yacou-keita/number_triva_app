import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_triva_app/core/error/exceptions.dart';
import 'package:number_triva_app/core/error/failures.dart';
import 'package:number_triva_app/core/network/network_info.dart';
import 'package:number_triva_app/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:number_triva_app/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:number_triva_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_triva_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_triva_app/features/number_trivia/domain/entities/number_trivia.entity.dart';
import 'package:mockito/annotations.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<NumberTriviaRemoteDataSource>(),
  MockSpec<NumberTriviaLocalDataSource>(),
  MockSpec<NetworkInfo>()
])
void main() {
  late MockNumberTriviaRemoteDataSource mockRemonteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetWorkInfo;
  late NumberTriviarepositoryImpl repository;

  setUp(() {
    mockRemonteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetWorkInfo = MockNetworkInfo();
    repository = NumberTriviarepositoryImpl(
        remoteDataSource: mockRemonteDataSource,
        localDataSource: mockLocalDataSource,
        netWorkInfo: mockNetWorkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetWorkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group(
    'getConcreteNumberTriva',
    () {
      const int testNumber = 1;
      const testNumberTriviaModel =
          NumberTriviaModel(text: "test trivia", number: testNumber);
      const NumberTriviaEntity testNumberTriviaEntity = testNumberTriviaModel;
      test(
        'should check is the divice is online',
        () async {
          when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
          repository.getConreteNumberTrivia(testNumber);
          verify(mockNetWorkInfo.isConnected);
        },
      );

      runTestsOnline(
        () {
          test(
            'should return remote data when the call to remote data source is successful',
            () async {
              when(mockRemonteDataSource.getConreteNumberTrivia(any))
                  .thenAnswer((_) async => testNumberTriviaModel);

              final result =
                  await repository.getConreteNumberTrivia(testNumber);

              verify(mockRemonteDataSource.getConreteNumberTrivia(testNumber));

              expect(result, equals(const Right(testNumberTriviaEntity)));
            },
          );

          test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
              when(mockRemonteDataSource.getConreteNumberTrivia(any))
                  .thenAnswer((_) async => testNumberTriviaModel);

              await repository.getConreteNumberTrivia(testNumber);

              verify(mockRemonteDataSource.getConreteNumberTrivia(testNumber));
              verify(mockLocalDataSource
                  .chacheNumberTrivia(testNumberTriviaModel));
            },
          );

          test(
            'should return server failure when the call to remote data source is unsuccessful',
            () async {
              when(mockRemonteDataSource.getConreteNumberTrivia(any))
                  .thenThrow(ServerException());

              final result =
                  await repository.getConreteNumberTrivia(testNumber);

              verify(mockRemonteDataSource.getConreteNumberTrivia(testNumber));
              verifyZeroInteractions(mockLocalDataSource);
              expect(result, equals(Left(ServerFailure())));
            },
          );
        },
      );

      runTestsOffline(
        () {
          test(
            'should return last locally cached data when the cached data is present',
            () async {
              when(mockLocalDataSource.getLastNumberTrivia())
                  .thenAnswer((_) async => testNumberTriviaModel);

              final result =
                  await repository.getConreteNumberTrivia(testNumber);
              verifyZeroInteractions(mockRemonteDataSource);
              verify(mockLocalDataSource.getLastNumberTrivia());
              expect(result, const Right(testNumberTriviaModel));
            },
          );

          test(
            'should return CacheFailure when there is no cached data present',
            () async {
              when(mockLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());

              final result =
                  await repository.getConreteNumberTrivia(testNumber);
              verifyZeroInteractions(mockRemonteDataSource);
              verify(mockLocalDataSource.getLastNumberTrivia());
              expect(result, Left(CacheFailure()));
            },
          );
        },
      );
    },
  );

  group(
    'getRandomNumberTriva',
    () {
      const testNumberTriviaModel =
          NumberTriviaModel(text: "test trivia", number: 123);
      const NumberTriviaEntity testNumberTriviaEntity = testNumberTriviaModel;
      test(
        'should check is the divice is online',
        () async {
          when(mockNetWorkInfo.isConnected).thenAnswer((_) async => true);
          repository.getRandomNumberTrivia();
          verify(mockNetWorkInfo.isConnected);
        },
      );

      runTestsOnline(
        () {
          test(
            'should return remote data when the call to remote data source is successful',
            () async {
              when(mockRemonteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => testNumberTriviaModel);

              final result = await repository.getRandomNumberTrivia();

              verify(mockRemonteDataSource.getRandomNumberTrivia());

              expect(result, equals(const Right(testNumberTriviaEntity)));
            },
          );

          test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
              when(mockRemonteDataSource.getRandomNumberTrivia())
                  .thenAnswer((_) async => testNumberTriviaModel);

              await repository.getRandomNumberTrivia();

              verify(mockRemonteDataSource.getRandomNumberTrivia());
              verify(mockLocalDataSource
                  .chacheNumberTrivia(testNumberTriviaModel));
            },
          );

          test(
            'should return server failure when the call to remote data source is unsuccessful',
            () async {
              when(mockRemonteDataSource.getRandomNumberTrivia())
                  .thenThrow(ServerException());

              final result = await repository.getRandomNumberTrivia();

              verify(mockRemonteDataSource.getRandomNumberTrivia());
              verifyZeroInteractions(mockLocalDataSource);
              expect(result, equals(Left(ServerFailure())));
            },
          );
        },
      );

      runTestsOffline(
        () {
          test(
            'should return last locally cached data when the cached data is present',
            () async {
              when(mockLocalDataSource.getLastNumberTrivia())
                  .thenAnswer((_) async => testNumberTriviaModel);

              final result = await repository.getRandomNumberTrivia();
              verifyZeroInteractions(mockRemonteDataSource);
              verify(mockLocalDataSource.getLastNumberTrivia());
              expect(result, const Right(testNumberTriviaModel));
            },
          );

          test(
            'should return CacheFailure when there is no cached data present',
            () async {
              when(mockLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());

              final result = await repository.getRandomNumberTrivia();
              verifyZeroInteractions(mockRemonteDataSource);
              verify(mockLocalDataSource.getLastNumberTrivia());
              expect(result, Left(CacheFailure()));
            },
          );
        },
      );
    },
  );
}
