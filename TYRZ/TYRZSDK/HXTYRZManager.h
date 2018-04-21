//
//  HXTYRZManager.h
//  TYRZ
//
//  Created by ths1 on 2018/4/13.
//  Copyright © 2018年 YuQi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HXTYRZManager : NSObject

/**
 单例获取

 @return 单例
 */
+ (instancetype)shareManager;


/**
 初始化参数
 */
- (void)initialize;


/**
 是否为移动
 */
- (BOOL)isCMCC;


/**
 获取Msgid
 */
- (NSString *)TYRZSDKMsgid;

/**
 获取Appid
 */
- (NSString *)TYRZSDKAppid;

/**
 预取号 在显式登录之前的操作，目的为提前获取本机手机号，节省显式登录时间。 手
 机号会缓存五分钟，五分钟之内显式登录可以免 获取资料 步骤

 @param success void
 @param failure des = 失败描述
 */
- (void)preGetPhonenumberSuccess:(void (^)(void))success
                         failure:(void (^)(NSString *des))failure;


/**
 显式登录

 @param vc 展示移动一键登录的控制器
 @param success token = 获得的token authTypeDes = 登录的认证方式 0:其他;1:WiFi下网关鉴权;2:网关鉴权;3:短信上行鉴权;7:短信验证码登录
 @param failure des = 失败描述
 */
- (void)getTokenExpWithController:(UIViewController *)vc
                          success:(void (^)(NSString *token, NSString *authTypeDes))success
                          failure:(void (^)(NSDictionary *context))failure;

@end

@interface HXTYRZManager (UI)
typedef NS_ENUM(NSUInteger, TYRZUAPage) {
    TYRZUABothPage = 0,
    TYRZUAAuthPage = 1, // 一键登录界面
    TYRZUASMSPage = 2, // 短信登录界面
};

- (void)setNavBarLeftImage:(UIImage *)image; //层级1
- (void)setNavBarBackgroundColor:(UIColor *)color; //层级1
- (void)setNavBarTitle:(NSString *)title; //层级暂定1

// UAPage->认证页面（一键登录页面）
// UASMSPage->短信验证页面
- (void)setUAPageNavRightItem:(UIButton *)button page:(TYRZUAPage)page; //层级2 右侧导航按钮
- (void)setUAPageContentLogo:(UIImage *)image; ////层级2 建议尺寸大于80x80 默认中国移动logo 嵌套在UAPage中
- (void)setUAPageContentPhoneNumberBGColor:(UIColor *)color page:(TYRZUAPage)page; //层级2
- (void)setUAPageContentPhoneNumberClearImage:(UIImage *)image; // 层级2 输入框x按钮图标 嵌套在UASMSPage中
- (void)setUAPageContentSMSCodeBGColor:(UIColor *)color; //层级2 短信验证输入框底色 嵌套在UASMSPage中
- (void)setUAPageContentAccountSwitchHidden:(BOOL)hidden; //层级2 是否隐藏切换账号按钮 嵌套在UAPage中
- (void)setUAPageContentLoginButtonBGColor:(UIColor *)color page:(TYRZUAPage)page; //层级2 登录按钮底色
- (void)setUAPageContentLoginButtonUnableBGColor:(UIColor *)color; //层级2 登录不可用按钮底色 嵌套在UASMSPage中
- (void)setUAPageContentLoginButtonCornerRadius:(NSNumber *)cornerRadius page:(TYRZUAPage)page; // 层级2 登录按钮圆角
- (void)setUAPageContentLoginButtonTitleFont:(UIFont *)font page:(TYRZUAPage)page; // 层级2 登录按钮字体
- (void)setUAPageContentLoginButtonTitleColor:(UIColor *)color page:(TYRZUAPage)page; // 层级2 登录按钮字体颜色
- (void)setUAPageContentLoginButtonTitle:(NSString *)title page:(TYRZUAPage)page; // 层级1或者2 登录按钮文字
- (void)setUAPageContentSeperatorHidden:(BOOL)hidden; // 层级2 是否隐藏ContentLogo下的分割线
@end
