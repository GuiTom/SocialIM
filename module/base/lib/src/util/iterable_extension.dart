/// 集合扩展
extension ExtendedIterable<E> on Iterable<E> {

  Iterable<E> addJoin(E Function(int index, E element) separator) sync* {
    var index = 0;
    for (var element in this) {
      if (index > 0) {
        yield separator(index, element);
      }
      yield element;
      index++;
    }
  }


}
