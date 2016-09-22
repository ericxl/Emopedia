//
//  UnicodeViewController.m
//  Emopedia
//
//  Created by Eric Liang on 5/3/15.
//  Copyright (c) 2015 Xiaoyong Liang. All rights reserved.
//

#import "UnicodeViewController.h"
#import "Common.h"
#import "DetailViewController.h"
#import "SettingsViewController.h"
#define TABLE_VIEW_SECTION_ACTIVE 0
#define TABLE_VIEW_SECTION_INACTIVE 1

#define MAX_CATEGORIES 9

@interface UnicodeViewController ()
@property (nonatomic) NSMutableArray *activeCates;
@property (nonatomic) NSMutableArray *inactiveCates;
@property (nonatomic) NSArray *allCate;

@end

@implementation UnicodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Emopedia";
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 150, 40)];
    titleLabel.text = self.title;
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
    
    self.allCate = [NSArray arrayWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Categories" withExtension:@"plist"]];
    NSUserDefaults *userdef = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.com.apprilo.emopediagroup"];
    self.activeCates = [NSMutableArray arrayWithArray:[userdef objectForKey:USER_DEFAULT_KEY_ACTIVE_UNICODE_CATEGORIES]];
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.allCate];
    [array removeObjectsInArray:self.activeCates];
    self.inactiveCates = array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)settingButtonPressed:(UIBarButtonItem *)sender {
    SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self presentViewController:settingsViewController animated:YES completion:nil];
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
    if(indexPath.section == TABLE_VIEW_SECTION_ACTIVE) {
        cell.textLabel.text = [[self.activeCates objectAtIndex:indexPath.row] objectForKey:@"Name"];
        cell.textLabel.textColor = [UIColor blackColor];
    } else if (indexPath.section == TABLE_VIEW_SECTION_INACTIVE){
        cell.textLabel.text = [[self.inactiveCates objectAtIndex:indexPath.row] objectForKey:@"Name"];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.font = FONT_DEFAULT_WITH_SIZE(15);
    
    cell.tintColor = COLOR_DEFAULT;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == TABLE_VIEW_SECTION_ACTIVE) {
        return [self.activeCates count];
    } else{
        return [self.inactiveCates count];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case TABLE_VIEW_SECTION_ACTIVE:
            return NSLocalizedString(@"Active", nil);
            break;

        case TABLE_VIEW_SECTION_INACTIVE:
            return NSLocalizedString(@"Inactive",nil);
            break;
        default:
            return nil;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    switch (section) {
        case TABLE_VIEW_SECTION_ACTIVE:
            return NSLocalizedString(@"To add Emopedia keyboard, go to Home > Settings > General > Keyboard > Keyboards > Add New Keyboard... > Select Emopedia", nil);
            break;
            
        case TABLE_VIEW_SECTION_INACTIVE:
            return [NSString stringWithFormat: @"For best performance, only %d  categories by default can be active at the same time to maximize performance. To allow more, tap on Settings on top left. Note: This may makes the keyboard unstable.", MAX_CATEGORIES];
            break;
        default:
            return nil;
    }
}
#pragma mark TableView Delegate
-(BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == TABLE_VIEW_SECTION_ACTIVE) {
        return YES;
        
    }else {
        return NO;
    }
    
    
}

-(UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == TABLE_VIEW_SECTION_ACTIVE) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleInsert;
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == TABLE_VIEW_SECTION_ACTIVE) {
        if(indexPath.row != 0) {
            return YES;
        }
        else return NO;
    }else if (indexPath.section == TABLE_VIEW_SECTION_INACTIVE){
        if([self.activeCates count] <= MAX_CATEGORIES - 1) {
            return YES;
        }
        else {
            NSUserDefaults *iosdef = [NSUserDefaults standardUserDefaults];
            BOOL more = [[iosdef objectForKey:USER_DEFAULT_KEY_MORE_CATEGORIES]boolValue];
            if(more){
                return YES;
            } else {
                return NO;
            }
        }
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && [indexPath section] == TABLE_VIEW_SECTION_ACTIVE) {
        NSString *deletedCate = [self.activeCates objectAtIndex:indexPath.row];
        
        [self.activeCates removeObjectAtIndex:indexPath.row];
        
        NSMutableArray *allCateArray = [NSMutableArray arrayWithArray:self.allCate];
        [allCateArray removeObjectsInArray:self.activeCates];
        NSInteger indexOfDeleted = [allCateArray indexOfObject:deletedCate];
        self.inactiveCates = allCateArray;
        
        NSUserDefaults *userdef = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.com.apprilo.emopediagroup"];
        [userdef setObject:self.activeCates forKey:USER_DEFAULT_KEY_ACTIVE_UNICODE_CATEGORIES];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:indexOfDeleted inSection:TABLE_VIEW_SECTION_INACTIVE], nil] withRowAnimation:UITableViewRowAnimationTop];
        [tableView endUpdates];
    } else if (editingStyle == UITableViewCellEditingStyleInsert && [indexPath section] == TABLE_VIEW_SECTION_INACTIVE) {
        NSString *selectedCate = [self.inactiveCates objectAtIndex:indexPath.row];
        
        [self.inactiveCates removeObjectAtIndex:indexPath.row];
        NSUInteger index = [self.activeCates count];
        [self.activeCates insertObject:selectedCate atIndex:index];
        
        NSUserDefaults *userdef = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.com.apprilo.emopediagroup"];
        [userdef setObject:self.activeCates forKey:USER_DEFAULT_KEY_ACTIVE_UNICODE_CATEGORIES];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationBottom];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:TABLE_VIEW_SECTION_ACTIVE], nil] withRowAnimation:UITableViewRowAnimationTop];
        [tableView endUpdates];
    }
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if([sourceIndexPath section] == TABLE_VIEW_SECTION_ACTIVE && [destinationIndexPath section] == TABLE_VIEW_SECTION_ACTIVE) {
        NSString *cateToMove = self.activeCates[sourceIndexPath.row];
        
        [self.activeCates removeObjectAtIndex:sourceIndexPath.row];
        [self.activeCates insertObject:cateToMove atIndex:destinationIndexPath.row];
        
        NSUserDefaults *userdef = [[NSUserDefaults standardUserDefaults]initWithSuiteName:@"group.com.apprilo.emopediagroup"];
        [userdef setObject:self.activeCates forKey:USER_DEFAULT_KEY_ACTIVE_UNICODE_CATEGORIES];
    }
    
    
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (sourceIndexPath.section == proposedDestinationIndexPath.section) {
        NSInteger row = 1;
        if (proposedDestinationIndexPath.row < row) {
            return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
        }
    }
    
    return proposedDestinationIndexPath;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [detailViewController setTitle:[tableView cellForRowAtIndexPath:indexPath].textLabel.text];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:COLOR_DEFAULT];
    
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
