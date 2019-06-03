//
//  MacUpdateAppInfoObject.m
//  MacUpdateKit
//
//  Created by Jovi on 6/3/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import "MacUpdateAppInfoObject.h"

@implementation MacUpdateAppInfoObject{
    NSString            *_appName;
    NSImage             *_appIcon;
    NSString            *_productID;
    NSString            *_currentVersion;
    NSString            *_latestVersion;
    NSString            *_releaseNotes;
    NSString            *_downloadURL;
    BOOL                _forceUpdateFlag;
}

-(instancetype)initWithAppName:(NSString *)appName withAppIcon:(NSImage *)icon withCurrentVersion:(NSString *)currentVersion withProductID:(NSString *)productID{
    if(self = [super init]){
        _appName = appName;
        _appIcon = icon;
        _currentVersion = currentVersion;
        _productID = productID;
    }
    return self;
}

-(BOOL)isNewVersionAvailable{
    BOOL bRslt = NO;
    NSComparisonResult comparisonResult = [_currentVersion compare:_latestVersion options:NSNumericSearch];
    if (NSOrderedAscending == comparisonResult) {
        bRslt = YES;
    }
    return bRslt;
}

@end
