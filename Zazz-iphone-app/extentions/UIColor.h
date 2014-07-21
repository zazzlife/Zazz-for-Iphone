
#define COLOR_ZAZZ_BLACK @"#242424"
#define COLOR_ZAZZ_GREY @"#453F3F"
#define COLOR_ZAZZ_YELLOW @"#F8C034"

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
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
@end


#define UIColorFromRGB(rgbValue)
