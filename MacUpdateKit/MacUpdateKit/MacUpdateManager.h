//
//  MacUpdateManager.h
//  MacUpdateKit
//
//  Created by Jovi on 6/3/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    AppUpdateWindowResultUpdate,
    AppUpdateWindowResultLater,
    AppUpdateWindowResultSkip
} AppUpdateWindowResult;

NS_ASSUME_NONNULL_BEGIN

@class MacUpdateUIConfiguration;
@class MacUpdateAppInfoObject;
@interface MacUpdateManager : NSObject <NSURLDownloadDelegate>

+(instancetype)sharedManager;

/*
 Param check4UpdateURL: This parameter is the address you deployed check-for-updates.php to the remote server. like "https://xxxx.com/php/update/check-for-updates.php"
 */
-(void)customize:(MacUpdateUIConfiguration *)configure withCheck4UpdatesURL:(NSString *)check4UpdateURL;

/*
 These functions will request app information from app store. Return value YES: New version is available.
 */
-(BOOL)checkAppUpdate:(MacUpdateAppInfoObject *)appObj;
-(void)checkAppUpdateAsync:(MacUpdateAppInfoObject *)appObj withCompletionBlock:(void (^)(BOOL rslt, MacUpdateAppInfoObject *AppObj))block;

/*
 If new version is available, this method will show the updateWindow and return YES, No new version will return NO.
 */
-(BOOL)requestAppUpdateWindow:(MacUpdateAppInfoObject *)appObj withCompletionCallback:(void (^)(AppUpdateWindowResult rslt, MacUpdateAppInfoObject *AppObj))block;

/*
 Record the skipped version.
 */
-(void)skipCurrentNewVersion:(MacUpdateAppInfoObject *)appObj;
-(BOOL)isCurrentNewVersionSkipped:(MacUpdateAppInfoObject *)appObj;

/*
 Download updates in the background
 */
-(void)downloadUpdatesInBackground:(MacUpdateAppInfoObject *)appObj withCachePath:(NSString *)cachPath withDownloadCompleteBlock:(void (^)(BOOL rslt,  NSString *installerPath, MacUpdateAppInfoObject *AppObj))downloadCompleteBlock;

/*
 Install updates in the background
 */
-(void)installUpdatesInBackground:(NSString *)installerPath;

@end

NS_ASSUME_NONNULL_END
