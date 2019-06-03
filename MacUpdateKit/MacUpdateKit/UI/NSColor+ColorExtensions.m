//
//  NSColor+ColorExtensions.m
//  MacUpdateKit
//
//  Created by Jovi on 8/12/16.
//  Copyright © 2016 Jovi. All rights reserved.
//

#import "NSColor+ColorExtensions.h"

@implementation NSColor (ColorExtensions)

- (NSColor *)lightenColorByValue:(float)value {
    float red = [self redComponent];
    red += value;
    
    float green = [self greenComponent];
    green += value;
    
    float blue = [self blueComponent];
    blue += value;
    
    return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0f];
}

- (NSColor *)darkenColorByValue:(float)value {
    float red = [self redComponent];
    red -= value;
    
    float green = [self greenComponent];
    green -= value;
    
    float blue = [self blueComponent];
    blue -= value;
    
    return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:1.0f];
}

- (BOOL)isLightColor {
    NSInteger   totalComponents = [self numberOfComponents];
    bool  isGreyscale     = totalComponents == 2 ? YES : NO;
    
    CGFloat sum;
    
    if (isGreyscale) {
        sum = [self redComponent];
    } else {
        sum = ([self redComponent]+[self greenComponent]+[self blueComponent])/3.0;
    }
    
    return (sum > 0.8);
}

- (CGColorRef)CGColor
{
    const NSInteger numberOfComponents = [self numberOfComponents];
    CGFloat components[numberOfComponents];
    CGColorSpaceRef colorSpace = [[self colorSpace] CGColorSpace];
    
    [self getComponents:(CGFloat *)&components];
    
    return CGColorCreate(colorSpace, components);
}

+ (NSColor *)colorWithHex:(NSString *)strHex alpha:(CGFloat)alpha{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =1;
    [[NSScanner scannerWithString:[strHex substringWithRange:range]]scanHexInt:&red];
    range.location =3;
    [[NSScanner scannerWithString:[strHex substringWithRange:range]]scanHexInt:&green];
    range.location =5;
    [[NSScanner scannerWithString:[strHex substringWithRange:range]]scanHexInt:&blue];
    return [NSColor colorWithDeviceRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

@end
