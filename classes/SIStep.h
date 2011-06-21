//
//  Step.h
//  Simon
//
//  Created by Derek Clarkson on 5/30/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIEnums.h"

@interface SIStep : NSObject {
@private
	SIKeyword keyword;
	NSString *command;
}

@property (nonatomic, readonly) SIKeyword keyword;
@property (nonatomic, retain) NSString *command;

-(id) initWithKeyword:(SIKeyword) aKeyword command:(NSString *) theCommand;

@end
