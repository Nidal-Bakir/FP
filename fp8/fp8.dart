void main(List<String> arguments) {
  const list = [10, 10, 3, 6, 9, 10, 11, 13, 18];
  final list2 = [];

  list
      .map(addOne)
      .map(square)
      .map(subtract10)
      .where((e) => e > 5)
      .take(2)
      .forEach((element) {
    list2.add(element);
  });

  print(list2.toString());
}

int addOne(int x) {
  print('addOne');
  return x + 1;
}

int square(int x) {
  print('square');
  return x * x;
}

int subtract10(int x) {
  print('subtract10');
  print('==============================');
  return x - 10;
}
