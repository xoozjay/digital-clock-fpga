set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN M18 } [get_ports BTN_SETTINGS];  # UP
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN P17 } [get_ports BTN_LEFT];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN M17 } [get_ports BTN_RIGHT];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN N17 } [get_ports BTN_CONFIRM];   # MID
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN P18 } [get_ports BTN_CANCEL];    # DOWN

set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN V10 } [get_ports Sw_debug_clk_fast];  # LEFT 1
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN J15 } [get_ports Sw_debug_clk_12];    # RIGHT 1