import Orion
import HarlemShakeRebornC

// HarlemShake-Reborn - You probably thought the Harlem Shake was over, didn't you?
// For modern iOS 14.0 - 16.7.10
// Based on original from @FilippoBiga: https://github.com/FilippoBiga/Harlem-Shake
//MARK: - Variables
var tweakPrefs: SettingsModel = SettingsModel()

//MARK: - Propertys
var harlemShake: IPFHarlemShake?

//MARK: - Initialize Tweak
struct HSWindow: HookGroup {}
struct HarlemShake: Tweak {
    init() {
        remLog("Preferences Loading...")
        tweakPrefs = TweakPreferences.preferences.loadPreferences()
        
        let windowHook: HSWindow = HSWindow()

        switch tweakPrefs.isTweakEnabled {
        case true:
            remLog("Tweak is Enabled! :)")
            windowHook.activate()
        case false:
            remLog("Tweak is Disabled! :(")
            break
        }
    }
}

//MARK: - Hooks
class UIWindowHook: ClassHook<UIWindow> {
    typealias Group = HSWindow
    
    func motionEnded(_ motion: UIEvent.EventSubtype, withEvent event: UIEvent) {
        orig.motionEnded(motion, withEvent: event)
        
        guard let isSreenOn = (SBBacklightController.sharedInstance() as? SBBacklightController)?.screenIsOn, isSreenOn,
              let isShowingHomescreen = (UIApplication.shared as? SpringBoard)?.isShowingHomescreen(), isShowingHomescreen else { return }
        
        if event.type == .motion {
            if !(harlemShake?.isShaking ?? false) {
                startHarlemShake()
            } else {
                /*
                 User has the ability to stop the HarlemShake...
                 This also handles a rare bug where the AVAudioPlayer may fail, causing the animations to loop endlessly without stopping.
                */
                guard let currentVC = target.rootViewController else { return }
                
                let title = "HarlemShake Reborn"
                let message = "HarlemShake is currently playing. Would you like to stop it?"
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive)
                let stopAction = UIAlertAction(title: "Stop", style: .default) { _ in
                    harlemShake?.removeAll()
                    harlemShake = nil
                    remLog("Stopped")
                }
                
                alertController.addAction(stopAction)
                alertController.addAction(dismissAction)
                
                currentVC.present(alertController, animated: true)
            }
        }
    }
    
    //orion:new
    func startHarlemShake() {
        guard let lonerView = getAnimateableLonerView() else { return }
        
        harlemShake = IPFHarlemShake(lonerView: lonerView)
        DispatchQueue.main.async {
            harlemShake?.shake {
                harlemShake = nil
                remLog("Completed")
            }
        }
    }
    
    //orion:new
    func getAnimateableLonerView() -> SBIconView? {
        guard let sharedIconManager = (SBIconController.sharedInstance() as? SBIconController)?.iconManager,
              let iconList = sharedIconManager.currentRootIconList,
              let icons = iconList.icons() as? NSArray,
              let icon: SBIcon = icons.object(at: Int.random(in: 0...(icons.count - 1))) as? SBIcon,
              let lonerView = iconList.iconView(forIcon: icon) as? SBIconView else { return nil }
        
        return lonerView
    }
}
