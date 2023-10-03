import '../fp_core/fp_core.dart';
import 'objects.dart';

void main(List<String> arguments) {
  final customer = Customer(id: 0, customerType: CustomerType.A);

  final order = Order(
    id: 0,
    orderType: OrderType.normal,
    customer: customer,
    totalPrice: 200,
  );

  final adjustedOrderCost = calcAdjustedCostOfOrder(order);

  print(adjustedOrderCost);
}

// Invoice leaf func
Invoice transformOrderToInvoiceFroIndividual(Order order) {
  return Invoice(cost: order.totalPrice, invoiceType: InvoiceType.individual);
}

Invoice transformOrderToInvoiceFroBusiness(Order order) {
  return Invoice(cost: order.totalPrice, invoiceType: InvoiceType.business);
}

Invoice transformOrderToInvoiceFroEnterprise(Order order) {
  return Invoice(cost: order.totalPrice, invoiceType: InvoiceType.enterprise);
}

// Shipping leaf func
Shipping determineShipperForUSA(Invoice invoice) {
  return Shipping(shipperId: 0);
}

Shipping determineShipperForCanada(Invoice invoice) {
  return Shipping(shipperId: 1);
}

Shipping determineShipperForGermany(Invoice invoice) {
  return Shipping(shipperId: 2);
}

Shipping determineShipperForFrance(Invoice invoice) {
  return Shipping(shipperId: 3);
}

Shipping determineShipperForSpain(Invoice invoice) {
  return Shipping(shipperId: 4);
}

Shipping determineShipperForItaly(Invoice invoice) {
  return Shipping(shipperId: 5);
}

// Freight leaf func
Freight calcFreightForClassA(Shipping shipping) {
  return Freight(freightCost: 10);
}

Freight calcFreightForClassB(Shipping shipping) {
  return Freight(freightCost: 20);
}

Freight calcFreightForClassC(Shipping shipping) {
  return Freight(freightCost: 30);
}

// Availability leaf func
Availability determineAvailabilityFromAsiaWarehouses(Order order) {
  return Availability(warehouseWithAvailabilityDate: [
    (warehousesId: 0, availabilityDate: DateTime.now()),
    (warehousesId: 1, availabilityDate: DateTime.now()),
    (warehousesId: 2, availabilityDate: DateTime.now()),
  ]);
}

Availability determineAvailabilityFromEuropeWarehouses(Order order) {
  return Availability(warehouseWithAvailabilityDate: [
    (warehousesId: 3, availabilityDate: DateTime.now()),
    (warehousesId: 4, availabilityDate: DateTime.now()),
    (warehousesId: 5, availabilityDate: DateTime.now()),
  ]);
}

//ShippingDate leaf func
ShippingDate aggregateProductToSingleWarehousesForClassA(
    Availability availability) {
  final firstWarehouse = availability.warehouseWithAvailabilityDate.first;
  final availabilityDate = firstWarehouse.availabilityDate;
  final warehousesId = firstWarehouse.warehousesId;

  return ShippingDate(data: availabilityDate, warehouse: warehousesId);
}

ShippingDate aggregateProductToSingleWarehousesForClassB(
    Availability availability) {
  final firstWarehouse = availability.warehouseWithAvailabilityDate.first;
  final availabilityDate =
      firstWarehouse.availabilityDate.add(Duration(days: 5));
  final warehousesId = firstWarehouse.warehousesId;

  return ShippingDate(data: availabilityDate, warehouse: warehousesId);
}

ShippingDate aggregateProductToSingleWarehousesForClassC(
    Availability availability) {
  final firstWarehouse = availability.warehouseWithAvailabilityDate.first;
  final availabilityDate =
      firstWarehouse.availabilityDate.add(Duration(days: 10));
  final warehousesId = firstWarehouse.warehousesId;

  return ShippingDate(data: availabilityDate, warehouse: warehousesId);
}

class InvoicePathFunctions {
  final Invoice Function(Order order) invoiceFunc;
  final Shipping Function(Invoice invoice) shippingFunc;
  final Freight Function(Shipping shipping) freightFunc;

  const InvoicePathFunctions({
    required this.invoiceFunc,
    required this.shippingFunc,
    required this.freightFunc,
  });
}

class AvailabilityPathFunctions {
  final Availability Function(Order order) availabilityFunc;
  final ShippingDate Function(Availability availability) shippingDateFunc;

  const AvailabilityPathFunctions({
    required this.availabilityFunc,
    required this.shippingDateFunc,
  });
}

class ProcessConfig {
  final InvoicePathFunctions invoicePathFunctions;
  final AvailabilityPathFunctions availabilityPathFunctions;

  const ProcessConfig({
    required this.invoicePathFunctions,
    required this.availabilityPathFunctions,
  });

  factory ProcessConfig.generateFromCustomer(Customer customer) {
    final customerType = customer.customerType;

    return ProcessConfig(
      invoicePathFunctions: InvoicePathFunctions(
          invoiceFunc: _getInvoiceFunc(customerType),
          shippingFunc: determineShipperForUSA,
          freightFunc: _getFreightFunc(customerType)),
      availabilityPathFunctions: AvailabilityPathFunctions(
        availabilityFunc: determineAvailabilityFromAsiaWarehouses,
        shippingDateFunc: _getShippingDateFunc(customerType),
      ),
    );
  }

  static Freight Function(Shipping) _getFreightFunc(CustomerType customerType) {
    return switch (customerType) {
      CustomerType.A => calcFreightForClassA,
      CustomerType.B => calcFreightForClassB,
      CustomerType.C => calcFreightForClassC,
    };
  }

  static Invoice Function(Order) _getInvoiceFunc(CustomerType customerType) {
    return switch (customerType) {
      CustomerType.A => transformOrderToInvoiceFroIndividual,
      CustomerType.B => transformOrderToInvoiceFroBusiness,
      CustomerType.C => transformOrderToInvoiceFroEnterprise,
    };
  }

  static ShippingDate Function(Availability) _getShippingDateFunc(
      CustomerType customerType) {
    return switch (customerType) {
      CustomerType.A => aggregateProductToSingleWarehousesForClassA,
      CustomerType.B => aggregateProductToSingleWarehousesForClassB,
      CustomerType.C => aggregateProductToSingleWarehousesForClassC,
    };
  }
}

Freight Function(Order order) invoicePath(
    InvoicePathFunctions invoicePathFunctions) {
  return invoicePathFunctions.invoiceFunc
      .compose(invoicePathFunctions.shippingFunc)
      .compose(invoicePathFunctions.freightFunc);
}

ShippingDate Function(Order order) availabilityPath(
    AvailabilityPathFunctions availabilityPathFunctions) {
  return availabilityPathFunctions.availabilityFunc
      .compose(availabilityPathFunctions.shippingDateFunc);
}

double _calcAdjustedCostOfOrder({
  required Order order,
  required ShippingDate Function(Order order) availabilityPathFunc,
  required Freight Function(Order order) invoicePathFunc,
}) {
  final freight = invoicePathFunc(order);
  final shippingDate = availabilityPathFunc(order);

  if (shippingDate.data.weekday == DateTime.monday) {
    return freight.freightCost * 1.5;
  }

  return freight.freightCost * 1;
}

// Root function
double calcAdjustedCostOfOrder(Order order) {
  final config = ProcessConfig.generateFromCustomer(order.customer);

  return _calcAdjustedCostOfOrder(
    order: order,
    invoicePathFunc: invoicePath(config.invoicePathFunctions),
    availabilityPathFunc: availabilityPath(config.availabilityPathFunctions),
  );
}
