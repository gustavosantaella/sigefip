import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('ja'),
    Locale('pt'),
    Locale('zh'),
  ];

  /// No description provided for @settingsTitle.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In es, this message translates to:
  /// **'Seleccionar Idioma'**
  String get selectLanguage;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @navHome.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get navHome;

  /// No description provided for @navAccounts.
  ///
  /// In es, this message translates to:
  /// **'Cuentas'**
  String get navAccounts;

  /// No description provided for @navTransactions.
  ///
  /// In es, this message translates to:
  /// **'Transacciones'**
  String get navTransactions;

  /// No description provided for @navBudget.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto'**
  String get navBudget;

  /// No description provided for @navCategories.
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get navCategories;

  /// No description provided for @navCalendar.
  ///
  /// In es, this message translates to:
  /// **'Calendario'**
  String get navCalendar;

  /// No description provided for @navMetrics.
  ///
  /// In es, this message translates to:
  /// **'Métricas'**
  String get navMetrics;

  /// No description provided for @navAlerts.
  ///
  /// In es, this message translates to:
  /// **'Alertas'**
  String get navAlerts;

  /// No description provided for @navProfile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get navProfile;

  /// No description provided for @financesTitle.
  ///
  /// In es, this message translates to:
  /// **'Finanzas'**
  String get financesTitle;

  /// No description provided for @recentTransactions.
  ///
  /// In es, this message translates to:
  /// **'Transacciones Recientes'**
  String get recentTransactions;

  /// No description provided for @noRecentTransactions.
  ///
  /// In es, this message translates to:
  /// **'No hay transacciones recientes'**
  String get noRecentTransactions;

  /// No description provided for @searchPlaceholder.
  ///
  /// In es, this message translates to:
  /// **'Buscar transacciones...'**
  String get searchPlaceholder;

  /// No description provided for @newTransaction.
  ///
  /// In es, this message translates to:
  /// **'Nueva Transacción'**
  String get newTransaction;

  /// No description provided for @transactionDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalle de Transacción'**
  String get transactionDetails;

  /// No description provided for @titleLabel.
  ///
  /// In es, this message translates to:
  /// **'Título'**
  String get titleLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get categoryLabel;

  /// No description provided for @accountLabel.
  ///
  /// In es, this message translates to:
  /// **'Cuenta'**
  String get accountLabel;

  /// No description provided for @amountLabel.
  ///
  /// In es, this message translates to:
  /// **'Monto'**
  String get amountLabel;

  /// No description provided for @dateLabel.
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get dateLabel;

  /// No description provided for @noteLabel.
  ///
  /// In es, this message translates to:
  /// **'Nota'**
  String get noteLabel;

  /// No description provided for @receiptLabel.
  ///
  /// In es, this message translates to:
  /// **'Comprobante'**
  String get receiptLabel;

  /// No description provided for @conversionRateLabel.
  ///
  /// In es, this message translates to:
  /// **'Tasa de Conversión'**
  String get conversionRateLabel;

  /// No description provided for @extrasLabel.
  ///
  /// In es, this message translates to:
  /// **'Extras'**
  String get extrasLabel;

  /// No description provided for @addPhotoLabel.
  ///
  /// In es, this message translates to:
  /// **'Agregar Foto'**
  String get addPhotoLabel;

  /// No description provided for @galleryLabel.
  ///
  /// In es, this message translates to:
  /// **'Galería'**
  String get galleryLabel;

  /// No description provided for @cameraLabel.
  ///
  /// In es, this message translates to:
  /// **'Cámara'**
  String get cameraLabel;

  /// No description provided for @saveTransaction.
  ///
  /// In es, this message translates to:
  /// **'Guardar Transacción'**
  String get saveTransaction;

  /// No description provided for @income.
  ///
  /// In es, this message translates to:
  /// **'Ingreso'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In es, this message translates to:
  /// **'Egreso'**
  String get expense;

  /// No description provided for @filterAll.
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get filterAll;

  /// No description provided for @deletedItem.
  ///
  /// In es, this message translates to:
  /// **'Eliminado'**
  String get deletedItem;

  /// No description provided for @errorProcessingImage.
  ///
  /// In es, this message translates to:
  /// **'Error procesando imagen'**
  String get errorProcessingImage;

  /// No description provided for @accountsTitle.
  ///
  /// In es, this message translates to:
  /// **'Mis Cuentas'**
  String get accountsTitle;

  /// No description provided for @newAccount.
  ///
  /// In es, this message translates to:
  /// **'Nueva Cuenta'**
  String get newAccount;

  /// No description provided for @accountNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la cuenta'**
  String get accountNameLabel;

  /// No description provided for @accountNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. Banco, Efectivo...'**
  String get accountNameHint;

  /// No description provided for @initialBalanceLabel.
  ///
  /// In es, this message translates to:
  /// **'Saldo Inicial'**
  String get initialBalanceLabel;

  /// No description provided for @currencyLabel.
  ///
  /// In es, this message translates to:
  /// **'Moneda'**
  String get currencyLabel;

  /// No description provided for @accountColorLabel.
  ///
  /// In es, this message translates to:
  /// **'Color de la cuenta'**
  String get accountColorLabel;

  /// No description provided for @saveAccount.
  ///
  /// In es, this message translates to:
  /// **'Guardar Cuenta'**
  String get saveAccount;

  /// No description provided for @accountDeleted.
  ///
  /// In es, this message translates to:
  /// **'Cuenta \"{name}\" eliminada'**
  String accountDeleted(Object name);

  /// No description provided for @budgetTitle.
  ///
  /// In es, this message translates to:
  /// **'Presupuesto'**
  String get budgetTitle;

  /// No description provided for @budgetList.
  ///
  /// In es, this message translates to:
  /// **'Listado'**
  String get budgetList;

  /// No description provided for @budgetMetrics.
  ///
  /// In es, this message translates to:
  /// **'Métricas'**
  String get budgetMetrics;

  /// No description provided for @alertsTitle.
  ///
  /// In es, this message translates to:
  /// **'Alertas de Gasto'**
  String get alertsTitle;

  /// No description provided for @noAlerts.
  ///
  /// In es, this message translates to:
  /// **'No hay alertas configuradas'**
  String get noAlerts;

  /// No description provided for @createAlert.
  ///
  /// In es, this message translates to:
  /// **'Crear Alerta'**
  String get createAlert;

  /// No description provided for @editAlert.
  ///
  /// In es, this message translates to:
  /// **'Editar Alerta'**
  String get editAlert;

  /// No description provided for @deleteAlert.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Alerta'**
  String get deleteAlert;

  /// No description provided for @maxAmountLabel.
  ///
  /// In es, this message translates to:
  /// **'Monto Máximo'**
  String get maxAmountLabel;

  /// No description provided for @periodLabel.
  ///
  /// In es, this message translates to:
  /// **'Período'**
  String get periodLabel;

  /// No description provided for @cutoffDayLabel.
  ///
  /// In es, this message translates to:
  /// **'Día de Corte (1-31)'**
  String get cutoffDayLabel;

  /// No description provided for @monthlyPeriod.
  ///
  /// In es, this message translates to:
  /// **'Mensual'**
  String get monthlyPeriod;

  /// No description provided for @annualPeriod.
  ///
  /// In es, this message translates to:
  /// **'Anual'**
  String get annualPeriod;

  /// No description provided for @saveChanges.
  ///
  /// In es, this message translates to:
  /// **'Guardar Cambios'**
  String get saveChanges;

  /// No description provided for @deleteConfirmation.
  ///
  /// In es, this message translates to:
  /// **'¿Seguro que quieres eliminar la alerta de \"{category}\"?'**
  String deleteConfirmation(Object category);

  /// No description provided for @edit.
  ///
  /// In es, this message translates to:
  /// **'Editar'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get delete;

  /// No description provided for @profileTitle.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profileTitle;

  /// No description provided for @statAccounts.
  ///
  /// In es, this message translates to:
  /// **'Cuentas'**
  String get statAccounts;

  /// No description provided for @statCategories.
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get statCategories;

  /// No description provided for @statTransactions.
  ///
  /// In es, this message translates to:
  /// **'Transacciones'**
  String get statTransactions;

  /// No description provided for @sectionAccount.
  ///
  /// In es, this message translates to:
  /// **'Cuenta'**
  String get sectionAccount;

  /// No description provided for @personalInfo.
  ///
  /// In es, this message translates to:
  /// **'Información Personal'**
  String get personalInfo;

  /// No description provided for @mainAccount.
  ///
  /// In es, this message translates to:
  /// **'Cuenta Principal'**
  String get mainAccount;

  /// No description provided for @sectionPreferences.
  ///
  /// In es, this message translates to:
  /// **'Preferencias'**
  String get sectionPreferences;

  /// No description provided for @settingsLabel.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settingsLabel;

  /// No description provided for @sectionInfo.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get sectionInfo;

  /// No description provided for @version.
  ///
  /// In es, this message translates to:
  /// **'Versión'**
  String get version;

  /// No description provided for @build.
  ///
  /// In es, this message translates to:
  /// **'Build'**
  String get build;

  /// No description provided for @copyright.
  ///
  /// In es, this message translates to:
  /// **'© 2026 Todos los derechos reservados'**
  String get copyright;

  /// No description provided for @exportData.
  ///
  /// In es, this message translates to:
  /// **'Exportar Datos'**
  String get exportData;

  /// No description provided for @deleteData.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Datos Permanentemente'**
  String get deleteData;

  /// No description provided for @exportComingSoon.
  ///
  /// In es, this message translates to:
  /// **'Función de exportación próximamente disponible'**
  String get exportComingSoon;

  /// No description provided for @deleteDataTitle.
  ///
  /// In es, this message translates to:
  /// **'⚠️ Eliminar Datos Permanentemente'**
  String get deleteDataTitle;

  /// No description provided for @deleteDataContent.
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas eliminar TODOS tus datos? Esta acción NO se puede deshacer.\n\nSe eliminarán:\n• Todas las cuentas\n• Todas las transacciones\n• Todas las categorías\n• Toda la información personal'**
  String get deleteDataContent;

  /// No description provided for @deleteAll.
  ///
  /// In es, this message translates to:
  /// **'Eliminar Todo'**
  String get deleteAll;

  /// No description provided for @dataDeleted.
  ///
  /// In es, this message translates to:
  /// **'Todos los datos han sido eliminados'**
  String get dataDeleted;

  /// No description provided for @calendarTitle.
  ///
  /// In es, this message translates to:
  /// **'Calendario'**
  String get calendarTitle;

  /// No description provided for @day.
  ///
  /// In es, this message translates to:
  /// **'Día'**
  String get day;

  /// No description provided for @noTransactions.
  ///
  /// In es, this message translates to:
  /// **'No hay transacciones'**
  String get noTransactions;

  /// No description provided for @daysMon.
  ///
  /// In es, this message translates to:
  /// **'Lun'**
  String get daysMon;

  /// No description provided for @daysTue.
  ///
  /// In es, this message translates to:
  /// **'Mar'**
  String get daysTue;

  /// No description provided for @daysWed.
  ///
  /// In es, this message translates to:
  /// **'Mié'**
  String get daysWed;

  /// No description provided for @daysThu.
  ///
  /// In es, this message translates to:
  /// **'Jue'**
  String get daysThu;

  /// No description provided for @daysFri.
  ///
  /// In es, this message translates to:
  /// **'Vie'**
  String get daysFri;

  /// No description provided for @daysSat.
  ///
  /// In es, this message translates to:
  /// **'Sáb'**
  String get daysSat;

  /// No description provided for @daysSun.
  ///
  /// In es, this message translates to:
  /// **'Dom'**
  String get daysSun;

  /// No description provided for @categoriesTitle.
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get categoriesTitle;

  /// No description provided for @newCategory.
  ///
  /// In es, this message translates to:
  /// **'Nueva Categoría'**
  String get newCategory;

  /// No description provided for @categoryNameLabel.
  ///
  /// In es, this message translates to:
  /// **'Nombre de la categoría'**
  String get categoryNameLabel;

  /// No description provided for @categoryNameHint.
  ///
  /// In es, this message translates to:
  /// **'Ej. Comida, Alquiler...'**
  String get categoryNameHint;

  /// No description provided for @iconLabel.
  ///
  /// In es, this message translates to:
  /// **'Icono'**
  String get iconLabel;

  /// No description provided for @colorLabel.
  ///
  /// In es, this message translates to:
  /// **'Color'**
  String get colorLabel;

  /// No description provided for @saveCategory.
  ///
  /// In es, this message translates to:
  /// **'Guardar Categoría'**
  String get saveCategory;

  /// No description provided for @deleteCategoryTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Eliminar categoría?'**
  String get deleteCategoryTitle;

  /// No description provided for @deleteCategoryContent.
  ///
  /// In es, this message translates to:
  /// **'¿Está seguro de querer eliminar la categoría \"{categoryName}\"?'**
  String deleteCategoryContent(Object categoryName);

  /// No description provided for @no.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get yes;

  /// No description provided for @categoryDeleted.
  ///
  /// In es, this message translates to:
  /// **'Categoría eliminada'**
  String get categoryDeleted;

  /// No description provided for @metricsTitle.
  ///
  /// In es, this message translates to:
  /// **'Métricas'**
  String get metricsTitle;

  /// No description provided for @daily.
  ///
  /// In es, this message translates to:
  /// **'Diario'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In es, this message translates to:
  /// **'Semanal'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In es, this message translates to:
  /// **'Mensual'**
  String get monthly;

  /// No description provided for @annual.
  ///
  /// In es, this message translates to:
  /// **'Anual'**
  String get annual;

  /// No description provided for @interval.
  ///
  /// In es, this message translates to:
  /// **'Intervalo'**
  String get interval;

  /// No description provided for @expensesByCategory.
  ///
  /// In es, this message translates to:
  /// **'Gastos por Categoría'**
  String get expensesByCategory;

  /// No description provided for @incomeByCategory.
  ///
  /// In es, this message translates to:
  /// **'Ingresos por Categoría'**
  String get incomeByCategory;

  /// No description provided for @accountUsage.
  ///
  /// In es, this message translates to:
  /// **'Uso de Cuentas'**
  String get accountUsage;

  /// No description provided for @mostUsed.
  ///
  /// In es, this message translates to:
  /// **'Más Usada'**
  String get mostUsed;

  /// No description provided for @leastUsed.
  ///
  /// In es, this message translates to:
  /// **'Menos Usada'**
  String get leastUsed;

  /// No description provided for @accountSummary.
  ///
  /// In es, this message translates to:
  /// **'Resumen por Cuenta'**
  String get accountSummary;

  /// No description provided for @noTransactionsPeriod.
  ///
  /// In es, this message translates to:
  /// **'No hay transacciones en este periodo'**
  String get noTransactionsPeriod;

  /// No description provided for @noData.
  ///
  /// In es, this message translates to:
  /// **'Sin datos para mostrar'**
  String get noData;

  /// No description provided for @transAbbrev.
  ///
  /// In es, this message translates to:
  /// **'trans.'**
  String get transAbbrev;

  /// No description provided for @incomeLabel.
  ///
  /// In es, this message translates to:
  /// **'Ingresos'**
  String get incomeLabel;

  /// No description provided for @expenseLabel.
  ///
  /// In es, this message translates to:
  /// **'Egresos'**
  String get expenseLabel;

  /// No description provided for @skip.
  ///
  /// In es, this message translates to:
  /// **'Saltar'**
  String get skip;

  /// No description provided for @start.
  ///
  /// In es, this message translates to:
  /// **'Empezar'**
  String get start;

  /// No description provided for @onboardingTitle1.
  ///
  /// In es, this message translates to:
  /// **'¡Bienvenido a Nexo Finance!'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In es, this message translates to:
  /// **'Tu compañero ideal para el control total de tus finanzas personales.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTip1.
  ///
  /// In es, this message translates to:
  /// **'Pequeños ahorros hoy, grandes metas mañana.'**
  String get onboardingTip1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In es, this message translates to:
  /// **'Transacciones Diarias'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In es, this message translates to:
  /// **'Podrás registrar tus ingresos y egresos diarios de forma rápida en el módulo de transacciones.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTip2.
  ///
  /// In es, this message translates to:
  /// **'Mantén un registro constante para no perder ni un centavo.'**
  String get onboardingTip2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In es, this message translates to:
  /// **'Gestiona tus Cuentas'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In es, this message translates to:
  /// **'Crea múltiples cuentas para separar tus ahorros de tus gastos diarios o inversiones.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingTip3.
  ///
  /// In es, this message translates to:
  /// **'Tener cuentas separadas te ayuda a no gastar lo que tienes destinado al ahorro.'**
  String get onboardingTip3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In es, this message translates to:
  /// **'Historial en el Calendario'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In es, this message translates to:
  /// **'¿Te olvidaste cuándo hiciste un movimiento? No te preocupes, podrás ver todos tus movimientos en una fecha específica dentro del calendario.'**
  String get onboardingDesc4;

  /// No description provided for @onboardingTip4.
  ///
  /// In es, this message translates to:
  /// **'La organización es la clave del éxito financiero.'**
  String get onboardingTip4;

  /// No description provided for @onboardingTitle5.
  ///
  /// In es, this message translates to:
  /// **'Análisis y Métricas'**
  String get onboardingTitle5;

  /// No description provided for @onboardingDesc5.
  ///
  /// In es, this message translates to:
  /// **'Visualiza el comportamiento de tu dinero con gráficos detallados por categorías y periodos.'**
  String get onboardingDesc5;

  /// No description provided for @onboardingTip5.
  ///
  /// In es, this message translates to:
  /// **'Entiende en qué gastas para optimizar tus ahorros.'**
  String get onboardingTip5;

  /// No description provided for @onboardingTitle6.
  ///
  /// In es, this message translates to:
  /// **'Alcanza tus Objetivos'**
  String get onboardingTitle6;

  /// No description provided for @onboardingDesc6.
  ///
  /// In es, this message translates to:
  /// **'Empieza a administrar tus finanzas para que alcances tus objetivos y vivas con tranquilidad.'**
  String get onboardingDesc6;

  /// No description provided for @onboardingTip6.
  ///
  /// In es, this message translates to:
  /// **'¡El mejor momento para empezar es ahora!'**
  String get onboardingTip6;

  /// No description provided for @paymentMethodsTitle.
  ///
  /// In es, this message translates to:
  /// **'Métodos de Pago'**
  String get paymentMethodsTitle;

  /// No description provided for @comingSoon.
  ///
  /// In es, this message translates to:
  /// **'Esta función estará disponible próximamente'**
  String get comingSoon;

  /// No description provided for @balance.
  ///
  /// In es, this message translates to:
  /// **'Saldo'**
  String get balance;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ja', 'pt', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
