//
//  ViewController.h
//  Workapp2
//
//  Created by Rodrigo Guinea on 16/03/15.
/*
 
 Copyright (c) WorkApp 2015
 
 */

#import <UIKit/UIKit.h>
#import "AyudaVC.h"
#import "InformacionVC.h"
#import "EjerciciosVC.h"
#define IMC @"Peso"
#define IDUSUARIO @"idUsuario"
#import "Reachability.h"

@interface ViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@property (strong) Reachability * googleReach;
@property BOOL haveWeInternet;

@end

