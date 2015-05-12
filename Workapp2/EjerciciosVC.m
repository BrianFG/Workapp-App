//
//  EjerciciosVC.m
//  Workapp2
//
//  Created by Rodrigo Guinea on 16/03/15.
/*
 
 Copyright (c) WorkApp 2015
 
 */

#import "EjerciciosVC.h"

@interface EjerciciosVC (){
    UITableView *thisTable;
}

@end

@implementation EjerciciosVC 

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"workicon.png"]]];
    self.navigationItem.rightBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationController.title = @"Ejercicios";
    if([self.checkedRows count]==0){
       // NSLog(@"iniciando checkedRows");
        self.checkedRows = [NSMutableArray arrayWithObjects:@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0, nil];
    }
    [self loadTableData];
    __weak __block typeof(self) weakself = self;
    
    //////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////
    //
    // create a Reachability object for www.google.com
    
    self.googleReach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    self.googleReach.reachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"GOOGLE Block Says Reachable(%@)", reachability.currentReachabilityString];
        NSLog(@"%@", temp);
        
        // to update UI components from a block callback
        // you need to dipatch this to the main thread
        // this uses NSOperationQueue mainQueue
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            weakself.haveWeInternet = YES;
        }];
    };
    
    self.googleReach.unreachableBlock = ^(Reachability * reachability)
    {
        NSString * temp = [NSString stringWithFormat:@"GOOGLE Block Says Unreachable(%@)", reachability.currentReachabilityString];
        NSLog(@"%@", temp);
        
        // to update UI components from a block callback
        // you need to dipatch this to the main thread
        // this one uses dispatch_async they do the same thing (as above)
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.haveWeInternet = NO;
        });
    };
    
    [self.googleReach startNotifier];
    
    // Do any additional setup after loading the view.
}
- (IBAction)TerminarPresionado:(id)sender {
    if([self ejerciciosCompletados]){
        //alerta completados
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Ejercicios Completados" message: @"Has completado todos los ejercicios del dia de hoy!" delegate: self cancelButtonTitle:nil otherButtonTitles: @"OK", nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Ejercicios no completados" message: @"¿Seguro que deseas dejar tus ejercicios incompletos?" delegate: self cancelButtonTitle:@"Si" otherButtonTitles: @"No", nil];
        [alert show];
    }
}
-(BOOL)ejerciciosCompletados{
    for(int i = 0; i < self.nombreArray.count ; i++){
        if ([self.checkedRows[i] integerValue] < [self.seriesArray[i] integerValue]){
            //NSLog(@"%@",self.checkedRows);
            //NSLog(@"%@",self.repeticionesArray);
            return false;
        }
    }
    return true;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [thisTable reloadData]; // to reload selected cell
    //NSLog(@"%@",self.checkedRows);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        return [self.tableData count];
    }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    thisTable = tableView;
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    int rowIsChecked = [[self.checkedRows objectAtIndex:indexPath.row] intValue];
    
    if (rowIsChecked >= [[self.seriesArray objectAtIndex:indexPath.row] intValue])
    {
        NSLog(@"yes");
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
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
}
-(void)cellImageViewTapped:(id) sender
{
    //UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    //NSLog(@"Tag = %ld", gesture.view.tag);

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        DetallesEjercicioVC *detalles = [storyboard instantiateViewControllerWithIdentifier:@"Detalles"];
        detalles.ejercicio = [self.tableData objectAtIndex:indexPath.row];
        detalles.checkedRows = self.checkedRows;
        detalles.selectedRow = indexPath.row;
        detalles.idEjercicio = [self.idEjercicioArray[indexPath.row] intValue];
        detalles.urlImagen = self.urlArray[indexPath.row];
        
        //NSLog(@"pasando valores: %@",detalles.urlImagen);
        UINavigationController *navController = self.navigationController;
        [navController pushViewController:detalles animated:YES];
    
    

    
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
}
- (void)loadTableData{
    [self iniciaArreglos];
    
    NSMutableArray *aux = [[NSMutableArray alloc] init];
    //self.tableData = @[@"",@"5x10 Lagartijas", @"5x15 Sentadillas", @"5x15 Abdominales"];
    for (int i = 0; i < self.seriesArray.count; i++){
        NSString *row =[NSString stringWithFormat:@"%@ x %@ - %@",self.seriesArray[i],self.repeticionesArray[i],self.nombreArray[i]];
        [aux addObject:row];
    }
    self.tableData = aux;
}
- (void) iniciaArreglos{
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        NSString *idUsuario = [defaults stringForKey:@"idUsuario"];
        NSError *error = nil;
        NSURL	*url	=	[NSURL	URLWithString:[NSString stringWithFormat:@"http://workapp2.jl.serv.net.mx/workapp/rutina.jsp?id=%@",idUsuario]];
        NSLog(@"%@",url);
        NSData	*datosBin	=	[NSData dataWithContentsOfURL:url];
        NSArray	*jsonArray	=	[NSJSONSerialization JSONObjectWithData:datosBin
                                                             options:NSJSONReadingMutableContainers	error:&error];
        self.nombreArray = [[NSMutableArray alloc]init];
        self.seriesArray= [[NSMutableArray alloc]init];
        self.repeticionesArray = [[NSMutableArray alloc]init];
        self.urlArray = [[NSMutableArray alloc]init];
        self.idEjercicioArray= [[NSMutableArray alloc]init];
        if	(	jsonArray	)	{
            for(NSDictionary	*item	in	jsonArray)	{
                //NSLog(@"Item:	%@",item);
                [self.nombreArray addObject: [item objectForKey:@"titulo"]];
                [self.repeticionesArray addObject: [item objectForKey:@"repeticiones"]];
                [self.seriesArray addObject: [item objectForKey:@"series"]];
                [self.urlArray addObject: [item objectForKey:@"imagen"]];
                [self.idEjercicioArray addObject: [item objectForKey:@"idEjercicioD"]];
            }
        }
        NSLog(@"URLS: %@",jsonArray);
    
    

}
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        UINavigationController *navController = self.navigationController;
        [navController popViewControllerAnimated:YES];
    }
}
-(void) lanzaAlertaErrorOk:(NSString *) mensaje{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message: mensaje delegate: self cancelButtonTitle:@"OK" otherButtonTitles: nil, nil];
    [alert show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
