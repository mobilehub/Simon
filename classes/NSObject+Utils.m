//
//  NSObject+Utils.m
//  Simon
//
//  Created by Derek Clarkson on 6/8/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import "NSObject+Utils.h"

@implementation NSObject (NSObject_Utils)

-(NSError *) errorForCode:(SIError) errorCode shortDescription:(NSString *) shortDescription description:(NSString *) description {
	NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
								 description, NSLocalizedDescriptionKey, 
								 shortDescription, NSLocalizedFailureReasonErrorKey, 
								 nil];
	return [NSError errorWithDomain:SIMON_ERROR_DOMAIN code:errorCode userInfo:dic];
}

-(SIKeyword) keywordFromString:(NSString *) string {
	NSString * upper = [string uppercaseString];
	if ([@"GIVEN" isEqualToString:upper]) {
		return SIKeywordGiven;
	} else if ([@"THEN" isEqualToString:upper]) {
		return SIKeywordThen;
	} else if ([@"AS" isEqualToString:upper]) {
		return SIKeywordAs;
	} else if ([@"AND" isEqualToString:upper]) {
		return SIKeywordAnd;
	}
	return SIKeywordUnknown;
}

-(NSString *) stringFromKeyword:(SIKeyword) keyword {
	switch (keyword) {
		case SIKeywordGiven:
			return @"Given";
			break;

		case SIKeywordThen:
			return @"Then";
			break;

		case SIKeywordAs:
			return @"As";
			break;

		case SIKeywordAnd:
			return @"And";
			break;

		default:
			break;
	}
	return nil;	
}

@end