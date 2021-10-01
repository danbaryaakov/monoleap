//
//  SettingsViewController.h
//  xophone
//
//  Created by Dan Bar-Yaakov on 7/29/15.
//  Copyright (c) 2015 Dan Bar-Yaakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController {
    MIDIClientRef client;
    MIDIPortRef outputPort;
}

@end
