import 'package:flutter/material.dart';
import 'package:nasa_api_app/presentation/checked_asteroids_screen.dart';
import 'package:nasa_api_app/presentation/commonWidget/image_widget.dart';
import 'package:provider/provider.dart';
import 'package:nasa_api_app/providers/asteroid_provider.dart';

class AsteroidListScreen extends StatelessWidget {
  final String title;
  const AsteroidListScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const NetworkImageWidget(
            'https://d.newsweek.com/en/full/1043290/7-26-asteroids.jpg'),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            actions: [
              TextButton.icon(
                label: const Text(
                  'Show Checked',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(Icons.check_box, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckedAsteroidsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: LayoutBuilder(builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width:
                      constraints.maxWidth < 600 ? constraints.maxWidth : 600,
                  child: Consumer<AsteroidProvider>(
                    builder: (context, provider, child) {
                      return FutureBuilder(
                        future: provider.fetchAsteroids(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (provider.asteroids.isEmpty) {
                            return const Center(
                                child: Text('No data available'));
                          } else {
                            return ListView.builder(
                              itemCount: provider.asteroids.length,
                              itemBuilder: (context, index) {
                                final asteroid = provider.asteroids[index];
                                return Card(
                                  color: Colors.black54,
                                  child: ListTile(
                                    title: Text(asteroid.name,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    subtitle: Text(
                                        'Hazardous: ${asteroid.isHazardous ? 'Yes' : 'No'}',
                                        style: const TextStyle(
                                            color: Colors.white70)),
                                    trailing: Checkbox(
                                      activeColor: Colors.white,
                                      checkColor: Colors.black,
                                      value: asteroid.checked,
                                      onChanged: (bool? value) {
                                        provider.toggleChecked(asteroid);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
