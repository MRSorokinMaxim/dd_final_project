//
//  TagsFlickrTVC.m
//  Flickr_project
//
//  Created by Максим Сорокин on 29.11.17.
//  Copyright © 2017 Максим Сорокин. All rights reserved.
//

#import "TagsFlickrTVC.h"
#import "FlickrAPIClass.h"
#import "PhotoFlickrCVC.h"

@interface TagsFlickrTVC ()
@property (nonatomic, strong) NSArray *tag;
@end

@implementation TagsFlickrTVC

#pragma mark - Properties

-(void)setTag:(NSArray *)tag{
    _tag = tag;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self fetchPhotos];
}


- (IBAction)fetchPhotos
{
    __weak TagsFlickrTVC* weakSelf = self;
    [self.refreshControl beginRefreshing];
    NSURL *url1 = [FlickrAPIClass URLforRecentTags];
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr tags", NULL);
    dispatch_async(fetchQ, ^{
        NSData *jsonResults1 = [NSData dataWithContentsOfURL:url1];
        NSDictionary *propertyListResults1 = [NSJSONSerialization JSONObjectWithData:jsonResults1
                                                                             options:0
                                                                               error:NULL];
        NSArray *tags =   [propertyListResults1 valueForKeyPath:@"hottags.tag"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.refreshControl endRefreshing];
            weakSelf.tag = tags;
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.tag count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tags";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *tag = self.tag[indexPath.row];
    cell.textLabel.text = [tag valueForKeyPath:@"_content"];
    return cell;
}

#pragma mark - Navigation

- (void)prepareImageViewController:(PhotoFlickrCVC *)ivc toDisplayPhoto:(NSString *)tag
{
    ivc.tag = tag;
    ivc.title = tag;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"tags to small foto"]) {
                if ([segue.destinationViewController isKindOfClass:[PhotoFlickrCVC class]]) {
                    [self prepareImageViewController:segue.destinationViewController
                                      toDisplayPhoto:[self.tag[indexPath.row] valueForKeyPath:@"_content"]];
                }
            }
        }
    }
}




@end
