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

import Orion
import AVFoundation
import HarlemShakeRebornC

class IPFHarlemShake: NSObject, AVAudioPlayerDelegate {
    
    //MARK: - Enums
    private enum IPFShakeStyle: Int, CaseIterable {
        case IPFShakeStyleStart     = 0
        case IPFShakeStyleTwo       = 1
        case IPFShakeStyleThree     = 2
    }
    
    //MARK: - Propertys
    private var audioPlayer: AVAudioPlayer?
    private var lonerView: UIView?
    private var completionCallback: (() -> Void)?
    
    //MARK: - Variables
    private var audioURL: URL {
        let basicPath: String = "/Library/Application Support/HarlemShake/"
        let audioName: String = "HarlemShake.mp3"
        let audioPath = FileManager.default.fileExists(atPath: basicPath + audioName) ? (basicPath) : ("/var/jb\(basicPath)")
        
        return URL(fileURLWithPath: audioPath + audioName)
    }
    
    private var shakingViews: [UIView] = []
    var isShaking: Bool = false
    
    //MARK: - Initializer
    private override init() {
        super.init()
        
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            self.audioPlayer?.delegate = self
            self.audioPlayer?.prepareToPlay()
        } catch let error as NSError {
            remLog(error.localizedDescription)
        }
    }
    
    ///Initialize IPFHarlemShake with a lonerView
    convenience init(lonerView: UIView) {
        self.init()
        self.lonerView = lonerView
    }
    
    deinit {
        self.removeAll()
    }
    
    //MARK: - Functions
    func shake(completion: (() -> Void)? = nil) {
        guard let audioPlayer = self.audioPlayer,
              let lonerView = self.lonerView, !self.isShaking else { return }
        
        self.isShaking = true
        self.shakingViews.removeAll()
        self.completionCallback = completion
        
        // Start playing the harlem shake music track
        audioPlayer.play()
        
        // Shake the lonerView which is the beginning of the Animation
        shakeView(lonerView, with: .IPFShakeStyleStart, randomSeed: CGFloat.random(in: 0.1...1))
        
        // Shake the other views with a delay
        let delay: CGFloat = 15.0
        let popTime = (DispatchTime.now() + delay)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            self.findViewsOfInterestWithCallback { [weak self] view in
                guard let strongSelf = self,
                      let sharedWallpaperController = (SBWallpaperController.sharedInstance() as? SBWallpaperController),
                      let wallpaperView = Ivars<UIWindow>(sharedWallpaperController)._wallpaperWindow.rootViewController?.view else { return }
                let iconAnimationCount: Int = 2
                
                strongSelf.lonerView?.layer.removeAllAnimations()
                strongSelf.shakingViews.append(contentsOf: [view, wallpaperView])
                
                // Shake the wallpaperView with a random animation
                strongSelf.shakeView(wallpaperView, with: IPFShakeStyle.allCases.randomElement() ?? .IPFShakeStyleStart, randomSeed: CGFloat.random(in: 0.1...1))
                
                while (view.layer.animationKeys()?.count ?? 0) < iconAnimationCount {
                    // Shake the view with a bunch of random animations
                    strongSelf.shakeView(view, with: IPFShakeStyle.allCases.randomElement() ?? .IPFShakeStyleStart, randomSeed: CGFloat.random(in: 0.1...1))
                }
            }
        }
    }
    
    private func shakeView(_ view: UIView, with style: IPFShakeStyle, randomSeed seed: CGFloat) {
        switch style {
        case .IPFShakeStyleStart:
            view.layer.add(animationForStyleStart(seed: seed), forKey: "styleStart")
        case .IPFShakeStyleTwo:
            view.layer.add(animationForStyleTwo(seed: seed), forKey: "styleTwo")
        case .IPFShakeStyleThree:
            view.layer.add(animationForStyleThree(seed: seed), forKey: "styleThree")
        }
    }
    
    private func findViewsOfInterestWithCallback(callback: @escaping (UIView) -> Void) {
        guard let lonerView = self.lonerView,
              let sharedCoverSheetVC = (SBLockScreenManager.sharedInstance() as? SBLockScreenManager),
              let coverSheetView = sharedCoverSheetVC.coverSheetViewController.coverSheetView else { return }
        
        var topView: UIView = lonerView
        while let superview = topView.superview {
            topView = superview
        }
        // Identify shakeable views within icons and on the lockscreen
        findViewsOfInterest(in: [topView, coverSheetView], callback: callback)
    }
    
    private func findViewsOfInterest(in views: [UIView], callback: @escaping (UIView) -> Void) {
        for rootView in views {
            for subview in rootView.subviews {
                if (subview.isKind(of: SBIconImageView.self) ||
                    subview.isKind(of: SBHWidgetContainerView.self) ||
                    subview.isKind(of: UILabel.self) ||
                    subview.isKind(of: UIButton.self) ||
                    subview.isKind(of: UIImageView.self) ||
                    subview.isKind(of: UITableViewCell.self) ||
                    subview.isKind(of: UIProgressView.self) ||
                    subview.isKind(of: UITextField.self) ||
                    subview.isKind(of: UITextView.self) ||
                    subview.isKind(of: UISlider.self)) {
                    callback(subview)
                } else if let superview = subview.superview, superview.isKind(of: SBDockView.self) {
                    /*
                     This makes sure, that MobileMeadow-Reborn will not be affected by the HarlemShake
                     because this will break the animations on the MMGroundContainerView (Plants)
                     */
                    for subview in superview.subviews {
                        if subview.isKind(of: SBDockIconListView.self) {
                            for subview in subview.subviews {
                                callback(subview)
                            }
                        }
                    }
                } else {
                    findViewsOfInterest(in: [subview], callback: callback)
                }
            }
        }
    }
    
    func removeAll() {
        self.audioPlayer = nil
        self.shakingViews.forEach({ $0.layer.removeAllAnimations() })
        self.isShaking = false
    }
    
    //MARK: - Animations
    func animationForStyleStart(seed: CGFloat) -> CAAnimation {
        let keyFrameShake = CAKeyframeAnimation(keyPath: "transform.translation")
        let negative: CGFloat = seed < 0.5  ? (1) : (-1)
        
        let offsetOne = Int((10.0 + 20.0 * seed) * negative)
        let offsetTwo = -offsetOne
        let values: [NSValue] = [
            CGSize.zero,
            CGSize(width: offsetOne, height: 0),
            CGSize(width: offsetTwo, height: 0),
            CGSize.zero,
            CGSize(width: 0, height: offsetOne),
            CGSize(width: 0, height: offsetTwo),
            CGSize.zero
        ].map { NSValue(cgSize: $0) }
        
        keyFrameShake.values = values
        keyFrameShake.keyTimes = [0, 0.1, 0.3, 0.4, 0.5, 0.7, 0.8, 1.0] as [NSNumber]
        keyFrameShake.timingFunctions = [
            CAMediaTimingFunction(name: .easeInEaseOut),
            CAMediaTimingFunction(name: .easeInEaseOut),
            CAMediaTimingFunction(name: .easeInEaseOut),
            CAMediaTimingFunction(name: .easeInEaseOut)
        ]
        
        keyFrameShake.duration = 1.0 + seed
        keyFrameShake.repeatCount = .greatestFiniteMagnitude
        keyFrameShake.isRemovedOnCompletion = true
        
        return keyFrameShake
    }
    
    func animationForStyleTwo(seed: CGFloat) -> CAAnimation {
        let keyFrameShake = CAKeyframeAnimation(keyPath: "transform")
        let negative: CGFloat = seed < 0.5  ? (1) : (-1)
        
        let startingScale = CATransform3DIdentity
        let secondScale = CATransform3DScale(CATransform3DIdentity, 1.0 + (seed * negative), 1.0 + (seed * negative), 1.0)
        let thirdScale = CATransform3DScale(CATransform3DIdentity, 1.0 + (seed * -negative), 1.0 + (seed * -negative), 1.0)
        let finalScale = CATransform3DIdentity
        
        keyFrameShake.values = [startingScale, secondScale, thirdScale, finalScale].map { NSValue(caTransform3D: $0) }
        keyFrameShake.keyTimes = [0, 0.4, 0.7, 1.0] as [NSNumber]
        keyFrameShake.timingFunctions = [
            CAMediaTimingFunction(name: .easeOut),
            CAMediaTimingFunction(name: .easeInEaseOut),
            CAMediaTimingFunction(name: .easeInEaseOut)
        ]
        
        keyFrameShake.duration = 1.0 + seed
        keyFrameShake.repeatCount = .greatestFiniteMagnitude
        
        return keyFrameShake
    }
    
    func animationForStyleThree(seed: CGFloat) -> CAAnimation {
        let styleOneGroup = CAAnimationGroup()
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        
        if seed < 0.5 {
            rotate.fromValue = CGFloat.pi * 2
            rotate.toValue = 0
        } else {
            rotate.fromValue = 0
            rotate.toValue = CGFloat.pi * 2
        }
        
        rotate.duration = 1.0 + seed
        
        let pop = CABasicAnimation(keyPath: "transform.scale")
        pop.fromValue = 1.0
        pop.toValue = 1.2
        pop.beginTime = rotate.duration
        pop.duration = 0.5 + seed
        pop.autoreverses = true
        pop.repeatCount = 1
        
        styleOneGroup.repeatCount = .greatestFiniteMagnitude
        styleOneGroup.autoreverses = true
        styleOneGroup.duration = rotate.duration + pop.duration
        styleOneGroup.animations = [rotate, pop]
        
        return styleOneGroup
    }
    
    //MARK: - Delegate (AVAudioPlayer)
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.removeAll()
        self.completionCallback?()
    }
}
