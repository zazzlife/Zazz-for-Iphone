@interface UIImage (mxcl)
+ (UIImage *)imageWithColor:(UIColor *)color width:(float)width andHeight:(float)height;
@end

@implementation UIImage (mxcl)
+ (UIImage *)imageWithColor:(UIColor *)color width:(float)width andHeight:(float)height{
    CGRect rect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end