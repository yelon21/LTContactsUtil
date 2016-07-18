//
//  LYViewController.m
//  LTContactsUtil
//
//  Created by yelon21 on 07/18/2016.
//  Copyright (c) 2016 yelon21. All rights reserved.
//

#import "LYViewController.h"
#import <LTContactsUtil/LTContactsUIUtil.h>

@interface LYViewController ()

@end

@implementation LYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    LTContactsUIUtil *contactsUIUtil = [[LTContactsUIUtil alloc]init];
    
    contactsUIUtil.telOnlyNumber = YES;
    
    [contactsUIUtil showAddressBookUIFromVC:self
                                       didSelect:^(NSString *name, NSString *tel) {
                                           
                                           NSLog(@"name=%@",name);
                                           NSLog(@"tel=%@",tel);
                                       }];
    
}
@end
