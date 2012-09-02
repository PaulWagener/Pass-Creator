//
//  MainTableController.m
//  Pass Creator
//
//  Created by Paul Wagener on 02-09-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import "MainTableController.h"

@implementation MainTableController

NSMutableArray *passes;

- (void) viewDidLoad {
    passes = [[NSUserDefaults standardUserDefaults] arrayForKey:@"Passes"].mutableCopy;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 1)
        return 1;
    
    return passes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
        return [tableView dequeueReusableCellWithIdentifier:@"AddCell"];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    NSDictionary *pass = [passes objectAtIndex:indexPath.row];
    cell.textLabel.text = [pass objectForKey:@"name"];
    
    return cell;
}

#pragma mark Editing

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [passes removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}



#pragma mark Moving

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
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
