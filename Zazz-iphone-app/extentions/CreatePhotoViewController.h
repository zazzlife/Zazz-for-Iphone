
#import <UIKit/UIKit.h>
#import "FeedViewController.h"
#import "CreateMessageViewController.h"

@interface CreatePhotoViewController: UIViewController<delegated>

@property id<MediaReceiver> delegate;

@end
