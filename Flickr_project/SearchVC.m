//
//  SearchVC.m
//  Flickr_project
//
//  Created by Максим Сорокин on 29.11.17.
//  Copyright © 2017 Максим Сорокин. All rights reserved.
//

#import "SearchVC.h"
#import "PhotoFlickrCVC.h"
@interface SearchVC ()

@property (weak, nonatomic) IBOutlet UITextField *textSearch;
@property (weak, nonatomic) IBOutlet UIButton *buttonFind;

@end

@implementation SearchVC

- (void)viewDidLoad {
   
    
    [super viewDidLoad];
    self.textSearch.hidden = YES;
    self.buttonFind.hidden = YES;
}


- (IBAction)buttonSearch:(id)sender {
    self.textSearch.hidden = self.textSearch.hidden == NO ? YES : NO;
    self.buttonFind.hidden = self.buttonFind.hidden == NO ? YES : NO;
    
    
}



#pragma mark - Navigation
- (void)prepareImageViewController:(PhotoFlickrCVC *)ivc toDisplayPhoto:(NSString *)tag
{
    ivc.textForSearch = tag;
    ivc.isComeFrom = didComeFromSearchVC;
    ivc.title = self.textSearch.text;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.view endEditing:YES];
    if ([sender isKindOfClass:[UIButton class]]) {
        if (![self.textSearch.text  isEqual: @""]) {
            if ([segue.identifier isEqualToString:@"search for text"]) {
                if ([segue.destinationViewController isKindOfClass:[PhotoFlickrCVC class]]) {
                    [self prepareImageViewController:segue.destinationViewController
                                      toDisplayPhoto:self.textSearch.text];
                }
            }
        }
    }
}



@end
