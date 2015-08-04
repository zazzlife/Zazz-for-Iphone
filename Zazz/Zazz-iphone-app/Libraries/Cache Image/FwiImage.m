#import "FwiImage.h"
#import "FwiCacheFolder.h"
#import "FwiCacheHandler.h"


@interface FwiImage () <FwiCacheHandlerDelegate> {
}

@property (nonatomic, retain) UIImage *defaultImage;


/** Initialize class's private variables. */
- (void)_init;
/** Visualize all view's components. */
- (void)_visualize;

/** Display downloaded image. */
- (void)_displayImage:(UIImage *)image;

@end


@implementation FwiImage


static FwiCacheHandler *_CacheHandler;


+ (void)initialize {
    if (!_CacheHandler) {
        FwiCacheFolder *cacheFolder = [FwiCacheFolder cacheFolderWithPath:@"Images"];
        _CacheHandler = [[FwiCacheHandler alloc] initWithCacheFolder:cacheFolder];
    }
}


#pragma mark - Class's constructors
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
        [self didMoveToSuperview];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}


#pragma mark - Cleanup memory
- (void)dealloc {
    FwiRelease(_url);
    FwiRelease(_defaultImage);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - Class's properties


#pragma mark - Class's public methods
- (void)downloadImageFromUrl:(NSURL *)url {
    [self downloadImageFromUrl:url isReload:NO];
}
- (void)downloadImageFromUrl:(NSURL *)url isReload:(BOOL)isReload {
    if (_url && _url == url) return;
    _imvImage.image = nil;
    FwiRelease(_url);

    if (url) {
        _url = FwiRetain(url);

        // Force to redownload
        if (isReload) {
            NSString *path = [_CacheHandler.cacheFolder readyPathForFilename:[_url description]];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }

        _vwActivity.alpha = 1.0f;
        [_vwActivity startAnimating];
        [_CacheHandler handleDelegate:self];
    }
    else {
        _vwActivity.alpha = 0.0f;
        [_vwActivity stopAnimating];
    }
}
- (void)downloadImageFromUrl:(NSURL *)url defaultImage:(UIImage *)defaultImage {
    self.defaultImage = defaultImage;
    
    _imvImage.hidden = NO;
    _imvImage.alpha  = 1.0f;
    _imvImage.image  = defaultImage;
    
    [self downloadImageFromUrl:url];
}
- (void)downloadImageFromUrl:(NSURL *)url isReload:(BOOL)isReload defaultImage:(UIImage *)defaultImage {
    self.defaultImage = defaultImage;
    
    _imvImage.hidden = NO;
    _imvImage.alpha  = 1.0f;
    _imvImage.image  = defaultImage;
    
    [self downloadImageFromUrl:url isReload:isReload];
}


#pragma mark - Class's private methods
- (void)_init {
    if (!_imvImage) {
        _imvImage = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imvImage];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_imvImage);
        [_imvImage setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSArray *constraint1 = [NSLayoutConstraint constraintsWithVisualFormat:@"|[_imvImage]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
        NSArray *constraint2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imvImage]|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
        [self addConstraints:constraint1];
        [self addConstraints:constraint2];
    }
    
    if (!_vwActivity) {
        _vwActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_vwActivity];
        
        [_vwActivity startAnimating];
        [_vwActivity setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:_vwActivity
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1
                                                                        constant:0];
        NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:_vwActivity
                                                                       attribute:NSLayoutAttributeCenterY
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeCenterY
                                                                      multiplier:1
                                                                        constant:0];
        [self addConstraint:constraint1];
        [self addConstraint:constraint2];
    }
}
- (void)_visualize {
}

- (void)_displayImage:(UIImage *)image {
    if (![[NSThread currentThread] isMainThread]) {
        [self performSelectorOnMainThread:@selector(_displayImage:) withObject:image waitUntilDone:NO];
        return;
    }

    _imvImage.alpha = 0.0f;
    _imvImage.image = image;
    [UIView animateWithDuration:0.2f
                     animations:^{
                         _imvImage.alpha   = 1.0f;
                         _vwActivity.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         [_vwActivity stopAnimating];
                     }];
}


#pragma mark - FwiCacheHandlerDelegate's members
- (NSURL *)urlForHandler:(FwiCacheHandler *)cacheHandler {
    return (_url ? _url : nil);
}

- (void)cacheHandlerWillStartDownloading:(FwiCacheHandler *)cacheHandler {
    [_vwActivity startAnimating];
}

- (void)cacheHandler:(FwiCacheHandler *)cacheHandler didFailDownloadingImage:(UIImage *)image atUrl:(NSURL *)url {
    /* Condition validation */
    if (_url != url) return;
    [_vwActivity stopAnimating];
    [self _displayImage:self.defaultImage];
}
- (void)cacheHandler:(FwiCacheHandler *)cacheHandler didFinishDownloadingImage:(UIImage *)image atUrl:(NSURL *)url {
    /* Condition validation */
    if (_url != url) return;
    [self _displayImage:(image ? image : self.defaultImage)];
}


@end
