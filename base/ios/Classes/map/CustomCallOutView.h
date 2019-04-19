//
//  CustomCallOutView.h
//  amap_base
//
//  Created by kennen on 2019/4/19.
//

#import <UIKit/UIKit.h>

typedef void(^RRCallBackBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface CustomCallOutView : UIView

@property (nonatomic, copy) RRCallBackBlock clickCloseBtnBlock;
@property (nonatomic, copy) RRCallBackBlock clickOrderBtnBlock;

- (void)setStoreName:(NSString *)storeName distance:(NSString *)distance;

@end

NS_ASSUME_NONNULL_END
