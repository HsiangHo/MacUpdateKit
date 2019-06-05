//
//  MUKButton.m
//  MacUpdateKit
//
//  Created by Jovi on 5/24/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import "MUKButton.h"
#import <Quartz/Quartz.h>

@implementation MUKButton{
    CATextLayer             *_titleLayer;
    NSTrackingArea          *_trackingArea;
    NSColor                 *_titleColor;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self setWantsLayer:YES];
        _titleLayer = [[CATextLayer alloc] init];
        [_titleLayer setDelegate:(id<CALayerDelegate> _Nullable)self];
        [_titleLayer setContentsScale: [[NSScreen mainScreen] backingScaleFactor]];
        [self setBezelStyle:NSRegularSquareBezelStyle];
        [self setButtonType:NSMomentaryChangeButton];
        [self setImagePosition:NSImageOnly];
        [self setFocusRingType:NSFocusRingTypeNone];
        [self __setupTitleLayer];
    }
    return self;
}

-(void)updateTrackingAreas{
    [super updateTrackingAreas];
    if(_trackingArea != nil) {
        [self removeTrackingArea:_trackingArea];
    }
    
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveAlways);
    _trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                  options:opts
                                                    owner:self
                                                 userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

-(void)drawRect:(NSRect)dirtyRect{
    
}

-(void)mouseEntered:(NSEvent *)theEvent{
    [super mouseEntered:theEvent];
    [[NSCursor pointingHandCursor] set];
}

-(void)mouseExited:(NSEvent *)theEvent{
    [super mouseExited:theEvent];
    [[NSCursor arrowCursor] set];
}

- (void)setFrame:(NSRect)frame {
    [super setFrame:frame];
    [self __setupTitleLayer];
}

- (void)setFont:(NSFont *)font {
    [super setFont:font];
    [self __setupTitleLayer];
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    [self __setupTitleLayer];
}

- (void)setTitleColor:(NSColor *)titleColor {
    _titleColor = titleColor;
    [self __setupTitleLayer];
}

- (void)__setupTitleLayer {
    // Ignore title layer if has no title or imagePosition equal to NSImageOnly
    if (!self.title || self.imagePosition == NSImageOnly) {
        [_titleLayer removeFromSuperlayer];
        return;
    }
    
    CGSize buttonSize = self.frame.size;
    CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName: self.font}];
    CGFloat x = 0.0; // Title's origin x
    CGFloat y = 0.0; // Title's origin y
    
    // Caculate the image's and title's position depends on button's imagePosition and imageHugsTitle property
    switch (self.imagePosition) {
        case NSImageOnly: {
            return;
            break;
        }
        case NSNoImage: {
            x = (buttonSize.width - titleSize.width) / 2.0;
            y = (buttonSize.height - titleSize.height) / 2.0;
            break;
        }
        case NSImageOverlaps: {
            x = (buttonSize.width - titleSize.width) / 2.0;
            y = (buttonSize.height - titleSize.height) / 2.0;
            break;
        }
        default: {
            break;
        }
    }
    
    if (NSLeftTextAlignment == self.alignment) {
        x = 5;
    }else if(NSRightTextAlignment == self.alignment){
        x = (buttonSize.width - titleSize.width) - 5;
    }else{
        x = (buttonSize.width - titleSize.width) / 2.0;
    }
    
    // Setup title layer
    _titleLayer.frame = NSMakeRect(round(x), round(y), ceil(titleSize.width), ceil(titleSize.height));
    _titleLayer.string = self.title;
    _titleLayer.font = (__bridge CFTypeRef _Nullable)(self.font);
    _titleLayer.fontSize = self.font.pointSize;
    _titleLayer.foregroundColor = _titleColor.CGColor;
    [self.layer addSublayer:_titleLayer];
}

@end
