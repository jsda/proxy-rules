#!/bin/bash

set -ex

# 创建存放文件的目录
DOWNLOAD_DIR="${GITHUB_WORKSPACE}/adguard/blocklists"
mkdir -p "$DOWNLOAD_DIR"
cd ${GITHUB_WORKSPACE}/adguard

# 定义 URL 列表
URLS=(
    "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/doh.txt"
    "https://raw.githubusercontent.com/217heidai/adblockfilters/main/rules/adblockdns.txt"
)

# 下载文件
for url in "${URLS[@]}"; do
    filename="$DOWNLOAD_DIR/$(basename "$url")"

    echo "正在下载: $url"

    # 使用 wget 下载，最多重试 3 次
    wget --timeout 30 --tries 3 -qO "$filename" "$url"

    # 检查是否下载成功
    if [[ $? -ne 0 ]]; then
        echo "❌ 下载失败: $url" >> $GITHUB_STEP_SUMMARY
        exit 1
    else
        echo "✅ 下载成功: $filename"
    fi
done

# 合并所有文件
echo "🔄 正在合并文件..."
cat "$DOWNLOAD_DIR"/* > merged.txt

# 去重
echo "🧹 正在去重..."
sort merged.txt | uniq > adblockdns.txt

sing-box rule-set convert --type adguard --output "adblockdns-ios.srs" "adblockdns.txt"
mv -f "adblockdns-ios.srs" ${GITHUB_WORKSPACE}/sing-box/rule_set_site



# 定义 URL 列表
URLS=(
    "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/tif.txt"
    "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/ultimate.txt"
    "https://raw.githubusercontent.com/ppfeufer/adguard-filter-list/master/blocklist"
    "https://raw.githubusercontent.com/badmojr/1Hosts/master/Xtra/adblock.txt"
)

# 下载文件
for url in "${URLS[@]}"; do
    filename="$DOWNLOAD_DIR/$(basename "$url")"

    echo "正在下载: $url"

    # 使用 wget 下载，最多重试 3 次
    wget --timeout 30 --tries 3 -qO "$filename" "$url"

    # 检查是否下载成功
    if [[ $? -ne 0 ]]; then
        echo "❌ 下载失败: $url" >> $GITHUB_STEP_SUMMARY
        exit 1
    else
        echo "✅ 下载成功: $filename"
    fi
done

# 合并所有文件
echo "🔄 正在合并文件..."
cat "$DOWNLOAD_DIR"/* > merged.txt

# 去重
echo "🧹 正在去重..."
sort merged.txt | uniq > adblockdns.txt

sing-box rule-set convert --type adguard --output "adblockdns.srs" "adblockdns.txt"
mv -f "adblockdns.srs" ${GITHUB_WORKSPACE}/sing-box/rule_set_site

# 清理临时文件
rm -rf ./*

echo "🎉 处理完成！"



mkdir -p "$DOWNLOAD_DIR"
# 定义 URL 列表
URLS=(
    "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/doh-ips.txt"
    "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/tif-ips.txt"
)

# 下载文件
for url in "${URLS[@]}"; do
    filename="$DOWNLOAD_DIR/$(basename "$url")"

    echo "正在下载: $url"

    # 使用 wget 下载，最多重试 3 次
    wget --timeout 30 --tries 3 -qO "$filename" "$url"

    # 检查是否下载成功
    if [[ $? -ne 0 ]]; then
        echo "❌ 下载失败: $url" >> $GITHUB_STEP_SUMMARY
        exit 1
    else
        echo "✅ 下载成功: $filename"
    fi
done

# 合并所有文件
echo "🔄 正在合并文件..."
cat "$DOWNLOAD_DIR"/* > merged.txt

# 去重
echo "🧹 正在去重..."
sort merged.txt | uniq > adblock-ip.txt

${GITHUB_WORKSPACE}/adblock-sb.sh adblock-ip.txt > adblock-ip.json
sing-box rule-set compile adblock-ip.json -o ${GITHUB_WORKSPACE}/sing-box/rule_set_ip/adblock-ip.srs

# 清理临时文件
rm -rf ${GITHUB_WORKSPACE}/adguard

echo "🎉 处理完成！"
