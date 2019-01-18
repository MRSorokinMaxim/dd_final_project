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

- (void)sessionTaskForTags:(NSURL *)url andKey:(NSString *)keyString {
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
                NSArray* tags = [propertyListResults valueForKeyPath:keyString];
                dispatch_async(dispatch_get_main_queue(), ^{
                    SEL selector = @selector(tagsLoaded:);
                    if(self.delegate && [self.delegate respondsToSelector:selector]){
                       [self.delegate tagsLoaded:tags];
                    }
                });
            }
        }
        else {
            [self happendErrorDowloads];
        }
        
    }];
    [task resume];
}

- (void)sessionTaskForPhotoURL:(NSURL *)url andKey:(NSString *)key {
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
                NSArray *photos = [propertyListResults valueForKeyPath:key];
                NSMutableArray *arrayBigPhoto = [[NSMutableArray alloc] init];
                NSMutableArray *arraySmallPhoto = [[NSMutableArray alloc] init];
                for (NSDictionary *photoData in photos) {
                    [arraySmallPhoto addObject:[FlickrAPIClass URLforPhoto:photoData format:FlickrPhotoFormatSquare]];
                    [arrayBigPhoto addObject:[FlickrAPIClass URLforPhoto:photoData format:FlickrPhotoFormatLarge]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    SEL selector = @selector(smallPhotoLoaded:andBigPhotoURL:);
                    if (self.delegate && [self.delegate respondsToSelector:selector]) {
                        [self.delegate smallPhotoLoaded:arraySmallPhoto andBigPhotoURL:arrayBigPhoto];
                    }
                });
            }
        }
        else {
            [self happendErrorDowloads];
        }
    }];
    [task resume];
}

- (void)sessionTaskForLoadPhotoAtURL:(NSURL *)url andCollectionViewCell:(UICollectionViewCell *)cell {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
        if (!error) {
            if ([request.URL isEqual:url]) {
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    SEL selector = @selector(smallImage:andCollectionViewCell:);
                    if (self.delegate && [self.delegate respondsToSelector:selector]) {
                        [self.delegate smallImage:image andCollectionViewCell:cell];
                    }
                });
            }
        }
        else {
            [self happendErrorDowloads];
        }
    }];
    [task resume];
}

- (void)sessionTaskForLoadBigPhotoAtUrl:(NSURL*)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
        if (!error) {
            if ([request.URL isEqual:url]) {
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    SEL selector = @selector(bigImage:);
                    if(self.delegate && [self.delegate respondsToSelector:selector]) {
                        [self.delegate bigImage:image];
                    }
                });
            }
        }
        else {
            [self happendErrorDowloads];
        }
    }];
    [task resume];
}

- (void)happendErrorDowloads {
    dispatch_async(dispatch_get_main_queue(), ^{
        SEL selector = @selector(happendErrorDowload);
        if (self.delegate && [self.delegate respondsToSelector:selector]) {
            [self.delegate happendErrorDowload];
        }
    });
}

@end
