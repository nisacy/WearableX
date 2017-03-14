//
//  ScreeningView.m
//  XLShop
//
//  Created by Shinsoft on 15/10/13.
//  Copyright © 2015年 Shinsoft. All rights reserved.
//

#import "ScreeningView.h"

#define default_title_color RGBCOLOR(132, 126, 140)
#define select_title_color RGBCOLOR(255,53,82)

@interface ScreeningView(){
    NSInteger selectIndex;
    NSInteger clickCount;//点击数量
    UIButton *oldButton;
    ScreeningModel *oldScreeningModel;
    UIButton *firstBtn;
}

@end

@implementation ScreeningView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame items:(NSArray *)screenings
{
    self.screenings = screenings;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(249, 249, 249);
        selectIndex = 0;
        // Initialization code
        [self initLayoutView];
    }
    return self;
}

- (void)initLayoutView{
    //获取均分宽度
    float mWidth = self.width/self.screenings.count;
    //高度
    float mHeight = self.height;
    
    
    //NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor],[UIColor blueColor],[UIColor grayColor],[UIColor purpleColor], nil];
    for (int i=0; i<self.screenings.count; i++) {
        ScreeningModel *screeningModel = [self.screenings objectAtIndex:i];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(mWidth * i, 0, mWidth, mHeight);
        button.tag = i;
        //button.backgroundColor = [colors objectAtIndex:i];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        //title
        [button setTitle:screeningModel.title forState:UIControlStateNormal];
        
        if (selectIndex == i) {
            [button setTitleColor:select_title_color forState:UIControlStateNormal];
        } else {
            [button setTitleColor:default_title_color forState:UIControlStateNormal];
        }
        [button setTitleColor:select_title_color forState:UIControlStateHighlighted];
        
        //默认背景
        if (!IsNilString(screeningModel.background)) {
            [button setBackgroundImage:[UIImage imageNamed:screeningModel.background] forState:UIControlStateNormal];
        }
        //选中背景
        if (!IsNilString(screeningModel.selectedBackground)) {
            [button setBackgroundImage:[UIImage imageNamed:screeningModel.selectedBackground] forState:UIControlStateHighlighted];
        }
        
        //小图标默认
        if (!IsNilString(screeningModel.normalIcon)) {
            [button setImage:[UIImage imageNamed:screeningModel.normalIcon] forState:UIControlStateNormal];
        }
        [button layoutIfNeeded];
        
        
        //改变图文位置
        button. titleEdgeInsets = UIEdgeInsetsMake ( 0 , -button. imageView . frame . size . width , 0 , button. imageView . frame . size . width );
        button. imageEdgeInsets = UIEdgeInsetsMake ( 0 , button. titleLabel . frame . size . width + 15 , 0 , 0 );
        
        [button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (i == 0) {
            oldButton = button;
            oldScreeningModel = screeningModel;
            firstBtn = button;
        }
        [self addSubview:button];
        
    }
}

- (void)resetView{
    [self selectClick:firstBtn isReset:YES];
}

- (void)selectClick:(UIButton *)sender{
    [self selectClick:sender isReset:NO];
}

- (void)selectClick:(UIButton *)sender isReset:(BOOL)isRest{
    DLog(@"p:%ld",sender.tag);
    
    if (![[self.screenings objectAtIndex:sender.tag] disableExchange]) {
        if (selectIndex == sender.tag) {
            clickCount++;
            oldButton = nil;
        } else {
            clickCount = 0;
        }
        
        selectIndex = sender.tag;
        [self resetLayoutView:sender isReset:isRest];
        
        oldButton = sender;
        oldScreeningModel = [self.screenings objectAtIndexedSubscript:selectIndex];
    } else {
        [self.delegate screeningView:self didSelectIndex:sender.tag isAsc:YES];
    }
}

/**
 *  更改字体颜色
    更改升序或降序图标
 */
- (void)resetLayoutView:(UIButton *)sender isReset:(BOOL)isRest{
    for (int i=0; i<self.screenings.count; i++) {
        ScreeningModel *screeningModel = [self.screenings objectAtIndex:i];
        
        if (selectIndex == i) {//当前选中的按钮
            if (clickCount == 0) {//首次点击
                [sender setTitleColor:select_title_color forState:UIControlStateNormal];
                
                //小图标选中
                if (!IsNilString(screeningModel.selectedIcon)) {
                    [sender setImage:[UIImage imageNamed:screeningModel.selectedIcon] forState:UIControlStateNormal];
                }
                if (!isRest) {
                    [self.delegate screeningView:self didSelectIndex:sender.tag isAsc:YES];
                }
                
            } else {//多次点击
                //小图标切换
                if (!IsNilString(screeningModel.selectedIcon) && !IsNilString(screeningModel.exchangeIcon)) {
                    if (clickCount%2 == 0) {//升序
                        if (!IsNilString(screeningModel.selectedIcon)) {
                            [sender setImage:[UIImage imageNamed:screeningModel.selectedIcon] forState:UIControlStateNormal];
                        }
                        if (!isRest) {
                            [self.delegate screeningView:self didSelectIndex:sender.tag isAsc:YES];
                        }
                        
                    } else {//降序
                        if (!IsNilString(screeningModel.exchangeIcon)) {
                            [sender setImage:[UIImage imageNamed:screeningModel.exchangeIcon] forState:UIControlStateNormal];
                        }
                        if (!isRest) {
                            [self.delegate screeningView:self didSelectIndex:sender.tag isAsc:NO];
                        }
                        
                        
                    }
                    
                }
            }
            
        } else {//非选中
            
            if (oldButton) {
                [oldButton setTitleColor:default_title_color forState:UIControlStateNormal];
                
                //小图标选中
                if (!IsNilString(oldScreeningModel.normalIcon)) {
                    [oldButton setImage:[UIImage imageNamed:oldScreeningModel.normalIcon] forState:UIControlStateNormal];
                } else {
                    [oldButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                }
            }
            
            
        }
        
    }
}

@end
