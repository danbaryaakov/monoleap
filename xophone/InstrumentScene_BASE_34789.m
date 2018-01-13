//
//  InstrumentScene.m
//  monoleap
//
//  Created by Dan Bar-Yaakov on 7/18/15.
//  Copyright (c) 2015 Dan Bar-Yaakov. All rights reserved.
//

#import "InstrumentScene.h"
#import "SKTexture+Gradient.h"
#import "SettingsManager.h"
#import "Theme.h"
#import "ColorBurstTheme.h"
#import "BasicTheme.h"

@implementation InstrumentScene {
    MIDIClientRef client;
    MIDIPortRef outputPort;
    int playedNote;
    NSArray *frequencies;

    NSArray* previousArgs;
    NSMutableArray *left, *right;;

    Byte volume, another, pitchBend;

    int prevNote;

    Theme* theme;
    
    int leftXCtrlValue, leftYCtrlValue, rightYCtrlValue, rightXCtrlValue, leftXCurrent, leftYCurrent, rightXCurrent, rightYCurrent;
    bool pitchBendEnabled, keySwitchEnabled, velocityEnabled, leftXCtrlEnabled, leftYCtrlEnabled, rightXCtrlEnabled, rightYCtrlEnabled, isTouchesEnded;
    
    CGFloat lastRightTop, lastLeftTop;
    bool isLeftMuted, isRightMuted;
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
    
    left = [NSMutableArray new];
    right = [NSMutableArray new];
    
    SettingsManager* settings = [SettingsManager sharedInstance];
    leftXCtrlValue = settings.leftXCtrlValue.intValue;
    leftYCtrlValue = settings.leftYCtrlValue.intValue;
    rightYCtrlValue = settings.rightYCtrlValue.intValue;
    rightXCtrlValue = settings.rightXCtrlValue.intValue;
    pitchBendEnabled = settings.pitchBendEnabled.boolValue;
    keySwitchEnabled = settings.keySwitchEnabled.boolValue;
    velocityEnabled = settings.velocityEnabled.boolValue;
    
    leftXCtrlEnabled = settings.leftXCtrlEnabled.boolValue;
    leftYCtrlEnabled = settings.leftYCtrlEnabled.boolValue;
    rightXCtrlEnabled = settings.rightXCtrlEnabled.boolValue;
    rightYCtrlEnabled = settings.rightYCtrlEnabled.boolValue;
    isRightMuted = false;
    isLeftMuted = false;

    if (theme == nil) {
        theme = [Theme byName:settings.themeName];
        [theme applyTo:self];
    }
    
    if (pitchBendEnabled) {
//        [self drawPitchBendArea];
    }
}

-(void)drawPitchBendArea {

    CIColor *rightColor = [CIColor colorWithRed:248.0/255.0 green:182.0/255.0 blue:250.0/255.0 alpha:0.2];
    CIColor *leftColor = [CIColor colorWithRed:248.0/255.0 green:182.0/255.0 blue:250.0/255.0 alpha:0.0];
    SKTexture* backgroundTexture = [SKTexture textureWithVerticalGradientofSize:CGSizeMake(self.frame.size.width/8, self.frame.size.height) topColor:rightColor bottomColor:leftColor];
    SKSpriteNode* backgroundGradient = [[SKSpriteNode alloc] initWithTexture:backgroundTexture];
    backgroundGradient.position =  CGPointMake(self.frame.size.width / 2 - self.frame.size.width / 16, self.frame.size.height / 2);
    [self addChild:backgroundGradient];

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
    
    SEL selector = @selector(handleTouches:);
    [self debounce:selector delay:0.02];
}

/*!
    Called when one or several touches are removed.
 
    @param touches
        All touches, after the removal (unsorted)
    @param event
        The touch event
*/
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [left removeAllObjects];
    [right removeAllObjects];
    NSSet *allTouches = [event touchesForView:self.view];
    for (UITouch *touch in allTouches) {
        if ([touches containsObject:touch]){
            continue;
        }
        CGPoint position = [touch locationInView:self.view];
        CGFloat width = CGRectGetWidth(self.view.bounds);
        if (position.x < width / 2) {
            [left addObject:touch];
        } else {
            [right addObject:touch];
        }
    }
    isTouchesEnded = true;
    SEL selector = @selector(handleTouches:);
    [self debounce:selector delay:0.02];
}

/*!
    Called when there is movement in a current pattern, but no note changes. Updates the X & Y operators on the positions, nad update the theme.
 
    @param touches
        Array of all touches (both hands)
    @param event
        The touch event
 */
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
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
    Byte message[] = {0x90, noteNumber, velocity};
    [self sendMidi:message];
    playedNote = noteNumber;
    //    [self playAudioNote: noteNumber];
}

-(void)noteOff:(int)noteNumber {
    Byte message[] = {0x80, noteNumber, 120};
    [self sendMidi:message];
    //    [self stopAudioNote];
}

-(void)sendMidi:(Byte*)message {
    MIDIPacketList packetList;
    MIDIPacket *packet = MIDIPacketListInit(&packetList);
    MIDIPacketListAdd(&packetList, sizeof(packetList), packet, 0, sizeof(message), message);
    ItemCount destinationCount = MIDIGetNumberOfDestinations();
    for (int i = 0; i < destinationCount; i++) {
        MIDISend(outputPort, MIDIGetDestination(i), &packetList);
    }
}

# pragma mark Touch add / remove processing

/*!
 Handles touches triggered by either an addition or removal of a one or several touches.
 */
-(void)handleTouches:(NSArray *)args {
    
    [self sortTouches:left];
    [self sortTouches:right];
    
    int rightPattern = [self getPattern:right];
    int leftPattern = [self getPattern:left];
    
    int baseNote;
    
    if (rightPattern == 0) {

        // stop audio and clear all visual indication
        [self noteOff:playedNote];
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
    CGFloat leftTopY = [leftTop locationInView:self.view].y;
    CGFloat rightTopY = [rightTop locationInView:self.view].y;
    if (isTouchesEnded) {
        
        
        if (leftTopY - lastLeftTop > 15) {
            isLeftMuted = true;
            [self noteOff:playedNote];
            
            return;
        } else {
            isLeftMuted = false;
        }
        if (leftPattern != 0 && (rightTop == 0 || rightTopY - lastRightTop > 15)) {
            isRightMuted = true;
            [self noteOff:playedNote];
            return;
        } else {
            isRightMuted = false;
        }
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideMenu" object:nil];
    __weak typeof(self) weakSelf = self;
    [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(showMenu) object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideMenu" object:nil];
    switch (leftPattern) {
        case 0:
            [self noteOff:playedNote];
            [theme drawLeftHandTouches:0 touches:left];
            [theme drawRightHandTouches:0 touches:right];
            break;
        case 1:
            prevNote = playedNote;
            [self noteOn:baseNote velocity:[self velocity:[left objectAtIndex:0]]];
            if (prevNote != playedNote) {
                [self noteOff:prevNote];
            }
            break;
        case 2:
            prevNote = playedNote;
            [self noteOn:baseNote + 1 velocity:[self velocity:[left objectAtIndex:0]]];
            if (prevNote != playedNote) {
                [self noteOff:prevNote];
            }
            break;
        case 3:
            prevNote = playedNote;
            [self noteOn:baseNote + 2 velocity:[self velocity:[left objectAtIndex:0]]];
            if (prevNote != playedNote) {
                [self noteOff:prevNote];
            }
            break;
        case 4:
            prevNote = playedNote;
            [self noteOn:baseNote + 3 velocity:[self velocity:[left objectAtIndex:0]]];
            if (prevNote != playedNote) {
                [self noteOff:prevNote];
            }
            break;
        case 5:
            prevNote = playedNote;
            [self noteOn:baseNote + 4 velocity:[self velocity:[left objectAtIndex:0]]];
            if (prevNote != playedNote) {
                [self noteOff:prevNote];
            }
            break;
        case 6:
            prevNote = playedNote;
            [self noteOn:baseNote + 5 velocity:[self velocity:[left objectAtIndex:0]]];
            if (prevNote != playedNote) {
                [self noteOff:prevNote];
            }
            break;
    }
    [theme drawLeftHandTouches:leftPattern touches:left];
    
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
-(int)getPattern:(NSMutableArray *)touches {
    int width = 170;
    if ([touches count] == 0) {
        return 0;
    }
    if ([touches count] == 1) {
        return 1;
    } else if ([touches count] == 2 && [self distance:[touches objectAtIndex:0] second:[touches objectAtIndex:1]] < width) {
        return 2;
    } else if ([touches count] == 2 && [self distance:[touches objectAtIndex:0] second:[touches objectAtIndex:1]] < width * 2) {
        return 4;
    } else if ([touches count] == 3
               && [self distance:[touches objectAtIndex:0] second:[touches objectAtIndex:1]] < width
               && [self distance:[touches objectAtIndex:1] second:[touches objectAtIndex:2]] < width) {
        return 3;
        
    } else if ([touches count] == 3
               && [self distance:[touches objectAtIndex:0] second:[touches objectAtIndex:1]] < width * 2
               && [self distance:[touches objectAtIndex:1] second:[touches objectAtIndex:2]] < width) {
        return 5;
    } else if ([touches count] == 2
               && [self distance:[touches objectAtIndex:0] second:[touches objectAtIndex:1]] < width * 3) {
        return 6;
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
        Byte message[] = {176, leftYCtrlValue , currentVal};
        leftYCurrent = currentVal;
        [self sendMidi:message];
    }

}

/*!
    Handles keyswitch messages (not enabled currently)
 */
-(void)handleKeySwitch: (UITouch*) touch {
    CGPoint location = [touch locationInView:self.view];
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat percent = MIN(100, MAX(0, location.y - height / 4) * 100 / (height / 3));
    if (percent < 33) {
        
        Byte message[] = {0x90, 24, 120};
        [self sendMidi:message];
        Byte offMessage[] = {0x80, 24, 120};
        [self sendMidi:offMessage];

    } else if (percent < 66) {
        Byte message[] = {0x90, 32, 120};
        [self sendMidi:message];
        Byte offMessage[] = {0x80, 32, 120};
        [self sendMidi:offMessage];
    } else {
        Byte message[] = {0x90, 34, 120};
        [self sendMidi:message];
        Byte offMessage[] = {0x80, 34, 120};
        [self sendMidi:offMessage];

    }
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
        Byte message[] = {176, rightYCtrlValue, val};
        rightYCurrent = val;
        [self sendMidi:message];
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
        Byte message[] = {176, rightXCtrlValue , currentMod};
        rightXCurrent = currentMod;
        [self sendMidi:message];
    }
}

-(void)handlePitchBend: (UITouch*) touch {
    CGPoint location = [touch locationInView:self.view];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat percent = MAX(0, location.x - width / 4) * 100 / (width / 4);
    int val = floor(percent * 63 / 100);
    if (val != pitchBend) {
        Byte message[] = {224, 0, 64 + val};
        pitchBend = val;
        [self sendMidi:message];
    }

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
        Byte message[] = {176, leftXCtrlValue , currentMod};
        leftXCurrent = currentMod;
        [self sendMidi:message];
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



