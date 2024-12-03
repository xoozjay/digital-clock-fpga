# 基于 Nexy4 DDR 开发板的 FPGA 数字钟项目
课程：数电实验/电子线路设计、测试及实验（二）
授课：钟--
---
所有代码均为本人独立完成，未参考 LLM ~~或圣遗物~~。

## 简要介绍
**实验目的**： 掌握使用 VerilogHDL 设计数字系统的方法
**实验目标**： 用 Verilog HDL 实现 P250 设计任务 7.4.4 设计课题 1

数字钟项目有以下几点验收任务：
**必做**:
- [x] 基础计时功能
- [x] 校时功能
- [x] （手绘模块连接图）
选做：
- [x] 任意闹钟
- [x] 12/24小时制可切换
- [x] 报整点数（几点钟 LED 闪烁几下）

## 实验环境
- Xilinx Vivado 2024.1
- Diligent Nexy4 DDR (Artix-7 series)

## 运行
将本项目导入你的 Vivado 中：
1. 打开 Vivado，确保安装了 Artix-7 系列环境
2. 菜单栏 `File` -> `Project` -> `Open...`
3. 文件选择器中，找到本地仓库的路径
4. 打开 `project_clock.xpr`
自行编译：
1. Run Synthesis
2. Run Implementation
3. Generate Bitstream
4. Open Hardware Manager - Auto Connect
5. Program Device

## 功能/模块详解
见 [module_zh.md] 咕咕咕～

## License
UNLICENSE
