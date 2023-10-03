import '../fp_core.dart';

void main(List<String> arguments) {
  final calcSalaryWithTaxForIndividual = calcSalaryWithTax(1.3);
  final calcSalaryWithTaxForBusiness = calcSalaryWithTax(1.2);
  final calcSalaryWithTaxForEnterprise = calcSalaryWithTax(1.1);

  print(calcSalaryWithTaxForIndividual(10));
  print(calcSalaryWithTaxForBusiness(10));
  print(calcSalaryWithTaxForEnterprise(10));
}

/// this is a closure (save/remember the [tax] value )
double Function(double salary) calcSalaryWithTax(double tax) {
  return (salary) => tax * salary;
}
