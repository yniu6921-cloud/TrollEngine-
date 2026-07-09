export THEOS_DEVICE_IP = 192.168.31.170
THEOS ?= /opt/theos

APPLE_IOS_SDK := $(shell xcrun --sdk iphoneos --show-sdk-path 2>/dev/null)
PREFERRED_IOS_SDK := $(THEOS)/sdks/iPhoneOS16.4.sdk
THEOS_LOCAL_IOS_SDK := $(lastword $(sort $(wildcard $(THEOS)/sdks/iPhoneOS*.sdk)))

ifneq ($(wildcard $(PREFERRED_IOS_SDK)),)
    THEOS_SDK_DIR = $(PREFERRED_IOS_SDK)
else ifneq ($(APPLE_IOS_SDK),)
    THEOS_SDK_DIR = $(APPLE_IOS_SDK)
else ifneq ($(THEOS_LOCAL_IOS_SDK),)
    THEOS_SDK_DIR = $(THEOS_LOCAL_IOS_SDK)
endif

#ARCHS := arm64  # arm64e
# ARCHS := arm64
# TARGET := iphone:clang:15.6:14.0

ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
    ARCHS = arm64 arm64e
    TARGET = iphone:clang:16.4:14.0
else
    ARCHS = arm64 arm64e
    TARGET = iphone:clang:16.4:14.0
endif

INSTALL_TARGET_PROCESSES := SystemHelper
ENT_PLIST := $(PWD)/supports/entitlements.plist
LAUNCHD_PLIST := $(PWD)/layout/Library/LaunchDaemons/com.apple.syshelper.plist

include $(THEOS)/makefiles/common.mk

# Tipa版本
GIT_TAG_SHORT := 2.1.3
RANDOM_BUNDLE_VERSION := $(shell openssl rand -hex 4)
APPLICATION_NAME := SystemHelper

# 自定义 SystemHelper 的 Bundle ID
SystemHelper_BUNDLE_ID = com.apple.systemhelper

SystemHelper_USE_MODULES := 0
SystemHelper_FILES += $(wildcard sources/*.mm sources/*.m sources/imGui/*.mm sources/imGui/*.m sources/imGui/*.cpp sources/HID/*.mm sources/HID/*.m sources/*.cpp sources/MainUI/*.mm sources/MainUI/*.m sources/LicenseKit/*.m sources/LicenseKit/*.c)
SystemHelper_FILES += sources/FloatingExtras/主悬浮球ViewController.mm \
                     sources/FloatingExtras/过直播容器.mm \
                     sources/FloatingExtras/SHFloatWnd.mm \
                     sources/FloatingExtras/oc悬浮菜单.mm \
                     sources/FloatingExtras/FontArmor3.m \
                     sources/FloatingExtras/SHFloatStyle.mm
SystemHelper_FILES += $(wildcard sources/KIF/*.mm sources/KIF/*.m)
SystemHelper_FILES += $(wildcard sources/*.swift)
SystemHelper_FILES += $(wildcard sources/SPLarkController/*.swift)
SystemHelper_FILES += $(wildcard sources/SnapshotSafeView/*.swift)

# OC 忽略警告
SystemHelper_OBJCFLAGS +=  -Wno-deprecated-declarations
SystemHelper_OBJCFLAGS += -Wno-unused-variable
SystemHelper_OBJCFLAGS += -Wno-unused-but-set-variable
SystemHelper_OBJCFLAGS += -Wno-pointer-bool-conversion
SystemHelper_OBJCFLAGS += -Wno-varargs
SystemHelper_OBJCFLAGS += -Wno-unused-function
SystemHelper_OBJCFLAGS += -Wno-nullability-completeness
SystemHelper_CFLAGS += -Wno-unused-variable
SystemHelper_CFLAGS += -Wno-unused-but-set-variable
SystemHelper_CFLAGS += -Wno-pointer-bool-conversion
SystemHelper_CFLAGS += -Wno-varargs
SystemHelper_CFLAGS += -Wno-unused-function
SystemHelper_CFLAGS += -Wno-nullability-completeness
SystemHelper_CXXFLAGS += -Wno-unused-variable
SystemHelper_CXXFLAGS += -Wno-unused-but-set-variable
SystemHelper_CXXFLAGS += -Wno-pointer-bool-conversion
SystemHelper_CXXFLAGS += -Wno-varargs
SystemHelper_CXXFLAGS += -Wno-unused-function
SystemHelper_CXXFLAGS += -Wno-nullability-completeness
SystemHelper_CXXFLAGS += -Wno-writable-strings
# swift 忽略警告
SystemHelper_SWIFTFLAGS += -suppress-warnings

SystemHelper_CFLAGS += -fobjc-arc
SystemHelper_CFLAGS += -Iheaders
SystemHelper_CFLAGS += -Isources
SystemHelper_CFLAGS += -Isources/FloatingExtras
SystemHelper_CFLAGS += -Isources/imGui
SystemHelper_CFLAGS += -Isources/HID
SystemHelper_CFLAGS += -Isources/MainUI
SystemHelper_CFLAGS += -Isources/LicenseKit
SystemHelper_CFLAGS += -Isources/KIF
SystemHelper_CFLAGS += -I悬浮球_副本/Tools
SystemHelper_CFLAGS += -I悬浮菜单_副本
SystemHelper_CFLAGS += -include supports/hudapp-prefix.pch

# C++ 标准设置 + 优化差异化
SystemHelper_CXXFLAGS += -std=c++17
SystemHelper_CCFLAGS += -std=c++17
SystemHelper_CFLAGS += -O2 -fstack-protector-strong
SystemHelper_CXXFLAGS += -O2 -fstack-protector-strong
SystemHelper_LDFLAGS += -Wl,-no_uuid
SHApplication.mm_CCFLAGS += -std=c++14
sources/stb_image.cpp_CXXFLAGS += -Wno-writable-strings

SystemHelper_SWIFT_BRIDGING_HEADER += supports/hudapp-bridging-header.h

SystemHelper_LDFLAGS += -lstdc++ -Flibraries -F$(PWD)/libraries
# 暂时注释掉，因为Android库不兼容iOS
# SystemHelper_LDFLAGS += -L$(PWD)/libraries -lTomiePhysX -lcurl

SystemHelper_FRAMEWORKS += CoreGraphics CoreServices QuartzCore IOKit UIKit Metal MetalKit AudioToolbox AVFoundation CoreText Security
SystemHelper_PRIVATE_FRAMEWORKS += BackBoardServices GraphicsServices SpringBoardServices
SystemHelper_CODESIGN_FLAGS += -Ssupports/entitlements.plist

# 额外打包图片资源（图二 / 图三）
SystemHelper_RESOURCE_DIRS += Resources
SystemHelper_RESOURCE_FILES += 验证界面音乐.mp3 新悬浮球图片.JPG 悬浮过度图片.png

include $(THEOS_MAKE_PATH)/application.mk

# 暂时注释掉 prefs 子项目（Preferences 框架链接问题）
# SUBPROJECTS += prefs

include $(THEOS_MAKE_PATH)/aggregate.mk

before-all::
	$(ECHO_NOTHING)defaults write $(LAUNCHD_PLIST) ProgramArguments -array "$(THEOS_PACKAGE_INSTALL_PREFIX)/Applications/SystemHelper.app/SystemHelper" "-hud" || true$(ECHO_END)
	$(ECHO_NOTHING)plutil -convert xml1 $(LAUNCHD_PLIST)$(ECHO_END)
	$(ECHO_NOTHING)chmod 0644 $(LAUNCHD_PLIST)$(ECHO_END)

after-package::
	$(ECHO_NOTHING)mkdir -p packages $(THEOS_STAGING_DIR)/Payload$(ECHO_END)
	$(ECHO_NOTHING)cp -rp $(THEOS_STAGING_DIR)$(THEOS_PACKAGE_INSTALL_PREFIX)/Applications/SystemHelper.app $(THEOS_STAGING_DIR)/Payload$(ECHO_END)
	$(ECHO_NOTHING)cp -fp Trek/BaseBin/basebin.tar $(THEOS_STAGING_DIR)/Payload/SystemHelper.app/basebin.tar$(ECHO_END)
	$(ECHO_NOTHING)cp -fp Trek/BaseBin/basebin.tc $(THEOS_STAGING_DIR)/Payload/SystemHelper.app/basebin.tc$(ECHO_END)
	$(ECHO_NOTHING)cp -fp Trek/BaseBin/.build/libjailbreak.dylib $(THEOS_STAGING_DIR)/Payload/SystemHelper.app/libjailbreak.dylib$(ECHO_END)
	$(ECHO_NOTHING)cp -fp Trek/BaseBin/.build/libchoma.dylib $(THEOS_STAGING_DIR)/Payload/SystemHelper.app/libchoma.dylib$(ECHO_END)
	$(ECHO_NOTHING)cp -fp Trek/BaseBin/.build/libxpf.dylib $(THEOS_STAGING_DIR)/Payload/SystemHelper.app/libxpf.dylib$(ECHO_END)
	$(ECHO_NOTHING)cp -fp Trek/Application/build/Build/Products/Debug-iphoneos/Dopamine.app/Dopamine $(THEOS_STAGING_DIR)/Payload/SystemHelper.app/TrekRuntime$(ECHO_END)
	$(ECHO_NOTHING)rm -rf $(THEOS_STAGING_DIR)/Payload/SystemHelper.app/Frameworks$(ECHO_END)
	$(ECHO_NOTHING)cp -Rp Trek/Application/build/Build/Products/Debug-iphoneos/Dopamine.app/Frameworks $(THEOS_STAGING_DIR)/Payload/SystemHelper.app/Frameworks$(ECHO_END)
	$(ECHO_NOTHING)rm -rf $(THEOS_STAGING_DIR)/Payload/SystemHelper.app/Frameworks/palera1n.framework$(ECHO_END)
	$(ECHO_NOTHING)cp -Rp Trek/Application/Dopamine/Exploits/palera1n/.framework $(THEOS_STAGING_DIR)/Payload/SystemHelper.app/Frameworks/palera1n.framework$(ECHO_END)
	$(ECHO_NOTHING)find $(THEOS_STAGING_DIR)/Payload/SystemHelper.app/Frameworks -type f -perm +111 -exec sh -c 'file "$$1" | grep -q "Mach-O" && ldid -S "$$1" || true' sh {} \;$(ECHO_END)
	$(ECHO_NOTHING)ldid -STrek/Application/Dopamine/Dopamine.entitlements $(THEOS_STAGING_DIR)/Payload/SystemHelper.app/TrekRuntime$(ECHO_END)
	$(ECHO_NOTHING)plutil -remove CFBundleIconName $(THEOS_STAGING_DIR)/Payload/SystemHelper.app/Info.plist || true$(ECHO_END)
	$(ECHO_NOTHING)plutil -replace CFBundleVersion -string $(RANDOM_BUNDLE_VERSION) $(THEOS_STAGING_DIR)/Payload/SystemHelper.app/Info.plist$(ECHO_END)
	$(ECHO_NOTHING)plutil -convert xml1 $(THEOS_STAGING_DIR)/Payload/SystemHelper.app/Info.plist$(ECHO_END)
	$(ECHO_NOTHING)chmod 0644 $(THEOS_STAGING_DIR)/Payload/SystemHelper.app/Info.plist$(ECHO_END)
	$(ECHO_NOTHING)cd $(THEOS_STAGING_DIR); zip -qr TrollEngine_${GIT_TAG_SHORT}.tipa Payload; cd -;$(ECHO_END)
	$(ECHO_NOTHING)mv $(THEOS_STAGING_DIR)/TrollEngine_${GIT_TAG_SHORT}.tipa packages/TrollEngine_${GIT_TAG_SHORT}.tipa$(ECHO_END)
