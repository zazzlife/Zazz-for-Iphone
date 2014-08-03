//
//  RootViewController.m
//  SecretTestApp
//
//  Created by Aaron Pang on 3/28/14.
//  Copyright (c) 2014 Aaron Pang. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImage+ImageEffects.h"
#import "ToolBarView.h"
#import "UIFont+SecretFont.h"
#import "CommentCell.h"
#import "UIView+GradientMask.h"

#import "AppDelegate.h"
#import "Post.h"
#import "Photo.h"
#import "UIColor.h"
#import "DetailViewItem.h"
#import "UILabel.h"

#import <QuartzCore/QuartzCore.h>

const CGFloat kBarHeight = 60.0f;
const CGFloat kBackgroundParallexFactor = 0.5f;
const CGFloat kBlurFadeInFactor = 0.005f;
const CGFloat kTextFadeOutFactor = 0.05f;
const CGFloat kCommentCellHeight = 50.0f;

@interface DetailViewController () <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation DetailViewController
    
CGRect HEADER_INIT_FRAME;
CGRect TOOLBAR_INIT_FRAME;
CGRect IMAGE_INIT_FRAME;
CGRect TEXT_INIT_FRAME;

DetailViewItem* _detailItem;
UIViewController* _delegate;

UIScrollView *_mainScrollView;
//UIScrollView *_backgroundScrollView;
UIImageView *_blurImageView;
UIImageView* _posterPhoto;
UILabel *_textLabel;
ToolBarView *_toolBarView;
UIView* _topContainer;
UIView* _textLabelView;
UITableView* _commentsTableView;
UIButton* _backButton;
UIImageView* _imageView;

-(id)initWithDetailItem:(DetailViewItem*)detailItem{
    
    if (!self) {self = [super init];}
    
    _detailItem = detailItem;
    
    _imageView = [[UIImageView alloc] init];
    _textLabelView = [[UIView alloc] init];
    
    [_imageView setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    if([_detailItem description]){
    
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, kBarHeight, 230, 0)];
        [_textLabel setText:_detailItem.description];
        [_textLabel setNumberOfLines:0];
        [_textLabel setFont:[UIFont secretFontLightWithSize:14.f]];
        [_textLabel setTextAlignment:NSTextAlignmentLeft];
        [_textLabel setTextColor:[UIColor whiteColor]];
        [_textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [_textLabel setBackgroundColor:[UIColor clearColor]];
        [_textLabel.layer setShadowColor:[UIColor blackColor].CGColor];
        [_textLabel.layer setShadowRadius:10.0f];
        [_textLabel resizeWithFlexibleHeight];
        
        UIImageView* backgroundImage = [[UIImageView alloc] init];
        UIImage* bkd = [UIImage imageNamed:@"Background"];
        [backgroundImage setImage:bkd];
        CGRect max_frame = [[UIScreen mainScreen] bounds];
        [backgroundImage setFrame: CGRectMake(CGRectGetMinX(max_frame) - 200, CGRectGetMinY(max_frame) - 200, CGRectGetWidth(max_frame) + 400, CGRectGetHeight(max_frame)+400)];
        
        _posterPhoto = [[UIImageView alloc] initWithImage:_detailItem.user.photo];
        [_posterPhoto setFrame:CGRectMake(25, kBarHeight, 50, 50)];
        [_posterPhoto.layer setCornerRadius:CGRectGetWidth(_posterPhoto.frame) / 2.0f];
        [_posterPhoto.layer setMasksToBounds:YES];
        
        [_textLabelView setFrame:CGRectMake(0, 0, 320, MAX(CGRectGetMaxY(_textLabel.frame),CGRectGetMaxY(_posterPhoto.frame)))];
        CGRect frame = _textLabelView.frame;
        
        [_textLabelView addSubview:backgroundImage];
        [_textLabelView addSubview:_textLabel];
        [_textLabelView addSubview:_posterPhoto];
        TEXT_INIT_FRAME = _textLabelView.frame;
    }
    
    if([_detailItem photo]){
        _imageView = [[UIImageView alloc] initWithImage:_detailItem.photo];
        CGFloat scale = 320/_imageView.frame.size.width;
        
        [_textLabel setFrame:CGRectMake(CGRectGetMinX(_textLabel.frame), 10, CGRectGetWidth(_textLabel.frame), CGRectGetHeight(_textLabel.frame))];
        [_posterPhoto setFrame:CGRectMake(25, 10, 50, 50)];
        
        IMAGE_INIT_FRAME = CGRectMake(0, 0, _imageView.frame.size.width * scale, _imageView.frame.size.height * scale);
        TEXT_INIT_FRAME = CGRectMake(CGRectGetMinX(TEXT_INIT_FRAME), CGRectGetMaxY(IMAGE_INIT_FRAME), CGRectGetWidth(TEXT_INIT_FRAME), MAX(_textLabel.frame.size.height,60));
        
        [_imageView setFrame:IMAGE_INIT_FRAME];
        [_textLabelView setFrame:TEXT_INIT_FRAME];
    }
    
    TOOLBAR_INIT_FRAME  = CGRectMake (0, CGRectGetMaxY(TEXT_INIT_FRAME), 320, 22);
    HEADER_INIT_FRAME   = CGRectMake (0, 0, CGRectGetWidth(TOOLBAR_INIT_FRAME), CGRectGetMaxY(TOOLBAR_INIT_FRAME));
    
    _toolBarView = [[ToolBarView alloc] initWithFrame:TOOLBAR_INIT_FRAME];
    _topContainer = [[UIView alloc] initWithFrame:HEADER_INIT_FRAME];
    
    [_toolBarView setCategories:_detailItem.categories];
    [_toolBarView setLikes: _detailItem.likes];
    
    
    [_topContainer addSubview:_textLabelView];
    [_topContainer addSubview:_imageView];
    [_topContainer addSubview:_toolBarView];
    
    // Take a snapshot of the background scroll view and apply a blur to that image
    // Then add the blurred image on top of the regular image and slowly fade it in
    // in scrollViewDidScroll
    UIGraphicsBeginImageContextWithOptions(_topContainer.bounds.size, _topContainer.opaque, 0.0);
    [_topContainer.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    _blurImageView = [[UIImageView alloc] initWithFrame:HEADER_INIT_FRAME];
    _blurImageView.image = [img applyBlurWithRadius:12 tintColor:[UIColor colorWithWhite:0.8 alpha:0.4] saturationDeltaFactor:1.8 maskImage:nil];
    _blurImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _blurImageView.alpha = 0;
    _blurImageView.backgroundColor = [UIColor clearColor];
    
    [_topContainer addSubview:_blurImageView];
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 24, 56, 25)];
    [_backButton setBackgroundImage:[UIImage imageNamed:@"yellow arrow"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(leaveView:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect _windowFrame = [UIApplication sharedApplication].keyWindow.frame;
    
    _commentsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(HEADER_INIT_FRAME), CGRectGetWidth(HEADER_INIT_FRAME),CGRectGetHeight(_windowFrame)-kBarHeight) style:UITableViewStylePlain];
    _commentsTableView.scrollEnabled = NO;
    _commentsTableView.delegate = self;
    _commentsTableView.dataSource = self;
    _commentsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _commentsTableView.separatorColor = [UIColor clearColor];
    
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_windowFrame), CGRectGetHeight(_windowFrame))];
    _mainScrollView.delegate = self;
    _mainScrollView.bounces = YES;
    _mainScrollView.alwaysBounceVertical = YES;
    _mainScrollView.contentSize = CGSizeZero;
    _mainScrollView.showsVerticalScrollIndicator = YES;
    _mainScrollView.canCancelContentTouches = NO;
    _mainScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(kBarHeight, 0, 0, 0);
    [_mainScrollView setContentSize:CGSizeMake(CGRectGetWidth(HEADER_INIT_FRAME), CGRectGetHeight(_windowFrame)+CGRectGetHeight(HEADER_INIT_FRAME)-kBarHeight)];
    [_mainScrollView setContentOffset:CGPointMake(0, 0)];
    
    
    [_mainScrollView addSubview:_topContainer];
    [_mainScrollView addSubview:_commentsTableView];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_mainScrollView];
    [self.view addSubview:_backButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotComments:) name:@"gotComments" object:nil];
    [[AppDelegate zazzApi] getCommentsFor:_detailItem.type andId:[NSString stringWithFormat:@"%@",detailItem.itemId]];
    
    return self;
}


-(void)leaveView:(id)sender{
    [[[AppDelegate getAppDelegate] navController] popViewControllerAnimated:true];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat delta = 0.0f;
    [_mainScrollView setBounces:true];
    // Here is where I do the "Zooming" image and the quick fade out the text and toolbar
    if (scrollView.contentOffset.y < 0.0f) {
        delta = fabs(MIN(0.0f, _mainScrollView.contentOffset.y));
        _topContainer.frame = CGRectMake(CGRectGetMinX(HEADER_INIT_FRAME),
                                         CGRectGetMinY(HEADER_INIT_FRAME)-delta,
                                         CGRectGetWidth(HEADER_INIT_FRAME),
                                         CGRectGetHeight(HEADER_INIT_FRAME) + delta);
        _toolBarView.frame  = CGRectMake(CGRectGetMinX(TOOLBAR_INIT_FRAME),
                                         CGRectGetHeight(_topContainer.frame) - 22,
                                         CGRectGetWidth(TOOLBAR_INIT_FRAME),
                                         CGRectGetHeight(TOOLBAR_INIT_FRAME));
        if(_detailItem.photo){
            _imageView.frame    = CGRectMake(CGRectGetMinX(IMAGE_INIT_FRAME) - delta / 2.0f,
                                             CGRectGetMinY(IMAGE_INIT_FRAME),
                                             CGRectGetWidth(IMAGE_INIT_FRAME) + delta,
                                             CGRectGetHeight(IMAGE_INIT_FRAME) + delta);
            _textLabelView.frame= CGRectMake(CGRectGetMinX(TEXT_INIT_FRAME),
                                             CGRectGetMaxY(_imageView.frame),
                                             CGRectGetWidth(TEXT_INIT_FRAME),
                                             CGRectGetHeight(TEXT_INIT_FRAME));
        }
        [_commentsTableView setContentOffset:(CGPoint){0,0} animated:NO];
    } else {
        [_mainScrollView setBounces:false];
        delta = _mainScrollView.contentOffset.y;
        float content_height_init = HEADER_INIT_FRAME.size.height - kBarHeight;
        float content_height      = content_height_init - delta;
        float alpha = MAX(0, content_height/content_height_init);

//        _textLabelView.alpha = alpha;
//        _toolBarView.alpha = alpha;
        _blurImageView.alpha = 1-alpha;
        
        if (alpha <= 0) {
//            NSLog(@"%f",content_height);
            _topContainer.frame = CGRectMake(0, delta + kBarHeight - CGRectGetHeight(_topContainer.frame) ,
                                            CGRectGetWidth(_topContainer.frame), CGRectGetHeight(HEADER_INIT_FRAME));
            _commentsTableView.frame = CGRectMake(0, CGRectGetMaxY(_topContainer.frame),
                                                      CGRectGetWidth(_commentsTableView.frame), CGRectGetHeight(_commentsTableView.frame));
            [_commentsTableView setScrollEnabled:true];
        }
        else {
            NSLog(@"4");
            [_commentsTableView setScrollEnabled:false];
            _toolBarView.frame = TOOLBAR_INIT_FRAME;
            _topContainer.frame = HEADER_INIT_FRAME;
            _commentsTableView.frame = CGRectMake(0, CGRectGetMaxY(_topContainer.frame), CGRectGetWidth(_commentsTableView.frame), CGRectGetHeight(_commentsTableView.frame));
            [_commentsTableView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
    }
}

#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_detailItem.comments)
        return 1;
    return [_detailItem.comments count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!_detailItem.comments){
        return 50;
    }
    Comment* comment = [_detailItem.comments objectAtIndex:[indexPath row]];
    NSString *text = comment.text;
    CGSize requiredSize;
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGRect rect = [text boundingRectWithSize:(CGSize){225, MAXFLOAT}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont secretFontLightWithSize:16.f]}
                                                   context:nil];
        requiredSize = rect.size;
    } else {
        requiredSize = [text sizeWithFont:[UIFont secretFontLightWithSize:16.f] constrainedToSize:(CGSize){225, MAXFLOAT} lineBreakMode:NSLineBreakByWordWrapping];
    }
    return kCommentCellHeight + requiredSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!_detailItem.comments){
        NSString* identifier = @"cellLoader";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] init];
        [spinner setFrame:cell.frame];
        [spinner setColor:[UIColor colorFromHexString:COLOR_ZAZZ_YELLOW]];
        [cell addSubview:spinner];
        [spinner startAnimating];
        return cell;
    }
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentView"];
    Comment* comment = _detailItem.comments[indexPath.row];
    if (!cell) {
        cell = [[CommentCell alloc]initWithComment:comment andReuseIdentifier:@"commentView"];
    }
    [cell.iconView setImage: comment.user.photo];
    [cell.commentLabel setFrame:CGRectMake(CGRectGetMaxX(cell.iconView.frame)+ kCommentPaddingFromLeft, 15, cell.frame.size.width - 80, 0)];
    [cell.commentLabel setText: comment.text];
    [cell.commentLabel resizeWithFlexibleHeight];
    
    [cell.commentLabel sizeToFit];
    cell.timeLabel.frame = (CGRect) {.origin = {CGRectGetMinX(cell.commentLabel.frame), CGRectGetMaxY(cell.commentLabel.frame)}};
    [cell.timeLabel setText:[ZazzApi formatDateString:comment.time]];
    [cell.timeLabel sizeToFit];

    return cell;
}


- (void)viewDidAppear:(BOOL)animated {
//    _mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), _commentsTableView.contentSize.height + CGRectGetHeight(_backgroundScrollView.frame));
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)gotComments:(NSNotification*)notif{
    NSString* type = [notif.userInfo objectForKey:@"type"];
    NSString* objId = [notif.userInfo objectForKey:@"feedId"];
    if(![type isEqualToString:_detailItem.type] || [objId intValue] != [_detailItem.itemId intValue]) return;
    NSLog(@"gotComments");
    _detailItem.comments = notif.object;
    [_toolBarView setNumberOfComments:[_detailItem.comments count]];
    [_commentsTableView reloadData];
}

@end
