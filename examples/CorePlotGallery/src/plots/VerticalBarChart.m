//
//  SimpleBarGraph.m
//  CorePlotGallery
//
//  Created by Jeff Buck on 7/31/10.
//  Copyright 2010 Jeff Buck. All rights reserved.
//


#import "VerticalBarChart.h"

@implementation VerticalBarChart

+ (void)load
{
    [super registerPlotItem:self];
}

- (id)init
{
    if ((self = [super init])) {
        title = @"Vertical Bar Chart";
    }

	return self;
}

- (void)killGraph
{
    if ([graphs count]) {		
        CPTGraph *graph = [graphs objectAtIndex:0];

        if (symbolTextAnnotation) {
            [graph.plotAreaFrame.plotArea removeAnnotation:symbolTextAnnotation];
            [symbolTextAnnotation release];
            symbolTextAnnotation = nil;
        }
    }

	[super killGraph];
}

- (void)generateData
{
}

#define HORIZONTAL 0

- (void)renderInLayer:(CPTGraphHostingView *)layerHostingView withTheme:(CPTTheme *)theme
{
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
    CGRect bounds = layerHostingView.bounds;
#else
    CGRect bounds = NSRectToCGRect(layerHostingView.bounds);
#endif
    
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:bounds];
    [self addGraph:graph toHostingView:layerHostingView];
    [self applyTheme:theme toGraph:graph withDefault:[CPTTheme themeNamed:kCPTDarkGradientTheme]];

	[self setTitleDefaultsForGraph:graph withBounds:bounds];
    [self setPaddingDefaultsForGraph:graph withBounds:bounds];

    // Add plot space for bar charts
    CPTXYPlotSpace *barPlotSpace = [[[CPTXYPlotSpace alloc] init] autorelease];
#if HORIZONTAL
    barPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-10.0f) length:CPTDecimalFromFloat(120.0f)];
    barPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.0f) length:CPTDecimalFromFloat(11.0f)];
#else
    barPlotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1.0f) length:CPTDecimalFromFloat(11.0f)];
    barPlotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-10.0f) length:CPTDecimalFromFloat(120.0f)];
#endif
    [graph addPlotSpace:barPlotSpace];


    // Create grid line styles
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 1.0f;
    majorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.75];

    CPTMutableLineStyle *minorGridLineStyle = [CPTMutableLineStyle lineStyle];
    minorGridLineStyle.lineWidth = 1.0f;
    minorGridLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:0.25];    

	// Create axes
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    CPTXYAxis *x = axisSet.xAxis;
	{
#if HORIZONTAL
		x.majorIntervalLength = CPTDecimalFromInteger(10);
		x.minorTicksPerInterval = 9;
#else
		x.majorIntervalLength = CPTDecimalFromInteger(1);
		x.minorTicksPerInterval = 0;
#endif
		x.orthogonalCoordinateDecimal = CPTDecimalFromInteger(0);
		x.majorGridLineStyle = majorGridLineStyle;
		x.minorGridLineStyle = minorGridLineStyle;
		x.axisLineStyle = nil;
		x.majorTickLineStyle = nil;
		x.minorTickLineStyle = nil;
		x.labelOffset = 10.0;
#if HORIZONTAL
		x.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
		x.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(10.0f)];
#else
		x.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(10.0f)];
		x.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
#endif

		x.title = @"X Axis";
		x.titleOffset = 30.0f;
#if HORIZONTAL
		x.titleLocation = CPTDecimalFromInteger(55);
#else
		x.titleLocation = CPTDecimalFromInteger(5);
#endif

		x.plotSpace = barPlotSpace;
	}
	
    CPTXYAxis *y = axisSet.yAxis;
	{
#if HORIZONTAL
		y.majorIntervalLength = CPTDecimalFromInteger(1);
		y.minorTicksPerInterval = 0;
#else
		y.majorIntervalLength = CPTDecimalFromInteger(10);
		y.minorTicksPerInterval = 9;
#endif
		y.orthogonalCoordinateDecimal = CPTDecimalFromInteger(0);
		y.preferredNumberOfMajorTicks = 8;
		y.majorGridLineStyle = majorGridLineStyle;
		y.minorGridLineStyle = minorGridLineStyle;
		y.axisLineStyle = nil;
		y.majorTickLineStyle = nil;
		y.minorTickLineStyle = nil;
		y.labelOffset = 10.0;
		y.labelRotation = M_PI/2;
#if HORIZONTAL
		y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(10.0f)];
		y.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
#else
		y.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f) length:CPTDecimalFromFloat(100.0f)];
		y.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5f) length:CPTDecimalFromFloat(10.0f)];
#endif

		y.title = @"Y Axis";
		y.titleOffset = 30.0f;
#if HORIZONTAL
		y.titleLocation = CPTDecimalFromInteger(5);
#else
		y.titleLocation = CPTDecimalFromInteger(55);
#endif

		y.plotSpace = barPlotSpace;
	}

    // Set axes
    graph.axisSet.axes = [NSArray arrayWithObjects:x, y, nil];

	// Create a bar line style
	CPTMutableLineStyle *barLineStyle = [[[CPTMutableLineStyle alloc] init] autorelease];
	barLineStyle.lineWidth = 1.0;
	barLineStyle.lineColor = [CPTColor whiteColor];

    // Create first bar plot
	CPTBarPlot *barPlot = [[[CPTBarPlot alloc] init] autorelease];
	barPlot.lineStyle = barLineStyle;
	barPlot.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:1.0f green:0.0f blue:0.5f alpha:0.5f]];
	barPlot.barBasesVary = YES;
    barPlot.barWidth = CPTDecimalFromFloat(0.5f); // bar is 50% of the available space
	barPlot.barCornerRadius = 10.0f;
#if HORIZONTAL
	barPlot.barsAreHorizontal = YES;
#else
	barPlot.barsAreHorizontal = NO;
#endif

    CPTMutableTextStyle *whiteTextStyle = [CPTMutableTextStyle textStyle];
    whiteTextStyle.color = [CPTColor whiteColor];
    barPlot.barLabelTextStyle = whiteTextStyle;
 
	barPlot.delegate = self;
    barPlot.dataSource = self;
    barPlot.identifier = @"Bar Plot 1";

    [graph addPlot:barPlot toPlotSpace:barPlotSpace];


    // Create second bar plot
    CPTBarPlot *barPlot2 = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];

	barPlot2.lineStyle = barLineStyle;
	barPlot2.fill = [CPTFill fillWithColor:[CPTColor colorWithComponentRed:0.0f green:1.0f blue:0.5f alpha:0.5f]];
	barPlot2.barBasesVary = YES;

	barPlot2.barWidth = CPTDecimalFromFloat(1.0f); // bar is full (100%) width
//	barPlot2.barOffset = -0.125f; // shifted left by 12.5%
    barPlot2.barCornerRadius = 2.0f;
#if HORIZONTAL
	barPlot2.barsAreHorizontal = YES;
#else
	barPlot2.barsAreHorizontal = NO;
#endif
    barPlot2.delegate = self;
	barPlot2.dataSource = self;
    barPlot2.identifier = @"Bar Plot 2";

    [graph addPlot:barPlot2 toPlotSpace:barPlotSpace];
}

- (void)dealloc
{
    [plotData release];
    [super dealloc];
}

-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index
{
    return nil;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index 
{
    return nil;
}

#pragma mark -
#pragma mark CPTBarPlot delegate method

-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index
{
    NSNumber *value = [self numberForPlot:plot field:CPTBarPlotFieldBarTip recordIndex:index];

    NSLog(@"bar was selected at index %d. Value = %f", (int)index, [value floatValue]);

    CPTGraph *graph = [graphs objectAtIndex:0];

    if ( symbolTextAnnotation ) {
        [graph.plotAreaFrame.plotArea removeAnnotation:symbolTextAnnotation];
        symbolTextAnnotation = nil;
    }

    // Setup a style for the annotation
    CPTMutableTextStyle *hitAnnotationTextStyle = [CPTMutableTextStyle textStyle];
    hitAnnotationTextStyle.color = [CPTColor orangeColor];
    hitAnnotationTextStyle.fontSize = 16.0f;
    hitAnnotationTextStyle.fontName = @"Helvetica-Bold";
    
    // Determine point of symbol in plot coordinates
    NSNumber *x = [NSNumber numberWithInt:index];
    NSNumber *y = [NSNumber numberWithInt:2]; //[self numberForPlot:plot field:0 recordIndex:index];
#if HORIZONTAL
    NSArray *anchorPoint = [NSArray arrayWithObjects:y, x, nil];
#else
    NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
#endif

    // Add annotation
    // First make a string for the y value
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    [formatter setMaximumFractionDigits:2];
    NSString *yString = [formatter stringFromNumber:value];
    
    // Now add the annotation to the plot area
    CPTTextLayer *textLayer = [[[CPTTextLayer alloc] initWithText:yString style:hitAnnotationTextStyle] autorelease];
    symbolTextAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:anchorPoint];
    symbolTextAnnotation.contentLayer = textLayer;
    symbolTextAnnotation.displacement = CGPointMake(0.0f, 0.0f);

    [graph.plotAreaFrame.plotArea addAnnotation:symbolTextAnnotation];    
}

#pragma mark -
#pragma mark Plot Data Source Methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return 10;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{

    NSNumber *num = nil;
	if (fieldEnum == CPTBarPlotFieldBarLocation) {
		// location
		if ([plot.identifier isEqual:@"Bar Plot 2"]) {
			num = [NSDecimalNumber numberWithInt:index];
		}
		else {
			num = [NSDecimalNumber numberWithInt:index];
		}
	}
	else if (fieldEnum == CPTBarPlotFieldBarTip) {
		// length
		if ([plot.identifier isEqual:@"Bar Plot 2"]) {
			num = [NSDecimalNumber numberWithInt:index];
		}
		else {
			num = [NSDecimalNumber numberWithInt:(index+1)*(index+1)];
		}

	}
	else {
		// base
		if ([plot.identifier isEqual:@"Bar Plot 2"]) {
			num = [NSDecimalNumber numberWithInt:0];
		}
		else {
			num = [NSDecimalNumber numberWithInt:index];
		}
	}

	NSLog(@"identifier = %@, field = %ld, index = %ld -> %@", plot.identifier, fieldEnum, index, num);

    return num;
}

@end
