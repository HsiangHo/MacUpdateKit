//
//  MacUpdateAppInfoObject.h
//  MacUpdateKit
//
//  Created by Jovi on 6/3/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MacUpdateAppInfoObject : NSObject

@property(strong,nonatomic,readwrite)   NSString    *appName;
@property(strong,nonatomic,readwrite)   NSImage     *appIcon;
@property(strong,nonatomic,readwrite)   NSString    *productID;
@property(strong,nonatomic,readwrite)   NSString    *currentVersion;

@property(strong,nonatomic,readwrite)   NSString    *latestVersion;
@property(strong,nonatomic,readwrite)   NSString    *releaseNotes;
@property(strong,nonatomic,readwrite)   NSString    *downloadURL;
@property(assign,nonatomic,readwrite)   BOOL        forceUpdateFlag;

-(instancetype)initWithAppName:(NSString *)appName withAppIcon:(NSImage *)icon withCurrentVersion:(NSString *)currentVersion withProductID:(NSString *)productID;
-(BOOL)isNewVersionAvailable;

@end

NS_ASSUME_NONNULL_END
