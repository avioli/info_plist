# A Flutter plugin to read the data from iOS or macOS's bundled Info.plist

Sometimes hard-conding the bundle name, identifier, the version or the build
can be forgotten, so this tiny plugin is meant to help in that department.

## Example usage

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InfoPlist.getInfoPlistContents();
  if (Platform.isIOS || Platform.isMacOS) {
    print(InfoPlist.bundleIdentifier); // "com.my.fancy.app"
    print(InfoPlist.bundleName); // "My fancy app"
    print(InfoPlist.version); // "1.0.0"
    print(InfoPlist.build); // "123"
  } else {
    print(InfoPlist.bundleIdentifier); // null
    print(InfoPlist.bundleName); // null
    print(InfoPlist.version); // null
    print(InfoPlist.build); // null
  }
}
```
