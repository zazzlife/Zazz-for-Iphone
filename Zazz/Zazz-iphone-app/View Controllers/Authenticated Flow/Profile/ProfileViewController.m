//
//  ProfileViewController.m
//  Zazz-iphone-app
//
//  Created by Fyodor Wolf on 6/4/14.
//  Copyright (c) 2014 Mitchell Sorkin. All rights reserved.
//

#import "ProfileViewController.h"
#import "FeedTableViewController.h"
#import "MediaFeedController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "PhotoPicker.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Photo.h"


@interface ProfileViewController () {
}


/** Initialize class's private variables. */
- (void)_init;
/** Localize UI components. */
- (void)_localize;
/** Visualize all view's components. */
- (void)_visualize;

@end


@implementation ProfileViewController

@synthesize user_id;
@synthesize _profile;

PhotoPicker* _activePicker;


#pragma mark - Class's constructors
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        [self _init];
//    }
//    return self;
//}
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        [self _init];
//    }
//    return self;
//}


#pragma mark - Cleanup memory
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - View's lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    //[self _visualize];
    
    //    //URL profile Photo
    //    NSURL *url = [NSURL URLWithString:@"http://bestinspired.com/wp-content/uploads/2015/05/Nature-Wallpaper2.jpg"];
    //    [_profileView downloadImageFromUrl:url];
    
    [self.scrollView setScrollsToTop:false];
    [self.scrollView setAlwaysBounceVertical:false];
    if(!self.user_id)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotMe:) name:@"gotMe" object:nil];
    if(!self._profile)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotProfile:) name:@"gotProfile" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    
    //    [self scrollViewDidScroll:self.feedTableViewController.tableView];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Only send request when user is authenticated
    if ([kPreferences accessToken]) {
        __autoreleasing NSString *urlString = [NSString stringWithFormat:_g_ServiceProfile, _g_Hostname, [kPreferences currentUsername]];
        __autoreleasing NSURL *url = [NSURL URLWithString:urlString];
        
        __autoreleasing FwiRequest *request = [kNetworkManager prepareRequestWithURL:url method:kMethodType_Get params:nil];
        
        [SVProgressHUD showWithStatus:kText_Loading];
        [kNetworkManager sendRequest:request handleError:YES completion:^(FwiJson *responseMessage, NSError *error, FwiNetworkStatus statusCode) {
            if (FwiNetworkStatusIsSuccces(statusCode)) {
                //DLog(@"%@", responseMessage);
            }
            
            [SVProgressHUD dismiss];
        }];
    }
}


-(IBAction)changeFeed:(UISegmentedControl*)sender{
    int segment = [sender selectedSegmentIndex];
    if(segment == 0){
        [self.feedTableViewController setShowPosts:false];
        [self.feedTableViewController setShowEvents:false];
        [self.feedTableViewController setShowPhotos:true];
        [self.feedTableViewController setShowVideos:true];
        [self.mediaFeedViewController.collectionView reloadData];
        [self.mediaFeedView setHidden:false];
        [self.mediaFeedViewController.collectionView setScrollEnabled:true];
        [self.postFeedView setHidden:true];
        [self.feedTableViewController.tableView setScrollEnabled:false];
    }else{
        [self.feedTableViewController setShowPosts:true];
        [self.feedTableViewController setShowEvents:true];
        [self.feedTableViewController setShowPhotos:false];
        [self.feedTableViewController setShowVideos:false];
        [self.feedTableViewController.tableView reloadData];
        [self.mediaFeedView setHidden:true];
        [self.mediaFeedViewController.collectionView setScrollEnabled:false];
        [self.postFeedView setHidden:false];
        [self.feedTableViewController.tableView setScrollEnabled:true];
    }
}

-(void)gotMe:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotMe"]) return;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotMe" object:nil];
    User* user = notif.object;
    [self setUser_id:user.userId];
    [[AppDelegate zazzApi] getProfile:user_id];
}

-(void)gotProfile:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"gotProfile"]) return;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gotProfile" object:nil];
    Profile* profile = notif.object;
    if([profile.profile_id intValue] == [self.user_id intValue]){
        [self setProfile:profile];
    }
    
    //Following example => [[AppDelegate zazzApi] setUserToFollow:@"83" action:YES];
}

-(void)setProfile:(Profile*)profile{
    [self set_profile:profile];
    [self.profilePhoto setImageWithURL:[NSURL URLWithString:profile.photoUrl]];
    [self.profilePhoto.layer setCornerRadius:self.profilePhoto.frame.size.height / 2];
    [self.profilePhoto.layer setMasksToBounds:YES];
    [self.username setText:[NSString stringWithFormat:@"@%@",profile.displayName]];
    [self.name setText:profile.userDetails.fullName];
    [self.tagline setText:profile.userDetails.major.name];
    [self.school setText:profile.userDetails.school.name];
    [self.city setText:profile.userDetails.city.name];
    [self.followers setText:[NSString stringWithFormat:@"%@",profile.followersCount]];
    if(!profile.isCurrentUserFollowingTargetUser){
        [self.follow setTitle:@"Following" forState:UIControlStateNormal];
    }
    if(self.feedTableViewController){
        [self.feedTableViewController setFeed_user_id:self._profile.profile_id];
        [self.feedTableViewController doRefresh:nil];
    }
}

- (IBAction)segmentChanged:(id)sender {
    if (sender == _segmentView && _segmentView.selectedSegmentIndex == 0) {
        _mediaFeedView.hidden = NO;
        _mediaFeedView.alpha = 0.0f;
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             _mediaFeedView.alpha = 1.0f;
                             _postFeedView.alpha  = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             _postFeedView.hidden = YES;
                         }];
    }
    else if (sender == _segmentView && _segmentView.selectedSegmentIndex == 1) {
        _postFeedView.hidden = NO;
        _postFeedView.alpha = 0.0f;
        
        [UIView animateWithDuration:0.3f
                         animations:^{
                             _mediaFeedView.alpha = 0.0f;
                             _postFeedView.alpha  = 1.0f;
                         }
                         completion:^(BOOL finished) {
                             _mediaFeedView.hidden = YES;
                         }];
    }
}

#pragma mark - CFTabBarViewDelegate method
-(void)setViewHidden:(BOOL)hidden{
    [self.view.superview setHidden:hidden];
    [self.feedTableViewController.tableView setScrollsToTop:true ];
    if(hidden){
        [self.mediaFeedViewController.collectionView setScrollsToTop:false];
        [self.feedTableViewController.tableView setScrollsToTop:false ];
    }
}

/* SCROLL DELEGATION BROKEN... TODO-fix it */
//-(void)scrollViewToTopIfNeeded:(UIScrollView*)scrollView{
//    float filter_bottom_y = CGRectGetMaxY(self.topContainer.frame);
//    float delta = scrollView.contentOffset.y;
//    if(delta > 0 && delta < filter_bottom_y){
//        [self.scrollView setContentOffset:CGPointZero animated:YES];
//        [scrollView setContentOffset:CGPointZero animated:YES];
//    }
//}

-(void)scrollViewDidScroll:(UIScrollView*)scrollView{
    float filter_view_height = CGRectGetMaxY(self.topContainer.frame);
    float delta = scrollView.contentOffset.y;
    if(delta <= 0){
        [self.scrollView setContentOffset:CGPointZero];
    }
    else if(delta < filter_view_height){
        [self.scrollView setContentOffset:CGPointMake(0, delta)];
    }
    else if (delta >= filter_view_height){
        [self.scrollView setContentOffset:CGPointMake(0, CGRectGetMaxY(self.topContainer.frame))];
    }
}


#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"embedProfileFeedViewController"]){
        [self setFeedTableViewController:(FeedTableViewController*)segue.destinationViewController];
        [self.feedTableViewController setFeed_user_id:self._profile.profile_id];
        [self.feedTableViewController setRequire_feed_user_id:true];
        [self.feedTableViewController setScrollDelegate:self];
        [self.feedTableViewController setShowPosts:true];
        [self.feedTableViewController viewDidEmbed];
    }else if([segue.identifier isEqualToString:@"embedProfileFeedMediaViewController"]){
        [self setMediaFeedViewController:(MediaFeedController*)segue.destinationViewController];
        //        [self.mediaFeedViewController setScrollDelegate:self];
        //        [self.mediaFeedViewController setFeedTableViewController:self.feedTableViewController];
        //        [self.mediaFeedViewController viewDidEmbed];
    }
}

-(IBAction)changeProfileImage:(UIButton*)sender{
    _activePicker = [[PhotoPicker alloc] initWithMediaReceiver:self];
    [_activePicker pickAssets];
}

//Called by Create<Media>ViewControllers.
-(void)setMediaAttachment:(NSArray*)media{
    if (!media) return;
    ALAsset* mediaAsset = [media objectAtIndex:0];
    ALAssetRepresentation* representation = [mediaAsset defaultRepresentation];
    // Retrieve the image orientation from the ALAsset
    UIImageOrientation orientation = UIImageOrientationUp;
    NSNumber* orientationValue = [mediaAsset valueForProperty:@"ALAssetPropertyOrientation"];
    if (orientationValue != nil) {
        orientation = [orientationValue intValue];
    }
    CGFloat scale  = 1;
    UIImage* pic = [UIImage imageWithCGImage:[representation fullResolutionImage]
                                       scale:scale orientation:orientation];
    RSKImageCropViewController* imageCropVC = [[RSKImageCropViewController alloc] initWithImage:pic];
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
}

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller{
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage{
    [self.profilePhoto setImage:croppedImage];
    [self.navigationController popViewControllerAnimated:YES];
    // upload the photo.
    Photo* photo = [[Photo alloc] init];
    [photo setImage:croppedImage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadedPhoto:) name:@"madePost" object:nil];
    [[AppDelegate zazzApi] postPhoto:photo];
}

-(void)uploadedPhoto:(NSNotification*)notif{
    if (![notif.name isEqualToString:@"madePost"]) return;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"madePost" object:nil];
    Photo* photo = notif.object;
    [[AppDelegate zazzApi] setProfilePic:photo.photoId];
}

-(void)enableBackButton{
    //assume it's full screen.
    [self.view setFrame:[[UIScreen mainScreen] bounds]];
    [self.scrollView setFrame:self.view.frame];
    [self.leftBarButton setImage:[UIImage imageNamed:@"yellow arrow"] forState:UIControlStateNormal];
    [self.leftBarButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)goBack:(UIButton*)button{
    [[[AppDelegate getAppDelegate] navController] popViewControllerAnimated:YES];
}

@end
