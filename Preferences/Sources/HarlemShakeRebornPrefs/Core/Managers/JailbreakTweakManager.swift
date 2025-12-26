/*
 
 MIT License

 Copyright (c) 2025 ★ Install Package Files

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
*/

import Foundation

final class JailbreakTweakManager {
    
    //MARK: - Enums
    enum JailbreakPaths {
        case bin
        case plist
        case assets
        
        var relativePath: String {
            switch self {
            case .bin:      return "usr/bin/"
            case .plist:    return "mobile/Library/Preferences/"
            case .assets:   return "Library/PreferenceBundles/"
            }
        }
    }
    
    //MARK: - Singelton
    static let shared = JailbreakTweakManager()
    
    //MARK: - Variables
    var binPath: String!
    var plistPath: String!
    var prefsAssetsPath: String!
    
    let currentPreferencesIdentifier: String = "Prefs"
    let currentTweakName: String = "HarlemShake Reborn"
    lazy var configuration: PackageConfiguration = .init(bundleName: currentTweakName.components(separatedBy: .whitespaces).joined() + currentPreferencesIdentifier,
                                                         plistName: "com.pkgfiles." + currentTweakName.components(separatedBy: .whitespaces).joined().lowercased() + currentPreferencesIdentifier.lowercased(),
                                                    tweakColor: .init(red: 112/255, green: 145/255, blue: 177/255, alpha: 1.0))
    
    //MARK: - Initializers
    private init() {}
    
    //MARK: - Functions
    /*
            NOTE: This file is a symlink, therefore 'roothide' cannot be imported directly (Or I just don't know how)...
            The current implementation serves as a workaround to accommodate this by using 'configure(with jbroot: String)'
    */
    func configure(with jbroot: String) {
        plistPath = load(path: .plist, for: jbroot) + configuration.plistName
        prefsAssetsPath = load(path: .assets, for: jbroot) + configuration.bundleName
        binPath = load(path: .bin, for: jbroot)
    }
    
    private func load(path: JailbreakPaths, for basePath: String) -> String {
        switch path {
        case .plist:    return basePath + "var/" + path.relativePath
        default:        return basePath + path.relativePath
        }
    }
}
