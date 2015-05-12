//
//  InformacionVC.h
//  Workapp2
//
//  Created by Rodrigo Guinea on 16/03/15.
/*
 
 Copyright (c) WorkApp 2015
 
 */

#import <UIKit/UIKit.h>
#import "EjerciciosVC.h"
#import "ViewController.h"
#import "Reachability.h"
#define NOMBRE @"Nombre"
#define SEXO @"Sexo"
#define FECHA @"Fecha"
#define PESO @"Peso"
#define ESTATURA @"Estatura"

@interface InformacionVC : UIViewController <UITextViewDelegate>

@property (nonatomic, retain) IBOutlet UITextField *NombreTF;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SexoSC;
@property (weak, nonatomic) IBOutlet UIDatePicker *fechaNacimientoDT;
@property (weak, nonatomic) IBOutlet UISlider *PesoS;
@property (weak, nonatomic) IBOutlet UISlider *EstaturaS;
@property (weak, nonatomic) IBOutlet UILabel *PesoLb;
@property (weak, nonatomic) IBOutlet UILabel *EstaturaLb;
@property (strong) Reachability * googleReach;
@property BOOL haveWeInternet;

@end
