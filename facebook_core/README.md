# facebook_core

Flutter plugin for Facebook Core.

## Android

```groovy
// android/app/build.gradle
android {
    defaultConfig {
        manifestPlaceholders = [
                FACEBOOK_APP_ID : "your facebook app id",
        ]
    }
}
```

## iOS

```
//  app.xcconfig

FACEBOOK_APP_ID=your facebook app id
FACEBOOK_DISPLAY_NAME=your facebook app display name
```

```
//  Debug.xcconfig
#include "app.xcconfig"
```

```
//  Release.xcconfig
#include "app.xcconfig"
```

```xml
	<!-- Info.plist -->
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLName</key>
			<string></string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>fb$(FACEBOOK_APP_ID)</string>
			</array>
		</dict>
	</array>
	<key>FacebookAppID</key>
	<string>$(FACEBOOK_APP_ID)</string>
	<key>FacebookDisplayName</key>
	<string>$(FACEBOOK_DISPLAY_NAME)</string>
	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>fbapi</string>
		<string>fbapi20130214</string>
		<string>fbapi20130410</string>
		<string>fbapi20130702</string>
		<string>fbapi20131010</string>
		<string>fbapi20131219</string>
		<string>fbapi20140410</string>
		<string>fbapi20140116</string>
		<string>fbapi20150313</string>
		<string>fbapi20150629</string>
		<string>fbapi20160328</string>
		<string>fbauth</string>
		<string>fb-messenger-share-api</string>
		<string>fbauth2</string>
		<string>fbshareextension</string>
	</array>
```

## Flutter

```yaml
# pubspec.yaml
dependencies:
  facebook_core:
    git:
      url: https://github.com/rxreader/flutter_facebook.git
      path: facebook_core
```

```yaml
# pubspec.yaml
dependencies:
  facebook_core: ^${latestVersion}
```

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

