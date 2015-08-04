#import "NetworkManager.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>


@interface NetworkManager () <FwiServiceDelegate> {
}


/** Handle network error status. */
- (void)_handleError:(NSError *)error errorMessage:(FwiJson *)errorMessage statusCode:(FwiNetworkStatus)statusCode;

@end


@implementation NetworkManager


#pragma mark - Class's constructors
- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}


#pragma mark - Cleanup memory
- (void)dealloc {
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}


#pragma mark - Class's properties


#pragma mark - Class's public methods
- (FwiRequest *)prepareRequestWithURL:(NSURL *)url method:(FwiMethodType)method params:(NSDictionary *)params {
    FwiRequest *urlRequest = [FwiRequest requestWithURL:url methodType:method];

    // Grant access type
    if ([kPreferences tokenType] && [kPreferences accessToken]) {
        [urlRequest setValue:[NSString stringWithFormat:@"%@ %@", [kPreferences tokenType], [kPreferences accessToken]] forHTTPHeaderField:@"Authorization"];
    }
    else {
        [urlRequest setValue:@"Basic hdi7o53NSeilrq7oQihy69PvH9BBQtw5QfcJy4ALBuY" forHTTPHeaderField:@"Authorization"];
    }
    
    // Insert data parameters if available
    if (params) {
        [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, id value, BOOL *stop) {
            [urlRequest addFormParameter:[FwiFormParam paramWithKey:key andValue:[value description]]];
        }];
    }
    return urlRequest;
}

- (void)sendRequest:(FwiRequest *)request handleError:(BOOL)handleError completion:(void(^)(FwiJson *responseMessage, NSError *error, FwiNetworkStatus statusCode))completion {
    __autoreleasing FwiRESTService *service = [FwiRESTService serviceWithRequest:request];
    service.delegate = self;
    
    [service executeWithCompletion:^(FwiJson *responseMessage, NSError *error, FwiNetworkStatus statusCode) {
        if (handleError && !FwiNetworkStatusIsSuccces(statusCode)) {
            [self _handleError:error errorMessage:responseMessage statusCode:statusCode];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(responseMessage, error, statusCode);
        });
    }];
}


#pragma mark - Class's private methods
- (void)_handleError:(NSError *)error errorMessage:(FwiJson *)errorMessage statusCode:(FwiNetworkStatus)statusCode {
    switch ((NSUInteger) statusCode) {
        case 400:
        case 401: {
            __autoreleasing NSString *title = [NSString stringWithFormat:@"%@ (%i)", kText_AppName, statusCode];
            __autoreleasing NSString *message = [[errorMessage jsonWithPath:@"error_description"] getString];
            [kAppDelegate presentAlertWithTitle:title message:message];
            break;
        }
//        case 402: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Payment Required: %@", detail]];
//            break;
//        }
//        case 403: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Forbidden: %@", detail]];
//            break;
//        }
//        case 404: {
//            //                    [kAppDelegate presentAlertWithTitle:kText_Warning message:@"Resource is not available."];
//            break;
//        }
//        case 405: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Method Not Allowed: %@", detail]];
//            break;
//        }
//        case 406: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Not Acceptable: %@", detail]];
//            break;
//        }
//        case 407: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Proxy Authentication Required: %@", detail]];
//            break;
//        }
//        case 408: {
//            break;
//        }
//        case 409: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Conflict: %@", detail]];
//            break;
//        }
//        case 410: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Gone: %@", detail]];
//            break;
//        }
//        case 411: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Length Required: %@", detail]];
//            break;
//        }
//        case 412: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Precondition Failed: %@", detail]];
//            break;
//        }
//        case 413: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Request Entity Too Large: %@", detail]];
//            break;
//        }
//        case 414: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Request-URI Too Large: %@", detail]];
//            break;
//        }
//        case 415: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Unsupported Media Type: %@", detail]];
//            break;
//        }
//        case 416: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Requested range not satisfiable: %@", detail]];
//            break;
//        }
//        case 417: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Expectation Failed: %@", detail]];
//            break;
//        }
//        case 418: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"I'm a teapot: %@", detail]];
//            break;
//        }
//        case 422: {
//            break;
//        }
//        case 423: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Locked: %@", detail]];
//            break;
//        }
//        case 424: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Failed Dependency: %@", detail]];
//            break;
//        }
//        case 425: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Unordered Collection: %@", detail]];
//            break;
//        }
//        case 426: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Upgrade Required: %@", detail]];
//            break;
//        }
//        case 428: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Precondition Required: %@", detail]];
//            break;
//        }
//        case 429: {
//            break;
//        }
//        case 431: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Request Header Fields Too Large: %@", detail]];
//            break;
//        }
//        case 500: {
//            break;
//        }
//        case 501: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Not Implemented: %@", detail]];
//            break;
//        }
//        case 502: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Bad Gateway: %@", detail]];
//            break;
//        }
//        case 503: {
//            break;
//        }
//        case 504: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Gateway Time-out: %@", detail]];
//            break;
//        }
//        case 505: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"HTTP Version not supported: %@", detail]];
//            break;
//        }
//        case 506: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Variant Also Negotiates: %@", detail]];
//            break;
//        }
//        case 507: {
//            break;
//        }
//        case 508: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Loop Detected: %@", detail]];
//            break;
//        }
//        case 511: {
//            //                    [kAppDelegate presentAlertWithTitle:title message:[NSString stringWithFormat:@"Network Authentication Required: %@", detail]];
//            break;
//        }
//        case kNetworkStatus_CannotConnectToHost:
        default:
            [kAppDelegate presentAlertWithTitle:kText_AppName message:@"Could not connect to server at the moment."];
            break;
    }
}


#pragma mark - FwiServiceDelegate's members
- (BOOL)service:(FwiService *)service authenticationChallenge:(SecCertificateRef)certificateRef {
    return YES;
}


@end