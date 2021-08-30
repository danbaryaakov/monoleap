//
//  MIDIConnector.m
//  monoleap
//
//  Created by Dan Bar-Yaakov on 05/11/2015.
//  Copyright © 2015 Dan Bar-Yaakov. All rights reserved.
//

#import "MIDIConnector.h"
#import <CoreMIDI/CoreMIDI.h>

@implementation MIDIConnector {
    MIDIClientRef client;
    MIDIPortRef outputPort;
}

+ (id)sharedInstance {
    static MIDIConnector *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        MIDIClientCreate(CFSTR("Monoleap"), nil, nil, &client);
        MIDIOutputPortCreate(client, CFSTR("MonoLeap Output Port"), &outputPort);
    }
    return self;
}

-(void)sendNoteOn:(int)noteNumber inChannel:(int)channel withVelocity:(int)velocity {
    Byte message[] = {0x90, noteNumber, velocity};
    [self sendMidi:message];
}

-(void)sendNoteOff:(int)noteNumber inChannel:(int)channel withVelocity:(int)velocity {
    Byte message[] = {0x80, noteNumber, 0};
    [self sendMidi:message];
}

-(void) sendControllerChange:(int)ccNumber value:(int)value inChannel:(int)channel {
    Byte message[] = {176, ccNumber, value};
    [self sendMidi:message];
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



@end
