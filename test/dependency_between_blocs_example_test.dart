import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_testing/bloc/weather_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

void main() {
  late MockWeatherBloc mockWeatherBloc;

  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
  });

  // Using async* will not show error when it is wrong
  // instead modify mockWeatherBloc.state to mockWeatherBloc.stream
  test(
    'Example mocked BloC test',
    () {
      // Arrange
      // Tell mockBloc which states it should output
      whenListen(
        mockWeatherBloc,
        Stream.fromIterable([
          const WeatherInitial(),
          const WeatherLoading(),
        ]),
      );
      // Assert
      expectLater(
        mockWeatherBloc.stream,
        emitsInOrder([
          const WeatherInitial(),
          const WeatherLoading(),
        ]),
      );
    },
  );
}
