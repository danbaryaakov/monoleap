#import <SpriteKit/SpriteKit.h>

@interface SKTexture (Gradient)

/** Creates a SKTexture programatically with a vertical gradient.
 
 Great suggestion for colors: http://ios7colors.com/.
 
 Example:
 (Inside a SKScene class)
  CIColor *topColor = [CIColor colorWithRed:1 green:0.369 blue:0.227 alpha:1];
  CIColor *bottomColor = [CIColor colorWithRed:1 green:0.165 blue:0.408 alpha:1];
  SKTexture* backgroundTexture = [SKTexture textureWithVerticalGradientofSize:self.size
                                                                     topColor:topColor
                                                                  bottomColor:bottomColor];
  SKSpriteNode* backgroundGradient = [[SKSpriteNode alloc] initWithTexture:backgroundTexture];
  backgroundGradient.position =     CGPointMake(self.size.width/2, self.size.height/2);
  [self addChild:backgroundGradient];
 */
+(SKTexture*)textureWithVerticalGradientofSize:(CGSize)size
                                      topColor:(CIColor*)topColor
                                   bottomColor:(CIColor*)bottomColor;

@end
