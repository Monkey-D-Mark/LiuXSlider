//
//  MFFontSettingView.m
//  MFProject
//
//  Created by ywch_mxw on 2019/1/18.
//  Copyright © 2019年 mxw. All rights reserved.
//

#import "MFFontSettingView.h"

@interface MFFontSettingView ()
@property (nonatomic, strong) UIView *backgroundView;
@end

@implementation MFFontSettingView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self maekupUI];
    }
    return self;
}

-(void)maekupUI{
    CGFloat cornerRadius = 4;
    CGFloat bottomOffset = 15;
    CGFloat margin = 15;
    if ([UIScreen mainScreen].bounds.size.height >= 812) {
        bottomOffset = 34;
    }else{
        bottomOffset = 15;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 2*margin;
    CGFloat height = 174;
    CGFloat viewY = [UIScreen mainScreen].bounds.size.height - height - bottomOffset;
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(margin, viewY, width, height)];
    _backgroundView.tag = 999;
    _backgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:_backgroundView];

    CGFloat buttonHeight = 46;
    CGFloat buttonY = height - buttonHeight;
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, buttonY, width, buttonHeight)];
    cancelButton.layer.cornerRadius = cornerRadius;
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:cancelButton];

    CGFloat assistHeight = 120;
    UIView *assistView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, assistHeight)];
    assistView.layer.cornerRadius = cornerRadius;
    assistView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [_backgroundView addSubview:assistView];

    CGFloat bottomMargin = 44;
    CGFloat iconWidth = 16;
    CGFloat iconHeight = iconWidth;
    CGFloat iconY = assistHeight - bottomMargin - iconHeight;
    CGFloat imageMargin = 20;
    UIImageView *smallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageMargin, iconY, iconWidth, iconHeight)];
    smallImageView.image = [UIImage imageNamed:@"min_icon"];
    [assistView addSubview:smallImageView];

    CGFloat bigImageViewX = width - imageMargin - iconWidth;
    UIImageView *bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(bigImageViewX, iconY, iconWidth, iconHeight)];
    bigImageView.image = [UIImage imageNamed:@"max_icon"];
    [assistView addSubview:bigImageView];

    CGFloat sliderMagin = 47;
    CGFloat sliderWidth = width - sliderMagin * 2;
    CGFloat sliderHeight = 40;
    CGFloat sliderY = assistHeight - sliderHeight - bottomMargin;
    NSArray *titleArray = @[@"小",@"中",@"大",@"特大"];
    UIImage *sliderImage = [UIImage imageNamed:@"font_slider"];
    NSInteger defaultIndex = 1;
    _fontSizeSlider = [[LiuXSlider alloc] initWithFrame:CGRectMake(sliderMagin, sliderY, sliderWidth, sliderHeight) titles:titleArray defaultIndex:defaultIndex sliderImage:sliderImage];
    [assistView addSubview:_fontSizeSlider];
}

- (void)showView{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self addSubview:self.backgroundView];
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
        self.backgroundView.alpha = 1;
    } completion:^(BOOL finished) {

    }];
}

-(void)removeOperateView{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.0;
        self.backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.backgroundView removeFromSuperview];
    }];
}

-(void)hideView {
    [self removeOperateView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hitTestWithTouches:touches withEvent:event];
}

- (void)hitTestWithTouches:(NSSet *)touches withEvent:(UIEvent *)event{
    //1、get touch position
    //获取当前self.view中的坐标系点击point
    CGPoint point = [[touches anyObject] locationInView:self];
    //2、get touched layer
    //获取当前点击layer、利用hitTest
    CALayer *layer = [self.layer hitTest:point];
    //判断layer类型
    if (layer == self.layer){
        [self hideView];
    }else if(layer == self.backgroundView.layer){

    }
}

@end

#define LiuXSliderWidth  (self.bounds.size.width)
#define LiuXSliderHeight  (self.bounds.size.height)

#define LiuXSliderTitleHeight  17
#define LiuXImageWidth  20

#define LiuXSliderLineWidth (LiuXSliderWidth-(LiuXImageWidth *1/4))

#define LiuXSliderLineHeight 1

#define LiuXImageY  (LiuXSliderLineY-(LiuXImageWidth *1/4))

#define LiuXSliderLineY (LiuXSliderHeight-LiuXSliderLineHeight-(LiuXImageWidth *1/4))

@interface LiuXSlider ()
{
    CGFloat _pointX;
    NSInteger _sectionIndex;
    CGFloat _sectionLength;
    UILabel *_selectLab;
}
/**
 *  必传，范围（0到(array.count-1)）
 */
@property (nonatomic,assign)CGFloat defaultIndx;

/**
 *  必传，传入节点数组
 */
@property (nonatomic,strong)NSArray *titleArray;

/**
 *  传入图片
 */
@property (nonatomic,strong)UIImage *sliderImage;
@property (strong,nonatomic)UIView *defaultView;
@property (strong,nonatomic)UIImageView *centerImage;
@end

@implementation LiuXSlider

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray defaultIndex:(CGFloat)defaultIndex sliderImage:(UIImage *)sliderImage{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        _pointX = 0;
        _sectionIndex = 0;

         [self makeupUI];

        self.titleArray = titleArray;
        self.defaultIndx = defaultIndex;
        self.sliderImage = sliderImage;
    }
    return self;
}

-(void)makeupUI{
    CGFloat viewX = LiuXImageWidth/2;
    CGFloat viewWidth = LiuXSliderWidth-LiuXImageWidth;
    _defaultView = [[UIView alloc] initWithFrame:CGRectMake(viewX, LiuXSliderLineY, viewWidth, LiuXSliderLineHeight)];
    _defaultView.backgroundColor = [UIColor blackColor];
    _defaultView.layer.cornerRadius = LiuXSliderLineHeight/2;
    [self addSubview:_defaultView];

    _centerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LiuXImageWidth, LiuXImageWidth)];
    _centerImage.center = CGPointMake(0, LiuXImageY);
    [self addSubview:_centerImage];

    _selectLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    _selectLab.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:153/255.0];
    _selectLab.font = [UIFont systemFontOfSize:12];
    _selectLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_selectLab];

}

- (void)setDefaultIndx:(CGFloat)defaultIndx{
    CGFloat width = defaultIndx / (_titleArray.count -1);

    _pointX = width*LiuXSliderLineWidth;
    _sectionIndex = defaultIndx;
}

- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    CGFloat baseWidth = LiuXSliderWidth-LiuXImageWidth - 1;
    _sectionLength = (baseWidth) / (titleArray.count -1);

    CGFloat startX = _defaultView.frame.origin.x;
    CGFloat startY = _defaultView.frame.origin.y - 8;
    for (NSInteger i=0; i<_titleArray.count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(startX+i*(_sectionLength), startY, 1, 8)];
        view.tag = i+100;
        view.backgroundColor = [UIColor blackColor];
        [self addSubview:view];
    }
}

- (void)setSliderImage:(UIImage *)sliderImage{
    _centerImage.image  = sliderImage;
    [self refreshSlider];
}

#pragma mark ---UIControl Touch
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self changePointX:touch];
    _pointX = _sectionIndex* _sectionLength;
    [self refreshSlider];
    [self labelEnlargeAnimation];
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self changePointX:touch];
    [self refreshSlider];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self changePointX:touch];
    _pointX = _sectionIndex * _sectionLength;
    if (self.valueChangedBlock) {
        self.valueChangedBlock((int)_sectionIndex);
    }
    [self refreshSlider];
    [self labelLessenAnimation];
}

-(void)changePointX:(UITouch *)touch{
    CGPoint point = [touch locationInView:self];
    _pointX = point.x;
    if (point.x < 0) {
        _pointX = LiuXImageWidth/2;
    }else if (point.x > LiuXSliderLineWidth){
        _pointX = LiuXSliderLineWidth + LiuXImageWidth/2;
    }
    _sectionIndex = (int)roundf(_pointX/_sectionLength);
}

-(void)refreshSlider{
    _pointX = _pointX + LiuXImageWidth/2;
    _centerImage.center = CGPointMake(_pointX, LiuXImageY);

    _selectLab.text = [NSString stringWithFormat:@"%@",_titleArray[_sectionIndex]];
    if (_sectionIndex==0) {
        _selectLab.center=CGPointMake(_pointX, 10);
    }else if (_sectionIndex==_titleArray.count-1) {
        _selectLab.center=CGPointMake(_pointX, 10);
    }else{
        _selectLab.center=CGPointMake(_pointX, 7);
    }
    for (UIView *view in self.subviews) {
        [self insertSubview:_centerImage aboveSubview:view];
    }
}

-(void)labelEnlargeAnimation{
    [UIView animateWithDuration:.1 animations:^{
        [self->_selectLab.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {

    }];
}

-(void)labelLessenAnimation{
    [UIView animateWithDuration:.1 animations:^{
        [self->_selectLab.layer setValue:@(1.0) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {

    }];
}

@end
