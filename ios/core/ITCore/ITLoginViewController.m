//
//  ITViewController.m
//  Desktop
//
//  Created by Администратор on 2/5/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "ITLoginViewController.h"
#import "ITApplicationManager.h"
#import "DejalActivityView.h"
#import <QuartzCore/QuartzCore.h>

@interface ITLoginViewController ()

@end

@implementation ITLoginViewController

-(id)init
{
    NSBundle * bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"ITCoreResources" withExtension:@"bundle"]];
    self = [super initWithNibName:@"LoginView" bundle:bundle];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSBundle * resources = [ITApplicationManager sharedManager].resourcesBundle;    
    self.titleItem.title = NSLocalizedStringFromTableInBundle(@"Вход в систему", @"LocalizableCore", resources, nil);
    self.loginText.placeholder = NSLocalizedStringFromTableInBundle(@"Логин", @"LocalizableCore", resources, nil);
    self.passwordText.placeholder = NSLocalizedStringFromTableInBundle(@"Пароль", @"LocalizableCore", resources, nil);
    self.rememberMe.text = NSLocalizedStringFromTableInBundle(@"Запомнить меня", @"LocalizableCore", resources, nil);
    self.loginButton.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Вход", @"LocalizableCore", resources, nil);
    [self createRecognizer];
    self.navigationItem.hidesBackButton = YES;
    self.loginText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.loginText.layer.borderWidth = 1;
    self.passwordText.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.passwordText.layer.borderWidth = 1;
    self.loginButton.layer.cornerRadius = 20;
}

- (void) createRecognizer
{
    UITapGestureRecognizer * recognizer = [UITapGestureRecognizer new];
    recognizer.cancelsTouchesInView = NO;
    [recognizer addTarget:self action:@selector(recognizerTap:)];
    recognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:recognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unregisterFromNotifications];
}

- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)unregisterFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Вызывается в момент, когда должна появится клавиатура
- (void)keyboardWillShown:(NSNotification *)aNotification
{
    CGRect start;
    CGRect end;
    [[[aNotification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&start];
    [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&end];
    
    double duration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int curve = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    NSDictionary* info = [aNotification userInfo];
    CGRect kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    UIWindow * window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    kbSize = [window.rootViewController.view convertRect:kbSize fromView:window];
    
    [UIView beginAnimations:@"kb" context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    self.logoImage.alpha = 0;
    self.contentView.frame = CGRectMake(CGRectGetMinX(self.contentView.frame), CGRectGetMinY(self.contentView.frame) - 152, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
    [UIView commitAnimations];
}

// Вызывается, когда клавиатура должна исчезнуть
- (void)keyboardWillHidden:(NSNotification *)aNotification
{
    double duration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    int curve = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    NSDictionary* info = [aNotification userInfo];
    CGRect kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    UIWindow * window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    kbSize = [window.rootViewController.view convertRect:kbSize fromView:window];
    
    double delay = 0;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [UIView beginAnimations:@"kb" context:nil];
        [UIView setAnimationDelay:0];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:curve];
        self.logoImage.alpha = 1;
        self.contentView.frame = CGRectMake(CGRectGetMinX(self.contentView.frame), CGRectGetMinY(self.contentView.frame) + 152, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
        [UIView commitAnimations];
    });
}


- (void)recognizerTap:(id)sender
{
    [self.view endEditing:YES];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.passwordText)
    {
        [textField resignFirstResponder];
        [self loginClick:nil];
    }
    else
    {
        [self.passwordText becomeFirstResponder];
    }
    return YES;
}

- (IBAction)loginClick:(UIButton *)sender
{
    [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedStringFromTableInBundle(@"Вход", @"LocalizableCore", [ITApplicationManager sharedManager].resourcesBundle, @"")];
    __weak ITLoginViewController * theSelf = self;
    [[ITApplicationManager sharedManager] loginWithName:self.loginText.text password:self.passwordText.text remember:self.rememberSwitch.on callback:^(BOOL success){
        [DejalBezelActivityView removeView];
        if (success)
        {
            [theSelf dismissViewControllerAnimated:YES completion:nil];
            if (theSelf.delegate)
            {
                [theSelf.delegate loginControllerDidLoginSuccessfully];
            }
        }
        else
        {
           UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Вход не выполнен", @"LocalizableCore", [ITApplicationManager sharedManager].resourcesBundle, nil) message: NSLocalizedStringFromTableInBundle(@"Неверный логин или пароль", @"LocalizableCore", [ITApplicationManager sharedManager].resourcesBundle, nil)
                                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
           [alert show];
        }
    }];
}

@end
