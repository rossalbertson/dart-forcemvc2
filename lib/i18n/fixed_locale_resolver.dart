part of dart_force_mvc_lib;

/**
 * Always returns a default locale, implementation of a locale resolver
 */
class FixedLocaleResolver extends AbstractLocaleResolver {
  /**
   * Create a FixedLocaleResolver that exposes the given locale.
   * @param locale the locale to expose
   */
  FixedLocaleResolver(Intl locale) {
    setDefaultLocale(locale);
  }

  Intl resolveLocale(ForceRequest request) {
    Intl locale = getDefaultLocale();
    if (locale == null) {
      locale = new Intl(Intl.defaultLocale);
    }
    return locale;
  }

  void setLocale(ForceRequest request, covariant Intl locale) {
    throw new UnsupportedError(
        "Cannot change fixed locale - use a different locale resolution strategy");
  }
}
