//
//  MainHelper.m
//  PMR
//
//  Created by Shinsoft on 16/10/26.
//  Copyright © 2016年 Shinsoft. All rights reserved.
//

#import "MainHelper.h"

@implementation MainHelper

+ (void)launchMailAppWithContent:(NSString *)content subject:(NSString *)subject
{
    NSMutableString *mailUrl = [[NSMutableString alloc] init];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"jenny.lu@medtronic.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    
    //参数
    [mailUrl appendFormat:@"?"];
    
    //添加抄送
    //    NSArray *ccRecipients = [NSArray arrayWithObjects:@"jian.wang@shinsoft.net", @"qin.hu@shinsoft.net", nil];
    //    [mailUrl appendFormat:@"cc=%@", [ccRecipients componentsJoinedByString:@","]];
    //    //添加密送
    //    NSArray *bccRecipients = [NSArray arrayWithObjects:@"chenxi.shi@shinsoft.net", nil];
    //    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    //添加主题
    [mailUrl appendString:[NSString stringWithFormat:@"&subject=%@",subject]];
    //添加邮件内容
    [mailUrl appendString:[NSString stringWithFormat:@"&body=%@",content]];
    NSString* email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
    
}

@end
