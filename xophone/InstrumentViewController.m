//
//  GameViewController.m
//  xophone
//
//  Created by Dan Bar-Yaakov on 7/21/15.
//  Copyright (c) 2015 Dan Bar-Yaakov. All rights reserved.
//

#import "InstrumentViewController.h"
#import "InstrumentScene.h"
#import "SettingsViewController.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    return scene;
}

@end

@implementation InstrumentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    skView.ignoresSiblingOrder = YES;
    self.view.multipleTouchEnabled = YES;
    InstrumentScene *scene = [InstrumentScene unarchiveFromFile:@"InstrumentScene"];
    
    scene.scaleMode = SKSceneScaleModeResizeFill;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSettings) name:@"showSettings" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenu) name:@"hideMenu" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenu) name:@"showMenu" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self // put here the view controller which has to be notified
                                             selector:@selector(orientationChanged:)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];
    
    [self initMenu];
    
    [skView presentScene:scene];
}

- (void)orientationChanged:(NSNotification *)notification{
    settingsButton.frame = CGRectMake(self.view.bounds.size.width - 138, self.view.bounds.size.height - 138, 128, 128);
}

-(void)initMenu {
    UIImage *starImage = [UIImage imageNamed:@"showSettings.png"];
    settingsButton = [[UIButton alloc] init];
    [settingsButton setBackgroundImage:starImage forState:UIControlStateNormal];
    settingsButton.frame = CGRectMake(self.view.bounds.size.width - 138, self.view.bounds.size.height - 138, 128, 128);
    [settingsButton addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingsButton];
    
}

-(void)showSettings {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotate
{
    return YES;
}
-(void)hideMenu {
    [UIView animateWithDuration:0.25 animations:^{settingsButton.alpha = 0.0;} completion:^(BOOL finished){if (finished) settingsButton.hidden = true;}];
}

-(void)showMenu {
    settingsButton.frame = CGRectMake(self.view.bounds.size.width - 138, self.view.bounds.size.height - 138, 128, 128);
    settingsButton.hidden = false;
    [UIView animateWithDuration:0.25 animations:^{settingsButton.alpha = 1.0;}];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
