# دليل إصلاح مشاكل Gradle و Java 🔧

## ✅ ما تم إصلاحه:

### 1. تحديث Java Version في build.gradle ✅
- **المشكلة:** `gradle.properties` يستخدم Java 17، لكن `build.gradle` يستخدم Java 8
- **الحل:** تحديث `build.gradle` لاستخدام Java 17

### 2. تحديث Kotlin JVM Target ✅
- **المشكلة:** Kotlin يستهدف JVM 1.8 بينما Java 17 مثبت
- **الحل:** تحديث `jvmTarget` إلى "17"

---

## 📝 التغييرات المطبقة:

### `android/app/build.gradle`:
```gradle
compileOptions {
    sourceCompatibility = JavaVersion.VERSION_17  // ✅ تم التحديث من VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_17  // ✅ تم التحديث من VERSION_1_8
}

kotlinOptions {
    jvmTarget = "17"  // ✅ تم التحديث من JavaVersion.VERSION_1_8
}
```

---

## 🔧 خطوات إصلاح إضافية (قم بتنفيذها):

### الخطوة 1: تنظيف المشروع بالكامل

```bash
# من مجلد المشروع الرئيسي
flutter clean
cd android
gradlew.bat clean
cd ..
flutter pub get
```

### الخطوة 2: التحقق من Java Version

```bash
java -version
```

**يجب أن يكون:**
- Java 17 أو أعلى
- إذا كان Java 8، قم بتحديثه

### الخطوة 3: التحقق من Gradle

```bash
cd android
gradlew.bat --version
```

**يجب أن يكون:**
- Gradle 8.13 (كما في `gradle-wrapper.properties`)

### الخطوة 4: إعادة بناء المشروع

```bash
# من مجلد المشروع الرئيسي
flutter build apk --debug
```

أو للتشغيل:
```bash
flutter run
```

---

## ⚠️ مشاكل محتملة وحلولها:

### المشكلة 1: "Could not find or load main class"
**الحل:**
```bash
cd android
gradlew.bat wrapper --gradle-version=8.13
cd ..
```

### المشكلة 2: "Unsupported class file major version"
**الحل:**
- تأكد من أن Java 17 مثبت
- تحقق من `gradle.properties`:
  ```
  org.gradle.java.home=C\:\\Program Files\\Eclipse Adoptium\\jdk-17.0.16.8-hotspot\\
  ```

### المشكلة 3: "Gradle sync failed"
**الحل:**
```bash
flutter clean
cd android
gradlew.bat clean
cd ..
flutter pub get
flutter pub upgrade
```

### المشكلة 4: "cloud_functions package not found"
**الحل:**
```bash
flutter pub get
# إذا لم يعمل:
flutter pub cache repair
flutter pub get
```

---

## 📋 التحقق من الإعدادات:

### 1. `android/gradle.properties`:
```properties
org.gradle.java.home=C\:\\Program Files\\Eclipse Adoptium\\jdk-17.0.16.8-hotspot\\
org.gradle.jvmargs=-Xmx4G -XX:MaxMetaspaceSize=2G
android.useAndroidX=true
android.enableJetifier=true
```

### 2. `android/app/build.gradle`:
```gradle
compileOptions {
    sourceCompatibility = JavaVersion.VERSION_17  ✅
    targetCompatibility = JavaVersion.VERSION_17  ✅
}

kotlinOptions {
    jvmTarget = "17"  ✅
}
```

### 3. `android/gradle/wrapper/gradle-wrapper.properties`:
```properties
distributionUrl=https\://services.gradle.org/distributions/gradle-8.13-bin.zip
```

---

## 🚀 بعد الإصلاح:

1. **شغّل:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **إذا استمرت المشاكل:**
   - أغلق Android Studio / VS Code
   - احذف مجلد `.dart_tool`
   - احذف مجلد `build`
   - أعد فتح المشروع
   - شغّل `flutter pub get` مرة أخرى

---

## ✅ الحالة النهائية:

- ✅ **Java Version:** محدث إلى 17 في build.gradle
- ✅ **Kotlin JVM Target:** محدث إلى 17
- ✅ **Gradle:** 8.13 (متوافق مع Java 17)
- ✅ **compileSdk:** 35 (يتطلب Java 17+)

---

**تاريخ الإصلاح:** 2025-01-11  
**الحالة:** ✅ تم إصلاح Java/Kotlin versions | ⚠️ يحتاج تنظيف و rebuild
