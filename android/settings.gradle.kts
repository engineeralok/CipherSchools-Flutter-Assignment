pluginManagement {
    val flutterSdkPath = providers.gradleProperty("flutter.sdk").let { flutterSdk ->
        if (!flutterSdk.isPresent) {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { 
                properties.load(it)
            }
            properties.getProperty("flutter.sdk").also {
                checkNotNull(it) { "flutter.sdk not set in local.properties" }
            }
        } else {
            flutterSdk.get()
        }
    }

    includeBuild("${flutterSdkPath}/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.2.1" apply false
    // START: FlutterFire Configuration
    id("com.google.gms.google-services") version("4.3.15") apply false
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android") version "2.0.10" apply false
}

include(":app")