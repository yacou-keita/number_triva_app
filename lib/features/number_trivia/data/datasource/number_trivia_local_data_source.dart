import 'dart:convert';

import 'package:number_triva_app/core/error/exceptions.dart';
import 'package:number_triva_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> chacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const cachedNumberTrivia = "CACHED_NUMBER_TRIVIA";

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(cachedNumberTrivia);
    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    }
    throw CacheException();
  }

  @override
  Future<void> chacheNumberTrivia(NumberTriviaModel triviaToCache)  {
   return sharedPreferences.setString(
        cachedNumberTrivia, json.encode(triviaToCache.toJson()));
  }
}
