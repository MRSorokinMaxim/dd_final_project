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

#pragma mark - Load ViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    [self fetchPhotos];
}

- (IBAction)fetchPhotos
{
    [self.refreshControl beginRefreshing];
    SessionDowload *sessionDowload = [[SessionDowload alloc]init];
    sessionDowload.delegate = self;
    NSURL *url = [FlickrAPIClass URLforRecentTags];
    [sessionDowload sessionTaskForTags:url andKey:@"hottags.tag"];
    
}
#pragma mark - DataSourseLoadProtocolDelegate

-(void)tagsLoaded:(NSArray *)tags{
    self.tag = tags;
    [self.refreshControl endRefreshing];
}

-(void)happendErrorDowload{
    
    [self.refreshControl endRefreshing];
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
    ivc.textForSearch = tag;
    ivc.isComeFrom = didComeFromTagsFlickrTVC;
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
