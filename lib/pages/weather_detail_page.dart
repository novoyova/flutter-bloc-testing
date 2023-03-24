import 'package:bloc_testing/bloc/weather_bloc.dart';
import 'package:bloc_testing/data/models/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherDetailPage extends StatefulWidget {
  final Weather masterWeather;

  const WeatherDetailPage({
    super.key,
    required this.masterWeather,
  });

  @override
  State<WeatherDetailPage> createState() => _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // To initiate getting the detailed weather,
    // we will also need to add an event to the bloc
    // The best time to add an event to the bloc is ASAP

    // Inside didChangeDependencies function,
    // we will still immediately add an event to the bloc,
    // when weather detail page is created by navigating to it,
    // but it is not going to call it multiple times when the UI is rebuild
    BlocProvider.of<WeatherBloc>(context)
        .add(GetDetailedWeather(widget.masterWeather.cityName));
  }

  // build: should not contain anything else, than the building of widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Detail'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return buildLoading();
            } else if (state is WeatherLoaded) {
              return buildColumnWithData(context, state.weather);
            } else {
              return const Text('Something went wrong');
            }
          },
        ),
      ),
    );
  }

  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(BuildContext context, Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          weather.cityName,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the Celcius temperature with 1 decimal place
          '${weather.temperatureCelcius.toStringAsFixed(1)} °C',
          style: const TextStyle(
            fontSize: 80,
          ),
        ),
        Text(
          // Display the Fahrenheit temperature with 1 decimal place
          '${weather.temperatureFahrenheit?.toStringAsFixed(1)} °F',
          style: const TextStyle(
            fontSize: 80,
          ),
        ),
      ],
    );
  }
}
