//
//  ViewController.m
//  HKU
//
//  Created by GK on 2019/5/17.
//  Copyright © 2019 GK. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;
@property (nonatomic,strong) UILabel *label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewOffsetConstraint;
@property (nonatomic,strong) UIView *footerView;
@property (nonatomic) CGFloat labelPosition;
@property (nonatomic) CGFloat offsetHeight;
@property (nonatomic) CGFloat offset;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.offset = 40;
    self.tableView.tableFooterView = self.footerView;
    
    if ([self hasBottomSafeAreaInsets]) {
        self.bottomHeightConstraint.constant = 120 + 34;
    }
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.labelPosition == 0) {
        
        CGRect tmpFrame = [self.footerView convertRect:self.label.frame toView:self.tableView];
        CGRect labelFrame = [self.tableView convertRect:tmpFrame toView:self.view];
        
        self.labelPosition = labelFrame.origin.y + labelFrame.size.height;
        
        CGFloat screenheight = UIScreen.mainScreen.bounds.size.height;
        CGFloat offset = screenheight - self.labelPosition - 120 + 64 - self.offset ; //view height 120

        if ([self hasBottomSafeAreaInsets]) { //for iphonex iphone xs
            offset = screenheight - self.labelPosition - 120 - 34 + 64 + 24 - self.offset; //view height 120 + 34
        }

        if (offset <= 0) {
            self.offsetHeight = offset ;
            self.bottomViewOffsetConstraint.constant = offset ;
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"indexPath:%@",@(indexPath.row)];

    if (indexPath.section == 3) {
        cell.hidden = YES;
    } else {
        cell.hidden = NO;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return 200;
    }
    return 0;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offset = scrollView.contentOffset.y;
    
    if (offset <= -self.offsetHeight ) {
        self.bottomViewOffsetConstraint.constant = offset + self.offsetHeight;
    } else {
        self.bottomViewOffsetConstraint.constant = 0;
    }
    
    NSLog(@"offset: %@",@(offset));
}

-(UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 200 + 120 + self.offset)];
        _footerView.backgroundColor = [UIColor redColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"我是一个buttom";
        self.label = label;
        label.backgroundColor = [UIColor yellowColor];
        label.frame = CGRectMake(0, 160, 200, 40);
        [_footerView addSubview:label];
    }
    return _footerView;
}

- (BOOL)hasBottomSafeAreaInsets {
    if (@available(iOS 11.0, tvOS 11.0, *)) {
        // with home indicator: 34.0 on iPhone X, XS, XS Max, XR.
        // with home indicator: 20.0 on iPad Pro 12.9" 3rd generation.
        CGFloat bottomInset =  [[UIApplication sharedApplication].keyWindow safeAreaInsets].bottom ;
        if (bottomInset >= 25) {
            return  YES;
        }
        return NO;
    }
    return NO;

}
@end
