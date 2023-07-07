//
//  ChatToCodeViewController.h
//  MyUtils
//
//  Created by smalltalk on 25/6/2023.
//  Copyright © 2023 wintelsui. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatToCodeViewController : NSViewController

@property (weak) IBOutlet NSSecureTextField *openAiKeyInput;
@property (weak) IBOutlet NSTextField *openAiKeyShow;
@property (weak) IBOutlet NSTextField *openAiKeyTestResult;

@end

NS_ASSUME_NONNULL_END
