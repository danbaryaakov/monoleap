//
//  MainSettingsView.swift
//  monoleap
//
//  Created by Dan Bar-Yaakov on 01/10/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import SwiftUI

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

enum SelectedPage {
    case instrument
    case theme
    case midi
}

struct MainSettingsView: View {
    
    var parent: MainViewController?
    
    @State private var selectedPage: SelectedPage = .instrument
    @State private var showAbout = false
    @State private var confirmationPresented = false
    
    var body: some View {
        ZStack {
            MonoleapAssets.darkBackground
            if (showAbout) {
                VStack {
                    Image("final_logo_w").resizable().scaledToFit().frame(height: 80)
                    HStack {
                        Text("Version")
                        Text(Bundle.main.releaseVersionNumber ?? "Unknown")
                    }.padding(30)
                }.padding(20).background(MonoleapAssets.sectionBackground).overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(MonoleapAssets.linearGradientTopBottom)).zIndex(1.0)
            }
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    Image("final_logo_w").resizable().scaledToFit().frame(height: 55).onTapGesture {
                        showAbout.toggle()
                    }
                    Spacer()
                    if #available(iOS 15.0, *) {
                        PageToggleButton(image: "restore_icon", showLabel: false).onTapGesture{
                            confirmationPresented = true
                        }.confirmationDialog("Restore all defaults?", isPresented: $confirmationPresented) {
                            Button("Restore Default Settings") {
                                Settings.restoreAllDefaults()
                                parent?.replaceMainView()
                            }.foregroundColor(MonoleapAssets.controlColor)
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                    Link(destination: URL(string: "https://www.monoleap.com/documentation")!) {
                        PageToggleButton(image: "help_icon", showLabel: false)
                    }
                }.padding([.leading, .trailing, .top], 20).padding(.top, 10)
                VStack {
                    switch selectedPage {
                    case .instrument:
                        InstrumentSettingsPage()
                    case .midi:
                        MIDISettingsPage()
                    case .theme:
                        ThemeSettingsPage()
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                HStack {
                    ZStack {
                        Capsule().fill(MonoleapAssets.sectionBackground).shadow(color: .black.opacity(0.75), radius: 4, x: 0, y: 4).shadow(color: .white.opacity(0.2), radius: 2, x: 0, y: -2).frame(width: 300, height: 110)
                        HStack {
                            PageToggleButton(image: "theme_icon", label: "Theme", selected: selectedPage == .theme).onTapGesture {
                                selectedPage = .theme
                            }.padding(.leading, 40)
                            PageToggleButton(image: "settings_icon", selected: selectedPage == .instrument).onTapGesture {
                                selectedPage = .instrument
                            }
                            PageToggleButton(image: "midi_icon", label: "MIDI", selected: selectedPage == .midi).onTapGesture {
                                selectedPage = .midi
                            }.padding(.trailing, 40)
                        }
                    }.padding([.trailing, .top, .bottom], 30).padding(.leading, 20)
                    Spacer()
                    Button("") {
                        parent?.performSegue(withIdentifier: "instrument", sender: self)
                    }.buttonStyle(BigRoundButtonStyle(image: "play", size: 140)).padding(30)
                }
            }
        }.ignoresSafeArea().onTapGesture {
            if (showAbout) {
                showAbout = false
            }
        }
    }
}

struct MainSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MainSettingsView()
    }
}
