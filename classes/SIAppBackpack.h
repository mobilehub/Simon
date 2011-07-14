//
//  SIAppBackpack.h
//  Simon
//
//  Created by Derek Clarkson on 7/13/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dUsefulStuff/DCBackgroundTask.h>

/**
 This class backpack's on a UIApplication in order to allow Simon to run in the background.
 */
@interface SIAppBackpack : NSObject<DCBackgroundTask> {
	@private 
	NSString * fileName;
}

-(id) initWithStoryFile:(NSString *) aFileName;

@end
