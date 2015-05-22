//
//  ITChangePasswordViewController.h
//  ITCore
//
//  Created by Admin on 13.01.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITChangePasswordViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordOld;
@property (weak, nonatomic) IBOutlet UITextField *passwordNew;
@property (weak, nonatomic) IBOutlet UITextField *repeatPasswordNew;
@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navitem;

- (IBAction)changePassword:(id)sender;

@end
