//
//  SettingsManager.h
//  monoleap
//
//  Created by Dan Bar-Yaakov on 8/2/15.
//  Copyright (c) 2015 Dan Bar-Yaakov. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
    @class SettingsManager
 
    @discussion Settings manager (singleton).
                Takes care of persisting and retrieving all settings.
*/
@interface SettingsManager : NSObject {

}

@property (nonatomic, retain) NSString *themeName;
@property (nonatomic, retain) NSNumber *leftXCtrlValue;
@property (nonatomic, retain) NSNumber *leftYCtrlValue;
@property (nonatomic, retain) NSNumber *rightYCtrlValue;
@property (nonatomic, retain) NSNumber *rightXCtrlValue;

@property (nonatomic, retain) NSNumber *leftXCtrlEnabled;
@property (nonatomic, retain) NSNumber *leftYCtrlEnabled;
@property (nonatomic, retain) NSNumber *rightXCtrlEnabled;
@property (nonatomic, retain) NSNumber *rightYCtrlEnabled;

@property (nonatomic, retain) NSNumber *pitchBendEnabled;
@property (nonatomic, retain) NSNumber *keySwitchEnabled;
@property (nonatomic, retain) NSNumber *velocityEnabled;
@property (nonatomic, retain) NSNumber *midiOutChannel;

@property (nonatomic, retain) NSNumber *synthEnabled;

+ (id)sharedInstance;

@end
