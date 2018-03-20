//
//  RxWebViewController.h
//  RxWebViewController
//
//  Created by roxasora on 15/10/23.
//  Copyright © 2015年 roxasora. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <WebKit/WebKit.h>

typedef void(^NeedNewPageBlock)(NSURLRequest *request);

@interface RxWebViewController : UIViewController<UIWebViewDelegate,UINavigationBarDelegate,WKNavigationDelegate>


/**
 *  origin url
 */
@property (nonatomic)NSURL* url;

/**
 *  embed webView
 */
//@property (nonatomic)UIWebView* webView;
@property (nonatomic, strong) WKWebView *webView;

/**
 *  tint color of progress view
 */
@property (nonatomic)UIColor* progressViewColor;

@property (nonatomic, assign) BOOL needNewPage;
@property (nonatomic, copy) NeedNewPageBlock needNewPageBlock;
@property (nonatomic, assign) BOOL isHandleBackByH5;

/**
 *  get instance with url
 *
 *  @param url url
 *
 *  @return instance
 */
-(instancetype)initWithUrl:(NSURL *)url needJSSupport:(BOOL)isNeedJSSupport;
- (void)load;

-(void)reloadWebView;


-(void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request;


#pragma mark - 添加JS调用支持
//- (void)addJSBridge;
//- (void)handleBackByH5;
//- (void)handleNativeBack;

@end



