//
//  CircledLinebutton.m
//  Emopedia
//
//  Created by Eric Liang on 4/19/15.
//  Copyright (c) 2015 Xiaoyong Liang. All rights reserved.
//

#import "CircledLinebutton.h"
#import <QuartzCore/QuartzCore.h>
#import "Common.h"
@interface CircledLinebutton ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@end

@implementation CircledLinebutton

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setTitleColor:COLOR_DEFAULT forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        self.circleLayer = [CAShapeLayer layer];
        [[self layer] addSublayer:self.circleLayer];
    }
    
    return self;
}
- (void)drawCircleButtonForSelectedState{
    
    
    //[self.circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self bounds].size.width,[self bounds].size.height)];
    [self.circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self bounds].size.width,[self bounds].size.height)];
    [self.circleLayer setPosition:CGPointMake(CGRectGetMidX([self bounds]),CGRectGetMidY([self bounds]))];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    
    [self.circleLayer setPath:[path CGPath]];
    
    [self.circleLayer setStrokeColor:[UIColor clearColor].CGColor];
    
    [self.circleLayer setLineWidth:2.0];
    [self.circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    
    //[[self layer] addSublayer:self.circleLayer];
     
}
-(void)updateCircle {
    [self.circleLayer setFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, [self frame].size.width,[self frame].size.height)];
    //[self.circleLayer setPosition:CGPointMake(CGRectGetMidX([self bounds]),CGRectGetMidY([self bounds]))];
    
}
-(void) setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected)
    {
        [self.circleLayer setFillColor:[UIColor lightGrayColor].CGColor];
    }
    else
    {
        [self.circleLayer setFillColor:[UIColor clearColor].CGColor];
    }
}
/*
-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];

    //[self.circleLayer setBounds:CGRectMake(0.0f, 0.0f, frame.size.width,frame.size.height)];
  
}
*/
@end
