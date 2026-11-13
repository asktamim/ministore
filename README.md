# MiniStore (Flutter)

## Run korar steps
1. `flutter create ministore`
2. Ei folder er `lib/` folder ta ar `pubspec.yaml` oi project e replace koro
3. `flutter pub get`
4. `flutter run`

## Android release build er jonno
android/app/src/main/AndroidManifest.xml e `<manifest>` er bhitore add koro:
`<uses-permission android:name="android.permission.INTERNET"/>`
(debug mode e default thake, release e lagbe)
