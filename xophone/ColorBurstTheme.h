//
//  PinkTheme.h
//  monoleap
//
//  Created by Dan Bar-Yaakov on 26/10/2015.
//  Copyright © 2015 Dan Bar-Yaakov. All rights reserved.
//

#import "Theme.h"

@interface ColorBurstTheme : Theme {
    InstrumentScene* parent;
    SKEmitterNode* backgroundParticles;
}

-(void)applyTo:(InstrumentScene*)scene;
-(void)removeFrom:(InstrumentScene*)scene;
-(void)verticalRightChanged:(int)position;
-(void)verticalLeftChanged:(int)position;
-(void)drawParticlesForPattern:(int)pattern touches:(NSArray*)touches particles:(NSMutableDictionary*) particles;
-(void)drawLeftHandTouches:(int)pattern touches:(NSArray*)touches;
-(void)drawRightHandTouches:(int)pattern touches:(NSArray*)touches;
-(void)leftHandMoved:(NSArray*)touches;
-(void)rightHandMoved:(NSArray*)touches;
@end
