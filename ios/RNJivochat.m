
#import "RNJivochat.h"

@interface RNJivochat ()
{
    JivoSdk* jivoSdk;
    NSString *langKey;
}
@property (weak, nonatomic) IBOutlet UIWebView *JivoView;
@end

@implementation RNJivochat

@synthesize bridge = _bridge;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()
- (void)openJivoChat {
    
}
@end
  
