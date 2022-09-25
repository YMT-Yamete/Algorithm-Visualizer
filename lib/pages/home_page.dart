import 'dart:isolate';
import 'package:algorithm_visualizer/algorithms/bubble_sort.dart';
import 'package:algorithm_visualizer/algorithms/insertion_sort.dart';
import 'package:algorithm_visualizer/algorithms/merge_sort.dart';
import 'package:algorithm_visualizer/algorithms/quick_sort.dart';
import 'package:algorithm_visualizer/algorithms/selection_sort.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:d_chart/d_chart.dart';

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
  ];

  // default data
  String chosenAlgorithm = "Bubble Sort";
  double speed = 100.0;
  int numOfInput = 30;
  int numberOfOperations = 0;

  // data
  List<num> generatedNumbers = [];
  List<num> chartData = [];

  // operations
  int bubbleSortOp = 0;
  int insertionSortOp = 0;
  int selectionSortOp = 0;
  int quickSortOp = 0;
  int mergeSortOp = 0;

  // update the chart UI & operations
  updateChart(newData) {
    setState(() {
      chartData = List.from(newData);
    });
    numberOfOperations++;
    updateComparisonData(numberOfOperations);
  }

  // update comparison graph
  updateComparisonData(operations) {
    switch (chosenAlgorithm) {
      case "Bubble Sort":
        {
          setState(() {
            bubbleSortOp = numberOfOperations;
          });
        }
        break;
      case "Insertion Sort":
        {
          setState(() {
            insertionSortOp = numberOfOperations;
          });
        }
        break;
      case "Selection Sort":
        {
          setState(() {
            selectionSortOp = numberOfOperations;
          });
        }
        break;
      case "Quick Sort":
        {
          setState(() {
            quickSortOp = numberOfOperations;
          });
        }
        break;
      case "Merge Sort":
        {
          setState(() {
            mergeSortOp = numberOfOperations;
          });
        }
        break;
    }
  }

  // clear data
  clearData() {
    setState(() {
      bubbleSortOp = 0;
      insertionSortOp = 0;
      selectionSortOp = 0;
      quickSortOp = 0;
      mergeSortOp = 0;
    });
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
        {
          await Isolate.spawn(
              selectionSort, [receivePort.sendPort, chartData, speed]);
        }
        break;
      case "Quick Sort":
        {
          await Isolate.spawn(
              quickSort, [receivePort.sendPort, chartData, speed]);
        }
        break;
      case "Merge Sort":
        {
          await Isolate.spawn(
              mergeSort, [receivePort.sendPort, chartData, speed]);
        }
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
                      const SizedBox(width: 50),
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
                      const SizedBox(width: 20),
                      TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.purple),
                        ),
                        onPressed: () {
                          clearData();
                        },
                        child: const Text('Clear Data'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
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
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child: DChartBar(
                      xAxisTitle: "Number of Operations",
                      verticalDirection: false,
                      data: [
                        {
                          'id': 'Bar',
                          'data': [
                            {'domain': 'Bubble Sort', 'measure': bubbleSortOp},
                            {
                              'domain': 'Insertion Sort',
                              'measure': insertionSortOp
                            },
                            {
                              'domain': 'Selection Sort',
                              'measure': selectionSortOp
                            },
                            {'domain': 'Quick Sort', 'measure': quickSortOp},
                            {'domain': 'Merge Sort', 'measure': mergeSortOp},
                          ],
                        },
                      ],
                      domainLabelPaddingToAxisLine: 16,
                      axisLineTick: 2,
                      axisLinePointTick: 2,
                      axisLinePointWidth: 10,
                      axisLineColor: Colors.black,
                      measureLabelPaddingToAxisLine: 16,
                      barColor: (barData, index, id) => Colors.purple,
                      showBarValue: true,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
