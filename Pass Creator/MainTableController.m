//
//  MainTableController.m
//  Pass Creator
//
//  Created by Paul Wagener on 02-09-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "MainTableController.h"
#import "PassController.h"
#import "Credits.h"
#import "BuyCreditsController.h"

#define ADD_PASS_SECTION 0

@implementation MainTableController

- (void) viewDidLoad {
    passes = [[NSUserDefaults standardUserDefaults] arrayForKey:@"Passes"].mutableCopy;
    
    // Respond to changes in credits (for example the initial sync)
    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:store queue:nil usingBlock:^(NSNotification *notification) {
        [self setCreditText];
    }];
    
    // get any changes since the last app launch right now (safer)
    [store synchronize];
    
    self.tableView.alpha = 0.0;
    self.navigationController.navigationBar.alpha = 0.0;
    self.navigationController.navigationBarHidden = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBarHidden = NO;
        self.tableView.alpha = 1.0;
        self.navigationController.navigationBar.alpha = 1.0;
    }];
}

- (void) viewWillAppear:(BOOL)animated {
    [self setCreditText];
}

- (void) setCreditText {
    creditLabel.text = [NSString stringWithFormat:@"Credits: %d", [Credits getCredits]];
}

/**
 * Start editing passes
 */
- (IBAction) edit :(id)sender {
    [self.tableView setEditing:YES animated:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
}

/**
 * Stop editing passes
 */
- (void) done :(id) sender {
    [self.tableView setEditing:NO animated:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(edit:)];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"credits"]) {
        BuyCreditsController *buyCredits = segue.destinationViewController;
        buyCredits.parent = self;
    }
    
    if([segue.identifier hasPrefix:@"pass"]) {
        PassController *passController = segue.destinationViewController;
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        
        
        Pass *pass;
        int passIndex;
        if(path.section == ADD_PASS_SECTION) {
            
            // Load new pass
            NSData *passData = [[NSUserDefaults standardUserDefaults] dataForKey:@"New Pass"];
            pass = [NSKeyedUnarchiver unarchiveObjectWithData:passData];
            [passes insertObject:@{} atIndex:0];
            passIndex = 0;
        } else if(path.section != ADD_PASS_SECTION) {
            
            // Load existing pass
            NSData *passData = [[passes objectAtIndex:path.row] objectForKey:@"data"];
            pass = [NSKeyedUnarchiver unarchiveObjectWithData:passData];
            
            passIndex = path.row;
        }
        
        passController.loadPass = pass;
        passController.savePass = ^(Pass *newPass) {
            NSData *newPassData = [NSKeyedArchiver  archivedDataWithRootObject:newPass];
            [passes replaceObjectAtIndex:passIndex withObject:@{@"name": newPass.title, @"data": newPassData}];
            [self.tableView reloadData];
            
            [self save];
        };
    }
}

- (void) save {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:passes forKey:@"Passes"];
    [defaults synchronize];
}

- (IBAction)naarTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://twitter.com/PassCreator"]];
}

- (IBAction) naarFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://facebook.com/PassCreator"]];
}


#pragma mark Table

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section == [self numberOfSectionsInTableView:tableView]-1)
        return creditsView;
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self tableView:tableView viewForFooterInSection:section].bounds.size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == ADD_PASS_SECTION)
        return 1;
    
    return passes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == ADD_PASS_SECTION)
        return [tableView dequeueReusableCellWithIdentifier:@"AddCell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    NSDictionary *pass = [passes objectAtIndex:indexPath.row];
    cell.textLabel.text = [pass objectForKey:@"name"];
    
    return cell;
}

#pragma mark Editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section != ADD_PASS_SECTION;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [passes removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self save];
    }
}



#pragma mark Moving

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section != ADD_PASS_SECTION;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSArray *pass = [passes objectAtIndex:fromIndexPath.row];
    [passes removeObjectAtIndex:fromIndexPath.row];
	[passes insertObject:pass atIndex:toIndexPath.row];
    [self save];
}

/**
 * Contain moving rows within their sections
 */
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    return proposedDestinationIndexPath;
}



@end
