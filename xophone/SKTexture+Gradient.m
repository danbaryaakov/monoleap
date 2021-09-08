#import "SKTexture+Gradient.h"

@implementation SKTexture (Gradient)

+(SKTexture*)textureWithHorizontalGradientofSize:(CGSize)size
                                      topColor:(CIColor*)topColor
                                   bottomColor:(CIColor*)bottomColor
{
    CIContext *coreImageContext = [CIContext contextWithOptions:nil];
    CIFilter *gradientFilter = [CIFilter filterWithName:@"CILinearGradient"];
    [gradientFilter setDefaults];
    CIVector *startVector = [CIVector vectorWithX:0 Y:size.height / 2];
    CIVector *endVector = [CIVector vectorWithX:size.width Y:size.height / 2];
    [gradientFilter setValue:startVector forKey:@"inputPoint0"];
    [gradientFilter setValue:endVector forKey:@"inputPoint1"];
    [gradientFilter setValue:bottomColor forKey:@"inputColor0"];
    [gradientFilter setValue:topColor forKey:@"inputColor1"];
    CGImageRef cgimg = [coreImageContext createCGImage:[gradientFilter outputImage]
                                              fromRect:CGRectMake(0, 0, size.width, size.height)];
    return [SKTexture textureWithImage:[UIImage imageWithCGImage:cgimg]];
}

+(SKTexture*)textureWithVerticalGradientofSize:(CGSize)size
                                      topColor:(CIColor*)topColor
                                   bottomColor:(CIColor*)bottomColor
{
    CIContext *coreImageContext = [CIContext contextWithOptions:nil];
    CIFilter *gradientFilter = [CIFilter filterWithName:@"CILinearGradient"];
    [gradientFilter setDefaults];
    CIVector *startVector = [CIVector vectorWithX: 0 Y: - size.height / 2];
    CIVector *endVector = [CIVector vectorWithX: 0 Y: size.height / 2];
    [gradientFilter setValue:startVector forKey:@"inputPoint0"];
    [gradientFilter setValue:endVector forKey:@"inputPoint1"];
    [gradientFilter setValue:bottomColor forKey:@"inputColor0"];
    [gradientFilter setValue:topColor forKey:@"inputColor1"];
    CGImageRef cgimg = [coreImageContext createCGImage:[gradientFilter outputImage]
                                              fromRect:CGRectMake(0, 0, size.width, size.height)];
    return [SKTexture textureWithImage:[UIImage imageWithCGImage:cgimg]];
}

@end
