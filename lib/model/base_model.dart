class BaseModel<T> {
  final int code;

  final String message;

  final T data;

  const BaseModel({this.code, this.message, this.data});
}
