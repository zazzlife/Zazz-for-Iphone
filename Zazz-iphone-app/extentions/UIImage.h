@interface UIImage (mxcl)
+ (UIImage *) imageWithColor:(UIColor *)color width:(float)width andHeight:(float)height;
+ (UIImage *) getImage:(UIImage*)image scaledToWidth:(float)width;
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


+(UIImage *) getImage:(UIImage*)image scaledToWidth:(float)width{
    float oldWidth = image.size.width;
    float scaleFactor = width / oldWidth;
    
    float newHeight = image.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [image drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end