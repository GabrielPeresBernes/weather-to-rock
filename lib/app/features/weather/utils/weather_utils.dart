abstract final class WeatherUtils {
  static String getWeatherIcon(String? icon) {
    switch (icon) {
      case 'Clouds':
        return 'assets/icons/weather/clouds.svg';
      case 'Mist':
        return 'assets/icons/weather/mist.svg';
      case 'Rain':
        return 'assets/icons/weather/rain.svg';
      case 'Snow':
        return 'assets/icons/weather/snow.svg';
      default:
        return 'assets/icons/weather/clear.svg';
    }
  }
}
