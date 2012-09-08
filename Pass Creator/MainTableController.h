//
//  MainTableController.h
//  Pass Creator
//
//  Created by Paul Wagener on 02-09-12.
//  Copyright (c) 2012 Paul Wagener. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableController : UITableViewController {
    IBOutlet UILabel *creditLabel;
    IBOutlet UIView *creditsView;
    
    NSMutableArray *passes;
}

- (IBAction) edit :(id)sender;
@end
