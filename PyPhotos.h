#ifndef __PHOTOS_WRAPPER
#define __PHOTOS_WRAPPER

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PyPhotoDelegate <NSObject>

- (void)imageCaptured;

@end


@interface PyPhotos : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    
    NSObject *_delegate;
    UIViewController *_controller;
    NSString *_filename;
}

@property id delegate;

@end

#endif
