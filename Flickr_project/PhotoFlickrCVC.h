//
//  PhotoFlickrCVC.h
//  Flickr_project
//
//  Created by Максим Сорокин on 29.11.17.
//  Copyright © 2017 Максим Сорокин. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    didComeFromTagsFlickrTVC = 1,
    didComeFromSearchVC = 2,
} IsComeFrom;

@interface PhotoFlickrCVC : UICollectionViewController
@property(strong,nonatomic) NSString *tag;
@property(nonatomic) IsComeFrom isComeFrom;
@end
