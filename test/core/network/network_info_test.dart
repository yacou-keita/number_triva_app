import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:number_triva_app/core/network/network_info.dart';



import 'network_info_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<InternetConnectionChecker>(),
])


void main() {
 late  NetworkInfoImpl networkInfoImpl;
 late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(internetConnectionChecker: mockInternetConnectionChecker);
  });

  group(
    'isConnected',
    () {
      test(
        'should forward the call to InternetConnectionChecker.hasConnection',
        () async {

          final testHasConnection = Future.value(true); 
          when(mockInternetConnectionChecker.hasConnection).thenAnswer((_)  => testHasConnection );
          final result =  networkInfoImpl.isConnected;
          verify(mockInternetConnectionChecker.hasConnection);
          expect(result, testHasConnection);
        },
      );
    },
  );
}