//
//  ChatToCodeUtils.m
//  MyUtils
//
//  Created by smalltalk on 25/6/2023.
//  Copyright © 2023 wintelsui. All rights reserved.
//

#import "ChatToCodeUtils.h"


#define kSaveOpenAiKeyName @"kSaveOpenAiKeyName"

@implementation ChatToCodeUtils



+ (NSString *)getOpenAiKeyName{
    NSString *config = [[[NSUserDefaults alloc] initWithSuiteName:@"group.com.sfs.MyUtils"] stringForKey:kSaveOpenAiKeyName];
    if (config == nil || config.length == 0) {
        config = @"";
    }
    return config;
}

+ (void)setSaveOpenAiKeyName:(NSString *)openAiKey{
    if (openAiKey == nil || openAiKey.length == 0) {
        openAiKey = @"";
    }

    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.sfs.MyUtils"];
    [userDefaults setObject:openAiKey forKey:kSaveOpenAiKeyName];
    [userDefaults synchronize];
}

+ (void)testOpenKey:(NSString *)openAIKey completion:(void (^)(BOOL succeed, NSDictionary *errorInfo))completion{
    
//    NSString *key = [ChatToCodeUtils getOpenAiKeyName];
    if (openAIKey.length > 0) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.openai.com/v1/models"]
           cachePolicy:NSURLRequestUseProtocolCachePolicy
           timeoutInterval:10.0];
        NSDictionary *headers = @{
            @"Authorization": [NSString stringWithFormat:@"Bearer %@", openAIKey]
        };

        [request setAllHTTPHeaderFields:headers];

        [request setHTTPMethod:@"GET"];

        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error) {
              NSLog(@"%@", error);
              dispatch_semaphore_signal(sema);
              
               completion(NO, @{@"code": @(-2), @"message": @"Request Error"});
           } else {
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
              NSError *parseError = nil;
              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
              NSLog(@"%@",responseDictionary);
              dispatch_semaphore_signal(sema);
               
               NSDictionary *dataDic = [responseDictionary objectForKey:@"data"];
               NSDictionary *errorDic = [responseDictionary objectForKey:@"error"];
               
               if (errorDic != nil || dataDic == nil) {
                   NSString *errorMsg;
                   if (errorDic != nil){
                       errorMsg = [errorDic objectForKey:@"message"];
                   }
                   if (errorDic == nil){
                       errorMsg = @"Request Error";
                   }
                   completion(NO, @{@"code": @(-3), @"message": errorMsg});
               }else{
                   completion(YES, @{@"code": @(0), @"message": @"Success"});
               }
               
               /*
                {
                    error =     {
                        code = "invalid_api_key";
                        message = "Incorrect API key provided: 1. You can find your API key at https://platform.openai.com/account/api-keys.";
                        param = "<null>";
                        type = "invalid_request_error";
                    };
                }
                {
                    data =     (
                                {
                            created = 1677532384;
                            id = "whisper-1";
                            object = model;
                            "owned_by" = "openai-internal";
                            parent = "<null>";
                            permission =             (
                                                {
                                    "allow_create_engine" = 0;
                                    "allow_fine_tuning" = 0;
                                    "allow_logprobs" = 1;
                                    "allow_sampling" = 1;
                                    "allow_search_indices" = 0;
                                    "allow_view" = 1;
                                    created = 1683912666;
                                    group = "<null>";
                                    id = "modelperm-KlsZlfft3Gma8pI6A8rTnyjs";
                                    "is_blocking" = 0;
                                    object = "model_permission";
                                    organization = "*";
                                }
                            );
                            root = "whisper-1";
                        }
                    );
                    object = list;
                }

                */
           }
        }];
        [dataTask resume];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        completion(NO, @{@"code": @(-1), @"message": @"OpenAIKey is Empty"});
    }
}

- (void)chat:(NSString *)messages completion:(void (^)(BOOL succeed, NSDictionary *errorInfo))completion{
    if (messages == nil || messages.length == 0) {
        completion(NO, @{@"code": @(-2), @"message": @"Message is Error"});
        return;
    }
    NSString *openAIKey = [ChatToCodeUtils getOpenAiKeyName];
    if (openAIKey.length > 0) {
        NSDictionary *dataMsg = @{@"model": @"gpt-3.5-turbo",
                                  @"messages": @[@{@"role": @"user", @"content": messages}]};
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataMsg options:NSJSONWritingPrettyPrinted error:&error];
        if (!jsonData) {
            NSLog(@"Error creating JSON data: %@", error.localizedDescription);
            completion(NO, @{@"code": @(-2), @"message": @"Message is Error"});
            
        } else {
            
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);

            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.openai.com/v1/chat/completions"]
               cachePolicy:NSURLRequestUseProtocolCachePolicy
               timeoutInterval:10.0];
            NSDictionary *headers = @{
               @"Accept": @"application/json",
               @"Content-Type": @"application/json",
               @"Authorization": [NSString stringWithFormat:@"Bearer %@", openAIKey]
            };

            [request setAllHTTPHeaderFields:headers];
            
            NSData *postData = [[NSData alloc] initWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPBody:postData];

            [request setHTTPMethod:@"POST"];

            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
               if (error) {
                  NSLog(@"%@", error);
                  dispatch_semaphore_signal(sema);
               } else {
                  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                  NSError *parseError = nil;
                  NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                  NSLog(@"%@",responseDictionary);
                  dispatch_semaphore_signal(sema);
               }
                
                /*
                 {
                     "error": {
                         "message": "You exceeded your current quota, please check your plan and billing details.",
                         "type": "insufficient_quota",
                         "param": null,
                         "code": null
                     }
                 }
                 */
            }];
            [dataTask resume];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
    }else{
        completion(NO, @{@"code": @(-1), @"message": @"OpenAIKey is Empty"});
    }
}

@end
