// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'اسم التطبيق';

  @override
  String get actions => 'الإجراءات';

  @override
  String get addNew => 'إضافة جديد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get confirm => 'تأكيد';

  @override
  String get confirmDelete => 'تأكيد الحذف';

  @override
  String get confirmDeleteMessage =>
      'هل أنت متأكد أنك تريد حذف هذا العنصر؟ لا يمكن التراجع عن هذا الإجراء.';

  @override
  String get create => 'إنشاء';

  @override
  String get crop => 'قص الصورة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get defaultErrorMessage => 'حدث خطأ ما, يرجى المحاولة مرة أخرى';

  @override
  String get delete => 'حذف';

  @override
  String get description => 'الوصف';

  @override
  String get edit => 'تعديل';

  @override
  String get error => 'خطأ';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get filters => 'الفلاتر';

  @override
  String get invalidFieldValue => 'قيمة حقل غير صالحة';

  @override
  String get lightMode => 'الوضع الصباحي';

  @override
  String get loading => 'جارٍ التحميل...';

  @override
  String get locationPermissionIsRequiredToContinue =>
      'يجب السماح بالوصول إلى الموقع للمتابعة';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get loginSuccess => 'تم تسجيل الدخول بنجاح';

  @override
  String get name => 'الاسم';

  @override
  String get networkError => 'تعذّر الاتصال بالخادم، تحقق من اتصالك بالإنترنت.';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get noItemsFoundError => 'لا يوجد عناصر';

  @override
  String get ofWord => 'من';

  @override
  String get page => 'صفحة';

  @override
  String get password => 'كلمة المرور';

  @override
  String get pickDate => 'اختر التاريخ';

  @override
  String get relocate => 'إعادة تحديد الموقع';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get save => 'حفظ';

  @override
  String get search => 'بحث';

  @override
  String get select => 'اختر';

  @override
  String get sessionExpired => 'انتهت الجلسة. يرجى تسجيل الدخول مجدداً.';

  @override
  String get successCreate => 'تمت الإضافة بنجاح';

  @override
  String get successDelete => 'تم الحذف بنجاح';

  @override
  String get successUpdate => 'تم التعديل بنجاح';

  @override
  String get switchTheme => 'تغيير اللون';

  @override
  String get theme => 'المظهر';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeSystem => 'النظام';

  @override
  String totalItems(Object count) {
    return 'الإجمالي: $count عنصر';
  }

  @override
  String get typeYourPasswordHere => 'أدخل كلمة المرور هنا';

  @override
  String get typeYourUsenameHere => 'ادخل اسم المستخدم هنا';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع';

  @override
  String get update => 'تحديث';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get validationEmail => 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String get validationMaxLength => 'الرجاء إكمال الطول المطلوب';

  @override
  String get validationPhoneNumber => 'الرجاء إدخال رقم هاتف صالح';

  @override
  String get validationRequired => 'هذا الحقل مطلوب';

  @override
  String get validationUrl => 'الرجاء إدخال عنوان URL صالح';

  @override
  String get validatorEmail => 'البريد الإلكتروني غير صحيح';

  @override
  String validatorMaxLength(Object n) {
    return 'رجاءً أدخل $n أحرف على الأكثر';
  }

  @override
  String validatorMinLength(Object n) {
    return 'رجاءً أدخل $n أحرف على الأقل';
  }

  @override
  String get validatorPhoneNumber => 'رقم الهاتف غير صحيح';

  @override
  String get validatorRequired => 'هذا الحقل مطلوب';

  @override
  String get validatorUrl => 'الرابط غير صحيح';

  @override
  String get validatorUseArabicOrKurdishLetters =>
      'رجاءً أدخل حروف عربية أو كردية';

  @override
  String get validatorUseEnglishLetters => 'رجاءً أدخل حروف إنجليزية';

  @override
  String get welcomeAgain => 'مرحباً بك مرة أخرى';

  @override
  String get arabicLabel => 'العربية';

  @override
  String get englishLabel => 'الإنجليزية';
}
