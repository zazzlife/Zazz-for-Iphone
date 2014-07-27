
#import <UIKit/UIKit.h>
#import "FeedViewController.h"
#import "CreateMessageViewController.h"

@interface CreatePhotoViewController: UIViewController<ChildViewController, delegated>

@property (nonatomic) UIViewController* parentViewController;
@property id<MediaReceiver> delegate;

@end
