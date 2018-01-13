//
//  ThemeSelectionController.m
//  monoleap
//
//  Created by Dan Bar-Yaakov on 29/10/2015.
//  Copyright © 2015 Dan Bar-Yaakov. All rights reserved.
//

#import "ThemeSelectionController.h"
#import "SettingsManager.h"
#import "Theme.h"

@interface ThemeSelectionController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *themeSelector;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

@implementation ThemeSelectionController
- (void)viewDidLoad {
    [super viewDidLoad];
    SettingsManager* settings = [SettingsManager sharedInstance];
    for (int i = 0; i < [self.themeSelector numberOfSegments]; i++)
    {
        if ([[self.themeSelector titleForSegmentAtIndex:i] isEqualToString:settings.themeName])
        {
            [self.themeSelector setSelectedSegmentIndex:i];
            break;
        }
    }
    
    self.descriptionLabel.numberOfLines = 3;
    self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.descriptionLabel.text = [Theme themeDescription:settings.themeName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)themeSelected:(UISegmentedControl*)segment {
    NSString* selectedThemeName = [segment titleForSegmentAtIndex:segment.selectedSegmentIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"THEME_SELECTED" object: selectedThemeName];
    self.descriptionLabel.text = [Theme themeDescription:selectedThemeName];
}

- (void)dismissMe {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
