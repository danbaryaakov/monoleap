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

-(void)applyTo:(SKScene*)scene;
-(void)removeFrom:(InstrumentScene*)scene;
-(void)verticalRightChanged:(int)position;
-(void)verticalLeftChanged:(int)position;
-(void)drawLeftHandTouches:(int)pattern touches:(NSArray<UITouch*>*)touches;
-(void)drawRightHandTouches:(int)pattern touches:(NSArray<UITouch*>*)touches;
-(void)leftHandMoved:(NSArray<UITouch*>*)touches;
-(void)rightHandMoved:(NSArray<UITouch*>*)touches;

+(instancetype)byName:(NSString*)name;
+(NSString*)description;
+(NSString*)themeDescription:(NSString*)name;

@end
