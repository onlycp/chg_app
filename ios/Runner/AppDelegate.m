#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "FlutterChannel.h"
#import "FlutterAlipayPlugin.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  [FlutterChannel pushFlutterViewController:(FlutterViewController *)self.window.rootViewController];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{

    return [FlutterAlipayPlugin handleOpenURL:url];
}
// ios 9.0+
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
     return [FlutterAlipayPlugin handleOpenURL:url];
}

@end
