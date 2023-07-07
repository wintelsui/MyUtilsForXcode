//
//  ChatCode.m
//  MyUtils
//
//  Created by smalltalk on 16/3/2021.
//  Copyright © 2021 wintelsui. All rights reserved.
//

#import "ChatCode.h"
#import "XTranslationEngine.h"

NSString * const idChatCodeToFirst = @"ChatToCode";

@implementation ChatCode

+ (void)chatCode:(XCSourceEditorCommandInvocation *)invocation index:(NSInteger)index{
    NSMutableString *selectString = [[NSMutableString alloc] init];
    NSInteger endLine = 0;
    NSInteger startLine = 0;
    NSInteger startColumn = 0;
    NSInteger endColumn = 0;
    
    for (XCSourceTextRange *range in invocation.buffer.selections) {
        startLine = range.start.line;
        startColumn = range.start.column;
        endLine = range.end.line;
        endColumn = range.end.column;
        
        
        for (NSInteger index = startLine; index <= endLine ;index ++){
            NSString *line = invocation.buffer.lines[index];
            if (line == nil) {
                line = @"";
            }
            
            if (index == endLine && line.length >= endColumn) {
                NSRange lineRange = NSMakeRange(0, endColumn);
                line = [line substringWithRange:lineRange];
            }
            if (index == startLine && line.length > startColumn) {
                NSRange lineRange = NSMakeRange(startColumn, line.length - startColumn);
                line = [line substringWithRange:lineRange];
            }
            [selectString appendString:line];
            if (endLine > startLine && index != endLine) {
                [selectString appendString:@"\n"];
            }
        }
    }
    
    if (selectString.length > 0) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *finalStr = @"// 123123";
            
            [invocation.buffer.lines insertObject:finalStr atIndex:endLine + 1];
//        });
    }
}

@end
