//
//  NSString+Utils.h
//  Simon
//
//  Created by Derek Clarkson on 6/18/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

/**
 * Returns the string with any leading and trail quotes removed. Works with both
 * single and double quotes.
 */
-(NSString *) stringByRemovingQuotes;

@end
