//
//  PDPatch.h
//  monoleap
//
//  Created by Itai Matos on 24/11/2015.
//  Copyright © 2015 Dan Bar-Yaakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDPatch : NSObject

-(instancetype)initWithFile:(NSString*)pdFile;
-(void)sendMidi:(int)midi andVelocity:(int)velocity;

-(void)receiveBangFromSource:(NSString *)source;


@end
