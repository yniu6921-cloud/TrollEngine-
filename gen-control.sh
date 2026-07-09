#!/bin/sh

# 该脚本用于生成 Debian 包的控制文件
if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

VERSION=$1

# 如果存在，则删除版本中的前导“v”
VERSION=${VERSION#v}

# 创建布局目录
mkdir -p layout/DEBIAN

# 写入控制文件
cat > layout/DEBIAN/control << __EOF__
Package: com.laote.yuanbao
Name: YuanBao
Version: $VERSION
Description: Roothide Version
 注意：使用前必须通过Roothide隐藏游戏！
 兼容iOS 15+
Section: Tweaks
Depends: firmware (>= 14.0), mobilesubstrate
Architecture: iphoneos-arm
Author: Mr_Laote
Maintainer: Mr_Laote <Mr_Laote@example.com>
Icon: file:///var/jb/Applications/YuanBao.app/icon.png
__EOF__

# 设置权限
chmod 0644 layout/DEBIAN/control

RAND_BUILD_STR=$(openssl rand -hex 4)

# 编写 Info.plist 文件
defaults write $PWD/Resources/Info.plist CFBundleShortVersionString $VERSION
defaults write $PWD/Resources/Info.plist CFBundleVersion $RAND_BUILD_STR
plutil -convert xml1 $PWD/Resources/Info.plist
chmod 0644 $PWD/Resources/Info.plist

XCODE_PROJ_PBXPROJ=$PWD/YuanBao.xcodeproj/project.pbxproj
sed -i '' "s/MARKETING_VERSION = .*;/MARKETING_VERSION = $VERSION;/g" $XCODE_PROJ_PBXPROJ
