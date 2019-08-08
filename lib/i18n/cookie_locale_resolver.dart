part of dart_force_mvc_lib;

/**
 * {@link LocaleResolver} implementation that uses a cookie sent back to the user
 * in case of a custom setting, with a fallback to the specified default locale
 * or the request's accept-header locale.
 *
 * This is particularly useful for stateless applications without user sessions.
 */
class CookieLocaleResolver extends AbstractLocaleResolver {
  /**
   * The default cookie name used if none is explicitly set.
   */
  final String DEFAULT_COOKIE_NAME = "FORCE.LOCALE";

  Intl defaultLocale;

  CookieHolderManager cookieManager = new CookieHolderManager();

  CookieLocaleResolver() {
    cookieManager.cookieName = DEFAULT_COOKIE_NAME;
  }

  /**
   * Set a fixed Locale that this resolver will return if no cookie found.
   */
  void setDefaultLocale(Intl defaultLocale) {
    this.defaultLocale = defaultLocale;
  }

  /**
   * Return the fixed Locale that this resolver will return if no cookie found,
   * if any.
   */
  Intl getDefaultLocale() {
    return this.defaultLocale;
  }

  Intl resolveLocale(ForceRequest request) {
    // Retrieve and parse cookie value.
    Cookie cookie = cookieManager.getCookie(request.request);
    if (cookie != null) {
      // ... todo for see implementation
//        Intl locale = Intl.parseString(cookie.value); //StringUtils.parseLocaleString(cookie.value); How will I parse the cookie to a locale
      Intl locale = new Intl(cookie.value);
      if (locale != null) {
        return locale;
      }
    }

    return determineDefaultLocale(request);
  }

  void setLocale(ForceRequest request, Intl locale) {
    if (locale != null) {
      cookieManager.addCookie(request.request.response, locale.toString());
    } else {
      // Set request attribute to fallback locale and remove cookie.
      cookieManager.removeCookie(request.request.response);
    }
  }

  /**
   * Determine the default locale for the given request,
   * Called if no locale cookie has been found.
   * 
   * The default implementation returns the specified default locale,
   * if any, else falls back to the request's accept-header locale.
   * @param request the request to resolve the locale for
   * @return the default locale
   */
  Intl determineDefaultLocale(ForceRequest request) {
    Intl defaultLocale = getDefaultLocale();
    if (defaultLocale == null) {
      defaultLocale = new Intl(Intl.defaultLocale);
    }
    return defaultLocale;
  }
}
