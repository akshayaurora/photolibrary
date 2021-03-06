"""
iOS Photo Library Python wrapper
=================================

"""

__all__ = ("PhotosLibrary", )

from kivy.utils import platform, reify
from kivy.event import EventDispatcher
from kivy.properties import StringProperty
from pyobjus import autoclass, protocol, objc_str

from pyobjus.protocols import protocols

protocols["PyPhotoDelegate"] = {
'imageCaptured': ('v8@0:4', 'v16@0:8'),
'captureCancelled': ('v8@0:4', 'v16@0:8')}


class PhotosLibrary(EventDispatcher):

    __events__ = (
        "on_image_captured",
        "on_capture_cancelled")

    def __init__(self):
        self.controller = None
        super(PhotosLibrary, self).__init__()

    @reify
    def pyPhotos(self):
        return autoclass('PyPhotos').alloc().init()

    def on_image_captured(self):
        ''' Default implenentation of the event.
        '''
        pass

    def on_capture_cancelled(self):
        ''' Default implementation of the event.
        '''
        pass

    def chooseFromGallery(self, filename, type='imges'):
        ''' Choose images/videos from gallery.
        '''
        if not self.pyPhotos.delegate:
            self.pyPhotos.delegate = self

        if type == 'image':
            return self.pyPhotos.chooseImageFromGallery_(filename)

    def isCameraAvailable(self):
        return self.pyPhotos.isCameraAvailable()

    def capture_image(self, filename):
        """Open Camera interface, capture image save it to filename.
        """
        if not self.pyPhotos.delegate:
            self.pyPhotos.delegate = self
        return self.pyPhotos.captureImage_(filename)

    @protocol("PyPhotoDelegate")
    def imageCaptured(self):
        self.dispatch('on_image_captured')

    @protocol("PyPhotoDelegate")
    def captureCancelled(self):
        self.dispatch('on_capture_cancelled')
