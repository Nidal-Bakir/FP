import 'package:collection/collection.dart' hide UnmodifiableSetView;
import 'dart:collection';

export 'package:collection/collection.dart' hide UnmodifiableSetView;
export 'dart:collection';

extension FunctionComposition<I, M> on M Function(I) {
  O Function(I) compose<O>(O Function(M) g) => (I x) => g(this(x));
}

extension AverageOrNull on Iterable<num> {
  double? get averageOrNull => isEmpty ? null : sum / length;
}
