//
//  NSString+Utils.m
//  Simon
//
//  Created by Derek Clarkson on 6/18/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

-(NSString *) stringByRemovingQuotes {
	NSCharacterSet *quotes = [NSCharacterSet characterSetWithCharactersInString:@"'\""];
	return [self stringByTrimmingCharactersInSet:quotes];
}

@end
