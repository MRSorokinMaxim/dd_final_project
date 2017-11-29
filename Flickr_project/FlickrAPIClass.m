//
//  FlickrAPIClass.m
//  Flickr_project
//
//  Created by Максим Сорокин on 29.11.17.
//  Copyright © 2017 Максим Сорокин. All rights reserved.
//

#import "FlickrAPIClass.h"

#define FlickrAPIKey @"8d090650bd255d8f2812b07687c0c30f"

@implementation FlickrAPIClass

+(NSURL *)URLForQuery:(NSString *)query
{
    query = [NSString stringWithFormat:@"%@&format=json&nojsoncallback=1&api_key=%@", query, FlickrAPIKey];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:query];
}

+(NSURL *)URLforRecentTags{
    return [self URLForQuery:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.tags.getHotList&period=day&count=20"]];
}

+(NSURL *)URLFotoforTags:(NSString*)tag{
    return [self URLForQuery:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&tags=%@&per_page=20",tag]];
}
+(NSURL *)URLFotoforText:(NSString*)text{
    return [self URLForQuery:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&text=%@&per_page=20",text]];
}
+(NSURL *)URLforPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format{
    return [NSURL URLWithString:[self urlStringForPhoto:photo format:format]];
}

+(NSString *)urlStringForPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format
{
    id farm = [photo objectForKey:@"farm"];
    id server = [photo objectForKey:@"server"];
    id photo_id = [photo objectForKey:@"id"];
    id secret = [photo objectForKey:@"secret"];
    
    NSString *fileType = @"jpg";
    
    if (!farm || !server || !photo_id || !secret) return nil;
    
    NSString *formatString = @"s";
    switch (format) {
        case FlickrPhotoFormatSquare:    formatString = @"s"; break;
        case FlickrPhotoFormatLarge:     formatString = @"b"; break;
    }
    
    return [NSString stringWithFormat:@"https://farm%@.static.flickr.com/%@/%@_%@_%@.%@", farm, server, photo_id, secret, formatString, fileType];
}



@end
