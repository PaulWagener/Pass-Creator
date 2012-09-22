//
//  MainTableController.h
//  Pass Creator
//
//  Created by Paul Wagener on 02-09-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableController : UIViewController<UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UILabel *creditLabel;
    IBOutlet UIView *creditsView;
    
    NSMutableArray *passes;
}

@property IBOutlet UITableView *tableView;

- (IBAction) edit :(id)sender;
- (void) setCreditText;
@end
