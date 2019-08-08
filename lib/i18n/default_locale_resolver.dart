part of dart_force_mvc_lib;

abstract class AbstractLocaleResolver implements LocaleResolver {
  Intl _defaultLocale;

  /**
   * Set a default Locale that this resolver will return if no other locale found.
   */
  void setDefaultLocale(Intl defaultLocale) {
    this._defaultLocale = defaultLocale;
  }

  /**
   * Return the default Locale that this resolver is supposed to fall back to, if any.
   */
  Intl getDefaultLocale() {
    return this._defaultLocale;
  }
}
