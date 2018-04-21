//
//  ViewController.m
//  TYRZ
//
//  Created by ths1 on 2018/4/13.
//  Copyright © 2018年 YuQi. All rights reserved.
//

#import "ViewController.h"
#import "HXTYRZManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[HXTYRZManager shareManager] initialize];
    
    [[HXTYRZManager shareManager] preGetPhonenumberSuccess:^{
        
    } failure:^(NSString *des) {
        
    }];
    
    [[HXTYRZManager shareManager] setNavBarBackgroundColor:[UIColor redColor]];
    [[HXTYRZManager shareManager] setNavBarTitle:@"一键登录"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[HXTYRZManager shareManager] getTokenExpWithController:self
                                                    success:(void (^)(NSString *token, NSString *authTypeDes))^{
                                                        
                                                    }
                                                    failure:(void (^)(NSDictionary *context))^{
                                                        
                                                    }];
}
@end
