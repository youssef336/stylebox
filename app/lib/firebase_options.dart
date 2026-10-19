// File generated from the Firebase console config for project stylebox-af5fe.
// Re-generate with `flutterfire configure --project=stylebox-af5fe` if apps change.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'register a web app and run flutterfire configure.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAyJfeqD4w7YHr71axC2utgvetk3j3XKHU',
    appId: '1:679216134970:android:f97a314368b33eb366ee03',
    messagingSenderId: '679216134970',
    projectId: 'stylebox-af5fe',
    storageBucket: 'stylebox-af5fe.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCsXUp36JBR3Br3KW3TNUrYqbS7R0XbqxU',
    appId: '1:679216134970:ios:707b7176a888084866ee03',
    messagingSenderId: '679216134970',
    projectId: 'stylebox-af5fe',
    storageBucket: 'stylebox-af5fe.firebasestorage.app',
    iosBundleId: 'com.stylebox.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCsXUp36JBR3Br3KW3TNUrYqbS7R0XbqxU',
    appId: '1:679216134970:ios:707b7176a888084866ee03',
    messagingSenderId: '679216134970',
    projectId: 'stylebox-af5fe',
    storageBucket: 'stylebox-af5fe.firebasestorage.app',
    iosBundleId: 'com.stylebox.app',
  );
}
