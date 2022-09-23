import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String defaultAlgorithm = "Bubble Sort";
  double speed = 100.0;
  int numOfInput = 30;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: const Color.fromARGB(255, 73, 27, 126),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Algorithm Visualizer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: "Lobster",
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Algorithm",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "Lobster",
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 80,
                      ),
                      SizedBox(
                        width: 140,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.grey,
                          ),
                          child: DropdownButton<String>(
                            value: defaultAlgorithm,
                            icon: const Icon(
                              Icons.arrow_downward,
                              color: Colors.white,
                            ),
                            elevation: 16,
                            style: const TextStyle(color: Colors.white),
                            underline: Container(
                              height: 2,
                              color: Colors.white,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                defaultAlgorithm = newValue!;
                              });
                            },
                            items: <String>[
                              'Bubble Sort',
                              'Insertion Sort',
                              'Quick Sort',
                              'Merge Sort'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Speed",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "Lobster",
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 85,
                      ),
                      SliderTheme(
                        data: const SliderThemeData(
                          activeTrackColor: Colors.white,
                          thumbColor: Colors.white,
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 10),
                        ),
                        child: Slider(
                          min: 0.0,
                          max: 100.0,
                          value: speed,
                          onChanged: (value) {
                            setState(() {
                              speed = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text(
                          "Input",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "Lobster",
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 110,
                      ),
                      SizedBox(
                        width: 150,
                        child: TextFormField(
                          initialValue: numOfInput.toString(),
                          onChanged: (input) {
                            setState(() {
                              numOfInput = int.parse(input);
                            });
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Number of Inputs',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(width: 180),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.purple),
                        ),
                        onPressed: () {
                          // TODO: Generate random numbers and display blocks on UI
                        },
                        child: const Text('Generate'),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.purple),
                        ),
                        onPressed: () {
                          //TODO: Sort according to chosen algorithm
                        },
                        child: const Text('Sort'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey,
              width: MediaQuery.of(context).size.width,
              child: Column(),
            ),
          ),
        ],
      ),
    );
  }
}
