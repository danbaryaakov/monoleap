//
//  Settings.h
//  xophone
//
//  Created by Dan Bar-Yaakov on 8/1/15.
//  Copyright (c) 2015 Dan Bar-Yaakov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Settings : NSManagedObject

@property (nonatomic, retain) NSNumber * leftXctrl;
@property (nonatomic, retain) NSNumber * leftYctrl;

@end
