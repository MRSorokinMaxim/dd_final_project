//
//  FlickrAPIClass.h
//  Flickr_project
//
//  Created by Максим Сорокин on 29.11.17.
//  Copyright © 2017 Максим Сорокин. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FlickrPhotoFormatSquare = 1,    // thumbnail
    FlickrPhotoFormatLarge = 2,     // normal size
} FlickrPhotoFormat;


@interface FlickrAPIClass : UIViewController

+ (NSURL *)URLforRecentTags;
+ (NSURL *)URLFotoforTags:(NSString*)tag;
+ (NSURL *)URLFotoforText:(NSString*)text;
+ (NSURL *)URLforPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format;

@end
