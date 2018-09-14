//
//  PagerViewController.m
//  PLPagerDemo
//
//  Created by changshitong on 2018/9/14.
//  Copyright © 2018年 PLAN. All rights reserved.
//

#import "PagerViewController.h"
#import "ContentViewController.h"

@interface PagerViewController () <PLPagerViewControllerDelegate,PLPagerViewControllerDataSource>
@property (nonatomic) UISegmentedControl *segmentControl;

@property (nonatomic) UIView *markView;
@end

@implementation PagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.segmentControl];
    self.segmentControl.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)+3, 30);
    CGFloat markWidth = CGRectGetWidth(self.view.bounds) / 20;
    [self.view addSubview:self.markView];
    self.markView.frame = CGRectMake(0, 35, markWidth, 20);
}


- (void)segmentControlValueChange:(UISegmentedControl *)control
{
    [self moveToViewControllerAtIndex:control.selectedSegmentIndex animated:YES];
}
- (UISegmentedControl *)segmentControl
{
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] init];
        [_segmentControl addTarget:self action:@selector(segmentControlValueChange:) forControlEvents:UIControlEventValueChanged];
        
        for (int i =0;i<20;i++) {
            [_segmentControl insertSegmentWithTitle:[NSString stringWithFormat:@"%d",i] atIndex:i animated:YES];
        }
    }
    return _segmentControl;
}

- (UIView *)markView
{
    if (!_markView) {
        _markView = [[UIView alloc] init];
        _markView.backgroundColor = [UIColor blackColor];
    }
    return _markView;
}

#pragma mark - PLPagerViewControllerDelegate

- (void)pagerViewController:(PLPagerViewController *)controller
            movedFromIndex:(NSInteger)fromIndex
                   toIndex:(NSInteger)toIndex
{
        NSLog(@"moved fromIndex:%ld toIndex:%ld",fromIndex,toIndex);
    [self.segmentControl setSelectedSegmentIndex:toIndex];
}

- (void)pagerViewController:(PLPagerViewController *)controller
           movingFromIndex:(NSInteger)fromIndex
                   toIndex:(NSInteger)toIndex
                  progress:(CGFloat)progress
           indexWasChanged:(BOOL)indexWasChanged
{

    if (indexWasChanged) {
        [self.segmentControl setSelectedSegmentIndex:toIndex];
    }
    
    CGRect rect = self.markView.frame;
    CGFloat markWidth = CGRectGetWidth(self.view.bounds) / 20.0;
    
    CGFloat fromOffset = CGRectGetMinX(self.markView.frame);
    CGFloat toOffset = markWidth * toIndex;
    
    rect.origin.x = fromOffset + (toOffset - fromOffset) * progress;
    
    self.markView.frame = rect;
    
}

#pragma mark - PLPagerViewControllerDataSource

- (NSArray *)childViewControllersForPagerViewController:(PLPagerViewController *)controller
{
    NSMutableArray *array = @[].mutableCopy;
    
    for (int i = 0; i < 20; i++) {
        ContentViewController *vc = [[ContentViewController alloc] init];
        vc.index = i;
        [array addObject:vc];
    }
    
    return array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
