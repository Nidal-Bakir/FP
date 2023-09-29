import '../fp_core.dart';

void main(List<String> arguments) {
  const list = [1, 2, 3, 4, 5];

  var res = list.map(addOne).map(square).map(subtract10).join(' , ');
  print(res);
  print('======================');

  res = list.map((x) => subtract10(square(addOne(x)))).join(' , ');
  print(res);
  print('======================');

  res = list.map(addOneSquareSubtract10()).join(' , ');
  print(res);
  print('======================');
}

int Function(int x) addOneSquareSubtract10() =>
    addOne.compose(square).compose(subtract10);

int addOne(int x) => x + 1;
int square(int x) => x * x;
int subtract10(int x) => x - 10;
