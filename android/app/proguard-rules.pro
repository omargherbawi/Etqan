# === Flutter Core ===
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# === Firebase (General) ===
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# === Gson (used often by Firebase, Retrofit, etc.) ===
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

# === Parcelable (Keep model classes used across platform channel boundaries) ===
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# === Prevent common obfuscation issues with reflection and annotations ===
-keepattributes InnerClasses, EnclosingMethod
-keepattributes RuntimeVisibleAnnotations, RuntimeInvisibleAnnotations
-keepattributes RuntimeVisibleParameterAnnotations
-keepattributes Signature

# === Flutter Performance Tips ===
-dontoptimize  # (optional: only if you hit rare build issues)
-allowaccessmodification
-dontusemixedcaseclassnames

# === Required for Firebase Performance Monitoring ===
-keep class com.google.firebase.perf.** { *; }
-dontwarn com.google.firebase.perf.**
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task