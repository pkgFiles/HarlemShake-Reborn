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

import Preferences
import HarlemShakeRebornPrefsC

extension PSListController {
    
    open override func readPreferenceValue(_ specifier: PSSpecifier!) -> Any! {
        guard let defaultPath = specifier.properties["defaults"] as? String else {
            return super.readPreferenceValue(specifier)
        }

        let path = "\(plistPath)\(defaultPath).plist"
        let settings = NSDictionary(contentsOfFile: path)

        return settings?[specifier.property(forKey: "key") as Any] ?? specifier.property(forKey: "default")
    }
    
    open override func setPreferenceValue(_ value: Any!, specifier: PSSpecifier!) {
        let path = "\(plistPath)\(specifier.properties["defaults"] as! String).plist"
        let prefs = NSMutableDictionary(contentsOfFile:path) ?? NSMutableDictionary()
        
        prefs.setValue(value, forKey: specifier.property(forKey: "key") as! String)
        prefs.write(toFile: path, atomically: true)
    }
}
