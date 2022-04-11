#import "WhatsappSharePlugin.h"
#if __has_include(<whatsapp_share/whatsapp_share-Swift.h>)
#import <whatsapp_share/whatsapp_share-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "whatsapp_share-Swift.h"
#endif

@implementation WhatsappSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWhatsappSharePlugin registerWithRegistrar:registrar];
}
@end
