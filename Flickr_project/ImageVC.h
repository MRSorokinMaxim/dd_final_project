//
//  ImageVC.h
//  Flickr_project
//
//  Created by Максим Сорокин on 29.11.17.
//  Copyright © 2017 Максим Сорокин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionDowload.h"
@interface ImageVC : UIViewController <DataSourseLoadProtocolDelegate>
@property(strong,nonatomic) NSURL *imageURL;
@end
