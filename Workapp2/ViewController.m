//
//  ViewController.m
//  Workapp2
//
//  Created by Rodrigo Guinea on 16/03/15.
/*
 
 Copyright (c) WorkApp 2015
 
 */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:0 forKey:@"idUsuario"];
    [defaults synchronize];*/
    // Create the data model
    _pageTitles = @[@"Rutinas personalizadas en tres pasos", @"Paso 1", @"Paso 2", @"Paso 3",@"Desarrollado en CEM"];
    _pageImages = @[@"workappBienvenido.png", @"registrate.png", @"informacion.png", @"disfruta.png", @"secundario.jpg"];
    // Do any additional setup after loading the view.
    // Create page view controller
    
    if (![self usuarioValido]){
        [self agregaVistaAlNavStack:@"Login" animado:NO];
    }
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"workicon.png"]]];
    self.navigationItem.rightBarButtonItem = item;
    
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

    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)AyudaApretado:(id)sender {
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AyudaPVC"];
    self.pageViewController.dataSource = self;
    
    AyudaVC *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    //self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    /*
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];*/
    UINavigationController *navController = self.navigationController;
    [navController pushViewController:self.pageViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (IBAction)ComenzarApretado:(id)sender {
    if (_haveWeInternet) {
        //pregunta si el usuario ya guardo informacion
        if([self usuarioValido]){
            if([self datoGuardado:IMC]){
                [self agregaVistaAlNavStack:@"Ejercicios" animado:YES];
            }else{
                NSString *mensaje = [NSString stringWithFormat:@"Por favor ingresa tus datos para poder comenzar."];
                [self lanzaAlertaCancelarOk: @"No has ingresado tus datos " mensaje: mensaje];
            }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"  message: @"Debes estar logeado para poder usar esta sección"delegate: self cancelButtonTitle:@"Cancelar" otherButtonTitles: @"Login", nil];
            [alert show];
        }
    }else{
        [self lanzaAlertaErrorOk:@"Lo siento no tienes conexión a internet"];
    }
    
}
- (IBAction)informacionApretado:(id)sender {
    //pregunta si el usuario ya guardo informacion
    if (_haveWeInternet) {
        if([self usuarioValido]){
            [self agregaVistaAlNavStack:@"Informacion" animado:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"  message: @"Debes estar logeado para poder usar esta sección"delegate: self cancelButtonTitle:@"Cancelar" otherButtonTitles: @"Login", nil];
            [alert show];
        }
    }else{
        [self lanzaAlertaErrorOk:@"Lo siento no tienes conexión a internet"];
    }
}
- (IBAction)estadisticasApretado:(id)sender {
    if (_haveWeInternet) {
        [self agregaVistaAlNavStack:@"Estadisticas" animado:YES];
    }else{
        [self lanzaAlertaErrorOk:@"Lo siento no tienes conexión a internet"];
    }
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //cambia la vista cuando se le hace click a una alerta
    if(buttonIndex == 1){
        if ([self usuarioValido]) {
            [self agregaVistaAlNavStack:@"Informacion" animado:YES];
        }else{
            [self agregaVistaAlNavStack:@"Login" animado:YES];
        }
        
    }
}
-(BOOL)datoGuardado:(NSString *) nombreDato {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    NSString *dato = [defaults stringForKey:nombreDato];
    if([dato length] == 0){
        //no se han guardado datos
        return NO;
        
    }else{
        //ya se guardaron ejercicos se puede comenzar
        return YES;
       
    }
}
-(void) lanzaAlertaCancelarOk: (NSString *) titulo mensaje:(NSString *)mensaje{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:titulo message: mensaje delegate: self cancelButtonTitle:@"Cancelar" otherButtonTitles: @"OK", nil];
    [alert show];
}
-(void) agregaVistaAlNavStack: (NSString *) idVista animado: (BOOL) animado {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EjerciciosVC *ejer = (EjerciciosVC *)[storyboard instantiateViewControllerWithIdentifier:idVista];
    UINavigationController *navController = self.navigationController;
    [navController pushViewController:ejer animated:animado];
}
- (BOOL) usuarioValido{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    long idUsuario = [defaults integerForKey:@"idUsuario"];
    if (idUsuario == 0){
        return NO;
    }
    return YES;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((AyudaVC*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((AyudaVC*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}
- (AyudaVC *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AyudaVC *pageContentViewController = [storyboard instantiateViewControllerWithIdentifier:@"Ayuda"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}
-(void) lanzaAlertaErrorOk:(NSString *) mensaje{
    UIAlertView *alerta = [[UIAlertView alloc]initWithTitle:@"Error" message: mensaje delegate: self cancelButtonTitle:@"OK" otherButtonTitles: nil, nil];
    [alerta show];
}


@end
