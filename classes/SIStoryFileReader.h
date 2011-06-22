//
//  FileSystemStoryReader.h
//  Simon
//
//  Created by Derek Clarkson on 5/30/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIStory.h"

@interface SIStoryFileReader : NSObject {
	@private
	NSArray * files;
	NSMutableArray *stories;
	SIStory *story;
}

/**
 * List of the files found in the file system which will be processed to produce stories.
 */
@property (retain, nonatomic) NSArray * files;

/**
 * Used to load tests from just one file out of many.
 */
-(id) initWithFileName:(NSString *) fileName;

/**
 * Reads the files and returns a list of SIStory objects.
 */
-(NSArray *) readStories:(NSError **) error;

@end
