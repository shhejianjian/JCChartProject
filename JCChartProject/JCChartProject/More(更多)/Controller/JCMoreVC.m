//
//  JCMoreVC.m
//  JCChartProject
//
//  Created by 何键键 on 17/5/15.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCMoreVC.h"
#import "MXConstant.h"
#import "XFSegmentView.h"
#import "JCMoreModel.h"
#import "JCStrategyCell.h"
#import "HCGDatePickerAppearance.h"
#import "JCWordWebView.h"
#import "AFN_Download_Tool.h"
#import "HWProgressView.h"

#define WINDOWFirst        [[[UIApplication sharedApplication] windows] firstObject]


static NSString *ID=@"JCStrategyCell";


@interface JCMoreVC ()<XFSegmentViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong) NSString *listUrl;

@property (nonatomic, strong) NSMutableArray *moreListArr;
/** 记录当前页码 */
@property (nonatomic, assign) int currentPage;
/** 总数 */
@property (nonatomic, assign) NSInteger  totalCount;

@property (strong, nonatomic) IBOutlet UIButton *startTimeBtn;
@property (strong, nonatomic) IBOutlet UIButton *endTimeBtn;

@property (nonatomic, copy) NSString *startTimeStr;
@property (nonatomic, copy) NSString *endTimeStr;
@property (strong, nonatomic) IBOutlet UILabel *nodataLabel;

@property (nonatomic, weak) HWProgressView *progressView;

@property (nonatomic, assign) CGFloat downProgress;
@property(nonatomic,strong)UIView *bGView;
@property(nonatomic,strong)UIImageView *CancelImage;
@property(strong,nonatomic)NSURLSessionDownloadTask *task;

@end

@implementation JCMoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = @"更多";
    
    [self.endTimeBtn setTitle:[self getNowDate] forState:UIControlStateNormal];
    [self.startTimeBtn setTitle:[self getStartDate] forState:UIControlStateNormal];
    
    XFSegmentView *segView=[[XFSegmentView alloc]initWithFrame:Frame(0, 64, SCREEN_WIDTH, WH(35))];
    [self.view addSubview:segView];
    segView.delegate = self;
    segView.titles = @[@"异常数据",@"文档查询"];
    segView.titleFont = Font(15);
    
    self.listUrl = abnomarlDataListUrl;
    
    self.startTimeStr = [self getParamsStartDate];
    self.endTimeStr = [self getParmasNowDate];
        
    [self.myTableView registerNib:[UINib nibWithNibName:@"JCStrategyCell" bundle:nil] forCellReuseIdentifier:ID];
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.myTableView.mj_header beginRefreshing];
}
- (void)loadNewData
{
    [self.moreListArr removeAllObjects];
    self.currentPage = 1;
    [self loadDataListWithUrl:self.listUrl AndStartTime:self.startTimeStr andEndTime:self.endTimeStr];
}
- (void)loadMoreData
{
    self.currentPage ++;
    [self loadDataListWithUrl:self.listUrl AndStartTime:self.startTimeStr andEndTime:self.endTimeStr];
}
- (void) loadDataListWithUrl:(NSString *)url AndStartTime:(NSString *)start andEndTime:(NSString *)endTime{
    NSString *jsessionid = [[NSUserDefaults standardUserDefaults]objectForKey:@"jsessionid"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"beginDate"] = start;
    params[@"endDate"] = endTime;
    params[@"pageNo"] = @(self.currentPage);
    params[@"pageSize"] = @"8";
    [XHHttpTool get:url params:params jessionid:jsessionid success:^(id json) {
        NSLog(@"json:%@",json);
        JCMoreModel *moreModel = [JCMoreModel mj_objectWithKeyValues:json];
        NSArray *arr = [JCMoreModel mj_objectArrayWithKeyValuesArray:moreModel.dataList];
        for (JCMoreModel *model in arr) {
            [self.moreListArr addObject:model];
        }
        if (self.moreListArr.count == 0) {
            self.nodataLabel.hidden = NO;
        } else {
            self.nodataLabel.hidden = YES;
        }
        self.totalCount = [moreModel.total integerValue];
        [self.myTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    [self.myTableView.mj_header endRefreshing];
    [self.myTableView.mj_footer endRefreshing];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.moreListArr.count == self.totalCount) {
        self.myTableView.mj_footer.state = MJRefreshStateNoMoreData;
    }else{
        self.myTableView.mj_footer.state = MJRefreshStateIdle;
    }
    return self.moreListArr.count;
}


- (JCStrategyCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JCStrategyCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell=[[JCStrategyCell alloc]init];
        
    }
    if (self.moreListArr.count != 0) {
        if ([self.listUrl isEqualToString:abnomarlDataListUrl]) {
            cell.abnormalDataModel = self.moreListArr[indexPath.row];
        }
        if ([self.listUrl isEqualToString:wordSearchListUrl]) {
            cell.wordDataModel = self.moreListArr[indexPath.row];
        }
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JCMoreModel *model = self.moreListArr[indexPath.row];
    NSLog(@"objectid:%@--%@",model.objectId,model.officeDocumentName);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [NSString stringWithFormat:@"%@/Caches/downloadFile",[paths objectAtIndex:0]];
//    NSString *path = [NSString stringWithFormat:@"%@/Caches/downloadFile",NSHomeDirectory()];
    path = [path stringByAppendingString:[NSString stringWithFormat:@"%@.%@",model.objectId,model.documentType]];
    
    NSInteger fileSize = [self fileSizeAtPath:path];
    NSLog(@"size====%ld",(long)fileSize
          );
    if (fileSize == [model.fileSize integerValue]) {
        JCWordWebView *wordVC = [[JCWordWebView alloc]init];
        wordVC.filePath = path;
        wordVC.titleName = model.officeDocumentName;
        [self.navigationController pushViewController:wordVC animated:YES];
    } else{
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL bRet = [fileMgr fileExistsAtPath:path];
        if (bRet) {
            NSError *err;
            [fileMgr removeItemAtPath:path error:&err];
        }
        
        NSString *urlStr = [NSString stringWithFormat:@"%@/%@?objectId=%@",BaseUrl,wordDownloadUrl,model.objectId];
        [self hudTipWillShow:YES];
        NSURLSessionDownloadTask *task = [AFN_Download_Tool downloadFileWithUrl:urlStr andFileName:model.objectId andFileType:model.documentType downloadProgress:^(CGFloat progress, CGFloat total, CGFloat current) {
            //               回到主线程更新进度条
            dispatch_async(dispatch_get_main_queue(), ^{
                self.downProgress = progress;
                self.progressView.progress = progress;
            });
            
        } downloadCompletion:^(BOOL state, NSString *message, NSString *filePath) {
            NSLog(@"文件路经：%@",filePath);
            NSLog(@"downp:%f",self.downProgress);
            if (state) {
                [MBProgressHUD showSuccess:message];
            }else {
                [MBProgressHUD showError:message];
            }
            if (self.downProgress == 1) {
                [self hudTipWillShow:NO];
                [MBProgressHUD hideHUDForView:self.view];
                JCWordWebView *wordVC = [[JCWordWebView alloc]init];
                wordVC.filePath = filePath;
                wordVC.titleName = model.officeDocumentName;
                [self.navigationController pushViewController:wordVC animated:YES];
            }
        }];
        _task = task;
        [AFN_Download_Tool start:task];
    }
    

}

-(long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


- (void)viewWillDisappear:(BOOL)animated{
    [self hudTipWillShow:NO];
}

#pragma mark -- init MBProgressHUD
- (void)hudTipWillShow:(BOOL)willShow{
    if (willShow) {
        [self createBackgroundView];
        HWProgressView *progressView = [[HWProgressView alloc] initWithFrame:CGRectMake(KScreenW/2-75, KScreenH/2, 150, 20)];
        [self.bGView addSubview:progressView];
        progressView.tag = 222;
        self.progressView = progressView;
//        self.progressView.progress = progress;
    }else{
        for (UIView *view in self.view.subviews) {
            if (view.tag == 222) {
                [view removeFromSuperview];
            }
            [self.bGView removeFromSuperview];
        }
    }
}

-(void)createBackgroundView{
    self.bGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, KScreenH)];
    self.bGView.backgroundColor = [UIColor blackColor];
    self.bGView.alpha = 0.5;
    self.bGView.userInteractionEnabled = YES;
    
    self.CancelImage = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenW/2-15, KScreenH/2+30, 30, 30)];
    self.CancelImage.image = [UIImage imageNamed:@"MBProgressHUD.bundle/error.png"];
    self.CancelImage.userInteractionEnabled = YES;
    [self.CancelImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)]];
    [self.bGView addSubview:self.CancelImage];
    
    [WINDOWFirst addSubview:self.bGView];
}

- (void)cancel{
    NSLog(@"111");
    [AFN_Download_Tool pause:_task];
    [self hudTipWillShow:NO];
}

-(void)segmentView:(XFSegmentView *)segmentView didSelectIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
    
    switch (index) {
        case 0:
            if (![self.listUrl isEqualToString:abnomarlDataListUrl]) {
                self.listUrl = abnomarlDataListUrl;
                [self loadNewData];
            }
            break;
        case 1:
            if (![self.listUrl isEqualToString:wordSearchListUrl]) {
                self.listUrl = wordSearchListUrl;
                [self loadNewData];
            }
            break;
        
            
        default:
            break;
    }
}

- (IBAction)startTimeClick:(id)sender {
    HCGDatePickerAppearance *picker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerDateMode completeBlock:^(NSDate *date) {
        [picker hide];
        [self.startTimeBtn setTitle:[self setdateFormatterwithDate:date] forState:UIControlStateNormal];
        self.startTimeStr = [self setParamsDateFormatterwithDate:date];
        [self loadNewData];
    }];
    [picker show];
}

- (IBAction)endTimeClick:(id)sender {
    HCGDatePickerAppearance *picker = [[HCGDatePickerAppearance alloc]initWithDatePickerMode:DatePickerDateMode completeBlock:^(NSDate *date) {
        [picker hide];
        [self.endTimeBtn setTitle:[self setdateFormatterwithDate:date] forState:UIControlStateNormal];
        self.endTimeStr = [self setParamsDateFormatterwithDate:date];
        [self loadNewData];
    }];
    [picker show];
}

- (NSString *)setdateFormatterwithDate:(NSDate *)date{
    NSString *formatStr = @"yyyy-MM-dd";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatStr];
    return [dateFormatter stringFromDate:date];
}
- (NSString *)setParamsDateFormatterwithDate:(NSDate *)date{
    NSString *formatStr = @"yyyyMMdd";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatStr];
    return [dateFormatter stringFromDate:date];
}
//结束时间
- (NSString*)getNowDate{
    NSDate *date = [NSDate date]; // 获得时间对象
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}
//获取开始时间
- (NSString*)getStartDate{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *myDate = [NSDate date];
    NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * -7];
    return [dateFormatter stringFromDate:newDate];
}
//结束时间
- (NSString*)getParmasNowDate{
    NSDate *date = [NSDate date]; // 获得时间对象
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    return [dateFormatter stringFromDate:date];
}
//获取开始时间
- (NSString*)getParamsStartDate{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *myDate = [NSDate date];
    NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * -7];
    return [dateFormatter stringFromDate:newDate];
}
- (NSMutableArray *)moreListArr {
	if(_moreListArr == nil) {
		_moreListArr = [[NSMutableArray alloc] init];
	}
	return _moreListArr;
}

@end
