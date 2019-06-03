//
//  MacUpdateUIConfiguration.h
//  MacUpdateKit
//
//  Created by Jovi on 6/3/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MacUpdateUIConfiguration : NSObject

@property (nonatomic, strong, readwrite)        NSString        *skipButtonTitle;
@property (nonatomic, strong, readwrite)        NSString        *laterButtonTitle;
@property (nonatomic, strong, readwrite)        NSString        *updateButtonTitle;

// Default: @"Release Notes:"
@property (nonatomic, strong, readwrite)        NSString        *releaseNotesText;
// Must format like: Version %@
@property (nonatomic, strong, readwrite)        NSString        *versionText;

@end

NS_ASSUME_NONNULL_END
