#!/bin/bash

# 检查是否传递了正确的参数（nano 或 orin）
if [ -z "$1" ] || { [ "$1" != "nano" ] && [ "$1" != "orin" ]; }; then
    echo "Usage: $0 <nano|orin>"
    exit 1
fi

# 根据传入的参数设置相应的路径和文件名
DEVICE=$1

# 设备为 orin 时设置路径和文件名
if [ "$DEVICE" == "orin" ]; then
    DTS_DIR="./orin"
    DTBO_OUTPUT="./orin/orin_mcp251xfd.dtbo"
    OVERLAY_FILE="orin_mcp251xfd_overlay.dts"
    PREPROCESSED_FILE="orin_preprocessed.dts"
else
    DTS_DIR="./nano"
    DTBO_OUTPUT="./nano/nano_mcp251xfd.dtbo"
    OVERLAY_FILE="nano_mcp251xfd_overlay.dts"
    PREPROCESSED_FILE="nano_preprocessed.dts"
fi

# 预处理 DTS 文件
cpp -nostdinc -I ./tegra/kernel-include/ -undef -x assembler-with-cpp $DTS_DIR/$OVERLAY_FILE $DTS_DIR/$PREPROCESSED_FILE

# 转换为 DTB 文件
dtc -@ -I dts -O dtb -o $DTBO_OUTPUT $DTS_DIR/$PREPROCESSED_FILE

# 传输文件到目标设备
#10.77.19.126 orin
#192.168.103.99 nano
scp $DTBO_OUTPUT mcp251xfd.ko nvidia@192.168.103.99:/home/nvidia

