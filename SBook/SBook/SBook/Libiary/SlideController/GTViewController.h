//
//  GTViewController.h
//  GHSidebarNav
//
//  Created by Greg Haines on 11/20/11.
//

#import <Foundation/Foundation.h>

typedef void (^RevealBlock)();

@interface GTViewController : UIViewController {
@private
	RevealBlock _revealBlock;
}

- (id)initWithTitle:(NSString *)title
          imageName:(NSString *) imageName
        revealBlock:(RevealBlock)revealBlock;

@end
