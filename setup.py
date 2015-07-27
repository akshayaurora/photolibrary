#!/usr/bin/env python
from distutils.core import setup, Extension
import os

setup(name='ios',
      version='1.0',
      ext_modules=[
                   Extension(
                             'photolibrary', ['photolibrary.c', 'PyPhotos.m'],
                             libraries=[ ],
                             library_dirs=[],
                             )
                   ]
      )