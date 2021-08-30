#import "InfoPlistPlugin.h"
#if __has_include(<info_plist/info_plist-Swift.h>)
#import <info_plist/info_plist-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "info_plist-Swift.h"
#endif

@implementation InfoPlistPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftInfoPlistPlugin registerWithRegistrar:registrar];
}
@end
