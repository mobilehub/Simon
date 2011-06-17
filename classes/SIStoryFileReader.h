//
//  FileSystemStoryReader.h
//  Simon
//
//  Created by Derek Clarkson on 5/30/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIStoryFactory.h"

@interface SIStoryFileReader : NSObject {
	@private
	NSArray * files;
	SIStoryFactory * storyFactory;
}

/**
 * List of the files found in the file system which will be processed to produce stories.
 */
@property (retain, nonatomic) NSArray * files;
@property (retain, nonatomic) SIStoryFactory *storyFactory;

/**
 * Used to load tests from just one file out of many.
 */
-(id) initWithFileName:(NSString *) fileName;

-(NSArray *) readStories:(NSError **) error;

@end
