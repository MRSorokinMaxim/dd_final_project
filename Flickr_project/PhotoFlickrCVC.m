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
@property(nonatomic,strong) NSArray* smallPhotoURL;
@property(nonatomic,strong) NSArray* bigPhotoURL;
@end

@implementation PhotoFlickrCVC



#pragma mark - Properties


-(void)setSmallPhoto:(NSArray *)smallPhotoURL{
    
    _smallPhotoURL = smallPhotoURL;
    [self.collectionView reloadData];
}

-(void)setBigPhotoURL:(NSArray *)bigPhotoURL{
    
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
    NSURL *url;
    
    if(self.textForSearch){
        if (self.isComeFrom == didComeFromTagsFlickrTVC){
            url = [FlickrAPIClass URLFotoforTags:self.textForSearch];
        }
        if(self.isComeFrom == didComeFromSearchVC){
            url = [FlickrAPIClass URLFotoforText:self.textForSearch];
        }
        
        SessionDowload *session = [[SessionDowload alloc]init];
        session.delegate = self;
        [session sessionTaskForPhotoURL:url andKey:@"photos.photo"];
    }
}
#pragma mark - DataSourseLoadProtocolDelegate

-(void)smallPhotoLoaded:(NSArray*)smallPhotoURL andBigPhotoURL:(NSArray*)bigPhotoURL{
    
    self.smallPhotoURL = smallPhotoURL;
    self.bigPhotoURL = bigPhotoURL;
    [self.collectionView reloadData];
}

-(void)smallImageView:(UIImageView *)imageView andCollectionViewCell:(UICollectionViewCell*)cell{
    
    [cell.contentView addSubview:imageView];
    [self.spinner stopAnimating];
    
}
-(void)happendErrorDowload{
    
    [self.spinner stopAnimating];
    NSString *message = @"Скорее всего пропал интернет! Но это не точно";
    NSString *alertTitle =@"Error";
    NSString *okText = @"Ok";
    UIAlertController *alert =  [UIAlertController alertControllerWithTitle:alertTitle
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton =[ UIAlertAction actionWithTitle:okText
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert animated:YES completion:nil];
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
        SessionDowload *sessiondowload = [[SessionDowload alloc]init];
        sessiondowload.delegate = self;
        [sessiondowload sessionTaskForLoadPhotoAtURL:URL andCollectionViewCell:cell];
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
