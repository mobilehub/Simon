//
//  SIEnums.h
//  Simon
//
//  Created by Derek Clarkson on 6/7/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	SIKeywordUnknown = 999,
	SIKeywordGiven = 0,
	SIKeywordThen,
	SIKeywordAs,
	SIKeywordAnd
} SIKeyword;

#define SIMON_ERROR_DOMAIN @"Simon"

typedef enum {
	SIErrorInvalidStorySyntax = 1,
	SIErrorInvalidKeyword,
	SIErrorInvalidRegularExpression,
	SIErrorUnknownSelector,
	SIErrorCannotConvertArgumentToType,
	SIErrorRegularExpressionWillNotMatchSelector,
	SIErrorNoStoriesFound,
	SIErrorStoryFailures
} SIError;

typedef enum {
	SIStoryStatusSuccess = 0,
	SIStoryStatusIgnored,
	SIStoryStatusError,
	SIStoryStatusNotMapped,
	SIStoryStatusNotRun
} SIStoryStatus;

