//
//  EstadisticasVC.m
//  Workapp2
//
//  Created by Rodrigo Guinea on 17/03/15.
/*
 
 Copyright (c) WorkApp 2015
 
 */

#import "EstadisticasVC.h"

@interface EstadisticasVC ()

@end

@implementation EstadisticasVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"workicon.png"]]];
    self.navigationItem.rightBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
     self.navigationController.title = @"Estadísticas";
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString *idUsuario = [defaults stringForKey:@"idUsuario"];
    NSURL	*url	=	[NSURL	URLWithString:[NSString stringWithFormat:@"http://workapp2.jl.serv.net.mx/workapp/estadisticas.jsp?id=%@",idUsuario]];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.wvEstadisticas loadRequest:requestObj];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
