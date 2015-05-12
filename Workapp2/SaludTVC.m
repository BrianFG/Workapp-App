//
//  SaludTVC.m
//  Workapp2
//
//  Created by José Antonio Guinea on 05/05/15.
//  Copyright (c) 2015 Rodrigo Guinea Nava. All rights reserved.
//

#import "SaludTVC.h"

@interface SaludTVC (){
    UITableView *thisTable;
    NSMutableArray *itsToDoChecked;
}

@end

@implementation SaludTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Salud!!!");
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"workicon.png"]]];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationController.title = @"Salud";
    
    self.checkedRows = [NSMutableArray arrayWithObjects: @NO,@NO,@NO,@NO,@NO, nil];
    [self loadTableData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadTableData{
    
    self.tableData = @[@"Lesión de pierna",@"Lesión de brazo", @"Lesión de espalda", @"Problema respiratorio",@"Problemas cardiaco"];
    NSLog(@"%@",self.tableData);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}
/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    thisTable = tableView;
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    imgView.image = [UIImage imageNamed: @"checkbox_unchecked.png"];
    
    cell.imageView.image = imgView.image;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.imageView.tag = indexPath.row;
    [cell.imageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellImageViewTapped:)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [cell.imageView addGestureRecognizer:tap];
    
    return cell;
}*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *CellIdentifier = @"ToDoList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    BOOL rowIsChecked = [[self.checkedRows objectAtIndex:indexPath.row] boolValue];
    
    if (rowIsChecked)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString *idUsuario = [defaults stringForKey:@"idUsuario"];
    NSInteger status;
    BOOL reverse = [[self.checkedRows objectAtIndex:indexPath.row] boolValue];
    if (reverse){
        status = 0;
        [self.checkedRows replaceObjectAtIndex:indexPath.row withObject: @NO];
    }else{
        status = 1;
        [self.checkedRows replaceObjectAtIndex:indexPath.row withObject: @YES];
    }
    NSLog(@"celda: %@",self.checkedRows);
    NSURL	*url	=	[NSURL	URLWithString:[NSString stringWithFormat:@"http://workapp2.jl.serv.net.mx/workapp/addC.jsp?idUser=%@&idC=%ld&status=%ld",idUsuario,indexPath.row+1,status]];
    NSData	*datosBin	=	[NSData dataWithContentsOfURL:url];
    NSLog(@"%@",url);
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
   
    
}

-(void)checkBoxButtonPressed:(id) sender
{
    //UIButton *checkBoxButton = (UIButton *) sender;
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSLog(@"Tag = %ld", (long)gesture.view.tag);
    
}

@end
