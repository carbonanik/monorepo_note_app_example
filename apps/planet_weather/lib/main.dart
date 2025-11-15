import 'package:flutter/material.dart';

import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const PlanetWeatherApp());
}

class PlanetWeatherApp extends StatelessWidget {
  const PlanetWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planet Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
        fontFamily: 'Orbitron',
      ),
      home: const PlanetWeatherHome(),
    );
  }
}

class PlanetWeatherHome extends StatefulWidget {
  const PlanetWeatherHome({super.key});

  @override
  State<PlanetWeatherHome> createState() => _PlanetWeatherHomeState();
}

class _PlanetWeatherHomeState extends State<PlanetWeatherHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int? selectedPlanetIndex;
  Map<String, dynamic>? earthWeather;
  bool isLoadingEarthWeather = false;

  final List<PlanetData> planets = [
    PlanetData(
      name: 'Mercury',
      temp: '430°C',
      condition: 'Scorching',
      description: 'Solar storms detected',
      color: Color(0xFF8C7853),
      icon: Icons.wb_sunny,
      details: 'No atmosphere • Extreme temperatures',
    ),
    PlanetData(
      name: 'Venus',
      temp: '462°C',
      condition: 'Sulfuric Clouds',
      description: 'Acid rain probability: 95%',
      color: Color(0xFFE89B3C),
      icon: Icons.cloud,
      details: 'Dense CO₂ atmosphere • Crushing pressure',
    ),
    PlanetData(
      name: 'Earth',
      temp: '15°C',
      condition: 'Habitable',
      description: 'Perfect for life',
      color: Color(0xFF4A90E2),
      icon: Icons.public,
      details: 'Oxygen rich • Water present',
      isEarth: true,
    ),
    PlanetData(
      name: 'Mars',
      temp: '-63°C',
      condition: 'Dust Storm',
      description: 'Colonization in progress',
      color: Color(0xFFE27B58),
      icon: Icons.landscape,
      details: 'Thin atmosphere • Ice caps present',
    ),
    PlanetData(
      name: 'Jupiter',
      temp: '-145°C',
      condition: 'Great Red Spot',
      description: 'Storm raging for 350 years',
      color: Color(0xFFD4A373),
      icon: Icons.cyclone,
      details: 'Gas giant • Powerful magnetic field',
    ),
    PlanetData(
      name: 'Saturn',
      temp: '-178°C',
      condition: 'Ring Radiation',
      description: 'Hexagonal storm at pole',
      color: Color(0xFFFAD5A5),
      icon: Icons.radio_button_unchecked,
      details: 'Beautiful rings • Low density',
    ),
    PlanetData(
      name: 'Uranus',
      temp: '-224°C',
      condition: 'Frozen Methane',
      description: 'Tilted 98° from orbit',
      color: Color(0xFF4FD1C5),
      icon: Icons.ac_unit,
      details: 'Sideways rotation • Ice giant',
    ),
    PlanetData(
      name: 'Neptune',
      temp: '-214°C',
      condition: 'Supersonic Winds',
      description: 'Fastest winds in solar system',
      color: Color(0xFF4169E1),
      icon: Icons.air,
      details: 'Dark storms • Extreme weather',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchEarthWeather() async {
    setState(() {
      isLoadingEarthWeather = true;
    });

    try {
      // Using Open-Meteo API (free, no API key required)
      // Default location: London coordinates as example
      final response = await http.get(
        Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=51.5074&longitude=-0.1278&current=temperature_2m,relative_humidity_2m,weather_code,wind_speed_10m',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          earthWeather = data['current'];
          isLoadingEarthWeather = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingEarthWeather = false;
      });
      print('Error fetching weather: $e');
    }
  }

  String getWeatherCondition(int code) {
    if (code == 0) return 'Clear';
    if (code <= 3) return 'Partly Cloudy';
    if (code <= 48) return 'Foggy';
    if (code <= 67) return 'Rainy';
    if (code <= 77) return 'Snowy';
    if (code <= 82) return 'Rain Showers';
    if (code <= 86) return 'Snow Showers';
    return 'Stormy';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: StarfieldPainter(_controller.value),
                size: Size.infinite,
              );
            },
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF6366F1).withOpacity(0.5),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(Icons.radar, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PLANET WEATHER',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..shader = LinearGradient(
                                  colors: [
                                    Color(0xFF6366F1),
                                    Color(0xFF8B5CF6),
                                    Color(0xFFEC4899),
                                  ],
                                ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                            ),
                          ),
                          Text(
                            'Solar System Monitor',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF6366F1).withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF10B981),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'LIVE',
                              style: TextStyle(
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Live Location Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      fetchEarthWeather();
                      setState(() {
                        selectedPlanetIndex = 2; // Earth index
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          // colors: [Color(0xFF10B981), Color(0xFF059669)],
                          colors: [Color(0xFF000138), Color(0xFF1C005C)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            // color: Color(0xFF10B981).withOpacity(0.3),
                            color: Color(0xFF333592).withOpacity(0.5),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'LIVE LOCATION (EARTH)',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (isLoadingEarthWeather)
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Planet Grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: planets.length,
                    itemBuilder: (context, index) {
                      final planet = planets[index];
                      final isSelected = selectedPlanetIndex == index;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPlanetIndex = index;
                            if (!planet.isEarth) {
                              earthWeather = null;
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                planet.color.withOpacity(0.3),
                                planet.color.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? planet.color
                                  : planet.color.withOpacity(0.3),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: planet.color.withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: planet.color.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        planet.icon,
                                        color: planet.color,
                                        size: 24,
                                      ),
                                    ),
                                    Spacer(),
                                    if (planet.isEarth && earthWeather != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF10B981),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          'LIVE',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  planet.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  planet.isEarth && earthWeather != null
                                      ? '${earthWeather!['temperature_2m'].round()}°C'
                                      : planet.temp,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: planet.color,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  planet.isEarth && earthWeather != null
                                      ? getWeatherCondition(
                                          earthWeather!['weather_code'],
                                        )
                                      : planet.condition,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Spacer(),
                                if (planet.isEarth && earthWeather != null)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.water_drop,
                                            size: 12,
                                            color: Colors.white.withOpacity(
                                              0.5,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${earthWeather!['relative_humidity_2m']}%',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white.withOpacity(
                                                0.5,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Icon(
                                            Icons.air,
                                            size: 12,
                                            color: Colors.white.withOpacity(
                                              0.5,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${earthWeather!['wind_speed_10m'].round()} km/h',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white.withOpacity(
                                                0.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                else
                                  Text(
                                    planet.description,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Selected Planet Details
                if (selectedPlanetIndex != null)
                  Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          planets[selectedPlanetIndex!].color.withOpacity(0.2),
                          Color(0xFF0A0E27),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: planets[selectedPlanetIndex!].color.withOpacity(
                          0.5,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: planets[selectedPlanetIndex!].color,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'PLANETARY DATA',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: planets[selectedPlanetIndex!].color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          planets[selectedPlanetIndex!].details,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlanetData {
  final String name;
  final String temp;
  final String condition;
  final String description;
  final Color color;
  final IconData icon;
  final String details;
  final bool isEarth;

  PlanetData({
    required this.name,
    required this.temp,
    required this.condition,
    required this.description,
    required this.color,
    required this.icon,
    required this.details,
    this.isEarth = false,
  });
}

class StarfieldPainter extends CustomPainter {
  final double animationValue;
  final math.Random random = math.Random(42);

  StarfieldPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (int i = 0; i < 100; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final opacity = (math.sin(animationValue * 2 * math.pi + i) + 1) / 2;

      paint.color = Colors.white.withOpacity(opacity * 0.6);
      canvas.drawCircle(Offset(x, y), random.nextDouble() * 1.5 + 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(StarfieldPainter oldDelegate) =>
      animationValue != oldDelegate.animationValue;
}
