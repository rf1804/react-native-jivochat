//
//  JivoChatVC.m
//  JivoChat
//
//  Created by Kamal on 26/06/18.
//  Copyright © 2018 Neophyte. All rights reserved.
//

#import "JivoChatVC.h"
#import "JivoSdk.h"

@interface JivoChatVC () <JivoDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) JivoSdk* jivoSdk;
@property (nonatomic, weak) NSString* lang;

@end

@implementation JivoChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self onViewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self onViewWillAppear];
}

//MARK:- onViewDidLoad
- (void)onViewDidLoad {
    self.lang = [NSBundle.mainBundle localizedStringForKey:@"LangKey" value:@"" table:nil];
    self.jivoSdk = [[JivoSdk alloc] init];
    self.jivoSdk.language = @"en";

    [self.jivoSdk setWebView:self.webView];
    [self.jivoSdk setDelegate:self];
    [self.jivoSdk prepare];
}
//MARK:- onViewWillAppear
- (void)onViewWillAppear {
    [self.jivoSdk start];
    
}

//MARK: ---- Delegate Methods
- (void)onEvent:(NSString *)name :(NSString *)data {
    
    NSLog(@"event:%@, data: %@", name, data);
    if ([[name lowercaseString] isEqualToString:@"url.click"]) {
        if (data.length > 2) {
            NSRange range = NSMakeRange(1, data.length - 2);
            NSString *strUrl = [data substringWithRange:range];
            NSURL *url = [NSURL URLWithString:strUrl];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
    else if ([[name lowercaseString] isEqualToString:@"chat.ready"]){
        NSString *contactInfo = [NSString stringWithFormat:@"client_name: %@, email: %@, phone: %@, description: %@", @"User", @"email@gmail.com", @"1234567", @"description"];
        [self.jivoSdk callApiMethod:@"setContactInfo" :contactInfo];
        [self.jivoSdk callApiMethod:@"setUserToken" :@"UserToken"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)actionBack:(id)sender {
    
//    [self.navigationController dismissViewControllerAnimated:TRUE completion:nil];
        
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

@end
