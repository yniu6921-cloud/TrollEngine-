ARCHS := arm64 arm64e
TARGET := iphone:clang:16.0:14.0
INSTALL_TARGET_PROCESSES := Preferences

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME += YuanBaoPrefs

YuanBaoPrefs_FILES += TSPrefsRootListController.m
YuanBaoPrefs_FRAMEWORKS += UIKit
YuanBaoPrefs_PRIVATE_FRAMEWORKS += Preferences
YuanBaoPrefs_INSTALL_PATH += /Library/PreferenceBundles
YuanBaoPrefs_CFLAGS += -fobjc-arc
YuanBaoPrefs_CFLAGS += -I../supports/

include $(THEOS_MAKE_PATH)/bundle.mk
