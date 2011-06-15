//
//  ParseKitGrammerTests.m
//  Simon
//
//  Created by Derek Clarkson on 6/2/11.
//  Copyright 2011 Sensis. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <dUsefulStuff/DCCommon.h>
#import "SIStory.h"
#import "SIStoryFactory.h"
#import <ParseKit/ParseKit.h>

typedef enum {
	CommandThe,
	CommandGiven
} Commands;

@interface ParseKitGrammerTests : GHTestCase {}
-(PKParser *) parserWithGrammerFile:(NSString *) grammerFileName;
-(void) log:(PKAssembly *) assembly type:(NSString *) type;
@end

@implementation ParseKitGrammerTests

-(void) testUsingJustATokeniser {
	NSString *s =	@"The parrot an parrot";
	PKTokenizer *t = [PKTokenizer tokenizerWithString:s];
	
	PKToken *eof = [PKToken EOFToken];
	PKToken *tok = nil;
	
	while ((tok = [t nextToken]) != eof) {
		DC_LOG(@"(%@) (%.1f) : %@", 
				tok.stringValue, tok.floatValue, [tok debugDescription]);
	}
	
}

-(void) testUsingJustATokeniserAndAStory {
	NSString *s =	@"As Simon."
	@"Given UI is up."
	@"Then check field x is \"derek.clarkson@sensis.com.au\""
	@"and field y is 12"
	@"and field z is \"abc\".";
	PKTokenizer *t = [PKTokenizer tokenizerWithString:s];

	PKToken *eof = [PKToken EOFToken];
	PKToken *tok = nil;
	
	while ((tok = [t nextToken]) != eof) {
		DC_LOG(@"(%@) (%.1f) : %@", 
				tok.stringValue, tok.floatValue, [tok debugDescription]);
	}
	
}


-(void) testReallyBasicGrammer {
	PKParser *parser = [self parserWithGrammerFile:@"simple"];
	NSString *s =	@"The parrot an parrot";
	id assembly = [parser parse:s];
	DC_LOG(@"Results = %@", [assembly class]);
	PKReleaseSubparserTree(parser);
}

-(void) testStoryGrammer {
	PKParser *parser = [self parserWithGrammerFile:@"SI"];
	NSString *s =	@"As Simon."
	@"Given UI is up."
	@"Then check field x is \"derek.clarkson@sensis.com.au\""
	@"and field y is 12"
	@"and field z is \"abc\".";
	[parser parse:s];
	PKReleaseSubparserTree(parser);
}

- (void)didMatchNoun:(PKAssembly *)a{
	[self log:a type:@"didMatchNoun       "];
}
- (void)didMatchA:(PKAssembly *)a{
	[self log:a type:@"didMatchA          "];
}
- (void)didMatchThe:(PKAssembly *)a{
	a.target = [NSNumber numberWithInt:CommandThe];
	[a pop];
	[a push:a.target];
	[self log:a type:@"didMatchThe        "];
}
- (void)didMatchAs:(PKAssembly *)a{
	[self log:a type:@"didMatchAs         "];
}
- (void)didMatchGiven:(PKAssembly *)a{
	[self log:a type:@"didMatchGiven      "];
}
- (void)didMatchThen:(PKAssembly *)a{
	[self log:a type:@"didMatchThen       "];
}
- (void)didMatchWhen:(PKAssembly *)a{
	[self log:a type:@"didMatchWhen       "];
}
- (void)didMatchOperator:(PKAssembly *)a{
	[self log:a type:@"didMatchOperator   "];
}
- (void)didMatchKeyword:(PKAssembly *)a{
	//[self log:a type:@"didMatchKeyword    "];
}
- (void)didMatchNumber:(PKAssembly *)a {
	[self log:a type:@"didMatchNumber     "];
}
- (void)didMatchStringValue:(PKAssembly *)a{
	[self log:a type:@"didMatchStringValue"];
}
- (void)didMatchStep:(PKAssembly *)a{
	[self log:a type:@"didMatchStep       "];
}
- (void)didMatchExpression:(PKAssembly *)a{
	//[self log:a type:@"didMatchExpression "];
}
- (void)didMatchOtherWord:(PKAssembly *)a{
	if (a.target == nil) {
		a.target = [[a pop] stringValue];
		[a push:a.target];
	}
	[self log:a type:@"didMatchOtherWord  "];
}

-(void) log:(PKAssembly *) assembly type:(NSString *) type{
	PKToken * token = [assembly top];
	NSLog(@"Method: [%@], token: %@, assembly: %@, target: %@", type, token, assembly, assembly.target);
}


-(PKParser *) parserWithGrammerFile:(NSString *) grammerFileName {
	NSString * grammerFile = [[NSBundle mainBundle] pathForResource:grammerFileName ofType:GRAMMER_EXTENSION];
	NSError * error = nil;
	NSString * grammer = [NSString stringWithContentsOfFile:grammerFile encoding:NSUTF8StringEncoding error:&error];
	if (grammer == nil) {
		GHFail(@"Reading grammer file failed: %@", [error localizedDescription]);
	}
	return [[PKParserFactory factory] parserFromGrammar:grammer assembler:self];
}


@end
