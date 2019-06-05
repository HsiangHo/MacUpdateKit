//
//  MacUpdateWindowController.m
//  MacUpdateKit
//
//  Created by Jovi on 6/3/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import "MacUpdateWindowController.h"
#import "MacUpdateAppInfoObject.h"
#import "MacUpdateUIConfiguration.h"
#import "NSColor+ColorExtensions.h"
#import "MUKButton.h"
#import "MUKWindow.h"
#import "MUKView.h"

@interface MacUpdateWindowController ()

@end

@implementation MacUpdateWindowController{
    MacUpdateAppInfoObject                                 *_appObj;
    NSImageView                                            *_ivIcon;
    NSTextField                                            *_lbName;
    NSTextField                                            *_lbVersion;
    NSTextField                                            *_lbReleaseNotes;
    NSScrollView                                           *_svReleaseNotes;
    NSTextView                                             *_tvReleaseNotes;
    MUKButton                                              *_btnSkip;
    MUKButton                                              *_btnLater;
    MUKButton                                              *_btnUpdate;
    __weak id<MacUpdateWindowControllerDelegate>           _delegate;
    NSString                                               *_releaseNotesNoneText;
    NSString                                               *_releaseNotesText;
}

-(instancetype)initWithAppObject:(MacUpdateAppInfoObject *)appObj withCustomizeConfigure:(MacUpdateUIConfiguration *)configure{
    if (self = [super init]) {
        _appObj = appObj;
        [self __initializeAppStoreUpdateWindowController: configure];
    }
    return self;
}

-(void)__initializeAppStoreUpdateWindowController:(MacUpdateUIConfiguration *)configure {
    NSRect rctWindow = NSMakeRect(0, 0, 320, 485);
    MUKWindow *window = [[MUKWindow alloc] initWithContentRect:NSMakeRect(0, 0, 320, 462) styleMask:NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:YES];
    [self setWindow:window];
    [window setLevel:NSFloatingWindowLevel];
    [window setMovableByWindowBackground:YES];
    [window center];
    [window setBackgroundColor:[NSColor whiteColor]];
    [window setAnimationBehavior:NSWindowAnimationBehaviorAlertPanel];
    
    MUKView *contentView = [[MUKView alloc] initWithFrame:rctWindow];
    [window.contentView addSubview:contentView];
    
    [[window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    [[window standardWindowButton:NSWindowZoomButton] setHidden:YES];
    
    _ivIcon = [[NSImageView alloc] initWithFrame:NSMakeRect((NSWidth(rctWindow) - 96) / 2, NSHeight(rctWindow) - 140, 96, 96)];
    [_ivIcon setImageScaling:NSImageScaleAxesIndependently];
    [window.contentView addSubview:_ivIcon];
    [_ivIcon setImage:[_appObj appIcon]];
    
    _lbName = [[NSTextField alloc] initWithFrame:NSMakeRect(0, NSMinY(_ivIcon.frame) - 40, NSWidth(rctWindow), 36)];
    [_lbName setEditable:NO];
    [_lbName setBezeled:NO];
    [_lbName setSelectable:NO];
    [_lbName setTextColor:[NSColor colorWithCalibratedRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0]];
    [_lbName setBackgroundColor:[NSColor clearColor]];
    [_lbName setFont:[NSFont fontWithName:@"Helvetica Neue Light" size:32]];
    [_lbName setAlignment:NSCenterTextAlignment];
    [_lbName setStringValue:[_appObj appName]];
    [window.contentView addSubview:_lbName];
    
    _lbVersion = [[NSTextField alloc] initWithFrame:NSMakeRect((NSWidth(rctWindow) - 110) / 2, NSMinY(_lbName.frame) - 30, 110, 19)];
    [_lbVersion setWantsLayer:YES];
    _lbVersion.layer.backgroundColor = [NSColor colorWithCalibratedRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    _lbVersion.layer.cornerRadius = 10.0f;
    [_lbVersion setDrawsBackground:NO];
    [_lbVersion setEditable:NO];
    [_lbVersion setBezeled:NO];
    [_lbVersion setSelectable:NO];
    [_lbVersion setTextColor:[NSColor colorWithCalibratedRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0]];
    [_lbVersion setBackgroundColor:[NSColor clearColor]];
    [_lbVersion setFont:[NSFont fontWithName:@"Helvetica Neue" size:13]];
    [_lbVersion setAlignment:NSCenterTextAlignment];
    [_lbVersion setStringValue:[NSString stringWithFormat:@"Version %@",[_appObj latestVersion]]];
    if (nil != [configure versionText]) {
        [_lbVersion setStringValue:[NSString stringWithFormat:[configure versionText], [_appObj latestVersion]]];
    }
    [window.contentView addSubview:_lbVersion];
    
    _releaseNotesNoneText = [configure releaseNotesText];
    _releaseNotesText = [configure releaseNotesText];
    _lbReleaseNotes = [[NSTextField alloc] initWithFrame:NSMakeRect((NSWidth(rctWindow) - 250) / 2, NSMinY(_lbName.frame) - 125, 250, 18)];
    [_lbReleaseNotes setEditable:NO];
    [_lbReleaseNotes setBezeled:NO];
    [_lbReleaseNotes setSelectable:NO];
    [_lbReleaseNotes setTextColor:[NSColor colorWithCalibratedRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0]];
    [_lbReleaseNotes setBackgroundColor:[NSColor clearColor]];
    [_lbReleaseNotes setFont:[NSFont fontWithName:@"Helvetica Neue" size:12]];
    [_lbReleaseNotes setAlignment:NSLeftTextAlignment];
    [_lbReleaseNotes setStringValue:@"Release Notes:"];
    if (nil != [configure releaseNotesText]) {
        [_lbReleaseNotes setStringValue:[configure releaseNotesText]];
    }
    [window.contentView addSubview:_lbReleaseNotes];
    
    _svReleaseNotes = [[NSScrollView alloc] initWithFrame:NSMakeRect(NSMinX(_lbReleaseNotes.frame), NSMinY(_lbReleaseNotes.frame) - 45, NSWidth(_lbReleaseNotes.frame), 40)];
    [window.contentView addSubview:_svReleaseNotes];
    _tvReleaseNotes = [[NSTextView alloc] initWithFrame:_svReleaseNotes.bounds];
    [_tvReleaseNotes setEditable:NO];
    [_tvReleaseNotes setSelectable:NO];
    [_svReleaseNotes setDocumentView:_tvReleaseNotes];
    
    _btnUpdate =  [[MUKButton alloc] initWithFrame:NSMakeRect((NSWidth(rctWindow) - 250) / 2, NSMinY(_svReleaseNotes.frame) - 55, 250, 45)];
    [_btnUpdate setTitle:@"Update"];
    [_btnUpdate setAlignment:NSCenterTextAlignment];
    [_btnUpdate.layer setCornerRadius:4.0];
    [_btnUpdate.layer setBackgroundColor:[NSColor colorWithDeviceRed:23/255.0 green:155/255.0 blue:247/255.0 alpha:1.0].CGColor];
    [_btnUpdate setTitleColor:[NSColor whiteColor]];
    [_btnUpdate setFont:[NSFont fontWithName:@"Helvetica Neue Medium" size:22]];
    if (nil != [configure updateButtonTitle]) {
        [_btnUpdate setTitle:[configure updateButtonTitle]];
    }
    [_btnUpdate setAlignment:NSCenterTextAlignment];
    [_btnUpdate setTarget:self];
    [_btnUpdate setAction:@selector(updateButton_click:)];
    [window.contentView addSubview:_btnUpdate];
    
    _btnSkip = [[MUKButton alloc] initWithFrame:NSMakeRect(NSMinX(_btnUpdate.frame), NSMinY(_btnUpdate.frame) - 30, 120, 20)];
    [_btnSkip setTitle:@"Skip this version"];
    [_btnSkip setAlignment:NSLeftTextAlignment];
    [_btnSkip.layer setBackgroundColor:[NSColor clearColor].CGColor];
    [_btnSkip setTitleColor:[NSColor lightGrayColor]];
    [_btnSkip setFont:[NSFont fontWithName:@"HelveticaNeue" size:14]];
    if (nil != [configure skipButtonTitle]) {
        [_btnSkip setTitle:[configure skipButtonTitle]];
    }
    [_btnSkip setTarget:self];
    [_btnSkip setAction:@selector(skipButton_click:)];
    [window.contentView addSubview:_btnSkip];
    
    _btnLater = [[MUKButton alloc] initWithFrame:NSMakeRect(NSMaxX(_btnUpdate.frame) - 80, NSMinY(_btnUpdate.frame) - 30, 80, 20)];
    [_btnLater setTitle:@"Later"];
    [_btnLater setAlignment:NSRightTextAlignment];
    [_btnLater.layer setBackgroundColor:[NSColor clearColor].CGColor];
    [_btnLater setTitleColor:[NSColor lightGrayColor]];
    [_btnLater setFont:[NSFont fontWithName:@"HelveticaNeue" size:14]];
    if (nil != [configure laterButtonTitle]) {
        [_btnLater setTitle:[configure laterButtonTitle]];
    }
    [_btnLater setTarget:self];
    [_btnLater setAction:@selector(laterButton_click:)];
    [window.contentView addSubview:_btnLater];
    
    [self __setupReleaseNotes];
}

-(void)__setupReleaseNotes{
    [_lbReleaseNotes setHidden:NO];
    [_svReleaseNotes setHidden:NO];
    if (nil == [_appObj releaseNotes] || [[_appObj releaseNotes] isEqualToString:@""]) {
        [_lbReleaseNotes setHidden:YES];
        [_svReleaseNotes setHidden:YES];
    }else{
        NSArray *array = [[_appObj releaseNotes] componentsSeparatedByString:@"\n"];
        NSString *rslt = @"";
        for (NSString *subItem in array) {
            rslt = [rslt stringByAppendingString:[NSString stringWithFormat:@" - %@\n",subItem]];
        }
        [[_tvReleaseNotes textStorage] setAttributedString:[[NSAttributedString alloc] initWithString: rslt]];
    }
    
}

-(IBAction)updateButton_click:(id)sender{
    if ([_delegate respondsToSelector:@selector(updateButtonClick:)]) {
        [_delegate updateButtonClick:self];
    }
    [self.window orderOut:nil];
    [self close];
}

-(IBAction)skipButton_click:(id)sender{
    if ([_delegate respondsToSelector:@selector(skipButtonClick:)]) {
        [_delegate skipButtonClick:self];
    }
    [self.window orderOut:nil];
    [self close];
}

-(IBAction)laterButton_click:(id)sender{
    if ([_delegate respondsToSelector:@selector(laterButtonClick:)]) {
        [_delegate laterButtonClick:self];
    }
    [self.window orderOut:nil];
    [self close];
}

@end
