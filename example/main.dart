library example;

import "package:forcemvc2/forcemvc2.dart";
import 'package:example/controllers.dart';

main() {
    print ("Opening localhost:8080 ...");
    WebApplication app = new WebApplication(views: 'views/');
    app.start();
}