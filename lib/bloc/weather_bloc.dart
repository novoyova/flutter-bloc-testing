import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_testing/data/models/weather.dart';
import 'package:bloc_testing/data/weather_repository.dart';
import 'package:equatable/equatable.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository) : super(const WeatherInitial()) {
    on<GetWeather>(_onGetWeather);
    on<GetDetailedWeather>(_onGetDetailedWeather);
  }

  void _onGetWeather(GetWeather event, Emitter<WeatherState> emit) async {
    emit(const WeatherLoading());

    try {
      final weather = await weatherRepository.fetchWeather(event.cityName);
      emit(WeatherLoaded(weather));
    } on NetworkError {
      emit(const WeatherError('Couldn\'t fetch weather'));
    }
  }

  void _onGetDetailedWeather(
      GetDetailedWeather event, Emitter<WeatherState> emit) async {
    emit(const WeatherLoading());

    try {
      final weather =
          await weatherRepository.fetchDetailedWeather(event.cityName);
      emit(WeatherLoaded(weather));
    } on NetworkError {
      emit(const WeatherError('Couldn\'t fetch weather'));
    }
  }
}
