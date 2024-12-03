set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN M18 } [get_ports BTN_SETTINGS];  # UP
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN P17 } [get_ports BTN_LEFT];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN M17 } [get_ports BTN_RIGHT];
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN N17 } [get_ports BTN_CONFIRM];   # MID
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN P18 } [get_ports BTN_CANCEL];    # DOWN

set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN V10 } [get_ports Sw_debug_clk_fast];  # LEFT 1
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN J15 } [get_ports Sw_debug_clk_12];    # RIGHT 1
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN L16 } [get_ports Sw_debug_time_set];  # RIGHT 2
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN U12 } [get_ports Sw_debug_set_hr]; 
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN H6 } [get_ports Sw_debug_set_min]; 
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN T13 } [get_ports Sw_debug_set_sec]; 
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN U8 } [get_ports Sw_debug_clock_hr]; 
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN T8 } [get_ports Sw_debug_clock_min]; 
set_property -dict { IOSTANDARD LVCMOS33 PACKAGE_PIN R13 } [get_ports Sw_debug_clock_sec]; 