//
//  ThemeManager.swift
//  monoleap
//
//  Created by Dan on 18/09/2021.
//  Copyright © 2021 Dan Bar-Yaakov. All rights reserved.
//

import Foundation

public struct ThemeInfo : Hashable {
    
    var key: String
    var name: String
    var image: String = "theme_test"
    
    var creator: () -> Theme
    
    public static func == (lhs: ThemeInfo, rhs: ThemeInfo) -> Bool {
        return lhs.key == rhs.key
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
}

public class ThemeManager : NSObject {
    
    static public let instance = ThemeManager()
    
    var allKeys: [String] = []
    var themes: [String:ThemeInfo] = [:]
    
    public var themeNames: [String] {
        get {
            allKeys
        }
    }
    
    private override init() {
        super.init()
        register("SPARK", name: "Spark", image: "theme_spark", creator: { RGBShaderTheme("Spark") })
        register("WATER_COLORS", name: "Water Colors", image: "theme_water_colors", creator: { RGBShaderTheme("WaterColors") })
        register("COLOR_CIRCLE", name: "Circle of Light", image: "theme_circle_of_light", creator: { RGBShaderTheme("Circles") })
        register("FLOWER", name: "Flower", image: "theme_flower", creator: { RGBShaderTheme("Flower") })
        register("FIRE", name: "Fire", image: "theme_fire", creator: { RGBShaderTheme("WarpLines") })
        register("RAINBOW", name: "Rainbow", image: "theme_rainbow", creator: { RGBShaderTheme("Rainbow") })
        register("DISCO", name: "Disco", image: "theme_disco", creator: { RGBShaderTheme("Splash") })
        register("RAINBOW_CIRCLES", name: "Rainbow Circles", image: "theme_rainbow_circles", creator: { RGBShaderTheme("ColorSquares") })
//        register("PARTICLES", name: "Particles", creator: { ColorBurstTheme() })
    }
    
    private func register(_ key: String, name: String, image: String = "theme_spark", creator: @escaping () -> Theme) {
        let info = ThemeInfo(key: key, name: name, image: image, creator: creator)
        themes[key] = info
        allKeys.append(key)
    }
    
    public func createTheme(key: String) -> Theme? {
        if let info = themes[key] {
            return info.creator()
        }
        return nil
    }
    
    public func createCurrentTheme() -> Theme? {
        if let info = themes[Settings.selectedTheme.value] {
            return info.creator()
        } else {
            Settings.selectedTheme.value = Settings.selectedTheme.defaultValue
            let info = themes[Settings.selectedTheme.value]
            return info?.creator()
        }
    }
    
    public func getAllThemes() -> [ThemeInfo] {
        return allKeys.map({themes[$0]!})
    }
}
