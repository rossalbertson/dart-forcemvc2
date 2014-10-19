part of dart_force_mvc_lib;

class ServingAssistent {
  final Uri pubServeUrl; // They read that from the Environment variable
  final client = new HttpClient();
  final http_server.VirtualDirectory vd;

  ServingAssistent(this.pubServeUrl, this.vd);

  Future proxyToPub(HttpRequest request, String path) {
    const RESPONSE_HEADERS = const [
        HttpHeaders.CONTENT_LENGTH,
        HttpHeaders.CONTENT_TYPE ];

    var uri = pubServeUrl.resolve(path);
    return client.openUrl(request.method, uri)
        .then((proxyRequest) {
          proxyRequest.headers.removeAll(HttpHeaders.ACCEPT_ENCODING);
          return proxyRequest.close();
        })
        .then((proxyResponse) {
          proxyResponse.headers.forEach((name, values) {
            if (RESPONSE_HEADERS.contains(name)) {
              request.response.headers.set(name, values);
            }
          });
          request.response.statusCode = proxyResponse.statusCode;
          request.response.reasonPhrase = proxyResponse.reasonPhrase;
          return proxyResponse.pipe(request.response);
        })
        .catchError((e) {
          print("Unable to connect to 'pub serve' for '${request.uri}': $e");
          var error = new AssistentError(
              "Unable to connect to 'pub serve' for '${request.uri}': $e");
          return new Future.error(error);
        });
  }

  Future serveFromFile(HttpRequest request, String path) {
    // Check if the request path is pointing to a static resource.
    Uri fileUri = Platform.script.resolve(path);
    File file = new File(fileUri.toFilePath());
    return file.exists().then((exists) { 
        if (!file.existsSync()) {
          path = path.replaceFirst("/build", "");
          fileUri = Platform.script.resolve(path);
          file = new File(fileUri.toFilePath());
        }
        return vd.serveFile(file, request);
    });
  }

  Future<Stream<List<int>>> readFromPub(String path) {
    var uri = pubServeUrl.resolve(path);
    return client.openUrl('GET', uri)
        .then((request) => request.close())
        .then((response) {
          if (response.statusCode == HttpStatus.OK) {
            return response;
          } else {
            var error = new AssistentError(
                "Failed to fetch asset '$path' from pub: "
                "${response.statusCode}.");
            return new Future.error(error);
          }
        })
        .catchError((error) {
          if (error is! AssistentError) {
            error = new AssistentError(
                "Failed to fetch asset '$path' from pub: '${path}': $error");
          }
          return new Future.error(error);
        });
  }

  Future serve(HttpRequest request, String path) {
    if (pubServeUrl != null) {
      return proxyToPub(request, path);
    } else {
      return serveFromFile(request, path);
    }
  }
}

class AssistentError extends Error {
    final message;

    /** The [message] describes the erroneous argument. */
    AssistentError([this.message]);

    String toString() {
      if (message != null) {
        return "Illegal argument(s): $message";
      }
      return "Illegal argument(s)";
    }
}