import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nasa_api_app/presentation/checked_asteroids_screen.dart';
import 'package:nasa_api_app/presentation/commonWidget/image_widget.dart';
import 'package:nasa_api_app/service/api_service.dart';
import 'package:nasa_api_app/model/asteroid.dart';

class AsteroidListScreen extends StatefulWidget {
  final String title;
  const AsteroidListScreen({super.key, required this.title});

  @override
  State<AsteroidListScreen> createState() => _AsteroidListScreenState();
}

class _AsteroidListScreenState extends State<AsteroidListScreen> {
  late Future<List<Asteroid>> futureAsteroids;

  List<Asteroid> asteroids = [];

  @override
  void initState() {
    super.initState();
    futureAsteroids = ApiService().fetchAsteroids();
  }

  void toggleChecked(Asteroid asteroid) {
    setState(() {
      int index = asteroids.indexOf(asteroid);
      if (index != -1) {
        asteroids[index] =
            asteroids[index].copyWith(checked: !asteroids[index].checked);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //Todo: move to onPressed
    final checkedAsteroids =
        asteroids.where((asteroid) => asteroid.checked).toList();

    print(
        '********** build first screen checkedAsteroids length  : ${checkedAsteroids.length}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asteroid List'),
        actions: [
          TextButton.icon(
            label: const Text('Show Checked'),
            icon: const Icon(Icons.check_box),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CheckedAsteroidsScreen(
                      checkedAsteroids: checkedAsteroids,
                      updateAsteroidCheckedState: toggleChecked),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          const NetworkImageWidget(
              'https://d.newsweek.com/en/full/1043290/7-26-asteroids.jpg'),
          Center(
            child: LayoutBuilder(builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: min(constraints.maxWidth, 600),
                  child: FutureBuilder<List<Asteroid>>(
                    future: futureAsteroids,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No data available'));
                      } else {
                        asteroids = snapshot.data!;
                        return ListView.builder(
                          itemCount: asteroids.length,
                          itemBuilder: (context, index) {
                            final asteroid = asteroids[index];
                            return Card(
                              color: Colors.black54,
                              child: ListTile(
                                title: Text(asteroid.name,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                subtitle: Text(
                                    'Hazardous: ${asteroid.isHazardous ? 'Yes' : 'No'}',
                                    style:
                                        const TextStyle(color: Colors.white70)),
                                //Todo: refactor to a separate widget
                                trailing: Checkbox(
                                  activeColor: Colors.white,
                                  checkColor: Colors.black,
                                  value: asteroid.checked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      asteroids[index] = asteroid.copyWith(
                                          checked: value ?? false);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
