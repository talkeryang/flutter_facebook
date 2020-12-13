# facebook_applinks

Flutter plugin for Facebook App Links.

## Android

```xml
    <!-- src/main/AndroidManifest.xml -->
    <application>
        <activity
            android:name=".MainActivity">
            <!-- facebook applinks -->
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:scheme="${FACEBOOK_APP_LINKS}" />
            </intent-filter>
        </activity>
    </application>
```

```groovy
// android/app/build.gradle
android {
    defaultConfig {
        manifestPlaceholders = [
                FACEBOOK_APP_LINKS : "your facebook app link scheme",
        ]
    }
}
```

## iOS

```
//  app.xcconfig

FACEBOOK_APP_LINKS=your facebook app link scheme
```

```xml
	<!-- Info.plist -->
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLName</key>
			<string>facebook_app_links</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>$(FACEBOOK_APP_LINKS)</string>
			</array>
		</dict>
	</array>
```

## Flutter

```yaml
# pubspec.yaml
dependencies:
  facebook_applinks:
    git:
      url: https://github.com/rxreader/flutter_facebook.git
      path: facebook_applinks
```

```yaml
# pubspec.yaml
dependencies:
  facebook_applinks: ^${latestVersion}
```

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

