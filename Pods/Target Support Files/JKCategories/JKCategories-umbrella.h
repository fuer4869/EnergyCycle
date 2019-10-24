#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JKCategories.h"
#import "JKCoreData.h"
#import "JKCoreLocation.h"
#import "JKFoundation.h"
#import "JKMapKit.h"
#import "JKQuartzCore.h"
#import "JKUIKit.h"
#import "NSFetchRequest+JKExtensions.h"
#import "NSManagedObject+JKDictionary.h"
#import "NSManagedObject+JKExtensions.h"
#import "NSManagedObjectContext+JKExtensions.h"
#import "NSManagedObjectContext+JKFetching.h"
#import "NSManagedObjectContext+JKFetchRequestsConstructors.h"
#import "NSManagedObjectContext+JKObjectClear.h"
#import "CLLocation+JKCH1903.h"
#import "NSArray+JKBlock.h"
#import "NSArray+JKSafeAccess.h"
#import "NSBundle+JKAppIcon.h"
#import "NSData+JKAPNSToken.h"
#import "NSData+JKBase64.h"
#import "NSData+JKDataCache.h"
#import "NSData+JKEncrypt.h"
#import "NSData+JKGzip.h"
#import "NSData+JKHash.h"
#import "NSData+JKPCM.h"
#import "NSData+JKzlib.h"
#import "NSDate+JKCupertinoYankee.h"
#import "NSDate+JKExtension.h"
#import "NSDate+JKFormatter.h"
#import "NSDate+JKInternetDateTime.h"
#import "NSDate+JKLunarCalendar.h"
#import "NSDate+JKReporting.h"
#import "NSDate+JKUtilities.h"
#import "NSDate+JKZeroDate.h"
#import "NSDateFormatter+JKMake.h"
#import "NSDictionary+JKBlock.h"
#import "NSDictionary+JKJSONString.h"
#import "NSDictionary+JKMerge.h"
#import "NSDictionary+JKSafeAccess.h"
#import "NSDictionary+JKURL.h"
#import "NSDictionary+JKXML.h"
#import "NSException+JKTrace.h"
#import "NSFileHandle+JKReadLine.h"
#import "NSFileManager+JKPaths.h"
#import "NSHTTPCookieStorage+JKFreezeDry.h"
#import "NSIndexPath+JKOffset.h"
#import "NSInvocation+JKBb.h"
#import "NSInvocation+JKBlock.h"
#import "NSNotificationCenter+JKMainThread.h"
#import "NSDecimalNumber+JKCalculatingByString.h"
#import "NSDecimalNumber+JKExtensions.h"
#import "NSNumber+JKCGFloat.h"
#import "NSNumber+JKRomanNumerals.h"
#import "NSNumber+JKRound.h"
#import "NSObject+JKAddProperty.h"
#import "NSObject+JKAppInfo.h"
#import "NSObject+JKAssociatedObject.h"
#import "NSObject+JKAutoCoding.h"
#import "NSObject+JKBlocks.h"
#import "NSObject+JKBlockTimer.h"
#import "NSObject+JKEasyCopy.h"
#import "NSObject+JKGCD.h"
#import "NSObject+JKKVOBlocks.h"
#import "NSObject+JKReflection.h"
#import "NSObject+JKRuntime.h"
#import "NSRunLoop+JKPerformBlock.h"
#import "NSSet+JKBlock.h"
#import "NSString+JKBase64.h"
#import "NSString+JKContains.h"
#import "NSString+JKDictionaryValue.h"
#import "NSString+JKEmoji.h"
#import "NSString+JKEncrypt.h"
#import "NSString+JKHash.h"
#import "NSString+JKHTML.h"
#import "NSString+JKMatcher.h"
#import "NSString+JKMIME.h"
#import "NSString+JKNormalRegex.h"
#import "NSString+JKPinyin.h"
#import "NSString+JKRemoveEmoji.h"
#import "NSString+JKScore.h"
#import "NSString+JKSize.h"
#import "NSString+JKStringPages.h"
#import "NSString+JKTrims.h"
#import "NSString+JKURLEncode.h"
#import "NSString+JKUUID.h"
#import "NSString+JKXMLDictionary.h"
#import "NSTimer+JKAddition.h"
#import "NSTimer+JKBlocks.h"
#import "NSURL+JKParam.h"
#import "NSURL+JKQueryDictionary.h"
#import "NSURLConnection+JKSelfSigned.h"
#import "NSMutableURLRequest+JKUpload.h"
#import "NSURLRequest+JKParamsFromDictionary.h"
#import "NSURLSession+JKSynchronousTask.h"
#import "NSUserDefaults+JKiCloudSync.h"
#import "NSUserDefaults+JKSafeAccess.h"
#import "MKMapView+JKBetterMaps.h"
#import "MKMapView+JKMoveLogo.h"
#import "MKMapView+JKZoomLevel.h"
#import "CAAnimation+JKEasingEquations.h"
#import "CALayer+JKBorderColor.h"
#import "CAMediaTimingFunction+JKAdditionalEquations.h"
#import "CAShapeLayer+JKUIBezierPath.h"
#import "CATransaction+JKAnimateWithDuration.h"
#import "UIAlertView+JKBlock.h"
#import "UIApplication+JKApplicationSize.h"
#import "UIApplication+JKKeyboardFrame.h"
#import "UIApplication+JKNetworkActivityIndicator.h"
#import "UIApplication+JKPermissions.h"
#import "UIBarButtonItem+JKAction.h"
#import "UIBarButtonItem+JKBadge.h"
#import "UIBezierPath+JKBasicShapes.h"
#import "UIBezierPath+JKLength.h"
#import "UIBezierPath+JKSVGString.h"
#import "UIBezierPath+JKSymbol.h"
#import "UIBezierPath+JKThroughPointsBezier.h"
#import "UIButton+JKBackgroundColor.h"
#import "UIButton+JKBadge.h"
#import "UIButton+JKBlock.h"
#import "UIButton+JKCountDown.h"
#import "UIButton+JKImagePosition.h"
#import "UIButton+JKIndicator.h"
#import "UIButton+JKMiddleAligning.h"
#import "UIButton+JKSubmitting.h"
#import "UIButton+JKTouchAreaInsets.h"
#import "UIColor+JKGradient.h"
#import "UIColor+JKHEX.h"
#import "UIColor+JKModify.h"
#import "UIColor+JKRandom.h"
#import "UIColor+JKWeb.h"
#import "UIControl+JKActionBlocks.h"
#import "UIControl+JKBlock.h"
#import "UIControl+JKSound.h"
#import "UIDevice+JKHardware.h"
#import "UIDevice+JKPasscodeStatus.h"
#import "UIFont+JKCustomLoader.h"
#import "UIFont+JKDynamicFontControl.h"
#import "UIFont+JKTTF.h"
#import "UIImage+JKAlpha.h"
#import "UIImage+JKAnimatedGIF.h"
#import "UIImage+JKBetterFace.h"
#import "UIImage+JKBlur.h"
#import "UIImage+JKCapture.h"
#import "UIImage+JKColor.h"
#import "UIImage+JKFileName.h"
#import "UIImage+JKFXImage.h"
#import "UIImage+JKGIF.h"
#import "UIImage+JKMerge.h"
#import "UIImage+JKOrientation.h"
#import "UIImage+JKRemoteSize.h"
#import "UIImage+JKResize.h"
#import "UIImage+JKRoundedCorner.h"
#import "UIImage+JKSuperCompress.h"
#import "UIImage+JKVector.h"
#import "UIImageView+JKAddition.h"
#import "UIImageView+JKBetterFace.h"
#import "UIImageView+JKFaceAwareFill.h"
#import "UIImageView+JKGeometryConversion.h"
#import "UIImageView+JKLetters.h"
#import "UIImageView+JKReflect.h"
#import "UILabel+JKAdjustableLabel.h"
#import "UILabel+JKAutomaticWriting.h"
#import "UILabel+JKAutoSize.h"
#import "UILabel+JKSuggestSize.h"
#import "UINavigationBar+JKAwesome.h"
#import "UINavigationController+JKKeyboardFix.h"
#import "UINavigationController+JKStackManager.h"
#import "UINavigationController+JKTransitions.h"
#import "UINavigationItem+JKLoading.h"
#import "UINavigationItem+JKLock.h"
#import "UINavigationItem+JKMargin.h"
#import "UIPopoverController+iPhone.h"
#import "UIResponder+JKChain.h"
#import "UIResponder+JKFirstResponder.h"
#import "UIScreen+JKFrame.h"
#import "UIScrollView+JKAddition.h"
#import "UIScrollView+JKPages.h"
#import "UISearchBar+JKBlocks.h"
#import "UISplitViewController+JKQuickAccess.h"
#import "UITableView+JKiOS7Style.h"
#import "UITableViewCell+JKDelaysContentTouches.h"
#import "UITableViewCell+JKNIB.h"
#import "UITextField+JKBlocks.h"
#import "UITextField+JKHistory.h"
#import "UITextField+JKInputLimit.h"
#import "UITextField+JKSelect.h"
#import "UITextField+JKShake.h"
#import "UITextView+JKInputLimit.h"
#import "UITextView+JKPinchZoom.h"
#import "UITextView+JKPlaceHolder.h"
#import "UITextView+JKSelect.h"
#import "UIView+JKAnimation.h"
#import "UIView+JKBlockGesture.h"
#import "UIView+JKConstraints.h"
#import "UIView+JKCustomBorder.h"
#import "UIView+JKDraggable.h"
#import "UIView+JKFind.h"
#import "UIView+JKFrame.h"
#import "UIView+JKNib.h"
#import "UIView+JKRecursion.h"
#import "UIView+JKScreenshot.h"
#import "UIView+JKShake.h"
#import "UIView+JKToast.h"
#import "UIView+JKVisuals.h"
#import "UIViewController+JKBackButtonItemTitle.h"
#import "UIViewController+JKBackButtonTouched.h"
#import "UIViewController+JKBlockSegue.h"
#import "UIViewController+JKRecursiveDescription.h"
#import "UIViewController+JKStoreKit.h"
#import "UIViewController+JKVisible.h"
#import "UIWebView+JKBlocks.h"
#import "UIWebView+JKCanvas.h"
#import "UIWebView+JKJavaScript.h"
#import "UIWebView+JKLoad.h"
#import "UIWebView+JKLoadInfo.h"
#import "UIWebView+JKMetaParser.h"
#import "UIWebView+JKStyle.h"
#import "UIWebVIew+JKSwipeGesture.h"
#import "UIWebView+JKWebStorage.h"
#import "UIWindow+JKHierarchy.h"

FOUNDATION_EXPORT double JKCategoriesVersionNumber;
FOUNDATION_EXPORT const unsigned char JKCategoriesVersionString[];

