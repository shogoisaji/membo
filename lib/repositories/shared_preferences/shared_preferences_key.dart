enum SharedPreferencesKey {
  isFirst('isFirst'),
  isDarkMode('isDarkMode'),
  isHaptic('isHaptic'),
  language('language'),
  ;

  const SharedPreferencesKey(this.value);
  final String value;
}
