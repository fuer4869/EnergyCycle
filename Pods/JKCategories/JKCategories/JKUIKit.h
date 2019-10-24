//
//  JKUIKit.h
//  JKCategories
//
//  Created by Jakey on 16/5/29.
//  Copyright © 2016年 www.skyfox.org. All rights reserved.
//
#if __has_include(<JKCategories/JKUIKit.h>)
#import <JKCategories/UIAlertView+JKBlock.h>
#import <JKCategories/UIApplication+JKApplicationSize.h>
#import <JKCategories/UIApplication+JKKeyboardFrame.h>
#import <JKCategories/UIApplication+JKNetworkActivityIndicator.h>
#import <JKCategories/UIApplication+JKPermissions.h>
#import <JKCategories/UIBarButtonItem+JKAction.h>
#import <JKCategories/UIBarButtonItem+JKBadge.h>
#import <JKCategories/UIBezierPath+JKBasicShapes.h>
#import <JKCategories/UIBezierPath+JKLength.h>
#import <JKCategories/UIBezierPath+JKSVGString.h>
#import <JKCategories/UIBezierPath+JKSymbol.h>
#import <JKCategories/UIBezierPath+JKThroughPointsBezier.h>
#import <JKCategories/UIButton+JKBackgroundColor.h>
#import <JKCategories/UIButton+JKBlock.h>
#import <JKCategories/UIButton+JKCountDown.h>
#import <JKCategories/UIButton+JKImagePosition.h>
#import <JKCategories/UIButton+JKIndicator.h>
#import <JKCategories/UIButton+JKMiddleAligning.h>
#import <JKCategories/UIButton+JKSubmitting.h>
#import <JKCategories/UIButton+JKTouchAreaInsets.h>
#import <JKCategories/UIButton+JKBadge.h>
#import <JKCategories/UIColor+JKGradient.h>
#import <JKCategories/UIColor+JKHEX.h>
#import <JKCategories/UIColor+JKModify.h>
#import <JKCategories/UIColor+JKRandom.h>
#import <JKCategories/UIColor+JKWeb.h>
#import <JKCategories/UIControl+JKActionBlocks.h>
#import <JKCategories/UIControl+JKBlock.h>
#import <JKCategories/UIControl+JKSound.h>
#import <JKCategories/UIDevice+JKHardware.h>
#import <JKCategories/UIFont+JKCustomLoader.h>
#import <JKCategories/UIFont+JKDynamicFontControl.h>
#import <JKCategories/UIFont+JKTTF.h>
#import <JKCategories/UIImage+JKAlpha.h>
#import <JKCategories/UIImage+JKAnimatedGIF.h>
#import <JKCategories/UIImage+JKBetterFace.h>
#import <JKCategories/UIImage+JKBlur.h>
#import <JKCategories/UIImage+JKCapture.h>
#import <JKCategories/UIImage+JKColor.h>
#import <JKCategories/UIImage+JKFileName.h>
#import <JKCategories/UIImage+JKFXImage.h>
#import <JKCategories/UIImage+JKGIF.h>
#import <JKCategories/UIImage+JKMerge.h>
#import <JKCategories/UIImage+JKOrientation.h>
#import <JKCategories/UIImage+JKRemoteSize.h>
#import <JKCategories/UIImage+JKResize.h>
#import <JKCategories/UIImage+JKRoundedCorner.h>
#import <JKCategories/UIImage+JKSuperCompress.h>
#import <JKCategories/UIImage+JKVector.h>
#import <JKCategories/UIImageView+JKAddition.h>
#import <JKCategories/UIImageView+JKBetterFace.h>
#import <JKCategories/UIImageView+JKFaceAwareFill.h>
#import <JKCategories/UIImageView+JKGeometryConversion.h>
#import <JKCategories/UIImageView+JKLetters.h>
#import <JKCategories/UIImageView+JKReflect.h>
#import <JKCategories/UILabel+JKAdjustableLabel.h>
#import <JKCategories/UILabel+JKAutomaticWriting.h>
#import <JKCategories/UILabel+JKAutoSize.h>
#import <JKCategories/UILabel+JKSuggestSize.h>
#import <JKCategories/UINavigationBar+JKAwesome.h>
#import <JKCategories/UINavigationController+JKKeyboardFix.h>
#import <JKCategories/UINavigationController+JKStackManager.h>
#import <JKCategories/UINavigationController+JKTransitions.h>
#import <JKCategories/UINavigationItem+JKLoading.h>
#import <JKCategories/UINavigationItem+JKLock.h>
#import <JKCategories/UINavigationItem+JKMargin.h>
#import <JKCategories/UIPopoverController+iPhone.h>
#import <JKCategories/UIResponder+JKChain.h>
#import <JKCategories/UIResponder+JKFirstResponder.h>
#import <JKCategories/UIScreen+JKFrame.h>
#import <JKCategories/UIScrollView+JKAddition.h>
#import <JKCategories/UIScrollView+JKPages.h>
#import <JKCategories/UISearchBar+JKBlocks.h>
#import <JKCategories/UISplitViewController+JKQuickAccess.h>
#import <JKCategories/UITableView+JKiOS7Style.h>
#import <JKCategories/UITableViewCell+JKDelaysContentTouches.h>
#import <JKCategories/UITableViewCell+JKNIB.h>
#import <JKCategories/UITextField+JKBlocks.h>
#import <JKCategories/UITextField+JKHistory.h>
#import <JKCategories/UITextField+JKSelect.h>
#import <JKCategories/UITextField+JKShake.h>
#import <JKCategories/UITextField+JKInputLimit.h>
#import <JKCategories/UITextView+JKPinchZoom.h>
#import <JKCategories/UITextView+JKPlaceHolder.h>
#import <JKCategories/UITextView+JKSelect.h>
#import <JKCategories/UITextView+JKInputLimit.h>
#import <JKCategories/UIView+JKAnimation.h>
#import <JKCategories/UIView+JKBlockGesture.h>
#import <JKCategories/UIView+JKConstraints.h>
#import <JKCategories/UIView+JKCustomBorder.h>
#import <JKCategories/UIView+JKDraggable.h>
#import <JKCategories/UIView+JKFind.h>
#import <JKCategories/UIView+JKFrame.h>
#import <JKCategories/UIView+JKNib.h>
#import <JKCategories/UIView+JKRecursion.h>
#import <JKCategories/UIView+JKScreenshot.h>
#import <JKCategories/UIView+JKShake.h>
#import <JKCategories/UIView+JKToast.h>
#import <JKCategories/UIView+JKVisuals.h>
#import <JKCategories/UIViewController+JKBackButtonItemTitle.h>
#import <JKCategories/UIViewController+JKBackButtonTouched.h>
#import <JKCategories/UIViewController+JKBlockSegue.h>
#import <JKCategories/UIViewController+JKRecursiveDescription.h>
#import <JKCategories/UIViewController+JKStoreKit.h>
#import <JKCategories/UIViewController+JKVisible.h>
#import <JKCategories/UIWebView+JKBlocks.h>
#import <JKCategories/UIWebView+JKCanvas.h>
#import <JKCategories/UIWebView+JKJavaScript.h>
#import <JKCategories/UIWebView+JKLoad.h>
#import <JKCategories/UIWebView+JKMetaParser.h>
#import <JKCategories/UIWebView+JKStyle.h>
#import <JKCategories/UIWebVIew+JKSwipeGesture.h>
#import <JKCategories/UIWebView+JKLoadInfo.h>
#import <JKCategories/UIWebView+JKWebStorage.h>
#import <JKCategories/UIWindow+JKHierarchy.h>
#else
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
#import "UIButton+JKBlock.h"
#import "UIButton+JKCountDown.h"
#import "UIButton+JKImagePosition.h"
#import "UIButton+JKIndicator.h"
#import "UIButton+JKMiddleAligning.h"
#import "UIButton+JKSubmitting.h"
#import "UIButton+JKTouchAreaInsets.h"
#import "UIButton+JKBadge.h"
#import "UIColor+JKGradient.h"
#import "UIColor+JKHEX.h"
#import "UIColor+JKModify.h"
#import "UIColor+JKRandom.h"
#import "UIColor+JKWeb.h"
#import "UIControl+JKActionBlocks.h"
#import "UIControl+JKBlock.h"
#import "UIControl+JKSound.h"
#import "UIDevice+JKHardware.h"
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
#import "UITextField+JKSelect.h"
#import "UITextField+JKShake.h"
#import "UITextField+JKInputLimit.h"
#import "UITextView+JKPinchZoom.h"
#import "UITextView+JKPlaceHolder.h"
#import "UITextView+JKSelect.h"
#import "UITextView+JKInputLimit.h"
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
#import "UIWebView+JKMetaParser.h"
#import "UIWebView+JKStyle.h"
#import "UIWebVIew+JKSwipeGesture.h"
#import "UIWebView+JKLoadInfo.h"
#import "UIWebView+JKWebStorage.h"
#import "UIWindow+JKHierarchy.h"
#endif

