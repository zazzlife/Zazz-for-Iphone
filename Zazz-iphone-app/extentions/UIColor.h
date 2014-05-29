@interface UIColor (mxcl)
+ (UIColor *)colorFromHexString:(NSString *)hexString;
@end

@implementation UIColor (mxcl)

// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
#define UIColorFromRGBA(rgbValue)
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0
                           alpha:((float)((rgbValue & 0xFF))/255.0)];
    
    //    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 24)/255.0 green:((rgbValue & 0xFF00) >> 16)/255.0 blue:((rgbValue & 0xFF) >> 8)/255.0 alpha:1.0];
}
@end