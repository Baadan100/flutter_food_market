# دليل التطوير - Flutter Fish Market

هذا الدليل مخصص للمطورين الذين يريدون المساهمة في تطوير المشروع.

## 🛠️ إعداد البيئة

### المتطلبات الأساسية
```bash
# Flutter SDK
flutter --version  # يجب أن يكون 3.5.4 أو أحدث

# Dart SDK
dart --version     # يجب أن يكون 3.5.4 أو أحدث

# Git
git --version

# Android Studio (للأندرويد)
# Xcode (لـ iOS - macOS فقط)
```

### تثبيت Flutter
```bash
# تحميل Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# التحقق من التثبيت
flutter doctor
```

### إعداد Android Studio
1. تثبيت Android Studio
2. تثبيت Android SDK
3. إعداد متغيرات البيئة:
```bash
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
```

## 🚀 بدء التطوير

### 1. استنساخ المشروع
```bash
git clone https://github.com/your-username/food_market.git
cd food_market
```

### 2. تثبيت الاعتمادات
```bash
flutter pub get
```

### 3. تشغيل التطبيق
```bash
# للويب
flutter run -d chrome

#لتشغيل بدون متصفح
flutter run -d web-server


# للأندرويد
flutter run

# للـ iOS (macOS فقط)
flutter run -d ios
```

## 📁 هيكل المشروع المفصل

```
lib/
├── app/                           # إعدادات التطبيق
│   ├── router.dart               # التوجيه الرئيسي
│   └── app_config.dart           # إعدادات التطبيق
├── core/                         # المكونات الأساسية
│   ├── constants/                # الثوابت
│   │   ├── app_constants.dart    # ثوابت التطبيق
│   │   ├── api_constants.dart    # ثوابت API
│   │   └── theme_constants.dart  # ثوابت التصميم
│   ├── errors/                   # معالجة الأخطاء
│   │   ├── exceptions.dart       # الاستثناءات
│   │   ├── failures.dart         # فشل العمليات
│   │   └── error_handler.dart    # معالج الأخطاء
│   ├── network/                  # الشبكة
│   │   ├── api_client.dart       # عميل API
│   │   ├── network_info.dart     # معلومات الشبكة
│   │   └── interceptors.dart     # معترضات الشبكة
│   ├── storage/                  # التخزين
│   │   ├── local_storage.dart    # التخزين المحلي
│   │   └── secure_storage.dart   # التخزين الآمن
│   └── utils/                    # الأدوات المساعدة
│       ├── validators.dart       # مدققات البيانات
│       ├── formatters.dart       # منسقات البيانات
│       └── extensions.dart       # امتدادات Dart
├── features/                     # الميزات الرئيسية
│   ├── auth/                     # نظام المصادقة
│   │   ├── application/          # منطق التطبيق
│   │   │   ├── auth_controller.dart
│   │   │   └── auth_service.dart
│   │   ├── domain/               # نماذج البيانات
│   │   │   ├── entities/         # الكيانات
│   │   │   ├── repositories/     # واجهات المستودعات
│   │   │   └── usecases/         # حالات الاستخدام
│   │   ├── data/                 # طبقة البيانات
│   │   │   ├── datasources/      # مصادر البيانات
│   │   │   ├── models/           # نماذج البيانات
│   │   │   └── repositories/     # تنفيذ المستودعات
│   │   └── presentation/         # واجهة المستخدم
│   │       ├── pages/            # الصفحات
│   │       ├── widgets/          # المكونات
│   │       └── controllers/      # المتحكمات
│   ├── catalog/                  # قائمة المنتجات
│   ├── cart/                     # سلة المشتريات
│   ├── checkout/                 # عملية الدفع
│   ├── home/                     # الصفحة الرئيسية
│   ├── orders/                   # إدارة الطلبات
│   ├── profile/                  # الملف الشخصي
│   ├── settings/                 # الإعدادات
│   ├── shell/                    # الهيكل العام
│   ├── splash/                   # شاشة البداية
│   └── onboarding/               # شاشات التعريف
├── l10n/                         # ملفات الترجمة
│   ├── app_localizations.dart    # الترجمة الرئيسية
│   ├── app_ar.arb               # النصوص العربية
│   └── app_en.arb               # النصوص الإنجليزية
├── theme/                        # إعدادات التصميم
│   ├── app_theme.dart           # الثيم الرئيسي
│   ├── app_colors.dart          # الألوان
│   ├── app_text_styles.dart     # أنماط النصوص
│   └── app_dimensions.dart      # الأبعاد
└── widgets/                      # المكونات المشتركة
    ├── glass.dart               # تأثير الزجاج
    ├── loading_widget.dart      # مكون التحميل
    ├── error_widget.dart        # مكون الخطأ
    └── custom_button.dart       # أزرار مخصصة
```

## 🏗️ Clean Architecture

### طبقات المشروع

#### 1. Presentation Layer (طبقة العرض)
```dart
// features/auth/presentation/pages/sign_in_page.dart
class SignInPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return Scaffold(/* UI */);
  }
}
```

#### 2. Application Layer (طبقة التطبيق)
```dart
// features/auth/application/auth_controller.dart
class AuthController extends StateNotifier<AuthState> {
  final SignInUseCase signInUseCase;
  
  Future<void> signIn(String email, String password) async {
    // منطق تسجيل الدخول
  }
}
```

#### 3. Domain Layer (طبقة النطاق)
```dart
// features/auth/domain/entities/user.dart
class User {
  final String id;
  final String email;
  final String name;
}

// features/auth/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<User> signIn(String email, String password);
  Future<User> signUp(String email, String password);
  Future<void> signOut();
}
```

#### 4. Data Layer (طبقة البيانات)
```dart
// features/auth/data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  
  @override
  Future<User> signIn(String email, String password) async {
    // تنفيذ تسجيل الدخول
  }
}
```

## 🧪 الاختبار

### هيكل الاختبارات
```
test/
├── unit/                         # اختبارات الوحدة
│   ├── features/
│   │   ├── auth/
│   │   │   ├── application/
│   │   │   ├── domain/
│   │   │   └── data/
│   │   └── catalog/
│   └── core/
├── widget/                       # اختبارات الواجهة
│   ├── features/
│   │   ├── auth/
│   │   └── catalog/
│   └── widgets/
└── integration/                  # اختبارات التكامل
    ├── auth_flow_test.dart
    └── cart_flow_test.dart
```

### تشغيل الاختبارات
```bash
# جميع الاختبارات
flutter test

# اختبارات وحدة محددة
flutter test test/unit/features/auth/

# اختبارات الواجهة
flutter test test/widget/

# اختبارات التكامل
flutter test integration_test/

# مع تغطية
flutter test --coverage
```

### مثال على اختبار الوحدة
```dart
// test/unit/features/auth/application/auth_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:food_market/features/auth/application/auth_controller.dart';

class MockSignInUseCase extends Mock implements SignInUseCase {}

void main() {
  group('AuthController', () {
    late AuthController controller;
    late MockSignInUseCase mockSignInUseCase;

    setUp(() {
      mockSignInUseCase = MockSignInUseCase();
      controller = AuthController(mockSignInUseCase);
    });

    test('should emit loading then success when sign in succeeds', () async {
      // Arrange
      when(() => mockSignInUseCase.call(any()))
          .thenAnswer((_) async => User(id: '1', email: 'test@test.com'));

      // Act
      await controller.signIn('test@test.com', 'password');

      // Assert
      expect(controller.state, isA<AuthSuccess>());
    });
  });
}
```

## 🔧 أدوات التطوير

### Code Generation
```bash
# توليد الكود
flutter packages pub run build_runner build

# مع حذف الملفات المتضاربة
flutter packages pub run build_runner build --delete-conflicting-outputs

# مراقبة التغييرات
flutter packages pub run build_runner watch
```

### التحليل والجودة
```bash
# تحليل الكود
flutter analyze

# تنسيق الكود
dart format .

# فحص التبعيات
flutter pub deps
```

### إدارة الحزم
```bash
# إضافة حزمة
flutter pub add package_name

# إضافة حزمة للتطوير
flutter pub add --dev package_name

# إزالة حزمة
flutter pub remove package_name

# تحديث الحزم
flutter pub upgrade
```

## 📱 البناء والنشر

### بناء التطبيق
```bash
# للأندرويد
flutter build apk --release
flutter build appbundle --release

# للـ iOS
flutter build ios --release
flutter build ipa --release

# للويب
flutter build web --release
```

### إعدادات البناء
```yaml
# android/app/build.gradle
android {
    compileSdkVersion 35
    defaultConfig {
        minSdkVersion 23
        targetSdkVersion 35
    }
}
```

## 🔐 الأمان

### أفضل الممارسات
```dart
// تشفير البيانات الحساسة
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  
  static Future<void> storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }
}
```

### التحقق من البيانات
```dart
// lib/core/utils/validators.dart
class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
  }
}
```

## 📊 المراقبة والتحليل

### Firebase Analytics
```dart
// lib/core/analytics/analytics_service.dart
class AnalyticsService {
  static Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
    await FirebaseAnalytics.instance.logEvent(
      name: name,
      parameters: parameters,
    );
  }
}
```

### Crashlytics
```dart
// lib/core/crashlytics/crashlytics_service.dart
class CrashlyticsService {
  static Future<void> recordError(dynamic exception, StackTrace stackTrace) async {
    await FirebaseCrashlytics.instance.recordError(
      exception,
      stackTrace,
    );
  }
}
```

## 🚀 CI/CD

### GitHub Actions
```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
    - run: flutter pub get
    - run: flutter analyze
    - run: flutter test
```

## 📚 الموارد المفيدة

### الوثائق الرسمية
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Riverpod Documentation](https://riverpod.dev/)

### أدوات مفيدة
- [Flutter Inspector](https://flutter.dev/docs/development/tools/flutter-inspector)
- [Dart DevTools](https://dart.dev/tools/dart-devtools)
- [Flutter Performance](https://flutter.dev/docs/perf)

### مجتمعات المطورين
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Reddit r/FlutterDev](https://www.reddit.com/r/FlutterDev/)

---

**آخر تحديث**: ديسمبر 2024  
**المسؤول**: فريق eLaunchCode  
**التواصل**: [contact@elaunchcode.com](mailto:contact@elaunchcode.com)
