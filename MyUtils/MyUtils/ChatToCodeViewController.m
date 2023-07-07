//
//  ChatToCodeViewController.m
//  MyUtils
//
//  Created by smalltalk on 25/6/2023.
//  Copyright © 2023 wintelsui. All rights reserved.
//

#import "ChatToCodeViewController.h"

#import "ChatToCodeUtils.h"

@interface ChatToCodeViewController ()
<NSTextFieldDelegate>
@end

@implementation ChatToCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    /*
     @property (weak) IBOutlet NSSecureTextField *openAiKeyInput;
     @property (weak) IBOutlet NSTextField *openAiKeyShow;
     @property (weak) IBOutlet NSTextField *openAiKeyTestResult;
     */
    self.openAiKeyInput.delegate = self;
    self.openAiKeyInput.stringValue = [ChatToCodeUtils getOpenAiKeyName];
    
    [self uploadopenAiKeyShow];
}

- (void)uploadopenAiKeyShow {
    NSString *value = self.openAiKeyInput.stringValue;
    if (value != nil && value.length > 0) {
        if (value.length > 6) {
            self.openAiKeyShow.stringValue = [NSString stringWithFormat:@"%@******%@", [value substringToIndex:3], [value substringFromIndex:(value.length - 3)]];
        }else{
            self.openAiKeyShow.stringValue = @"******";
        }
    }else{
        self.openAiKeyShow.stringValue = @"";
    }
    self.openAiKeyTestResult.stringValue = @"";
}

- (void)controlTextDidChange:(NSNotification *)obj{
    NSLog(@"controlTextDidChange:%@", self.openAiKeyInput.stringValue);
    
    [self uploadopenAiKeyShow];
}

- (IBAction)testOpenAIKeyPressed:(id)sender {
    NSString *value = self.openAiKeyInput.stringValue;
    self.openAiKeyTestResult.stringValue = @"";
    
    if (value != nil && value.length > 0) {
        [ChatToCodeUtils testOpenKey:value completion:^(BOOL succeed, NSDictionary *errorInfo) {
            NSInteger code = [[errorInfo objectForKey:@"code"] integerValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (code == 0) {
                    self.openAiKeyTestResult.stringValue = @"passed";
                }else{
                    self.openAiKeyTestResult.stringValue = @"failed";
                }
            });
        }];
    }
}

- (IBAction)saveOpenAIKeyPressed:(id)sender {
    NSString *value = self.openAiKeyInput.stringValue;
    if (value != nil && value.length > 0) {
        [ChatToCodeUtils setSaveOpenAiKeyName:value];
    }
}

@end
