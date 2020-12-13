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
	<string>$(PRODUCT_NAME)</string>
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

* release

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

