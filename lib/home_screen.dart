import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/models/forecast_item.dart';
import 'package:weatherapp/models/weather_description.dart';
import 'package:weatherapp/models/weather_response.dart';
import 'package:weatherapp/weather_api.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final WeatherApi _api = WeatherApi();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  late Future<WeatherResponse> _weatherFuture;
  String? _activeCityQuery;

  static const _gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xff4480c6), Color(0xff37489b)],
  );

  @override
  void initState() {
    super.initState();
    _weatherFuture = _api.fetchByCoordinates();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      final query = _activeCityQuery;
      _weatherFuture = (query != null && query.isNotEmpty)
          ? _api.fetchByCity(query)
          : _api.fetchByCoordinates();
    });
  }

  void _search() {
    final query = _searchController.text.trim();
    _searchFocus.unfocus();
    setState(() {
      _activeCityQuery = query.isEmpty ? null : query;
      _weatherFuture = query.isEmpty
          ? _api.fetchByCoordinates()
          : _api.fetchByCity(query);
    });
  }

  Future<void> _onRefresh() async {
    final future = (_activeCityQuery != null && _activeCityQuery!.isNotEmpty)
        ? _api.fetchByCity(_activeCityQuery!)
        : _api.fetchByCoordinates();
    setState(() => _weatherFuture = future);
    try {
      await future;
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: _gradient),
        child: SafeArea(
          child: FutureBuilder<WeatherResponse>(
            future: _weatherFuture,
            builder: (context, snapshot) {
              return RefreshIndicator(
                color: Colors.deepOrange,
                backgroundColor: Colors.white,
                onRefresh: _onRefresh,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                      sliver: SliverToBoxAdapter(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: Column(
                              children: [
                                _SearchBar(
                                  controller: _searchController,
                                  focusNode: _searchFocus,
                                  onSearch: _search,
                                ),
                                const SizedBox(height: 28),
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                  const _LoadingView()
                                else if (snapshot.hasError)
                                  _ErrorView(
                                    message: snapshot.error.toString(),
                                    onRetry: _reload,
                                  )
                                else if (!snapshot.hasData ||
                                    snapshot.data!.list.isEmpty)
                                  _ErrorView(
                                    message: 'No weather data available.',
                                    onRetry: _reload,
                                  )
                                else
                                  _WeatherContent(weather: snapshot.data!),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onSearch,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearch(),
              style: const TextStyle(color: Colors.black87),
              decoration: const InputDecoration(
                hintText: 'Search city',
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                isDense: true,
              ),
            ),
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          height: 48,
          child: Material(
            color: Colors.deepOrange,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: InkWell(
              onTap: onSearch,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 320,
      child: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, color: Colors.white70, size: 48),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                ),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherContent extends StatelessWidget {
  const _WeatherContent({required this.weather});

  final WeatherResponse weather;

  @override
  Widget build(BuildContext context) {
    final current = weather.list.first;
    final details = current.main;
    final description = current.primaryWeather;
    final daily = weather.dailyForecasts;
    final range = weather.temperatureRangeForDay(current.dayKey);

    return Column(
      children: [
        Text(
          weather.city.displayName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _capitalize(description?.description ?? 'No description'),
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        _WeatherIcon(description: description, size: 100),
        Text(
          _formatTemp(details.temp),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 64,
            fontWeight: FontWeight.w300,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'H: ${_formatTemp(range.max ?? details.tempMax)}  L: ${_formatTemp(range.min ?? details.tempMin)}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 28),
        _DetailsRow(
          feelsLike: details.feelsLike,
          humidity: details.humidity,
          windSpeed: current.wind.speed,
        ),
        const SizedBox(height: 32),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '5-Day Forecast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (daily.isEmpty)
          const Text(
            'Forecast unavailable.',
            style: TextStyle(color: Colors.white70),
          )
        else
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: daily.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _DayForecastTile(item: daily[index]);
              },
            ),
          ),
      ],
    );
  }

  static String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }
}

class _DetailsRow extends StatelessWidget {
  const _DetailsRow({
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
  });

  final double? feelsLike;
  final int? humidity;
  final double? windSpeed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DetailItem(
            label: 'Feels like',
            value: _formatTemp(feelsLike),
          ),
        ),
        Expanded(
          child: _DetailItem(
            label: 'Humidity',
            value: humidity == null ? '--' : '$humidity%',
          ),
        ),
        Expanded(
          child: _DetailItem(
            label: 'Wind',
            value: windSpeed == null
                ? '--'
                : '${windSpeed!.toStringAsFixed(1)} m/s',
          ),
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DayForecastTile extends StatelessWidget {
  const _DayForecastTile({required this.item});

  final ForecastItem item;

  @override
  Widget build(BuildContext context) {
    final date = item.dateTime ?? DateTime.now();
    final weekday = DateFormat.E().format(date);

    return Container(
      width: 88,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weekday,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _WeatherIcon(description: item.primaryWeather, size: 42),
          const SizedBox(height: 8),
          Text(
            _formatTemp(item.main.temp),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _WeatherIcon extends StatelessWidget {
  const _WeatherIcon({
    required this.description,
    required this.size,
  });

  final WeatherDescription? description;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      _iconForCode(description?.icon),
      color: Colors.white,
      size: size * 0.7,
    );
  }

  static IconData _iconForCode(String? code) {
    if (code == null || code.length < 2) return Icons.wb_cloudy;

    final isNight = code.endsWith('n');
    switch (code.substring(0, 2)) {
      case '01':
        return isNight ? Icons.nights_stay : Icons.wb_sunny;
      case '02':
        return Icons.wb_cloudy;
      case '03':
      case '04':
        return Icons.cloud;
      case '09':
        return Icons.grain;
      case '10':
        return Icons.umbrella;
      case '11':
        return Icons.thunderstorm;
      case '13':
        return Icons.ac_unit;
      case '50':
        return Icons.blur_on;
      default:
        return Icons.wb_cloudy;
    }
  }
}

String _formatTemp(double? temp) {
  if (temp == null) return '--';
  return '${temp.round()}°';
}
