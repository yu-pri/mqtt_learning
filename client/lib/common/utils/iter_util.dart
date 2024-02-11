extension IterableExtensions<T> on Iterable<T> {
  Iterable<T> intersperse(
    T interspersedValue, {
    bool includeStart = false,
    bool includeEnd = false,
  }) sync* {
    if (includeStart) yield interspersedValue;

    for (final value in take(length - 1)) {
      yield value;
      yield interspersedValue;
    }

    yield last;
    if (includeEnd) yield interspersedValue;
  }
}
