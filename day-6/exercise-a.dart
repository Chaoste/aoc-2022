import 'dart:io';

void exerciseA() {
  File file = new File('./input.txt');
  String line = file.readAsStringSync();

  for(var i = 4; i < line.length; i++) {
    var unique_set = <String>{};
    unique_set.addAll(line.substring(i-4, i).split(''));
    if (unique_set.length == 4) {
      print('Result:');
      print(i);
      break;
    }
  }
}

void main() {
  exerciseA();
}