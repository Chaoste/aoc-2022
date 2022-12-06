import 'dart:io';

void exerciseA() {
  File file = new File('./input.txt');
  String line = file.readAsStringSync();

  for(var i = 14; i < line.length; i++) {
    var unique_set = <String>{};
    unique_set.addAll(line.substring(i-14, i).split(''));
    if (unique_set.length == 14) {
      print('Result:');
      print(i);
      break;
    }
  }
}

void main() {
  exerciseA();
}