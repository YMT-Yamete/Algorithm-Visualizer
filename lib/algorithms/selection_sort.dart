import 'dart:io';
import 'dart:isolate';

selectionSort(List<dynamic> arguments) {
  SendPort sendPort = arguments[0];
  final array = arguments[1];
  final speed = arguments[2];
  if (array == null || array.length == 0) return;
  int n = array.length;
  int i, steps;
  for (steps = 0; steps < n; steps++) {
    for (i = steps + 1; i < n; i++) {
      sendPort.send(array);
      if (array[steps] > array[i]) {
        int temp = array[steps];
        array[steps] = array[i];
        array[i] = temp;
        num duration = 101 - speed;
        sleep(Duration(milliseconds: duration.toInt()));
        sendPort.send(array);
      }
    }
  }
}
