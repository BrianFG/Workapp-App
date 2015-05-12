//
//  EjerciciosVC.h
//  Workapp2
//
//  Created by Rodrigo Guinea on 16/03/15.
/*
 
 Copyright (c) WorkApp 2015
 
 */

#import <UIKit/UIKit.h>
#import "DetallesEjercicioVC.h"
#import "Reachability.h"

@interface EjerciciosVC : UIViewController <UITableViewDelegate, UITableViewDataSource , UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) NSMutableArray *seriesArray;
@property (nonatomic, strong) NSMutableArray *repeticionesArray;
@property (nonatomic, strong) NSMutableArray *nombreArray;
@property (nonatomic, strong) NSMutableArray *urlArray;
@property (nonatomic, strong) NSMutableArray *idEjercicioArray;
@property (nonatomic, strong) NSString *detalles;
@property (nonatomic, strong) NSMutableArray *checkedRows;
@property (strong) Reachability * googleReach;
@property BOOL haveWeInternet;
@end
