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
	NSMutableArray * parameters;
	NSMutableString * selector;
	BOOL parametersAdded;
}

@property (nonatomic, readonly) SIKeyword keyword;

-(id) initWithKeyword:(SIKeyword) aKeyword;

-(void) addWord:(NSString *) word;

-(void) addParameter:(id) parm;

-(SEL) selector;

@end
