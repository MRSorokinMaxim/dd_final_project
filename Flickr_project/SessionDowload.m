//
//  SessionDowload.m
//  Flickr_project
//
//  Created by Максим Сорокин on 29.11.17.
//  Copyright © 2017 Максим Сорокин. All rights reserved.
//

#import "SessionDowload.h"
#import "FlickrAPIClass.h"

@implementation SessionDowload

-(void)sessionTaskForTags:(NSURL*)url andKey:(NSString*)keyString{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
        if (!error) {
            if ([request.URL isEqual:url]) {
                
                NSData *jsonResults = [NSData dataWithContentsOfURL:localfile];
                NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                                    options:0
                                                                                      error:NULL];
                NSArray* tags =   [propertyListResults valueForKeyPath:keyString];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    SEL selector = @selector(tagsLoaded:);
                    if(self.delegate && [self.delegate respondsToSelector:selector]){
                       [self.delegate tagsLoaded:tags];
                    }
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                SEL selector = @selector(happendErrorDowload);
                if(self.delegate && [self.delegate respondsToSelector:selector]){
                    [self.delegate happendErrorDowload];
                }
            });
        }
        
    }];
    
    [task resume];
}
-(void)sessionTaskForPhotoURL:(NSURL*)url andKey:(NSString*)key{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
        if (!error) {
            if ([request.URL isEqual:url]) {
                NSData *jsonResults = [NSData dataWithContentsOfURL:localfile];
                NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                                    options:0
                                                                                      error:NULL];
                NSArray *foto =   [propertyListResults valueForKeyPath:key];
                NSMutableArray* arrayBigPhoto = [[NSMutableArray alloc]init];
                NSMutableArray* arraySmallPhoto = [[NSMutableArray alloc]init];
                for ( NSDictionary *dict in foto){
                    [arraySmallPhoto addObject:[FlickrAPIClass URLforPhoto:dict format:FlickrPhotoFormatSquare]];
                    [arrayBigPhoto addObject:[FlickrAPIClass URLforPhoto:dict format:FlickrPhotoFormatLarge]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    SEL selector = @selector(smallPhotoLoaded:andBigPhotoURL:);
                    if(self.delegate && [self.delegate respondsToSelector:selector]){
                        [self.delegate smallPhotoLoaded:arraySmallPhoto andBigPhotoURL:arrayBigPhoto];
                    }
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                SEL selector = @selector(happendErrorDowload);
                if(self.delegate && [self.delegate respondsToSelector:selector]){
                    [self.delegate happendErrorDowload];
                }
            });
        }
    }];
    [task resume];
}
-(void)sessionTaskForLoadPhotoAtURL:(NSURL*)url andCollectionViewCell:(UICollectionViewCell*)cell{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            if ([request.URL isEqual:url]) {
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    SEL selector = @selector(smallImageView:andCollectionViewCell:);
                    if(self.delegate && [self.delegate respondsToSelector:selector]){
                        [self.delegate smallImageView:imageView andCollectionViewCell:cell];
                    }
                                
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                SEL selector = @selector(happendErrorDowload);
                if(self.delegate && [self.delegate respondsToSelector:selector]){
                    [self.delegate happendErrorDowload];
                }
            });
        }
    }];
    [task resume];

}
-(void)sessionTaskForLoadBigPhotoAtUrl:(NSURL*)url{
       
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
        if (!error) {
            if ([request.URL isEqual:url]) {
                
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    SEL selector = @selector(bigImage:);
                    if(self.delegate && [self.delegate respondsToSelector:selector]){
                        [self.delegate bigImage:image];
                    }
                });
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                SEL selector = @selector(happendErrorDowload);
                if(self.delegate && [self.delegate respondsToSelector:selector]){
                    [self.delegate happendErrorDowload];
                }
            });
        }
    }];
    [task resume];
}
@end
