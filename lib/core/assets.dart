enum Assets {
  logo('assets/images/logo.png'),
  bg('assets/images/splash_bg.png'),
  next('assets/images/next.png'),
  backIcon('assets/images/arrow-left.png'),
  googleIcon('assets/images/google_icon.png'),
  accountIcon('assets/images/account_icon.png'),
  settingsIcon('assets/images/settings_icon.png'),
  exportDataIcon('assets/images/export_icon.png'),
  profileImage('assets/images/profile_image.png'),
  logOutIcon('assets/images/logout_icon.png'),
  editIcon('assets/images/edit.png');

  final String path;

  const Assets(this.path);
}
