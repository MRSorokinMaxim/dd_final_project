//
//  PhotoFlickrCVC.m
//  Flickr_project
//
//  Created by Максим Сорокин on 29.11.17.
//  Copyright © 2017 Максим Сорокин. All rights reserved.
//

#import "PhotoFlickrCVC.h"
#import "FlickrAPIClass.h"
#import "ImageVC.h"

@interface PhotoFlickrCVC ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic,strong) NSMutableArray* smallPhotoURL;
@property(nonatomic,strong) NSMutableArray* bigPhotoURL;
@end

@implementation PhotoFlickrCVC

@synthesize smallPhotoURL = _smallPhotoURL;
@synthesize bigPhotoURL = _bigPhotoURL;


#pragma mark - Properties

-(NSMutableArray *)smallPhotoURL{
    if (!_smallPhotoURL) {
        _smallPhotoURL = [[NSMutableArray alloc]init];
        
    }
    return _smallPhotoURL;
}
-(void)setSmallPhoto:(NSMutableArray *)smallPhotoURL{
    
    _smallPhotoURL = smallPhotoURL;
    [self.collectionView reloadData];
}
-(NSMutableArray *)bigPhotoURL{
    if (!_bigPhotoURL) {
        _bigPhotoURL = [[NSMutableArray alloc]init];
        
    }
    return _bigPhotoURL;
}
-(void)setBigPhotoURL:(NSMutableArray *)bigPhotoURL{
    _bigPhotoURL = bigPhotoURL;
    [self.collectionView reloadData];
}

#pragma mark - Initialization
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.spinner startAnimating];
    [self fetchPhotos];
    
}
- (void)fetchPhotos
{
    __weak PhotoFlickrCVC* weakSelf = self;
    NSURL *url = [FlickrAPIClass URLFotoforTags:self.tag];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr photo", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                            options:0
                                                                              error:NULL];
        NSArray *foto =   [propertyListResults valueForKeyPath:@"photos.photo"];
        NSMutableArray* arrayBigPhoto = [[NSMutableArray alloc]init];
        NSMutableArray* arraySmallPhoto = [[NSMutableArray alloc]init];
        for ( NSDictionary *dict in foto){
            [arraySmallPhoto addObject:[FlickrAPIClass URLforPhoto:dict format:FlickrPhotoFormatSquare]];
            [arrayBigPhoto addObject:[FlickrAPIClass URLforPhoto:dict format:FlickrPhotoFormatLarge]];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.smallPhotoURL = arraySmallPhoto;
            weakSelf.bigPhotoURL = arrayBigPhoto;
            [weakSelf.collectionView reloadData];
        });
    });
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.smallPhotoURL.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"small photo" forIndexPath:indexPath];
    
    NSURL *URL = self.smallPhotoURL[indexPath.row];
    
    if (URL) {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        
        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error) {
            
            if (!error) {
                if ([request.URL isEqual:URL]) {
                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];
                    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
                    dispatch_async(dispatch_get_main_queue(), ^{ [cell.contentView addSubview: imageView];[self.spinner stopAnimating]; });
                }
            }
        }];
        [task resume];
    }
    return cell;
}

#pragma mark - Navigation

- (void)prepareImageViewController:(ImageVC *)ivc toDisplayPhoto:(NSURL *)url
{
    ivc.imageURL = url;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([sender isKindOfClass:[UICollectionViewCell class]]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"small photo to big photo"]) {
                if ([segue.destinationViewController isKindOfClass:[ImageVC class]]) {
                    [self prepareImageViewController:segue.destinationViewController
                                    toDisplayPhoto:self.bigPhotoURL[indexPath.row]];
                }
            }
        }
    }
}


@end
