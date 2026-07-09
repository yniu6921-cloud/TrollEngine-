# Trollengine

## 发布编译
make package FINALPACKAGE=1

## 清理构建缓存
make clean
rm -rf ./obj ./packages

## 多巴胺越狱
make package THEOS_PACKAGE_SCHEME=rootless


## 正式打包
FINALPACKAGE=1 make package THEOS_PACKAGE_SCHEME=rootless

# 备份
ARCHS := arm64
ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
    ARCHS = arm64 arm64e # 架构
    TARGET = iphone:clang:latest:14.0 # SDK 版本
else
    ARCHS = arm64 arm64e # 架构
    TARGET = iphone:clang:latest:14 # SDK 版本
endif
