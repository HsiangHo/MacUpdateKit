//
//  NSColor+ColorExtensions.h
//  MacUpdateKit
//
//  Created by Jovi on 8/12/16.
//  Copyright © 2016 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (ColorExtensions)

- (NSColor *)lightenColorByValue:(float)value;
- (NSColor *)darkenColorByValue:(float)value;
- (BOOL)isLightColor;
+ (NSColor *)colorWithHex:(NSString *)strHex alpha:(CGFloat)alpha;          //eg: #FFFFFF

/*
 Before 10.8 CGColor was not supported
 */
@property (nonatomic, readonly) CGColorRef CGColor;

@end
