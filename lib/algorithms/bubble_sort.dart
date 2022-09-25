import 'dart:io';
import 'dart:isolate';

bubbleSort(List<dynamic> arguments) {
  SendPort sendPort = arguments[0];
  final array = arguments[1];
  final speed = arguments[2];
  int lengthOfArray = array.length;
  for (int i = 0; i < lengthOfArray - 1; i++) {
    for (int j = 0; j < lengthOfArray - i - 1; j++) {
      sendPort.send(array);
      if (array[j] > array[j + 1]) {
        num temp = array[j];
        array[j] = array[j + 1];
        array[j + 1] = temp;
        num duration = 101 - speed;
        sleep(Duration(milliseconds: duration.toInt()));
        sendPort.send(array);
      }
    }
  }
}
