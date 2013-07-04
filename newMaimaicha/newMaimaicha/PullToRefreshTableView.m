
#import "PullToRefreshTableView.h"
#import <QuartzCore/QuartzCore.h>
/**
 *
 * StateView 顶部和底部状态视图
 *
 **/

@implementation StateView

@synthesize indicatorView;
@synthesize stateLabel;
@synthesize viewType;
@synthesize currentState;

- (id)initWithFrame:(CGRect)frame viewType:(int)type{
    CGFloat width = frame.size.width;
    
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, width, k_STATE_VIEW_HEIGHT)];
    
    if (self) {
        //  设置当前视图类型
        viewType = type;
        self.backgroundColor = [UIColor clearColor];
        //  初始化状态提示文本
        stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, width, 20)];
        stateLabel.font = [UIFont systemFontOfSize:12.0f];
        stateLabel.backgroundColor = [UIColor clearColor];
        stateLabel.textAlignment = NSTextAlignmentCenter;
        stateLabel.text = @"";
        [self addSubview:stateLabel];
        
        //  初始化加载指示器（菊花圈）  
        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(220,10, 20, 20)];
        indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        indicatorView.hidesWhenStopped = YES;
        [self addSubview:indicatorView];
    }
    return self;
}

- (void)changeState:(int)state{
    
    [indicatorView stopAnimating];
    [UIView beginAnimations:nil context:nil];
    switch (state) {
        case k_PULL_STATE_NORMAL:
            currentState = k_PULL_STATE_NORMAL;
            if (self.viewType == k_VIEW_TYPE_HEADER) {
                stateLabel.text = @"下拉加载最新";
            } else {
                stateLabel.text = @"往上拖加载更多";
            }
            break;
            
        case k_PULL_STATE_LOAD:
            currentState = k_PULL_STATE_LOAD;
            stateLabel.text = @"正在加载..";
            [indicatorView startAnimating];
            break;
            
        case k_PULL_STATE_END:
            currentState = k_PULL_STATE_END;
            stateLabel.text = @"已全部显示";
            break;
        case  k_PULL_STATE_NOScroll:
            currentState = k_PULL_STATE_NOScroll;
            stateLabel.text = @"";
            break;
        default:
            currentState = k_PULL_STATE_NOScroll;
            if (self.viewType == k_VIEW_TYPE_HEADER) {
                stateLabel.text = @"下拉加载最新";
            } else {
                stateLabel.text = @"往上拖加载更多";
            }
            break;
    }
    [UIView commitAnimations];
}
- (void)dealloc{
}

@end


/**
 *
 * PullToRefreshTableView 拖动刷新/加载 表格视图
 *
 **/


@implementation PullToRefreshTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        footerView = [[StateView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) viewType:k_VIEW_TYPE_FOOTER];
        [self setTableFooterView:footerView];
        headerView = [[StateView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) viewType:k_VIEW_TYPE_HEADER];
        headerView.stateLabel.text = @"下拉加载更多";
        [self setTableHeaderView:headerView];
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y-k_STATE_VIEW_HEIGHT, self.frame.size.width, self.frame.size.height+k_STATE_VIEW_HEIGHT)];
    }
    return self;
}

- (void)dealloc{

}

- (void)tableViewDidDragging{
    CGFloat offsetY = self.contentOffset.y;
    
    if (footerView.currentState==k_PULL_STATE_END || footerView.currentState==k_PULL_STATE_NOScroll) {
        return;
    } 
    if (footerView.currentState == k_PULL_STATE_LOAD) {
        return;
    }
    if (headerView.currentState == k_PULL_STATE_LOAD) {
        return;
    }
    
    //  计算表内容大小与窗体大小的实际差距
    CGFloat differenceY = self.contentSize.height > self.frame.size.height ? (self.contentSize.height - self.frame.size.height) : 0;
    //  改变“上拖加载更多”视图的文字提示
    if (offsetY > differenceY + k_STATE_VIEW_HEIGHT / 3 * 2) {
    } else {
        [footerView changeState:k_PULL_STATE_NORMAL];
    }
}

- (int)tableViewDidEndDragging{
    CGFloat offsetY = self.contentOffset.y;
    if (footerView.currentState == k_PULL_STATE_LOAD || headerView.currentState == k_PULL_STATE_LOAD) {
        return k_RETURN_DO_NOTHING;
    }
    if ((0 - offsetY) > k_STATE_VIEW_HEIGHT / 3 * 2) {
        [headerView changeState:k_PULL_STATE_LOAD];
        return k_RETURN_REFRESH;
    }
    CGFloat differenceY = self.contentSize.height > self.frame.size.height ? (self.contentSize.height - self.frame.size.height) : 0;
    if (footerView.currentState != k_PULL_STATE_END && footerView.currentState != k_PULL_STATE_NOScroll &&
        offsetY > differenceY + k_STATE_VIEW_HEIGHT / 3 * 2) {
        [footerView changeState:k_PULL_STATE_LOAD];
        return k_RETURN_LOADMORE;
    }
    return k_RETURN_DO_NOTHING;
}

- (void)reloadData:(BOOL)dataIsAllLoaded{
    [self reloadData];
    self.contentInset = UIEdgeInsetsZero;
    if (dataIsAllLoaded) {
        [footerView changeState:k_PULL_STATE_NORMAL];
    } else {
        [footerView changeState:k_PULL_STATE_END];//k_PULL_STATE_END
    }
    [headerView changeState:k_PULL_STATE_NORMAL];
}
- (void)tablewsetState:(BOOL)statesIsEnd{
    if (statesIsEnd) {
         [footerView changeState:k_PULL_STATE_NOScroll];
    } else {
        [footerView changeState:k_PULL_STATE_NORMAL];
        //k_PULL_STATE_END
    }
}

@end