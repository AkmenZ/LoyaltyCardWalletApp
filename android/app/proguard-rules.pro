# ==============================================================
# 0. CORE ATTRIBUTES (Required for JSON Reflection)
# ==============================================================
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses

# ==============================================================
# 1. BUILD FIXES
# ==============================================================
-dontwarn org.apache.http.**
-dontwarn android.net.http.AndroidHttpClient
-dontwarn javax.naming.**
-dontwarn javax.security.**
-dontwarn org.ietf.jgss.**
-dontwarn java.nio.file.**
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement
-dontwarn com.google.android.play.core.**

# ==============================================================
# 2. RUNTIME CRASH FIXES (Prevent "Key Error")
# ==============================================================
-keep class com.google.api.client.** { *; }
-keep class com.google.api.services.drive.** { *; }
-keep class com.google.auth.** { *; }
-keep class com.google.gson.** { *; }
-keep class com.fasterxml.jackson.** { *; }
# Explicitly keep the GenericJson class used by Drive models
-keep class * extends com.google.api.client.json.GenericJson { *; }

# ==============================================================
# 3. FLUTTER DEFAULTS
# ==============================================================
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }