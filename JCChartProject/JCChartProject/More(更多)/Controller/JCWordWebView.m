//
//  JCWordWebView.m
//  JCChartProject
//
//  Created by 何键键 on 17/6/8.
//  Copyright © 2017年 JC. All rights reserved.
//

#import "JCWordWebView.h"
#import "MXConstant.h"


@interface JCWordWebView ()<UIDocumentInteractionControllerDelegate>
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@end

@implementation JCWordWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mxNavigationItem.title = self.titleName;
    self.mxNavigationItem.rightItem = [[MXBarButtonItem alloc]initWIthImage:@"更多" handler:^{
        [self btnClick];
    }];
    
    
    self.myWebView.layer.cornerRadius = 5;
    self.myWebView.layer.masksToBounds = YES;
    self.myWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.myWebView.scalesPageToFit=YES;
    self.myWebView.multipleTouchEnabled=YES;
    self.myWebView.userInteractionEnabled=YES;
    self.myWebView.backgroundColor = [UIColor clearColor];
    self.myWebView.opaque = NO;
    [self loadwebView];
    NSLog(@"filepath:%@",self.filePath);

}

- (void)btnClick{
    NSURL *url = [NSURL fileURLWithPath:self.filePath];
    _documentInteractionController = [UIDocumentInteractionController
                                      interactionControllerWithURL:url];
    [_documentInteractionController setDelegate:self];
    
    [_documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];

}




- (void) loadwebView {
    //    NSString *txtPath=[[NSBundle mainBundle]pathForResource:@"city_list" ofType:@"txt"];
    //
    //    NSLog(@"txtPath:%@",txtPath);
    
    ///编码可以解决 .txt 中文显示乱码问题
    
    NSStringEncoding *useEncodeing = nil;
    
    //带编码头的如utf-8等，这里会识别出来
    
    NSString *body = [NSString stringWithContentsOfFile:self.filePath usedEncoding:useEncodeing error:nil];
    
    //识别不到，按GBK编码再解码一次.这里不能先按GB18030解码，否则会出现整个文档无换行bug。
    
    if (!body) {
        
        body = [NSString stringWithContentsOfFile:self.filePath encoding:0x80000632 error:nil];
        
        NSLog(@"%@",body);
        
    }
    
    //还是识别不到，按GB18030编码再解码一次.
    
    if (!body) {
        
        body = [NSString stringWithContentsOfFile:self.filePath encoding:0x80000631 error:nil];
        
        NSLog(@"%@",body);
        
    }
    
    //展现
    
    if (body) {
        
        NSLog(@"%@",body);
        
        NSData *data=[body dataUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"data:%@",data);
        
        [self.myWebView loadHTMLString:body baseURL: nil];
        
    }else {
        
        NSString *urlString = [[NSBundle mainBundle] pathForAuxiliaryExecutable:self.filePath];
        
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *requestUrl = [NSURL URLWithString:urlString];
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
        
        [self.myWebView loadRequest:request];
        
    }
    
    
    
}

// 自定义方法 获取指定URL的MIMEType类型
- (NSString *)mimeType:(NSURL *)url
{
    // 1. NSURLRequest
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // 2. NSURLConnection
    // 从NSURLResponse可以获取到服务器返回的MIMEType
    // 使用同步方法获取response里面的MIMEType
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&response error:nil];
    return response.MIMEType;
}



@end
