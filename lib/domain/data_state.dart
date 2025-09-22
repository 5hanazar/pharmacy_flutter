abstract class MyState<T> {
  MyState._();
  T? get value;
  factory MyState.success(T value) = MySuccessState<T>;
  factory MyState.loading(T? value) = MyLoadingState<T>;
  factory MyState.error(T? value, String msg) = MyErrorState<T>;
}

class MySuccessState<T> extends MyState<T> {
  MySuccessState(this._value) : super._();
  final T _value;

  @override
  T get value => _value;
}

class MyLoadingState<T> extends MyState<T> {
  MyLoadingState(this._value) : super._();
  final T? _value;

  @override
  T? get value => _value;
}

class MyErrorState<T> extends MyState<T> {
  MyErrorState(this._value, this.msg) : super._();
  final T? _value;
  final String msg;

  @override
  T? get value => _value;
}