//
//  InformacionVC.m
//  Workapp2
//
//  Created by Rodrigo Guinea on 16/03/15.
/*
 
 Copyright (c) WorkApp 2015
 
 */

#import "InformacionVC.h"
@interface InformacionVC ()

@end

@implementation InformacionVC
- (void)viewDidLoad {
    
    [super viewDidLoad];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"workicon.png"]]];
    self.navigationItem.rightBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationController.title = @"Información";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString *peso = [defaults stringForKey:PESO];
    NSLog(@"%@",[defaults objectForKey:PESO]);
    if(peso == nil){
        self.PesoLb.text = [NSString stringWithFormat:@"%1.0f Kg",self.PesoS.value];
        self.EstaturaLb.text = [NSString stringWithFormat:@"%1.0f cm",self.EstaturaS.value];
    }else{
        self.NombreTF.text = [defaults stringForKey:@"idUsuario"];
        
        //self.fechaNacimientoDT.date = ;
        ;
        NSLog(@"%@",[defaults objectForKey:FECHA]);
        [self.fechaNacimientoDT setDate:[defaults objectForKey:FECHA]];
       /* self.fechaNacimientoDT.date = nsd.date;*/
        self.PesoS.value =[[defaults stringForKey:PESO] intValue];
        self.EstaturaS.value =[[defaults stringForKey:ESTATURA] intValue];
        if([[defaults stringForKey:SEXO] isEqualToString:@"Hombre"]){
            self.SexoSC.selectedSegmentIndex = 0;
        }else{
            self.SexoSC.selectedSegmentIndex = 1;
        }
        self.PesoLb.text = [NSString stringWithFormat:@"%1.0f Kg",self.PesoS.value];
            self.EstaturaLb.text = [NSString stringWithFormat:@"%1.0f cm",self.EstaturaS.value];
    }
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
- (void)pickerChanged:(id)sender
{
    NSLog(@"value: %@",[sender date]);
}
-(BOOL)textFieldShouldReturn:(UITextView *)txtView
{
    [txtView resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)CambioPesoSlider:(id)sender {
    
    self.PesoLb.text = [NSString stringWithFormat:@"%1.0f Kg",self.PesoS.value];
}
- (IBAction)CambioEstaturaSlider:(id)sender {
    self.EstaturaLb.text = [NSString stringWithFormat:@"%1.0f cm",self.EstaturaS.value];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.NombreTF isFirstResponder] && [touch view] != self.NombreTF) {
        [self.NombreTF resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)GuardarInfo:(id)sender {
    if (_haveWeInternet) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.NombreTF.text forKey:NOMBRE];
        if (self.SexoSC.selectedSegmentIndex == 0){
            [defaults setObject:@"Hombre" forKey:SEXO];
        }else{
            [defaults setObject:@"Mujer" forKey:SEXO];
        }
        [defaults setObject:self.fechaNacimientoDT.date forKey:FECHA];
        [defaults setObject:[NSString stringWithFormat:@"%1.0f", self.PesoS.value]forKey:PESO];
        [defaults setObject:[NSString stringWithFormat:@"%1.0f", self.EstaturaS.value] forKey:ESTATURA];
        [defaults synchronize];
        [self mandaInformacion];
        NSInteger imc = self.PesoS.value/((self.EstaturaS.value/100)*(self.EstaturaS.value/100));
        NSString *mensaje = @"";
        if (imc >= 30){
            mensaje = [NSString stringWithFormat:@"Bienvenido %@. Tu IMC es de %ld por lo que se te recomienda hacer ejercicio cardiovascular.", self.NombreTF.text, (long)imc];
        }else{
            mensaje = [NSString stringWithFormat:@"Bienvenido %@. Tu IMC es de %ld por lo que se te recomienda rutinas de peso.", self.NombreTF.text, (long)imc];
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Datos Guardados" message: mensaje delegate: self cancelButtonTitle:@"Menu" otherButtonTitles: @"Empezar!", nil];
        [alert show];
    }else{
        [self lanzaAlertaErrorOk:@"Lo siento no tienes conexión a internet"];
    }
    
}
-(void) lanzaAlertaErrorOk:(NSString *) mensaje{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message: mensaje delegate: self cancelButtonTitle:@"OK" otherButtonTitles: nil, nil];
    [alert show];
}
-(void)mandaInformacion{
    if (_haveWeInternet) {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString *idUsuario = [defaults stringForKey:@"idUsuario"];
    NSString *nombre = self.NombreTF.text;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *fecha = [formatter stringFromDate:self.fechaNacimientoDT.date];
    NSString *peso = [NSString stringWithFormat:@"%d", (int)self.PesoS.value];
    NSString *altura = [NSString stringWithFormat:@"%d", (int)self.EstaturaS.value];
    NSString *sexo = @"";
    if (self.SexoSC.selectedSegmentIndex == 0){
        sexo = @"Hombre";
    }else{
        sexo = @"Mujer";
    }
    NSLog(@"%@",fecha);
    NSURL	*url	=	[NSURL	URLWithString:[NSString stringWithFormat:@"http://workapp2.jl.serv.net.mx/workapp/userData.jsp?id=%@&nombre=%@&peso=%@&fecha=%@&altura=%@&sexo=%@",idUsuario,nombre,peso,fecha,altura,sexo]];
    NSLog(@"%@",url);
    //NSData	*datosBin	=	[NSData dataWithContentsOfURL:url];
    }else{
        [self lanzaAlertaErrorOk:@"Lo siento no tienes conexión a internet"];
    }
}
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if(buttonIndex == 0){
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if(buttonIndex == 1){
        EjerciciosVC *ejercicios = (EjerciciosVC *)[storyboard instantiateViewControllerWithIdentifier:@"Ejercicios"];
        UINavigationController *navController = self.navigationController;
        [navController popViewControllerAnimated:NO];
        [navController pushViewController:ejercicios animated:YES];
    }
}

@end
