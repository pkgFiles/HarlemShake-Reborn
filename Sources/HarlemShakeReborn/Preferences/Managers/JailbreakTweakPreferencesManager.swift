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
import HarlemShakeRebornC

final class JailbreakTweakPreferencesManager {
    
    //MARK: - Singelton
    static let current = JailbreakTweakPreferencesManager()
    
    //MARK: - Variables
    lazy var settings: SettingsModel = loadPreferences()
    
    //MARK: - Initializers
    private init() {
        NSDistributedNotificationCenter.default.addObserver(self,
                                                            selector: #selector(reloadPreferences),
                                                            name: .didUpdateEnabledStateValue,
                                                            object: nil)
    }
    
    //MARK: - Functions
    func loadPreferences() -> SettingsModel {
        guard let data = FileManager.default.contents(atPath: JailbreakTweakManager.shared.plistPath) else {
            guard !FileManager.default.fileExists(atPath: JailbreakTweakManager.shared.plistPath) else { return .init() }
            remLog("Preferences don't exist... Creating...")
            do {
                return try createPreferences(atPath: JailbreakTweakManager.shared.plistPath)
            } catch { remLog(error.localizedDescription); return .init() }
        }
        
        do {
            remLog("Preferences Loading...")
            let settings = try PropertyListDecoder().decode(SettingsModel.self, from: data)
            remLog(settings)
            return settings
        } catch {
            remLog("Preferences Updating...")
            do {
                return try updatePreferences(atPath: JailbreakTweakManager.shared.plistPath)
            } catch { remLog(error.localizedDescription); return .init() }
        }
    }
    
    private func createPreferences(atPath path: String) throws -> SettingsModel {
        guard let dict = try JSONSerialization.jsonObject(with: JSONEncoder().encode(SettingsModel())) as? [String: Any] else { return .init() }
        let plistData = NSDictionary(dictionary: dict)
        plistData.write(toFile: path, atomically: true)
        return try JSONDecoder().decode(SettingsModel.self, from: try JSONSerialization.data(withJSONObject: plistData))
    }
    
    private func updatePreferences(atPath path: String) throws -> SettingsModel {
        guard let plistData: NSMutableDictionary = NSMutableDictionary(contentsOfFile: path),
              let plistKeys: [String] = plistData.allKeys as? [String] else { return .init() }
        guard let settingsData = try JSONSerialization.jsonObject(with: JSONEncoder().encode(SettingsModel())) as? [String: Any] else { throw NSError(domain: "JSONError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create a JSON-Object!"]) }
        
        for i in settingsData {
            if !plistKeys.contains(i.key) {
                remLog("The Key: \(i.key) don't exist! Adding to .plist...")
                plistData.setValue(i.value, forKey: i.key)
                plistData.write(toFile: path, atomically: true)
            }
        }
        return try JSONDecoder().decode(SettingsModel.self, from: try JSONSerialization.data(withJSONObject: plistData))
    }
    
    //MARK: - Actions
    @objc private func reloadPreferences() { settings = loadPreferences() }
}
