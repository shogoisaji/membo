enum SharedPreferencesKey {
  isDarkMode('isDarkMode'),
  isHaptic('isHaptic'),
  language('language'),
  ;

  const SharedPreferencesKey(this.value);
  final String value;
}
