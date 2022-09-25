import 'dart:io';
import 'dart:isolate';

insertionSort(List<dynamic> arguments) {
  SendPort sendPort = arguments[0];
  final array = arguments[1];
  final speed = arguments[2];
  for (int j = 1; j < array.length; j++) {
    int key = array[j];
    int i = j - 1;
    sendPort.send(array); 
    while (i >= 0 && array[i] > key) {
      sendPort.send(array);
      array[i + 1] = array[i];
      i = i - 1;
      array[i + 1] = key;
      num duration = 101 - speed;
      sleep(Duration(milliseconds: duration.toInt()));
      sendPort.send(array);
    }
  } 
}
