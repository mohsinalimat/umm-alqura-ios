#import "SwitchCell.h"

@implementation SwitchCell

- (void)awakeFromNib {
    _cLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _cLabel.numberOfLines = 0;
    _cLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


@end
