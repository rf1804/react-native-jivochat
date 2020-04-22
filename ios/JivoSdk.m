//
//  JivoSDK.m
//  JivoSupport
//
//  Created by Dimmetrius on 15.03.16.
//  Copyright © 2016 JivoSite. All rights reserved.
//

#include <objc/runtime.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#import "JivoSdk.h"
#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface JivoSdk ()
{
    UIView* loadingView;
}
@end

@implementation JivoSdk

@synthesize delegate;

/* hackishFixClassName для открытия стандартной клавиатуры*/
static const char * const hackishFixClassName = "UIWebBrowserViewMinusAccessoryView";
static Class hackishFixClass = Nil;

- (UIView *)hackishlyFoundBrowserView {
    UIScrollView *scrollView = _webView.scrollView;
    
    UIView *browserView = nil;
    for (UIView *subview in scrollView.subviews) {
        if ([NSStringFromClass([subview class]) hasPrefix:@"UIWebBrowserView"]) {
            browserView = subview;
            break;
        }
    }
    return browserView;
}

- (id)methodReturningNil {
    return nil;
}

- (void)ensureHackishSubclassExistsOfBrowserViewClass:(Class)browserViewClass {
    if (!hackishFixClass) {
        Class newClass = objc_allocateClassPair(browserViewClass, hackishFixClassName, 0);
        IMP nilImp = [self methodForSelector:@selector(methodReturningNil)];
        class_addMethod(newClass, @selector(inputAccessoryView), nilImp, "@@:");
        objc_registerClassPair(newClass);
        
        hackishFixClass = newClass;
    }
}

- (BOOL) hackishlyHidesInputAccessoryView {
    UIView *browserView = [self hackishlyFoundBrowserView];
    return [browserView class] == hackishFixClass;
}

- (void) setHackishlyHidesInputAccessoryView:(BOOL)value {
    UIView *browserView = [self hackishlyFoundBrowserView];
    if (browserView == nil) {
        return;
    }
    [self ensureHackishSubclassExistsOfBrowserViewClass:[browserView class]];
    
    if (value) {
        object_setClass(browserView, hackishFixClass);
    }
    else {
        Class normalClass = objc_getClass("UIWebBrowserView");
        object_setClass(browserView, normalClass);
    }
    [browserView reloadInputViews];
}

- (void)removeBar {
    // убираем toolbar на клаве
    if (![self hackishlyHidesInputAccessoryView]){
        [self setHackishlyHidesInputAccessoryView: YES];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"keyboardWillShow");
    //перед показом клавиатуры делаем ее стандартной
    [self performSelector:@selector(removeBar) withObject:nil afterDelay:0];
    
    //вычисляем высоту клавиатуры и передаем в виджет
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrame = [_webView convertRect:keyboardFrame fromView:nil];
    
    NSString *script = [NSString stringWithFormat:@"window.onKeyBoard({visible:true, height:%@}); ", [@(keyboardFrame.size.height) stringValue]];
    [_webView evaluateJavaScript:script completionHandler:^(id result, NSError *error) {}];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    NSLog(@"keyboardDidShow");
    
    //вычисляем высоту клавиатуры и передаем в виджет
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardFrame = [_webView convertRect:keyboardFrame fromView:nil];
    
    [self execJs:[NSString stringWithFormat:@"window.scrollTo(0, %@);", [@(keyboardFrame.size.height) stringValue]]];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSLog(@"keyboardWillHide");
    
    // анимация для скрытия клавиатуры
    CGRect frame = _webView.frame;
    frame.origin.y = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        _webView.frame = frame;
    }];
    
    [_webView evaluateJavaScript:@"window.onKeyBoard({visible:false, height:0});" completionHandler:^(id result, NSError *error) {}];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    NSLog(@"keyboardDidHide");
}


/* Создание спиннера пока загружается webview*/
- (void)createLoader {
    loadingView = [[UIView alloc]initWithFrame:CGRectMake(100, 400, 80, 80)];
    loadingView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.6];
    loadingView.layer.cornerRadius = 5;
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(loadingView.frame.size.width / 2.0, 35);
    [activityView startAnimating];
    activityView.tag = 100;
    [loadingView addSubview:activityView];
    
    
    UILabel* lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, 80, 30)];
    lblLoading.text = [[NSBundle mainBundle] localizedStringForKey:(@"Loading") value:@"" table:nil];
    lblLoading.textColor = [UIColor whiteColor];
    lblLoading.font = [UIFont fontWithName:lblLoading.font.fontName size:15];
    lblLoading.textAlignment = NSTextAlignmentCenter;
    [loadingView addSubview:lblLoading];
    
    
    [_webView addSubview:loadingView];
    [loadingView setCenter : UIApplication.sharedApplication.keyWindow.center];
}

- (void)deregisterForKeyboardNotifications {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [center removeObserver:self name:UIKeyboardDidShowNotification  object:nil];
    [center removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [center removeObserver:self name:UIKeyboardDidHideNotification  object:nil];
}

-(void)dealloc{
    [self deregisterForKeyboardNotifications];
}

- (NSString *)decodeString:(NSString *)encodedString {
    NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return decodedString;
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    //если загрузка по протоколу jivoapi://, то начинаем обработку
    if ([[[url scheme] lowercaseString] isEqualToString:@"jivoapi"]) {
        NSArray *components = [[[url absoluteString] stringByReplacingOccurrencesOfString:@"jivoapi://"
                                                                               withString:@""] componentsSeparatedByString:@"/"];
        NSString *apiKey = (NSString*)[components objectAtIndex:0];
        NSString *data = @"";
        if ([components count] > 1){
            data = [self decodeString: (NSString*)[components objectAtIndex:1]];
        }
        
        [delegate onEvent:apiKey :data];
        
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - JivoSdk

-(id) initWith:(WKWebView*)web;{
    self = [super init];
    if(self) {
        self.webView = web;
        self.language = @"";
    }
    return self;
}

- (id) initWith:(WKWebView*)web :(NSString*) lang; {
    self = [super init];
    if(self) {
        self.webView = web;
        self.language = lang;
    }
    
    return self;
}

- (void) prepare; {}

-(void) start; {
    //убираем нативный скролл
    _webView.scrollView.scrollEnabled = NO;
    _webView.scrollView.bounces = NO;
    
    NSString *indexFile;
    
    if(self.language.length > 0){
        indexFile = [NSString stringWithFormat:@"index_%@", self.language];
    }else{
        indexFile = @"index";
    }
    
    //загрузка кода виджета в webview
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:indexFile ofType:@"html" inDirectory:@"/html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    
    [_webView loadHTMLString:htmlString
                     baseURL:[NSURL fileURLWithPath:
                              [NSString stringWithFormat:@"%@/html/",
                               [[NSBundle mainBundle] bundlePath]]]];
}

-(void) stop; {
    [self deregisterForKeyboardNotifications];
}

-(NSString*) execJs : (NSString*) code;{
    __block NSString *resultString = nil;
    __block BOOL finished = NO;
    
    [_webView evaluateJavaScript:code completionHandler:^(id result, NSError *error) {
        if (error == nil) {
            if (result != nil) {
                resultString = [NSString stringWithFormat:@"%@", result];
            }
        } else {
            NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
        }
        finished = YES;
    }];
    
    while (!finished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    return resultString;
}

-(void) callApiMethod: (NSString*) methodName : (NSString*)data;{
    [_webView evaluateJavaScript:[NSString stringWithFormat:@"window.jivo_api.%@(%@);",methodName,data] completionHandler:^(id result, NSError *error) {}];
}

@end
