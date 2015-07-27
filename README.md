# iOS PHPhotoLibrary Python wrapper

This wrapper allows you to use the PHPhotoLibrary on iOS with Python.
This is just a custom wrapper for a couple of functions not a complete wrapper.

## Installation

### iOS

You need to use the latest kivy-ios toolchain:

    ./toolchain.py build pyPhotoLibrary

Then either create or update an Xcode project with the toolchain.

## Usage

    from pyPhotoLibrary import Photos
    photos.bind(
        on_image_captured=self.on_image_captured,
        on_capture_cancelled=self.on_capture_cancelled)
    if photos.isCameraAvailable:
        photos.capture_image(filename)
    else:
        photos.chooseFromGallery(filename)

Show a standard camera interface and return the captured image.
If the device has no camera or if the camera interface is cancelled, None
is returned.

    photos.pyPhotos

This `pyPhotos` attribute holds the pyobj reference to the actual objc
class used to interface with the PhPhotolibrary 

    def on_image_captured(self):
        print "image was successfully captured"

    def on_capture_cancelled(self):
        print('Cancelled!')


