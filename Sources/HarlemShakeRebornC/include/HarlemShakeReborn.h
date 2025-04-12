#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Springboard/Springboard.h>
#import "RemoteLog.h"

@interface CSCoverSheetView : UIView
@end

@interface CSCoverSheetViewControllerBase : UIViewController
@end

@interface CSCoverSheetViewController : CSCoverSheetViewControllerBase
@property (nonatomic,readonly) CSCoverSheetView *coverSheetView;
@end

@interface SBLockScreenManager : NSObject
@property (nonatomic,readonly) CSCoverSheetViewController *coverSheetViewController;
+(id)sharedInstance;
@end

@interface SBHomeScreenViewController : UIViewController
@end

@interface SBNestingViewController : UIViewController
@end

@interface SBFolderController : SBNestingViewController
@end

@interface SBRootFolderController : SBFolderController
+(id)iconLocation;
@end

@interface SBIconListView : UIView
-(NSArray *)icons;
-(id)iconViewForIcon:(id)arg1 ;
@end

@interface SBHIconManager : NSObject
@property (nonatomic,readonly) SBIconListView *currentRootIconList;
@end

@interface SBIconController : NSObject
@property (nonatomic,readonly) SBHIconManager *iconManager;
+(id)sharedInstance;
@end

@interface SBIcon : NSObject
@end

@interface SBIconView : UIView
@end

@interface SBIconImageView : UIView
@end

@interface SBIconBadgeView : UIView
@end

@interface SBHWidgetContainerView : UIView
@end

@interface SBDockView : UIView
@end

@interface SBDockIconListView : UIView
@end

@interface SBWallpaperController : NSObject {
    UIWindow* _wallpaperWindow;
    UIViewController* _rootWallpaperViewController;
}
+(id)sharedInstance;
@end

@interface SBBacklightController : NSObject
@property (nonatomic,readonly) BOOL screenIsOn;
+(id)sharedInstance;
@end
