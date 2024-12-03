create_clock -period 10 [get_ports clk];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN E3 } [get_ports clk];

set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN R11 } [get_ports LED];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN N15 } [get_ports LED_ALERT_R];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN R12 } [get_ports LED_ALERT_B];

set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN T10 } [get_ports CA];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN R10 } [get_ports CB];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN K16 } [get_ports CC];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN K13 } [get_ports CD];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN P15 } [get_ports CE];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN T11 } [get_ports CF];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN L18 } [get_ports CG];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN H15 } [get_ports DP];

set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN U13 } [get_ports AN[7]];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN K2 } [get_ports AN[6]];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN T14 } [get_ports AN[5]];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN P14 } [get_ports AN[4]];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN J14 } [get_ports AN[3]];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN T9 } [get_ports AN[2]];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN J18 } [get_ports AN[1]];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN J17 } [get_ports AN[0]];


