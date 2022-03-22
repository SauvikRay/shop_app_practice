class HttpException implements Exception{
    final String message;

  HttpException(this.message);
    
    @override
  String toString() {
    //Instance of http
    return message;
  }

}