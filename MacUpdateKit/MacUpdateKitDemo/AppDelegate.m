//
//  AppDelegate.m
//  MacUpdateKitDemo
//
//  Created by Jovi on 6/3/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import "AppDelegate.h"
#import <MacUpdateKit/MacUpdateKit.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    MacUpdateAppInfoObject *appObj = [[MacUpdateAppInfoObject alloc] initWithAppName:@"TEST" withAppIcon:[NSImage imageNamed:@"NSComputer"] withCurrentVersion:@"1.0" withProductID:@"100"];
    MacUpdateUIConfiguration *UIConfigure = [[MacUpdateUIConfiguration alloc] init];
    [UIConfigure setSkipButtonTitle:@"Skip"];
    [UIConfigure setUpdateButtonTitle:@"Update"];
    [UIConfigure setLaterButtonTitle:@"Later"];
    [UIConfigure setVersionText:@"Version %@"];
    [UIConfigure setReleaseNotesText:@"Release Notes:"];
    [[MacUpdateManager sharedManager] customize:UIConfigure withCheck4UpdatesURL:@"https://xxxxx.com/php/update/check-for-updates.php"];
    
    BOOL bRslt = [[MacUpdateManager sharedManager] checkAppUpdate:appObj];
    bRslt = [appObj isNewVersionAvailable];
    [[MacUpdateManager sharedManager] checkAppUpdateAsync:appObj withCompletionBlock:^(BOOL rslt, MacUpdateAppInfoObject * _Nonnull AppObj) {
        if (rslt && [appObj isNewVersionAvailable] && ![[MacUpdateManager sharedManager] isCurrentNewVersionSkipped:appObj]) {
            if([appObj forceUpdateFlag]){
                // force install updates
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[MacUpdateManager sharedManager] downloadUpdatesInBackground:appObj withCachePath:@"/tmp" withDownloadCompleteBlock:^(BOOL rslt, NSString * _Nonnull installerPath, MacUpdateAppInfoObject * _Nonnull AppObj) {
                        if (rslt) {
                            [[MacUpdateManager sharedManager] installUpdatesInBackground:installerPath];
                        }
                    }];
                });
            }else{
                //prompt alert window
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[MacUpdateManager sharedManager] requestAppUpdateWindow:appObj withCompletionCallback:^(AppUpdateWindowResult rslt, MacUpdateAppInfoObject * _Nonnull AppObj) {
                        switch (rslt) {
                            case AppUpdateWindowResultUpdate:
                                [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString: [appObj downloadURL]]];
                                break;
                                
                            case AppUpdateWindowResultSkip:
                                [[MacUpdateManager sharedManager] skipCurrentNewVersion:AppObj];
                                break;
                                
                            case AppUpdateWindowResultLater:
                                break;
                                
                            default:
                                break;
                        }
                    }];
                });
            }
        }
    }];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
