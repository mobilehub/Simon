//
//  StoryFactory.h
//  Simon
//
//  Created by Derek Clarkson on 5/31/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>
#import "SIStory.h"
#import "SIStoryFactoryDelegate.h"

/**
 * Factory for creating stories from various sources.
 */
@interface SIStoryFactory : NSObject {
@private 
	NSObject<SIStoryFactoryDelegate> * delegate;
	SIStory * story;
}

-(void) didReadURL:(NSString *) url error:(NSError **) error;
-(void) didReadDelimitedString:(NSString *) delimitedString error:(NSError **) error;
-(void) didReadEmail:(NSString *) email error:(NSError **) error;
-(void) didReadWord:(NSString *) word error:(NSError **) error;
-(void) didReadNumber:(CGFloat) number error:(NSError **) error;
-(void) didReadQuotedString:(NSString *) quotedString error:(NSError **) error;
-(void) didReadSymbol:(NSString *) symbol error:(NSError **) error;
-(void) didReadEndOfInput;

// Do not retain. Delegates are typically not retained.
@property (assign, nonatomic) NSObject<SIStoryFactoryDelegate> * delegate;

@end
