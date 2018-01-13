//
//  PDPatch.m
//  monoleap
//
//  Created by Itai Matos on 24/11/2015.
//  Copyright © 2015 Dan Bar-Yaakov. All rights reserved.
//

#import "PDPatch.h"

@implementation PDPatch

-(instancetype)initWithFile:(NSString*)pdFile{
    void *patch;
    
    self = [super init];
    if (self) {
        patch = [PdBase openFile:pdFile path:[[NSBundle mainBundle]resourcePath]];
        if (!patch) {
            NSLog(@"Patch faild to load");
        }
    }
    
    return self;
}

-(void)sendMidi:(int)midi andVelocity:(int)velocity{
    
    [PdBase sendNoteOn:midi pitch:midi+20 velocity:velocity];

    NSLog(@"Note:%d", midi);

}

-(void)receiveBangFromSource:(NSString *)source{
    NSLog(@"BNG recieved from PD");
}
@end
