import 'package:collection/collection.dart';

typedef Rule = ({
  bool Function(Order) qualifier,
  double Function(Order) discountCalc
});

typedef Rules = UnmodifiableListView<Rule>;

extension AverageOrNull on Iterable<num> {
  double? get averageOrNull => isEmpty ? null : sum / length;
}

void main(List<String> arguments) {
  final ordersWithDiscount =
      listOfOrders.map((order) => getOrderWithDiscount(order, rules));

  // Printing =================================================================
  print(ordersWithDiscount
      .map((e) => '{id : ${e.id},  discount : ${e.discount}}\n')
      .reduce((prev, curr) => '$prev$curr'));
}

Order getOrderWithDiscount(Order order, Rules rules) {
  final discount = rules
      .where((rule) => rule.qualifier(order))
      .map((rule) => rule.discountCalc(order))
      .sorted((a, b) => a.compareTo(b))
      .take(3)
      .averageOrNull;

  return order.copyWith(discount: discount);
}

final rules = Rules([
  (qualifier: isQualifiedForA, discountCalc: calcDiscountBasedOnRuleA),
  (qualifier: isQualifiedForB, discountCalc: calcDiscountBasedOnRuleB),
  (qualifier: isQualifiedForC, discountCalc: calcDiscountBasedOnRuleC),
  (qualifier: isQualifiedForD, discountCalc: calcDiscountBasedOnRuleD),
]);

bool isQualifiedForA(Order order) => true;
double calcDiscountBasedOnRuleA(Order order) =>
    (order.unitPrice * 0.9) * order.quantity;

bool isQualifiedForB(Order order) => false;
double calcDiscountBasedOnRuleB(Order order) =>
    (order.unitPrice * 0.5) * order.quantity;

bool isQualifiedForC(Order order) => true;
double calcDiscountBasedOnRuleC(Order order) =>
    (order.unitPrice * 0.2) * order.quantity;

bool isQualifiedForD(Order order) => false;
double calcDiscountBasedOnRuleD(Order order) =>
    (order.unitPrice * 0.7) * order.quantity;

//=============================================================================

final listOfOrders = [
  Order(
    id: 1,
    quantity: 1,
    unitPrice: 10,
    expiryDate: DateTime.now().add(Duration(days: 30)),
  ),
  Order(
    id: 2,
    quantity: 2,
    unitPrice: 20,
    expiryDate: DateTime.now().add(Duration(days: 60)),
  ),
  Order(
    id: 2,
    quantity: 2,
    unitPrice: 20,
    expiryDate: DateTime.now().add(Duration(days: 60)),
  ),
  Order(
    id: 3,
    quantity: 3,
    unitPrice: 30,
    expiryDate: DateTime.now().add(Duration(days: 5)),
  ),
  Order(
    id: 4,
    quantity: 4,
    unitPrice: 40,
    expiryDate: DateTime.now().add(Duration(days: 360)),
  )
];

class Order {
  final int id;
  final int quantity;
  final double unitPrice;
  final DateTime expiryDate;
  final double? discount;

  const Order({
    required this.id,
    required this.quantity,
    required this.unitPrice,
    required this.expiryDate,
    this.discount,
  });

  Order copyWith({double? discount}) {
    return Order(
      id: id,
      unitPrice: unitPrice,
      quantity: quantity,
      expiryDate: expiryDate,
      discount: discount ?? this.discount,
    );
  }
}
