#import "CPTAxis.h"
#import "CPTAxisSet.h"
#import "CPTGraph.h"
#import "CPTLineStyle.h"
#import "CPTPlotSpace.h"
#import "CPTPlotArea.h"

/**	@brief A container layer for the set of axes for a graph.
 **/
@implementation CPTAxisSet

/**	@property axes
 *	@brief The axes in the axis set.
 **/
@synthesize axes;

/** @property borderLineStyle 
 *	@brief The line style for the layer border.
 *	If nil, the border is not drawn.
 **/
@synthesize borderLineStyle;

#pragma mark -
#pragma mark Init/Dealloc

-(id)initWithFrame:(CGRect)newFrame
{
	if ( (self = [super initWithFrame:newFrame]) ) {
		axes = [[NSArray array] retain];
		borderLineStyle = nil;
		
        self.needsDisplayOnBoundsChange = YES;
	}
	return self;
}

-(id)initWithLayer:(id)layer
{
	if ( (self = [super initWithLayer:layer]) ) {
		CPTAxisSet *theLayer = (CPTAxisSet *)layer;
		
		axes = [theLayer->axes retain];
		borderLineStyle = [theLayer->borderLineStyle retain];
	}
	return self;
}

-(void)dealloc
{
    [axes release];
	[borderLineStyle release];
	[super dealloc];
}

#pragma mark -
#pragma mark Labeling

/**	@brief Updates the axis labels for each axis in the axis set.
 **/
-(void)relabelAxes
{
	NSArray *theAxes = self.axes;
	[theAxes makeObjectsPerformSelector:@selector(setNeedsLayout)];
	[theAxes makeObjectsPerformSelector:@selector(setNeedsRelabel)];
}

#pragma mark -
#pragma mark Layout

+(CGFloat)defaultZPosition 
{
	return CPTDefaultZPositionAxisSet;
}

-(void)layoutSublayers
{
	[super layoutSublayers];
	
	NSArray *theAxes = self.axes;
	[theAxes makeObjectsPerformSelector:@selector(setNeedsLayout)];
	[theAxes makeObjectsPerformSelector:@selector(setNeedsDisplay)];
}

#pragma mark -
#pragma mark Accessors

-(void)setAxes:(NSArray *)newAxes 
{
    if ( newAxes != axes ) {
        for ( CPTAxis *axis in axes ) {
            [axis removeFromSuperlayer];
			axis.plotArea = nil;
        }
		[newAxes retain];
        [axes release];
        axes = newAxes;
		CPTPlotArea *plotArea = (CPTPlotArea *)self.superlayer;
        for ( CPTAxis *axis in axes ) {
            [self addSublayer:axis];
			axis.plotArea = plotArea;
        }
        [self setNeedsLayout];
		[self setNeedsDisplay];
    }
}

-(void)setBorderLineStyle:(CPTLineStyle *)newLineStyle
{
	if ( newLineStyle != borderLineStyle ) {
		[borderLineStyle release];
		borderLineStyle = [newLineStyle copy];
		[self setNeedsDisplay];
	}
}

@end
