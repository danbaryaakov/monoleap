//
//  AppDelegate.h
//  monoleap
//
//  Created by Dan Bar-Yaakov on 7/21/15.
//  Copyright (c) 2015 Dan Bar-Yaakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdAudioController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PdAudioController *pd;

@end

