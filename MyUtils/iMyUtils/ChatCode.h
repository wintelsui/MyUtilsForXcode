//
//  ChatCode.h
//  MyUtils
//
//  Created by smalltalk on 16/3/2021.
//  Copyright © 2021 wintelsui. All rights reserved.
//

#import <XcodeKit/XcodeKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * _Nonnull const idChatCodeToFirst;

@interface ChatCode : NSObject

+ (void)chatCode:(XCSourceEditorCommandInvocation *)invocation index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
