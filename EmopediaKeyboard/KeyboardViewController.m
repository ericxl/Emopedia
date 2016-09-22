//
//  KeyboardViewController.m
//  Emopedia
//
//  Created by Eric Liang on 4/20/15.
//  Copyright (c) 2015 Xiaoyong Liang. All rights reserved.
//
#import "KeyboardViewController.h"
#import "Common.h"
#import <malloc/malloc.h>
//#import "CircledLinebutton.h"

@interface KeyboardViewController ()<UIScrollViewDelegate>


@property (strong, nonatomic) UIView *keyboardView;

@property (strong, nonatomic) UIView *topScrollContainer;
@property (strong, nonatomic) UIScrollView *topScrollView;
@property (strong, nonatomic) UIView *topScrollContentView;
@property (strong, nonatomic) UILabel *categoryIndicator;
@property int keyboardExpandedTag;
@property (nonatomic) NSUInteger numberOfKeyboards;

@property (strong, nonatomic) NSTimer* backspaceTimer;

@property (strong, nonatomic) UIView *bottomScrollContainer;
@property (strong, nonatomic) UIScrollView *bottomScrollView;
@property (strong, nonatomic) UIView *bottomScrollContentView;
@property (strong, nonatomic) UIButton *globeButton;
@property (strong, nonatomic) UIButton *backspaceButton;
@property (nonatomic) NSUInteger numberOfCates;
@property (nonatomic, strong) NSArray *keyboardTitles;

@property NSUInteger lastSelectedIndex;

@end

@implementation KeyboardViewController


-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
}
- (void)updateViewConstraints {
    [super updateViewConstraints];
    
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect keyboardRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.keyboardView setFrame:keyboardRect];
    [self.topScrollContainer setFrame:CGRectMake(0, 0, keyboardRect.size.width, self.view.frame.size.height/5*4)];
    [self.bottomScrollContainer setFrame:CGRectMake(0, self.view.frame.size.height/5*4, self.view.frame.size.width, self.view.frame.size.height/5)];
    [self.globeButton setFrame:CGRectMake(4, 4, 32, 32)];
    [self.backspaceButton setFrame:CGRectMake(keyboardRect.size.width - 36, 4, 32, 32)];
    
    [self layoutBottomView];
    
    [self layoutKeyboardButtons];
    

}
CGFloat keyboardButtonLeftMargin,keyboardButtonTopMargin,keyboardButtonSide;
NSUInteger keyboardButtonNumberInColumn;
#define KEYBOARDTAGOFFSET 20
-(void)layoutKeyboardButtons {
    
    
    keyboardButtonTopMargin = 1.0f;
    keyboardButtonLeftMargin = 1.0f;
    if([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height){
        NSUserDefaults *userdef = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.com.apprilo.emopediagroup"];
        NSMutableArray *activeCates = [NSMutableArray arrayWithArray:[userdef objectForKey:USER_DEFAULT_KEY_ACTIVE_UNICODE_CATEGORIES]];
        NSString *cateTitle = [[activeCates objectAtIndex:self.lastSelectedIndex]objectForKey:@"Name"];
        if([cateTitle hasPrefix:@"Box Drawing"]) {
            keyboardButtonNumberInColumn = 3;
        } else {
            keyboardButtonNumberInColumn = 4;
        }
    }
    else{
        keyboardButtonNumberInColumn = 3;
    }
    CGRect topScrollContainerFrame = self.topScrollContainer.frame;
    keyboardButtonSide = (topScrollContainerFrame.size.height - self.categoryIndicator.frame.size.height + keyboardButtonTopMargin ) /keyboardButtonNumberInColumn - keyboardButtonTopMargin;
    
    self.topScrollView.translatesAutoresizingMaskIntoConstraints = YES;
    self.topScrollContentView.translatesAutoresizingMaskIntoConstraints = YES;
    
    CGRect topScrollViewFrame = CGRectMake(0, self.categoryIndicator.frame.size.height, topScrollContainerFrame.size.width, topScrollContainerFrame.size.height-self.categoryIndicator.frame.size.height);
    [self.topScrollView setFrame: topScrollViewFrame];
    [self.topScrollContentView setFrame:CGRectMake(0, 0, topScrollViewFrame.size.width, topScrollViewFrame.size.height)];
    
    for(NSUInteger i = 0; i < _numberOfKeyboards; i++ ) {
        UIButton *button =(UIButton*) [self.topScrollContentView viewWithTag:i + KEYBOARDTAGOFFSET];
        CGRect buttonFrame = CGRectMake(((i - i % keyboardButtonNumberInColumn) / keyboardButtonNumberInColumn) * (keyboardButtonLeftMargin + keyboardButtonSide) + keyboardButtonLeftMargin, keyboardButtonTopMargin + (i % keyboardButtonNumberInColumn) * (keyboardButtonTopMargin + keyboardButtonSide), keyboardButtonSide , keyboardButtonSide);
        [button setFrame:buttonFrame];
    }
    //timeString = [timeString stringByAppendingString:[NSString stringWithFormat:@"at lo %.02f",[date timeIntervalSinceNow]]];
    [self resizeScrollViewSize];
}

-(void)layoutBottomView{
    CGFloat cateButtonMargin,cateButtonSide;
    
    //laying out bottom scroll buttons
    
    self.bottomScrollView.translatesAutoresizingMaskIntoConstraints = YES;
    self.bottomScrollContentView.translatesAutoresizingMaskIntoConstraints = YES;
    
    CGRect bottomScrollContainerFrame = self.bottomScrollContainer.frame;
    
    cateButtonMargin = 1.0f;
    cateButtonSide = bottomScrollContainerFrame.size.height - 2 * cateButtonMargin;
    
    
    
    CGRect bottomScrollViewFrame = CGRectMake(self.globeButton.frame.origin.x + self.globeButton.frame.size.width, 0, bottomScrollContainerFrame.size.width - self.backspaceButton.frame.size.width - self.globeButton.frame.size.width - self.globeButton.frame.origin.x, bottomScrollContainerFrame.size.height);
    [self.bottomScrollView setFrame:bottomScrollViewFrame];
    [self.bottomScrollContentView setFrame:CGRectMake(0, 0, bottomScrollViewFrame.size.width, bottomScrollViewFrame.size.height)];
    
    NSUserDefaults *userdef = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.com.apprilo.emopediagroup"];
    NSMutableArray *activeCates = [NSMutableArray arrayWithArray:[userdef objectForKey:USER_DEFAULT_KEY_ACTIVE_UNICODE_CATEGORIES]];
    
    for (NSUInteger i = 0; i < [activeCates count]; i++) {
        UIButton * button =(UIButton *)[self.bottomScrollContentView viewWithTag:i + KEYBOARDTAGOFFSET];
        if(i ==0) {
            button.frame = CGRectMake(cateButtonMargin , bottomScrollContainerFrame.size.height/2 - cateButtonSide/2, cateButtonSide, cateButtonSide);
        } else {
            button.frame = CGRectMake(cateButtonMargin + (cateButtonSide + cateButtonMargin) * i, bottomScrollContainerFrame.size.height/2 - cateButtonSide/2, cateButtonSide, cateButtonSide);
        }
        //[button drawCircleButtonForSelectedState];
    }
    
    CGFloat bottomContentWidth = [activeCates count] * (cateButtonMargin + cateButtonSide);
    CGSize bottomContentSize;
    if(bottomContentWidth > self.bottomScrollContentView.frame.size.width) {
        bottomContentSize = CGSizeMake(bottomContentWidth, bottomScrollContainerFrame.size.height);
    } else {
        bottomContentSize = self.bottomScrollView.frame.size;
    }
    
    [self.bottomScrollContentView setFrame:CGRectMake(0, 0, bottomContentSize.width, bottomContentSize.height)];
    [self.bottomScrollView setContentSize:bottomContentSize];
}

- (void)killScroll
{
    //self.topScrollView.scrollEnabled = NO;
    //self.topScrollView.scrollEnabled = YES;
    [self.topScrollView setContentOffset:CGPointMake(0, 0)];
}

//NSDate *date;
//NSString *timeString = @"";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //date = [NSDate date];
    NSUserDefaults *userdef = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.com.apprilo.emopediagroup"];
    NSArray *allCate = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Categories" withExtension:@"plist"]];
    NSDictionary *activeCateDef = [NSDictionary dictionaryWithObjectsAndKeys:[NSArray arrayWithObjects:[allCate objectAtIndex:0],[allCate objectAtIndex:1],[allCate objectAtIndex:2],[allCate objectAtIndex:15], nil], USER_DEFAULT_KEY_ACTIVE_UNICODE_CATEGORIES,nil];
    [userdef registerDefaults:activeCateDef];
    
   
    NSMutableArray *array = [NSMutableArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"Name",@"APPLE LOGO", @"Description", nil]];
    [userdef registerDefaults:[NSDictionary dictionaryWithObject:[NSArray arrayWithArray:array] forKey:USER_DEFAULT_KEY_FREQUENTLY_USED]];
    
    [userdef synchronize];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self initializeKeyboard];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - TextInput methods

- (void)textWillChange:(id<UITextInput>)textInput {
    
}

- (void)textDidChange:(id<UITextInput>)textInput {
    UIColor *backgroundColor = nil;
    UIColor *textColor = nil;
    UIColor *cateLabelColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        [self.backspaceButton setImage:[UIImage imageNamed:@"backspace_white.png"] forState:UIControlStateNormal];
        [self.backspaceButton setImage:[UIImage imageNamed:@"backspace_white_high.png"] forState:UIControlStateHighlighted];
        
        [self.globeButton setImage:[UIImage imageNamed:@"globe_white.png"] forState:UIControlStateNormal];
        
        backgroundColor = rgb(89, 89, 89);
        textColor = [UIColor whiteColor];
        cateLabelColor = rgb(191, 191, 191);
        
        
        NSUserDefaults *userdef = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.com.apprilo.emopediagroup"];
        NSMutableArray *activeCates = [NSMutableArray arrayWithArray:[userdef objectForKey:USER_DEFAULT_KEY_ACTIVE_UNICODE_CATEGORIES]];
        for (NSUInteger i = 0; i < [activeCates count]; i++) {
            UIButton * button =(UIButton *)[self.bottomScrollContentView viewWithTag:i + KEYBOARDTAGOFFSET];
            [button setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor: COLOR_DEFAULT forState:UIControlStateSelected];
        }
        for (id obj in self.topScrollContentView.subviews) {
            UIButton *button =(UIButton*) obj;
            [button setTitleColor: textColor forState:UIControlStateNormal];
            [button setTitleColor: [UIColor blackColor] forState:UIControlStateHighlighted];
        }
        
    } else {
        [self.globeButton setImage:[UIImage imageNamed:@"globe_black.png"] forState:UIControlStateNormal];
        
        
        [self.backspaceButton setImage:[UIImage imageNamed:@"backspace_black.png"] forState:UIControlStateNormal];
        [self.backspaceButton setImage:[UIImage imageNamed:@"backspace_black_high.png"] forState:UIControlStateHighlighted];
        
        backgroundColor = rgb(236, 238, 241);
        textColor = COLOR_DEFAULT;
        cateLabelColor = rgb(165, 166, 169);
        
        NSUserDefaults *userdef = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.com.apprilo.emopediagroup"];
        NSMutableArray *activeCates = [NSMutableArray arrayWithArray:[userdef objectForKey:USER_DEFAULT_KEY_ACTIVE_UNICODE_CATEGORIES]];
        for (NSUInteger i = 0; i < [activeCates count]; i++) {
            UIButton * button =(UIButton *)[self.bottomScrollContentView viewWithTag:i + KEYBOARDTAGOFFSET];
            [button setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor: textColor forState:UIControlStateSelected];
        }
        for (id obj in self.topScrollContentView.subviews) {
            UIButton *button =(UIButton*) obj;
            [button setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor: textColor forState:UIControlStateHighlighted];
        }
    }
    [self.view setBackgroundColor:backgroundColor];
    
    [self.categoryIndicator setTextColor:cateLabelColor];
}

#pragma mark - initialization method

- (void) initializeKeyboard {
    self.keyboardExpandedTag = -1;
    //setting up bottom scroll
    NSUserDefaults *userdef = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.com.apprilo.emopediagroup"];
    NSMutableArray *activeCates = [NSMutableArray arrayWithArray:[userdef objectForKey:USER_DEFAULT_KEY_ACTIVE_UNICODE_CATEGORIES]];
    //self.cateButtons = [NSMutableArray arrayWithObjects: nil];
    for (NSUInteger cnt = 0; cnt < [activeCates count]; cnt++) {
        //We'll create an imageView object in every 'page' of our scrollView.
        CGRect frame;
        frame.origin.x = 10 +36 * cnt;
        frame.origin.y = 5;
        frame.size = CGSizeMake(10, 10);
        
        NSDictionary *cateDict = [activeCates objectAtIndex:cnt];
        
        UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[cateDict objectForKey:@"Description"] forState:UIControlStateNormal];
        
        
        if(self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark){
            [button setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor: [UIColor blackColor] forState:UIControlStateSelected];
        } else {
            [button setTitleColor: COLOR_DEFAULT forState:UIControlStateNormal];
            [button setTitleColor: [UIColor blackColor] forState:UIControlStateSelected];
        }
        
        
        
        [button setTitle:[cateDict objectForKey:@"Description"] forState:UIControlStateHighlighted];
        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        //[button drawCircleButtonForSelectedState];
        [button setFrame:frame];
        [button setTranslatesAutoresizingMaskIntoConstraints:YES];
        //[button drawCircleButtonForSelectedState];
        [button addTarget:self action:@selector(cateButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont systemFontOfSize:24.0]];
        [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
        [button setTag:_numberOfCates + KEYBOARDTAGOFFSET];
        [self.bottomScrollContentView addSubview:button];
        _numberOfCates++;
    }
   
    self.lastSelectedIndex = 0;
    UIButton * selectButton =(UIButton *)[self.bottomScrollContentView viewWithTag:self.lastSelectedIndex + KEYBOARDTAGOFFSET];
    
    //UIButton *selectButton = (UIButton *)[self.cateButtons objectAtIndex:self.lastSelectedIndex];
    [selectButton setSelected:YES];
    NSString *cateTitle = [[activeCates objectAtIndex:self.lastSelectedIndex]objectForKey:@"Name"];
    [self.categoryIndicator setText:cateTitle];
    
    
    //setting up top scroll
    //self.keyboardButtons = [NSMutableArray arrayWithObjects: nil];
    NSArray *buttonTitles = [userdef objectForKey:USER_DEFAULT_KEY_FREQUENTLY_USED];
    
    
    self.keyboardTitles = buttonTitles;
    
    //timeString = [timeString stringByAppendingString:[NSString stringWithFormat:@"init %.02f",[date timeIntervalSinceNow]]];
    _numberOfKeyboards = 0;
    [self refreshKeyboardButtonsWithTitleArray:self.keyboardTitles];
    
}

-(void) refreshKeyboardButtonsWithTitleArray:(NSArray *) buttonTitles {
    NSUInteger buttonTitlesNumber = [buttonTitles count];
    NSUInteger keyboardButtonNumber = _numberOfKeyboards;
    if (keyboardButtonNumber >= buttonTitlesNumber) {
        //buttons are enough for current context
        for (int cnt = 0; cnt < keyboardButtonNumber; cnt++) {
            UIButton * button =(UIButton *)[self.topScrollContentView viewWithTag:cnt + KEYBOARDTAGOFFSET];
            if(cnt < buttonTitlesNumber) {
                NSString * title = [[buttonTitles objectAtIndex:cnt] objectForKey:@"Name"];
                NSArray *strings = [title componentsSeparatedByString:@","];
                
                
                if([strings count] > 1) {
                    [button setTitle:[strings objectAtIndex:0] forState:UIControlStateNormal];
                } else {
                    [button setTitle:title forState:UIControlStateNormal];
                }
                
                
                //[button setTitle:title forState:UIControlStateSelected];
                //[button setTitle:title forState:UIControlStateHighlighted];
                [button setHidden:NO];
            } else {
                [button removeFromSuperview];
                button = nil;
                //[button setHidden:YES];
            }
        }
        self.numberOfKeyboards = buttonTitlesNumber;
        //[self layoutKeyboardButtons];
    } else {
        for (int cnt = 0; cnt < buttonTitlesNumber; cnt++) {
            if(cnt < keyboardButtonNumber) {
                UIButton * button =(UIButton *)[self.topScrollContentView viewWithTag:cnt + KEYBOARDTAGOFFSET];
                
                //NSLog(@"size of Object: %zd", malloc_size((__bridge const void *)(button)));
                
                NSString * title = [[buttonTitles objectAtIndex:cnt] objectForKey:@"Name"];
                NSArray *strings = [title componentsSeparatedByString:@","];
                
                
                if([strings count] > 1) {
                    [button setTitle:[strings objectAtIndex:0] forState:UIControlStateNormal];
                } else {
                    [button setTitle:title forState:UIControlStateNormal];
                }
                [button setHidden:NO];
            } else {
                
                UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
                //NSDictionary *titleDict = [buttonTitles objectAtIndex:cnt];
                
                
                NSString * title = [[buttonTitles objectAtIndex:cnt] objectForKey:@"Name"];
                NSArray *strings = [title componentsSeparatedByString:@","];
                
                
                if([strings count] > 1) {
                    [button setTitle:[strings objectAtIndex:0] forState:UIControlStateNormal];
                } else {
                    [button setTitle:title forState:UIControlStateNormal];
                }
                
                if(self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark){
                    [button setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                    [button setTitleColor: [UIColor blackColor] forState:UIControlStateHighlighted];
                } else {
                    [button setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
                    [button setTitleColor: COLOR_DEFAULT forState:UIControlStateHighlighted];
                }
                
                [button setFrame:CGRectMake(0, 0, 30, 30)];
                [button setTranslatesAutoresizingMaskIntoConstraints:YES];
                [button addTarget:self action:@selector(keyboardButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
                [button.titleLabel setFont:[UIFont systemFontOfSize:40.0]];
                [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
                [button setTag:_numberOfKeyboards + KEYBOARDTAGOFFSET];
                [self.topScrollContentView addSubview:button];
                //[self.keyboardButtons insertObject:button atIndex:cnt];
                _numberOfKeyboards++;
            }
        }
        [self layoutKeyboardButtons];
    }
}

-(void)resizeScrollViewSize{
    CGRect topScrollContainerFrame = self.topScrollContainer.frame;
    CGFloat topContentWidth = (ceilf((float)[self.keyboardTitles count] / keyboardButtonNumberInColumn)) * (keyboardButtonSide + keyboardButtonLeftMargin);
    //NSLog(@"seting%f",topContentWidth);
    CGSize topContentSize;
    if(topContentWidth > self.topScrollContainer.frame.size.width) {
        topContentSize = CGSizeMake(topContentWidth, topScrollContainerFrame.size.height - self.categoryIndicator.frame.size.height);
    } else {
        topContentSize = self.topScrollContainer.frame.size;
    }
    
    [self.topScrollContentView setFrame:CGRectMake(0, 0, topContentSize.width, topContentSize.height)];
    [self.topScrollView setContentSize:topContentSize];
    
    //timeString = [timeString stringByAppendingString:[NSString stringWithFormat:@"fin%.02f",[date timeIntervalSinceNow]]];
    //[self.categoryIndicator setText:timeString];
}

#pragma mark - key methods

- (IBAction) globeKeyPressed:(id)sender {
    
    //required functionality, switches to user's next keyboard
    [self advanceToNextInputMode];
    
    /*
    [[self.topScrollContentView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.topScrollContainer = nil;
    self.topScrollView = nil;
    
    
    self.topScrollContentView = nil;
    self.categoryIndicator = nil;
    
    self.bottomScrollContainer = nil;
    self.bottomScrollView = nil;
    self.bottomScrollContentView = nil;
    self.backspaceButton = nil;
    self.cateButtons = nil;
    self.keyboardTitles = nil;
    
    
    UIView *cview = self.view;
    cview = nil;
    self.view = self.fontview;
    */
    
}

- (IBAction) keyPressed:(UIButton*)sender {
    
    //inserts the pressed character into the text document
    [self.textDocumentProxy insertText:sender.titleLabel.text];

}

-(IBAction) backspaceKeyPressed: (UIButton*) sender {
    if(self.backspaceTimer) {
        [self.backspaceTimer invalidate];
    }
    [self.textDocumentProxy deleteBackward];
}
-(void)deleteback {
    [self.textDocumentProxy deleteBackward];
}
-(IBAction) backspaceKeyHold: (UIButton*) sender {
    
    self.backspaceTimer = [NSTimer scheduledTimerWithTimeInterval:0.15f target:self selector:@selector(deleteback) userInfo:nil repeats:YES];
}

-(IBAction) spaceKeyPressed: (UIButton*) sender {
    
    [self.textDocumentProxy insertText:@" "];
    
}

-(IBAction) returnKeyPressed: (UIButton*) sender {
    
    [self.textDocumentProxy insertText:@"\n"];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    //CGFloat pageWidth = self.topScrollView.frame.size.width;
    //int page = floor((self.topScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
}

#pragma mark - Top Scroll Buttons
NSTimer *timer;
-(void)timerHandler {
    NSUserDefaults *userdef = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.com.apprilo.emopediagroup"];
    NSMutableArray *activeCates = [NSMutableArray arrayWithArray:[userdef objectForKey:USER_DEFAULT_KEY_ACTIVE_UNICODE_CATEGORIES]];
    NSString *cateTitle = [[activeCates objectAtIndex:self.lastSelectedIndex]objectForKey:@"Name"];
    [self.categoryIndicator setText:cateTitle];

}

-(void)keyboardButtonSelected:(id) sender {
    UIButton *button = (UIButton *)sender;
    NSUInteger buttonIndex = [button tag] - KEYBOARDTAGOFFSET;
    
    
    if(self.keyboardExpandedTag == -1 ) {
        //expand keyboard
        //NSString * title = [[buttonTitles objectAtIndex:cnt] objectForKey:@"Name"];
        
        if([[[[self.keyboardTitles objectAtIndex:buttonIndex]objectForKey:@"Name"] componentsSeparatedByString:@","] count] > 1) {
            self.keyboardExpandedTag = (int)[button tag];
            NSArray *titleArray =[[[self.keyboardTitles objectAtIndex:buttonIndex]objectForKey:@"Name"] componentsSeparatedByString:@","];
            for (int i = 1; i < [titleArray count]; i++) {
                UIButton * button =(UIButton *)[self.topScrollContentView viewWithTag:i + self.keyboardExpandedTag];
                [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            }
            
            NSString *description = [[[self.keyboardTitles objectAtIndex:buttonIndex]objectForKey:@"Description"]uppercaseString];
            [self.categoryIndicator setAlpha:1.0];
            [self.categoryIndicator setText:[NSString stringWithFormat:@"%@: Choose a variant",description]];
        } else {
            NSString *insertedText = button.titleLabel.text;
            [self.textDocumentProxy insertText:insertedText];
            NSString *description = [[[self.keyboardTitles objectAtIndex:buttonIndex]objectForKey:@"Description"]uppercaseString];
            [self.categoryIndicator setAlpha:1.0];
            [self.categoryIndicator setText:description];
            
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
            
            if(timer){
                [timer invalidate];
            }
            timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerHandler) userInfo:nil repeats:NO];
        }
        
        
    } else {
        if([[[[self.keyboardTitles objectAtIndex:buttonIndex]objectForKey:@"Name"] componentsSeparatedByString:@","] count] > 1 && (buttonIndex < self.keyboardExpandedTag - KEYBOARDTAGOFFSET || buttonIndex > self.keyboardExpandedTag - KEYBOARDTAGOFFSET + 5)) {
            //unexpand and expand
            for (int i = 1; i < 6; i++) {
                UIButton * button =(UIButton *)[self.topScrollContentView viewWithTag:i + self.keyboardExpandedTag];
                
                NSString *titleString = [[self.keyboardTitles objectAtIndex:i + self.keyboardExpandedTag - KEYBOARDTAGOFFSET] objectForKey:@"Name"];
                NSString *title = [[titleString componentsSeparatedByString:@","]objectAtIndex:0];
                
                [button setTitle:title forState:UIControlStateNormal];
            }
            
            self.keyboardExpandedTag = (int)[button tag];
            NSArray *titleArray =[[[self.keyboardTitles objectAtIndex:buttonIndex]objectForKey:@"Name"] componentsSeparatedByString:@","];
            for (int i = 1; i < [titleArray count]; i++) {
                UIButton * button =(UIButton *)[self.topScrollContentView viewWithTag:i + self.keyboardExpandedTag];
                [button setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            }
            
            NSString *description = [[[self.keyboardTitles objectAtIndex:buttonIndex]objectForKey:@"Description"]uppercaseString];
            [self.categoryIndicator setAlpha:1.0];
            [self.categoryIndicator setText:[NSString stringWithFormat:@"%@: Choose a variant",description]];

        } else {
            //insert title and unexpand
            NSString *insertedText = button.titleLabel.text;
            [self.textDocumentProxy insertText:insertedText];
            
            int variantNumber =(int) (buttonIndex - self.keyboardExpandedTag + KEYBOARDTAGOFFSET);
            NSString *description = [[[self.keyboardTitles objectAtIndex:self.keyboardExpandedTag - KEYBOARDTAGOFFSET]objectForKey:@"Description"]uppercaseString];
            [self.categoryIndicator setAlpha:1.0];
            [self.categoryIndicator setText:[NSString stringWithFormat:@"%@: Variant %d",description,variantNumber]];
            
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
            
            if(timer){
                [timer invalidate];
            }
            timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerHandler) userInfo:nil repeats:NO];
            
            for (int i = 1; i < 6; i++) {
                UIButton * button =(UIButton *)[self.topScrollContentView viewWithTag:i + self.keyboardExpandedTag];
                
                NSString *titleString = [[self.keyboardTitles objectAtIndex:i + self.keyboardExpandedTag - KEYBOARDTAGOFFSET] objectForKey:@"Name"];
                NSString *title = [[titleString componentsSeparatedByString:@","]objectAtIndex:0];
                
                [button setTitle:title forState:UIControlStateNormal];
            }
            self.keyboardExpandedTag = -1;
            
        }
        
    }
    
}


#pragma mark - Bottom Scroll Buttons
-(void)cateButtonSelected :(UIButton * ) sender {
    //CircledLinebutton *button = (CircledLinebutton *)sender;
    NSUInteger buttonIndex = sender.tag - KEYBOARDTAGOFFSET;

    if(buttonIndex != self.lastSelectedIndex) {
        [sender setSelected:YES];
        UIButton *oldButton = (UIButton *)[self.bottomScrollContentView viewWithTag:self.lastSelectedIndex + KEYBOARDTAGOFFSET];
        [oldButton setSelected:NO];
        self.lastSelectedIndex = buttonIndex;
        
        //[self killScroll];
        
        NSUserDefaults *userdef = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.com.apprilo.emopediagroup"];
        NSMutableArray *activeCates = [NSMutableArray arrayWithArray:[userdef objectForKey:USER_DEFAULT_KEY_ACTIVE_UNICODE_CATEGORIES]];
        if(timer) {
            [timer invalidate];
        }
        NSString *cateTitle = [[activeCates objectAtIndex:buttonIndex]objectForKey:@"Name"];
        [self.categoryIndicator setText:cateTitle];
        
        NSArray *buttonTitles;
        if(buttonIndex!=0) {
            buttonTitles = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:cateTitle withExtension:@"plist"]];
            
        } else {
            buttonTitles = [userdef objectForKey:USER_DEFAULT_KEY_FREQUENTLY_USED];
            
        }
        
        self.keyboardTitles = buttonTitles;
        [self refreshKeyboardButtonsWithTitleArray:self.keyboardTitles];
        
        [self resizeScrollViewSize];

    }
}


@end
