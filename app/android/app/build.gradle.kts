plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")        // or id("kotlin-android") if your template uses that
    id("com.google.gms.google-services")      // <-- apply exactly once here (no version here)
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.stylebox.app"
    compileSdk = flutter.compileSdkVersion
    // Match Flutter's default; install this exact version if missing (SDK Manager > NDK side by side).
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.stylebox.app"
        minSdk = flutter.minSdkVersion   // ensure this is >= 21 if you use most Firebase SDKs
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: configure your real signing for release builds
            signingConfig = signingConfigs.getByName("debug")
            // Keep release build stable for TensorFlow Lite by avoiding R8 shrinking.
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase Bill of Materials to keep Firebase libs in sync
    implementation(platform("com.google.firebase:firebase-bom:34.9.0"))

    // Add the Firebase products you need (no versions when using the BoM)
    implementation("com.google.firebase:firebase-analytics")

    // Examples:
    // implementation("com.google.firebase:firebase-auth")
    // implementation("com.google.firebase:firebase-firestore")
    // implementation("com.google.firebase:firebase-messaging")
    // implementation("com.google.firebase:firebase-crashlytics")
}

