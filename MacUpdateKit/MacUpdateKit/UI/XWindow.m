//
//  XWindow.m
//  MacUpdateKit
//
//  Created by Jovi on 5/9/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import "XWindow.h"

@implementation XWindow{
    NSView                              *_mainView;
    __weak NSView                       *_titlebarContainerView;
}

#pragma mark - Override Methods

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeXWindow];
    }
    return self;
}

-(instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag{
    if (self = [super initWithContentRect:contentRect styleMask:style backing:bufferingType defer:flag]) {
        [self __initializeXWindow];
    }
    return self;
}

-(instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen{
    if (self = [super initWithContentRect:contentRect styleMask:style backing:bufferingType defer:flag screen:screen]) {
        [self __initializeXWindow];
    }
    return self;
}

-(BOOL)canBecomeKeyWindow{
    return YES;
}

-(BOOL)canBecomeMainWindow {
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidResizeNotification object:nil];
}

-(void)windowDidResize:(NSNotification *)notification{
    [self __adjustContentViewLayout];
}

#pragma mark - Private Methods

-(void)__initializeXWindow{
    NSArray *arraySubviews = self.contentView.superview.subviews;
    for(NSView *view in arraySubviews){
        if([[view className] isEqualToString:@"NSTitlebarContainerView"]){
            [view setHidden:YES];
            _titlebarContainerView = view;
            break;
        }else if([[view className] isEqualToString:@"_NSThemeCloseWidget"] ||
                 [[view className] isEqualToString:@"_NSThemeZoomWidget"] ||
                 [[view className] isEqualToString:@"_NSThemeWidget"]){
            [view setHidden:YES];
        }
    }
    _mainView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)];
    [self.contentView addSubview:_mainView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidResizeNotification object:nil];
    [self __adjustContentViewLayout];
}

-(void)__adjustContentViewLayout{
    [self.contentView setFrame: self.contentView.superview.bounds];
    NSRect rctContent = self.contentView.bounds;
    NSRect rctMainView = _mainView.frame;

    rctMainView.size.height = NSHeight(rctContent);
    rctMainView.size.width = NSWidth(rctContent);
    rctMainView.origin.x = 0;
    rctMainView.origin.y = 0;
    [_mainView setFrame:rctMainView];
}

@end
