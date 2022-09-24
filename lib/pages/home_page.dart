import 'dart:isolate';

import 'package:algorithm_visualizer/algorithms/bubble_sort.dart';
import 'package:algorithm_visualizer/algorithms/insertion_sort.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // algorithm list
  List<String> algorithmList = [
    'Bubble Sort',
    'Insertion Sort',
    'Selection Sort',
    'Quick Sort',
    'Merge Sort',
    'Heap Sort'
  ];

  //default data
  String chosenAlgorithm = "Bubble Sort";
  double speed = 100.0;
  int numOfInput = 30;

  List<num> generatedNumbers = [];
  List<num> chartData = [];
  int numberOfOperations = 0;

  // update the chart UI & operations
  updateChart(newData) {
    setState(() {
      chartData = List.from(newData);
    });
    numberOfOperations++;
  }

  // generate random numbers and show them on chart
  randomGenerate(numOfInput) {
    generatedNumbers.clear();
    var ran = Random();
    for (var i = 0; i < numOfInput; i++) {
      int generatedNumber = ran.nextInt(100);
      setState(() {
        generatedNumbers.add(generatedNumber);
      });
    }
    setState(() {
      chartData = List.from(generatedNumbers);
    });
  }

  // reuse previously generated data
  reuseData() {
    chartData = List.from(generatedNumbers);
  }

  // sort data
  sort(algorithm, speed) async {
    final receivePort = ReceivePort();
    // run algorithms in separate thread and send data back to main thread
    switch (algorithm) {
      case "Bubble Sort":
        {
          await Isolate.spawn(
              bubbleSort, [receivePort.sendPort, chartData, speed]);
        }
        break;
      case "Insertion Sort":
        {
          await Isolate.spawn(
              insertionSort, [receivePort.sendPort, chartData, speed]);
        }
        break;
      case "Selection Sort":
        {}
        break;
      case "Quick Sort":
        {}
        break;
      case "Merge Sort":
        {}
        break;
      case "Heap Sort":
        {}
        break;
    }
    receivePort.listen((newData) {
      updateChart(newData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              color: const Color.fromARGB(255, 73, 27, 126),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 120,
                        child: Padding(
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
                      ),
                      const SizedBox(
                        width: 80,
                      ),
                      SizedBox(
                        width: 120,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            canvasColor: Colors.grey,
                          ),
                          child: DropdownButton<String>(
                            value: chosenAlgorithm,
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
                                chosenAlgorithm = newValue!;
                              });
                            },
                            // algorithm list
                            items: algorithmList
                                .map<DropdownMenuItem<String>>((String value) {
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 120,
                        child: Padding(
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
                      ),
                      const SizedBox(
                        width: 55,
                      ),
                      SizedBox(
                        width: 145,
                        child: SliderTheme(
                          data: const SliderThemeData(
                            activeTrackColor: Colors.white,
                            thumbColor: Colors.white,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 10),
                          ),
                          child: Slider(
                            min: 1.0,
                            max: 100.0,
                            value: speed,
                            onChanged: (value) {
                              setState(() {
                                speed = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 120,
                        child: Padding(
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
                      ),
                      const SizedBox(
                        width: 80,
                      ),
                      SizedBox(
                        width: 120,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 120,
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            "Operations",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: "Lobster",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 80,
                      ),
                      SizedBox(
                        width: 120,
                        child: Text(
                          numberOfOperations.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "Lobster",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          setState(() {
                            reuseData();
                          });
                        },
                        child: const Text('Reuse'),
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
                          setState(() {
                            randomGenerate(numOfInput);
                          });
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
                        onPressed: () async {
                          setState(() {
                            numberOfOperations = 0;
                          });
                          await sort(chosenAlgorithm, speed.toInt());
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
            flex: 10,
            child: Container(
              color: Colors.grey,
              width: MediaQuery.of(context).size.width,
              child: (chartData.isEmpty)
                  ? null
                  : SfSparkBarChart(
                      color: Colors.black,
                      labelDisplayMode: SparkChartLabelDisplayMode.all,
                      data: chartData,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
