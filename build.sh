#!/bin/bash

# ===================== 颜色和样式定义 =====================
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m' # 重置颜色

BOLD='\033[1m'
UNDERLINE='\033[4m'

# ===================== 功能函数 =====================
function header() {
    echo -e "${MAGENTA}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC} ${BOLD}🚀 YUANBAO 构建脚本 1.0.2${NC}                        ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
}

function footer() {
    echo ""
    echo -e "${MAGENTA}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC} ${BOLD}🏁 构建完成${NC}                                      ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════════════╝${NC}"
}

function success() {
    echo -e "${GREEN}✓ ${1}${NC}"
}

function info() {
    echo -e "${BLUE}ℹ ${1}${NC}"
}

function warning() {
    echo -e "${YELLOW}⚠ ${1}${NC}"
}

function error() {
    echo -e "${RED}✗ ${1}${NC}" >&2
    exit 1
}

function check_command() {
    if ! command -v $1 &> /dev/null; then
        error "未找到命令 $1。请安装后重试。"
    fi
}

# ===================== 主脚本 =====================
header

# 检查版本参数
if [ $# -ne 1 ]; then
    echo -e "用法: ${BOLD}$0 <版本号>${NC}"
    echo -e "示例: ${BOLD}$0 v1.2.3${NC}"
    error "必须提供版本参数"
fi

VERSION=$1
VERSION=${VERSION#v}

info "开始构建版本: ${BOLD}${VERSION}${NC}"

# 检查必要命令
check_command xcodebuild
check_command codesign
check_command ldid
check_command zip

# 清理并构建
info "运行 xcodebuild..."
xcodebuild clean build archive \
    -scheme YuanBao \
    -project YuanBao.xcodeproj \
    -sdk iphoneos \
    -destination 'generic/platform=iOS' \
    -archivePath YuanBao \
    CODE_SIGNING_ALLOWED=NO | xcpretty || {
    error "构建失败"
}

# 准备签名
info "准备签名..."
chmod 0644 Resources/Info.plist || warning "无法修改 Info.plist 的权限"
cp supports/entitlements.plist YuanBao.xcarchive/Products || error "无法复制 entitlements.plist"

# 移除现有签名
info "移除现有签名..."
cd YuanBao.xcarchive/Products/Applications || error "无法进入 Applications 目录"
codesign --remove-signature YuanBao.app || error "无法移除签名"
cd - > /dev/null

# 使用 ldid 重新签名
info "使用 ldid 重新签名..."
cd YuanBao.xcarchive/Products || error "无法进入 Products 目录"
mv Applications Payload || error "无法将 Applications 重命名为 Payload"
ldid -Sentitlements.plist Payload/YuanBao.app || error "签名失败"
chmod 0644 Payload/YuanBao.app/Info.plist || warning "无法修改已签名 Info.plist 的权限"

# 创建 IPA 包
info "创建 IPA 包..."
zip -qr YuanBao.tipa Payload || error "无法创建 IPA 包"
cd - > /dev/null

# 移动到 packages 目录
info "移动最终包..."
mkdir -p packages || error "无法创建 packages 目录"
mv YuanBao.xcarchive/Products/YuanBao.tipa packages/YuanBao+AppIntents16_$VERSION.tipa || error "无法移动最终包"

success "构建成功完成！"
info "包已创建于: ${BOLD}packages/YuanBao+AppIntents16_${VERSION}.tipa${NC}"

footer
