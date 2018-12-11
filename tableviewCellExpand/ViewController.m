//
//  ViewController.m
//  tableviewCellExpand
//
//  Created by qiaochun ji on 2018/12/11.
//  Copyright © 2018 qiaochun ji. All rights reserved.
//

#import "ViewController.h"

#define SCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT  [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray *dataArray;//创建一个数据源数组
@property (nonatomic,strong) NSMutableDictionary *dic;//创建一个字典进行判断收缩还是展开
@property (nonatomic,strong) NSArray *sectionArr;//分组的名字

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.dic = [NSMutableDictionary dictionary];
    self.dataArray = @[@[@"1"],@[@"1",@"2"],@[@"1",@"2",@"3"],@[@"1",@"2",@"3",@"4"]];
    self.sectionArr = @[@"第一组",@"第二组",@"第三组",@"第四组"];
    [self.view addSubview:self.tableView];
    
}

//懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    view.backgroundColor = [UIColor lightGrayColor];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    titleLab.text = self.sectionArr[section];
    titleLab.textColor = [UIColor blackColor];
    titleLab.userInteractionEnabled = true;
    [view addSubview:titleLab];
    //创建一个手势进行点击，这里可以换成button
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action_tap:)];
    view.tag = 300 + section;
    [view addGestureRecognizer:tap];
    return view;
}

- (void)action_tap:(UIGestureRecognizer *)tap{
    NSString *str = [NSString stringWithFormat:@"%ld",tap.view.tag - 300];
    if ([self.dic[str] integerValue] == 0) {//如果是0，就把1赋给字典,打开cell
        [self.dic setObject:@"1" forKey:str];
    }else{//反之关闭cell
        [self.dic setObject:@"0" forKey:str];
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:[str integerValue]]withRowAnimation:UITableViewRowAnimationFade];//有动画的刷新
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *string = [NSString stringWithFormat:@"%ld",section];
    if ([self.dic[string] integerValue] == 1 ) {  //打开cell返回数组的count
        NSArray *array = [NSArray arrayWithArray:self.dataArray[section]];
        return array.count;
    }else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor orangeColor];
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}


@end
