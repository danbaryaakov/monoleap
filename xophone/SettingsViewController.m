//
//  SettingsViewController.m
//
//
//  Created by Dan Bar-Yaakov on 7/29/15.
//  Copyright (c) 2015 Dan Bar-Yaakov. All rights reserved.
//

#import <CoreMIDI/CoreMIDI.h>
#import "SettingsViewController.h"
#import "SettingsManager.h"
#import "ThemeSelectionController.h"
#import "ActionSheetPicker.h"

@interface SettingsViewController ()<UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnMidiChannel;

@property (weak, nonatomic) IBOutlet UILabel *leftXLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftYLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightYLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightXLabel;

@property (weak, nonatomic) IBOutlet UISwitch *leftXCtrlEnabled;
@property (weak, nonatomic) IBOutlet UISlider *leftXCtrlValueSlider;
@property (weak, nonatomic) IBOutlet UIStepper *leftXCtrlValueStepper;

@property (weak, nonatomic) IBOutlet UIButton *selectThemeButton;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;

@property (weak, nonatomic) IBOutlet UISwitch *leftYCtrlEnabled;
@property (weak, nonatomic) IBOutlet UISlider *leftYCtrlValueSlider;
@property (weak, nonatomic) IBOutlet UIStepper *leftYCtrlValueStepper;

@property (weak, nonatomic) IBOutlet UISwitch *rightXCtrlEnabled;
@property (weak, nonatomic) IBOutlet UISlider *rightXCtrlValueSlider;
@property (weak, nonatomic) IBOutlet UIStepper *rightXCtrlValueStepper;

@property (weak, nonatomic) IBOutlet UISwitch *rightYCtrlEnabled;
@property (weak, nonatomic) IBOutlet UISlider *rightYCtrlValueSlider;
@property (weak, nonatomic) IBOutlet UIStepper *rightYCtrlValueStepper;

@property (weak, nonatomic) IBOutlet UISwitch *keySwitchEnabled;

@property (weak, nonatomic) IBOutlet UISwitch *pitchBendSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *velocitySwitch;

@property (strong, nonatomic) IBOutlet UISwitch *enableSynth;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SettingsManager *settings = [SettingsManager sharedInstance];
    
    [self.leftXCtrlEnabled setOn: settings.leftXCtrlEnabled.boolValue];
    [self.leftXCtrlValueSlider setValue: settings.leftXCtrlValue.floatValue];
    [self.leftXCtrlValueStepper setValue: settings.leftXCtrlValue.intValue];
    self.leftXLabel.text = [NSString stringWithFormat:@"%i", settings.leftXCtrlValue.intValue];
    
    [self.leftYCtrlEnabled setOn: settings.leftYCtrlEnabled.boolValue];
    [[self leftYCtrlValueSlider]setValue: settings.leftYCtrlValue.floatValue];
    [self.leftYCtrlValueStepper setValue:settings.leftYCtrlValue.intValue];
    self.leftYLabel.text = [NSString stringWithFormat:@"%i", settings.leftYCtrlValue.intValue];
    
    [self.rightYCtrlEnabled setOn: settings.rightYCtrlEnabled.boolValue];
    [[self rightYCtrlValueSlider]setValue: settings.rightYCtrlValue.floatValue];
    [self.rightYCtrlValueStepper setValue:settings.rightYCtrlValue.intValue];
    self.rightYLabel.text = [NSString stringWithFormat:@"%i", settings.rightYCtrlValue.intValue];
    
    [self.rightXCtrlEnabled setOn: settings.rightXCtrlEnabled.boolValue];
    [[self rightXCtrlValueSlider]setValue: settings.rightXCtrlValue.floatValue];
    [self.rightXCtrlValueStepper setValue:settings.rightXCtrlValue.intValue];
    self.rightXLabel.text = [NSString stringWithFormat:@"%i", settings.rightXCtrlValue.intValue];
    
    [[self pitchBendSwitch] setOn: settings.pitchBendEnabled.boolValue];
    [[self keySwitchEnabled] setOn: settings.keySwitchEnabled.boolValue];
    [[self velocitySwitch] setOn: settings.velocityEnabled.boolValue];

    [[self btnMidiChannel] setTitle:settings.midiOutChannel.stringValue forState:UIControlStateNormal];

    [[self enableSynth]setOn:settings.synthEnabled.boolValue];
    
    self.themeLabel.text = settings.themeName;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(themeSelected:)
                                                 name:@"THEME_SELECTED"
                                               object:nil];
    
    MIDIClientCreate(CFSTR("Xophone"), nil, nil, &client);
    MIDIOutputPortCreate(client, CFSTR("Xophone Output Port"), &outputPort);
}

- (IBAction)xAxisRightChanged:(id)sender {
}

- (IBAction)pitchBendEnableChanged:(UISwitch*)sender {
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.pitchBendEnabled = [NSNumber numberWithBool:sender.on];
}

- (IBAction)xAxisLeftCtrlEnable:(UISwitch *)sender {
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.leftXCtrlEnabled = [NSNumber numberWithBool:sender.on];
}

- (IBAction)xAxisLeftChanged:(UISlider*)sender {
    int value = floor(sender.value);
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.leftXCtrlValue = [NSNumber numberWithInt: value];
    self.leftXLabel.text = [NSString stringWithFormat:@"%i", value];
    [self.leftXCtrlValueStepper setValue:value];
}

- (IBAction)xAxisLeftStepperChanged:(UIStepper*)sender {
    int value = floor(sender.value);
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.leftXCtrlValue = [NSNumber numberWithInt: value];
    self.leftXLabel.text = [NSString stringWithFormat:@"%i", value];
    [self.leftXCtrlValueSlider setValue:value animated:YES ];
}

- (IBAction)yAxisLeftCtrlEnable:(UISwitch*)sender {
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.leftYCtrlEnabled = [NSNumber numberWithBool:sender.on];
}

- (IBAction)synthEnabled:(UISwitch*)sender {
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.synthEnabled = [NSNumber numberWithBool:sender.on];
}


- (IBAction)sendXAxisLeft:(id)sender {
    for (int i = 1; i < 127; i++) {
        Byte message[] = {176, self.leftXCtrlValueSlider.value, i};
        [self sendMidi:message];
    }
}

- (IBAction)yAxisLeftChanged:(UISlider*)sender {
    int value = floor(sender.value);
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.leftYCtrlValue = [NSNumber numberWithInt:value];
    self.leftYLabel.text = [NSString stringWithFormat:@"%i", value];
    [self.leftYCtrlValueStepper setValue:value];
}

- (IBAction)yAxisLeftStepperChanged:(UIStepper*)sender {
    int value = floor(sender.value);
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.leftYCtrlValue = [NSNumber numberWithInt:value];
    self.leftYLabel.text = [NSString stringWithFormat:@"%i", value];
    [self.leftYCtrlValueSlider setValue: value animated:YES];
}

- (IBAction)sendYAxisLeft:(id)sender {
    for (int i = 1; i < 127; i++) {
        
        Byte message[] = {176, self.leftYCtrlValueSlider.value, i};
        [self sendMidi:message];
    }
}
- (IBAction)yAxisRightCtrlEnable:(UISwitch*)sender {
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.rightYCtrlEnabled = [NSNumber numberWithBool:sender.on];
}

- (IBAction)yAxisRightSliderChanged:(UISlider*)sender {
    int value = floor(sender.value);
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.rightYCtrlValue = [NSNumber numberWithInt:value];
    self.rightYLabel.text = [NSString stringWithFormat:@"%i", value];
    [self.rightYCtrlValueStepper setValue:value];
}

- (IBAction)yAxisRightStepperChanged:(UIStepper*)sender {
    int value = floor(sender.value);
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.rightYCtrlValue = [NSNumber numberWithInt:value];
    self.rightYLabel.text = [NSString stringWithFormat:@"%i", value];
    [self.rightYCtrlValueSlider setValue: value animated:YES];
}

- (IBAction)sendYAxisRight:(id)sender {
    for (int i = 1; i < 127; i++) {
        Byte message[] = {176, self.rightYCtrlValueSlider.value, i};
        [self sendMidi:message];
    }

}

- (IBAction)xAxisRightCtrlEnable:(UISwitch*)sender {
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.rightXCtrlEnabled = [NSNumber numberWithBool:sender.on];
}

- (IBAction)xAxisRightSliderChanged:(UISlider*)sender {
    int value = floor(sender.value);
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.rightXCtrlValue = [NSNumber numberWithInt:value];
    self.rightXLabel.text = [NSString stringWithFormat:@"%i", value];
    [self.rightXCtrlValueStepper setValue:value];

}

- (IBAction)xAxisRightStepperChanged:(UIStepper*)sender {
    int value = floor(sender.value);
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.rightYCtrlValue = [NSNumber numberWithInt:value];
    self.rightXLabel.text = [NSString stringWithFormat:@"%i", value];
    [self.rightXCtrlValueSlider setValue: value animated:YES];

}

- (IBAction)sendXAxisRight:(id)sender {
    for (int i = 1; i < 127; i++) {
        Byte message[] = {176, self.rightXCtrlValueSlider.value, i};
        [self sendMidi:message];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)enableKSChanged:(UISwitch*)sender {
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.keySwitchEnabled = [NSNumber numberWithBool:sender.on];
}

- (IBAction)enableVelocityChanged:(UISwitch*)sender {
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.velocityEnabled = [NSNumber numberWithBool:sender.on];
}

- (IBAction)enableSythChanged:(UISwitch *)sender {
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.synthEnabled = [NSNumber numberWithBool:sender.on];
}

-(void)sendMidi:(Byte*)message {
    MIDIPacketList packetList;
    MIDIPacket *packet = MIDIPacketListInit(&packetList);
    MIDIPacketListAdd(&packetList, sizeof(packetList), packet, 0, sizeof(message), message);
    
    ItemCount destinationCount = MIDIGetNumberOfDestinations();
    for (int i = 0; i < destinationCount; i++) {
        MIDISend(outputPort, MIDIGetDestination(i), &packetList);
    }
}

- (IBAction)selectTheme:(id)sender {
    
    // grab the view controller we want to show
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"App" bundle:nil];
    ThemeSelectionController *controller = [storyboard instantiateViewControllerWithIdentifier:@"Themes"];
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    controller.modalPresentationStyle = UIModalPresentationPopover;
    controller.preferredContentSize = CGSizeMake(280,200);
    [self presentViewController:controller animated:YES completion:nil];
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.delegate = self;
    popController.sourceRect = CGRectMake(self.selectThemeButton.frame.size.width / 2, 0, 0, 0);

    // in case we don't have a bar button as reference


    popController.sourceView = self.selectThemeButton;
    [popController setBackgroundColor: controller.view.backgroundColor];
    
}

-(void)themeSelected:(NSNotification*)notification {
    NSString* themeName = notification.object;
    self.themeLabel.text = themeName;
    SettingsManager *settings = [SettingsManager sharedInstance];
    settings.themeName = themeName;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
# pragma mark - Popover Presentation Controller Delegate

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    return YES;
}

- (void)popoverPresentationController:(UIPopoverPresentationController *)popoverPresentationController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView *__autoreleasing  _Nonnull *)view {
}
- (IBAction)selectMidiChannel:(id)sender {
    NSArray *channels = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", nil];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select MIDI Channel"
                                            rows: channels
                                initialSelection: self.btnMidiChannel.titleLabel.text.integerValue - 1
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           
                                           [self.btnMidiChannel setTitle:selectedValue forState:UIControlStateNormal];
                                           
                                           SettingsManager *settings = [SettingsManager sharedInstance];
                                           
                                           settings.midiOutChannel = [NSNumber numberWithInteger:self.btnMidiChannel.titleLabel.text.integerValue];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         
                                     }
                                          origin:sender];
}

@end
