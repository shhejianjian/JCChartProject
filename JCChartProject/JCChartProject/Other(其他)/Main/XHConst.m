

#import <Foundation/Foundation.h>

//url 192.168.7.207:8000
/** 根目录地址 */
NSString *const BaseUrl = @"http://192.168.7.71:8008/aems";

/** 用户登录 */
NSString *const LoginUrl = @"http://192.168.7.71:8008/aems/login";

/** 检查更新 */
NSString *const updateAppVersionUrl = @"api/v1/appService/appVersion/checkLatestVersion";


/** 修改密码 */
NSString *const updatePasswordUrl = @"api/v1/appService/modifyPassword";


/** 功能菜单 */
NSString *const MenuUrl = @"api/v1/appService/menu/user/";
/** 订阅菜单 */
NSString *const favoriteMenuUrl = @"api/v1/appService/appCustomMenu/favorite";
/** 图表配置 */
NSString *const MenuDetailUrl = @"api/v1/appService/appCustomMenu/";

/** 图表数据 */
NSString *const ChartDataUrl = @"api/v1/dpv/fetchByTime?";

/** 钻取图表配置 */
NSString *const SubChartDetailUrl = @"api/v1/aems/dataPoint/relation?";


/** 策略列表 */
NSString *const StrategyListUrl = @"api/v1/appService/strategyActivation/query";

/** 其他-异常数据列表 */
NSString *const abnomarlDataListUrl = @"api/v1/appService/dataPointExceptionLog/query";

/** 其他-文档查询列表 */
NSString *const wordSearchListUrl = @"api/v1/appService/officeDocument/query";

/** 其他-文档下载 */
NSString *const wordDownloadUrl = @"api/v1/appService/officeDocument/download";
