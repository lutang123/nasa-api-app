import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nasa_api_app/model/asteroid.dart';
import 'package:nasa_api_app/presentation/commonWidget/image_widget.dart';

class CheckedAsteroidsScreen extends StatefulWidget {
  final List<Asteroid> checkedAsteroids;

  const CheckedAsteroidsScreen({super.key, required this.checkedAsteroids});

  @override
  State<CheckedAsteroidsScreen> createState() => _CheckedAsteroidsScreenState();
}

class _CheckedAsteroidsScreenState extends State<CheckedAsteroidsScreen> {
  void toggleCheck(int index) {
    setState(() {
      widget.checkedAsteroids[index] = widget.checkedAsteroids[index]
          .copyWith(checked: !widget.checkedAsteroids[index].checked);
    });
  }

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
            body: Stack(
              children: [
                Center(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: min(constraints.maxWidth, 600),
                        child: ListView.builder(
                          itemCount: widget.checkedAsteroids.length,
                          itemBuilder: (context, index) {
                            final asteroid = widget.checkedAsteroids[index];
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
                                trailing: Checkbox(
                                  activeColor: Colors.white,
                                  checkColor: Colors.black,
                                  value: asteroid.checked,
                                  onChanged: (bool? value) {
                                    toggleCheck(index);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ],
            )

            // ListView.builder(
            //   itemCount: checkedAsteroids.length,
            //   itemBuilder: (context, index) {
            //     final asteroid = checkedAsteroids[index];
            //     return ListTile(
            //       title: Text(asteroid.name),
            //       subtitle: Text('Hazardous: ${asteroid.isHazardous ? 'Yes' : 'No'}'),
            //     );
            //   },
            // ),
            ),
      ],
    );
  }
}
