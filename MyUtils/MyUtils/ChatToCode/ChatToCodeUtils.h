//
//  ChatToCodeUtils.h
//  MyUtils
//
//  Created by smalltalk on 25/6/2023.
//  Copyright © 2023 wintelsui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatToCodeUtils : NSObject

+ (NSString *)getOpenAiKeyName;
+ (void)setSaveOpenAiKeyName:(NSString *)openAiKey;


+ (void)testOpenKey:(NSString *)openAIKey completion:(void (^)(BOOL succeed, NSDictionary *errorInfo))completion;

@end

NS_ASSUME_NONNULL_END
