// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get cancel => 'Cancelar';

  @override
  String get navHome => 'Inicio';

  @override
  String get navAccounts => 'Cuentas';

  @override
  String get navTransactions => 'Transacciones';

  @override
  String get navBudget => 'Presupuesto';

  @override
  String get navCategories => 'Categorías';

  @override
  String get navCalendar => 'Calendario';

  @override
  String get navMetrics => 'Métricas';

  @override
  String get navAlerts => 'Alertas';

  @override
  String get navProfile => 'Perfil';

  @override
  String get financesTitle => 'Finanzas';

  @override
  String get recentTransactions => 'Transacciones Recientes';

  @override
  String get noRecentTransactions => 'No hay transacciones recientes';

  @override
  String get searchPlaceholder => 'Buscar transacciones...';

  @override
  String get newTransaction => 'Nueva Transacción';

  @override
  String get transactionDetails => 'Detalle de Transacción';

  @override
  String get titleLabel => 'Título';

  @override
  String get categoryLabel => 'Categoría';

  @override
  String get accountLabel => 'Cuenta';

  @override
  String get amountLabel => 'Monto';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get noteLabel => 'Nota';

  @override
  String get receiptLabel => 'Comprobante';

  @override
  String get conversionRateLabel => 'Tasa de Conversión';

  @override
  String get extrasLabel => 'Extras';

  @override
  String get addPhotoLabel => 'Agregar Foto';

  @override
  String get galleryLabel => 'Galería';

  @override
  String get cameraLabel => 'Cámara';

  @override
  String get saveTransaction => 'Guardar Transacción';

  @override
  String get income => 'Ingreso';

  @override
  String get expense => 'Egreso';

  @override
  String get filterAll => 'Todas';

  @override
  String get deletedItem => 'Eliminado';

  @override
  String get errorProcessingImage => 'Error procesando imagen';

  @override
  String get accountsTitle => 'Mis Cuentas';

  @override
  String get newAccount => 'Nueva Cuenta';

  @override
  String get accountNameLabel => 'Nombre de la cuenta';

  @override
  String get accountNameHint => 'Ej. Banco, Efectivo...';

  @override
  String get initialBalanceLabel => 'Saldo Inicial';

  @override
  String get currencyLabel => 'Moneda';

  @override
  String get accountColorLabel => 'Color de la cuenta';

  @override
  String get saveAccount => 'Guardar Cuenta';

  @override
  String accountDeleted(Object name) {
    return 'Cuenta \"$name\" eliminada';
  }

  @override
  String get budgetTitle => 'Presupuesto';

  @override
  String get budgetList => 'Listado';

  @override
  String get budgetMetrics => 'Métricas';

  @override
  String get alertsTitle => 'Alertas de Gasto';

  @override
  String get noAlerts => 'No hay alertas configuradas';

  @override
  String get createAlert => 'Crear Alerta';

  @override
  String get editAlert => 'Editar Alerta';

  @override
  String get deleteAlert => 'Eliminar Alerta';

  @override
  String get maxAmountLabel => 'Monto Máximo';

  @override
  String get periodLabel => 'Período';

  @override
  String get cutoffDayLabel => 'Día de Corte (1-31)';

  @override
  String get monthlyPeriod => 'Mensual';

  @override
  String get annualPeriod => 'Anual';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String deleteConfirmation(Object category) {
    return '¿Seguro que quieres eliminar la alerta de \"$category\"?';
  }

  @override
  String get edit => 'Editar';

  @override
  String get delete => 'Eliminar';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get statAccounts => 'Cuentas';

  @override
  String get statCategories => 'Categorías';

  @override
  String get statTransactions => 'Transacciones';

  @override
  String get sectionAccount => 'Cuenta';

  @override
  String get personalInfo => 'Información Personal';

  @override
  String get mainAccount => 'Cuenta Principal';

  @override
  String get sectionPreferences => 'Preferencias';

  @override
  String get settingsLabel => 'Configuración';

  @override
  String get sectionInfo => 'Información';

  @override
  String get version => 'Versión';

  @override
  String get build => 'Build';

  @override
  String get copyright => '© 2026 Todos los derechos reservados';

  @override
  String get exportData => 'Exportar Datos';

  @override
  String get deleteData => 'Eliminar Datos Permanentemente';

  @override
  String get exportComingSoon =>
      'Función de exportación próximamente disponible';

  @override
  String get deleteDataTitle => '⚠️ Eliminar Datos Permanentemente';

  @override
  String get deleteDataContent =>
      '¿Estás seguro de que deseas eliminar TODOS tus datos? Esta acción NO se puede deshacer.\n\nSe eliminarán:\n• Todas las cuentas\n• Todas las transacciones\n• Todas las categorías\n• Toda la información personal';

  @override
  String get deleteAll => 'Eliminar Todo';

  @override
  String get dataDeleted => 'Todos los datos han sido eliminados';

  @override
  String get calendarTitle => 'Calendario';

  @override
  String get day => 'Día';

  @override
  String get noTransactions => 'No hay transacciones';

  @override
  String get daysMon => 'Lun';

  @override
  String get daysTue => 'Mar';

  @override
  String get daysWed => 'Mié';

  @override
  String get daysThu => 'Jue';

  @override
  String get daysFri => 'Vie';

  @override
  String get daysSat => 'Sáb';

  @override
  String get daysSun => 'Dom';

  @override
  String get categoriesTitle => 'Categorías';

  @override
  String get newCategory => 'Nueva Categoría';

  @override
  String get categoryNameLabel => 'Nombre de la categoría';

  @override
  String get categoryNameHint => 'Ej. Comida, Alquiler...';

  @override
  String get iconLabel => 'Icono';

  @override
  String get colorLabel => 'Color';

  @override
  String get saveCategory => 'Guardar Categoría';

  @override
  String get deleteCategoryTitle => '¿Eliminar categoría?';

  @override
  String deleteCategoryContent(Object categoryName) {
    return '¿Está seguro de querer eliminar la categoría \"$categoryName\"?';
  }

  @override
  String get no => 'No';

  @override
  String get yes => 'Sí';

  @override
  String get categoryDeleted => 'Categoría eliminada';

  @override
  String get metricsTitle => 'Métricas';

  @override
  String get daily => 'Diario';

  @override
  String get weekly => 'Semanal';

  @override
  String get monthly => 'Mensual';

  @override
  String get annual => 'Anual';

  @override
  String get interval => 'Intervalo';

  @override
  String get expensesByCategory => 'Gastos por Categoría';

  @override
  String get incomeByCategory => 'Ingresos por Categoría';

  @override
  String get accountUsage => 'Uso de Cuentas';

  @override
  String get mostUsed => 'Más Usada';

  @override
  String get leastUsed => 'Menos Usada';

  @override
  String get accountSummary => 'Resumen por Cuenta';

  @override
  String get noTransactionsPeriod => 'No hay transacciones en este periodo';

  @override
  String get noData => 'Sin datos para mostrar';

  @override
  String get transAbbrev => 'trans.';

  @override
  String get incomeLabel => 'Ingresos';

  @override
  String get expenseLabel => 'Egresos';

  @override
  String get skip => 'Saltar';

  @override
  String get start => 'Empezar';

  @override
  String get onboardingTitle1 => '¡Bienvenido a Nexo Finance!';

  @override
  String get onboardingDesc1 =>
      'Tu compañero ideal para el control total de tus finanzas personales.';

  @override
  String get onboardingTip1 => 'Pequeños ahorros hoy, grandes metas mañana.';

  @override
  String get onboardingTitle2 => 'Transacciones Diarias';

  @override
  String get onboardingDesc2 =>
      'Podrás registrar tus ingresos y egresos diarios de forma rápida en el módulo de transacciones.';

  @override
  String get onboardingTip2 =>
      'Mantén un registro constante para no perder ni un centavo.';

  @override
  String get onboardingTitle3 => 'Gestiona tus Cuentas';

  @override
  String get onboardingDesc3 =>
      'Crea múltiples cuentas para separar tus ahorros de tus gastos diarios o inversiones.';

  @override
  String get onboardingTip3 =>
      'Tener cuentas separadas te ayuda a no gastar lo que tienes destinado al ahorro.';

  @override
  String get onboardingTitle4 => 'Historial en el Calendario';

  @override
  String get onboardingDesc4 =>
      '¿Te olvidaste cuándo hiciste un movimiento? No te preocupes, podrás ver todos tus movimientos en una fecha específica dentro del calendario.';

  @override
  String get onboardingTip4 =>
      'La organización es la clave del éxito financiero.';

  @override
  String get onboardingTitle5 => 'Análisis y Métricas';

  @override
  String get onboardingDesc5 =>
      'Visualiza el comportamiento de tu dinero con gráficos detallados por categorías y periodos.';

  @override
  String get onboardingTip5 =>
      'Entiende en qué gastas para optimizar tus ahorros.';

  @override
  String get onboardingTitle6 => 'Alcanza tus Objetivos';

  @override
  String get onboardingDesc6 =>
      'Empieza a administrar tus finanzas para que alcances tus objetivos y vivas con tranquilidad.';

  @override
  String get onboardingTip6 => '¡El mejor momento para empezar es ahora!';

  @override
  String get paymentMethodsTitle => 'Métodos de Pago';

  @override
  String get comingSoon => 'Esta función estará disponible próximamente';
}
