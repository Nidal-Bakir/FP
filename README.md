# Declarative Programming

## FP

Functional Programming using Dart language

From [Mohamed Hamed Hammad FP playlist](https://www.youtube.com/playlist?list=PLpbZuj8hP-I6F-Zj1Ay8nQ1rMnmFnlK2f)

This is a piece of art : )

```dart
extension FunctionComposition<I,M> on M Function(I) {
  O Function(I) compose<O>(O Function(M) g) => (I x) => g(this(x));
}
```
