part of dart_force_mvc_lib;

class ForceRequest implements HttpInputMessage, HttpOutputMessage {

  HttpRequest request;
  Map<String, String> path_variables;
  Completer _asyncCallCompleter;
  Intl locale;

  

  ForceRequest._();

  ForceRequest(this.request) {
    path_variables = new Map<String, String>();
    _asyncCallCompleter = new Completer();
  }

  List<String> header(String name) => request.headers[name.toLowerCase()];

  bool accepts(String type) =>
      request.headers['accept'].where((name) => name.split(',').indexOf(type) > 0).length > 0;


  bool isMime(String type) =>
      request.headers['content-type'].where((value) => value == type).isNotEmpty;

  bool get isForwarded => request.headers['x-forwarded-host'] != null;

  List<Cookie> get cookies => request.cookies.map((Cookie cookie) {
    cookie.name = Uri.decodeQueryComponent(cookie.name);
    cookie.value = Uri.decodeQueryComponent(cookie.value);
    return cookie;
  });

  void statusCode(int statusCode) {
    request.response.statusCode = statusCode;
  }

  // HTTPInputMessage
  Stream getBody() {
    return this.request.transform(const AsciiDecoder());
  }

  IOSink getOutputBody() {
    return request.response;
  }

  HttpHeadersWrapper getResponseHeaders() {
    return new HttpHeadersWrapper(this.request.response.headers);
  }

  HttpHeadersWrapper getRequestHeaders() {
    return new HttpHeadersWrapper(this.request.headers);
  }

  // All about getting post data
  Future<dynamic> getPostData({ bool usejson: true }) {
    Completer<dynamic> completer = new Completer<dynamic>();
    this.request.listen((List<int> buffer) {
      // Return the data back to the client.
      String dataOnAString = new String.fromCharCodes(buffer);

      var package = usejson ? json.decode(dataOnAString) : dataOnAString;
      completer.complete(package);
    });
    return completer.future;
  }

  Future<dynamic> getPostRawData() { // used to be Future<Map<String, String>>
      Completer c = new Completer();
      this.getBody().listen((content) {
        c.complete(content);
      });
      return c.future;
    }

/*  Future<Map<String, String>> getPostParams({ Encoding enc: utf8 }) {
    Completer c = new Completer<Map<String, String>>();
    this.getBody().listen((content) {
      final Map<String, String> postParams = new Map.fromIterable(
          content.split("&").map((kvs) => kvs.split("=")),
          key: (kv) => Uri.decodeQueryComponent(kv[0], encoding: enc),
          value: (kv) => Uri.decodeQueryComponent(kv[1], encoding: enc)
      );
      c.complete(postParams);
    });
    return c.future;
  } */

  Future getPostParams({Encoding enc=utf8}) {
      Map myParams = new Map();
    Completer c = new Completer();
    this.getBody().listen((content) {
      List x = content.split("&");
       for (String atom in x) {
      List particle = atom.split("=");
      String key = Uri.decodeQueryComponent(particle[0], encoding: enc);
      String value = Uri.decodeQueryComponent(particle[1], encoding: enc);
      if (key.endsWith("[]")) {
        key = key.replaceFirst("[]", "");
      if (myParams.containsKey(key)) {
          (myParams[key] as List).add(value);
      } else {
        myParams[key] = new List();
        myParams[key].add(value);
      }
      
      } else {
      myParams[key] = value;
      }
    }
  c.complete(myParams);
    });
    return c.future;

  }

  void async(value) {
    _asyncCallCompleter.complete(value);
  }

  Future get asyncFuture => _asyncCallCompleter.future;

}
