//
//  WaterTheme.m
//  monoleap
//
//  Created by Dan Bar-Yaakov on 31/10/2015.
//  Copyright © 2015 Dan Bar-Yaakov. All rights reserved.
//

#import "CalmTheme.h"

@implementation CalmTheme

-(void)verticalLeftChanged:(int)position {}
-(void)verticalRightChanged:(int)position {}
-(void)rightHandMoved:(NSArray *)touches {}

+(NSString*)description {
    return @"Minimal theme";
}

-(void)drawRightHandTouches:(int)pattern touches:(NSArray *)touches {
  
}

-(void)drawLeftHandTouches:(int)pattern touches:(NSArray *)touches {}
-(void)leftHandMoved:(NSArray *)touches {}

//-(void)drawPattern:(int)pattern touches:(NSArray*)touches {
//    switch (pattern) {
//        case 0:
//            [self hideParticle:0 particles:particles];
//            [self hideParticle:1 particles:particles];
//            [self hideParticle:2 particles:particles];
//            [self hideParticle:3 particles:particles];
//            break;
//        case 1:
//            [self drawParticle:0 touch:[touches objectAtIndex:0] particles:particles color: [UIColor blueColor]];
//            [self hideParticle:1 particles:particles];
//            [self hideParticle:2 particles:particles];
//            [self hideParticle:3 particles:particles];
//            break;
//        case 2:
//            [self drawParticle:0 touch:[touches objectAtIndex:0] particles:particles color: [UIColor cyanColor]];
//            [self drawParticle:1 touch:[touches objectAtIndex:1] particles:particles color: [UIColor cyanColor]];
//            [self hideParticle:2 particles:particles];
//            [self hideParticle:3 particles:particles];
//            break;
//        case 3:
//            [self drawParticle:0 touch:[touches objectAtIndex:0] particles:particles color: [UIColor greenColor]];
//            [self drawParticle:1 touch:[touches objectAtIndex:1] particles:particles color: [UIColor greenColor]];
//            [self drawParticle:2 touch:[touches objectAtIndex:2] particles:particles color: [UIColor greenColor]];
//            [self hideParticle:3 particles:particles];
//            break;
//        case 4:
//            [self drawParticle:0 touch:[touches objectAtIndex:0] particles:particles color: [UIColor yellowColor]];
//            [self hideParticle:1 particles:particles];
//            [self hideParticle:2 particles:particles];
//            [self drawParticle:3 touch:[touches objectAtIndex:1] particles:particles color: [UIColor yellowColor]];
//            break;
//        case 5:
//            [self drawParticle:0 touch:[touches objectAtIndex:0] particles:particles color: [UIColor purpleColor]];
//            [self hideParticle:1 particles:particles];
//            [self drawParticle:2 touch:[touches objectAtIndex:1] particles:particles color: [UIColor purpleColor]];
//            [self drawParticle:3 touch:[touches objectAtIndex:2] particles:particles color: [UIColor purpleColor]];
//            break;
//        case 6:
//            [self drawParticle:0 touch:[touches objectAtIndex:0] particles:particles color: [UIColor redColor]];
//            [self hideParticle:1 particles:particles];
//            [self hideParticle:2 particles:particles];
//            [self drawParticle:3 touch:[touches objectAtIndex:1] particles:particles color: [UIColor redColor]];
//            break;
//}

@end
