// Code adapted inspired from https://github.com/tito/pymoodstocks as a reference
// on how to interact with ios modules and delegates, this however utilises
// cython to get a library.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
//#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#include "PyPhotos.h"

@implementation PyPhotos

- (id) init {
    self = [super init];
    return self;
}

- (int) isCameraAvailable {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // There is no camera on this device.
        return 0;
    }
    return 1;
}

- (int) captureImage:(char *)filename {
    _filename = [NSString stringWithUTF8String:filename];

    if (! [self isCameraAvailable]){
        return 0;
    }


    //    # 0 = photo lib
    //    # 1 = camera
    //    # 2 = SavedPhotoAlbums
    [self showImagePicker:1];
    return 1;
}

- (void) showImagePicker:(int) sourceType{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    if (! imagePicker.delegate){
        imagePicker.delegate = self;
    }

    imagePicker.sourceType = sourceType;

    _controller = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    [_controller presentViewController:imagePicker animated:YES completion:nil];
}

- (void) chooseFromGallery:(char *) filename{
    // Choose images from gallery

    //    # 0 = photo lib
    //    # 1 = camera
    //    # 2 = SavedPhotoAlbums
    [self showImagePicker:0];
}

- (void)imagePickerController:(UIImagePickerController *)picker
    didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //''' This is called when the camera is done capturing the image
    //'''
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker release];

        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSDictionary *metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
        NSString *mimeType = @"image/jpeg"; // ideally this would be dynamically set. Not defaulted to a jpeg!

        // you could add to the metadata dictionary (after converting it to a mutable copy) if you needed to.

        // convert to NSData
        //NSData *imageData = [self dataFromImage:image metadata:metadata mimetype:mimeType];
        //printf(imageData.bytes);

        // Save image to camera roll
        //[self savetoCameraRoll:image];

        [self saveImage:image metadata:metadata filename:_filename];

        // We can't use the metadata from here directly it's incomplete.
        //#NSString = autoclass('NSString')
        //#NSJSONSerialization = autoclass('NSJSONSerialization')
        //
        //#jsondata = NSJSONSerialization.dataWithJSONObject_options_error_(
        //#                                          metadata,
        //#                                          1,
        //#                                          None)
        //#print NSString.alloc().initWithData_usedEncoding_(
        //#    jsondata, 4).UTF8String()
    }];
}

- (void)saveImage:(UIImage *)image
             metadata:(NSDictionary *)metadata
             filename:(NSString *)filename
{
    // Create your file URL.
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSURL *outputURL = [NSURL fileURLWithPath:filename];
    // Set your compression quuality (0.0 to 1.0).
    NSMutableDictionary *mutableMetadata = [metadata mutableCopy];
    [mutableMetadata setObject:@(1.0) forKey:(__bridge NSString *)kCGImageDestinationLossyCompressionQuality];

    // Create an image destination.
    CGImageDestinationRef imageDestination = CGImageDestinationCreateWithURL((__bridge CFURLRef)outputURL, kUTTypeJPEG , 1, NULL);
    if (imageDestination == NULL ) {

        // Handle failure.
        NSLog(@"Error -> failed to create image destination.");
        return;
    }

    // Add your image to the destination.
    CGImageDestinationAddImage(imageDestination, image.CGImage, (__bridge CFDictionaryRef)mutableMetadata);

    // Finalize the destination.
    if (CGImageDestinationFinalize(imageDestination) == NO) {

        // Handle failure.
        NSLog(@"Error -> failed to finalize the image.");
    }
    
    CFRelease(imageDestination);
    NSLog(@"Image saved successfully");
    [self.delegate imageCaptured];
}

- (void)savetoCameraRoll: (UIImage *)image{

    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // Request creating an asset from the image.
        PHAssetChangeRequest *createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];

        // Get a placeholder for the new asset and add it to the album editing request.
        PHObjectPlaceholder *assetPlaceholder = [createAssetRequest placeholderForCreatedAsset];

        // Request editing the album.
        //PHAssetCollectionChangeRequest *albumChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:album];

        //[albumChangeRequest addAssets:@[ assetPlaceholder ]];

    } completionHandler:^(BOOL success, NSError *error) {
        NSLog(@"Finished adding asset. %@", (success ? @"Success" : error));
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end