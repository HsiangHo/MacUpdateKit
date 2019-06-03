//
//  NSBezierPath+XAdditions.h
//  MacUpdateKit
//
//  Created by Jovi on 5/24/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBezierPath (XAdditions)

// The caller should release with CGPathRelease.
- (CGPathRef)quartzPath;

@end

NS_ASSUME_NONNULL_END
