//
//  Theme.m
//  monoleap
//
//  Created by Dan Bar-Yaakov on 26/10/2015.
//  Copyright © 2015 Dan Bar-Yaakov. All rights reserved.
//

#import "Theme.h"
#import "BasicTheme.h"
#import "ColorBurstTheme.h"

@implementation Theme

-(void)verticalLeftChanged:(int)position {}
-(void)verticalRightChanged:(int)position {}
-(void)rightHandMoved:(NSArray *)touches {}
-(void)drawRightHandTouches:(int)pattern touches:(NSArray *)touches {}
-(void)drawLeftHandTouches:(int)pattern touches:(NSArray *)touches {}
-(void)leftHandMoved:(NSArray *)touches {}

+(NSString*)description {
    return @"";
}

+(instancetype)byName:(NSString *)name {
    NSString* className = [self classNameForTheme:name];
    return [[NSClassFromString(className) alloc]init];
}

+(NSString*)classNameForTheme:(NSString*)name {
    if ([name isEqualToString:@"Basic"]) {
        return @"BasicTheme";
    }
    if ([name isEqualToString:@"Color Burst"]) {
        return @"ColorBurstTheme";
    }
    if ([name isEqualToString:@"Calm"]) {
        return @"CalmTheme";
    }
    return nil;
}

+(NSString*)themeDescription:(NSString*)name {
    NSString* className = [self classNameForTheme:name];
    return [NSClassFromString(className) description];
}

-(void)applyTo:(InstrumentScene *)scene {
    
}

-(void)removeFrom:(InstrumentScene *)scene {
    
}

@end
