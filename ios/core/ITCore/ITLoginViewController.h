//
//  ITViewController.h
//  Desktop
//
//  Created by Администратор on 2/5/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITLoginControllerDelegate.h"

@interface ITLoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UISwitch *rememberSwitch;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) id<ITLoginControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *rememberMe;
@property (unsafe_unretained, nonatomic) IBOutlet UINavigationItem *titleItem;

- (IBAction)loginClick:(id)sender;

@end
