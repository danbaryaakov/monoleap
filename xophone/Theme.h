//
//  Theme.h
//  monoleap
//
//  Created by Dan Bar-Yaakov on 26/10/2015.
//  Copyright © 2015 Dan Bar-Yaakov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InstrumentScene.h"

@interface Theme : NSObject

-(void)applyTo:(InstrumentScene*)scene;
-(void)removeFrom:(InstrumentScene*)scene;
-(void)verticalRightChanged:(int)position;
-(void)verticalLeftChanged:(int)position;
-(void)drawLeftHandTouches:(int)pattern touches:(NSArray*)touches;
-(void)drawRightHandTouches:(int)pattern touches:(NSArray*)touches;
-(void)leftHandMoved:(NSArray*)touches;
-(void)rightHandMoved:(NSArray*)touches;

+(instancetype)byName:(NSString*)name;
+(NSString*)description;
+(NSString*)themeDescription:(NSString*)name;

@end
