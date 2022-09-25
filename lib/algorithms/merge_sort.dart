import 'dart:io';
import 'dart:isolate';

mergeSort(List<dynamic> arguments) {
  SendPort sendPort = arguments[0];
  final array = arguments[1];
  final speed = arguments[2];
  sort(array, 0, array.length - 1, speed, sendPort);
}

void sort(List list, int leftIndex, int rightIndex, speed, sendPort) {
  if (leftIndex < rightIndex) {
    int middleIndex = (rightIndex + leftIndex) ~/ 2;

    sort(list, leftIndex, middleIndex, speed, sendPort);
    sort(list, middleIndex + 1, rightIndex, speed, sendPort);

    // merge
    num duration = 101 - speed;
    sleep(Duration(milliseconds: duration.toInt()));

    int leftSize = middleIndex - leftIndex + 1;
    int rightSize = rightIndex - middleIndex;

    List leftList = List.filled(leftSize, null, growable: false);
    List rightList = List.filled(rightSize, null, growable: false);

    for (int i = 0; i < leftSize; i++) {
      leftList[i] = list[leftIndex + i];
    }
    for (int j = 0; j < rightSize; j++) {
      rightList[j] = list[middleIndex + j + 1];
    }

    int i = 0, j = 0;
    int k = leftIndex;

    while (i < leftSize && j < rightSize) {
      sendPort.send(list);
      if (leftList[i] <= rightList[j]) {
        list[k] = leftList[i];
        i++;
      } else {
        list[k] = rightList[j];
        j++;
      }
      k++;
    }

    while (i < leftSize) {
      sendPort.send(list);
      list[k] = leftList[i];
      i++;
      k++;
    }

    while (j < rightSize) {
      sendPort.send(list);
      list[k] = rightList[j];
      j++;
      k++;
    }
    sendPort.send(list);
  }
}
