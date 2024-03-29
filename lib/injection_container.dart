import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:number_triva_app/core/network/network_info.dart';
import 'package:number_triva_app/core/util/input_converter.dart';
import 'package:number_triva_app/features/number_trivia/data/datasource/number_trivia_local_data_source.dart';
import 'package:number_triva_app/features/number_trivia/data/datasource/number_trivia_remote_data_source.dart';
import 'package:number_triva_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_triva_app/features/number_trivia/domain/repositories/number_trivia.repository.dart';
import 'package:number_triva_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_triva_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number trivia
// bloc
  sl.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl()));

  // use cases
  sl.registerLazySingleton(
      () => GetTriviaForConcreteNumber(numberString: sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(repository: sl()));

  // Repository
  sl.registerLazySingleton<NumberTrivaRepository>(() =>
      NumberTriviarepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), netWorkInfo: sl()));

  //data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));

  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(internetConnectionChecker: sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(()  => sharedPreferences);
  sl.registerLazySingleton(()  => http.Client);
  sl.registerLazySingleton(()  => InternetConnectionChecker);
}
