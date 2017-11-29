//
//  SessionDowload.h
//  Flickr_project
//
//  Created by Максим Сорокин on 29.11.17.
//  Copyright © 2017 Максим Сорокин. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImageView;
@class UICollectionViewCell;
@class UIImage;
@protocol DataSourseLoadProtocolDelegate<NSObject>

@optional

-(void)tagsLoaded:(NSArray*)tags; // For TagsFlickrTVC
-(void)smallPhotoLoaded:(NSArray*)smallPhotoURL andBigPhotoURL:(NSArray*)bigPhotoURL; // For PhotoFlockrCVC
-(void)smallImageView:(UIImageView*)imageView andCollectionViewCell:(UICollectionViewCell*)cell; // For PhotoFlockrCVC
-(void)bigImage:(UIImage*)image; // For ImageVC
-(void)happendErrorDowload; //For All VC

@end

@interface SessionDowload : NSObject

@property(weak,atomic) id <DataSourseLoadProtocolDelegate> delegate;

-(void)sessionTaskForTags:(NSURL*)url andKey:(NSString*)keyString;// For TagsFlickrTVC
-(void)sessionTaskForPhotoURL:(NSURL*)url andKey:(NSString*)key;// For PhotoFlockrCVC
-(void)sessionTaskForLoadPhotoAtURL:(NSURL*)url andCollectionViewCell:(UICollectionViewCell*)cell;// For PhotoFlockrCVC
-(void)sessionTaskForLoadBigPhotoAtUrl:(NSURL*)url;// For ImageVC

@end
