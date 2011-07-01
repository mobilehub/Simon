//
//  SIInternal.h
//  Simon
//
//  Created by Derek Clarkson on 7/1/11.
//  Copyright 2011 Sensis. All rights reserved.
//

/**
 * The prefix used to start the method names for the step definition.
 */
#define SISTEP_METHOD_PREFIX __stepMap

/**
 * The name of the field dynamically added to classes which contain step implementations. A reference to the parent story
 * is set on this key effectively giving the class access to the story without the author having to write any code.
 */
#define SIINSTANCE_STORY_REF_KEY @"__story"

/**
 * These two are used to convert a sequence of chars to a string constant. We used this to convert a selector to a string
 * constant within a macro. Again we need that extra level of indirection 
 * to fix the translation of the parameter when stringification is involved.
 */
#define toNSString(chars) _toNSString(chars)
#define _toNSString(chars) @#chars
