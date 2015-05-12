//
//  LoginVC.h
//  Workapp2
//
//  Created by Rodrigo Guinea on 22/04/15.
/*
 
 Copyright (c) WorkApp 2015
 
 */

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"

@interface LoginVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *tfNombreUsuario;
@property (weak, nonatomic) IBOutlet UITextField *tfContrasena;
@property (weak, nonatomic) IBOutlet UITextField *tfRepiteContrasena;
@property (weak, nonatomic) IBOutlet UIButton *botonCrearNuevaCuenta;
@property (weak, nonatomic) IBOutlet UIButton *botonIngresar;
@property (weak, nonatomic) IBOutlet UIButton *botonYaTengo;
@property (weak, nonatomic) IBOutlet UIButton *botonCrear;
@property (strong) Reachability * googleReach;
@property BOOL haveWeInternet;
@end
