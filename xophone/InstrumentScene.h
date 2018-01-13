//
//  InstrumentScene.h
//  monoleap
//
//  Copyright (c) 2015 Dan Bar-Yaakov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMIDI/CoreMIDI.h>
#import <CoreMotion/CoreMotion.h>
#import "PDPatch.h"

/*!
    @class InstrumentScene
    @discussion The main scene, allowing users to play the instrument.
 
 */
@interface InstrumentScene : SKScene  {
}
@property (strong, nonatomic) PDPatch *patch;



@end
