// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get cancel => 'Cancel';

  @override
  String get navHome => 'Home';

  @override
  String get navAccounts => 'Accounts';

  @override
  String get navTransactions => 'Transactions';

  @override
  String get navBudget => 'Budget';

  @override
  String get navCategories => 'Categories';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navMetrics => 'Metrics';

  @override
  String get navAlerts => 'Alerts';

  @override
  String get navProfile => 'Profile';

  @override
  String get financesTitle => 'Finances';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get noRecentTransactions => 'No recent transactions';

  @override
  String get searchPlaceholder => 'Search transactions...';

  @override
  String get newTransaction => 'New Transaction';

  @override
  String get transactionDetails => 'Transaction Details';

  @override
  String get titleLabel => 'Title';

  @override
  String get categoryLabel => 'Category';

  @override
  String get accountLabel => 'Account';

  @override
  String get amountLabel => 'Amount';

  @override
  String get dateLabel => 'Date';

  @override
  String get noteLabel => 'Note';

  @override
  String get receiptLabel => 'Receipt';

  @override
  String get conversionRateLabel => 'Conversion Rate';

  @override
  String get extrasLabel => 'Extras';

  @override
  String get addPhotoLabel => 'Add Photo';

  @override
  String get galleryLabel => 'Gallery';

  @override
  String get cameraLabel => 'Camera';

  @override
  String get saveTransaction => 'Save Transaction';

  @override
  String get income => 'Income';

  @override
  String get expense => 'Expense';

  @override
  String get filterAll => 'All';

  @override
  String get deletedItem => 'Deleted';

  @override
  String get errorProcessingImage => 'Error processing image';

  @override
  String get accountsTitle => 'My Accounts';

  @override
  String get newAccount => 'New Account';

  @override
  String get accountNameLabel => 'Account Name';

  @override
  String get accountNameHint => 'Ex. Bank, Cash...';

  @override
  String get initialBalanceLabel => 'Initial Balance';

  @override
  String get currencyLabel => 'Currency';

  @override
  String get accountColorLabel => 'Account Color';

  @override
  String get saveAccount => 'Save Account';

  @override
  String accountDeleted(Object name) {
    return 'Account \"$name\" deleted';
  }

  @override
  String get budgetTitle => 'Budget';

  @override
  String get budgetList => 'List';

  @override
  String get budgetMetrics => 'Metrics';

  @override
  String get alertsTitle => 'Expense Alerts';

  @override
  String get noAlerts => 'No alerts configured';

  @override
  String get createAlert => 'Create Alert';

  @override
  String get editAlert => 'Edit Alert';

  @override
  String get deleteAlert => 'Delete Alert';

  @override
  String get maxAmountLabel => 'Max Amount';

  @override
  String get periodLabel => 'Period';

  @override
  String get cutoffDayLabel => 'Cutoff Day (1-31)';

  @override
  String get monthlyPeriod => 'Monthly';

  @override
  String get annualPeriod => 'Annual';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String deleteConfirmation(Object category) {
    return 'Are you sure you want to delete the alert for \"$category\"?';
  }

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get profileTitle => 'Profile';

  @override
  String get statAccounts => 'Accounts';

  @override
  String get statCategories => 'Categories';

  @override
  String get statTransactions => 'Transactions';

  @override
  String get sectionAccount => 'Account';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get mainAccount => 'Main Account';

  @override
  String get sectionPreferences => 'Preferences';

  @override
  String get settingsLabel => 'Settings';

  @override
  String get sectionInfo => 'Information';

  @override
  String get version => 'Version';

  @override
  String get build => 'Build';

  @override
  String get copyright => '© 2026 All rights reserved';

  @override
  String get exportData => 'Export Data';

  @override
  String get deleteData => 'Permanently Delete Data';

  @override
  String get exportComingSoon => 'Export function coming soon';

  @override
  String get deleteDataTitle => '⚠️ Permanently Delete Data';

  @override
  String get deleteDataContent =>
      'Are you sure you want to delete ALL your data? This action CANNOT be undone.\n\nThe following will be deleted:\n• All accounts\n• All transactions\n• All categories\n• All personal information';

  @override
  String get deleteAll => 'Delete All';

  @override
  String get dataDeleted => 'All data has been deleted';

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get day => 'Day';

  @override
  String get noTransactions => 'No transactions';

  @override
  String get daysMon => 'Mon';

  @override
  String get daysTue => 'Tue';

  @override
  String get daysWed => 'Wed';

  @override
  String get daysThu => 'Thu';

  @override
  String get daysFri => 'Fri';

  @override
  String get daysSat => 'Sat';

  @override
  String get daysSun => 'Sun';

  @override
  String get categoriesTitle => 'Categories';

  @override
  String get newCategory => 'New Category';

  @override
  String get categoryNameLabel => 'Category Name';

  @override
  String get categoryNameHint => 'Ex. Food, Rent...';

  @override
  String get iconLabel => 'Icon';

  @override
  String get colorLabel => 'Color';

  @override
  String get saveCategory => 'Save Category';

  @override
  String get deleteCategoryTitle => 'Delete Category?';

  @override
  String deleteCategoryContent(Object categoryName) {
    return 'Are you sure you want to delete the category \"$categoryName\"?';
  }

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get categoryDeleted => 'Category deleted';

  @override
  String get metricsTitle => 'Metrics';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get annual => 'Annual';

  @override
  String get interval => 'Interval';

  @override
  String get expensesByCategory => 'Expenses by Category';

  @override
  String get incomeByCategory => 'Income by Category';

  @override
  String get accountUsage => 'Account Usage';

  @override
  String get mostUsed => 'Most Used';

  @override
  String get leastUsed => 'Least Used';

  @override
  String get accountSummary => 'Account Summary';

  @override
  String get noTransactionsPeriod => 'No transactions in this period';

  @override
  String get noData => 'No data to display';

  @override
  String get transAbbrev => 'trans.';

  @override
  String get incomeLabel => 'Incomes';

  @override
  String get expenseLabel => 'Expenses';

  @override
  String get skip => 'Skip';

  @override
  String get start => 'Start';

  @override
  String get onboardingTitle1 => 'Welcome to Nexo Finance!';

  @override
  String get onboardingDesc1 =>
      'Your ideal companion for total control of your personal finances.';

  @override
  String get onboardingTip1 => 'Small savings today, big goals tomorrow.';

  @override
  String get onboardingTitle2 => 'Daily Transactions';

  @override
  String get onboardingDesc2 =>
      'Record your daily income and expenses quickly in the transaction module.';

  @override
  String get onboardingTip2 =>
      'Keep a constant record so you don\'t lose a penny.';

  @override
  String get onboardingTitle3 => 'Manage your Accounts';

  @override
  String get onboardingDesc3 =>
      'Create multiple accounts to separate your savings from your daily expenses or investments.';

  @override
  String get onboardingTip3 =>
      'Having separate accounts helps you not spend what you have set aside for savings.';

  @override
  String get onboardingTitle4 => 'History in Calendar';

  @override
  String get onboardingDesc4 =>
      'Forgot when you made a movement? Don\'t worry, you can see all your movements on a specific date in the calendar.';

  @override
  String get onboardingTip4 => 'Organization is the key to financial success.';

  @override
  String get onboardingTitle5 => 'Analysis and Metrics';

  @override
  String get onboardingDesc5 =>
      'Visualize the behavior of your money with detailed charts by categories and periods.';

  @override
  String get onboardingTip5 =>
      'Understand what you spend on to optimize your savings.';

  @override
  String get onboardingTitle6 => 'Reach your Goals';

  @override
  String get onboardingDesc6 =>
      'Start managing your finances so you can reach your goals and live with peace of mind.';

  @override
  String get onboardingTip6 => 'The best time to start is now!';

  @override
  String get paymentMethodsTitle => 'Payment Methods';

  @override
  String get comingSoon => 'This feature will be available soon';

  @override
  String get balance => 'Balance';

  @override
  String get defaultCategories => 'Default';

  @override
  String get myCategories => 'My Categories';
}
