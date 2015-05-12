//
//  AyudaVC.m
//  Workapp2
//
//  Created by Rodrigo Guinea on 17/03/15.
/*
 
 Copyright (c) WorkApp 2015
 
 */

#import "AyudaVC.h"

@interface AyudaVC ()

@end

@implementation AyudaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"workicon.png"]]];
    self.navigationItem.rightBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.navigationController.title = @"Ayuda";
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    self.titleLabel.text = self.titleText;
    if([self.titleText compare:@"Desarrollado en CEM"]){
        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"drops.png"]];
        [self.view insertSubview:backgroundView atIndex:0];
    }
    
    //self.view.backgroundColor = UIColorFromRGB(0x0F77AE);
    //self.pageImages = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
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
