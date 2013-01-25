//
//  DataUpdateViewController.h
//  KnessetTrivia
//
//  Created by Stav Ashuri on 1/25/13.
//
//

#import <UIKit/UIKit.h>
#import "DACircularProgressView.h"
#import "UpdateDelegateProtocol.h"

@interface UpdateViewController : UIViewController {
    IBOutlet UILabel *lblCurrentDownload;
    IBOutlet UIImageView *ivBackground;
}

@property (assign) id <UpdateDelegate> delegate;

@end
