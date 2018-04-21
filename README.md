# YQTYRZManager
移动一键登录工具类

# 移动一键登录

现在的移动一键登录SDK只有两个主要功能，分别是本机号码校验和获取用户信息功能。

个人理解：前者的作用是验证本次登陆的手机账号是否为手机中插着的手机号。后者的作用是用于登陆。

因此，本次的工具类是基于后者提供的功能开发的。

## 工具类提供的接口

### 业务逻辑相关的接口



```
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
```

调用``-(void)getTokenExpWithController``方法后进入一键登录界面，但是进入的过程是这样的：

会先进入一个获取手机号界面如下图1，然后几秒钟后再跳转到一键登录界面。

![获取手机号](/Users/yuqi/JabberYQ.github.io/source/_posts/%E4%B8%80%E9%94%AE%E7%99%BB%E5%BD%951.PNG)

![跳转](/Users/yuqi/JabberYQ.github.io/source/_posts/%E4%B8%80%E9%94%AE%E7%99%BB%E5%BD%952.PNG)

![一键登录界面](/Users/yuqi/JabberYQ.github.io/source/_posts/%E4%B8%80%E9%94%AE%E7%99%BB%E5%BD%953.PNG)

接下里说一下预取号方法。当在调用``-(void)getTokenExpWithController``方法之前，先调用``-(void)preGetPhonenumberSuccess``方法，会预先获取到本机手机号。因此可以节省下几秒钟的时间。

### 大致解释如何使用该功能

在调用``-(void)preGetPhonenumberSuccess``方法后，用户点击一键登录按钮后，会回调回``token``字段。这个``token``的作用是去获取用户信息的。

在移动的开发文档中，有提供获取用户信息的接口：

![获取用户信息接口](/Users/yuqi/JabberYQ.github.io/source/_posts/%E8%8E%B7%E5%8F%96%E7%94%A8%E6%88%B7%E4%BF%A1%E6%81%AF%E6%8E%A5%E5%8F%A3.png)

该接口所需的参数中有一个``token``参数，返回的数据中有登陆的手机号字段。

因此大致做法是，本地调用一键登录接口，获取``token``参数，再把``token``以及其他相关的参数传给后台，让后台去调用获取用户信息接口，获得手机号后进行比较，如果是同一个，登陆成功，再去数据库中获取用户数据返回给前端。

### UI设置接口

在新的SDK中，移动提供了开发者自定义UI功能。但是当前版本提供的可修改的界面仍不是很多。

移动的接口如下：

```
+ (void)customUIWithParams:(NSDictionary *)customUIParams
               customViews:(void(^)(NSDictionary *customAreaView))customViews;
```

``customUIParams``字典键值对在开发文档中有写。

我对UI自定义功能也进行了二次封装，将这些方法放在了HXTYRZManager的分类中。举例如下：

```
- (void)setNavBarLeftImage:(UIImage *)image; //层级1
- (void)setNavBarBackgroundColor:(UIColor *)color; //层级1
- (void)setNavBarTitle:(NSString *)title; //层级暂定1
```

其中的实现：

```
- (void)setNavBarLeftImage:(UIImage *)image //层级1
{
    if ([self isNil:image]) {
        return;
    }
    [self.customUIParams setObject:image forKey:UAPageNavLeftLogo];
}
```

本质为在工具类中设置字典，跳过外部设置。并且，我在工具类的显示登陆方法实现中，调用了移动的``-(void)customUIWithParams``方法。因此，你需要在调用我的显示登陆接口之前，先设置好UI。

# SDK下载地址
[SDK下载地址](http://dev.10086.cn/)

# 博客地址
[博客地址](http://jabberyq.top/2018/04/21/iOS%E5%AE%9E%E6%88%98%EF%BC%9A%E7%A7%BB%E5%8A%A8%E4%B8%80%E9%94%AE%E7%99%BB%E5%BD%95SDK%E5%B0%81%E8%A3%85/)
