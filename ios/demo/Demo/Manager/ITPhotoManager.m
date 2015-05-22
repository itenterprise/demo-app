//
//  ITPhotoManager.m
//  CaseManagement
//
//  Created by Admin on 20.10.14.
//  Copyright (c) 2014 Information Technologies Ltd. All rights reserved.
//

#import "ITPhotoManager.h"
#import "ITDemoManager.h"

@interface ITPhotoManager()

@property (nonatomic, unsafe_unretained) NSInteger imageCount;

@end

@implementation ITPhotoManager

- (void) loadPhotos: (NSArray *)photos forUsers: (NSArray *)users inContext: (NSManagedObjectContext *)context
{
    self.imageCount = photos.count;
    for (int i = 0; i < photos.count; i++)
    {
        NSString * photo = photos[i];
        if (!photo.length)
        {
            continue;
        }
        __block UserInfo * info = users[i];
        __block ITPhotoManager * theSelf = self;
        __block NSManagedObjectContext * theContext = context;
        [[[ITDemoManager sharedManager] serviceManager] getFile:photo withBlock:^(NSString * tempName) {
            if (tempName.length)
            {
                info.imageContents = [UIImage imageWithData:[NSData dataWithContentsOfFile:tempName]];
            }
            theSelf.imageCount--;
            if (!theSelf.imageCount)
            {
                [theContext save:nil];
            }
        }];
    }
}

@end
