//
//  FontsViewController.m
//  Emopedia
//
//  Created by Eric Liang on 5/4/15.
//  Copyright (c) 2015 Xiaoyong Liang. All rights reserved.
//

#import "FontsViewController.h"
#import "Common.h"
@interface FontsViewController ()

@end

@implementation FontsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 40)];
    titleLabel.text = self.title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = COLOR_DEFAULT;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FONT_DEFAULT_WITH_SIZE(16);
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.rightBarButtonItem = [self rightBarButtonWithTitle:@"Edit"];
    
    self.tableView.separatorColor = COLOR_DEFAULT;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(UIBarButtonItem *)rightBarButtonWithTitle:(NSString *)title {
    UIBarButtonItem *rightButton = nil;
    NSString *fontName = [title isEqualToString:@"Edit"] ? @"CaeciliaLTStd-Roman" :@"CaeciliaLTStd-Bold";
    rightButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
    [rightButton setTitleTextAttributes:@{
                                          NSFontAttributeName: [UIFont fontWithName:fontName size:16],
                                          NSForegroundColorAttributeName: COLOR_DEFAULT
                                          } forState:UIControlStateNormal];
    [rightButton setTitleTextAttributes:@{
                                          NSFontAttributeName: [UIFont fontWithName:fontName size:16],
                                          NSForegroundColorAttributeName: [UIColor colorWithComplementaryFlatColorOf:COLOR_DEFAULT]
                                          } forState:UIControlStateHighlighted];
    return rightButton;
}

- (IBAction)editButtonPressed:(UIBarButtonItem *)sender {
    [self.tableView setEditing:![self.tableView isEditing] animated:YES];
    NSString *editTitle = [self.tableView isEditing]? @"Done" : @"Edit";
    self.navigationItem.rightBarButtonItem = [self rightBarButtonWithTitle:editTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

@end
