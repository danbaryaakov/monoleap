//
//  MIDIConnector.h
//  monoleap
//
//  Created by Dan Bar-Yaakov on 05/11/2015.
//  Copyright © 2015 Dan Bar-Yaakov. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
    Handles all MIDI communication.
 */
@interface MIDIConnector : NSObject

+(id)sharedInstance;

-(void)sendNoteOn:(int)noteNumber inChannel:(int)channel withVelocity:(int)velocity;
-(void)sendNoteOff:(int)noteNumber inChannel:(int)channel withVelocity:(int)velocity;
-(void)sendControllerChange:(int)ccNumber value:(int)value inChannel:(int)channel;
-(void)sendMidi:(Byte*)message;

@end
