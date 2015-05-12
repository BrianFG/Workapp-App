//
//  DetallesEjercicioVC.h
//  Workapp2
//
//  Created by Rodrigo Guinea on 17/03/15.
/*
 
 Copyright (c) WorkApp 2015
 
 */

#import <UIKit/UIKit.h>
#import "EjerciciosVC.h"
#import "Red.h"
#import "Reachability.h"

#define DATOS_IMAGEN 500

@interface DetallesEjercicioVC : UIViewController <RedDelegado>
@property (strong, nonatomic) NSString *ejercicio;
@property (strong, nonatomic) NSMutableArray *checkedRows;
@property (strong, nonatomic) NSURL *urlImagen;
@property (weak, nonatomic) IBOutlet UILabel *TituloLb;
@property (weak, nonatomic) IBOutlet UILabel *stopWatchLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imagenEjercicio;
@property (strong, nonatomic) NSTimer *stopWatchTimer; // Store the timer that fires after a certain time
@property (strong, nonatomic) NSDate *startDate; // Stores the date of the click on the start button
@property NSInteger selectedRow;
@property NSInteger idEjercicio;
@property (strong) Reachability * googleReach;
@property BOOL haveWeInternet;



@end
