//
//  Section.h
//  MELer_DB
//
//  Created by Mateusz Zając on 09.10.2013.
//  Copyright (c) 2013 Mateusz Zając. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Chapter;

@interface Section : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) Chapter *chapter;

@end
