# saraka

## Development

### Getting Started

#### Service Account Key

Check your debug key with keytool. As default, the keystore password is `android`.

```
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore
```

Input password. As default, the keystore password is `android`.

```
Enter keystore password: 🔑
```

Check the output and copy `SHA1` value. Here is the example output below:

```
Alias name: androiddebugkey
Creation date: 30-Dec-2018
Entry type: PrivateKeyEntry
Certificate chain length: 1
Certificate[1]:
Owner: C=US, O=Android, CN=Android Debug
Issuer: C=US, O=Android, CN=Android Debug
Serial number: 1
Valid from: Sun Dec 30 15:43:54 PST 2018 until: Tue Dec 22 15:43:54 PST 2048
Certificate fingerprints:
	 MD5:  00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
	 SHA1: 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:0:00
	 SHA256: 00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00:00
Signature algorithm name: SHA1withRSA
Subject Public Key Algorithm: 1024-bit RSA key
Version: 1
```

Go to Firebase Console then go to App Setting -> "Saraka" (Android) (You can jump there by [this link](https://console.firebase.google.com/u/0/project/saraka/settings/general/android:app.axross.saraka)). Click the "Add fingerprint" button in the "SHA certificate fingerprints" section and paste your SHA1 value that you copied in the previous step there, then click "Save" button.

Click "google-services.json" to download the file.

Put the downloaded file as `<repository_root>/android/app/google-services.json`.

#### Generate a launcher icon

Run the command in the following to generate a launcher icon:

```
flutter packages pub run flutter_launcher_icons:main -f ./flutter_launcher_icons.yaml
```
