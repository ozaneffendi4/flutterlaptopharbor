plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.laptopharbor"
    compileSdk = 35           // Updated to latest SDK
    ndkVersion = "27.0.12077973"  // Match Firebase requirement

    defaultConfig {
        applicationId = "com.example.laptopharbor"
        minSdk = 23           // Required for firebase_auth/firebase_core
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
        multiDexEnabled = true // Enable if you have many dependencies
    }

    buildTypes {
    release {
        signingConfig = signingConfigs.getByName("debug")
        isMinifyEnabled = false
        isShrinkResources = false // add this line
    }
}


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

flutter {
    source = "../.."
}
