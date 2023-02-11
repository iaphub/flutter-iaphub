#import "IaphubFlutterPlugin.h"
#if __has_include(<iaphub_flutter/iaphub_flutter-Swift.h>)
#import <iaphub_flutter/iaphub_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "iaphub_flutter-Swift.h"
#endif

@implementation IaphubFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIaphubFlutterPlugin registerWithRegistrar:registrar];
}
@end
