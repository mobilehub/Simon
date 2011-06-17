//
//  StoryRunner.h
//  Simon
//
//  Created by Derek Clarkson on 6/17/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIStoryReader.h"

@interface SIStoryRunner : NSObject {
	@private 
	SIStoryReader * reader;
}

@property (retain, nonatomic) SIStoryReader * reader;

@end
