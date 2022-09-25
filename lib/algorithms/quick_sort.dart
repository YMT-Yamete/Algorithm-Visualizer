import 'dart:io';
import 'dart:isolate';

quickSort(List<dynamic> arguments) {
  SendPort sendPort = arguments[0];
  final array = arguments[1];
  final speed = arguments[2];
  sort(array, 0, array.length - 1, speed, sendPort);
}

void sort(listtobesort, int leftelement, int rightelement, speed, sendPort) {
  int i = leftelement;
  int j = rightelement;
  int pivotelement = listtobesort[(leftelement + rightelement) ~/ 2];

sendPort.send(listtobesort);
  while (i <= j) {
    sendPort.send(listtobesort);
    while (listtobesort[i] < pivotelement) {
      i++;
    }

    while (listtobesort[j] > pivotelement) {
      j--;
    }

sendPort.send(listtobesort);
    if (i <= j) {
      sendPort.send(listtobesort);
      int objtemp = listtobesort[i];
      listtobesort[i] = listtobesort[j];
      listtobesort[j] = objtemp;
      i++;
      j--;
    }
  }

  num duration = 101 - speed;
  sleep(Duration(milliseconds: duration.toInt()));
  sendPort.send(listtobesort);

  if (leftelement < j) {
    sort(listtobesort, leftelement, j, speed, sendPort);
  }
  if (i < rightelement) {
    sort(listtobesort, i, rightelement, speed, sendPort);
  }
}
