
#import "RNJivochat.h"
#import "JivoChatVC.h"
#if __has_include(<React/RCTBridge.h>)
#import <React/RCTBridge.h>
#else // Compatibility for RN version < 0.40
#import "RCTBridge.h"
#endif
@interface RNJivochat()

@end

@implementation RNJivochat
@synthesize bridge = _bridge;
- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(openJivoChat) {
    
    JivoChatVC *chatVC = [[JivoChatVC alloc] initWithNibName:@"JivoChatVC" bundle:nil];
    UIViewController *root = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    
//    UINavigationController * navg = [[UINavigationController alloc] initWithRootViewController:chatVC];
//
////    UIBarButtonItem *flipButton=  [[UIBarButtonItem alloc]
////                                   initWithTitle:@"Back"
////                                   style:UIBarButtonItemStyleBordered
////                                   target:self
////                                   action:@selector(flipView:)];
//
//
//
//    UIBarButtonItem * flipButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed:@"ic_back"] style:UIBarStyleDefault target:self action:nil];
//
//    navg.navigationItem.leftBarButtonItem = flipButton;
//    root.navigationItem.leftBarButtonItem = flipButton;

    
    [root presentViewController:chatVC animated:true completion:nil];
}



@end
  
