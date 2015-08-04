#import "MediaFeedController.h"
#import "MediaFeedCell.h"


@interface MediaFeedController () {
}


/** Initialize class's private variables. */
- (void)_init;
/** Localize UI components. */
- (void)_localize;
/** Visualize all view's components. */
- (void)_visualize;

@end


@implementation MediaFeedController


static NSString * const _Identifier = @"Cell";


#pragma mark - Class's constructors
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self _init];
    }
    return self;
}


#pragma mark - Cleanup memory
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - View's lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //create array of image
    self.imageArray = [NSArray arrayWithObjects:@"iPad76.png","iPad76.png", "iPad76.png", "iPad76.png", "iPad76.png", nil];
    
    
    
    [self _visualize];
    

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _localize];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


#pragma mark - View's memory handler
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - View's orientation handler
- (BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}


#pragma mark - View's status handler
- (BOOL)prefersStatusBarHidden {
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


#pragma mark - View's transition event handler
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


#pragma mark - Class's properties


#pragma mark - Class's public methods


#pragma mark - Class's private methods
- (void)_init {
}
- (void)_localize {
}
- (void)_visualize {
}


#pragma mark - Class's notification handlers


#pragma mark - UICollectionViewDataSource's members
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    __autoreleasing MediaFeedCell *cell = (MediaFeedCell *)[collectionView dequeueReusableCellWithReuseIdentifier:_Identifier forIndexPath:indexPath];
    
    //test
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,100,100)];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.clipsToBounds = YES;
    imgView.image = [self.imageArray objectAtIndex:indexPath.row];
    [cell addSubview:imgView];
    
    
    
    
    return cell;
}


#pragma mark - UICollectionViewDelegate's members
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}


#pragma mark - UICollectionViewDelegateFlowLayout's members
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(106.0f, 106.0f);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}


@end
