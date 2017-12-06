//
//  Roboto.swift
//  POE
//
//  Created by Benjamin Erhart on 24.03.17.
//  Copyright © 2017 Guardian Project. All rights reserved.
//

import UIKit

enum Roboto {
    static let defaultSize: CGFloat = 17

    static let regular = "Roboto-Regular"
    static let italic = "Roboto-Italic"
    static let bold = "Roboto-Bold"
    static let boldItalic = "Roboto-BoldItalic"
    static let black = "Roboto-Black"
    static let blackItalic = "Roboto-BlackItalic"
    static let medium = "Roboto-Medium"
    static let mediumItalic = "Roboto-MediumItalic"
    static let light = "Roboto-Light"
    static let lightItalic = "Roboto-LightItalic"
    static let thin = "Roboto-Thin"
    static let thinItalic = "Roboto-ThinItalic"

    static let condensed = "RobotoCondensed-Regular"
    static let condensedItalic = "RobotoCondensed-Italic"
    static let condensedBold = "RobotoCondensed-Bold"
    static let condensedBoldItalic = "RobotoCondensed-BoldItalic"
    static let condensedLight = "RobotoCondensed-Light"
    static let condensedLightItalic = "RobotoCondensed-LightItalic"
}


/**
    Evaluate a given font and replace it with the most adequate font of the Roboto family.
 
    - Parameter oldFont
        The original font.
 
    Inspired by [Using custom font for entire iOS app swift](http://stackoverflow.com/questions/28180449/using-custom-font-for-entire-ios-app-swift).
 */
private func replaceFont(_ oldFont: UIFont?) -> UIFont? {
    let oldName = oldFont?.fontName.lowercased() ?? ""
    var name :String

    if oldName.contains("condensed") {
        if oldName.contains("bold") || oldName.contains("black") {
            name = oldName.contains("italic") ? Roboto.condensedBoldItalic : Roboto.condensedBold
        }
        else if oldName.contains("light") || oldName.contains("ultralight") || oldName.contains("thin") {
            name = oldName.contains("italic") ? Roboto.condensedLightItalic : Roboto.condensedLight
        }
        else if oldName.contains("italic") {
            name = Roboto.condensedItalic
        }
        else {
            name = Roboto.condensed
        }
    }
    else if oldName.contains("bold") {
        name = oldName.contains("italic") ? Roboto.boldItalic : Roboto.bold
    }
    else if oldName.contains("black") {
        name = oldName.contains("italic") ? Roboto.blackItalic : Roboto.black
    }
    else if oldName.contains("medium") {
        name = oldName.contains("italic") ? Roboto.mediumItalic : Roboto.medium
    }
    else if oldName.contains("light") {
        name = oldName.contains("italic") ? Roboto.lightItalic : Roboto.light
    }
    else if oldName.contains("ultralight") || oldName.contains("thin") {
        name = oldName.contains("italic") ? Roboto.thinItalic : Roboto.thin
    }
    else if oldName.contains("italic") {
        name = Roboto.italic
    }
    else {
        name = Roboto.regular
    }

    if let font = UIFont(name: name, size: oldFont?.pointSize ?? Roboto.defaultSize) {
        return font
    }

    return oldFont
}


extension UILabel {
    var substituteFont: Bool {
        get {
            return false
        }
        set {
            self.font = replaceFont(self.font)
        }
    }
}

extension UITextView {
    var substituteFont : Bool {
        get {
            return false
        }
        set {
            self.font = replaceFont(self.font)
        }
    }
}

extension UITextField {
    var substituteFont : Bool {
        get {
            return false
        }
        set {
            self.font = replaceFont(self.font)
        }
    }
}

/**
    Taken from 
    [Can I embed a custom font in a bundle and access it from an ios framework?](http://stackoverflow.com/questions/14735522/can-i-embed-a-custom-font-in-a-bundle-and-access-it-from-an-ios-framework)
 */
private func registerFont(from url: URL) throws {
    guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
        throw NSError.init(domain: "Could not create font data provider for \(url).", code: -1, userInfo: nil)
    }
    let font = CGFont(fontDataProvider)
    var error: Unmanaged<CFError>?
    guard CTFontManagerRegisterGraphicsFont(font!, &error) else {
        throw error!.takeUnretainedValue()
    }
}

/**
    Inspired by 
    [Can I embed a custom font in a bundle and access it from an ios framework?](http://stackoverflow.com/questions/14735522/can-i-embed-a-custom-font-in-a-bundle-and-access-it-from-an-ios-framework)
*/
private func fontURLs() -> [URL] {
    var urls = [URL]()

    // Fortunately, file and font names are identical with the Roboto font family.
    let fileNames = [
        Roboto.black, Roboto.blackItalic,
        Roboto.bold, Roboto.boldItalic,
        Roboto.italic,
        Roboto.light, Roboto.lightItalic,
        Roboto.medium, Roboto.mediumItalic,
        Roboto.regular,
        Roboto.thin, Roboto.thinItalic,
        Roboto.condensedBold, Roboto.condensedBoldItalic,
        Roboto.condensedItalic,
        Roboto.condensedLight, Roboto.condensedLightItalic,
        Roboto.condensed]

    fileNames.forEach({
        if let url = XibViewController.getBundle().url(forResource: $0, withExtension: "ttf") {
            urls.append(url)
        }
    })

    return urls
}

/**
    #robotoIt() needs to be called only once.
    This flag tracks that.
 */
private var robotoed = false

/**
    Loads and injects the Roboto font family dynamically into the app.
 
    Replaces the normal font of UILabels, UITextViews and UITextFields with proper styles of the 
    Roboto font family.
 
    If the fonts are not properly replaced, ensure that the font files are added to the "POE" target
    properly!
 */
func robotoIt() {
    if (!robotoed) {
        do {
            try fontURLs().forEach({ try registerFont(from: $0) })
        } catch {
            print(error)
        }

        UILabel.appearance().substituteFont = true
        UITextView.appearance().substituteFont = true
        UITextField.appearance().substituteFont = true

        robotoed = true

//        // Debug: Print list of font families and their fonts.
//        for family: String in UIFont.familyNames {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family) {
//                print("== \(names)")
//            }
//        }
    }
}
