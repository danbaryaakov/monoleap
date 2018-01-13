//
//  PinkTheme.m
//  monoleap
//
//  Created by Dan Bar-Yaakov on 26/10/2015.
//  Copyright © 2015 Dan Bar-Yaakov. All rights reserved.
//

#import "BasicTheme.h"

@implementation BasicTheme {
    NSMutableDictionary* leftParticles;
    NSMutableDictionary* rightParticles;
}

-(void)applyTo:(InstrumentScene *)scene {
    parent = scene;
    leftParticles = [NSMutableDictionary new];
    rightParticles = [NSMutableDictionary new];
}

-(void)removeFrom:(InstrumentScene *)scene {
    parent = nil;
}

-(void)verticalRightChanged:(int)position {

}

-(void)verticalLeftChanged:(int)position {

}
+(NSString*)description {
    return @"Finger colors reflect patterns (as in the Getting Started guide)";
}

-(void)drawRightHandTouches:(int)pattern touches:(NSArray*)touches {
    [self drawParticlesForPattern:pattern touches:touches particles:rightParticles];
}

-(void)drawLeftHandTouches:(int)pattern touches:(NSArray*)touches {
    [self drawParticlesForPattern:pattern touches:touches particles:leftParticles];
}

-(void)leftHandMoved:(NSArray *)touches {
    [self adjustParticlePositions:leftParticles touches:touches];
}

-(void)rightHandMoved:(NSArray *)touches {
    [self adjustParticlePositions:rightParticles touches:touches];
}

-(void)drawParticlesForPattern:(int)pattern touches:(NSArray*)touches particles:(NSMutableDictionary*) particles {
    switch (pattern) {
        case 0:
            [self hideParticle:0 particles:particles];
            [self hideParticle:1 particles:particles];
            [self hideParticle:2 particles:particles];
            [self hideParticle:3 particles:particles];
            break;
        case 1:
            [self drawParticle:0 touch:[touches objectAtIndex:0] particles:particles color: [UIColor blueColor]];
            [self hideParticle:1 particles:particles];
            [self hideParticle:2 particles:particles];
            [self hideParticle:3 particles:particles];
            break;
        case 2:
            [self drawParticle:0 touch:[touches objectAtIndex:0] particles:particles color: [UIColor cyanColor]];
            [self drawParticle:1 touch:[touches objectAtIndex:1] particles:particles color: [UIColor cyanColor]];
            [self hideParticle:2 particles:particles];
            [self hideParticle:3 particles:particles];
            break;
        case 3:
            [self drawParticle:0 touch:[touches objectAtIndex:0] particles:particles color: [UIColor greenColor]];
            [self drawParticle:1 touch:[touches objectAtIndex:1] particles:particles color: [UIColor greenColor]];
            [self drawParticle:2 touch:[touches objectAtIndex:2] particles:particles color: [UIColor greenColor]];
            [self hideParticle:3 particles:particles];
            break;
        case 4:
            [self drawParticle:0 touch:[touches objectAtIndex:0] particles:particles color: [UIColor yellowColor]];
            [self hideParticle:1 particles:particles];
            [self hideParticle:2 particles:particles];
            [self drawParticle:3 touch:[touches objectAtIndex:1] particles:particles color: [UIColor yellowColor]];
            break;
        case 5:
            [self drawParticle:0 touch:[touches objectAtIndex:0] particles:particles color: [UIColor purpleColor]];
            [self hideParticle:1 particles:particles];
            [self drawParticle:2 touch:[touches objectAtIndex:1] particles:particles color: [UIColor purpleColor]];
            [self drawParticle:3 touch:[touches objectAtIndex:2] particles:particles color: [UIColor purpleColor]];
            break;
        case 6:
            [self drawParticle:0 touch:[touches objectAtIndex:0] particles:particles color: [UIColor redColor]];
            [self hideParticle:1 particles:particles];
            [self hideParticle:2 particles:particles];
            [self drawParticle:3 touch:[touches objectAtIndex:1] particles:particles color: [UIColor redColor]];
            break;
    }
    
}


-(void)drawParticle:(int)touchIndex touch:(UITouch*)touch particles:(NSMutableDictionary*) particles color:(SKColor*) color {
    CGPoint position = [touch locationInNode:parent];
    SKEmitterNode *particle = [particles objectForKey:[NSNumber numberWithInt:touchIndex]];
    if (particle == nil) {
        NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"Spark" ofType:@"sks"];
        particle = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
        [particles setValue:particle forKey:[NSNumber numberWithInt:touchIndex]];
        particle.position = position;
        particle.name = @"Fire";
        particle.targetNode = parent.scene;
        [particle setHidden:false];
        [parent addChild:particle];
    } else {
        particle.hidden = false;
        particle.position = position;
        [particle setHidden:false];
    }
    [particle setParticleBirthRate:600];
    particle.particleColorSequence = nil;
    particle.particleColorBlendFactor = 1.0;
    particle.particleAlpha = 1.0;
    particle.particleColor = color;
    
}

-(void)adjustParticlePositions:(NSMutableDictionary*)particles touches:(NSArray*)touches {
    NSArray *sortedKeys = [[particles allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }}];
    
    int idx = 0;
    for (id key in sortedKeys) {
        SKEmitterNode* node = [particles objectForKey:key];
        if (node.hidden == false && idx < touches.count) {
            UITouch* touch = [touches objectAtIndex:idx];
            CGPoint position = [touch locationInNode:parent];
            node.position = position;
            idx++;
        }
    }
}


-(void)hideParticle:(int)touchIndex particles:(NSMutableDictionary*)particles {
    SKEmitterNode *particle = [particles objectForKey:[NSNumber numberWithInt:touchIndex]];
    if (particle != nil) {
        [particle setParticleBirthRate:0];
        [particle setHidden:true];
    }
}

-(void)dealloc {
    for (SKEmitterNode *particle in leftParticles.allValues) {
        particle.targetNode = nil;
    }
    for (SKEmitterNode *particle in rightParticles.allValues) {
        particle.targetNode = nil;
    }
}


@end
