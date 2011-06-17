//
//  StoryReader.h
//  Simon
//
//  Created by Derek Clarkson on 6/1/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIStoryFileReader.h"
#import "SIStoryFactory.h"

/**
 * Class which reads stories from the files produced by the DCStoryFileReader and creates
 * story objects.
 */
@interface SIStoryReader : NSObject {
	@private 
	SIStoryFileReader * fileReader;
	SIStoryFactory * storyFactory;
}

@property (retain, nonatomic) SIStoryFileReader *fileReader;
@property (retain, nonatomic) SIStoryFactory *storyFactory;

-(id) initWithStoryFileReader:(SIStoryFileReader *) storyFileReader storyFactory:(SIStoryFactory *) aStoryFactory;

/**
 * Reads the stories, interprets them and returns an aray of story objects.
 */
-(NSArray *) readStories:(NSError **) error;

@end
