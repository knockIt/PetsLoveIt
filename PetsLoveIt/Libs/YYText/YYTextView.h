//
//  YYTextView.h
//  YYText <https://github.com/ibireme/YYText>
//
//  Created by ibireme on 15/2/25.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>


#import "YYTextParser.h"
#import "YYTextLayout.h"
#import "YYTextAttribute.h"

@class YYTextView;

/**
 The YYTextViewDelegate protocol defines a set of optional methods you can use
 to receive editing-related messages for YYTextView objects. 
 
 @discussion The API and behavior is similar to UITextViewDelegate,
 see UITextViewDelegate's documentation for more information.
 */
@protocol YYTextViewDelegate <NSObject, UIScrollViewDelegate>
@optional
- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView;
- (BOOL)textViewShouldEndEditing:(YYTextView *)textView;
- (void)textViewDidBeginEditing:(YYTextView *)textView;
- (void)textViewDidEndEditing:(YYTextView *)textView;
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
- (void)textViewDidChange:(YYTextView *)textView;
- (void)textViewDidChangeSelection:(YYTextView *)textView;

- (BOOL)textView:(YYTextView *)textView shouldTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange;
- (void)textView:(YYTextView *)textView didTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect;
- (BOOL)textView:(YYTextView *)textView shouldLongPressHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange;
- (void)textView:(YYTextView *)textView didLongPressHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect;
@end



/**
 The YYTextView class implements the behavior for a scrollable, multiline text region.
 
 @discussion The API and behavior is similar to UITextView, but provides more features:
 
 * It extends the CoreText attributes to support more text effects.
 * It allows to add UIImage, UIView and CALayer as text attachments.
 * It allows to add 'highlight' link to some range of text to allow user interact with.
 * It allows to add exclusion paths to control text container's shape.
 * It supports vertical form layout to display and edit CJK text.
 * It allows user to copy/paste image and attributed text from/to text view.
 * It allows to set an attributed text as placeholder.
 
 See NSAttributedString+YYText.h for more convenience methods to set the attributes.
 See YYTextAttribute.h and YYTextLayout.h for more information.
 */
@interface YYTextView : UIScrollView <UITextInput>


#pragma mark - Accessing the Delegate
///=============================================================================
/// @name Accessing the Delegate
///=============================================================================

@property (nonatomic, weak) id<YYTextViewDelegate> delegate;


#pragma mark - Configuring the Text Attributes
///=============================================================================
/// @name Configuring the Text Attributes
///=============================================================================

/**
 The text displayed by the text view.
 Set a new value to this property also replaces the text in `attributedText`.
 Get the value returns the plain text in `attributedText`.
 */
@property (nonatomic, copy) NSString *text;

/**
 The font of the text. Default is 12-point system font.
 Set a new value to this property also causes the new font to be applied to the entire `attributedText`.
 Get the value returns the font at the head of `attributedText`.
 */
@property (nonatomic, strong) UIFont *font;

/**
 The color of the text. Default is black.
 Set a new value to this property also causes the new color to be applied to the entire `attributedText`.
 Get the value returns the color at the head of `attributedText`.
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 The technique to use for aligning the text. Default is NSLeftTextAlignment.
 Set a new value to this property also causes the new alignment to be applied to the entire `attributedText`.
 Get the value returns the alignment at the head of `attributedText`.
 */
@property (nonatomic, assign) NSTextAlignment textAlignment;

/**
 The text vertical aligmnent in container. Default is YYTextVerticalAlignmentTop.
 */
@property (nonatomic, assign) YYTextVerticalAlignment textVerticalAlignment;

/**
 The types of data converted to clickable URLs in the text view. Default is UIDataDetectorTypeNone.
 The tap or long press action should be handled by delegate.
 */
@property (nonatomic, assign) UIDataDetectorTypes dataDetectorTypes;

/**
 The attributes to apply to links at normal state. Default is light blue color.
 When a range of text is detected by the `dataDetectorTypes`, this value would be
 used to modify the original attributes in the range.
 */
@property (nonatomic, copy) NSDictionary *linkTextAttributes;

/**
 The attributes to apply to links at highlight state. Default is a gray border.
 When a range of text is detected by the `dataDetectorTypes` and the range was touched by user,
 this value would be used to modify the original attributes in the range.
 */
@property (nonatomic, copy) NSDictionary *highlightTextAttributes;

/**
 The attributes to apply to new text being entered by the user.
 When the text view's selection changes, this value is reset automatically.
 */
@property (nonatomic, copy) NSDictionary *typingAttributes;

/**
 The styled text displayed by the text view.
 Set a new value to this property also replaces the value of the `text`, `font`, `textColor`,
 `textAlignment` and other properties in text view.
 
 @discussion It only support the attributes declared in CoreText and YYTextAttribute.
 See `NSAttributedString+YYText` for more convenience methods to set the attributes.
 */
@property (nonatomic, copy) NSAttributedString *attributedText;

/**
 When `text` or `attributedText` is changed, the parser will be called to modify the text.
 It can be used to add code highlighting or emoticon replacement to text view.
 The default value is nil.
 
 See `YYTextParser` protocol for more information.
 */
@property (nonatomic, strong) id<YYTextParser> textParser;

/**
 The current text layout in text view (readonly).
 It can be used to query the text layout information.
 */
@property (nonatomic, strong, readonly) YYTextLayout *textLayout;


#pragma mark - Configuring the Placeholder
///=============================================================================
/// @name Configuring the Placeholder
///=============================================================================

/**
 The placeholder text displayed by the text view (when the text view is empty).
 Set a new value to this property also replaces the text in `placeholderAttributedText`.
 Get the value returns the plain text in `placeholderAttributedText`.
 */
@property (nonatomic, copy) NSString *placeholderText;

/**
 The font of the placeholder text. Default is same as `font` property.
 Set a new value to this property also causes the new font to be applied to the entire `placeholderAttributedText`.
 Get the value returns the font at the head of `placeholderAttributedText`.
 */
@property (nonatomic, strong) UIFont *placeholderFont;

/**
 The color of the placeholder text. Default is gray.
 Set a new value to this property also causes the new color to be applied to the entire `placeholderAttributedText`.
 Get the value returns the color at the head of `placeholderAttributedText`.
 */
@property (nonatomic, strong) UIColor *placeholderTextColor;

/**
 The styled placeholder text displayed by the text view (when the text view is empty).
 Set a new value to this property also replaces the value of the `placeholderText`, 
 `placeholderFont`, `placeholderTextColor`.
 
 @discussion It only support the attributes declared in CoreText and YYTextAttribute.
 See `NSAttributedString+YYText` for more convenience methods to set the attributes.
 */
@property (nonatomic, copy) NSAttributedString *placeholderAttributedText;


#pragma mark - Configuring the Text Container
///=============================================================================
/// @name Configuring the Text Container
///=============================================================================

/**
 The inset of the text container's layout area within the text view's content area.
 */
@property (nonatomic, assign) UIEdgeInsets textContainerInset;

/**
 An array of UIBezierPath objects representing the exclusion paths inside the 
 receiver's bounding rectangle. Default value is nil.
 */
@property (nonatomic, copy) NSArray *exclusionPaths;

/**
 Whether the receiver's layout orientation is vertical form. Default is NO.
 It may used to edit/display CJK text.
 */
@property (nonatomic, assign, getter=isVerticalForm) BOOL verticalForm;

/**
 The text line position modifier used to modify the lines' position in layout.
 See `YYTextLinePositionModifier` protocol for more information.
 */
@property (nonatomic, copy) id<YYTextLinePositionModifier> linePositionModifier;

/**
 The debug option to display CoreText layout result.
 The default value is [YYTextDebugOption sharedDebugOption].
 */
@property (nonatomic, copy) YYTextDebugOption *debugOption;


#pragma mark - Working with the Selection and Menu
///=============================================================================
/// @name Working with the Selection and Menu
///=============================================================================

/**
 Scrolls the receiver until the text in the specified range is visible.
 */
- (void)scrollRangeToVisible:(NSRange)range;

/**
 The current selection range of the receiver.
 */
@property (nonatomic, assign) NSRange selectedRange;

/**
 A Boolean value indicating whether inserting text replaces the previous contents.
 The default value is NO.
 */
@property (nonatomic, assign) BOOL clearsOnInsertion;

/**
 A Boolean value indicating whether the receiver is selectable. Default is YES.
 When the value of this property is NO, user cannot select content or edit text.
 */
@property (nonatomic, getter=isSelectable) BOOL selectable;

/**
 A Boolean value indicating whether the receiver is highlightable. Default is YES.
 When the value of this property is NO, user cannot interact with the highlight range of text.
 */
@property (nonatomic, getter=isHighlightable) BOOL highlightable;

/**
 A Boolean value indicating whether the receiver is editable. Default is YES.
 When the value of this property is NO, user cannot edit text.
 */
@property (nonatomic, getter=isEditable) BOOL editable;

/**
 A Boolean value indicating whether the receiver can paste image from pasteboard. Default is NO.
 When the value of this property is YES, user can paste image from pasteboard via "paste" menu.
 */
@property (nonatomic, assign) BOOL allowsPasteImage;

/**
 A Boolean value indicating whether the receiver can paste attributed text from pasteboard. Default is NO.
 When the value of this property is YES, user can paste attributed text from pasteboard via "paste" menu.
 */
@property (nonatomic, assign) BOOL allowsPasteAttributedString;

/**
 A Boolean value indicating whether the receiver can copy attributed text to pasteboard. Default is YES.
 When the value of this property is YES, user can copy attributed text (with attachment image)
 from text view to pasteboard via "copy" menu.
 */
@property (nonatomic, assign) BOOL allowsCopyAttributedString;


#pragma mark - Manage the undo and redo
///=============================================================================
/// @name Manage the undo and redo
///=============================================================================

/**
 A Boolean value indicating whether the receiver can undo and redo typing with
 shake gesture. The default value is YES.
 */
@property (nonatomic, assign) BOOL allowsUndoAndRedo;

/**
 The maximum undo/redo level. The default value is 20.
 */
@property (nonatomic, assign) NSUInteger maximumUndoLevel;


#pragma mark - Replacing the System Input Views
///=============================================================================
/// @name Replacing the System Input Views
///=============================================================================

/**
 The custom input view to display when the text view becomes the first responder.
 It can be used to replace system keyboard.
 
 @discussion If set the value while first responder, it will not take effect until 
 'reloadInputViews' is called.
 */
@property (readwrite, retain) UIView *inputView;

/**
 The custom accessory view to display when the text view becomes the first responder.
 It can be used to add a toolbar at the top of keyboard.
 
 @discussion If set the value while first responder, it will not take effect until
 'reloadInputViews' is called.
 */
@property (readwrite, retain) UIView *inputAccessoryView;

/**
 If you use an custom accessory view without "inputAccessoryView" property,
 you may set the accessory view's height. It may used by auto scroll calculation.
 */
@property (nonatomic, assign) CGFloat extraAccessoryViewHeight;

@end


// Notifications, see UITextView's documentation for more information.
UIKIT_EXTERN NSString *const YYTextViewTextDidBeginEditingNotification;
UIKIT_EXTERN NSString *const YYTextViewTextDidChangeNotification;
UIKIT_EXTERN NSString *const YYTextViewTextDidEndEditingNotification;
