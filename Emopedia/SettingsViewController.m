//
//  SettingsViewController.m
//  Emopedia
//
//  Created by Eric Liang on 4/17/15.
//  Copyright (c) 2015 Xiaoyong Liang. All rights reserved.
//

#import "SettingsViewController.h"
#import "Common.h"

#define TABLE_VIEW_SECTION_GENERAL_SETTINGS 0
@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 40)];
    titleLabel.text = @"Settings";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = COLOR_DEFAULT;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FONT_DEFAULT_WITH_SIZE(16);
    self.navigationItem.titleView = titleLabel;
    // Do any additional setup after loading the view.
    UIBarButtonItem *leftBarButton = nil;
    leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
    [leftBarButton setTitleTextAttributes:@{
                                            NSFontAttributeName: [UIFont fontWithName:@"CaeciliaLTStd-Roman" size:16],
                                            NSForegroundColorAttributeName: COLOR_DEFAULT
                                            } forState:UIControlStateNormal];
    [leftBarButton setTitleTextAttributes:@{
                                            NSFontAttributeName: [UIFont fontWithName:@"CaeciliaLTStd-Roman" size:16],
                                            NSForegroundColorAttributeName: [UIColor colorWithComplementaryFlatColorOf:COLOR_DEFAULT]
                                            } forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = leftBarButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelButtonPressed:(UIBarButtonItem *) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        //cell.tintColor = [UIColor flatCoffeeColor];
        //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    if(indexPath.section == TABLE_VIEW_SECTION_GENERAL_SETTINGS) {
        if(indexPath.row == 0){
            cell.textLabel.text = @"Allow More Categories";
        }
        
        
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.font = FONT_DEFAULT_WITH_SIZE(15);
    
    cell.tintColor = COLOR_DEFAULT;
    //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
    cell.accessoryView = switchView;
    NSUserDefaults *iosdef = [NSUserDefaults standardUserDefaults];
    BOOL more = [[iosdef objectForKey:USER_DEFAULT_KEY_MORE_CATEGORIES]boolValue];
    [switchView setOn:more animated:NO];
    [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == TABLE_VIEW_SECTION_GENERAL_SETTINGS) {
        return 1;
    }
    else return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case TABLE_VIEW_SECTION_GENERAL_SETTINGS:
            return NSLocalizedString(@"General Settings", nil);
            break;
        default:
            return @"";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)switchChanged: (UISwitch *)sender {
    NSUserDefaults *iosdef = [NSUserDefaults standardUserDefaults];
    BOOL more = sender.isOn;
    [iosdef setObject:[NSNumber numberWithBool:more] forKey:USER_DEFAULT_KEY_MORE_CATEGORIES];
    [iosdef synchronize];
}
@end
