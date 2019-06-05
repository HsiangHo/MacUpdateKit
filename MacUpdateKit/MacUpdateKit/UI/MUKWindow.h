//
//  MUKWindow.h
//  MacUpdateKit
//
//  Created by Jovi on 5/9/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MUKWindow : NSWindow

@property (nonatomic,strong,readonly)       NSView                     *mainView;

@end

NS_ASSUME_NONNULL_END
