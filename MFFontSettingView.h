//
//  MFFontSettingView.h
//  MFProject
//
//  Created by ywch_mxw on 2019/1/18.
//  Copyright © 2019年 mxw. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LiuXSlider;

typedef void(^valueChangeBlock)(int index);

NS_ASSUME_NONNULL_BEGIN

@interface MFFontSettingView : UIView

@property (nonatomic, strong) LiuXSlider *fontSizeSlider;
-(void)showView;

@end


//
//  LiuXSlider.m
//  LJSlider
//
//  Created by 刘鑫 on 16/3/24.
//  Copyright © 2016年 com.anjubao. All rights reserved.
//

//  git地址：https://github.com/xinge1/LiuXSlider
//
@interface LiuXSlider : UIControl

/**
 *  回调
 */
@property (nonatomic,copy) valueChangeBlock valueChangedBlock;

/**
 *  初始化方法
 *
 *  @param frame frame
 *  @param titleArray         必传，传入节点数组
 *  @param defaultIndex       必传，范围（0到(array.count-1)）
 *  @param sliderImage        传入画块图片
 *
 *  @return view
 */
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray defaultIndex:(CGFloat)defaultIndex sliderImage:(UIImage *)sliderImage;

@end

NS_ASSUME_NONNULL_END
