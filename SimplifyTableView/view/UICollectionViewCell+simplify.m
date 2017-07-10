//
//  UICollectionViewCell+simplify.m
//  SMCore
//
//  Created by 王金东 on 15/12/18.
//  Copyright © 2015年 王金东. All rights reserved.
//

#import "UICollectionViewCell+simplify.h"
#import <objc/runtime.h>

static const void *cViewCellKeyForViewController= &cViewCellKeyForViewController;

@implementation UICollectionViewCell (simplify)

- (void)setDataInfo:(id)dataInfo {

}

- (id)dataInfo {
    return nil;
}
- (void)setViewController:(UIViewController *)viewController {
    objc_setAssociatedObject(self, cViewCellKeyForViewController, viewController, OBJC_ASSOCIATION_ASSIGN);
}
- (UIViewController *)viewController {
    return  objc_getAssociatedObject(self, cViewCellKeyForViewController);
}

@end
