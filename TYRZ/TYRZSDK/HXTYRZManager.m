//
//  HXTYRZManager.m
//  TYRZ
//
//  Created by ths1 on 2018/4/13.
//  Copyright © 2018年 YuQi. All rights reserved.
//

#import "HXTYRZManager.h"
#import <TYRZSDK/TYRZSDK.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "HXTYRZConst.h"

static NSString *const UAAuthPage = @"UAAuthPage";
static NSString *const UASMSPage = @"UASMSPage";
static NSString *const UAPageNavLeftLogo = @"UAPageNavLeftLogo";
static NSString *const UAPageNavBackgroundColor = @"UAPageNavBackgroundColor";
static NSString *const UAPageNavTitle = @"UAPageNavTitle";
static NSString *const UAPageNavRightItem = @"UAPageNavRightItem";
static NSString *const UAPageContentLogo = @"UAPageContentLogo";
static NSString *const UAPageContentPhoneNumberBGColor = @"UAPageContentPhoneNumberBGColor";
static NSString *const UAPageContentPhoneNumberClearImage = @"UAPageContentPhoneNumberClearImage";
static NSString *const UAPageContentSMSCodeBGColor = @"UAPageContentSMSCodeBGColor";
static NSString *const UAPageContentAccountSwitchHidden = @"UAPageContentAccountSwitchHidden";
static NSString *const UAPageContentLoginButtonBGColor = @"UAPageContentLoginButtonBGColor";
static NSString *const UAPageContentLoginButtonUnableBGColor = @"UAPageContentLoginButtonUnableBGColor";
static NSString *const UAPageContentLoginButtonCornerRadius = @"UAPageContentLoginButtonCornerRadius";
static NSString *const UAPageContentLoginButtonTitleFont = @"UAPageContentLoginButtonTitleFont";
static NSString *const UAPageContentLoginButtonTitleColor = @"UAPageContentLoginButtonTitleColor";
static NSString *const UAPageContentLoginButtonTitle = @"UAPageContentLoginButtonTitle";
static NSString *const UAPageContentSeperatorHidden = @"UAPageContentSeperatorHidden";

@interface HXTYRZManager()
@property (nonatomic, strong) NSMutableDictionary *customUIParams;
@end

@implementation HXTYRZManager
#pragma mark - 单例
+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static HXTYRZManager *manager = nil;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[self alloc] init];
        }
    });
    return manager;
}

#pragma mark - 初始化SDK参数
- (void)initialize
{
    [TYRZUILogin initializeWithAppId:TYRZAppId appKey:TYRZAppKey];
}

#pragma mark - 是否为移动
- (BOOL)isCMCC
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    if (!carrier.isoCountryCode) {
        return NO;
    }
    
    NSString *carrierName = [carrier carrierName];
    if ([carrierName isEqualToString:@"中国移动"]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 获取Msgid
- (NSString *)TYRZSDKMsgid
{
    NSString *msgid = [self uuid];
    return msgid;
}

#pragma mark - 获取Appid
- (NSString *)TYRZSDKAppid
{
    return TYRZAppId;
}

#pragma mark - 预取号
- (void)preGetPhonenumberSuccess:(void (^)(void))success
                         failure:(void (^)(NSString *des))failure
{
    [TYRZUILogin preGetPhonenumber:^(id sender) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *resultCode = sender[TYRZResultCode];
            if ([resultCode isEqualToString:TYRZSuccessCode]) { // 成功
                if (success) {
                    success();
                }
            } else { // 失败
                if (failure) {
                    NSString *desc = sender[TYRZDesc];
                    failure(desc);
                }
            }
        });
    }];
}

#pragma mark - 显式登录
- (void)getTokenExpWithController:(UIViewController *)vc
                          success:(void (^)(NSString *token, NSString *authTypeDes))success
                          failure:(void (^)(NSDictionary *context))failure
{
    // 设置UI
    [TYRZUILogin customUIWithParams:self.customUIParams customViews:^(NSDictionary *customAreaView) {
            
    }];
    
    [TYRZUILogin getTokenExpWithController:vc
                                  complete:^(id sender) {
                                      NSString *resultCode = sender[TYRZResultCode];
                                      if ([resultCode isEqualToString:TYRZSuccessCode]) { // 获取token成功
                                          if (success) {
                                              success(sender[TYRZToken], sender[TYRZAuthTypeDes]);
                                          }
                                      } else { // 失败
                                          if (failure) {
                                              failure(sender);
                                          }
                                      }
                                  }];
}


#pragma mark - private
- (NSString *)uuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    
    return [[uuid lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

- (NSString *)timestamp
{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *result = [formatter stringFromDate:now];
    
    return result;
}

#pragma mark - getter
- (NSMutableDictionary *)customUIParams
{
    if (!_customUIParams) {
        _customUIParams = [NSMutableDictionary dictionary];
        [_customUIParams setObject:[NSMutableDictionary dictionary] forKey:UAAuthPage]; // 授权页面
        [_customUIParams setObject:[NSMutableDictionary dictionary] forKey:UASMSPage]; // 账号短信验证页面
    }
    return _customUIParams;
}
@end


@implementation HXTYRZManager (UI)
- (void)setNavBarLeftImage:(UIImage *)image //层级1
{
    if ([self isNil:image]) {
        return;
    }
    [self.customUIParams setObject:image forKey:UAPageNavLeftLogo];
}

- (void)setNavBarBackgroundColor:(UIColor *)color//层级1
{
    if ([self isNil:color]) {
        return;
    }
    [self.customUIParams setObject:color forKey:UAPageNavBackgroundColor];
}

- (void)setNavBarTitle:(NSString *)title //层级暂定1
{
    if ([self isNil:title]) {
        return;
    }
    [self.customUIParams setObject:title forKey:UAPageNavTitle];
}

// UAPage->认证页面（一键登录页面）
// UASMSPage->短信验证页面
- (void)setUAPageNavRightItem:(UIButton *)button page:(TYRZUAPage)page//层级2
{
    if ([self isNil:button]) {
        return;
    }
    switch (page) {
        case TYRZUABothPage:
        {
            NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
            if (UASMSPageDic) {
                [UASMSPageDic setObject:button forKey:UAPageNavRightItem];
            }
            NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
            if (UAAuthPageDic) {
                [UAAuthPageDic setObject:button forKey:UAPageNavRightItem];
            }
        }
            break;
        case TYRZUAAuthPage:
        {
            NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
            if (UAAuthPageDic) {
                [UAAuthPageDic setObject:button forKey:UAPageNavRightItem];
            }
        }
            break;
        case TYRZUASMSPage:
        {
            NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
            if (UASMSPageDic) {
                [UASMSPageDic setObject:button forKey:UAPageNavRightItem];
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)setUAPageContentLogo:(UIImage *)image //层级2 建议尺寸大于80x80 默认中国移动logo
{
    if ([self isNil:image]) {
        return;
    }
    NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
    if (UAAuthPageDic) {
        [UAAuthPageDic setObject:image forKey:UAPageContentLogo];
    }
}

- (void)setUAPageContentPhoneNumberBGColor:(UIColor *)color page:(TYRZUAPage)page //层级2
{
    if ([self isNil:color]) {
        return;
    }
    switch (page) {
        case TYRZUABothPage:
        {
            NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
            if (UASMSPageDic) {
                [UASMSPageDic setObject:color forKey:UAPageContentPhoneNumberBGColor];
            }
            NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
            if (UAAuthPageDic) {
                [UAAuthPageDic setObject:color forKey:UAPageContentPhoneNumberBGColor];
            }
        }
            break;
        case TYRZUAAuthPage:
        {
            NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
            if (UAAuthPageDic) {
                [UAAuthPageDic setObject:color forKey:UAPageContentPhoneNumberBGColor];
            }
        }
            break;
        case TYRZUASMSPage:
        {
            NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
            if (UASMSPageDic) {
                [UASMSPageDic setObject:color forKey:UAPageContentPhoneNumberBGColor];
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)setUAPageContentPhoneNumberClearImage:(UIImage *)image // 层级2 输入框x按钮图标 嵌套在UASMSPage中
{
    if ([self isNil:image]) {
        return;
    }
    NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
    if (UASMSPageDic) {
        [UASMSPageDic setObject:image forKey:UAPageContentPhoneNumberBGColor];
    }
}

- (void)setUAPageContentSMSCodeBGColor:(UIColor *)color //层级2 短信验证输入框底色 嵌套在UASMSPage中
{
    if ([self isNil:color]) {
        return;
    }
    NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
    if (UASMSPageDic) {
        [UASMSPageDic setObject:color forKey:UAPageContentSMSCodeBGColor];
    }
}

- (void)setUAPageContentAccountSwitchHidden:(BOOL)hidden //层级2 是否隐藏切换账号按钮 嵌套在UAPage中
{
    NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
    if (UAAuthPageDic) {
        [UAAuthPageDic setObject:@(hidden) forKey:UAPageContentAccountSwitchHidden];
    }
}

- (void)setUAPageContentLoginButtonBGColor:(UIColor *)color page:(TYRZUAPage)page //层级2 登录按钮底色
{
    if ([self isNil:color]) {
        return;
    }
    switch (page) {
        case TYRZUABothPage:
        {
            NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
            if (UASMSPageDic) {
                [UASMSPageDic setObject:color forKey:UAPageContentLoginButtonBGColor];
            }
            NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
            if (UAAuthPageDic) {
                [UAAuthPageDic setObject:color forKey:UAPageContentLoginButtonBGColor];
            }
        }
            break;
        case TYRZUAAuthPage:
        {
            NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
            if (UAAuthPageDic) {
                [UAAuthPageDic setObject:color forKey:UAPageContentLoginButtonBGColor];
            }
        }
            break;
        case TYRZUASMSPage:
        {
            NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
            if (UASMSPageDic) {
                [UASMSPageDic setObject:color forKey:UAPageContentLoginButtonBGColor];
            }
        }
            break;
        default:
            break;
    }
}

- (void)setUAPageContentLoginButtonUnableBGColor:(UIColor *)color //层级2 登录不可用时按钮底色 嵌套在UASMSPage中
{
    if ([self isNil:color]) {
        return;
    }
    NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
    if (UASMSPageDic) {
        [UASMSPageDic setObject:color forKey:UAPageContentLoginButtonUnableBGColor];
    }
}

- (void)setUAPageContentLoginButtonCornerRadius:(NSNumber *)cornerRadius page:(TYRZUAPage)page // 层级2 登录按钮圆角
{
    if ([self isNil:cornerRadius]) {
        return;
    }
    switch (page) {
        case TYRZUABothPage:
        {
            NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
            if (UASMSPageDic) {
                [UASMSPageDic setObject:cornerRadius forKey:UAPageContentLoginButtonCornerRadius];
            }
            NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
            if (UAAuthPageDic) {
                [UAAuthPageDic setObject:cornerRadius forKey:UAPageContentLoginButtonCornerRadius];
            }
        }
            break;
        case TYRZUAAuthPage:
        {
            NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
            if (UAAuthPageDic) {
                [UAAuthPageDic setObject:cornerRadius forKey:UAPageContentLoginButtonCornerRadius];
            }
        }
            break;
        case TYRZUASMSPage:
        {
            NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
            if (UASMSPageDic) {
                [UASMSPageDic setObject:cornerRadius forKey:UAPageContentLoginButtonCornerRadius];
            }
        }
            break;
        default:
            break;
    }
}

- (void)setUAPageContentLoginButtonTitleFont:(UIFont *)font page:(TYRZUAPage)page // 层级2 登录按钮字体
{
    if ([self isNil:font]) {
        return;
    }
    switch (page) {
        case TYRZUABothPage:
        {
            NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
            if (UASMSPageDic) {
                [UASMSPageDic setObject:font forKey:UAPageContentLoginButtonTitleFont];
            }
            NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
            if (UAAuthPageDic) {
                [UAAuthPageDic setObject:font forKey:UAPageContentLoginButtonTitleFont];
            }
        }
            break;
        case TYRZUAAuthPage:
        {
            NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
            if (UAAuthPageDic) {
                [UAAuthPageDic setObject:font forKey:UAPageContentLoginButtonTitleFont];
            }
        }
            break;
        case TYRZUASMSPage:
        {
            NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
            if (UASMSPageDic) {
                [UASMSPageDic setObject:font forKey:UAPageContentLoginButtonTitleFont];
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)setUAPageContentLoginButtonTitleColor:(UIColor *)color page:(TYRZUAPage)page // 层级2 登录按钮字体颜色
{
    if ([self isNil:color]) {
        return;
    }
    switch (page) {
        case TYRZUABothPage:
        {
            NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
            if (UASMSPageDic) {
                [UASMSPageDic setObject:color forKey:UAPageContentLoginButtonTitleColor];
            }
            NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
            if (UAAuthPageDic) {
                [UAAuthPageDic setObject:color forKey:UAPageContentLoginButtonTitleColor];
            }
        }
            break;
        case TYRZUAAuthPage:
        {
            NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
            if (UAAuthPageDic) {
                [UAAuthPageDic setObject:color forKey:UAPageContentLoginButtonTitleColor];
            }
        }
            break;
        case TYRZUASMSPage:
        {
            NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
            if (UASMSPageDic) {
                [UASMSPageDic setObject:color forKey:UAPageContentLoginButtonTitleColor];
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)setUAPageContentLoginButtonTitle:(NSString *)title page:(TYRZUAPage)page // 层级1或者2 登录按钮文字
{
    if ([self isNil:title]) {
        return;
    }
    switch (page) {
        case TYRZUABothPage:
        {
            NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
            if (UASMSPageDic) {
                [UASMSPageDic setObject:title forKey:UAPageContentLoginButtonTitle];
            }
            NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
            if (UAAuthPageDic) {
                [UAAuthPageDic setObject:title forKey:UAPageContentLoginButtonTitle];
            }
        }
            break;
        case TYRZUAAuthPage:
        {
            NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
            if (UAAuthPageDic) {
                [UAAuthPageDic setObject:title forKey:UAPageContentLoginButtonTitle];
            }
        }
            break;
        case TYRZUASMSPage:
        {
            NSMutableDictionary *UASMSPageDic = self.customUIParams[UASMSPage];
            if (UASMSPageDic) {
                [UASMSPageDic setObject:title forKey:UAPageContentLoginButtonTitle];
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)setUAPageContentSeperatorHidden:(BOOL)hidden // 层级2 是否隐藏ContentLogo下的分割线
{
    NSMutableDictionary *UAAuthPageDic = self.customUIParams[UAAuthPage];
    if (UAAuthPageDic) {
        [UAAuthPageDic setObject:@(hidden) forKey:UAPageContentSeperatorHidden];
    }
}

- (BOOL)isNil:(id)obj
{
    if (obj != nil) {
        return NO;
    } else {
        return YES;
    }
}
@end
