//
//  LoginVC.m
//  Workapp2
//
//  Created by Rodrigo Guinea on 22/04/15.
/*
 
 Copyright (c) WorkApp 2015
 
 */

#import "LoginVC.h"
@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"workicon.png"]]];
    self.navigationItem.rightBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self cambiaVisibilidadTF:self.tfRepiteContrasena];
    [self cambiaVisibilidadButton: self.botonYaTengo];
    [self cambiaVisibilidadButton: self.botonCrear];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)botonCrearCuenta:(id)sender {
    [self modificaAlphasView];
}
- (IBAction)botonIngresar:(id)sender {
    if([self esContrasenaCorrecta]){
        //ir a menu
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //borra contrasenia
        [self borraContrasena];
        //lanza alerta
        [self lanzaAlertaErrorOk:@"Usuario y/o contraseña incorrectos. Intenta de nuevo."];
    }
}
- (IBAction)botonYaTengoCuenta:(id)sender {
    [self modificaAlphasView];
}
- (IBAction)botonCrear:(id)sender {
    if([self.tfContrasena.text isEqualToString: self.tfRepiteContrasena.text]){
        if(self.tfContrasena.text.length > 5){
            [self creaCuenta];
        }else{
            [self lanzaAlertaErrorOk:@"La contraseña debe de ser de 6 caracteres o más."];
        }
    }else{
        [self lanzaAlertaErrorOk:@"Las contraseñas no son iguales. Intenta de nuevo."];
        [self borraContrasena];
    }
}
-(void)modificaAlphasView{
    //cambiar alfa:a
    [self cambiaVisibilidadTF:     self.tfRepiteContrasena];
    [self cambiaVisibilidadButton: self.botonYaTengo];
    [self cambiaVisibilidadButton: self.botonCrear];
    [self cambiaVisibilidadButton: self.botonCrearNuevaCuenta];
    [self cambiaVisibilidadButton: self.botonIngresar];
}
-(void) borraContrasena{
    self.tfContrasena.text = @"";
    self.tfRepiteContrasena.text = @"";
}
-(BOOL) esContrasenaCorrecta{
    if (_haveWeInternet) {
        NSString *nombreUsuario = self.tfNombreUsuario.text;
        NSString *password = self.tfContrasena.text;
        NSString *hash = [self sha1:password];
        NSLog(@"Usuario: %@, pass: %@, hash: %@",nombreUsuario,password,hash);
        //////////////////////////////////////////////////////////////////////
        //                                                                  //
        //                      enviar hash y password                      //
        //                                                                  //
        //////////////////////////////////////////////////////////////////////
        NSURL	*url	=	[NSURL	URLWithString:[NSString stringWithFormat:@"http://workapp2.jl.serv.net.mx/workapp/login.jsp?user=%@&pass=%@",nombreUsuario,hash]];
        NSLog(@"%@",url);
        NSError *error = nil;
        
        NSData	*datosBin	=	[NSData dataWithContentsOfURL:url];
        NSInteger idUsuario = 0;
        NSArray	*jsonArray	=	[NSJSONSerialization JSONObjectWithData:datosBin
                                                             options:NSJSONReadingMutableContainers	error:&error];
        if	(	jsonArray	)	{
            for(NSDictionary	*item	in	jsonArray)	{
                NSLog(@"Item:	%@",item);
                idUsuario = [[item objectForKey:@"id"] integerValue];
            }
        }else{
            NSLog(@"Error	parseando	JSON:	%@",error);
        }
        if(idUsuario > 0){
            [self guardaUsuario:idUsuario];
            return YES;
        }
        return NO;
    }else{
        [self lanzaAlertaErrorOk:@"Lo siento no tienes conexión a internet"];
        return NO;
    }
    
}
- (void)creaCuenta{
    if (_haveWeInternet){
        NSInteger status = 0;
        NSString *nombreUsuario = self.tfNombreUsuario.text;
        NSString *password = self.tfContrasena.text;
        NSString *hash = [self sha1:password];
        NSError *error = nil;
        NSURL	*url	=	[NSURL	URLWithString:[NSString stringWithFormat:@"http://workapp2.jl.serv.net.mx/workapp/newUser.jsp?user=%@&pass=%@",nombreUsuario,hash]];
        NSLog(@"%@",url);
        NSData	*datosBin	=	[NSData dataWithContentsOfURL:url];
        NSArray	*jsonArray	=	[NSJSONSerialization JSONObjectWithData:datosBin
                                                             options:NSJSONReadingMutableContainers	error:&error];
        if	(	jsonArray	)	{
            for(NSDictionary	*item	in	jsonArray)	{
                NSLog(@"Item:	%@",item);
                status = [[item objectForKey:@"status"] integerValue];
            }
        }else{
            NSLog(@"Error	parseando	JSON:	%@",error);
        }
        if (status == 0){
            [self lanzaAlertaErrorOk:@"Ya existe un usuario con ese nombre. Prueba de nuevo"];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Éxito" message: @"Has creado tu cuenta correctamente." delegate: self cancelButtonTitle:@"Aceptar" otherButtonTitles: nil, nil];
            [alert show];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }else{
        [self lanzaAlertaErrorOk:@"Lo siento no tienes conexión a internet"];
    }

}
- (void)guardaUsuario:(NSInteger)idUsuario{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:idUsuario forKey:@"idUsuario"];
    [defaults synchronize];
    NSLog(@"Usuario Guardado");
}
- (void)cambiaVisibilidadLabel: (UILabel *) sender{
    sender.alpha = -sender.alpha +1;
}
- (void)cambiaVisibilidadButton: (UIButton *) sender{
    sender.alpha = -sender.alpha +1;
}
- (void)cambiaVisibilidadTF: (UITextField *) sender{
    sender.alpha = -sender.alpha +1;
}
- (NSString *)sha1:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cStr, (CC_LONG) strlen(cStr), result);
    NSString *s = [NSString  stringWithFormat:
                   @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   result[0], result[1], result[2], result[3], result[4],
                   result[5], result[6], result[7],
                   result[8], result[9], result[10], result[11], result[12],
                   result[13], result[14], result[15],
                   result[16], result[17], result[18], result[19]
                   ];
    
    return s;
}
-(void) lanzaAlertaCancelarOk: (NSString *) titulo mensaje:(NSString *) mensaje{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titulo message: mensaje delegate: self cancelButtonTitle:@"Aceptar" otherButtonTitles: @"OK", nil];
    [alert show];
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
