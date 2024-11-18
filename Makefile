SHELL := /bin/bash

BASE.DIR=$(PWD)
DOWNLOADS.DIR=$(BASE.DIR)/downloads
INSTALLED.HOST.DIR=$(BASE.DIR)/installed.host

# https://github.com/opencv/opencv/archive/refs/tags/4.10.0.tar.gz
OPENCV.VERSION=4.10.0
OPENCV.DIR=$(DOWNLOADS.DIR)/opencv-$(OPENCV.VERSION)
OPENCV.ARCHIVE=$(OPENCV.VERSION).tar.gz
OPENCV.URL=https://github.com/opencv/opencv/archive/refs/tags/$(OPENCV.ARCHIVE)
OPENCV_CONTRIB.URL=https://github.com/opencv/opencv_contrib/archive/refs/tags/$(OPENCV.ARCHIVE)
OPENCV.BUILD=$(DOWNLOADS.DIR)/build.opencv

opencv.fetch: .FORCE
	mkdir -p $(DOWNLOADS.DIR) && rm -rf opencv-$(OPENCV.ARCHIVE) && rm -rf opencv_contrib-$(OPENCV.ARCHIVE)
	cd $(DOWNLOADS.DIR) && wget $(OPENCV.URL) -O opencv-$(OPENCV.ARCHIVE) && wget $(OPENCV_CONTRIB.URL) -O opencv_contrib-$(OPENCV.ARCHIVE)
	cd $(DOWNLOADS.DIR) && tar xf opencv-$(OPENCV.ARCHIVE) && tar xf opencv_contrib-$(OPENCV.ARCHIVE)

opencv: .FORCE	
	rm -rf $(OPENCV.BUILD) && mkdir -p $(OPENCV.BUILD) && mkdir -p $(INSTALLED.HOST.DIR)
	cd $(OPENCV.BUILD) && cmake $(OPENCV.DIR) -DOPENCV_EXTRA_MODULES_PATH=$(DOWNLOADS.DIR)/opencv_contrib-$(OPENCV.VERSION)/modules -DCMAKE_INSTALL_PREFIX=$(INSTALLED.HOST.DIR) && cmake --build . && make -j8 install

.FORCE: