//
//  JivoSdk.h
//  JivoSupport
//
//  Created by Dimmetrius on 15.03.16.
//  Copyright © 2016 JivoSite. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#ifndef JivoSdk_h
#define JivoSdk_h

@protocol JivoDelegate

// define protocol functions that can be used in any class using this delegate
-(void)onEvent:(NSString *)name :(NSString*)data;

@end

@interface JivoSdk : NSObject<WKNavigationDelegate>

@property (nonatomic, assign) id delegate;
@property (strong, nonatomic) WKWebView* webView;
@property (strong, nonatomic) NSString* language;

-(id) initWith:(WKWebView*)web :(NSString*) lang;
-(id) initWith:(WKWebView*)web;
-(void) prepare;
-(void) start;
-(void) stop;
-(NSString*) execJs : (NSString*) code;
-(void) callApiMethod: (NSString*) methodName : (NSString*)data;

@end

#endif /* JivoSdk_h */
