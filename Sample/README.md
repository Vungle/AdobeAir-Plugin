# publisher-sample-air

## Introduction

This sample app shows how to integrate the Vungle Publisher SDK into an Adobe
AIR application.

## Requirements

* Mac OS X (Windows should also be OK, but not tested yet).
* [Adobe AIR SDK](http://www.adobe.com/devnet/air/air-sdk-download.html).
* [JRE](http://www.oracle.com/technetwork/java/javase/downloads/index.html) (required to run Adobe AIR SDK tools).
* Apple Developer Program membership if you are going to create applications for iOS.

## Setup

1. Install Adobe AIR SDK and adjust `PATH` environment variable to be able to run tools located in its `bin` directory.

2. Put your code signing keys to the directory `keys` of the source tree.

   * For Android you can generate your own key using the command
     `keytool -genkey -v -keystore sample-android.p12 -alias alias_name -keyalg RSA -keysize 2048 -storetype pkcs12 -validity 10000`

   * For iOS you sould join Apple Developer Program to get a signing identity for your app. As a result you'll get two files: private key and provisioning profile. Without these files it is not possible to run the app on the device. iOS simulator is not supported. The files should be named `sample-ios.p12` and `sample-ios.mobileprovision`. You can export your keys to .p12 file using Keychain Access utility.

   Please note that keystores are password protected, and sample build scripts use the password `123456` to access keystores. If you have specified another password, don't forget to change the build scripts too.

Now the project should be ready to build.

## Build instructons

On Mac OS X just run `build-android.sh` to build the application for Android or `build-ios.sh` to build the application for iOS. Then install the resulting package `build/example.apk` or `build/example.ipa` to the device.

Let's take a closer look at what is being done to compile the application. On Windows you can execute these commands manually.

1. AIR compiler is called to make an SWF file:

   ```
   amxmlc -compiler.library-path=extensions/com.vungle.extensions.Vungle.ane -output build/sample.swf -swf-version=23 -default-size=320,480 -default-background-color=#b1b1b1 -debug src/VungleExample.as
   ```

2. AIR Developer Tool is called to assemble the platform-specific package.

   For Android:

   ```
   adt -package -target apk-captive-runtime -keystore keys/sample-android.p12 -storetype pkcs12 -storepass 123456 build/example.apk app.xml -C build sample.swf -C src/assets berlinSky.jpg londonSky.jpg sfSky.jpg -extdir extensions
   ```

   For iOS:

   ```
   adt -package -target ipa-test-interpreter -keystore keys/sample-ios.p12 -storetype pkcs12 -storepass 123456 -provisioning-profile keys/sample-ios.mobileprovision build/example.ipa app.xml -C build sample.swf -C src/assets berlinSky.jpg londonSky.jpg sfSky.jpg Default@2x.png Default-568h@2x.png -extdir extensions
   ```

## About the app

The sample app has 3 buttons:

* “Play Ad” - to play an ad with default options; this is the most simple application.
* “Play Incentivized Ad” - to play an incentivized ad; this requires a bit more code.
* “Play Ad With Options” - to play an ad with specific options; this is very similar to playing an incentivized ad, but this time we change another option to start playing muted.

At the top of the screen you can see the log messages.

Look into the source code `src/VungleExample.as` for details. There's a lot of comments to help you understand how it works.
