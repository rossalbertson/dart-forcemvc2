part of dart_force_mvc_lib;

/**
 * Implementation of LocaleResolver that simply uses the primary locale
 * specified in the "accept-language" header of the HTTP request (that is,
 * the locale sent by the client browser, normally that of the client's OS).
 */
class AcceptHeaderLocaleResolver implements LocaleResolver {

  Intl resolveLocale(ForceRequest request) {
    List<Intl> locales = new List<Intl>();
    List<String> values = request.header(HttpHeaders.ACCEPT_LANGUAGE);
    if (values!=null && values.isNotEmpty) {
        values.forEach((value) {
             locales.add(resolveLocaleWithHeader(value));
            });
    }
    return locales.isNotEmpty? locales[0] : Intl.defaultLocale;
  }

  void setLocale(ForceRequest request, covariant Intl locale) {
    throw new UnsupportedError(
        "Cannot change HTTP accept header - use a different locale resolution strategy");
  }

  Intl resolveLocaleWithHeader(String accept_header) {
    List<Intl> locales = new List<Intl>();
    for (String str in accept_header.split(",")){
        List arr = str.trim().replaceAll("-", "_").split(";");

      //Parse the locale
    //    Intl locale = null;
    //    List l = arr[0].split("_");
    /*    switch(l.length){
            case 2: locale = new Intl(l[0], l[1]); break;
            case 3: locale = new Intl(l[0], l[1], variant: l[2]); break;
            default: locale = new Intl(l[0], ""); break;
            */
    Intl locale = new Intl(arr[0]);


/*
        //Parse the q-value
        // not been used
        /*double q = 1.0;
        for (String s in arr){
            s = s.trim();
            if (s.startsWith("q=")){
                q = double.parse(s.substring(2).trim());
                break;
            }
        }*/
*/
        locales.add(locale);
    }
    return locales.isNotEmpty ? locales[0] : null;
  }
}
