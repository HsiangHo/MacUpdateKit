//
//  MacUpdateWindowController.h
//  MacUpdateKit
//
//  Created by Jovi on 6/3/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MacUpdateAppInfoObject;
@class MacUpdateUIConfiguration;
@class MacUpdateWindowController;

NS_ASSUME_NONNULL_BEGIN

@protocol MacUpdateWindowControllerDelegate <NSObject>

@optional
-(void)skipButtonClick:(MacUpdateWindowController *)sender;
-(void)updateButtonClick:(MacUpdateWindowController *)sender;
-(void)laterButtonClick:(MacUpdateWindowController *)sender;

@end

@interface MacUpdateWindowController : NSWindowController

@property(nonatomic, weak, readwrite)   id<MacUpdateWindowControllerDelegate>           delegate;
@property(nonatomic, strong, readonly)  MacUpdateAppInfoObject                          *appObj;

-(instancetype)initWithAppObject:(MacUpdateAppInfoObject *)appObj withCustomizeConfigure:(MacUpdateUIConfiguration *)configure;

@end

NS_ASSUME_NONNULL_END
