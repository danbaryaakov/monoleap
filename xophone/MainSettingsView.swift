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
    
    var body: some View {
        ZStack {
            MonoleapAssets.dark_background
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    Image("final_logo_w").resizable().scaledToFit().frame(height: 55).onTapGesture {
                        showAbout.toggle()
                    }
                    Spacer()
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
                        Capsule().fill(MonoleapAssets.dark_background).shadow(color: .black.opacity(0.75), radius: 4, x: 0, y: 4).shadow(color: .white.opacity(0.1), radius: 4, x: 0, y: -2).frame(width: 300, height: 100)
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
                    BigRoundButton(image: "play", size: 140).onTapGesture {
                        parent?.performSegue(withIdentifier: "instrument", sender: self)
                    }.onLongPressGesture {
                        parent?.performSegue(withIdentifier: "instrument", sender: self)
                    }.padding(30)
                }
            }
//            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).onTapGesture {
//                parent?.performSegue(withIdentifier: "instrument", sender: self)
//            }
        }.ignoresSafeArea()
    }
}

struct MainSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        MainSettingsView()
    }
}
