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
	NSMutableArray * words;
}

@property(nonatomic,readonly) SIKeyword keyword;
@property(nonatomic,readonly) NSMutableArray * words;

-(id) initWithKeyword:(SIKeyword) aKeyword;

-(void) addWord:(NSString *) word;

-(SEL) selector;

@end
