//
//  DetallesEjercicioVC.m
//  Workapp2
//
//  Created by Rodrigo Guinea on 17/03/15.
/*
 
 Copyright (c) WorkApp 2015
 
 */

#import "DetallesEjercicioVC.h"

@interface DetallesEjercicioVC (){
    UIAlertView *alert;
    NSTimer *timer;
    NSString *nombreEjercicio;
    NSInteger repeticionesTotales;
    NSInteger repeticionesActuales;
    NSString *repeticiones;
}
@end

@implementation DetallesEjercicioVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"workicon.png"]]];
    self.navigationItem.rightBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSArray *aux = [self.ejercicio componentsSeparatedByString:@" "];
    repeticionesTotales = [aux[0] intValue];
    repeticionesActuales = [self.checkedRows[self.selectedRow] intValue];
    repeticiones = aux[2];
    nombreEjercicio = aux[4];
    self.TituloLb.text = [NSString stringWithFormat:@"%@ %ld de %ld series de %@ repeticiones", nombreEjercicio, repeticionesActuales + 1, (long)repeticionesTotales, repeticiones];
    [self descargarDatos];
    self.imagenEjercicio.contentMode = UIViewContentModeScaleAspectFit;
    timer = [NSTimer timerWithTimeInterval:4 target:self selector:@selector(timerTick:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
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
#pragma mark - Metodos del delegado RedDelegado
-(void)descargarDatos{
        
        NSString *direction = [NSString stringWithFormat: @"%@",self.urlImagen];
        NSLog(@"%@",self.urlImagen);
        Red *descarga = [[Red alloc]init];
        descarga.delegado = self;
        [descarga descargar:direction conID:DATOS_IMAGEN];
   
}
-(void)terminaDescarga:(NSData *)datos conID:(NSInteger)ID{
    if(ID==DATOS_IMAGEN){
        UIImage *img = [UIImage imageWithData:datos];
        self.imagenEjercicio.image = img;
    }/*else if(ID==DATOS_TEXTO){
        NSString *str = [[NSString alloc] initWithData:self.buffer encoding:NSUTF8StringEncoding];
        //self.tvDatos.text = str;
        NSLog(str);
    }*/
}
- (void)timerTick:(NSTimer*)timer
{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    [timer invalidate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)completadoPressed:(id)sender {
    repeticionesActuales++;
    [self.checkedRows removeObjectAtIndex:self.selectedRow];
    [self.checkedRows insertObject:[NSNumber numberWithInt:(int)repeticionesActuales] atIndex:self.selectedRow];
    
    if (repeticionesActuales == repeticionesTotales){
        [self lanzaAlertaCompletado];
    }else{
        [self lanzaAlertaCronometro];
    }
    
    self.TituloLb.text = [NSString stringWithFormat:@"%@ %ld de %ld series de %@ repeticiones", nombreEjercicio, repeticionesActuales + 1, (long)repeticionesTotales, repeticiones];
    self.startDate = [NSDate date];
    
    // Create the stop watch timer that fires every 0.5 s
    self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/2 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}
- (IBAction)onStopPressed:(id)sender {
    [self.stopWatchTimer invalidate];
    self.stopWatchTimer = nil;
    [self updateTimer];
}
- (void)updateTimer
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
    if (timeInterval >= 30){
        [self.stopWatchTimer invalidate];
        self.stopWatchTimer = nil;
        self.stopWatchLabel.text = @"Acabó tu tiempo de descanso!";
    }else{
        timeInterval = 30 - timeInterval;
        NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
        // Create a date formatter
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"mm:ss"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
        // Format the elapsed time and set it to the label
        NSString *timeString = [dateFormatter stringFromDate:timerDate];
        self.stopWatchLabel.text = [NSString stringWithFormat:@"Descansa %@ seg",timeString];
    }
}

-(void) lanzaAlertaCronometro{
    NSString *mensaje = [NSString stringWithFormat:@"En hora buena! Llevas %ld de %ld series. Descansa antes de la siguiente serie",repeticionesActuales, repeticionesTotales];
    UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:@"Bien hecho!" message: mensaje delegate: self cancelButtonTitle:@"Continuar" otherButtonTitles: nil, nil];
    [alerta show];
}
-(void) lanzaAlertaCompletado{
    if(_haveWeInternet){
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults synchronize];
        NSString *idUsuario = [defaults stringForKey:@"idUsuario"];
        NSString *mensaje = [NSString stringWithFormat:@"Excelente! Terminaste las %ld series. Pasa al siguiente ejercicio después de descansar.",repeticionesActuales];
        UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:@"Bien hecho!" message: mensaje delegate: self cancelButtonTitle:@"Hacer más"  otherButtonTitles: @"Lista de ejercicios", nil];
        NSURL	*url	=	[NSURL	URLWithString:[NSString stringWithFormat:@"http://workapp2.jl.serv.net.mx/workapp/addWork.jsp?idUser=%@&idWork=%ld",idUsuario,(long)self.idEjercicio]];
        NSLog(@"%@",url);
        NSData	*datosBin	=	[NSData dataWithContentsOfURL:url];
        [alerta show];
    }else{
        [self lanzaAlertaErrorOk:@"Lo siento no tienes conexión a internet"];
    }
    
}
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void) lanzaAlertaErrorOk:(NSString *) mensaje{
    UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:@"Error" message: mensaje delegate: self cancelButtonTitle:@"OK" otherButtonTitles: nil, nil];
    [alerta show];
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
