//
//  ITDetailViewControllDelegate.h
//  CaseManagement
//
//  Created by Администратор on 6/23/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * Протокол для обозначения контроллеров, которые должны быть обновлены после некоторох изменений
 */
@protocol ITUpdatableViewControllerDelegate <NSObject>

@required
- (void) reloadData;

@end
