import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nasa_api_app/model/asteroid.dart';
import 'package:nasa_api_app/presentation/commonWidget/image_widget.dart';

class CheckedAsteroidsScreen extends StatefulWidget {
  final List<Asteroid> checkedAsteroids;
  final Function(Asteroid asteroid) updateAsteroidCheckedState;

  const CheckedAsteroidsScreen(
      {super.key,
      required this.checkedAsteroids,
      required this.updateAsteroidCheckedState});

  @override
  State<CheckedAsteroidsScreen> createState() => _CheckedAsteroidsScreenState();
}

class _CheckedAsteroidsScreenState extends State<CheckedAsteroidsScreen> {
  List<Asteroid> newCheckedAsteroids = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      newCheckedAsteroids = List<Asteroid>.from(widget.checkedAsteroids);
    });
  }

  void toggleChecked(Asteroid asteroid) {
    setState(() {
      widget.updateAsteroidCheckedState(asteroid);

      int index = newCheckedAsteroids.indexOf(asteroid);
      if (index != -1) {
        newCheckedAsteroids[index] = newCheckedAsteroids[index]
            .copyWith(checked: !newCheckedAsteroids[index].checked);
        if (!newCheckedAsteroids[index].checked) {
          newCheckedAsteroids.removeAt(index);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        '........build second screen: newCheckedAsteroids length  : ${newCheckedAsteroids.length}');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Checked Asteroids'),
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
                    child: ListView.builder(
                      itemCount: newCheckedAsteroids.length,
                      itemBuilder: (context, index) {
                        final asteroid = newCheckedAsteroids[index];
                        return Card(
                          color: Colors.black54,
                          child: ListTile(
                            title: Text(asteroid.name,
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text(
                                'Hazardous: ${asteroid.isHazardous ? 'Yes' : 'No'}',
                                style: const TextStyle(color: Colors.white70)),
                            trailing: Checkbox(
                                activeColor: Colors.white,
                                checkColor: Colors.black,
                                value: asteroid.checked,
                                onChanged: (bool? value) {
                                  toggleChecked(asteroid);
                                }),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ));
  }
}
