//
//  NSObject+Utils.h
//  Simon
//
//  Created by Derek Clarkson on 6/8/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SIEnums.h"

@interface NSObject (NSObject_Utils)

-(NSError *) errorForCode:(SIError) errorCode shortDescription:(NSString *) shortDescription failureReason:(NSString *) failureReason; 

-(SIKeyword) keywordFromString:(NSString *) string;
-(NSString *) stringFromKeyword:(SIKeyword) keyword;

@end
