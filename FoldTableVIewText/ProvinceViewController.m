//
//  ProvinceViewController.m
//  FoldTableVIewText
//
//  Created by 恒 韩 on 17/1/12.
//  Copyright © 2017年 co. All rights reserved.
//

#import "ProvinceViewController.h"
#import "CityTableViewCell.h"

@interface ProvinceViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
 
    UITableView *_provinceTableView;
    NSDictionary *_provinceDic;
    NSArray *_provinceArray;
    NSMutableArray *_isExpandArray;//记录section是否展开
    
}
@end

@implementation ProvinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isExpandArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"城市列表";
    [self getProvinceDataFromList];
    [self initProvinceTableView];
}

- (void)getProvinceDataFromList{
    NSString *dataList = [[NSBundle mainBundle]pathForResource:@"ProvinceData" ofType:@"plist"];
    _provinceDic = [[NSDictionary alloc]initWithContentsOfFile:dataList];
    _provinceArray = [_provinceDic allKeys];
    for (NSInteger i = 0; i < _provinceArray.count; i++) {
        [_isExpandArray addObject:@"0"];//0:没展开 1:展开
    }
    NSLog(@"城市列表:%@",_provinceDic);
}

- (void)initProvinceTableView{
    _provinceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 375, 667 - 64) style:UITableViewStyleGrouped];
    _provinceTableView.delegate = self;
    _provinceTableView.dataSource = self;
    [self.view addSubview:_provinceTableView];
}

#pragma -- mark tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _provinceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_isExpandArray[section]isEqualToString:@"1"]) {
        NSString *keyProvince = _provinceArray[section];
        NSArray *cityArray = [_provinceDic objectForKey:keyProvince];
        return  cityArray.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UILabel *provinceLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 0, 100, 26)];
    provinceLabel.textColor = [UIColor blackColor];
    provinceLabel.text = _provinceArray[section];
    [headerView addSubview:provinceLabel];
    UIImageView *selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(26, 5, 18, 18)];
    [headerView addSubview:selectImageView];
    if ([_isExpandArray[section] isEqualToString:@"0"]) {
        //未展开
        selectImageView.image = [UIImage imageNamed:@"caret"];
    }else{
        //展开
        selectImageView.image = [UIImage imageNamed:@"caret_open"];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [headerView addGestureRecognizer:tap];
    headerView.tag = section;
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *iditifier = @"CityTableViewCell";
    CityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iditifier];
    if (cell == nil) {
        NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:iditifier owner:self options:nil];
        cell = nibArray[0];
    }
    NSString *keyOfProvince = _provinceArray[indexPath.section];
    NSArray *cityArray = [_provinceDic objectForKey:keyOfProvince];
    cell.provinceLabel.text = cityArray[indexPath.row];
    return cell;
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    if ([_isExpandArray[tap.view.tag] isEqualToString:@"0"]) {
        //关闭 => 展开
        [_isExpandArray removeObjectAtIndex:tap.view.tag];
        [_isExpandArray insertObject:@"1" atIndex:tap.view.tag];
    }else{
        //展开 => 关闭
        [_isExpandArray removeObjectAtIndex:tap.view.tag];
        [_isExpandArray insertObject:@"0" atIndex:tap.view.tag];
        
    }
//     NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:tap.view.tag];
//     NSRange rang = NSMakeRange(indexPath.section, 1);
//     NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:rang];
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:tap.view.tag];
    [_provinceTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
