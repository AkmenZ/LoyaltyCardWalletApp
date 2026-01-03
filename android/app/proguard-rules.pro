# 1. Apache / Java Naming (Google Drive/Cloud libs)
-dontwarn org.apache.http.**
-dontwarn android.net.http.AndroidHttpClient
-dontwarn javax.naming.**
-dontwarn javax.security.**
-dontwarn org.ietf.jgss.**
-dontwarn java.nio.file.**
-dontwarn org.codehaus.mojo.animal_sniffer.IgnoreJRERequirement

# 2. Play Core / Deferred Components (The new error you saw)
-dontwarn com.google.android.play.core.**

# 3. Flutter Wrappers
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }