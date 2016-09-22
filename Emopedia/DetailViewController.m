//
//  DetailViewController.m
//  Emopedia
//
//  Created by Eric Liang on 4/14/15.
//  Copyright (c) 2015 Xiaoyong Liang. All rights reserved.
//
#import "DetailViewController.h"
#import "Common.h"

#define KEYBOARDTAGOFFSET 20

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *indicator;
@property (nonatomic, strong) NSArray *keyboardTitles;
@property int keyboardExpandedTag;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 40)];
    titleLabel.text = self.title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = COLOR_DEFAULT;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FONT_DEFAULT_WITH_SIZE(16);
    self.navigationItem.titleView = titleLabel;
    
    [self.indicator setText:self.title];
    NSArray *buttonTitles;
    if ([self.title isEqualToString:@"Frequently Used"]) {
        NSUserDefaults *userdef = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.com.apprilo.emopediagroup"];
        buttonTitles = [userdef objectForKey:USER_DEFAULT_KEY_FREQUENTLY_USED];
    } else {
        buttonTitles = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:self.title withExtension:@"plist"]];
    }

    self.keyboardTitles = buttonTitles;
    for (int cnt = 0; cnt < [buttonTitles count]; cnt++) {
        NSString *title = [[buttonTitles objectAtIndex:cnt] objectForKey:@"Name"];
        
        UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
        //NSDictionary *titleDict = [buttonTitles objectAtIndex:cnt];
        
        
        NSArray *strings = [title componentsSeparatedByString:@","];
        
        
        if([strings count] > 1) {
            [button setTitle:[strings objectAtIndex:0] forState:UIControlStateNormal];
        } else {
            [button setTitle:title forState:UIControlStateNormal];
        }
        
        [button setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor: COLOR_DEFAULT forState:UIControlStateHighlighted];
        
        [button setFrame:CGRectMake(30, 30, 30, 30)];
        [button setTranslatesAutoresizingMaskIntoConstraints:YES];
        [button addTarget:self action:@selector(keyboardButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:40.0]];
        [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [button setTag:cnt + KEYBOARDTAGOFFSET];
        [self.view addSubview:button];
    }
   
    self.keyboardExpandedTag = -1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


NSUInteger keyboardButtonNumberInRow;

-(void)viewDidLayoutSubviews {
    CGFloat keyboardButtonLeftMargin,keyboardButtonTopMargin,keyboardButtonSide;

    keyboardButtonNumberInRow = 9;
    
    keyboardButtonTopMargin = 1.0f;
    keyboardButtonLeftMargin = 1.0f;
    
    CGRect scrollContainerFrame = self.view.frame;
    
    keyboardButtonSide = (scrollContainerFrame.size.width - keyboardButtonTopMargin) /keyboardButtonNumberInRow - keyboardButtonTopMargin;
    
      for (id obj in [self.view subviews]) {
          //UIView *view = (UIView *)obj;
          if([obj tag] >= KEYBOARDTAGOFFSET) {
              UIButton *button =(UIButton*) obj;
              NSUInteger cnt = [button tag] - KEYBOARDTAGOFFSET;
              
              
              CGRect buttonFrame = CGRectMake(keyboardButtonLeftMargin + (cnt % keyboardButtonNumberInRow) * (keyboardButtonLeftMargin + keyboardButtonSide), ((cnt - cnt % keyboardButtonNumberInRow) / keyboardButtonNumberInRow) * (keyboardButtonTopMargin + keyboardButtonSide) + keyboardButtonTopMargin + 24, keyboardButtonSide,keyboardButtonSide);
              [button setFrame:buttonFrame];
          }
    }
    
    /*
    CGFloat contentHeight = (ceilf((float)[self.keyboardTitles count] / keyboardButtonNumberInRow)) * (keyboardButtonSide + keyboardButtonTopMargin);
    CGSize contentSize;
    if(contentHeight > self.scrollView.frame.size.height) {
        contentSize = CGSizeMake(scrollContainerFrame.size.width, contentHeight);
    } else {
        contentSize = self.scrollView.frame.size;
    }
    */
    ///[self.scrollContentView setFrame:CGRectMake(0, 0, contentSize.width, contentSize.height)];
    //[self.scrollView setContentSize:contentSize];

    
}

-(void) keyboardButtonSelected: (UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    NSUInteger buttonIndex = [button tag] - KEYBOARDTAGOFFSET;
    
    
    if(self.keyboardExpandedTag == -1 ) {
        //expand keyboard
        //NSString * title = [[buttonTitles objectAtIndex:cnt] objectForKey:@"Name"];
        
        if([[[[self.keyboardTitles objectAtIndex:buttonIndex]objectForKey:@"Name"] componentsSeparatedByString:@","] count] > 1) {
            self.keyboardExpandedTag = (int)[button tag];
            NSArray *titleArray =[[[self.keyboardTitles objectAtIndex:buttonIndex]objectForKey:@"Name"] componentsSeparatedByString:@","];
            for (int i = 1; i < [titleArray count]; i++) {
                UIButton * button =(UIButton *)[self.view viewWithTag:i + self.keyboardExpandedTag];
                [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            }
            
            NSString *description = [[[self.keyboardTitles objectAtIndex:buttonIndex]objectForKey:@"Description"]uppercaseString];
            [self.indicator setAlpha:1.0];
            [self.indicator setText:[NSString stringWithFormat:@"%@: Choose a variant",description]];
        } else {
            NSString *description = [[[self.keyboardTitles objectAtIndex:buttonIndex]objectForKey:@"Description"]uppercaseString];
            [self.indicator setAlpha:1.0];
            [self.indicator setText:description];
            
            NSUserDefaults *userdef = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.com.apprilo.emopediagroup"];
            NSMutableArray *array = [NSMutableArray arrayWithArray:[userdef objectForKey:USER_DEFAULT_KEY_FREQUENTLY_USED]];
            
            
            
            NSDictionary *typedDict = [NSDictionary dictionaryWithObjectsAndKeys:button.titleLabel.text,@"Name",description,@"Description" , nil];
            if(![[array objectAtIndex:0] isEqualToDictionary:typedDict]) {
                NSInteger i = [array indexOfObject:typedDict];
                
                if(i != NSNotFound) {
                    [array removeObjectAtIndex:i];
                }
                
                [array insertObject:typedDict atIndex:0];
                if ([array count] >30) {
                    [array removeObjectAtIndex:30];
                }
            }
            
            [userdef setObject:array forKey:USER_DEFAULT_KEY_FREQUENTLY_USED];
            [userdef synchronize];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        
    } else {
        if([[[[self.keyboardTitles objectAtIndex:buttonIndex]objectForKey:@"Name"] componentsSeparatedByString:@","] count] > 1 && (buttonIndex < self.keyboardExpandedTag - KEYBOARDTAGOFFSET || buttonIndex > self.keyboardExpandedTag - KEYBOARDTAGOFFSET + 5)) {
            //unexpand and expand
            for (int i = 1; i < 6; i++) {
                UIButton * button =(UIButton *)[self.view viewWithTag:i + self.keyboardExpandedTag];
                
                NSString *titleString = [[self.keyboardTitles objectAtIndex:i + self.keyboardExpandedTag - KEYBOARDTAGOFFSET] objectForKey:@"Name"];
                NSString *title = [[titleString componentsSeparatedByString:@","]objectAtIndex:0];
                
                [button setTitle:title forState:UIControlStateNormal];
            }
            
            self.keyboardExpandedTag = (int)[button tag];
            NSArray *titleArray =[[[self.keyboardTitles objectAtIndex:buttonIndex]objectForKey:@"Name"] componentsSeparatedByString:@","];
            for (int i = 1; i < [titleArray count]; i++) {
                UIButton * button =(UIButton *)[self.view viewWithTag:i + self.keyboardExpandedTag];
                [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            }
            
            NSString *description = [[[self.keyboardTitles objectAtIndex:buttonIndex]objectForKey:@"Description"]uppercaseString];
            [self.indicator setAlpha:1.0];
            [self.indicator setText:[NSString stringWithFormat:@"%@: Choose a variant",description]];
            
        } else {
            
            int variantNumber =(int) (buttonIndex - self.keyboardExpandedTag + KEYBOARDTAGOFFSET);
            NSString *description = [[[self.keyboardTitles objectAtIndex:self.keyboardExpandedTag - KEYBOARDTAGOFFSET]objectForKey:@"Description"]uppercaseString];
            [self.indicator setAlpha:1.0];
            [self.indicator setText:[NSString stringWithFormat:@"%@: Variant %d",description,variantNumber]];
            
            NSUserDefaults *userdef = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.com.apprilo.emopediagroup"];
            NSMutableArray *array = [NSMutableArray arrayWithArray:[userdef objectForKey:USER_DEFAULT_KEY_FREQUENTLY_USED]];
            
            NSDictionary *typedDict = [NSDictionary dictionaryWithObjectsAndKeys:button.titleLabel.text,@"Name",description,@"Description" , nil];
            if(![[array objectAtIndex:0] isEqualToDictionary:typedDict]) {
                NSInteger i = [array indexOfObject:typedDict];
                
                if(i != NSNotFound) {
                    [array removeObjectAtIndex:i];
                }
                
                [array insertObject:typedDict atIndex:0];
                if ([array count] >30) {
                    [array removeObjectAtIndex:30];
                }
            }
            
            [userdef setObject:array forKey:USER_DEFAULT_KEY_FREQUENTLY_USED];
            [userdef synchronize];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            for (int i = 1; i < 6; i++) {
                UIButton * button =(UIButton *)[self.view viewWithTag:i + self.keyboardExpandedTag];
                
                NSString *titleString = [[self.keyboardTitles objectAtIndex:i + self.keyboardExpandedTag - KEYBOARDTAGOFFSET] objectForKey:@"Name"];
                NSString *title = [[titleString componentsSeparatedByString:@","]objectAtIndex:0];
                
                [button setTitle:title forState:UIControlStateNormal];
            }
            self.keyboardExpandedTag = -1;
            
        }
        
    }
    

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
