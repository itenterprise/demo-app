//
//  ITMenuViewController.h
//  CaseManagement
//
//  Created by Администратор on 5/16/14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITMenuViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *myActiveImage;
@property (weak, nonatomic) IBOutlet UIImageView *myCompleteImage;
@property (weak, nonatomic) IBOutlet UIImageView *myCancelImage;
@property (weak, nonatomic) IBOutlet UIImageView *controlActiveImage;
@property (weak, nonatomic) IBOutlet UIImageView *controlCompleteImage;
@property (weak, nonatomic) IBOutlet UIImageView *controlCancelImage;

@property (weak, nonatomic) IBOutlet UIImageView *inDocumentsImage;
@property (weak, nonatomic) IBOutlet UIImageView *sendDocuments;
@property (weak, nonatomic) IBOutlet UIImageView *archiveImage;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *images;


@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *cells;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fotoView;

@end
