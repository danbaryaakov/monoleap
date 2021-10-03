//
//  InstrumentScene.m
//  monoleap
//
//  Created by Dan Bar-Yaakov on 7/18/15.
//  Copyright (c) 2015 Dan Bar-Yaakov. All rights reserved.
//

#import "InstrumentSceneOld.h"
#import "SKTexture+Gradient.h"
//#import "SettingsManager.h"
#import "Theme.h"
#import "ColorBurstTheme.h"
//#import "BasicTheme.h"
//#import "MIDIConnector.h"
#import "monoleap-Swift.h"

@implementation InstrumentSceneOld {
    MIDIClientRef client;
    MIDIPortRef outputPort;
    int playedNote;
    NSArray *frequencies;

    NSArray* previousArgs;
    NSMutableArray *left, *right;;

    Byte volume, another, pitchBend;
    
    MIDIConnector* midiConnector;
    
    float fingerWidth;
    
    int prevNote;

    ColorBurstTheme* theme;
    
    int leftXCtrlValue, leftYCtrlValue, rightYCtrlValue, rightXCtrlValue, leftXCurrent, leftYCurrent, rightXCurrent, rightYCurrent;
    bool pitchBendEnabled, keySwitchEnabled, velocityEnabled, leftXCtrlEnabled, leftYCtrlEnabled, rightXCtrlEnabled, rightYCtrlEnabled, isTouchesEnded, PDEnabled, isInvalidPattern;
    
    bool synthEnabled;
    
    CGFloat lastRightTop, lastLeftTop;
    bool isLeftMuted, isRightMuted;
    
    SKSpriteNode* rectFingerOneLeft;
    SKSpriteNode* rectFingerTwoLeft;
    SKSpriteNode* rectFingerThreeLeft;
    SKSpriteNode* rectFingerFourLeft;
    
    SKSpriteNode* rectFingerOneRight;
    SKSpriteNode* rectFingerTwoRight;
    SKSpriteNode* rectFingerThreeRight;
    SKSpriteNode* rectFingerFourRight;
    
}

# pragma mark Initialization

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
      
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    MIDIClientCreate(CFSTR("Xophone"), nil, nil, &client);
    MIDIOutputPortCreate(client, CFSTR("Xophone Output Port"), &outputPort);
    self.backgroundColor = [SKColor blackColor];
    
    midiConnector = [MIDIConnector sharedInstance];
    left = [NSMutableArray new];
    right = [NSMutableArray new];
    
    fingerWidth = 130;
    leftXCtrlValue = 60;
    leftYCtrlValue = 71;
    rightYCtrlValue = 0;
    rightXCtrlValue = 0;
    pitchBendEnabled = false;
    keySwitchEnabled = false;
    velocityEnabled = false;
    
    leftXCtrlEnabled = false;
    leftYCtrlEnabled = false;
    rightXCtrlEnabled = false;
    rightYCtrlEnabled = false;
    isRightMuted = false;
    isLeftMuted = false;
    synthEnabled = true;
    
    if (theme == nil) {
        theme = [ColorBurstTheme byName:@""];
        [theme applyTo:self];
    }
    
    if (pitchBendEnabled) {
//        [self drawPitchBendArea];
    }
    if (synthEnabled) {
//        SynthManager.instance;
    }
//    self.patch = [[PDPatch alloc]initWithFile:@"MidiSyth.pd"];
}

-(void)drawPitchBendArea {

    CIColor *rightColor = [CIColor colorWithRed:248.0/255.0 green:182.0/255.0 blue:250.0/255.0 alpha:0.2];
    CIColor *leftColor = [CIColor colorWithRed:248.0/255.0 green:182.0/255.0 blue:250.0/255.0 alpha:0.0];
    SKTexture* backgroundTexture = [SKTexture textureWithHorizontalGradientofSize:CGSizeMake(self.frame.size.width/8, self.frame.size.height) topColor:rightColor bottomColor:leftColor];
    SKSpriteNode* backgroundGradient = [[SKSpriteNode alloc] initWithTexture:backgroundTexture];
    backgroundGradient.position =  CGPointMake(self.frame.size.width / 2 - self.frame.size.width / 16, self.frame.size.height / 2);
    [self addChild:backgroundGradient];

}

-(void)drawPatternGuides {
    if ([left count] > 0) {
        UITouch *topRight = [left firstObject];
        int leftTop = [topRight locationInView:self.view].y;
        if (rectFingerOneLeft == nil) {
            rectFingerOneLeft = [self createGradientRect:self.size.width / 2 - 20 height:fingerWidth];
            rectFingerTwoLeft = [self createGradientRect:self.size.width / 2 - 20 height:fingerWidth];
            rectFingerThreeLeft = [self createGradientRect:self.size.width / 2 - 20 height:fingerWidth];
            rectFingerFourLeft = [self createGradientRect:self.size.width / 2 - 20 height:fingerWidth * 2];
            
            [self addChild:rectFingerOneLeft];
            [self addChild:rectFingerTwoLeft];
            [self addChild:rectFingerThreeLeft];
            [self addChild:rectFingerFourLeft];
        }
        rectFingerOneLeft.position = CGPointMake(self.size.width / 4, self.size.height - leftTop);
        
        rectFingerTwoLeft.position = CGPointMake(self.size.width / 4, self.size.height - leftTop - fingerWidth);
        
        rectFingerThreeLeft.position = CGPointMake(self.size.width / 4, self.size.height - leftTop - fingerWidth * 2);
        
        rectFingerFourLeft.position = CGPointMake(self.size.width / 4, self.size.height - leftTop - fingerWidth * 3.5);
        
        [rectFingerOneLeft setHidden:false];
        [rectFingerOneLeft setSize:CGSizeMake(self.size.width / 2 - 20, fingerWidth) ];
        [rectFingerTwoLeft setHidden:false];
        [rectFingerTwoLeft setSize:CGSizeMake(self.size.width / 2 - 20, fingerWidth) ];
        [rectFingerThreeLeft setHidden:false];
        [rectFingerThreeLeft setSize:CGSizeMake(self.size.width / 2 - 20, fingerWidth) ];
        [rectFingerFourLeft setHidden:false];
        [rectFingerFourLeft setSize:CGSizeMake(self.size.width / 2 - 20, fingerWidth * 2) ];
        
    } else {
        [rectFingerOneLeft setHidden:true];
        [rectFingerTwoLeft setHidden:true];
        [rectFingerThreeLeft setHidden:true];
        [rectFingerFourLeft setHidden:true];
    }
    
    if ([right count] > 0) {
        UITouch *topRight = [right firstObject];
        int rightTop = [topRight locationInView:self.view].y;
        if (rectFingerOneRight == nil) {
            rectFingerOneRight = [self createGradientRect:self.size.width / 2 - 20 height:fingerWidth];
            rectFingerTwoRight = [self createGradientRect:self.size.width / 2 - 20 height:fingerWidth];
            rectFingerThreeRight = [self createGradientRect:self.size.width / 2 - 20 height:fingerWidth];
            rectFingerFourRight = [self createGradientRect:self.size.width / 2 - 20 height:fingerWidth * 2];
            
            [self addChild:rectFingerOneRight];
            [self addChild:rectFingerTwoRight];
            [self addChild:rectFingerThreeRight];
            [self addChild:rectFingerFourRight];
        }
        rectFingerOneRight.position = CGPointMake(self.size.width * 3/4, self.size.height - rightTop);
        
        rectFingerTwoRight.position = CGPointMake(self.size.width * 3/4, self.size.height - rightTop - fingerWidth);
        
        rectFingerThreeRight.position = CGPointMake(self.size.width * 3/4, self.size.height - rightTop - fingerWidth * 2);
        
        rectFingerFourRight.position = CGPointMake(self.size.width * 3/4, self.size.height - rightTop - fingerWidth * 3.5);
        
        [rectFingerOneRight setHidden:false];
        [rectFingerOneRight setSize:CGSizeMake(self.size.width / 2 - 20, fingerWidth) ];
        [rectFingerTwoRight setHidden:false];
        [rectFingerTwoRight setSize:CGSizeMake(self.size.width / 2 - 20, fingerWidth) ];
        [rectFingerThreeRight setHidden:false];
        [rectFingerThreeRight setSize:CGSizeMake(self.size.width / 2 - 20, fingerWidth) ];
        [rectFingerFourRight setHidden:false];
        [rectFingerFourRight setSize:CGSizeMake(self.size.width / 2 - 20, fingerWidth * 2) ];
        
    } else {
        [rectFingerOneRight setHidden:true];
        [rectFingerTwoRight setHidden:true];
        [rectFingerThreeRight setHidden:true];
        [rectFingerFourRight setHidden:true];
    }
}

-(SKSpriteNode*)createGradientRect:(int)width height:(int)height {
    CIColor *topColor = [CIColor colorWithRed:248.0/255.0 green:182.0/255.0 blue:250.0/255.0 alpha:0.15];
    CIColor *btmColor = [CIColor colorWithRed:248.0/255.0 green:182.0/255.0 blue:250.0/255.0 alpha:0.01];
    SKTexture* backgroundTexture = [SKTexture textureWithVerticalGradientofSize:CGSizeMake(width , height) topColor:topColor bottomColor:btmColor];
    
    return [[SKSpriteNode alloc] initWithTexture:backgroundTexture];
}

# pragma mark Touch event callbacks

/*!
    Called when one or several new touches are detected.
    
    @param touches
        All touches (unsorted)
    @param event
        The touch event
*/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches Began");
    bool noPatternPreviouslyPlayed = [left count] == 0;
    [left removeAllObjects];
    [right removeAllObjects];
    NSSet *allTouches = [event touchesForView:self.view];
    int index = 0;
    for (UITouch *touch in allTouches) {
        CGPoint position = [touch locationInView:self.view];
        CGFloat width = CGRectGetWidth(self.view.bounds);
        if (position.x < width / 2) {
            [left addObject:touch];
        } else {
            [right addObject:touch];
        }
        index++;
    }
    isTouchesEnded = false;
    isInvalidPattern = false;
    SEL selector = @selector(handleTouches:);
    [self debounce:selector delay:noPatternPreviouslyPlayed ? 0.015: 0.05];
}

/*!
    Called when one or several touches are removed.
 
    @param touches
        All touches, after the removal (unsorted)
    @param event
        The touch event
*/
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"Touches Ended");
    [left removeAllObjects];
    [right removeAllObjects];
    NSSet *allTouches = [event touchesForView:self.view];
    
    bool allTouchesRemoved = [allTouches count] == 0;
    
    int touchesMinY = INT_MAX;
    int removedTouchMinY = INT_MAX;
    
    for (UITouch *touch in allTouches) {
        CGPoint position = [touch locationInView:self.view];
        CGFloat width = CGRectGetWidth(self.view.bounds);
        
        if ([touches containsObject:touch]){
            // removed touch
            CGPoint position = [touch locationInView:self.view];
            NSLog(@"Removed touch position: %f, %f", position.x, position.y);
            if (position.x < width / 2) {
                removedTouchMinY = MIN(removedTouchMinY, position.y);
            }
            continue;
        }
        
        if (position.x < width / 2) {
            [left addObject:touch];
            touchesMinY = MIN(touchesMinY, position.y);
        } else {
            [right addObject:touch];
        }
    }
    isTouchesEnded = true;
    NSLog(@"removedTouchMinY = %d, touchesMinY = %d", removedTouchMinY, touchesMinY);
    if (removedTouchMinY < touchesMinY) {
        NSLog(@"Invalid pattern found (accidentally released topmost right touch");
        isInvalidPattern = true;
    }
    SEL selector = @selector(handleTouches:);
    
    // if no previous pattern was played before these touches, use
    // a smaller debounce value, because there is little risk of accidental notes
    [self debounce:selector delay:allTouchesRemoved ? 0 : 0.05];
}

/*!
    Called when there is movement in a current pattern, but no note changes. Updates the X & Y operators on the positions, nad update the theme.
 
    @param touches
        Array of all touches (both hands)
    @param event
        The touch event
 */
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (isInvalidPattern) {
        return;
    }
    [left removeAllObjects];
    [right removeAllObjects];
    NSSet *allTouches = [event touchesForView:self.view];
    int index = 0;
    for (UITouch *touch in allTouches) {
        CGPoint position = [touch locationInView:self.view];
        CGFloat width = CGRectGetWidth(self.view.bounds);
        if (position.x < width / 2) {
            [left addObject:touch];
        } else {
            [right addObject:touch];
        }
        index++;
    }
    [self sortTouches:left];
    [self sortTouches:right];
    [theme leftHandMoved:left];
    [theme rightHandMoved:right];
    [self drawPatternGuides];
    
    UITouch *topRight = [left firstObject];
    lastRightTop = [topRight locationInView:self.view].y;
    
    if ([right count] > 0 && [left count] > 0) {
        [self handleLeftYCtrl:right.firstObject];
        [self handleLeftXCtrl:right.firstObject isMoved:true];
        [self handleRightYCtrl:left.firstObject];
        [self handleRightXCtrl:left.firstObject];
    }
}

# pragma mark Midi

-(void)noteOn:(int)noteNumber velocity:(int)velocity{
//    if (playedNote == noteNumber) {
//        return;
//    }
    [midiConnector sendNoteOn:noteNumber inChannel:1 withVelocity:velocity];
    playedNote = noteNumber;
    [self sendMidiToPDwithNoteNumner:noteNumber andVelocity:velocity];
    if (synthEnabled) {
//        [SynthManager.instance noteOn:noteNumber];
    }
}

-(void)noteOff:(int)noteNumber isOtherNotePlaying:(bool)otherNotePlaying {
    [midiConnector sendNoteOff:noteNumber inChannel:1 withVelocity:120];
    if (! otherNotePlaying) {
        [self sendMidiToPDwithNoteNumner:noteNumber andVelocity:0];
    }
    if (synthEnabled) {
//        [SynthManager.instance noteOff:noteNumber];
    }
}


-(void)sendMidiToPDwithNoteNumner:(int)noteNumber andVelocity:(int)velocity{
    if (PDEnabled) {
        NSLog(@"PD Enabled");
        NSLog(@"Send note number %d and velocity %d", noteNumber, velocity);
//        [_patch sendMidi:noteNumber andVelocity:velocity];
    }
    else{
        NSLog(@"PD Disabled");
    }
}

# pragma mark Touch add / remove processing

/*!
 Handles touches triggered by either an addition or removal of a one or several touches.
 */
-(void)handleTouches:(NSArray *)args {
    NSLog(@"handleTouches()");
    [self hideMenu];
    
    [self sortTouches:left];
    [self sortTouches:right];
    [self drawPatternGuides];
    int rightPattern = [self getPattern:right withAux:true];
    int leftPattern = [self getPattern:left withAux:true];
    
    int baseNote;
    
    if (leftPattern == 8) {
        // calibrate
        [self debounce:@selector(callibrate) delay:1];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(callibrate) object:nil];
    }
    
    if (isInvalidPattern || rightPattern <= 0) {

        // stop audio and clear all visual indication
        [self noteOff:playedNote isOtherNotePlaying:false];
        [theme drawLeftHandTouches:0 touches:left];
        [theme drawRightHandTouches:0 touches:right];
        
        // Show the menu after a while
        [self debounce:@selector(showMenu) delay:1];
        
        return;
        
    } else {
        [theme drawRightHandTouches:rightPattern touches:right];
        baseNote = 48 + 6 * (rightPattern - 1);
    }
    
    
    
    UITouch *leftTop = [right firstObject];
    UITouch *rightTop = [left firstObject];
//    CGFloat leftTopY = [leftTop locationInView:self.view].y;
//    CGFloat rightTopY = [rightTop locationInView:self.view].y;
    if (isTouchesEnded) {
        
//        
//        if (leftTopY - lastLeftTop > 15) {
//            isLeftMuted = true;
//            [self noteOff:playedNote];
//            
//            return;
//        } else {
//            isLeftMuted = false;
//        }
//        if (leftPattern != 0 && (rightTop == 0 || rightTopY - lastRightTop > 15)) {
//            isRightMuted = true;
//            [self noteOff:playedNote];
//            return;
//        } else {
//            isRightMuted = false;
//        }
    } else {
        isLeftMuted = false;
        isRightMuted = false;
    }
    lastLeftTop = [leftTop locationInView:self.view].y;
    lastRightTop = [rightTop locationInView:self.view].y;
    
    if (! isTouchesEnded && rightPattern != 0 && leftPattern != 0) {
        [self handleLeftYCtrl:right.firstObject];
        [self handleLeftXCtrl:right.firstObject isMoved:false];
        [self handleRightYCtrl:left.firstObject];
        [self handleRightXCtrl:left.firstObject];
    }
    
    switch (leftPattern) {
        case 0:
            [self noteOff:playedNote isOtherNotePlaying:false];
            [theme drawLeftHandTouches:0 touches:left];
            [theme drawRightHandTouches:0 touches:right];
            break;
        case 1:
            prevNote = playedNote;
            [self noteOn:baseNote velocity:[self velocity:[left objectAtIndex:0]]];
            if (prevNote != playedNote) {
                [self noteOff:prevNote isOtherNotePlaying:true];
            }
            break;
        case 2:
            prevNote = playedNote;
            [self noteOn:baseNote + 1 velocity:[self velocity:[left objectAtIndex:0]]];
            if (prevNote != playedNote) {
                [self noteOff:prevNote isOtherNotePlaying:true];
            }
            break;
        case 3:
            prevNote = playedNote;
            [self noteOn:baseNote + 2 velocity:[self velocity:[left objectAtIndex:0]]];
            if (prevNote != playedNote) {
                [self noteOff:prevNote isOtherNotePlaying:true];
            }
            break;
        case 4:
            prevNote = playedNote;
            [self noteOn:baseNote + 3 velocity:[self velocity:[left objectAtIndex:0]]];
            if (prevNote != playedNote) {
                [self noteOff:prevNote isOtherNotePlaying:true];
            }
            break;
        case 5:
            prevNote = playedNote;
            [self noteOn:baseNote + 4 velocity:[self velocity:[left objectAtIndex:0]]];
            if (prevNote != playedNote) {
                [self noteOff:prevNote isOtherNotePlaying:true];
            }
            break;
        case 6:
            prevNote = playedNote;
            [self noteOn:baseNote + 5 velocity:[self velocity:[left objectAtIndex:0]]];
            if (prevNote != playedNote) {
                [self noteOff:prevNote isOtherNotePlaying:true];
            }
            break;
    }
    [theme drawLeftHandTouches:leftPattern touches:left];
    
}

-(void)callibrate {
    float firstDistance = [self distance:[left objectAtIndex:0] second:[left objectAtIndex:1]];
    float secondDistance = [self distance:[left objectAtIndex:1] second:[left objectAtIndex:2]];
    NSLog(@"First distance: %f, Second: %f", firstDistance, secondDistance);
    fingerWidth = (firstDistance + secondDistance) / 2;
//    SettingsManager.fingerWidth = fingerWidth;
    NSLog(@"Calibrate --> new finger width is %f", fingerWidth);
    [self drawPatternGuides];
}

-(void)hideMenu {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideMenu" object:nil];
    __weak typeof(self) weakSelf = self;
    [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(showMenu) object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideMenu" object:nil];
    
}

/*!
    Sorts a given array of touches by vertical screen position (top to bottom).
*/
-(void)sortTouches:(NSMutableArray *)touches {
    [touches sortUsingComparator:^NSComparisonResult(id a, id b) {
        CGPoint firstLoc = [(UITouch*)a locationInView:self.view];
        CGPoint secondLoc = [(UITouch*)b locationInView:self.view];
        if (firstLoc.y < secondLoc.y) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if (firstLoc.y > secondLoc.y) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
}


/*!
    Analyzes the given array of (already sorted) touches and returns a pattern if one is matched.
 
    @param touches
        An array of touches of a given hand (up to 4)
*/
-(int)getPattern:(NSMutableArray *)touches withAux:(bool)withAux {
    
    if ([touches count] == 0) {
        return 0;
    }
    if ([touches count] == 1) {
        return 1;
    } else if ([touches count] == 2 && [self distance:[touches objectAtIndex:0] second:[touches objectAtIndex:1]] < fingerWidth * 1.5) {
        return 2;
    } else if ([touches count] == 2 && [self distance:[touches objectAtIndex:0] second:[touches objectAtIndex:1]] < fingerWidth * 2.5) {
        return 4;
    } else if ([touches count] == 3
               && [self distance:[touches objectAtIndex:0] second:[touches objectAtIndex:1]] < fingerWidth * 1.5
               && [self distance:[touches objectAtIndex:0] second:[touches objectAtIndex:2]] < fingerWidth * 2.5) {
        return 3;
        
    } else if ([touches count] == 3
               && [self distance:[touches objectAtIndex:0] second:[touches objectAtIndex:1]] < fingerWidth * 2.5
               && [self distance:[touches objectAtIndex:0] second:[touches objectAtIndex:1]] > fingerWidth * 1.5
               && [self distance:[touches objectAtIndex:1] second:[touches objectAtIndex:2]] < fingerWidth * 2.5) {
        return 5;
    } else if ([touches count] == 2
               && [self distance:[touches objectAtIndex:0] second:[touches objectAtIndex:1]] < fingerWidth * 4.5) {
        return 6;
    } else if ([touches count] == 3
               && [self distance:[touches objectAtIndex:0] second: [touches objectAtIndex:1]] < fingerWidth * 1.5
               && [self distance:[touches objectAtIndex:1] second: [touches objectAtIndex:2]] < fingerWidth * 2.5) {
        return 7;
    } else if ([touches count] == 4) {
        return 8;
    }
    return -1;
}

# pragma mark Operator handling
/*!
    Updates the Left hand Y axis modifier according to the touch vertical position.
    
    @param touch
        The touch object associated with the left hand's first finger.
*/
-(void)handleLeftYCtrl:(UITouch*)touch {
    if (! leftYCtrlEnabled || isLeftMuted) {
        return;
    }
    CGPoint location = [touch locationInView:self.view];
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat percent = MIN(MAX(0, location.y - height / 4) * 100 / (height / 3), 100);
    int currentVal = floor(percent * 127 / 100);
    [theme verticalLeftChanged:currentVal];
    if (currentVal != leftYCurrent) {
        leftYCurrent = currentVal;
        [midiConnector sendControllerChange:leftYCtrlValue value:currentVal inChannel:1];
        if (synthEnabled) {
//            [SynthManager.instance resonance:currentVal];
        }
    }

}



/*!
    Handles keyswitch messages (not enabled currently)
 */
-(void)handleKeySwitch: (UITouch*) touch {
//    CGPoint location = [touch locationInView:self.view];
//    CGFloat height = CGRectGetHeight(self.view.bounds);
//    CGFloat percent = MIN(100, MAX(0, location.y - height / 4) * 100 / (height / 3));
//    if (percent < 33) {
//        
//        Byte message[] = {0x90, 24, 120};
//        [self sendMidi:message];
//        Byte offMessage[] = {0x80, 24, 120};
//        [self sendMidi:offMessage];
//
//    } else if (percent < 66) {
//        Byte message[] = {0x90, 32, 120};
//        [self sendMidi:message];
//        Byte offMessage[] = {0x80, 32, 120};
//        [self sendMidi:offMessage];
//    } else {
//        Byte message[] = {0x90, 34, 120};
//        [self sendMidi:message];
//        Byte offMessage[] = {0x80, 34, 120};
//        [self sendMidi:offMessage];
//
//    }
}

-(void)handleRightYCtrl: (UITouch*) touch {

    if (keySwitchEnabled) {
        [self handleKeySwitch:touch];
        return;
    }
    if (! rightYCtrlEnabled || isRightMuted) {
        return;
    }
    CGPoint location = [touch locationInView:self.view];
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat percent = MIN(100, MAX(0, location.y - height / 4) * 100 / (height / 3));
    int val = floor(percent * 127 / 100);
    [theme verticalRightChanged:val];
    if (val != rightYCurrent) {
        rightYCurrent = val;
        [midiConnector sendControllerChange:rightYCtrlValue value:val inChannel:1];
        if (synthEnabled) {
//            [SynthManager.instance filterCutoff:val];
        }
    }
}

-(void)handleRightXCtrl: (UITouch*) touch {
    if (pitchBendEnabled) {
        [self handlePitchBend:touch];
        return;
    }
    if (! rightXCtrlEnabled) {
        return;
    }
    CGPoint location = [touch locationInView:self.view];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat percent = MIN(100, MAX(0, location.x * 100 / (width / 2)));
    int currentMod = floor(percent * 127 / 100);
    if (currentMod != rightXCurrent) {
        rightXCurrent = currentMod;
        [midiConnector sendControllerChange:rightXCtrlValue value:currentMod inChannel:1];
    }
}

-(void)handlePitchBend: (UITouch*) touch {
//    CGPoint location = [touch locationInView:self.view];
//    CGFloat width = CGRectGetWidth(self.view.bounds);
//    CGFloat percent = MAX(0, location.x - width / 4) * 100 / (width / 4);
//    int val = floor(percent * 63 / 100);
//    if (val != pitchBend) {
//        Byte message[] = {224, 0, 64 + val};
//        pitchBend = val;
//        [midiConnector sendMidi:message];
//    }
}

-(void)handleLeftXCtrl:(UITouch*)touch isMoved:(bool)moved{
    if (! leftXCtrlEnabled) {
        return;
    }
    CGPoint location = [touch locationInView:self.view];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat percent = MAX(0, MIN(100, (width - location.x) * 100 / (width / 2)));
    int currentMod = floor(percent * 127 / 100);
    if (currentMod != leftXCurrent) {
        leftXCurrent = currentMod;
        [midiConnector sendControllerChange:leftXCtrlValue value:currentMod inChannel:1];
    }


}

# pragma mark Lifecycle

-(void)showMenu {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showMenu" object:nil];
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

# pragma mark Utilities

-(int)velocity:(UITouch *)touch {
    if (velocityEnabled) {
        CGPoint location = [touch locationInView:self.view];
        CGFloat width = CGRectGetWidth(self.view.bounds);
        CGFloat percent = location.x * 100 / (width / 2);
        int velocity = floor(percent * 127 / 100) + 20;
        return velocity;
    }
    return 100;
}

-(CGFloat)distance:(UITouch *)first second:(UITouch *)second {
    CGPoint firstLocation = [first locationInView:self.view];
    CGPoint secondLocation = [second locationInView:self.view];
    return secondLocation.y - firstLocation.y;
}


- (void)debounce:(SEL)action delay:(NSTimeInterval)delay
{
    __weak typeof(self) weakSelf = self;
    NSArray * args = nil;
    [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:action object:previousArgs];
    [weakSelf performSelector:action withObject:args afterDelay:delay];
}

@end



