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
        
        if event.type == .motion, !(harlemShake?.isShaking ?? false) {
            if let lonerView = getAnimateableLonerView() {
                harlemShake = IPFHarlemShake(lonerView: lonerView)
                DispatchQueue.main.async {
                    harlemShake?.shake {
                        harlemShake = nil
                        remLog("Completed")
                    }
                }
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
