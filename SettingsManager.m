//
//  SettingsManager.m
//  monoleap
//
//  Created by Dan Bar-Yaakov on 8/2/15.
//  Copyright (c) 2015 Dan Bar-Yaakov. All rights reserved.
//

#import "SettingsManager.h"

@implementation SettingsManager

NSString *const LEFT_X_CTRL_VALUE = @"leftXCtrlValue";
NSString *const LEFT_Y_CTRL_VALUE = @"leftYCtrlValue";
NSString *const RIGHT_Y_CTRL_VALUE = @"rightYCtrlValue";
NSString *const RIGHT_X_CTRL_VALUE = @"rightXCtrlValue";
NSString *const PITCH_BEND_ENABLED = @"pitchBendEnabled";
NSString *const KEYSWITCH_ENABLED = @"keySwitchEnabled";
NSString *const VELOCITY_ENABLED = @"velocityEnabled";

NSString *const RIGHT_X_CTRL_ENABLED = @"rightXCtrlEnabled";
NSString *const RIGHT_Y_CTRL_ENABLED = @"rightYCtrlEnabled";
NSString *const LEFT_X_CTRL_ENABLED = @"leftXCtrlEnabled";
NSString *const LEFT_Y_CTRL_ENABLED = @"leftYCtrlEnabled";

NSString *const MIDI_OUT_CH = @"midiOutChannel";
NSString *const SYNTH_ENABLED = @"SynthEnabled";

NSString *const THEME_NAME = @"themeName";
NSString *const FINGER_WIDTH = @"fingerWidth";

+ (id)sharedInstance {
    static SettingsManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        _leftXCtrlValue = [defaults objectForKey:LEFT_X_CTRL_VALUE];
        if (_leftXCtrlValue == nil) {
            _leftXCtrlValue = [NSNumber numberWithInt:1];
        }
        
        _leftYCtrlValue = [defaults objectForKey:LEFT_Y_CTRL_VALUE];
        if (_leftYCtrlValue == nil) {
            _leftYCtrlValue = [NSNumber numberWithInt:71];
        }
        
        _rightYCtrlValue = [defaults objectForKey:RIGHT_Y_CTRL_VALUE];
        if (_rightYCtrlValue == nil) {
            _rightYCtrlValue = [NSNumber numberWithInt:74];
        }
        
        _rightXCtrlValue = [defaults objectForKey:RIGHT_X_CTRL_VALUE];
        if (_rightXCtrlValue == nil) {
            _rightXCtrlValue = [NSNumber numberWithInt: 12];
        }
        
        _pitchBendEnabled = [defaults objectForKey:PITCH_BEND_ENABLED];
        if (_pitchBendEnabled == nil) {
	        _pitchBendEnabled = [NSNumber numberWithBool:true];
        }
        
        _keySwitchEnabled = [defaults objectForKey:KEYSWITCH_ENABLED];
        if (_keySwitchEnabled == nil) {
            _keySwitchEnabled = [NSNumber numberWithBool:false];
        }
        
        _velocityEnabled = [defaults objectForKey:VELOCITY_ENABLED];
        if (_velocityEnabled == nil) {
            _velocityEnabled = [NSNumber numberWithBool:false];
        }
        
        _rightXCtrlEnabled = [defaults objectForKey:RIGHT_X_CTRL_ENABLED];
        if (_rightXCtrlEnabled == nil) {
            _rightXCtrlEnabled = [NSNumber numberWithBool:false];
        }
        
        _rightYCtrlEnabled = [defaults objectForKey:RIGHT_Y_CTRL_ENABLED];
        if (_rightYCtrlEnabled == nil) {
            _rightYCtrlEnabled = [NSNumber numberWithBool:true];
        }
        
        _leftXCtrlEnabled = [defaults objectForKey:LEFT_X_CTRL_ENABLED];
        if (_leftXCtrlEnabled == nil) {
            _leftXCtrlEnabled = [NSNumber numberWithBool:true];
        }
        
        _leftYCtrlEnabled = [defaults objectForKey:LEFT_Y_CTRL_ENABLED];
        if (_leftYCtrlEnabled == nil) {
            _leftYCtrlEnabled = [NSNumber numberWithBool:true];
        }

        _themeName = [defaults objectForKey:THEME_NAME];
        if (_themeName == nil) {
            _themeName = @"Basic";
        }
        
  
        _midiOutChannel = [defaults objectForKey:MIDI_OUT_CH];
        if (_midiOutChannel == nil) {
            _midiOutChannel = [NSNumber numberWithInteger:1];
        }
        
        _synthEnabled = [defaults objectForKey:SYNTH_ENABLED];
        if (_synthEnabled == nil) {
            _synthEnabled = [NSNumber numberWithBool: true];
        }
        
        _fingerWidth = [defaults objectForKey:FINGER_WIDTH];
        if (_fingerWidth == nil) {
            _fingerWidth = [NSNumber numberWithFloat:136];
        }
        
    }
    return self;
}

- (void)dealloc {

}


@end

