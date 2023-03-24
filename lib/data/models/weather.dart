import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String cityName;
  final double temperatureCelcius;
  final double? temperatureFahrenheit;

  const Weather({
    required this.cityName,
    required this.temperatureCelcius,
    this.temperatureFahrenheit, // Celcius * 1.8 + 32
  });

  @override
  List<Object?> get props => [
        cityName,
        temperatureCelcius,
        temperatureFahrenheit,
      ];
}
