import 'package:flutter/material.dart';
import 'package:nasa_api_app/presentation/commonWidget/image_widget.dart';
import 'package:provider/provider.dart';
import 'package:nasa_api_app/providers/asteroid_provider.dart';

class CheckedAsteroidsScreen extends StatelessWidget {
  const CheckedAsteroidsScreen({super.key});

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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Checked Asteroids',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
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
                      final checkedAsteroids = provider.checkedAsteroids;
                      if (checkedAsteroids.isEmpty) {
                        return const Center(
                            child: Text('No checked asteroids'));
                      }
                      return ListView.builder(
                        itemCount: checkedAsteroids.length,
                        itemBuilder: (context, index) {
                          final asteroid = checkedAsteroids[index];
                          return Card(
                            color: Colors.black54,
                            child: ListTile(
                              title: Text(asteroid.name,
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(
                                  'Hazardous: ${asteroid.isHazardous ? 'Yes' : 'No'}',
                                  style:
                                      const TextStyle(color: Colors.white70)),
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
