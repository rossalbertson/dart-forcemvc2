import 'package:test/test.dart';
import 'package:forcemvc2/force_mvc2.dart';

main() {
  // First tests!
  var accept_header_string = "en-ca,en;q=0.8,en-us;q=0.6,de-de;q=0.4,de;q=0.2";

  test("test locale resolving", () {
    AcceptHeaderLocaleResolver lr = new AcceptHeaderLocaleResolver();

    Intl locale = lr.resolveLocaleWithHeader(accept_header_string);

    expect("en_CA", locale.toString());
  });
}
