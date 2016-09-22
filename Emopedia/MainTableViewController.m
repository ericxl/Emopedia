//
//  MainTableViewController.m
//  Emopedia
//
//  Created by Eric Liang on 4/14/15.
//  Copyright (c) 2015 Xiaoyong Liang. All rights reserved.
//

#import "MainTableViewController.h"
#import "UnicodeViewController.h"
#import "FontsViewController.h"
#import "SettingsViewController.h"
#import "Common.h"
#import "FMPlistEn.h"

#define TABLE_VIEW_SECTION_EMOPEDIA 0

@interface MainTableViewController ()

@property (nonatomic) NSArray *specials;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem *editTableButton;


@end


@implementation MainTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.specials = @[@"Unicode Symbols",@"Fonts", @"Emoticons",@"Stickers"];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 40)];
    titleLabel.text = @"Emopedia";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.textColor = COLOR_DEFAULT;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FONT_DEFAULT_WITH_SIZE(16);
    self.navigationItem.titleView = titleLabel;
    
    self.navigationItem.rightBarButtonItem = [self rightBarButtonWithTitle:@"Edit"];
    
    UIBarButtonItem *startStopButton = nil;
    startStopButton = [[UIBarButtonItem alloc] initWithTitle:@"⚙" style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonPressed:)];
    [startStopButton setTitleTextAttributes:@{
                                              NSFontAttributeName: [UIFont systemFontOfSize:20],
                                              NSForegroundColorAttributeName: COLOR_DEFAULT
                                              } forState:UIControlStateNormal];
    [startStopButton setTitleTextAttributes:@{
                                              NSFontAttributeName: [UIFont systemFontOfSize:20],
                                              NSForegroundColorAttributeName: [UIColor colorWithComplementaryFlatColorOf:COLOR_DEFAULT]
                                              } forState:UIControlStateHighlighted];
    self.navigationItem.leftBarButtonItem = startStopButton;

    self.tableView.separatorColor = COLOR_DEFAULT;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (IBAction)settingButtonPressed:(UIBarButtonItem *)sender {
    SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self presentViewController:settingsViewController animated:YES completion:nil];
}

#pragma mark TableView Data Source

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        //cell.tintColor = [UIColor flatCoffeeColor];
        //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    if (indexPath.section == TABLE_VIEW_SECTION_EMOPEDIA){
        cell.textLabel.text = [self.specials objectAtIndex:indexPath.row];
        if([[self.specials objectAtIndex:indexPath.row] isEqualToString:@"Fonts"]) {
            cell.textLabel.textColor = [UIColor flatForestGreenColor];
        } else if ([[self.specials objectAtIndex:indexPath.row] isEqualToString:@"Emoticons"]) {
            cell.textLabel.textColor = [UIColor flatDustSun];
        } else if ([[self.specials objectAtIndex:indexPath.row] isEqualToString:@"Stickers"]) {
            cell.textLabel.textColor = [UIColor flatNavyBlueColor];
        }
        
    }

    cell.textLabel.font = FONT_DEFAULT_WITH_SIZE(15);
    
    cell.tintColor = COLOR_DEFAULT;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == TABLE_VIEW_SECTION_EMOPEDIA) {
        return [self.specials count];
    }
    else return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case TABLE_VIEW_SECTION_EMOPEDIA:
            return NSLocalizedString(@"Emopedia", nil);
            break;
        default:
            return @"";
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case TABLE_VIEW_SECTION_EMOPEDIA:
            return NSLocalizedString(@"To add Emopedia keyboard, go to Home > Settings > General > Keyboard > Keyboards > Add New Keyboard... > Select Emopedia", nil);
            break;
        default:
            return nil;
    }
}
#pragma mark TableView Delegate
-(BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == TABLE_VIEW_SECTION_EMOPEDIA) {
        return YES;
        
    }else {
        return NO;
    }
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([[self.specials objectAtIndex:indexPath.row] isEqualToString:@"Unicode Symbols"]) {
        UnicodeViewController *unicodeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UnicodeViewController"];
        [unicodeViewController setTitle:[self.specials objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:unicodeViewController animated:YES];
    } else if([[self.specials objectAtIndex:indexPath.row] isEqualToString:@"Fonts"]) {
        
        FontsViewController *fontsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FontsViewController"];
        [fontsViewController setTitle:[self.specials objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:fontsViewController animated:YES];
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:COLOR_DEFAULT];
}
@end
