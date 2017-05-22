
#import <Foundation/Foundation.h>



#define XHColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define XHGlobalColor XHColor(39, 165, 156)

/** 根目录地址 */
extern NSString *const BaseUrl;

/** 用户登录 */
extern NSString *const LoginUrl;

/** 功能菜单 */
extern NSString *const MenuUrl;

/** 图标配置 */
extern NSString *const MenuDetailUrl;

/** 图标数据 */
extern NSString *const ChartDataUrl;

/** 钻取图表配置 */
extern NSString *const SubChartDetailUrl;
