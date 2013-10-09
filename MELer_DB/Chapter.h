//
//  Chapter.h
//  MELer_DB
//
//  Created by Mateusz Zając on 09.10.2013.
//  Copyright (c) 2013 Mateusz Zając. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Section;

@interface Chapter : NSManagedObject

@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSArray *sections;
@end

@interface Chapter (CoreDataGeneratedAccessors)

- (void)addSectionsObject:(Section *)value;
- (void)removeSectionsObject:(Section *)value;
- (void)addSections:(NSArray *)values;
- (void)removeSections:(NSArray *)values;

@end
