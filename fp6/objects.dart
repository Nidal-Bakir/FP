enum OrderType { normal, fastDelivery, in1Day }

class Order {
  final int id;
  final OrderType orderType;
  final double totalPrice;
  final Customer customer;

  const Order({
    required this.id,
    required this.orderType,
    required this.totalPrice,
    required this.customer,
  });

  Order copyWith({
    double? totalPrice,
    OrderType? orderType,
  }) {
    return Order(
      id: id,
      customer: customer,
      totalPrice: totalPrice ?? this.totalPrice,
      orderType: orderType ?? this.orderType,
    );
  }
}

enum CustomerType { A, B, C }

class Customer {
  final int id;
  final CustomerType customerType;

  const Customer({
    required this.id,
    required this.customerType,
  });
}

class Availability {
  final List<({int warehousesId, DateTime availabilityDate})>
      warehouseWithAvailabilityDate;

  const Availability({required this.warehouseWithAvailabilityDate});
}

class ShippingDate {
  final DateTime data;
  final int warehouse;

  const ShippingDate({required this.data, required this.warehouse});
}

enum InvoiceType { individual, business, enterprise }

class Invoice {
  final double cost;
  final InvoiceType invoiceType;

  const Invoice({required this.cost, required this.invoiceType});
}

class Shipping {
  final int shipperId;

  const Shipping({required this.shipperId});
}

class Freight {
  final double freightCost;

  const Freight({required this.freightCost});
}
