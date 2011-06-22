//
//  UITreeTests.m
//  Simon
//
//  Created by Derek Clarkson on 6/3/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import "SIStory.h"

@interface UITreeTests : GHTestCase {}

@end

@interface UITreeTests()
-(void) logSubviewsOfView:(UIView *) view widthPrefix:(NSString *) prefix;
-(NSString *) getLogTextForView:(UIView *) view;
@end


@implementation UITreeTests

-(void) testAccessToWindow {
		GHAssertNotNil([UIApplication sharedApplication].keyWindow, @"didnt get to primary window");
}

-(void) testAccessToWindowSubviews {
	UIWindow * window = [UIApplication sharedApplication].keyWindow;
	[self logSubviewsOfView:window widthPrefix:@""];
}

-(void) logSubviewsOfView:(UIView *) view widthPrefix:(NSString *) prefix {
	DC_LOG(@"%@%@", prefix, [self getLogTextForView:view]);
	NSString * offset = [NSString stringWithFormat:@"%@%@", prefix, @"   "];
	for (UIView * subview in view.subviews) {
		[self logSubviewsOfView:subview widthPrefix:offset];
	}
}

-(NSString *) getLogTextForView:(UIView *) view {

	if ([view isKindOfClass:[UIButton class]]) {
		UIButton * button = (UIButton *) view;
		return [NSString stringWithFormat:@"[%@] (%i) %@", [button class], button.buttonType, button.currentTitle];
	} else
		if ([view isKindOfClass:[UILabel class]]) {
			UILabel * label = (UILabel *) view;
			return [NSString stringWithFormat:@"[%@] %@", [label class], label.text];
		}
	
	return [[view class] description];
}


@end
