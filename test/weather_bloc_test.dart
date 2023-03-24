import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_testing/bloc/weather_bloc.dart';
import 'package:bloc_testing/data/models/weather.dart';
import 'package:bloc_testing/data/weather_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// NEW WAY
class MockWeatherRepository extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherRepository {}

void main() {
  late WeatherBloc weatherBloc;
  late MockWeatherRepository mockWeatherRepository;

  // In general, you should prefer setUp, and
  // only use setUpAll if the callback is prohibitively slow.
  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    weatherBloc = WeatherBloc(mockWeatherRepository);
  });

  group('GetWeather', () {
    const weatherTest = Weather(
      cityName: 'Bali',
      temperatureCelcius: 30.0,
    );

    // The OLD WAY using [mocktail] need to use async*
    // using async* will not show error when it is wrong
    // instead modify weatherBloc to weatherBloc.stream in expectLater
    test(
      'OLD WAY emits [WeatherLoading, WeatherLoaded] when successful',
      () {
        // Arrange
        when(() => mockWeatherRepository.fetchWeather(any()))
            .thenAnswer((_) async => weatherTest);
        // Act
        weatherBloc.add(const GetWeather('Bali'));
        // Assert
        expectLater(
          weatherBloc.stream,
          emitsInOrder([
            // const WeatherInitial(),
            const WeatherLoading(),
            const WeatherLoaded(weatherTest),
          ]),
        );
      },
    );

    // The NEW WAY using [mocktail] and [blocTest]
    blocTest(
      'emits [WeatherLoading, WeatherLoaded] when successful',
      build: () {
        // Need to delcare return value, otherwise will get Null type error
        when(() => mockWeatherRepository.fetchWeather(any()))
            .thenAnswer((_) async => weatherTest);
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const GetWeather('Bali')),
      expect: () => [
        // From bloc v8 the Initial State already included automatically
        // const WeatherInitial(),
        const WeatherLoading(),
        const WeatherLoaded(weatherTest),
      ],
    );

    blocTest(
      'emits [WeatherLoading, WeatherError] when unsuccessful',
      build: () {
        // Need to delcare return value, otherwise will get Null type error
        when(() => mockWeatherRepository.fetchWeather(any()))
            .thenThrow(NetworkError());
        return weatherBloc;
      },
      act: (bloc) => bloc.add(const GetWeather('Bali')),
      expect: () => [
        // From bloc v8 the Initial State already included automatically
        // const WeatherInitial(),
        const WeatherLoading(),
        const WeatherError('Couldn\'t fetch weather'),
      ],
    );
  });
}
