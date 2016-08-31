//
//  JXHRecommendTagCell.m
//  百思不得姐
//
//  Created by juxiaohui on 16/8/31.
//  Copyright © 2016年 juxiaohui. All rights reserved.
//

#import "JXHRecommendTagCell.h"
#import "JXHRecommendTagModel.h"
#import "UIImageView+JXHHeader.h"

@interface JXHRecommendTagCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageListView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;

@end

@implementation JXHRecommendTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setFrame:(CGRect)frame{

    frame.size.height -=1;
    
    [super setFrame:frame];
}

-(void)setTagModel:(JXHRecommendTagModel *)tagModel{

    _tagModel = tagModel;
    
    [self.imageListView setHeader:tagModel.image_list];
    
    self.themeNameLabel.text = tagModel.theme_name;
    
    if ([tagModel.sub_number integerValue] >= 10000) {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%.1f万人订阅", [tagModel.sub_number integerValue] / 10000.0];
    } else {
        self.subNumberLabel.text = [NSString stringWithFormat:@"%@人订阅", tagModel.sub_number];
    }

    
}
- (IBAction)subButtonClick:(UIButton *)sender {
    
    self.block?self.block(self.tagModel.theme_id):nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
