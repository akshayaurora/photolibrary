# iOs PHPhotoLibrary Python wrapper

This wrapper allow you to use the PHPhotoLibrary on iOS with Python.

## Installation

### iOS

You need to use the latest kivy-ios toolchain:

    ./toolchain.py build pyPhotoLibrary

Then either create or update an Xcode project with the toolchain.

## Usage

	from pyPhotoLibrary import Photos
    photos.capture_image()

Show a standard camera interface and return the captured image.
If the device has no camera or if the camera interface is cancelled, None
is returned.

	Photos.save(image)

