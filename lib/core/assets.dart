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
  editIcon('assets/images/edit.png'),
  incomeIcon('assets/images/income_icon.png'),
  expenseIcon('assets/images/expenses_icon.png'),
  shoppingIcon('assets/images/shopping_icon.png'),
  subscriptionIcon('assets/images/subscription_icon.png'),
  travelIcon('assets/images/travel_icon.png'),
  foodIcon('assets/images/food_icon.png');

  final String path;

  const Assets(this.path);
}

enum SvgAssets {
  homeIcon('assets/images/home.svg'),
  transactionIcon('assets/images/transaction.svg'),
  pieChartIcon('assets/images/pie_chart.svg'),
  userIcon('assets/images/user.svg'),
  downArrowIcon('assets/images/down_arrow.svg'),
  notificationIcon('assets/images/notification.svg');

  final String path;

  const SvgAssets(this.path);
}
