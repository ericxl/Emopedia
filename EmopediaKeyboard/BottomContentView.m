//
//  BottomContentView.m
//  Emopedia
//
//  Created by Eric Liang on 4/20/15.
//  Copyright (c) 2015 Xiaoyong Liang. All rights reserved.
//

#import "BottomContentView.h"

@implementation BottomContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib {
    self.multipleTouchEnabled = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"touches began");
}
@end
