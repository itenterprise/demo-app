//
//  ITChangePasswordViewController.m
//  ITCore
//
//  Created by Admin on 13.01.15.
//  Copyright (c) 2015 Information Technologies Ltd. All rights reserved.
//

#import "ITChangePasswordViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ITApplicationManager.h"
#import "DejalActivityView.h"

@interface ITChangePasswordViewController ()

@end

@implementation ITChangePasswordViewController

-(id)init
{
    NSBundle * bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"ITCoreResources" withExtension:@"bundle"]];
    self = [super initWithNibName:@"ChangePassword" bundle:bundle];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navitem.title = NSLocalizedStringFromTableInBundle(@"Изменить пароль", @"LocalizableCore", [ITApplicationManager sharedManager].resourcesBundle, @"");
    self.passwordNew.placeholder = NSLocalizedStringFromTableInBundle(@"Новый пароль", @"LocalizableCore", [ITApplicationManager sharedManager].resourcesBundle, @"");
    self.passwordOld.placeholder = NSLocalizedStringFromTableInBundle(@"Старый пароль", @"LocalizableCore", [ITApplicationManager sharedManager].resourcesBundle, @"");
    self.repeatPasswordNew.placeholder = NSLocalizedStringFromTableInBundle(@"Повторите новый пароль", @"LocalizableCore", [ITApplicationManager sharedManager].resourcesBundle, @"");
    self.changePasswordButton.titleLabel.text = NSLocalizedStringFromTableInBundle(@"Изменить пароль", @"LocalizableCore", [ITApplicationManager sharedManager].resourcesBundle, @"");
    
    NSString * backString = NSLocalizedStringFromTableInBundle(@"Назад", @"LocalizableCore", [ITApplicationManager sharedManager].resourcesBundle, @"");
    self.navitem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:backString style:UIBarButtonItemStylePlain target:self action:@selector(back)];

    self.navigationItem.hidesBackButton = YES;
    self.passwordNew.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.passwordNew.layer.borderWidth = 1;
    self.passwordOld.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.passwordOld.layer.borderWidth = 1;
    self.repeatPasswordNew.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.repeatPasswordNew.layer.borderWidth = 1;
    self.changePasswordButton.layer.cornerRadius = 20;
}

- (void)back
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)changePassword:(id)sender
{
    if (!self.passwordNew.text.length || !self.passwordOld.text.length || !self.repeatPasswordNew.text.length)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTableInBundle(@"Необходимо заполнить все поля", @"LocalizableCore", [ITApplicationManager sharedManager].resourcesBundle, @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if (![self.passwordNew.text isEqualToString:self.repeatPasswordNew.text])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedStringFromTableInBundle(@"Подтверждение нового пароля не совпадает с новым паролем", @"LocalizableCore", [ITApplicationManager sharedManager].resourcesBundle, @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedStringFromTableInBundle(@"Смена пароля", @"LocalizableCore", [ITApplicationManager sharedManager].resourcesBundle, @"")];
    [[ITApplicationManager sharedManager] changePassword: self.passwordOld.text toPassword: self.passwordNew.text withBlock: ^(id ret) {
            [DejalBezelActivityView removeView];
            if ([ret isKindOfClass:[NSDictionary class]])
            {
                NSInteger success = [ret[@"SUCCESS"] integerValue];
                NSString * reason = ret[@"FAILREASON"];
                if (!success)
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Не удалось изменить пароль", @"LocalizableCore", [ITApplicationManager sharedManager].resourcesBundle, @"") message:reason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                }
                else
                {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTableInBundle(@"Пароль успешно изменен!", @"LocalizableCore", [ITApplicationManager sharedManager].resourcesBundle, @"") message:reason delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                }
            }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
