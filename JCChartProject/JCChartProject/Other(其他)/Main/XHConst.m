

#import <Foundation/Foundation.h>

//url 192.168.7.207:8000
/** 根目录地址 */
NSString *const BaseUrl = @"http://192.168.7.207:8000/aems";

/** 用户登录 */
NSString *const LoginUrl = @"http://192.168.7.207:8000/aems/login";

/** 功能菜单 */
NSString *const MenuUrl = @"api/v1/appService/menu/user/";

/** 图表配置 */
NSString *const MenuDetailUrl = @"api/v1/appService/appCustomMenu/";

/** 图表数据 */
NSString *const ChartDataUrl = @"api/v1/dpv/fetchByTime?";

/** 钻取图表配置 */
NSString *const SubChartDetailUrl = @"api/v1/aems/dataPoint/relation?";
