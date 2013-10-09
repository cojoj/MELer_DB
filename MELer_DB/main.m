//
//  main.m
//  MELer_DB
//
//  Created by Mateusz Zając on 09.10.2013.
//  Copyright (c) 2013 Mateusz Zając. All rights reserved.
//

#import "Chapter.h"
#import "Section.h"

static NSManagedObjectModel *managedObjectModel()
{
    static NSManagedObjectModel *model = nil;
    if (model != nil) {
        return model;
    }
    
    NSString *path = @"MELer_DB";
    path = [path stringByDeletingPathExtension];
    NSURL *modelURL = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"momd"]];
    model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return model;
}

static NSManagedObjectContext *managedObjectContext()
{
    static NSManagedObjectContext *context = nil;
    if (context != nil) {
        return context;
    }

    @autoreleasepool {
        context = [[NSManagedObjectContext alloc] init];
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel()];
        [context setPersistentStoreCoordinator:coordinator];
        
        NSString *STORE_TYPE = NSSQLiteStoreType;
        
        NSString *path = [[NSProcessInfo processInfo] arguments][0];
        path = [path stringByDeletingPathExtension];
        NSURL *url = [NSURL fileURLWithPath:[path stringByAppendingPathExtension:@"sqlite"]];
        
        NSError *error;
        NSPersistentStore *newStore = [coordinator addPersistentStoreWithType:STORE_TYPE configuration:nil URL:url options:nil error:&error];
        
        if (newStore == nil) {
            NSLog(@"Store Configuration Failure %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
        }
    }
    return context;
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        // Create the managed object context
        NSManagedObjectContext *context = managedObjectContext();
        
        // Custom code here...
        // Save the managed object context
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Error while saving %@", ([error localizedDescription] != nil) ? [error localizedDescription] : @"Unknown Error");
            exit(1);
        }
        
        // Getting path to the JSON file
        NSString* dataPath = [[NSBundle mainBundle] pathForResource:@"MELs" ofType:@"json"];
        // Serializing JSON to the Array of Chapters
        NSArray* MELs = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath]
                                                         options:kNilOptions
                                                           error:&error];
        // Logging all MELs from variable
        // NSLog(@"%@", MELs);
        
        // Saving MELs to Core Data one by one
        [MELs enumerateObjectsUsingBlock:^(id chap, NSUInteger idx, BOOL *stop) {
            Chapter *chapter = [NSEntityDescription insertNewObjectForEntityForName:@"Chapter" inManagedObjectContext:context];
            
            chapter.title = [chap valueForKey:@"title"];
            chapter.number = [chap valueForKey:@"chapter"];
            chapter.details = [chap valueForKey:@"description"];
            
            [[chap valueForKey:@"section"] enumerateObjectsUsingBlock:^(id sec, NSUInteger idx, BOOL *stop) {
                Section *section = [NSEntityDescription insertNewObjectForEntityForName:@"Section" inManagedObjectContext:context];
                
                section.title = [sec valueForKey:@"title"];
                section.number = [sec valueForKey:@"number"];
                section.details = [sec valueForKey:@"description"];
                
                [chapter addSectionsObject:section];
            }];
            
            NSError *error;
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }];
        
        // Listing all MELs from Core Data
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Chapter" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        for (Chapter *info in fetchedObjects) {
            NSLog(@"%@", info.title);
        }
    }
    return 0;
}

