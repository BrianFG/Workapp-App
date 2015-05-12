//
//  SaludTVC.h
//  Workapp2
//
//  Created by José Antonio Guinea on 05/05/15.
//  Copyright (c) 2015 Rodrigo Guinea Nava. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaludTVC : UITableViewController <UITableViewDelegate, UITableViewDataSource , UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *checkedRows;

@end
