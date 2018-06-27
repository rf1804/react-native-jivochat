
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
    
    [root presentViewController:chatVC animated:true completion:nil];
}



@end
  
