# NFC Clocking Machine App

App that read NFC cards or devices to record employee attendance. in case employee forgot the card he can clockin manually, option of thaking pictures at the moment employee clock-in.

Tha app will authenticate with a Laravel backend (LB) using Sanctum API Token Authentication
The plan is use GraphQL to comunicate with the LB

![20200807_144836](https://user-images.githubusercontent.com/8298090/89618303-66e6a980-d8be-11ea-8e58-b9c8680f0098.jpg)

# How to intall test app in your device

## Andrioid



## iOS


22 Oct Develop, Deploy and Test Flutter Apps
Posted at 13:39h in Topics by Khanh Do 0 Comments  
2Likes
Introduction
Flutter is Google’s mobile app SDK for crafting high-quality native interfaces on iOS and Android in record time. Flutter works with existing code, is used by developers and organizations around the world, and is free and open source.

What does Flutter do?
For users, Flutter makes beautiful app UIs come to life.

For developers, Flutter lowers the bar to entry for building mobile apps. It speeds up the development of mobile apps and reduces the cost and complexity of app production across iOS and Android.

For designers, Flutter helps deliver the original design vision, without loss of fidelity or compromises. It also acts as a productive prototyping tool.

Install
System requirements
To install and run Flutter, your development environment must meet these minimum requirements:

Operating Systems: macOS (64-bit)
Disk Space: 700 MB (does not include disk space for IDE/tools).
Tools: Flutter depends on these command-line tools being available in your environment.
bash, mkdir, rm, git, curl, unzip, which
Get the Flutter SDK
Clone alpha branch from Flutter repository using Git and add bin folder to your PATH.

$ git clone https://github.com/flutter/flutter.git -b alpha
$ export PATH=`pwd`/flutter/bin:$PATH
The above command sets your PATH variable temporarily, for the current terminal window. You are now ready to run Flutter commands!

Note: To permanently add Flutter to your path, see the reference https://flutter.io/setup-macos/#update-your-path.

Run flutter doctor
Run the following command to see if there are any dependencies you need to install to complete the setup:

$ flutter doctor
This command checks your environment and displays a report to the terminal window. The Dart SDK is bundled with Flutter; it is not necessary to install Dart separately.

For example:



Platform setup
macOS supports developing Flutter apps for both iOS and Android. Complete at least one of the two platform setup steps now, to be able to build and run your first Flutter app.

iOS setup
Install Xcode
To develop Flutter apps for iOS, you need a Mac with Xcode 9.0 or newer:

Install Xcode 9.0 or newer (via web download or the Mac App Store).
Configure the Xcode command-line tools to use the newly-installed version of Xcode by running sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer from the command line.This is the correct path for most cases, when you want to use the latest version of Xcode. If you need to use a different version, specify that path instead.
Make sure the Xcode license agreement is signed by either opening Xcode once and confirming or running sudo xcodebuild -license from the command line.
With Xcode, you’ll be able to run Flutter apps on an iOS device or on the simulator.

Deploy to iOS devices
To deploy your Flutter app to a physical iOS device, you’ll need some additional tools and an Apple account. You’ll also need to set up physical device deployment in Xcode.

Install homebrew.
Open the terminal and run these commands to install the tools for deploying Flutter apps to iOS devices.
$ brew update
$ brew install --HEAD libimobiledevice
$ brew install ideviceinstaller ios-deploy cocoapods
$ pod setup
If any of these commands fails with an error, run brew doctor and follow the instructions for resolving the issue.

Follow the Xcode signing flow to provision your project:
Open the default Xcode workspace in your project by running open ios/Runner.xcworkspace in a terminal window from your Flutter project directory.
In Xcode, select the Runner project in the left navigation panel.
In the Runner target settings page, make sure your Development Team is selected under General > Signing > Team. When you select a team, Xcode creates and downloads a Development Certificate, registers your device with your account, and creates and downloads a provisioning profile (if needed).
To start your first iOS development project, you may need to sign into Xcode with your Apple ID.
Xcode account add
Development and testing is supported for any Apple ID. Enrolling in the Apple Developer Program is required to distribute your app to the App Store. View the differences between Apple membership types.
The first time you use an attached physical device for iOS development, you will need to trust both your Mac and the Development Certificate on that device. Select Trust in the dialog prompt when first connecting the iOS device to your Mac.
Trust Mac
Then, go to the Settings app on the iOS device, select General > Device Management and trust your Certificate.
If automatic signing fails in Xcode, verify that the project’s General > Identity > Bundle Identifier value is unique.
Check the app's Bundle ID
Start your app by running flutter run.
Android setup
 Note: Flutter relies on a full installation of Android Studio to supply its Android platform dependencies. However, you can write your Flutter apps in a number of editors; a later step will discuss that.
Install Android Studio
Download and install Android Studio.
Start Android Studio, and go through the ‘Android Studio Setup Wizard’. This will install the latest Android SDK, Android SDK Platform-Tools, and Android SDK Build-Tools, which are required by Flutter when developing for Android.
Set up your Android device
To prepare to run and test your Flutter app on an Android device, you’ll need an Android device running Android 4.1 (API level 16) or higher.

Enable Developer options and USB debugging on your device. Detailed instructions are available in the Android documentation.
Using a USB cable, plug your phone into your computer. If prompted on your device, authorize your computer to access your device.
In the terminal, run the flutter devices command to verify that Flutter recognizes your connected Android device.
By default, Flutter uses the version of the Android SDK where your adb tool is based. If you want Flutter to use a different installation of the Android SDK, you must set the environmentANDROID_HOME variable to that installation directory.

Create Project
Here I created a sample flutter_app project using following terminal command:

flutter create flutter_app
cd flutter_app
Run the app
To list out all connected devices, please use the commandflutter devices to show all:

SM G950U1 • 9887fc41594630315a • android-arm • Android 7.0 (API 24)
iPhone 7 • a0c2865be4ccfe53aea7c280dded0837873104ae • ios • iOS 10.3.3
If you have only one device is connected, just use the command flutter run to install your app into the device.

Otherwise, if have more than one device connected; please specify a device with the '-d <deviceId>' flag, or use '-d all' to act on all devices.

flutter run -d 9887fc41594630315a
flutter run -d a0c2865be4ccfe53aea7c280dded0837873104ae
Note: For iOS device, if you see the error as below, please double check the iOS Setup step to fix it.

Generate a Native Binary
To generate an APK file, run:

flutter build apk
The output looks like:

Initializing gradle...                                4.4s
Resolving dependencies...                             2.2s
Running 'gradlew assembleRelease'...
Skipping AOT snapshot build. Fingerprint match.
Built build/app/outputs/apk/release/app-release.apk (7.6MB).
To generate an IPA file, run:

flutter build ios
The output looks like:

Building com.example.flutterApp for device (ios-release)...
Automatically signing iOS for device deployment using specified development team in Xcode project: 4X2699XXXX
Running Xcode build...                               23.5s
Built /build/ios/Release-iphoneos/Runner.app
Testing your apps on real devices
In this part, I will guide you how to use Kobiton Cloud to test your apps. A Kobiton account is required to access Kobiton system. If you do not have a Kobiton account yet, go ahead to create a free trial account and sign in. It takes just a few moments.

Uploading Mobile Apps to Kobiton Store for Testing
Navigate to https://portal.kobiton.com/apps and upload your apps

The file extension can be .apk, .ipa or .zip
The file size exceeds 500mb
Launch a manual test with your expected device
Navigate to https://portal.kobiton.com/devices and launch your device

Select APPS tab and install your app into the real device

Do the same thing for iOS devices

Modify your desiredCaps to automate your app with the expected device
You can set your test to reference the application at the Kobiton Storage URL with the app capability, as shown in this example for Java.
DesiredCapabilities capabilities = new DesiredCapabilities();
capabilities.setCapability("app", "kobiton-store:1024"); 
capabilities.setCapability("deviceGroup", "KOBITON"); 
capabilities.setCapability("deviceName", "Galaxy S8+");
capabilities.setCapability("platformVersion", "7.0");
capabilities.setCapability("platformName", "Android");
DesiredCapabilities capabilities = new DesiredCapabilities();
capabilities.setCapability("app", "kobiton-store:1024");
capabilities.setCapability("deviceGroup", "KOBITON");
capabilities.setCapability("deviceName", "iPhone 6 Plus");
capabilities.setCapability("platformVersion", "10.0.2");
capabilities.setCapability("platformName", "iOS");
