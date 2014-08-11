
#import <UIKit/UIKit.h>
#import "CTAssetsPickerController.h"


@protocol MediaReceiver <NSObject>
@optional
-(void)setMediaAttachment:(id)media;
@end

@interface PhotoPicker: NSObject

@property UIViewController<MediaReceiver>* delegate;

- (PhotoPicker*) initWithMediaReceiver:(UIViewController<MediaReceiver>*)mediaReiver;
- (void) pickAssets;

@end
