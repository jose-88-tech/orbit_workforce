# Keep SQLite and SQLCipher
-keep class net.sqlcipher.** { *; }
-keep class net.sqlcipher.database.** { *; }

# Protect business logic for manual code validation
-keepclassmembers class * {
    *** validateSiteCode(...);
}

# Flutter specific ProGuard rules are handled by the plugin, but we can add more here.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
