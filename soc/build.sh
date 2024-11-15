#!/bin/bash
cpp -nostdinc -I  ./tegra/kernel-include/  -undef -x assembler-with-cpp ./orin/orin_mcp251xfd_overlay.dts ./orin/orin_preprocessed.dts
dtc -@ -I dts -O dtb -o ./orin/orin_mcp251xfd.dtbo  ./orin/orin_preprocessed.dts
scp ./orin/orin_mcp251xfd.dtbo nvidia@192.168.103.92:/home/nvidia