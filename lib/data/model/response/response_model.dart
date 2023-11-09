class ResponseModel {
  bool _isSuccess;
  String _message;
  List<dynamic> _data; // Lista de datos

  ResponseModel(this._isSuccess, this._message, [List<dynamic> data = const []]) {
    _data = data;
  }

  String get message => _message;
  bool get isSuccess => _isSuccess;
  List<dynamic> get data => _data; // Obtén la lista de datos
}
