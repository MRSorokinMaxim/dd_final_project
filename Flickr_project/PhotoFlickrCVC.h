//
//  PhotoFlickrCVC.h
//  Flickr_project
//
//  Created by Максим Сорокин on 29.11.17.
//  Copyright © 2017 Максим Сорокин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionDowload.h"

typedef enum {
    didComeFromTagsFlickrTVC = 1,
    didComeFromSearchVC = 2,
} IsComeFrom;

@interface PhotoFlickrCVC : UICollectionViewController <DataSourseLoadProtocolDelegate>

@property(strong,nonatomic) NSString *textForSearch;
@property(nonatomic) IsComeFrom isComeFrom;
@end
