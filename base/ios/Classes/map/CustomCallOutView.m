//
//  CustomCallOutView.m
//  amap_base
//
//  Created by kennen on 2019/4/19.
//

#import "CustomCallOutView.h"
#import "UnifiedAssets.h"

#define ssRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define ssRGBHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

/// 箭头高度
#define kArrowHeight    (10.f)
#define kRadius         (4.f)

@interface CustomCallOutView ()

/// 背景
@property (nonatomic, strong) UIView *backView;
/// 关闭按钮
//@property (nonatomic, strong) UIButton *closeBtn;
/// 店名
@property (nonatomic, strong) UILabel *storeName;
/// 距离
@property (nonatomic, strong) UILabel *distance;
/// 预约按钮
@property (nonatomic, strong) UIButton *orderBtn;

@end

@implementation CustomCallOutView

- (void)setStoreName:(NSString *)storeName distance:(NSString *)distance {
    self.storeName.text = storeName;
    self.distance.text = distance;
    CGRect oldFrame = self.storeName.frame;
    [self.storeName sizeToFit];
    CGRect newFrame = self.storeName.frame;
    self.storeName.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, newFrame.size.height <= oldFrame.size.height ? newFrame.size.height : oldFrame.size.height);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews {
    [self addSubview:self.backView];
    [self.backView addSubview:self.storeName];
    [self.backView addSubview:self.distance];
    [self.backView addSubview:self.orderBtn];
//    [self addSubview:self.closeBtn];
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 10.f)];
        _backView.layer.cornerRadius = kRadius;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}
/*
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _closeBtn.frame = CGRectMake(0, 0, 24.f, 24.f);
        _closeBtn.center = self.backView.frame.origin;
        _closeBtn.tag = 1001;
        [_closeBtn setImage:[UIImage imageWithContentsOfFile:[UnifiedAssets getDefaultAssetPath:@"images/close_btn.png"]] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}
*/
- (UIButton *)orderBtn {
    if (!_orderBtn) {
        _orderBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _orderBtn.frame = CGRectMake(self.backView.bounds.size.width - 70.f, 0, 70.f, 86.f);
        _orderBtn.backgroundColor = ssRGBHex(0xF3432A);
        [_orderBtn setTitle:@"预约" forState:(UIControlStateNormal)];
        [_orderBtn setTitleColor:UIColor.whiteColor forState:(UIControlStateNormal)];
        _orderBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [_orderBtn addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        _orderBtn.tag = 1000;
    }
    return _orderBtn;
}

- (void)clickBtn:(UIButton *)btn {
    switch (btn.tag) {
        case 1000: {
            if (self.clickOrderBtnBlock) {
                self.clickOrderBtnBlock();
            }
            break;
        }
            /*
        case 1001: {
            if (self.clickCloseBtnBlock) {
                self.clickCloseBtnBlock();
            }
            break;
        }
             */
            
        default:
            break;
    }
}

- (UILabel *)storeName {
    if (!_storeName) {
        _storeName = [[UILabel alloc] initWithFrame:CGRectMake(16.f, 8.f, _backView.bounds.size.width - 16.f * 2 - 70.f, 50.f)];
        _storeName.textColor = ssRGBHex(0x333333);
        _storeName.numberOfLines = 2;
        _storeName.text = @"杭州中策车空间下沙旗舰店";
    }
    return _storeName;
}

- (UILabel *)distance {
    if (!_distance) {
        _distance = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.storeName.frame), CGRectGetMaxY(self.backView.frame) - 8.f - 20.f, CGRectGetWidth(self.storeName.frame), 20.f)];
        _distance.textColor = ssRGBHex(0x666666);
        _distance.text = @"1.7km";
    }
    return _distance;
}

#pragma mark - 绘制

//1.这个是callout背景颜色
- (void)drawRect:(CGRect)rect{
    [self drawInContext:UIGraphicsGetCurrentContext()];
//    self.layer.shadowColor = [UIColor whiteColor].CGColor;
//    self.layer.shadowOpacity = 0.7;
//    self.layer.shadowOffset = CGSizeMake(3.0f, 3.0f);
    
}
//callout填充
- (void)drawInContext:(CGContextRef)context{
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:1.0 alpha:1.0].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
}
//划线路径
- (void)getDrawPath:(CGContextRef)context {
    CGRect rect = self.bounds;
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect) - kArrowHeight;
    
    //箭头
    //左
    CGContextMoveToPoint(context, midX - kArrowHeight / 2.f, maxY);
    //下
    CGContextAddLineToPoint(context, midX, maxY + kArrowHeight);
    //右
    CGContextAddLineToPoint(context, midX + kArrowHeight / 2.f, maxY);
    
    //圆弧
    //右下
    CGContextAddArcToPoint(context, maxX, maxY, maxX, minY, kRadius);
    //右上
    CGContextAddArcToPoint(context, maxX, minY, minX, minY, kRadius);
    //左上
    CGContextAddArcToPoint(context, minX, minY, minX, maxY, kRadius);
    //左下
    CGContextAddArcToPoint(context, minX, maxY, midX, maxY, kRadius);
    
    //封闭
    CGContextClosePath(context);
}

@end
