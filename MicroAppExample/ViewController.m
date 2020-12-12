//
//  ViewController.m
//  MicroAppExample
//
//  Created by ashoka on 2020/10/23.
//  Copyright © 2020 iWhaleCloud. All rights reserved.
//

#import "ViewController.h"
#import <AlitaNativeLib/AlitaNativeLib.h>

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<AlitaMicroApp *> *appList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initSubviews];
    [self initData];
}

- (void)initSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)initData {
    [self fetchMicroAppList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSDate *end = NSDate.date;
    NSLog(@"push end: %.3f", [end timeIntervalSince1970]);
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.appList.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.section == 0) {
        AlitaMicroApp *app = self.appList[indexPath.row];
        cell.textLabel.text = app.appName;
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"API 演示";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AlitaMicroApp *app = self.appList[indexPath.row];
        [AlitaNative viewController:self openMicroApp:app];
    } else if (indexPath.section == 1) {
        [AlitaNative viewController:self openURL:[NSURL URLWithString:@"https://micro-app-demo-nextjs.vercel.app"] userData:@{
            @"param": @"api demo",
        }];
    }
}

#pragma mark - network
- (void)fetchMicroAppList {
    __weak typeof(self) weakSelf = self;
    [AlitaMicroApp microAppListWithCallback:^(NSArray<AlitaMicroApp *> * _Nullable list, AlitaPagination * _Nullable pagination, NSError * _Nullable error) {
        NSLog(@"%@\n%@\n%@", list, pagination, error);
        weakSelf.appList = list;
        [weakSelf.tableView reloadData];
    }];
}


@end
