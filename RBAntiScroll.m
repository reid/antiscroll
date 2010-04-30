//
//  RBAntiScroll.m
//  AntiScroll
//
//  Created by Reid Burke on 4/28/10.
//  Copyright 2010 Reid Burke. All rights reserved.
//

#import "RBAntiScroll.h"
#import "JRSwizzle.h"

@implementation NSView (TTView) // TTView <- TTPane <- TTSplitView

- (void) RBAntiScroll_drawRect:(NSRect)dirtyRect
{
	[self RBAntiScroll_drawRect:dirtyRect];
	
	// expand to fit the superview
	NSView *superview = [self superview];
	[self setFrame:[superview frame]];
	
	if ([[superview valueForKey:@"scroller"] superview] != nil) {
		// superview wasn't initialized with our swizzled method
		[RBAntiScroll hideScrollbarsFromPane:superview];
	}
}

@end


@implementation NSView (TTPane)

- (id) RBAntiScroll_initWithFrame:(struct CGRect)arg1 withSplitView:(id)arg2 withController:(id)arg3 withProfile:(id)arg4 logicalScreen:(id)arg5;
{	
	id result = [self RBAntiScroll_initWithFrame: arg1 withSplitView: arg2 withController: arg3 withProfile: arg4 logicalScreen: arg5];
	[RBAntiScroll hideScrollbarsFromPane:self];
	return result;
}

@end


@implementation RBAntiScroll

+ (void) hideScrollbarsFromPane: (NSView*) pane // TTPane
{
	[[pane valueForKey:@"scroller"] removeFromSuperview];
	[[pane valueForKey:@"_splitButton"] setFrameSize:NSZeroSize];
}
		 
+ (void) load
{
	[NSClassFromString(@"TTPane") jr_swizzleMethod:@selector(initWithFrame:withSplitView:withController:withProfile:logicalScreen:) withMethod:@selector(RBAntiScroll_initWithFrame:withSplitView:withController:withProfile:logicalScreen:) error:NULL];
	[NSClassFromString(@"TTView") jr_swizzleMethod:@selector(drawRect:) withMethod:@selector(RBAntiScroll_drawRect:) error:NULL];
}

@end
