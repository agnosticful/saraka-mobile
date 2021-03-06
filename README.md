# saraka

## Development

### Getting Started

#### Android Signing Config

You need to ask some existing member to get `android/app/release.gradle` and place it.

#### Generate a launcher icon

Run the command in the following to generate a launcher icon:

```
flutter packages pub run flutter_launcher_icons:main -f ./flutter_launcher_icons.yaml
```

### Debug Firebase Analytics

You can make sure whether Firebase Analytics events you attached to some action works correctly with DebugView. In order to use it, you need to enable Analytics Debug Mode with the following command:

```
adb shell setprop debug.firebase.analytics.app app.axross.saraka
```

_Note: Usually your machine has path to `adb`, but it doesn't if you installed Android SDK on Android Studio. In that case, you can find `adb` in `~/Library/Android/sdk/platform-tools` (macOS)._

If you want to disable it, you can do it with the following one:

```
adb shell setprop debug.firebase.analytics.app .none.
```

Ref: https://support.google.com/firebase/answer/7201382
