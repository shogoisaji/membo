enum SharedPreferencesKey {
  isFirst('isFirst'),
  skipUpdateVersion('skipUpdateVersion'),
  isDarkMode('isDarkMode'),
  isHaptic('isHaptic'),
  language('language'),
  ;

  const SharedPreferencesKey(this.value);
  final String value;
}
