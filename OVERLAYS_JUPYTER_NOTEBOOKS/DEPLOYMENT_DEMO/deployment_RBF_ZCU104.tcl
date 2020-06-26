
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2019.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xczu7ev-ffvc1156-2-e
   set_property BOARD_PART xilinx.com:zcu104:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:zynq_ultra_ps_e:3.3\
xilinx.com:ip:axi_dma:7.1\
xilinx.com:hls:geometric_values_rbf_top:1.0\
xilinx.com:hls:get_w:1.0\
xilinx.com:hls:test_predictions_top:1.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: test_predictions_1
proc create_hier_cell_test_predictions_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_test_predictions_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE2


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: dma_ds, and set properties
  set dma_ds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_ds ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_ds

  # Create instance: dma_gv, and set properties
  set dma_gv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_gv ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_gv

  # Create instance: dma_tp, and set properties
  set dma_tp [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_tp ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_tp

  # Create instance: test_predictions_top, and set properties
  set test_predictions_top [ create_bd_cell -type ip -vlnv xilinx.com:hls:test_predictions_top:1.0 test_predictions_top ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins dma_gv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins dma_ds/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_LITE2] [get_bd_intf_pins dma_tp/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins dma_gv/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins dma_ds/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins dma_tp/M_AXI_S2MM]
  connect_bd_intf_net -intf_net dma_ds_M_AXIS_MM2S [get_bd_intf_pins dma_ds/M_AXIS_MM2S] [get_bd_intf_pins test_predictions_top/dataset_details]
  connect_bd_intf_net -intf_net dma_gv_M_AXIS_MM2S [get_bd_intf_pins dma_gv/M_AXIS_MM2S] [get_bd_intf_pins test_predictions_top/geometric_values]
  connect_bd_intf_net -intf_net test_predictions_top_test_predictions_out [get_bd_intf_pins dma_tp/S_AXIS_S2MM] [get_bd_intf_pins test_predictions_top/test_predictions_out]

  # Create port connections
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins dma_ds/axi_resetn] [get_bd_pins dma_gv/axi_resetn] [get_bd_pins dma_tp/axi_resetn] [get_bd_pins test_predictions_top/ap_rst_n]
  connect_bd_net -net s_axi_lite_aclk_1 [get_bd_pins s_axi_lite_aclk] [get_bd_pins dma_ds/m_axi_mm2s_aclk] [get_bd_pins dma_ds/s_axi_lite_aclk] [get_bd_pins dma_gv/m_axi_mm2s_aclk] [get_bd_pins dma_gv/s_axi_lite_aclk] [get_bd_pins dma_tp/m_axi_s2mm_aclk] [get_bd_pins dma_tp/s_axi_lite_aclk] [get_bd_pins test_predictions_top/ap_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: get_w_1
proc create_hier_cell_get_w_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_get_w_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE3


  # Create pins
  create_bd_pin -dir I -type clk ap_clk
  create_bd_pin -dir I -type rst ap_rst_n

  # Create instance: dma_cf, and set properties
  set dma_cf [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_cf ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_cf

  # Create instance: dma_ds, and set properties
  set dma_ds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_ds ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_ds

  # Create instance: dma_nw, and set properties
  set dma_nw [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_nw ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_nw

  # Create instance: dma_sv, and set properties
  set dma_sv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_sv ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_sv

  # Create instance: get_w, and set properties
  set get_w [ create_bd_cell -type ip -vlnv xilinx.com:hls:get_w:1.0 get_w ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins dma_ds/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins dma_cf/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_LITE2] [get_bd_intf_pins dma_sv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI_LITE3] [get_bd_intf_pins dma_nw/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins dma_ds/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins dma_cf/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M_AXI_MM2S2] [get_bd_intf_pins dma_sv/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins dma_nw/M_AXI_S2MM]
  connect_bd_intf_net -intf_net dma_cf_M_AXIS_MM2S [get_bd_intf_pins dma_cf/M_AXIS_MM2S] [get_bd_intf_pins get_w/sv_coeffs]
  connect_bd_intf_net -intf_net dma_ds_M_AXIS_MM2S [get_bd_intf_pins dma_ds/M_AXIS_MM2S] [get_bd_intf_pins get_w/ds_details_in]
  connect_bd_intf_net -intf_net dma_sv_M_AXIS_MM2S [get_bd_intf_pins dma_sv/M_AXIS_MM2S] [get_bd_intf_pins get_w/data_matrices]
  connect_bd_intf_net -intf_net get_w_norm_w_out [get_bd_intf_pins dma_nw/S_AXIS_S2MM] [get_bd_intf_pins get_w/norm_w_out]

  # Create port connections
  connect_bd_net -net ap_clk_1 [get_bd_pins ap_clk] [get_bd_pins dma_cf/m_axi_mm2s_aclk] [get_bd_pins dma_cf/s_axi_lite_aclk] [get_bd_pins dma_ds/m_axi_mm2s_aclk] [get_bd_pins dma_ds/s_axi_lite_aclk] [get_bd_pins dma_nw/m_axi_s2mm_aclk] [get_bd_pins dma_nw/s_axi_lite_aclk] [get_bd_pins dma_sv/m_axi_mm2s_aclk] [get_bd_pins dma_sv/s_axi_lite_aclk] [get_bd_pins get_w/ap_clk]
  connect_bd_net -net ap_rst_n_1 [get_bd_pins ap_rst_n] [get_bd_pins dma_cf/axi_resetn] [get_bd_pins dma_ds/axi_resetn] [get_bd_pins dma_nw/axi_resetn] [get_bd_pins dma_sv/axi_resetn] [get_bd_pins get_w/ap_rst_n]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: geometric_values_11
proc create_hier_cell_geometric_values_11 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_geometric_values_11() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE4


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: dma_cf, and set properties
  set dma_cf [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_cf ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_cf

  # Create instance: dma_ds, and set properties
  set dma_ds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_ds ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_ds

  # Create instance: dma_gv, and set properties
  set dma_gv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_gv ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_gv

  # Create instance: dma_sv, and set properties
  set dma_sv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_sv ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_sv

  # Create instance: dma_tm, and set properties
  set dma_tm [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_tm ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_tm

  # Create instance: geometric_values_rbf, and set properties
  set geometric_values_rbf [ create_bd_cell -type ip -vlnv xilinx.com:hls:geometric_values_rbf_top:1.0 geometric_values_rbf ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins dma_tm/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins dma_ds/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_LITE2] [get_bd_intf_pins dma_cf/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI_LITE3] [get_bd_intf_pins dma_sv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI_LITE4] [get_bd_intf_pins dma_gv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins dma_tm/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins dma_ds/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins M_AXI_MM2S2] [get_bd_intf_pins dma_cf/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins M_AXI_MM2S3] [get_bd_intf_pins dma_sv/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins dma_gv/M_AXI_S2MM]
  connect_bd_intf_net -intf_net dma_cf_M_AXIS_MM2S [get_bd_intf_pins dma_cf/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/sv_coeffs]
  connect_bd_intf_net -intf_net dma_ds_M_AXIS_MM2S [get_bd_intf_pins dma_ds/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/classification_details]
  connect_bd_intf_net -intf_net dma_sv_M_AXIS_MM2S [get_bd_intf_pins dma_sv/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/support_vectors]
  connect_bd_intf_net -intf_net dma_tm_M_AXIS_MM2S [get_bd_intf_pins dma_tm/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/testing_matrix]
  connect_bd_intf_net -intf_net geometric_values_rbf_geometric_values_out [get_bd_intf_pins dma_gv/S_AXIS_S2MM] [get_bd_intf_pins geometric_values_rbf/geometric_values_out]

  # Create port connections
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins dma_cf/axi_resetn] [get_bd_pins dma_ds/axi_resetn] [get_bd_pins dma_gv/axi_resetn] [get_bd_pins dma_sv/axi_resetn] [get_bd_pins dma_tm/axi_resetn] [get_bd_pins geometric_values_rbf/ap_rst_n]
  connect_bd_net -net s_axi_lite_aclk_1 [get_bd_pins s_axi_lite_aclk] [get_bd_pins dma_cf/m_axi_mm2s_aclk] [get_bd_pins dma_cf/s_axi_lite_aclk] [get_bd_pins dma_ds/m_axi_mm2s_aclk] [get_bd_pins dma_ds/s_axi_lite_aclk] [get_bd_pins dma_gv/m_axi_s2mm_aclk] [get_bd_pins dma_gv/s_axi_lite_aclk] [get_bd_pins dma_sv/m_axi_mm2s_aclk] [get_bd_pins dma_sv/s_axi_lite_aclk] [get_bd_pins dma_tm/m_axi_mm2s_aclk] [get_bd_pins dma_tm/s_axi_lite_aclk] [get_bd_pins geometric_values_rbf/ap_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: geometric_values_10
proc create_hier_cell_geometric_values_10 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_geometric_values_10() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE4


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: dma_cf, and set properties
  set dma_cf [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_cf ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_cf

  # Create instance: dma_ds, and set properties
  set dma_ds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_ds ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_ds

  # Create instance: dma_gv, and set properties
  set dma_gv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_gv ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_gv

  # Create instance: dma_sv, and set properties
  set dma_sv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_sv ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_sv

  # Create instance: dma_tm, and set properties
  set dma_tm [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_tm ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_tm

  # Create instance: geometric_values_rbf, and set properties
  set geometric_values_rbf [ create_bd_cell -type ip -vlnv xilinx.com:hls:geometric_values_rbf_top:1.0 geometric_values_rbf ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins dma_tm/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins dma_ds/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_LITE2] [get_bd_intf_pins dma_cf/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI_LITE3] [get_bd_intf_pins dma_sv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI_LITE4] [get_bd_intf_pins dma_gv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins dma_tm/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins dma_ds/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins M_AXI_MM2S2] [get_bd_intf_pins dma_cf/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins M_AXI_MM2S3] [get_bd_intf_pins dma_sv/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins dma_gv/M_AXI_S2MM]
  connect_bd_intf_net -intf_net dma_cf_M_AXIS_MM2S [get_bd_intf_pins dma_cf/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/sv_coeffs]
  connect_bd_intf_net -intf_net dma_ds_M_AXIS_MM2S [get_bd_intf_pins dma_ds/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/classification_details]
  connect_bd_intf_net -intf_net dma_sv_M_AXIS_MM2S [get_bd_intf_pins dma_sv/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/support_vectors]
  connect_bd_intf_net -intf_net dma_tm_M_AXIS_MM2S [get_bd_intf_pins dma_tm/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/testing_matrix]
  connect_bd_intf_net -intf_net geometric_values_rbf_geometric_values_out [get_bd_intf_pins dma_gv/S_AXIS_S2MM] [get_bd_intf_pins geometric_values_rbf/geometric_values_out]

  # Create port connections
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins dma_cf/axi_resetn] [get_bd_pins dma_ds/axi_resetn] [get_bd_pins dma_gv/axi_resetn] [get_bd_pins dma_sv/axi_resetn] [get_bd_pins dma_tm/axi_resetn] [get_bd_pins geometric_values_rbf/ap_rst_n]
  connect_bd_net -net s_axi_lite_aclk_1 [get_bd_pins s_axi_lite_aclk] [get_bd_pins dma_cf/m_axi_mm2s_aclk] [get_bd_pins dma_cf/s_axi_lite_aclk] [get_bd_pins dma_ds/m_axi_mm2s_aclk] [get_bd_pins dma_ds/s_axi_lite_aclk] [get_bd_pins dma_gv/m_axi_s2mm_aclk] [get_bd_pins dma_gv/s_axi_lite_aclk] [get_bd_pins dma_sv/m_axi_mm2s_aclk] [get_bd_pins dma_sv/s_axi_lite_aclk] [get_bd_pins dma_tm/m_axi_mm2s_aclk] [get_bd_pins dma_tm/s_axi_lite_aclk] [get_bd_pins geometric_values_rbf/ap_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: geometric_values_9
proc create_hier_cell_geometric_values_9 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_geometric_values_9() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE4


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: dma_cf, and set properties
  set dma_cf [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_cf ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_cf

  # Create instance: dma_ds, and set properties
  set dma_ds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_ds ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_ds

  # Create instance: dma_gv, and set properties
  set dma_gv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_gv ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_gv

  # Create instance: dma_sv, and set properties
  set dma_sv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_sv ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_sv

  # Create instance: dma_tm, and set properties
  set dma_tm [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_tm ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_tm

  # Create instance: geometric_values_rbf, and set properties
  set geometric_values_rbf [ create_bd_cell -type ip -vlnv xilinx.com:hls:geometric_values_rbf_top:1.0 geometric_values_rbf ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins dma_tm/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins dma_ds/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_LITE2] [get_bd_intf_pins dma_cf/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI_LITE3] [get_bd_intf_pins dma_sv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI_LITE4] [get_bd_intf_pins dma_gv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins dma_cf/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins dma_tm/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins M_AXI_MM2S2] [get_bd_intf_pins dma_ds/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins M_AXI_MM2S3] [get_bd_intf_pins dma_sv/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins dma_gv/M_AXI_S2MM]
  connect_bd_intf_net -intf_net dma_cf_M_AXIS_MM2S [get_bd_intf_pins dma_cf/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/sv_coeffs]
  connect_bd_intf_net -intf_net dma_ds_M_AXIS_MM2S [get_bd_intf_pins dma_ds/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/classification_details]
  connect_bd_intf_net -intf_net dma_sv_M_AXIS_MM2S [get_bd_intf_pins dma_sv/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/support_vectors]
  connect_bd_intf_net -intf_net dma_tm_M_AXIS_MM2S [get_bd_intf_pins dma_tm/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/testing_matrix]
  connect_bd_intf_net -intf_net geometric_values_rbf_geometric_values_out [get_bd_intf_pins dma_gv/S_AXIS_S2MM] [get_bd_intf_pins geometric_values_rbf/geometric_values_out]

  # Create port connections
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins dma_cf/axi_resetn] [get_bd_pins dma_ds/axi_resetn] [get_bd_pins dma_gv/axi_resetn] [get_bd_pins dma_sv/axi_resetn] [get_bd_pins dma_tm/axi_resetn] [get_bd_pins geometric_values_rbf/ap_rst_n]
  connect_bd_net -net s_axi_lite_aclk_1 [get_bd_pins s_axi_lite_aclk] [get_bd_pins dma_cf/m_axi_mm2s_aclk] [get_bd_pins dma_cf/s_axi_lite_aclk] [get_bd_pins dma_ds/m_axi_mm2s_aclk] [get_bd_pins dma_ds/s_axi_lite_aclk] [get_bd_pins dma_gv/m_axi_s2mm_aclk] [get_bd_pins dma_gv/s_axi_lite_aclk] [get_bd_pins dma_sv/m_axi_mm2s_aclk] [get_bd_pins dma_sv/s_axi_lite_aclk] [get_bd_pins dma_tm/m_axi_mm2s_aclk] [get_bd_pins dma_tm/s_axi_lite_aclk] [get_bd_pins geometric_values_rbf/ap_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: geometric_values_8
proc create_hier_cell_geometric_values_8 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_geometric_values_8() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE4


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: dma_cf, and set properties
  set dma_cf [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_cf ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_cf

  # Create instance: dma_ds, and set properties
  set dma_ds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_ds ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_ds

  # Create instance: dma_gv, and set properties
  set dma_gv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_gv ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_gv

  # Create instance: dma_sv, and set properties
  set dma_sv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_sv ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_sv

  # Create instance: dma_tm, and set properties
  set dma_tm [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_tm ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_tm

  # Create instance: geometric_values_rbf, and set properties
  set geometric_values_rbf [ create_bd_cell -type ip -vlnv xilinx.com:hls:geometric_values_rbf_top:1.0 geometric_values_rbf ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins dma_tm/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins dma_ds/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_LITE2] [get_bd_intf_pins dma_cf/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI_LITE3] [get_bd_intf_pins dma_sv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI_LITE4] [get_bd_intf_pins dma_gv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins dma_tm/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins dma_ds/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins M_AXI_MM2S2] [get_bd_intf_pins dma_cf/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins M_AXI_MM2S3] [get_bd_intf_pins dma_sv/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins dma_gv/M_AXI_S2MM]
  connect_bd_intf_net -intf_net dma_cf_M_AXIS_MM2S [get_bd_intf_pins dma_cf/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/sv_coeffs]
  connect_bd_intf_net -intf_net dma_ds_M_AXIS_MM2S [get_bd_intf_pins dma_ds/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/classification_details]
  connect_bd_intf_net -intf_net dma_sv_M_AXIS_MM2S [get_bd_intf_pins dma_sv/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/support_vectors]
  connect_bd_intf_net -intf_net dma_tm_M_AXIS_MM2S [get_bd_intf_pins dma_tm/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/testing_matrix]
  connect_bd_intf_net -intf_net geometric_values_rbf_geometric_values_out [get_bd_intf_pins dma_gv/S_AXIS_S2MM] [get_bd_intf_pins geometric_values_rbf/geometric_values_out]

  # Create port connections
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins dma_cf/axi_resetn] [get_bd_pins dma_ds/axi_resetn] [get_bd_pins dma_gv/axi_resetn] [get_bd_pins dma_sv/axi_resetn] [get_bd_pins dma_tm/axi_resetn] [get_bd_pins geometric_values_rbf/ap_rst_n]
  connect_bd_net -net s_axi_lite_aclk_1 [get_bd_pins s_axi_lite_aclk] [get_bd_pins dma_cf/m_axi_mm2s_aclk] [get_bd_pins dma_cf/s_axi_lite_aclk] [get_bd_pins dma_ds/m_axi_mm2s_aclk] [get_bd_pins dma_ds/s_axi_lite_aclk] [get_bd_pins dma_gv/m_axi_s2mm_aclk] [get_bd_pins dma_gv/s_axi_lite_aclk] [get_bd_pins dma_sv/m_axi_mm2s_aclk] [get_bd_pins dma_sv/s_axi_lite_aclk] [get_bd_pins dma_tm/m_axi_mm2s_aclk] [get_bd_pins dma_tm/s_axi_lite_aclk] [get_bd_pins geometric_values_rbf/ap_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: geometric_values_7
proc create_hier_cell_geometric_values_7 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_geometric_values_7() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE4


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: dma_cf, and set properties
  set dma_cf [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_cf ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_cf

  # Create instance: dma_ds, and set properties
  set dma_ds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_ds ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_ds

  # Create instance: dma_gv, and set properties
  set dma_gv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_gv ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_gv

  # Create instance: dma_sv, and set properties
  set dma_sv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_sv ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_sv

  # Create instance: dma_tm, and set properties
  set dma_tm [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_tm ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_tm

  # Create instance: geometric_values_rbf, and set properties
  set geometric_values_rbf [ create_bd_cell -type ip -vlnv xilinx.com:hls:geometric_values_rbf_top:1.0 geometric_values_rbf ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins dma_tm/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins dma_ds/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_LITE2] [get_bd_intf_pins dma_cf/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI_LITE3] [get_bd_intf_pins dma_sv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI_LITE4] [get_bd_intf_pins dma_gv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins dma_tm/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins dma_ds/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins M_AXI_MM2S2] [get_bd_intf_pins dma_cf/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins M_AXI_MM2S3] [get_bd_intf_pins dma_sv/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins dma_gv/M_AXI_S2MM]
  connect_bd_intf_net -intf_net dma_cf_M_AXIS_MM2S [get_bd_intf_pins dma_cf/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/sv_coeffs]
  connect_bd_intf_net -intf_net dma_ds_M_AXIS_MM2S [get_bd_intf_pins dma_ds/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/classification_details]
  connect_bd_intf_net -intf_net dma_sv_M_AXIS_MM2S [get_bd_intf_pins dma_sv/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/support_vectors]
  connect_bd_intf_net -intf_net dma_tm_M_AXIS_MM2S [get_bd_intf_pins dma_tm/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/testing_matrix]
  connect_bd_intf_net -intf_net geometric_values_rbf_geometric_values_out [get_bd_intf_pins dma_gv/S_AXIS_S2MM] [get_bd_intf_pins geometric_values_rbf/geometric_values_out]

  # Create port connections
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins dma_cf/axi_resetn] [get_bd_pins dma_ds/axi_resetn] [get_bd_pins dma_gv/axi_resetn] [get_bd_pins dma_sv/axi_resetn] [get_bd_pins dma_tm/axi_resetn] [get_bd_pins geometric_values_rbf/ap_rst_n]
  connect_bd_net -net s_axi_lite_aclk_1 [get_bd_pins s_axi_lite_aclk] [get_bd_pins dma_cf/m_axi_mm2s_aclk] [get_bd_pins dma_cf/s_axi_lite_aclk] [get_bd_pins dma_ds/m_axi_mm2s_aclk] [get_bd_pins dma_ds/s_axi_lite_aclk] [get_bd_pins dma_gv/m_axi_s2mm_aclk] [get_bd_pins dma_gv/s_axi_lite_aclk] [get_bd_pins dma_sv/m_axi_mm2s_aclk] [get_bd_pins dma_sv/s_axi_lite_aclk] [get_bd_pins dma_tm/m_axi_mm2s_aclk] [get_bd_pins dma_tm/s_axi_lite_aclk] [get_bd_pins geometric_values_rbf/ap_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: geometric_values_6
proc create_hier_cell_geometric_values_6 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_geometric_values_6() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE4


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: dma_cf, and set properties
  set dma_cf [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_cf ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_cf

  # Create instance: dma_ds, and set properties
  set dma_ds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_ds ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_ds

  # Create instance: dma_gv, and set properties
  set dma_gv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_gv ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_gv

  # Create instance: dma_sv, and set properties
  set dma_sv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_sv ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_sv

  # Create instance: dma_tm, and set properties
  set dma_tm [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_tm ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_tm

  # Create instance: geometric_values_rbf, and set properties
  set geometric_values_rbf [ create_bd_cell -type ip -vlnv xilinx.com:hls:geometric_values_rbf_top:1.0 geometric_values_rbf ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins dma_tm/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins dma_ds/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_LITE2] [get_bd_intf_pins dma_cf/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI_LITE3] [get_bd_intf_pins dma_sv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI_LITE4] [get_bd_intf_pins dma_gv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins dma_tm/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins dma_ds/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins M_AXI_MM2S2] [get_bd_intf_pins dma_cf/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins M_AXI_MM2S3] [get_bd_intf_pins dma_sv/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins dma_gv/M_AXI_S2MM]
  connect_bd_intf_net -intf_net dma_cf_M_AXIS_MM2S [get_bd_intf_pins dma_cf/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/sv_coeffs]
  connect_bd_intf_net -intf_net dma_ds_M_AXIS_MM2S [get_bd_intf_pins dma_ds/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/classification_details]
  connect_bd_intf_net -intf_net dma_sv_M_AXIS_MM2S [get_bd_intf_pins dma_sv/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/support_vectors]
  connect_bd_intf_net -intf_net dma_tm_M_AXIS_MM2S [get_bd_intf_pins dma_tm/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/testing_matrix]
  connect_bd_intf_net -intf_net geometric_values_rbf_geometric_values_out [get_bd_intf_pins dma_gv/S_AXIS_S2MM] [get_bd_intf_pins geometric_values_rbf/geometric_values_out]

  # Create port connections
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins dma_cf/axi_resetn] [get_bd_pins dma_ds/axi_resetn] [get_bd_pins dma_gv/axi_resetn] [get_bd_pins dma_sv/axi_resetn] [get_bd_pins dma_tm/axi_resetn] [get_bd_pins geometric_values_rbf/ap_rst_n]
  connect_bd_net -net s_axi_lite_aclk_1 [get_bd_pins s_axi_lite_aclk] [get_bd_pins dma_cf/m_axi_mm2s_aclk] [get_bd_pins dma_cf/s_axi_lite_aclk] [get_bd_pins dma_ds/m_axi_mm2s_aclk] [get_bd_pins dma_ds/s_axi_lite_aclk] [get_bd_pins dma_gv/m_axi_s2mm_aclk] [get_bd_pins dma_gv/s_axi_lite_aclk] [get_bd_pins dma_sv/m_axi_mm2s_aclk] [get_bd_pins dma_sv/s_axi_lite_aclk] [get_bd_pins dma_tm/m_axi_mm2s_aclk] [get_bd_pins dma_tm/s_axi_lite_aclk] [get_bd_pins geometric_values_rbf/ap_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: geometric_values_5
proc create_hier_cell_geometric_values_5 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_geometric_values_5() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE4


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: dma_cf, and set properties
  set dma_cf [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_cf ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_cf

  # Create instance: dma_ds, and set properties
  set dma_ds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_ds ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_ds

  # Create instance: dma_gv, and set properties
  set dma_gv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_gv ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_gv

  # Create instance: dma_sv, and set properties
  set dma_sv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_sv ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_sv

  # Create instance: dma_tm, and set properties
  set dma_tm [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_tm ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_tm

  # Create instance: geometric_values_rbf, and set properties
  set geometric_values_rbf [ create_bd_cell -type ip -vlnv xilinx.com:hls:geometric_values_rbf_top:1.0 geometric_values_rbf ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins dma_tm/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins dma_ds/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_LITE2] [get_bd_intf_pins dma_cf/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI_LITE3] [get_bd_intf_pins dma_sv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI_LITE4] [get_bd_intf_pins dma_gv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins dma_tm/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins dma_ds/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins M_AXI_MM2S2] [get_bd_intf_pins dma_cf/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins M_AXI_MM2S3] [get_bd_intf_pins dma_sv/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins dma_gv/M_AXI_S2MM]
  connect_bd_intf_net -intf_net dma_cf_M_AXIS_MM2S [get_bd_intf_pins dma_cf/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/sv_coeffs]
  connect_bd_intf_net -intf_net dma_ds_M_AXIS_MM2S [get_bd_intf_pins dma_ds/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/classification_details]
  connect_bd_intf_net -intf_net dma_sv_M_AXIS_MM2S [get_bd_intf_pins dma_sv/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/support_vectors]
  connect_bd_intf_net -intf_net dma_tm_M_AXIS_MM2S [get_bd_intf_pins dma_tm/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/testing_matrix]
  connect_bd_intf_net -intf_net geometric_values_rbf_geometric_values_out [get_bd_intf_pins dma_gv/S_AXIS_S2MM] [get_bd_intf_pins geometric_values_rbf/geometric_values_out]

  # Create port connections
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins dma_cf/axi_resetn] [get_bd_pins dma_ds/axi_resetn] [get_bd_pins dma_gv/axi_resetn] [get_bd_pins dma_sv/axi_resetn] [get_bd_pins dma_tm/axi_resetn] [get_bd_pins geometric_values_rbf/ap_rst_n]
  connect_bd_net -net s_axi_lite_aclk_1 [get_bd_pins s_axi_lite_aclk] [get_bd_pins dma_cf/m_axi_mm2s_aclk] [get_bd_pins dma_cf/s_axi_lite_aclk] [get_bd_pins dma_ds/m_axi_mm2s_aclk] [get_bd_pins dma_ds/s_axi_lite_aclk] [get_bd_pins dma_gv/m_axi_s2mm_aclk] [get_bd_pins dma_gv/s_axi_lite_aclk] [get_bd_pins dma_sv/m_axi_mm2s_aclk] [get_bd_pins dma_sv/s_axi_lite_aclk] [get_bd_pins dma_tm/m_axi_mm2s_aclk] [get_bd_pins dma_tm/s_axi_lite_aclk] [get_bd_pins geometric_values_rbf/ap_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: geometric_values_4
proc create_hier_cell_geometric_values_4 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_geometric_values_4() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE4


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: dma_cf, and set properties
  set dma_cf [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_cf ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_cf

  # Create instance: dma_ds, and set properties
  set dma_ds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_ds ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_ds

  # Create instance: dma_gv, and set properties
  set dma_gv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_gv ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_gv

  # Create instance: dma_sv, and set properties
  set dma_sv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_sv ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_sv

  # Create instance: dma_tm, and set properties
  set dma_tm [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_tm ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_tm

  # Create instance: geometric_values_rbf, and set properties
  set geometric_values_rbf [ create_bd_cell -type ip -vlnv xilinx.com:hls:geometric_values_rbf_top:1.0 geometric_values_rbf ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins dma_tm/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins dma_ds/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_LITE2] [get_bd_intf_pins dma_cf/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI_LITE3] [get_bd_intf_pins dma_sv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI_LITE4] [get_bd_intf_pins dma_gv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins dma_cf/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins dma_tm/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins M_AXI_MM2S2] [get_bd_intf_pins dma_ds/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins M_AXI_MM2S3] [get_bd_intf_pins dma_sv/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins dma_gv/M_AXI_S2MM]
  connect_bd_intf_net -intf_net dma_cf_M_AXIS_MM2S [get_bd_intf_pins dma_cf/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/sv_coeffs]
  connect_bd_intf_net -intf_net dma_ds_M_AXIS_MM2S [get_bd_intf_pins dma_ds/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/classification_details]
  connect_bd_intf_net -intf_net dma_sv_M_AXIS_MM2S [get_bd_intf_pins dma_sv/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/support_vectors]
  connect_bd_intf_net -intf_net dma_tm_M_AXIS_MM2S [get_bd_intf_pins dma_tm/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/testing_matrix]
  connect_bd_intf_net -intf_net geometric_values_rbf_geometric_values_out [get_bd_intf_pins dma_gv/S_AXIS_S2MM] [get_bd_intf_pins geometric_values_rbf/geometric_values_out]

  # Create port connections
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins dma_cf/axi_resetn] [get_bd_pins dma_ds/axi_resetn] [get_bd_pins dma_gv/axi_resetn] [get_bd_pins dma_sv/axi_resetn] [get_bd_pins dma_tm/axi_resetn] [get_bd_pins geometric_values_rbf/ap_rst_n]
  connect_bd_net -net s_axi_lite_aclk_1 [get_bd_pins s_axi_lite_aclk] [get_bd_pins dma_cf/m_axi_mm2s_aclk] [get_bd_pins dma_cf/s_axi_lite_aclk] [get_bd_pins dma_ds/m_axi_mm2s_aclk] [get_bd_pins dma_ds/s_axi_lite_aclk] [get_bd_pins dma_gv/m_axi_s2mm_aclk] [get_bd_pins dma_gv/s_axi_lite_aclk] [get_bd_pins dma_sv/m_axi_mm2s_aclk] [get_bd_pins dma_sv/s_axi_lite_aclk] [get_bd_pins dma_tm/m_axi_mm2s_aclk] [get_bd_pins dma_tm/s_axi_lite_aclk] [get_bd_pins geometric_values_rbf/ap_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: geometric_values_3
proc create_hier_cell_geometric_values_3 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_geometric_values_3() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE4


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: dma_cf, and set properties
  set dma_cf [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_cf ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_cf

  # Create instance: dma_ds, and set properties
  set dma_ds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_ds ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_ds

  # Create instance: dma_gv, and set properties
  set dma_gv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_gv ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_gv

  # Create instance: dma_sv, and set properties
  set dma_sv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_sv ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_sv

  # Create instance: dma_tm, and set properties
  set dma_tm [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_tm ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_tm

  # Create instance: geometric_values_rbf, and set properties
  set geometric_values_rbf [ create_bd_cell -type ip -vlnv xilinx.com:hls:geometric_values_rbf_top:1.0 geometric_values_rbf ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins dma_tm/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins dma_ds/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_LITE2] [get_bd_intf_pins dma_cf/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI_LITE3] [get_bd_intf_pins dma_sv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI_LITE4] [get_bd_intf_pins dma_gv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins dma_tm/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins dma_ds/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins M_AXI_MM2S2] [get_bd_intf_pins dma_cf/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins M_AXI_MM2S3] [get_bd_intf_pins dma_sv/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins dma_gv/M_AXI_S2MM]
  connect_bd_intf_net -intf_net dma_cf_M_AXIS_MM2S [get_bd_intf_pins dma_cf/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/sv_coeffs]
  connect_bd_intf_net -intf_net dma_ds_M_AXIS_MM2S [get_bd_intf_pins dma_ds/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/classification_details]
  connect_bd_intf_net -intf_net dma_sv_M_AXIS_MM2S [get_bd_intf_pins dma_sv/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/support_vectors]
  connect_bd_intf_net -intf_net dma_tm_M_AXIS_MM2S [get_bd_intf_pins dma_tm/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/testing_matrix]
  connect_bd_intf_net -intf_net geometric_values_rbf_geometric_values_out [get_bd_intf_pins dma_gv/S_AXIS_S2MM] [get_bd_intf_pins geometric_values_rbf/geometric_values_out]

  # Create port connections
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins dma_cf/axi_resetn] [get_bd_pins dma_ds/axi_resetn] [get_bd_pins dma_gv/axi_resetn] [get_bd_pins dma_sv/axi_resetn] [get_bd_pins dma_tm/axi_resetn] [get_bd_pins geometric_values_rbf/ap_rst_n]
  connect_bd_net -net s_axi_lite_aclk_1 [get_bd_pins s_axi_lite_aclk] [get_bd_pins dma_cf/m_axi_mm2s_aclk] [get_bd_pins dma_cf/s_axi_lite_aclk] [get_bd_pins dma_ds/m_axi_mm2s_aclk] [get_bd_pins dma_ds/s_axi_lite_aclk] [get_bd_pins dma_gv/m_axi_s2mm_aclk] [get_bd_pins dma_gv/s_axi_lite_aclk] [get_bd_pins dma_sv/m_axi_mm2s_aclk] [get_bd_pins dma_sv/s_axi_lite_aclk] [get_bd_pins dma_tm/m_axi_mm2s_aclk] [get_bd_pins dma_tm/s_axi_lite_aclk] [get_bd_pins geometric_values_rbf/ap_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: geometric_values_2
proc create_hier_cell_geometric_values_2 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_geometric_values_2() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE4


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: dma_cf, and set properties
  set dma_cf [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_cf ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_cf

  # Create instance: dma_ds, and set properties
  set dma_ds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_ds ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_ds

  # Create instance: dma_gv, and set properties
  set dma_gv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_gv ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_gv

  # Create instance: dma_sv, and set properties
  set dma_sv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_sv ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_sv

  # Create instance: dma_tm, and set properties
  set dma_tm [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_tm ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_tm

  # Create instance: geometric_values_rbf, and set properties
  set geometric_values_rbf [ create_bd_cell -type ip -vlnv xilinx.com:hls:geometric_values_rbf_top:1.0 geometric_values_rbf ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins dma_tm/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins dma_ds/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_LITE2] [get_bd_intf_pins dma_cf/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI_LITE3] [get_bd_intf_pins dma_sv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI_LITE4] [get_bd_intf_pins dma_gv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins dma_tm/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins dma_ds/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins M_AXI_MM2S2] [get_bd_intf_pins dma_cf/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins M_AXI_MM2S3] [get_bd_intf_pins dma_sv/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins dma_gv/M_AXI_S2MM]
  connect_bd_intf_net -intf_net dma_cf_M_AXIS_MM2S [get_bd_intf_pins dma_cf/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/sv_coeffs]
  connect_bd_intf_net -intf_net dma_ds_M_AXIS_MM2S [get_bd_intf_pins dma_ds/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/classification_details]
  connect_bd_intf_net -intf_net dma_sv_M_AXIS_MM2S [get_bd_intf_pins dma_sv/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/support_vectors]
  connect_bd_intf_net -intf_net dma_tm_M_AXIS_MM2S [get_bd_intf_pins dma_tm/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/testing_matrix]
  connect_bd_intf_net -intf_net geometric_values_rbf_geometric_values_out [get_bd_intf_pins dma_gv/S_AXIS_S2MM] [get_bd_intf_pins geometric_values_rbf/geometric_values_out]

  # Create port connections
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins dma_cf/axi_resetn] [get_bd_pins dma_ds/axi_resetn] [get_bd_pins dma_gv/axi_resetn] [get_bd_pins dma_sv/axi_resetn] [get_bd_pins dma_tm/axi_resetn] [get_bd_pins geometric_values_rbf/ap_rst_n]
  connect_bd_net -net s_axi_lite_aclk_1 [get_bd_pins s_axi_lite_aclk] [get_bd_pins dma_cf/m_axi_mm2s_aclk] [get_bd_pins dma_cf/s_axi_lite_aclk] [get_bd_pins dma_ds/m_axi_mm2s_aclk] [get_bd_pins dma_ds/s_axi_lite_aclk] [get_bd_pins dma_gv/m_axi_s2mm_aclk] [get_bd_pins dma_gv/s_axi_lite_aclk] [get_bd_pins dma_sv/m_axi_mm2s_aclk] [get_bd_pins dma_sv/s_axi_lite_aclk] [get_bd_pins dma_tm/m_axi_mm2s_aclk] [get_bd_pins dma_tm/s_axi_lite_aclk] [get_bd_pins geometric_values_rbf/ap_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: geometric_values_1
proc create_hier_cell_geometric_values_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_geometric_values_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S1

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S2

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_MM2S3

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI_S2MM

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE1

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE2

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE3

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE4


  # Create pins
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir I -type clk s_axi_lite_aclk

  # Create instance: dma_cf, and set properties
  set dma_cf [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_cf ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_cf

  # Create instance: dma_ds, and set properties
  set dma_ds [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_ds ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_ds

  # Create instance: dma_gv, and set properties
  set dma_gv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_gv ]
  set_property -dict [ list \
   CONFIG.c_include_mm2s {0} \
   CONFIG.c_include_s2mm {1} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {32} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_gv

  # Create instance: dma_sv, and set properties
  set dma_sv [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_sv ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_sv

  # Create instance: dma_tm, and set properties
  set dma_tm [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_dma:7.1 dma_tm ]
  set_property -dict [ list \
   CONFIG.c_include_s2mm {0} \
   CONFIG.c_include_sg {0} \
   CONFIG.c_m_axis_mm2s_tdata_width {16} \
   CONFIG.c_sg_include_stscntrl_strm {0} \
   CONFIG.c_sg_length_width {26} \
 ] $dma_tm

  # Create instance: geometric_values_rbf, and set properties
  set geometric_values_rbf [ create_bd_cell -type ip -vlnv xilinx.com:hls:geometric_values_rbf_top:1.0 geometric_values_rbf ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins dma_tm/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins S_AXI_LITE1] [get_bd_intf_pins dma_ds/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins S_AXI_LITE2] [get_bd_intf_pins dma_cf/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins S_AXI_LITE3] [get_bd_intf_pins dma_sv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn5 [get_bd_intf_pins S_AXI_LITE4] [get_bd_intf_pins dma_gv/S_AXI_LITE]
  connect_bd_intf_net -intf_net Conn6 [get_bd_intf_pins M_AXI_MM2S] [get_bd_intf_pins dma_tm/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn7 [get_bd_intf_pins M_AXI_MM2S1] [get_bd_intf_pins dma_ds/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn8 [get_bd_intf_pins M_AXI_MM2S2] [get_bd_intf_pins dma_cf/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn9 [get_bd_intf_pins M_AXI_MM2S3] [get_bd_intf_pins dma_sv/M_AXI_MM2S]
  connect_bd_intf_net -intf_net Conn10 [get_bd_intf_pins M_AXI_S2MM] [get_bd_intf_pins dma_gv/M_AXI_S2MM]
  connect_bd_intf_net -intf_net dma_cf_M_AXIS_MM2S [get_bd_intf_pins dma_cf/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/sv_coeffs]
  connect_bd_intf_net -intf_net dma_ds_M_AXIS_MM2S [get_bd_intf_pins dma_ds/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/classification_details]
  connect_bd_intf_net -intf_net dma_sv_M_AXIS_MM2S [get_bd_intf_pins dma_sv/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/support_vectors]
  connect_bd_intf_net -intf_net dma_tm_M_AXIS_MM2S [get_bd_intf_pins dma_tm/M_AXIS_MM2S] [get_bd_intf_pins geometric_values_rbf/testing_matrix]
  connect_bd_intf_net -intf_net geometric_values_rbf_geometric_values_out [get_bd_intf_pins dma_gv/S_AXIS_S2MM] [get_bd_intf_pins geometric_values_rbf/geometric_values_out]

  # Create port connections
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins dma_cf/axi_resetn] [get_bd_pins dma_ds/axi_resetn] [get_bd_pins dma_gv/axi_resetn] [get_bd_pins dma_sv/axi_resetn] [get_bd_pins dma_tm/axi_resetn] [get_bd_pins geometric_values_rbf/ap_rst_n]
  connect_bd_net -net s_axi_lite_aclk_1 [get_bd_pins s_axi_lite_aclk] [get_bd_pins dma_cf/m_axi_mm2s_aclk] [get_bd_pins dma_cf/s_axi_lite_aclk] [get_bd_pins dma_ds/m_axi_mm2s_aclk] [get_bd_pins dma_ds/s_axi_lite_aclk] [get_bd_pins dma_gv/m_axi_s2mm_aclk] [get_bd_pins dma_gv/s_axi_lite_aclk] [get_bd_pins dma_sv/m_axi_mm2s_aclk] [get_bd_pins dma_sv/s_axi_lite_aclk] [get_bd_pins dma_tm/m_axi_mm2s_aclk] [get_bd_pins dma_tm/s_axi_lite_aclk] [get_bd_pins geometric_values_rbf/ap_clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports

  # Create instance: axi_smc, and set properties
  set axi_smc [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc ]
  set_property -dict [ list \
   CONFIG.NUM_SI {16} \
 ] $axi_smc

  # Create instance: axi_smc_1, and set properties
  set axi_smc_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc_1 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {16} \
 ] $axi_smc_1

  # Create instance: axi_smc_2, and set properties
  set axi_smc_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc_2 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {16} \
 ] $axi_smc_2

  # Create instance: axi_smc_3, and set properties
  set axi_smc_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 axi_smc_3 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {14} \
 ] $axi_smc_3

  # Create instance: geometric_values_1
  create_hier_cell_geometric_values_1 [current_bd_instance .] geometric_values_1

  # Create instance: geometric_values_2
  create_hier_cell_geometric_values_2 [current_bd_instance .] geometric_values_2

  # Create instance: geometric_values_3
  create_hier_cell_geometric_values_3 [current_bd_instance .] geometric_values_3

  # Create instance: geometric_values_4
  create_hier_cell_geometric_values_4 [current_bd_instance .] geometric_values_4

  # Create instance: geometric_values_5
  create_hier_cell_geometric_values_5 [current_bd_instance .] geometric_values_5

  # Create instance: geometric_values_6
  create_hier_cell_geometric_values_6 [current_bd_instance .] geometric_values_6

  # Create instance: geometric_values_7
  create_hier_cell_geometric_values_7 [current_bd_instance .] geometric_values_7

  # Create instance: geometric_values_8
  create_hier_cell_geometric_values_8 [current_bd_instance .] geometric_values_8

  # Create instance: geometric_values_9
  create_hier_cell_geometric_values_9 [current_bd_instance .] geometric_values_9

  # Create instance: geometric_values_10
  create_hier_cell_geometric_values_10 [current_bd_instance .] geometric_values_10

  # Create instance: geometric_values_11
  create_hier_cell_geometric_values_11 [current_bd_instance .] geometric_values_11

  # Create instance: get_w_1
  create_hier_cell_get_w_1 [current_bd_instance .] get_w_1

  # Create instance: ps8_0_axi_periph, and set properties
  set ps8_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps8_0_axi_periph ]
  set_property -dict [ list \
   CONFIG.NUM_MI {62} \
 ] $ps8_0_axi_periph

  # Create instance: rst_ps8_0_100M, and set properties
  set rst_ps8_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_ps8_0_100M ]

  # Create instance: test_predictions_1
  create_hier_cell_test_predictions_1 [current_bd_instance .] test_predictions_1

  # Create instance: zynq_ultra_ps_e_0, and set properties
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e:3.3 zynq_ultra_ps_e_0 ]
  set_property -dict [ list \
   CONFIG.PSU_BANK_0_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_1_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_BANK_2_IO_STANDARD {LVCMOS18} \
   CONFIG.PSU_DDR_RAM_HIGHADDR {0x7FFFFFFF} \
   CONFIG.PSU_DDR_RAM_HIGHADDR_OFFSET {0x00000002} \
   CONFIG.PSU_DDR_RAM_LOWADDR_OFFSET {0x80000000} \
   CONFIG.PSU_DYNAMIC_DDR_CONFIG_EN {0} \
   CONFIG.PSU_MIO_0_DIRECTION {out} \
   CONFIG.PSU_MIO_0_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_0_POLARITY {Default} \
   CONFIG.PSU_MIO_16_DIRECTION {inout} \
   CONFIG.PSU_MIO_16_POLARITY {Default} \
   CONFIG.PSU_MIO_17_DIRECTION {inout} \
   CONFIG.PSU_MIO_17_POLARITY {Default} \
   CONFIG.PSU_MIO_18_DIRECTION {in} \
   CONFIG.PSU_MIO_18_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_18_POLARITY {Default} \
   CONFIG.PSU_MIO_18_SLEW {fast} \
   CONFIG.PSU_MIO_19_DIRECTION {out} \
   CONFIG.PSU_MIO_19_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_19_POLARITY {Default} \
   CONFIG.PSU_MIO_1_DIRECTION {inout} \
   CONFIG.PSU_MIO_1_POLARITY {Default} \
   CONFIG.PSU_MIO_20_DIRECTION {out} \
   CONFIG.PSU_MIO_20_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_20_POLARITY {Default} \
   CONFIG.PSU_MIO_21_DIRECTION {in} \
   CONFIG.PSU_MIO_21_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_21_POLARITY {Default} \
   CONFIG.PSU_MIO_21_SLEW {fast} \
   CONFIG.PSU_MIO_24_DIRECTION {out} \
   CONFIG.PSU_MIO_24_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_24_POLARITY {Default} \
   CONFIG.PSU_MIO_25_DIRECTION {in} \
   CONFIG.PSU_MIO_25_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_25_POLARITY {Default} \
   CONFIG.PSU_MIO_25_SLEW {fast} \
   CONFIG.PSU_MIO_27_DIRECTION {out} \
   CONFIG.PSU_MIO_27_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_27_POLARITY {Default} \
   CONFIG.PSU_MIO_28_DIRECTION {in} \
   CONFIG.PSU_MIO_28_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_28_POLARITY {Default} \
   CONFIG.PSU_MIO_28_SLEW {fast} \
   CONFIG.PSU_MIO_29_DIRECTION {out} \
   CONFIG.PSU_MIO_29_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_29_POLARITY {Default} \
   CONFIG.PSU_MIO_2_DIRECTION {inout} \
   CONFIG.PSU_MIO_2_POLARITY {Default} \
   CONFIG.PSU_MIO_30_DIRECTION {in} \
   CONFIG.PSU_MIO_30_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_30_POLARITY {Default} \
   CONFIG.PSU_MIO_30_SLEW {fast} \
   CONFIG.PSU_MIO_3_DIRECTION {inout} \
   CONFIG.PSU_MIO_3_POLARITY {Default} \
   CONFIG.PSU_MIO_45_DIRECTION {in} \
   CONFIG.PSU_MIO_45_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_45_POLARITY {Default} \
   CONFIG.PSU_MIO_45_SLEW {fast} \
   CONFIG.PSU_MIO_46_DIRECTION {inout} \
   CONFIG.PSU_MIO_46_POLARITY {Default} \
   CONFIG.PSU_MIO_47_DIRECTION {inout} \
   CONFIG.PSU_MIO_47_POLARITY {Default} \
   CONFIG.PSU_MIO_48_DIRECTION {inout} \
   CONFIG.PSU_MIO_48_POLARITY {Default} \
   CONFIG.PSU_MIO_49_DIRECTION {inout} \
   CONFIG.PSU_MIO_49_POLARITY {Default} \
   CONFIG.PSU_MIO_4_DIRECTION {inout} \
   CONFIG.PSU_MIO_4_POLARITY {Default} \
   CONFIG.PSU_MIO_50_DIRECTION {inout} \
   CONFIG.PSU_MIO_50_POLARITY {Default} \
   CONFIG.PSU_MIO_51_DIRECTION {out} \
   CONFIG.PSU_MIO_51_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_51_POLARITY {Default} \
   CONFIG.PSU_MIO_52_DIRECTION {in} \
   CONFIG.PSU_MIO_52_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_52_POLARITY {Default} \
   CONFIG.PSU_MIO_52_SLEW {fast} \
   CONFIG.PSU_MIO_53_DIRECTION {in} \
   CONFIG.PSU_MIO_53_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_53_POLARITY {Default} \
   CONFIG.PSU_MIO_53_SLEW {fast} \
   CONFIG.PSU_MIO_54_DIRECTION {inout} \
   CONFIG.PSU_MIO_54_POLARITY {Default} \
   CONFIG.PSU_MIO_55_DIRECTION {in} \
   CONFIG.PSU_MIO_55_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_55_POLARITY {Default} \
   CONFIG.PSU_MIO_55_SLEW {fast} \
   CONFIG.PSU_MIO_56_DIRECTION {inout} \
   CONFIG.PSU_MIO_56_POLARITY {Default} \
   CONFIG.PSU_MIO_57_DIRECTION {inout} \
   CONFIG.PSU_MIO_57_POLARITY {Default} \
   CONFIG.PSU_MIO_58_DIRECTION {out} \
   CONFIG.PSU_MIO_58_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_58_POLARITY {Default} \
   CONFIG.PSU_MIO_59_DIRECTION {inout} \
   CONFIG.PSU_MIO_59_POLARITY {Default} \
   CONFIG.PSU_MIO_5_DIRECTION {out} \
   CONFIG.PSU_MIO_5_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_5_POLARITY {Default} \
   CONFIG.PSU_MIO_60_DIRECTION {inout} \
   CONFIG.PSU_MIO_60_POLARITY {Default} \
   CONFIG.PSU_MIO_61_DIRECTION {inout} \
   CONFIG.PSU_MIO_61_POLARITY {Default} \
   CONFIG.PSU_MIO_62_DIRECTION {inout} \
   CONFIG.PSU_MIO_62_POLARITY {Default} \
   CONFIG.PSU_MIO_63_DIRECTION {inout} \
   CONFIG.PSU_MIO_63_POLARITY {Default} \
   CONFIG.PSU_MIO_64_DIRECTION {out} \
   CONFIG.PSU_MIO_64_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_64_POLARITY {Default} \
   CONFIG.PSU_MIO_65_DIRECTION {out} \
   CONFIG.PSU_MIO_65_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_65_POLARITY {Default} \
   CONFIG.PSU_MIO_66_DIRECTION {out} \
   CONFIG.PSU_MIO_66_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_66_POLARITY {Default} \
   CONFIG.PSU_MIO_67_DIRECTION {out} \
   CONFIG.PSU_MIO_67_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_67_POLARITY {Default} \
   CONFIG.PSU_MIO_68_DIRECTION {out} \
   CONFIG.PSU_MIO_68_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_68_POLARITY {Default} \
   CONFIG.PSU_MIO_69_DIRECTION {out} \
   CONFIG.PSU_MIO_69_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_69_POLARITY {Default} \
   CONFIG.PSU_MIO_6_DIRECTION {out} \
   CONFIG.PSU_MIO_6_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_6_POLARITY {Default} \
   CONFIG.PSU_MIO_70_DIRECTION {in} \
   CONFIG.PSU_MIO_70_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_70_POLARITY {Default} \
   CONFIG.PSU_MIO_70_SLEW {fast} \
   CONFIG.PSU_MIO_71_DIRECTION {in} \
   CONFIG.PSU_MIO_71_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_71_POLARITY {Default} \
   CONFIG.PSU_MIO_71_SLEW {fast} \
   CONFIG.PSU_MIO_72_DIRECTION {in} \
   CONFIG.PSU_MIO_72_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_72_POLARITY {Default} \
   CONFIG.PSU_MIO_72_SLEW {fast} \
   CONFIG.PSU_MIO_73_DIRECTION {in} \
   CONFIG.PSU_MIO_73_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_73_POLARITY {Default} \
   CONFIG.PSU_MIO_73_SLEW {fast} \
   CONFIG.PSU_MIO_74_DIRECTION {in} \
   CONFIG.PSU_MIO_74_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_74_POLARITY {Default} \
   CONFIG.PSU_MIO_74_SLEW {fast} \
   CONFIG.PSU_MIO_75_DIRECTION {in} \
   CONFIG.PSU_MIO_75_DRIVE_STRENGTH {12} \
   CONFIG.PSU_MIO_75_POLARITY {Default} \
   CONFIG.PSU_MIO_75_SLEW {fast} \
   CONFIG.PSU_MIO_76_DIRECTION {out} \
   CONFIG.PSU_MIO_76_INPUT_TYPE {cmos} \
   CONFIG.PSU_MIO_76_POLARITY {Default} \
   CONFIG.PSU_MIO_77_DIRECTION {inout} \
   CONFIG.PSU_MIO_77_POLARITY {Default} \
   CONFIG.PSU_MIO_TREE_PERIPHERALS {Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Feedback Clk##########I2C 1#I2C 1#UART 0#UART 0#UART 1#UART 1###CAN 1#CAN 1##DPAUX#DPAUX#DPAUX#DPAUX###############SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#SD 1#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#Gem 3#MDIO 3#MDIO 3} \
   CONFIG.PSU_MIO_TREE_SIGNALS {sclk_out#miso_mo1#mo2#mo3#mosi_mi0#n_ss_out#clk_for_lpbk##########scl_out#sda_out#rxd#txd#txd#rxd###phy_tx#phy_rx##dp_aux_data_out#dp_hot_plug_detect#dp_aux_data_oe#dp_aux_data_in###############sdio1_cd_n#sdio1_data_out[0]#sdio1_data_out[1]#sdio1_data_out[2]#sdio1_data_out[3]#sdio1_cmd_out#sdio1_clk_out#ulpi_clk_in#ulpi_dir#ulpi_tx_data[2]#ulpi_nxt#ulpi_tx_data[0]#ulpi_tx_data[1]#ulpi_stp#ulpi_tx_data[3]#ulpi_tx_data[4]#ulpi_tx_data[5]#ulpi_tx_data[6]#ulpi_tx_data[7]#rgmii_tx_clk#rgmii_txd[0]#rgmii_txd[1]#rgmii_txd[2]#rgmii_txd[3]#rgmii_tx_ctl#rgmii_rx_clk#rgmii_rxd[0]#rgmii_rxd[1]#rgmii_rxd[2]#rgmii_rxd[3]#rgmii_rx_ctl#gem3_mdc#gem3_mdio_out} \
   CONFIG.PSU_SD1_INTERNAL_BUS_WIDTH {4} \
   CONFIG.PSU_USB3__DUAL_CLOCK_ENABLE {1} \
   CONFIG.PSU__ACT_DDR_FREQ_MHZ {1050.000000} \
   CONFIG.PSU__CAN1__GRP_CLK__ENABLE {0} \
   CONFIG.PSU__CAN1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__CAN1__PERIPHERAL__IO {MIO 24 .. 25} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__ACT_FREQMHZ {1200.000000} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__FREQMHZ {1200} \
   CONFIG.PSU__CRF_APB__ACPU_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FBDIV {72} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__APLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__APLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__APLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_FPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TRACE_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__DBG_TSTMP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__ACT_FREQMHZ {525.000000} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__FREQMHZ {1067} \
   CONFIG.PSU__CRF_APB__DDR_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__ACT_FREQMHZ {600.000000} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__DPDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FBDIV {63} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__DPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__DPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__DPLL_TO_LPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__ACT_FREQMHZ {25.000000} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_AUDIO_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_AUDIO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__ACT_FREQMHZ {26.785715} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR0 {14} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_STC_REF_CTRL__SRCSEL {RPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__ACT_FREQMHZ {300.000000} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRF_APB__DP_VIDEO_REF_CTRL__SRCSEL {VPLL} \
   CONFIG.PSU__CRF_APB__DP_VIDEO__FRAC_ENABLED {0} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__ACT_FREQMHZ {600.000000} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__FREQMHZ {600} \
   CONFIG.PSU__CRF_APB__GDMA_REF_CTRL__SRCSEL {APLL} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__ACT_FREQMHZ {500.000000} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__DIVISOR0 {1} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRF_APB__GPU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__PCIE_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRF_APB__SATA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__DIVISOR0 {5} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRF_APB__TOPSW_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__ACT_FREQMHZ {525.000000} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__FREQMHZ {533.33} \
   CONFIG.PSU__CRF_APB__TOPSW_MAIN_CTRL__SRCSEL {DPLL} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRF_APB__VPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRF_APB__VPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRF_APB__VPLL_TO_LPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__ACT_FREQMHZ {500.000000} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__ADMA_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__AFI6_REF_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__ACT_FREQMHZ {50.000000} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR0 {30} \
   CONFIG.PSU__CRL_APB__AMS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__CAN1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__ACT_FREQMHZ {500.000000} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__CPU_R5_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__DBG_LPD_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__DLL_REF_CTRL__ACT_FREQMHZ {1500.000000} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__ACT_FREQMHZ {125.000000} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__GEM3_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__GEM_TSU_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__I2C1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FBDIV {90} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__IOPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__IOPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__IOPLL_TO_FPD_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__IOU_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__LPD_LSBUS_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__ACT_FREQMHZ {500.000000} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__DIVISOR0 {3} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__FREQMHZ {500} \
   CONFIG.PSU__CRL_APB__LPD_SWITCH_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__NAND_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__ACT_FREQMHZ {187.500000} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__PCAP_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__PL0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL2_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR0 {4} \
   CONFIG.PSU__CRL_APB__PL3_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__ACT_FREQMHZ {125.000000} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR0 {12} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__FREQMHZ {125} \
   CONFIG.PSU__CRL_APB__QSPI_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__DIV2 {1} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FBDIV {45} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__FRACDATA {0.000000} \
   CONFIG.PSU__CRL_APB__RPLL_CTRL__SRCSEL {PSS_REF_CLK} \
   CONFIG.PSU__CRL_APB__RPLL_FRAC_CFG__ENABLED {0} \
   CONFIG.PSU__CRL_APB__RPLL_TO_FPD_CTRL__DIVISOR0 {2} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SDIO0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__ACT_FREQMHZ {187.500000} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR0 {8} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__FREQMHZ {200} \
   CONFIG.PSU__CRL_APB__SDIO1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR0 {7} \
   CONFIG.PSU__CRL_APB__SPI1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__TIMESTAMP_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART0_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR0 {15} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__FREQMHZ {100} \
   CONFIG.PSU__CRL_APB__UART1_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__ACT_FREQMHZ {250.000000} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__FREQMHZ {250} \
   CONFIG.PSU__CRL_APB__USB0_BUS_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR0 {6} \
   CONFIG.PSU__CRL_APB__USB1_BUS_REF_CTRL__DIVISOR1 {1} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__ACT_FREQMHZ {20.000000} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR0 {25} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__DIVISOR1 {3} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__FREQMHZ {20} \
   CONFIG.PSU__CRL_APB__USB3_DUAL_REF_CTRL__SRCSEL {IOPLL} \
   CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
   CONFIG.PSU__DDRC__ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__BANK_ADDR_COUNT {2} \
   CONFIG.PSU__DDRC__BG_ADDR_COUNT {1} \
   CONFIG.PSU__DDRC__BRC_MAPPING {ROW_BANK_COL} \
   CONFIG.PSU__DDRC__BUS_WIDTH {64 Bit} \
   CONFIG.PSU__DDRC__CL {15} \
   CONFIG.PSU__DDRC__CLOCK_STOP_EN {0} \
   CONFIG.PSU__DDRC__COL_ADDR_COUNT {10} \
   CONFIG.PSU__DDRC__COMPONENTS {Components} \
   CONFIG.PSU__DDRC__CWL {14} \
   CONFIG.PSU__DDRC__DDR3L_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__DDR4_ADDR_MAPPING {0} \
   CONFIG.PSU__DDRC__DDR4_CAL_MODE_ENABLE {0} \
   CONFIG.PSU__DDRC__DDR4_CRC_CONTROL {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_MODE {0} \
   CONFIG.PSU__DDRC__DDR4_T_REF_RANGE {Normal (0-85)} \
   CONFIG.PSU__DDRC__DEEP_PWR_DOWN_EN {0} \
   CONFIG.PSU__DDRC__DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PSU__DDRC__DIMM_ADDR_MIRROR {0} \
   CONFIG.PSU__DDRC__DM_DBI {DM_NO_DBI} \
   CONFIG.PSU__DDRC__DQMAP_0_3 {0} \
   CONFIG.PSU__DDRC__DQMAP_12_15 {0} \
   CONFIG.PSU__DDRC__DQMAP_16_19 {0} \
   CONFIG.PSU__DDRC__DQMAP_20_23 {0} \
   CONFIG.PSU__DDRC__DQMAP_24_27 {0} \
   CONFIG.PSU__DDRC__DQMAP_28_31 {0} \
   CONFIG.PSU__DDRC__DQMAP_32_35 {0} \
   CONFIG.PSU__DDRC__DQMAP_36_39 {0} \
   CONFIG.PSU__DDRC__DQMAP_40_43 {0} \
   CONFIG.PSU__DDRC__DQMAP_44_47 {0} \
   CONFIG.PSU__DDRC__DQMAP_48_51 {0} \
   CONFIG.PSU__DDRC__DQMAP_4_7 {0} \
   CONFIG.PSU__DDRC__DQMAP_52_55 {0} \
   CONFIG.PSU__DDRC__DQMAP_56_59 {0} \
   CONFIG.PSU__DDRC__DQMAP_60_63 {0} \
   CONFIG.PSU__DDRC__DQMAP_64_67 {0} \
   CONFIG.PSU__DDRC__DQMAP_68_71 {0} \
   CONFIG.PSU__DDRC__DQMAP_8_11 {0} \
   CONFIG.PSU__DDRC__DRAM_WIDTH {16 Bits} \
   CONFIG.PSU__DDRC__ECC {Disabled} \
   CONFIG.PSU__DDRC__ENABLE_LP4_HAS_ECC_COMP {0} \
   CONFIG.PSU__DDRC__ENABLE_LP4_SLOWBOOT {0} \
   CONFIG.PSU__DDRC__FGRM {1X} \
   CONFIG.PSU__DDRC__LPDDR3_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LPDDR4_T_REF_RANGE {NA} \
   CONFIG.PSU__DDRC__LP_ASR {manual normal} \
   CONFIG.PSU__DDRC__MEMORY_TYPE {DDR 4} \
   CONFIG.PSU__DDRC__PARITY_ENABLE {0} \
   CONFIG.PSU__DDRC__PER_BANK_REFRESH {0} \
   CONFIG.PSU__DDRC__PHY_DBI_MODE {0} \
   CONFIG.PSU__DDRC__ROW_ADDR_COUNT {15} \
   CONFIG.PSU__DDRC__SB_TARGET {15-15-15} \
   CONFIG.PSU__DDRC__SELF_REF_ABORT {0} \
   CONFIG.PSU__DDRC__SPEED_BIN {DDR4_2133P} \
   CONFIG.PSU__DDRC__STATIC_RD_MODE {0} \
   CONFIG.PSU__DDRC__TRAIN_DATA_EYE {1} \
   CONFIG.PSU__DDRC__TRAIN_READ_GATE {1} \
   CONFIG.PSU__DDRC__TRAIN_WRITE_LEVEL {1} \
   CONFIG.PSU__DDRC__T_FAW {30.0} \
   CONFIG.PSU__DDRC__T_RAS_MIN {33} \
   CONFIG.PSU__DDRC__T_RC {47.06} \
   CONFIG.PSU__DDRC__T_RCD {15} \
   CONFIG.PSU__DDRC__T_RP {15} \
   CONFIG.PSU__DDRC__VENDOR_PART {OTHERS} \
   CONFIG.PSU__DDRC__VREF {1} \
   CONFIG.PSU__DDR_HIGH_ADDRESS_GUI_ENABLE {0} \
   CONFIG.PSU__DDR__INTERFACE__FREQMHZ {533.500} \
   CONFIG.PSU__DISPLAYPORT__LANE0__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE0__IO {GT Lane1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__ENABLE {1} \
   CONFIG.PSU__DISPLAYPORT__LANE1__IO {GT Lane0} \
   CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DLL__ISUSED {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
   CONFIG.PSU__DP__LANE_SEL {Dual Lower} \
   CONFIG.PSU__DP__REF_CLK_FREQ {27} \
   CONFIG.PSU__DP__REF_CLK_SEL {Ref Clk3} \
   CONFIG.PSU__ENET3__FIFO__ENABLE {0} \
   CONFIG.PSU__ENET3__GRP_MDIO__ENABLE {1} \
   CONFIG.PSU__ENET3__GRP_MDIO__IO {MIO 76 .. 77} \
   CONFIG.PSU__ENET3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__ENET3__PERIPHERAL__IO {MIO 64 .. 75} \
   CONFIG.PSU__ENET3__PTP__ENABLE {0} \
   CONFIG.PSU__ENET3__TSU__ENABLE {0} \
   CONFIG.PSU__FPDMASTERS_COHERENCY {0} \
   CONFIG.PSU__FPD_SLCR__WDT1__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__FPD_SLCR__WDT1__FREQMHZ {100.000000} \
   CONFIG.PSU__FPD_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__FPGA_PL0_ENABLE {1} \
   CONFIG.PSU__GEM3_COHERENCY {0} \
   CONFIG.PSU__GEM3_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__GEM__TSU__ENABLE {0} \
   CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__GT__LINK_SPEED {HBR} \
   CONFIG.PSU__GT__PRE_EMPH_LVL_4 {0} \
   CONFIG.PSU__GT__VLT_SWNG_LVL_4 {0} \
   CONFIG.PSU__HIGH_ADDRESS__ENABLE {0} \
   CONFIG.PSU__I2C0__PERIPHERAL__ENABLE {0} \
   CONFIG.PSU__I2C1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__I2C1__PERIPHERAL__IO {MIO 16 .. 17} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC0_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC1_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC2_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__IOU_TTC_APB_CLK__TTC3_SEL {APB} \
   CONFIG.PSU__IOU_SLCR__TTC0__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC0__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC1__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC2__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__TTC3__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__WDT0__ACT_FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__WDT0__FREQMHZ {100.000000} \
   CONFIG.PSU__IOU_SLCR__WDT_CLK_SEL__SELECT {APB} \
   CONFIG.PSU__MAXIGP0__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP1__DATA_WIDTH {128} \
   CONFIG.PSU__MAXIGP2__DATA_WIDTH {32} \
   CONFIG.PSU__OVERRIDE__BASIC_CLOCK {0} \
   CONFIG.PSU__PL_CLK0_BUF {TRUE} \
   CONFIG.PSU__PRESET_APPLIED {1} \
   CONFIG.PSU__PROTECTION__MASTERS {USB1:NonSecure;0|USB0:NonSecure;1|S_AXI_LPD:NA;0|S_AXI_HPC1_FPD:NA;0|S_AXI_HPC0_FPD:NA;0|S_AXI_HP3_FPD:NA;1|S_AXI_HP2_FPD:NA;1|S_AXI_HP1_FPD:NA;1|S_AXI_HP0_FPD:NA;1|S_AXI_ACP:NA;0|S_AXI_ACE:NA;0|SD1:NonSecure;1|SD0:NonSecure;0|SATA1:NonSecure;1|SATA0:NonSecure;1|RPU1:Secure;1|RPU0:Secure;1|QSPI:NonSecure;1|PMU:NA;1|PCIe:NonSecure;0|NAND:NonSecure;0|LDMA:NonSecure;1|GPU:NonSecure;1|GEM3:NonSecure;1|GEM2:NonSecure;0|GEM1:NonSecure;0|GEM0:NonSecure;0|FDMA:NonSecure;1|DP:NonSecure;1|DAP:NA;1|Coresight:NA;1|CSU:NA;1|APU:NA;1} \
   CONFIG.PSU__PROTECTION__SLAVES {LPD;USB3_1_XHCI;FE300000;FE3FFFFF;0|LPD;USB3_1;FF9E0000;FF9EFFFF;0|LPD;USB3_0_XHCI;FE200000;FE2FFFFF;1|LPD;USB3_0;FF9D0000;FF9DFFFF;1|LPD;UART1;FF010000;FF01FFFF;1|LPD;UART0;FF000000;FF00FFFF;1|LPD;TTC3;FF140000;FF14FFFF;1|LPD;TTC2;FF130000;FF13FFFF;1|LPD;TTC1;FF120000;FF12FFFF;1|LPD;TTC0;FF110000;FF11FFFF;1|FPD;SWDT1;FD4D0000;FD4DFFFF;1|LPD;SWDT0;FF150000;FF15FFFF;1|LPD;SPI1;FF050000;FF05FFFF;0|LPD;SPI0;FF040000;FF04FFFF;0|FPD;SMMU_REG;FD5F0000;FD5FFFFF;1|FPD;SMMU;FD800000;FDFFFFFF;1|FPD;SIOU;FD3D0000;FD3DFFFF;1|FPD;SERDES;FD400000;FD47FFFF;1|LPD;SD1;FF170000;FF17FFFF;1|LPD;SD0;FF160000;FF16FFFF;0|FPD;SATA;FD0C0000;FD0CFFFF;1|LPD;RTC;FFA60000;FFA6FFFF;1|LPD;RSA_CORE;FFCE0000;FFCEFFFF;1|LPD;RPU;FF9A0000;FF9AFFFF;1|LPD;R5_TCM_RAM_GLOBAL;FFE00000;FFE3FFFF;1|LPD;R5_1_Instruction_Cache;FFEC0000;FFECFFFF;1|LPD;R5_1_Data_Cache;FFED0000;FFEDFFFF;1|LPD;R5_1_BTCM_GLOBAL;FFEB0000;FFEBFFFF;1|LPD;R5_1_ATCM_GLOBAL;FFE90000;FFE9FFFF;1|LPD;R5_0_Instruction_Cache;FFE40000;FFE4FFFF;1|LPD;R5_0_Data_Cache;FFE50000;FFE5FFFF;1|LPD;R5_0_BTCM_GLOBAL;FFE20000;FFE2FFFF;1|LPD;R5_0_ATCM_GLOBAL;FFE00000;FFE0FFFF;1|LPD;QSPI_Linear_Address;C0000000;DFFFFFFF;1|LPD;QSPI;FF0F0000;FF0FFFFF;1|LPD;PMU_RAM;FFDC0000;FFDDFFFF;1|LPD;PMU_GLOBAL;FFD80000;FFDBFFFF;1|FPD;PCIE_MAIN;FD0E0000;FD0EFFFF;0|FPD;PCIE_LOW;E0000000;EFFFFFFF;0|FPD;PCIE_HIGH2;8000000000;BFFFFFFFFF;0|FPD;PCIE_HIGH1;600000000;7FFFFFFFF;0|FPD;PCIE_DMA;FD0F0000;FD0FFFFF;0|FPD;PCIE_ATTRIB;FD480000;FD48FFFF;0|LPD;OCM_XMPU_CFG;FFA70000;FFA7FFFF;1|LPD;OCM_SLCR;FF960000;FF96FFFF;1|OCM;OCM;FFFC0000;FFFFFFFF;1|LPD;NAND;FF100000;FF10FFFF;0|LPD;MBISTJTAG;FFCF0000;FFCFFFFF;1|LPD;LPD_XPPU_SINK;FF9C0000;FF9CFFFF;1|LPD;LPD_XPPU;FF980000;FF98FFFF;1|LPD;LPD_SLCR_SECURE;FF4B0000;FF4DFFFF;1|LPD;LPD_SLCR;FF410000;FF4AFFFF;1|LPD;LPD_GPV;FE100000;FE1FFFFF;1|LPD;LPD_DMA_7;FFAF0000;FFAFFFFF;1|LPD;LPD_DMA_6;FFAE0000;FFAEFFFF;1|LPD;LPD_DMA_5;FFAD0000;FFADFFFF;1|LPD;LPD_DMA_4;FFAC0000;FFACFFFF;1|LPD;LPD_DMA_3;FFAB0000;FFABFFFF;1|LPD;LPD_DMA_2;FFAA0000;FFAAFFFF;1|LPD;LPD_DMA_1;FFA90000;FFA9FFFF;1|LPD;LPD_DMA_0;FFA80000;FFA8FFFF;1|LPD;IPI_CTRL;FF380000;FF3FFFFF;1|LPD;IOU_SLCR;FF180000;FF23FFFF;1|LPD;IOU_SECURE_SLCR;FF240000;FF24FFFF;1|LPD;IOU_SCNTRS;FF260000;FF26FFFF;1|LPD;IOU_SCNTR;FF250000;FF25FFFF;1|LPD;IOU_GPV;FE000000;FE0FFFFF;1|LPD;I2C1;FF030000;FF03FFFF;1|LPD;I2C0;FF020000;FF02FFFF;0|FPD;GPU;FD4B0000;FD4BFFFF;1|LPD;GPIO;FF0A0000;FF0AFFFF;1|LPD;GEM3;FF0E0000;FF0EFFFF;1|LPD;GEM2;FF0D0000;FF0DFFFF;0|LPD;GEM1;FF0C0000;FF0CFFFF;0|LPD;GEM0;FF0B0000;FF0BFFFF;0|FPD;FPD_XMPU_SINK;FD4F0000;FD4FFFFF;1|FPD;FPD_XMPU_CFG;FD5D0000;FD5DFFFF;1|FPD;FPD_SLCR_SECURE;FD690000;FD6CFFFF;1|FPD;FPD_SLCR;FD610000;FD68FFFF;1|FPD;FPD_GPV;FD700000;FD7FFFFF;1|FPD;FPD_DMA_CH7;FD570000;FD57FFFF;1|FPD;FPD_DMA_CH6;FD560000;FD56FFFF;1|FPD;FPD_DMA_CH5;FD550000;FD55FFFF;1|FPD;FPD_DMA_CH4;FD540000;FD54FFFF;1|FPD;FPD_DMA_CH3;FD530000;FD53FFFF;1|FPD;FPD_DMA_CH2;FD520000;FD52FFFF;1|FPD;FPD_DMA_CH1;FD510000;FD51FFFF;1|FPD;FPD_DMA_CH0;FD500000;FD50FFFF;1|LPD;EFUSE;FFCC0000;FFCCFFFF;1|FPD;Display Port;FD4A0000;FD4AFFFF;1|FPD;DPDMA;FD4C0000;FD4CFFFF;1|FPD;DDR_XMPU5_CFG;FD050000;FD05FFFF;1|FPD;DDR_XMPU4_CFG;FD040000;FD04FFFF;1|FPD;DDR_XMPU3_CFG;FD030000;FD03FFFF;1|FPD;DDR_XMPU2_CFG;FD020000;FD02FFFF;1|FPD;DDR_XMPU1_CFG;FD010000;FD01FFFF;1|FPD;DDR_XMPU0_CFG;FD000000;FD00FFFF;1|FPD;DDR_QOS_CTRL;FD090000;FD09FFFF;1|FPD;DDR_PHY;FD080000;FD08FFFF;1|DDR;DDR_LOW;0;7FFFFFFF;1|DDR;DDR_HIGH;800000000;800000000;0|FPD;DDDR_CTRL;FD070000;FD070FFF;1|LPD;Coresight;FE800000;FEFFFFFF;1|LPD;CSU_DMA;FFC80000;FFC9FFFF;1|LPD;CSU;FFCA0000;FFCAFFFF;0|LPD;CRL_APB;FF5E0000;FF85FFFF;1|FPD;CRF_APB;FD1A0000;FD2DFFFF;1|FPD;CCI_REG;FD5E0000;FD5EFFFF;1|FPD;CCI_GPV;FD6E0000;FD6EFFFF;1|LPD;CAN1;FF070000;FF07FFFF;1|LPD;CAN0;FF060000;FF06FFFF;0|FPD;APU;FD5C0000;FD5CFFFF;1|LPD;APM_INTC_IOU;FFA20000;FFA2FFFF;1|LPD;APM_FPD_LPD;FFA30000;FFA3FFFF;1|FPD;APM_5;FD490000;FD49FFFF;1|FPD;APM_0;FD0B0000;FD0BFFFF;1|LPD;APM2;FFA10000;FFA1FFFF;1|LPD;APM1;FFA00000;FFA0FFFF;1|LPD;AMS;FFA50000;FFA5FFFF;1|FPD;AFI_5;FD3B0000;FD3BFFFF;1|FPD;AFI_4;FD3A0000;FD3AFFFF;1|FPD;AFI_3;FD390000;FD39FFFF;1|FPD;AFI_2;FD380000;FD38FFFF;1|FPD;AFI_1;FD370000;FD37FFFF;1|FPD;AFI_0;FD360000;FD36FFFF;1|LPD;AFIFM6;FF9B0000;FF9BFFFF;1|FPD;ACPU_GIC;F9010000;F907FFFF;1} \
   CONFIG.PSU__PSS_REF_CLK__FREQMHZ {33.333333} \
   CONFIG.PSU__QSPI_COHERENCY {0} \
   CONFIG.PSU__QSPI_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__QSPI__GRP_FBCLK__ENABLE {1} \
   CONFIG.PSU__QSPI__GRP_FBCLK__IO {MIO 6} \
   CONFIG.PSU__QSPI__PERIPHERAL__DATA_MODE {x4} \
   CONFIG.PSU__QSPI__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__QSPI__PERIPHERAL__IO {MIO 0 .. 5} \
   CONFIG.PSU__QSPI__PERIPHERAL__MODE {Single} \
   CONFIG.PSU__SATA__LANE0__ENABLE {0} \
   CONFIG.PSU__SATA__LANE1__ENABLE {1} \
   CONFIG.PSU__SATA__LANE1__IO {GT Lane3} \
   CONFIG.PSU__SATA__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SATA__REF_CLK_FREQ {125} \
   CONFIG.PSU__SATA__REF_CLK_SEL {Ref Clk1} \
   CONFIG.PSU__SAXIGP2__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP3__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP4__DATA_WIDTH {128} \
   CONFIG.PSU__SAXIGP5__DATA_WIDTH {128} \
   CONFIG.PSU__SD1_COHERENCY {0} \
   CONFIG.PSU__SD1_ROUTE_THROUGH_FPD {0} \
   CONFIG.PSU__SD1__DATA_TRANSFER_MODE {4Bit} \
   CONFIG.PSU__SD1__GRP_CD__ENABLE {1} \
   CONFIG.PSU__SD1__GRP_CD__IO {MIO 45} \
   CONFIG.PSU__SD1__GRP_POW__ENABLE {0} \
   CONFIG.PSU__SD1__GRP_WP__ENABLE {0} \
   CONFIG.PSU__SD1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SD1__PERIPHERAL__IO {MIO 46 .. 51} \
   CONFIG.PSU__SD1__RESET__ENABLE {0} \
   CONFIG.PSU__SD1__SLOT_TYPE {SD 2.0} \
   CONFIG.PSU__SWDT0__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT0__RESET__ENABLE {0} \
   CONFIG.PSU__SWDT1__CLOCK__ENABLE {0} \
   CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__SWDT1__RESET__ENABLE {0} \
   CONFIG.PSU__TSU__BUFG_PORT_PAIR {0} \
   CONFIG.PSU__TTC0__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC0__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC1__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC1__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC2__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC2__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__TTC3__CLOCK__ENABLE {0} \
   CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__TTC3__WAVEOUT__ENABLE {0} \
   CONFIG.PSU__UART0__BAUD_RATE {115200} \
   CONFIG.PSU__UART0__MODEM__ENABLE {0} \
   CONFIG.PSU__UART0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART0__PERIPHERAL__IO {MIO 18 .. 19} \
   CONFIG.PSU__UART1__BAUD_RATE {115200} \
   CONFIG.PSU__UART1__MODEM__ENABLE {0} \
   CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 20 .. 21} \
   CONFIG.PSU__USB0_COHERENCY {0} \
   CONFIG.PSU__USB0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB0__PERIPHERAL__IO {MIO 52 .. 63} \
   CONFIG.PSU__USB0__REF_CLK_FREQ {26} \
   CONFIG.PSU__USB0__REF_CLK_SEL {Ref Clk2} \
   CONFIG.PSU__USB0__RESET__ENABLE {0} \
   CONFIG.PSU__USB1__RESET__ENABLE {0} \
   CONFIG.PSU__USB2_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__EMIO__ENABLE {0} \
   CONFIG.PSU__USB3_0__PERIPHERAL__ENABLE {1} \
   CONFIG.PSU__USB3_0__PERIPHERAL__IO {GT Lane2} \
   CONFIG.PSU__USB__RESET__MODE {Boot Pin} \
   CONFIG.PSU__USB__RESET__POLARITY {Active Low} \
   CONFIG.PSU__USE__IRQ0 {1} \
   CONFIG.PSU__USE__M_AXI_GP0 {1} \
   CONFIG.PSU__USE__M_AXI_GP1 {0} \
   CONFIG.PSU__USE__M_AXI_GP2 {0} \
   CONFIG.PSU__USE__S_AXI_GP2 {1} \
   CONFIG.PSU__USE__S_AXI_GP3 {1} \
   CONFIG.PSU__USE__S_AXI_GP4 {1} \
   CONFIG.PSU__USE__S_AXI_GP5 {1} \
   CONFIG.SUBPRESET1 {Custom} \
 ] $zynq_ultra_ps_e_0

  # Create interface connections
  connect_bd_intf_net -intf_net axi_smc_1_M00_AXI [get_bd_intf_pins axi_smc_1/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP1_FPD]
  connect_bd_intf_net -intf_net axi_smc_2_M00_AXI [get_bd_intf_pins axi_smc_2/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP2_FPD]
  connect_bd_intf_net -intf_net axi_smc_3_M00_AXI [get_bd_intf_pins axi_smc_3/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP3_FPD]
  connect_bd_intf_net -intf_net axi_smc_M00_AXI [get_bd_intf_pins axi_smc/M00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/S_AXI_HP0_FPD]
  connect_bd_intf_net -intf_net geometric_values_10_M_AXI_MM2S [get_bd_intf_pins axi_smc_3/S04_AXI] [get_bd_intf_pins geometric_values_10/M_AXI_MM2S]
  connect_bd_intf_net -intf_net geometric_values_10_M_AXI_MM2S1 [get_bd_intf_pins axi_smc_3/S05_AXI] [get_bd_intf_pins geometric_values_10/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net geometric_values_10_M_AXI_MM2S2 [get_bd_intf_pins axi_smc_3/S06_AXI] [get_bd_intf_pins geometric_values_10/M_AXI_MM2S2]
  connect_bd_intf_net -intf_net geometric_values_10_M_AXI_MM2S3 [get_bd_intf_pins axi_smc_3/S07_AXI] [get_bd_intf_pins geometric_values_10/M_AXI_MM2S3]
  connect_bd_intf_net -intf_net geometric_values_10_M_AXI_S2MM [get_bd_intf_pins axi_smc_3/S08_AXI] [get_bd_intf_pins geometric_values_10/M_AXI_S2MM]
  connect_bd_intf_net -intf_net geometric_values_11_M_AXI_MM2S [get_bd_intf_pins axi_smc_3/S09_AXI] [get_bd_intf_pins geometric_values_11/M_AXI_MM2S]
  connect_bd_intf_net -intf_net geometric_values_11_M_AXI_MM2S1 [get_bd_intf_pins axi_smc_3/S10_AXI] [get_bd_intf_pins geometric_values_11/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net geometric_values_11_M_AXI_MM2S2 [get_bd_intf_pins axi_smc_3/S11_AXI] [get_bd_intf_pins geometric_values_11/M_AXI_MM2S2]
  connect_bd_intf_net -intf_net geometric_values_11_M_AXI_MM2S3 [get_bd_intf_pins axi_smc_3/S12_AXI] [get_bd_intf_pins geometric_values_11/M_AXI_MM2S3]
  connect_bd_intf_net -intf_net geometric_values_11_M_AXI_S2MM [get_bd_intf_pins axi_smc_3/S13_AXI] [get_bd_intf_pins geometric_values_11/M_AXI_S2MM]
  connect_bd_intf_net -intf_net geometric_values_1_M_AXI_MM2S [get_bd_intf_pins axi_smc/S00_AXI] [get_bd_intf_pins geometric_values_1/M_AXI_MM2S]
  connect_bd_intf_net -intf_net geometric_values_1_M_AXI_MM2S1 [get_bd_intf_pins axi_smc/S01_AXI] [get_bd_intf_pins geometric_values_1/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net geometric_values_1_M_AXI_MM2S2 [get_bd_intf_pins axi_smc/S02_AXI] [get_bd_intf_pins geometric_values_1/M_AXI_MM2S2]
  connect_bd_intf_net -intf_net geometric_values_1_M_AXI_MM2S3 [get_bd_intf_pins axi_smc/S03_AXI] [get_bd_intf_pins geometric_values_1/M_AXI_MM2S3]
  connect_bd_intf_net -intf_net geometric_values_1_M_AXI_S2MM [get_bd_intf_pins axi_smc/S04_AXI] [get_bd_intf_pins geometric_values_1/M_AXI_S2MM]
  connect_bd_intf_net -intf_net geometric_values_2_M_AXI_MM2S [get_bd_intf_pins axi_smc/S05_AXI] [get_bd_intf_pins geometric_values_2/M_AXI_MM2S]
  connect_bd_intf_net -intf_net geometric_values_2_M_AXI_MM2S1 [get_bd_intf_pins axi_smc/S06_AXI] [get_bd_intf_pins geometric_values_2/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net geometric_values_2_M_AXI_MM2S2 [get_bd_intf_pins axi_smc/S07_AXI] [get_bd_intf_pins geometric_values_2/M_AXI_MM2S2]
  connect_bd_intf_net -intf_net geometric_values_2_M_AXI_MM2S3 [get_bd_intf_pins axi_smc/S08_AXI] [get_bd_intf_pins geometric_values_2/M_AXI_MM2S3]
  connect_bd_intf_net -intf_net geometric_values_2_M_AXI_S2MM [get_bd_intf_pins axi_smc/S09_AXI] [get_bd_intf_pins geometric_values_2/M_AXI_S2MM]
  connect_bd_intf_net -intf_net geometric_values_3_M_AXI_MM2S [get_bd_intf_pins axi_smc/S10_AXI] [get_bd_intf_pins geometric_values_3/M_AXI_MM2S]
  connect_bd_intf_net -intf_net geometric_values_3_M_AXI_MM2S1 [get_bd_intf_pins axi_smc/S11_AXI] [get_bd_intf_pins geometric_values_3/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net geometric_values_3_M_AXI_MM2S2 [get_bd_intf_pins axi_smc/S12_AXI] [get_bd_intf_pins geometric_values_3/M_AXI_MM2S2]
  connect_bd_intf_net -intf_net geometric_values_3_M_AXI_MM2S3 [get_bd_intf_pins axi_smc/S13_AXI] [get_bd_intf_pins geometric_values_3/M_AXI_MM2S3]
  connect_bd_intf_net -intf_net geometric_values_3_M_AXI_S2MM [get_bd_intf_pins axi_smc/S14_AXI] [get_bd_intf_pins geometric_values_3/M_AXI_S2MM]
  connect_bd_intf_net -intf_net geometric_values_4_M_AXI_MM2S [get_bd_intf_pins axi_smc/S15_AXI] [get_bd_intf_pins geometric_values_4/M_AXI_MM2S]
  connect_bd_intf_net -intf_net geometric_values_4_M_AXI_MM2S1 [get_bd_intf_pins axi_smc_1/S01_AXI] [get_bd_intf_pins geometric_values_4/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net geometric_values_4_M_AXI_MM2S2 [get_bd_intf_pins axi_smc_1/S02_AXI] [get_bd_intf_pins geometric_values_4/M_AXI_MM2S2]
  connect_bd_intf_net -intf_net geometric_values_4_M_AXI_MM2S3 [get_bd_intf_pins axi_smc_1/S03_AXI] [get_bd_intf_pins geometric_values_4/M_AXI_MM2S3]
  connect_bd_intf_net -intf_net geometric_values_4_M_AXI_S2MM [get_bd_intf_pins axi_smc_1/S04_AXI] [get_bd_intf_pins geometric_values_4/M_AXI_S2MM]
  connect_bd_intf_net -intf_net geometric_values_5_M_AXI_MM2S [get_bd_intf_pins axi_smc_1/S05_AXI] [get_bd_intf_pins geometric_values_5/M_AXI_MM2S]
  connect_bd_intf_net -intf_net geometric_values_5_M_AXI_MM2S1 [get_bd_intf_pins axi_smc_1/S06_AXI] [get_bd_intf_pins geometric_values_5/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net geometric_values_5_M_AXI_MM2S2 [get_bd_intf_pins axi_smc_1/S07_AXI] [get_bd_intf_pins geometric_values_5/M_AXI_MM2S2]
  connect_bd_intf_net -intf_net geometric_values_5_M_AXI_MM2S3 [get_bd_intf_pins axi_smc_1/S08_AXI] [get_bd_intf_pins geometric_values_5/M_AXI_MM2S3]
  connect_bd_intf_net -intf_net geometric_values_5_M_AXI_S2MM [get_bd_intf_pins axi_smc_1/S09_AXI] [get_bd_intf_pins geometric_values_5/M_AXI_S2MM]
  connect_bd_intf_net -intf_net geometric_values_6_M_AXI_MM2S [get_bd_intf_pins axi_smc_2/S00_AXI] [get_bd_intf_pins geometric_values_6/M_AXI_MM2S]
  connect_bd_intf_net -intf_net geometric_values_6_M_AXI_MM2S1 [get_bd_intf_pins axi_smc_2/S01_AXI] [get_bd_intf_pins geometric_values_6/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net geometric_values_6_M_AXI_MM2S2 [get_bd_intf_pins axi_smc_2/S02_AXI] [get_bd_intf_pins geometric_values_6/M_AXI_MM2S2]
  connect_bd_intf_net -intf_net geometric_values_6_M_AXI_MM2S3 [get_bd_intf_pins axi_smc_2/S03_AXI] [get_bd_intf_pins geometric_values_6/M_AXI_MM2S3]
  connect_bd_intf_net -intf_net geometric_values_6_M_AXI_S2MM [get_bd_intf_pins axi_smc_2/S04_AXI] [get_bd_intf_pins geometric_values_6/M_AXI_S2MM]
  connect_bd_intf_net -intf_net geometric_values_7_M_AXI_MM2S [get_bd_intf_pins axi_smc_2/S05_AXI] [get_bd_intf_pins geometric_values_7/M_AXI_MM2S]
  connect_bd_intf_net -intf_net geometric_values_7_M_AXI_MM2S1 [get_bd_intf_pins axi_smc_2/S06_AXI] [get_bd_intf_pins geometric_values_7/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net geometric_values_7_M_AXI_MM2S2 [get_bd_intf_pins axi_smc_2/S07_AXI] [get_bd_intf_pins geometric_values_7/M_AXI_MM2S2]
  connect_bd_intf_net -intf_net geometric_values_7_M_AXI_MM2S3 [get_bd_intf_pins axi_smc_2/S08_AXI] [get_bd_intf_pins geometric_values_7/M_AXI_MM2S3]
  connect_bd_intf_net -intf_net geometric_values_7_M_AXI_S2MM [get_bd_intf_pins axi_smc_2/S09_AXI] [get_bd_intf_pins geometric_values_7/M_AXI_S2MM]
  connect_bd_intf_net -intf_net geometric_values_8_M_AXI_MM2S [get_bd_intf_pins axi_smc_2/S10_AXI] [get_bd_intf_pins geometric_values_8/M_AXI_MM2S]
  connect_bd_intf_net -intf_net geometric_values_8_M_AXI_MM2S1 [get_bd_intf_pins axi_smc_2/S11_AXI] [get_bd_intf_pins geometric_values_8/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net geometric_values_8_M_AXI_MM2S2 [get_bd_intf_pins axi_smc_2/S12_AXI] [get_bd_intf_pins geometric_values_8/M_AXI_MM2S2]
  connect_bd_intf_net -intf_net geometric_values_8_M_AXI_MM2S3 [get_bd_intf_pins axi_smc_2/S13_AXI] [get_bd_intf_pins geometric_values_8/M_AXI_MM2S3]
  connect_bd_intf_net -intf_net geometric_values_8_M_AXI_S2MM [get_bd_intf_pins axi_smc_2/S14_AXI] [get_bd_intf_pins geometric_values_8/M_AXI_S2MM]
  connect_bd_intf_net -intf_net geometric_values_9_M_AXI_MM2S [get_bd_intf_pins axi_smc_2/S15_AXI] [get_bd_intf_pins geometric_values_9/M_AXI_MM2S]
  connect_bd_intf_net -intf_net geometric_values_9_M_AXI_MM2S1 [get_bd_intf_pins axi_smc_3/S00_AXI] [get_bd_intf_pins geometric_values_9/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net geometric_values_9_M_AXI_MM2S2 [get_bd_intf_pins axi_smc_3/S01_AXI] [get_bd_intf_pins geometric_values_9/M_AXI_MM2S2]
  connect_bd_intf_net -intf_net geometric_values_9_M_AXI_MM2S3 [get_bd_intf_pins axi_smc_3/S02_AXI] [get_bd_intf_pins geometric_values_9/M_AXI_MM2S3]
  connect_bd_intf_net -intf_net geometric_values_9_M_AXI_S2MM [get_bd_intf_pins axi_smc_3/S03_AXI] [get_bd_intf_pins geometric_values_9/M_AXI_S2MM]
  connect_bd_intf_net -intf_net get_w_1_M_AXI_MM2S [get_bd_intf_pins axi_smc_1/S10_AXI] [get_bd_intf_pins get_w_1/M_AXI_MM2S]
  connect_bd_intf_net -intf_net get_w_1_M_AXI_MM2S1 [get_bd_intf_pins axi_smc_1/S11_AXI] [get_bd_intf_pins get_w_1/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net get_w_1_M_AXI_MM2S2 [get_bd_intf_pins axi_smc_1/S12_AXI] [get_bd_intf_pins get_w_1/M_AXI_MM2S2]
  connect_bd_intf_net -intf_net get_w_1_M_AXI_S2MM [get_bd_intf_pins axi_smc_1/S13_AXI] [get_bd_intf_pins get_w_1/M_AXI_S2MM]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M00_AXI [get_bd_intf_pins geometric_values_1/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M00_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M01_AXI [get_bd_intf_pins geometric_values_1/S_AXI_LITE1] [get_bd_intf_pins ps8_0_axi_periph/M01_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M02_AXI [get_bd_intf_pins geometric_values_1/S_AXI_LITE2] [get_bd_intf_pins ps8_0_axi_periph/M02_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M03_AXI [get_bd_intf_pins geometric_values_1/S_AXI_LITE3] [get_bd_intf_pins ps8_0_axi_periph/M03_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M04_AXI [get_bd_intf_pins geometric_values_1/S_AXI_LITE4] [get_bd_intf_pins ps8_0_axi_periph/M04_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M05_AXI [get_bd_intf_pins get_w_1/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M05_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M06_AXI [get_bd_intf_pins get_w_1/S_AXI_LITE1] [get_bd_intf_pins ps8_0_axi_periph/M06_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M07_AXI [get_bd_intf_pins get_w_1/S_AXI_LITE2] [get_bd_intf_pins ps8_0_axi_periph/M07_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M08_AXI [get_bd_intf_pins get_w_1/S_AXI_LITE3] [get_bd_intf_pins ps8_0_axi_periph/M08_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M09_AXI [get_bd_intf_pins ps8_0_axi_periph/M09_AXI] [get_bd_intf_pins test_predictions_1/S_AXI_LITE]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M10_AXI [get_bd_intf_pins ps8_0_axi_periph/M10_AXI] [get_bd_intf_pins test_predictions_1/S_AXI_LITE1]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M11_AXI [get_bd_intf_pins ps8_0_axi_periph/M11_AXI] [get_bd_intf_pins test_predictions_1/S_AXI_LITE2]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M12_AXI [get_bd_intf_pins geometric_values_2/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M12_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M13_AXI [get_bd_intf_pins geometric_values_2/S_AXI_LITE1] [get_bd_intf_pins ps8_0_axi_periph/M13_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M14_AXI [get_bd_intf_pins geometric_values_2/S_AXI_LITE2] [get_bd_intf_pins ps8_0_axi_periph/M14_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M15_AXI [get_bd_intf_pins geometric_values_2/S_AXI_LITE3] [get_bd_intf_pins ps8_0_axi_periph/M15_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M16_AXI [get_bd_intf_pins geometric_values_2/S_AXI_LITE4] [get_bd_intf_pins ps8_0_axi_periph/M16_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M17_AXI [get_bd_intf_pins geometric_values_3/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M17_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M18_AXI [get_bd_intf_pins geometric_values_3/S_AXI_LITE1] [get_bd_intf_pins ps8_0_axi_periph/M18_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M19_AXI [get_bd_intf_pins geometric_values_3/S_AXI_LITE2] [get_bd_intf_pins ps8_0_axi_periph/M19_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M20_AXI [get_bd_intf_pins geometric_values_3/S_AXI_LITE3] [get_bd_intf_pins ps8_0_axi_periph/M20_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M21_AXI [get_bd_intf_pins geometric_values_3/S_AXI_LITE4] [get_bd_intf_pins ps8_0_axi_periph/M21_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M22_AXI [get_bd_intf_pins geometric_values_4/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M22_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M23_AXI [get_bd_intf_pins geometric_values_4/S_AXI_LITE1] [get_bd_intf_pins ps8_0_axi_periph/M23_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M24_AXI [get_bd_intf_pins geometric_values_4/S_AXI_LITE2] [get_bd_intf_pins ps8_0_axi_periph/M24_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M25_AXI [get_bd_intf_pins geometric_values_4/S_AXI_LITE3] [get_bd_intf_pins ps8_0_axi_periph/M25_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M26_AXI [get_bd_intf_pins geometric_values_4/S_AXI_LITE4] [get_bd_intf_pins ps8_0_axi_periph/M26_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M27_AXI [get_bd_intf_pins geometric_values_5/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M27_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M28_AXI [get_bd_intf_pins geometric_values_5/S_AXI_LITE1] [get_bd_intf_pins ps8_0_axi_periph/M28_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M29_AXI [get_bd_intf_pins geometric_values_5/S_AXI_LITE2] [get_bd_intf_pins ps8_0_axi_periph/M29_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M30_AXI [get_bd_intf_pins geometric_values_5/S_AXI_LITE3] [get_bd_intf_pins ps8_0_axi_periph/M30_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M31_AXI [get_bd_intf_pins geometric_values_5/S_AXI_LITE4] [get_bd_intf_pins ps8_0_axi_periph/M31_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M32_AXI [get_bd_intf_pins geometric_values_6/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M32_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M33_AXI [get_bd_intf_pins geometric_values_6/S_AXI_LITE1] [get_bd_intf_pins ps8_0_axi_periph/M33_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M34_AXI [get_bd_intf_pins geometric_values_6/S_AXI_LITE2] [get_bd_intf_pins ps8_0_axi_periph/M34_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M35_AXI [get_bd_intf_pins geometric_values_6/S_AXI_LITE3] [get_bd_intf_pins ps8_0_axi_periph/M35_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M36_AXI [get_bd_intf_pins geometric_values_6/S_AXI_LITE4] [get_bd_intf_pins ps8_0_axi_periph/M36_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M37_AXI [get_bd_intf_pins geometric_values_7/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M37_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M38_AXI [get_bd_intf_pins geometric_values_7/S_AXI_LITE1] [get_bd_intf_pins ps8_0_axi_periph/M38_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M39_AXI [get_bd_intf_pins geometric_values_7/S_AXI_LITE2] [get_bd_intf_pins ps8_0_axi_periph/M39_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M40_AXI [get_bd_intf_pins geometric_values_7/S_AXI_LITE3] [get_bd_intf_pins ps8_0_axi_periph/M40_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M41_AXI [get_bd_intf_pins geometric_values_7/S_AXI_LITE4] [get_bd_intf_pins ps8_0_axi_periph/M41_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M42_AXI [get_bd_intf_pins geometric_values_8/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M42_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M43_AXI [get_bd_intf_pins geometric_values_8/S_AXI_LITE1] [get_bd_intf_pins ps8_0_axi_periph/M43_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M44_AXI [get_bd_intf_pins geometric_values_8/S_AXI_LITE2] [get_bd_intf_pins ps8_0_axi_periph/M44_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M45_AXI [get_bd_intf_pins geometric_values_8/S_AXI_LITE3] [get_bd_intf_pins ps8_0_axi_periph/M45_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M46_AXI [get_bd_intf_pins geometric_values_8/S_AXI_LITE4] [get_bd_intf_pins ps8_0_axi_periph/M46_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M47_AXI [get_bd_intf_pins geometric_values_9/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M47_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M48_AXI [get_bd_intf_pins geometric_values_9/S_AXI_LITE1] [get_bd_intf_pins ps8_0_axi_periph/M48_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M49_AXI [get_bd_intf_pins geometric_values_9/S_AXI_LITE2] [get_bd_intf_pins ps8_0_axi_periph/M49_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M50_AXI [get_bd_intf_pins geometric_values_9/S_AXI_LITE3] [get_bd_intf_pins ps8_0_axi_periph/M50_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M51_AXI [get_bd_intf_pins geometric_values_9/S_AXI_LITE4] [get_bd_intf_pins ps8_0_axi_periph/M51_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M52_AXI [get_bd_intf_pins geometric_values_10/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M52_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M53_AXI [get_bd_intf_pins geometric_values_10/S_AXI_LITE1] [get_bd_intf_pins ps8_0_axi_periph/M53_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M54_AXI [get_bd_intf_pins geometric_values_10/S_AXI_LITE2] [get_bd_intf_pins ps8_0_axi_periph/M54_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M55_AXI [get_bd_intf_pins geometric_values_10/S_AXI_LITE3] [get_bd_intf_pins ps8_0_axi_periph/M55_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M56_AXI [get_bd_intf_pins geometric_values_10/S_AXI_LITE4] [get_bd_intf_pins ps8_0_axi_periph/M56_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M57_AXI [get_bd_intf_pins geometric_values_11/S_AXI_LITE] [get_bd_intf_pins ps8_0_axi_periph/M57_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M58_AXI [get_bd_intf_pins geometric_values_11/S_AXI_LITE1] [get_bd_intf_pins ps8_0_axi_periph/M58_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M59_AXI [get_bd_intf_pins geometric_values_11/S_AXI_LITE2] [get_bd_intf_pins ps8_0_axi_periph/M59_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M60_AXI [get_bd_intf_pins geometric_values_11/S_AXI_LITE3] [get_bd_intf_pins ps8_0_axi_periph/M60_AXI]
  connect_bd_intf_net -intf_net ps8_0_axi_periph_M61_AXI [get_bd_intf_pins geometric_values_11/S_AXI_LITE4] [get_bd_intf_pins ps8_0_axi_periph/M61_AXI]
  connect_bd_intf_net -intf_net test_predictions_1_M_AXI_MM2S [get_bd_intf_pins axi_smc_1/S00_AXI] [get_bd_intf_pins test_predictions_1/M_AXI_MM2S]
  connect_bd_intf_net -intf_net test_predictions_1_M_AXI_MM2S1 [get_bd_intf_pins axi_smc_1/S14_AXI] [get_bd_intf_pins test_predictions_1/M_AXI_MM2S1]
  connect_bd_intf_net -intf_net test_predictions_1_M_AXI_S2MM [get_bd_intf_pins axi_smc_1/S15_AXI] [get_bd_intf_pins test_predictions_1/M_AXI_S2MM]
  connect_bd_intf_net -intf_net zynq_ultra_ps_e_0_M_AXI_HPM0_FPD [get_bd_intf_pins ps8_0_axi_periph/S00_AXI] [get_bd_intf_pins zynq_ultra_ps_e_0/M_AXI_HPM0_FPD]

  # Create port connections
  connect_bd_net -net rst_ps8_0_100M_peripheral_aresetn [get_bd_pins axi_smc/aresetn] [get_bd_pins axi_smc_1/aresetn] [get_bd_pins axi_smc_2/aresetn] [get_bd_pins axi_smc_3/aresetn] [get_bd_pins geometric_values_1/axi_resetn] [get_bd_pins geometric_values_10/axi_resetn] [get_bd_pins geometric_values_11/axi_resetn] [get_bd_pins geometric_values_2/axi_resetn] [get_bd_pins geometric_values_3/axi_resetn] [get_bd_pins geometric_values_4/axi_resetn] [get_bd_pins geometric_values_5/axi_resetn] [get_bd_pins geometric_values_6/axi_resetn] [get_bd_pins geometric_values_7/axi_resetn] [get_bd_pins geometric_values_8/axi_resetn] [get_bd_pins geometric_values_9/axi_resetn] [get_bd_pins get_w_1/ap_rst_n] [get_bd_pins ps8_0_axi_periph/ARESETN] [get_bd_pins ps8_0_axi_periph/M00_ARESETN] [get_bd_pins ps8_0_axi_periph/M01_ARESETN] [get_bd_pins ps8_0_axi_periph/M02_ARESETN] [get_bd_pins ps8_0_axi_periph/M03_ARESETN] [get_bd_pins ps8_0_axi_periph/M04_ARESETN] [get_bd_pins ps8_0_axi_periph/M05_ARESETN] [get_bd_pins ps8_0_axi_periph/M06_ARESETN] [get_bd_pins ps8_0_axi_periph/M07_ARESETN] [get_bd_pins ps8_0_axi_periph/M08_ARESETN] [get_bd_pins ps8_0_axi_periph/M09_ARESETN] [get_bd_pins ps8_0_axi_periph/M10_ARESETN] [get_bd_pins ps8_0_axi_periph/M11_ARESETN] [get_bd_pins ps8_0_axi_periph/M12_ARESETN] [get_bd_pins ps8_0_axi_periph/M13_ARESETN] [get_bd_pins ps8_0_axi_periph/M14_ARESETN] [get_bd_pins ps8_0_axi_periph/M15_ARESETN] [get_bd_pins ps8_0_axi_periph/M16_ARESETN] [get_bd_pins ps8_0_axi_periph/M17_ARESETN] [get_bd_pins ps8_0_axi_periph/M18_ARESETN] [get_bd_pins ps8_0_axi_periph/M19_ARESETN] [get_bd_pins ps8_0_axi_periph/M20_ARESETN] [get_bd_pins ps8_0_axi_periph/M21_ARESETN] [get_bd_pins ps8_0_axi_periph/M22_ARESETN] [get_bd_pins ps8_0_axi_periph/M23_ARESETN] [get_bd_pins ps8_0_axi_periph/M24_ARESETN] [get_bd_pins ps8_0_axi_periph/M25_ARESETN] [get_bd_pins ps8_0_axi_periph/M26_ARESETN] [get_bd_pins ps8_0_axi_periph/M27_ARESETN] [get_bd_pins ps8_0_axi_periph/M28_ARESETN] [get_bd_pins ps8_0_axi_periph/M29_ARESETN] [get_bd_pins ps8_0_axi_periph/M30_ARESETN] [get_bd_pins ps8_0_axi_periph/M31_ARESETN] [get_bd_pins ps8_0_axi_periph/M32_ARESETN] [get_bd_pins ps8_0_axi_periph/M33_ARESETN] [get_bd_pins ps8_0_axi_periph/M34_ARESETN] [get_bd_pins ps8_0_axi_periph/M35_ARESETN] [get_bd_pins ps8_0_axi_periph/M36_ARESETN] [get_bd_pins ps8_0_axi_periph/M37_ARESETN] [get_bd_pins ps8_0_axi_periph/M38_ARESETN] [get_bd_pins ps8_0_axi_periph/M39_ARESETN] [get_bd_pins ps8_0_axi_periph/M40_ARESETN] [get_bd_pins ps8_0_axi_periph/M41_ARESETN] [get_bd_pins ps8_0_axi_periph/M42_ARESETN] [get_bd_pins ps8_0_axi_periph/M43_ARESETN] [get_bd_pins ps8_0_axi_periph/M44_ARESETN] [get_bd_pins ps8_0_axi_periph/M45_ARESETN] [get_bd_pins ps8_0_axi_periph/M46_ARESETN] [get_bd_pins ps8_0_axi_periph/M47_ARESETN] [get_bd_pins ps8_0_axi_periph/M48_ARESETN] [get_bd_pins ps8_0_axi_periph/M49_ARESETN] [get_bd_pins ps8_0_axi_periph/M50_ARESETN] [get_bd_pins ps8_0_axi_periph/M51_ARESETN] [get_bd_pins ps8_0_axi_periph/M52_ARESETN] [get_bd_pins ps8_0_axi_periph/M53_ARESETN] [get_bd_pins ps8_0_axi_periph/M54_ARESETN] [get_bd_pins ps8_0_axi_periph/M55_ARESETN] [get_bd_pins ps8_0_axi_periph/M56_ARESETN] [get_bd_pins ps8_0_axi_periph/M57_ARESETN] [get_bd_pins ps8_0_axi_periph/M58_ARESETN] [get_bd_pins ps8_0_axi_periph/M59_ARESETN] [get_bd_pins ps8_0_axi_periph/M60_ARESETN] [get_bd_pins ps8_0_axi_periph/M61_ARESETN] [get_bd_pins ps8_0_axi_periph/S00_ARESETN] [get_bd_pins rst_ps8_0_100M/peripheral_aresetn] [get_bd_pins test_predictions_1/axi_resetn]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins axi_smc/aclk] [get_bd_pins axi_smc_1/aclk] [get_bd_pins axi_smc_2/aclk] [get_bd_pins axi_smc_3/aclk] [get_bd_pins geometric_values_1/s_axi_lite_aclk] [get_bd_pins geometric_values_10/s_axi_lite_aclk] [get_bd_pins geometric_values_11/s_axi_lite_aclk] [get_bd_pins geometric_values_2/s_axi_lite_aclk] [get_bd_pins geometric_values_3/s_axi_lite_aclk] [get_bd_pins geometric_values_4/s_axi_lite_aclk] [get_bd_pins geometric_values_5/s_axi_lite_aclk] [get_bd_pins geometric_values_6/s_axi_lite_aclk] [get_bd_pins geometric_values_7/s_axi_lite_aclk] [get_bd_pins geometric_values_8/s_axi_lite_aclk] [get_bd_pins geometric_values_9/s_axi_lite_aclk] [get_bd_pins get_w_1/ap_clk] [get_bd_pins ps8_0_axi_periph/ACLK] [get_bd_pins ps8_0_axi_periph/M00_ACLK] [get_bd_pins ps8_0_axi_periph/M01_ACLK] [get_bd_pins ps8_0_axi_periph/M02_ACLK] [get_bd_pins ps8_0_axi_periph/M03_ACLK] [get_bd_pins ps8_0_axi_periph/M04_ACLK] [get_bd_pins ps8_0_axi_periph/M05_ACLK] [get_bd_pins ps8_0_axi_periph/M06_ACLK] [get_bd_pins ps8_0_axi_periph/M07_ACLK] [get_bd_pins ps8_0_axi_periph/M08_ACLK] [get_bd_pins ps8_0_axi_periph/M09_ACLK] [get_bd_pins ps8_0_axi_periph/M10_ACLK] [get_bd_pins ps8_0_axi_periph/M11_ACLK] [get_bd_pins ps8_0_axi_periph/M12_ACLK] [get_bd_pins ps8_0_axi_periph/M13_ACLK] [get_bd_pins ps8_0_axi_periph/M14_ACLK] [get_bd_pins ps8_0_axi_periph/M15_ACLK] [get_bd_pins ps8_0_axi_periph/M16_ACLK] [get_bd_pins ps8_0_axi_periph/M17_ACLK] [get_bd_pins ps8_0_axi_periph/M18_ACLK] [get_bd_pins ps8_0_axi_periph/M19_ACLK] [get_bd_pins ps8_0_axi_periph/M20_ACLK] [get_bd_pins ps8_0_axi_periph/M21_ACLK] [get_bd_pins ps8_0_axi_periph/M22_ACLK] [get_bd_pins ps8_0_axi_periph/M23_ACLK] [get_bd_pins ps8_0_axi_periph/M24_ACLK] [get_bd_pins ps8_0_axi_periph/M25_ACLK] [get_bd_pins ps8_0_axi_periph/M26_ACLK] [get_bd_pins ps8_0_axi_periph/M27_ACLK] [get_bd_pins ps8_0_axi_periph/M28_ACLK] [get_bd_pins ps8_0_axi_periph/M29_ACLK] [get_bd_pins ps8_0_axi_periph/M30_ACLK] [get_bd_pins ps8_0_axi_periph/M31_ACLK] [get_bd_pins ps8_0_axi_periph/M32_ACLK] [get_bd_pins ps8_0_axi_periph/M33_ACLK] [get_bd_pins ps8_0_axi_periph/M34_ACLK] [get_bd_pins ps8_0_axi_periph/M35_ACLK] [get_bd_pins ps8_0_axi_periph/M36_ACLK] [get_bd_pins ps8_0_axi_periph/M37_ACLK] [get_bd_pins ps8_0_axi_periph/M38_ACLK] [get_bd_pins ps8_0_axi_periph/M39_ACLK] [get_bd_pins ps8_0_axi_periph/M40_ACLK] [get_bd_pins ps8_0_axi_periph/M41_ACLK] [get_bd_pins ps8_0_axi_periph/M42_ACLK] [get_bd_pins ps8_0_axi_periph/M43_ACLK] [get_bd_pins ps8_0_axi_periph/M44_ACLK] [get_bd_pins ps8_0_axi_periph/M45_ACLK] [get_bd_pins ps8_0_axi_periph/M46_ACLK] [get_bd_pins ps8_0_axi_periph/M47_ACLK] [get_bd_pins ps8_0_axi_periph/M48_ACLK] [get_bd_pins ps8_0_axi_periph/M49_ACLK] [get_bd_pins ps8_0_axi_periph/M50_ACLK] [get_bd_pins ps8_0_axi_periph/M51_ACLK] [get_bd_pins ps8_0_axi_periph/M52_ACLK] [get_bd_pins ps8_0_axi_periph/M53_ACLK] [get_bd_pins ps8_0_axi_periph/M54_ACLK] [get_bd_pins ps8_0_axi_periph/M55_ACLK] [get_bd_pins ps8_0_axi_periph/M56_ACLK] [get_bd_pins ps8_0_axi_periph/M57_ACLK] [get_bd_pins ps8_0_axi_periph/M58_ACLK] [get_bd_pins ps8_0_axi_periph/M59_ACLK] [get_bd_pins ps8_0_axi_periph/M60_ACLK] [get_bd_pins ps8_0_axi_periph/M61_ACLK] [get_bd_pins ps8_0_axi_periph/S00_ACLK] [get_bd_pins rst_ps8_0_100M/slowest_sync_clk] [get_bd_pins test_predictions_1/s_axi_lite_aclk] [get_bd_pins zynq_ultra_ps_e_0/maxihpm0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/pl_clk0] [get_bd_pins zynq_ultra_ps_e_0/saxihp0_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp1_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp2_fpd_aclk] [get_bd_pins zynq_ultra_ps_e_0/saxihp3_fpd_aclk]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_resetn0 [get_bd_pins rst_ps8_0_100M/ext_reset_in] [get_bd_pins zynq_ultra_ps_e_0/pl_resetn0]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0xA0002000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_1/dma_cf/S_AXI_LITE/Reg] SEG_dma_cf_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA0006000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs get_w_1/dma_cf/S_AXI_LITE/Reg] SEG_dma_cf_Reg1
  create_bd_addr_seg -range 0x00001000 -offset 0xA000E000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_2/dma_cf/S_AXI_LITE/Reg] SEG_dma_cf_Reg2
  create_bd_addr_seg -range 0x00001000 -offset 0xA0013000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_3/dma_cf/S_AXI_LITE/Reg] SEG_dma_cf_Reg3
  create_bd_addr_seg -range 0x00001000 -offset 0xA0018000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_4/dma_cf/S_AXI_LITE/Reg] SEG_dma_cf_Reg4
  create_bd_addr_seg -range 0x00001000 -offset 0xA001D000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_5/dma_cf/S_AXI_LITE/Reg] SEG_dma_cf_Reg5
  create_bd_addr_seg -range 0x00001000 -offset 0xA0022000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_6/dma_cf/S_AXI_LITE/Reg] SEG_dma_cf_Reg6
  create_bd_addr_seg -range 0x00001000 -offset 0xA0027000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_7/dma_cf/S_AXI_LITE/Reg] SEG_dma_cf_Reg7
  create_bd_addr_seg -range 0x00001000 -offset 0xA002C000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_8/dma_cf/S_AXI_LITE/Reg] SEG_dma_cf_Reg8
  create_bd_addr_seg -range 0x00001000 -offset 0xA0031000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_9/dma_cf/S_AXI_LITE/Reg] SEG_dma_cf_Reg9
  create_bd_addr_seg -range 0x00001000 -offset 0xA0036000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_10/dma_cf/S_AXI_LITE/Reg] SEG_dma_cf_Reg10
  create_bd_addr_seg -range 0x00001000 -offset 0xA003B000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_11/dma_cf/S_AXI_LITE/Reg] SEG_dma_cf_Reg11
  create_bd_addr_seg -range 0x00001000 -offset 0xA0001000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_1/dma_ds/S_AXI_LITE/Reg] SEG_dma_ds_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA0005000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs get_w_1/dma_ds/S_AXI_LITE/Reg] SEG_dma_ds_Reg1
  create_bd_addr_seg -range 0x00001000 -offset 0xA000A000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs test_predictions_1/dma_ds/S_AXI_LITE/Reg] SEG_dma_ds_Reg2
  create_bd_addr_seg -range 0x00001000 -offset 0xA000D000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_2/dma_ds/S_AXI_LITE/Reg] SEG_dma_ds_Reg3
  create_bd_addr_seg -range 0x00001000 -offset 0xA0012000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_3/dma_ds/S_AXI_LITE/Reg] SEG_dma_ds_Reg4
  create_bd_addr_seg -range 0x00001000 -offset 0xA0017000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_4/dma_ds/S_AXI_LITE/Reg] SEG_dma_ds_Reg5
  create_bd_addr_seg -range 0x00001000 -offset 0xA001C000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_5/dma_ds/S_AXI_LITE/Reg] SEG_dma_ds_Reg6
  create_bd_addr_seg -range 0x00001000 -offset 0xA0021000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_6/dma_ds/S_AXI_LITE/Reg] SEG_dma_ds_Reg7
  create_bd_addr_seg -range 0x00001000 -offset 0xA0026000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_7/dma_ds/S_AXI_LITE/Reg] SEG_dma_ds_Reg8
  create_bd_addr_seg -range 0x00001000 -offset 0xA002B000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_8/dma_ds/S_AXI_LITE/Reg] SEG_dma_ds_Reg9
  create_bd_addr_seg -range 0x00001000 -offset 0xA0030000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_9/dma_ds/S_AXI_LITE/Reg] SEG_dma_ds_Reg10
  create_bd_addr_seg -range 0x00001000 -offset 0xA0035000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_10/dma_ds/S_AXI_LITE/Reg] SEG_dma_ds_Reg11
  create_bd_addr_seg -range 0x00001000 -offset 0xA003A000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_11/dma_ds/S_AXI_LITE/Reg] SEG_dma_ds_Reg12
  create_bd_addr_seg -range 0x00001000 -offset 0xA0004000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_1/dma_gv/S_AXI_LITE/Reg] SEG_dma_gv_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA0009000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs test_predictions_1/dma_gv/S_AXI_LITE/Reg] SEG_dma_gv_Reg1
  create_bd_addr_seg -range 0x00001000 -offset 0xA0010000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_2/dma_gv/S_AXI_LITE/Reg] SEG_dma_gv_Reg2
  create_bd_addr_seg -range 0x00001000 -offset 0xA0015000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_3/dma_gv/S_AXI_LITE/Reg] SEG_dma_gv_Reg3
  create_bd_addr_seg -range 0x00001000 -offset 0xA001A000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_4/dma_gv/S_AXI_LITE/Reg] SEG_dma_gv_Reg4
  create_bd_addr_seg -range 0x00001000 -offset 0xA001F000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_5/dma_gv/S_AXI_LITE/Reg] SEG_dma_gv_Reg5
  create_bd_addr_seg -range 0x00001000 -offset 0xA0024000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_6/dma_gv/S_AXI_LITE/Reg] SEG_dma_gv_Reg6
  create_bd_addr_seg -range 0x00001000 -offset 0xA0029000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_7/dma_gv/S_AXI_LITE/Reg] SEG_dma_gv_Reg7
  create_bd_addr_seg -range 0x00001000 -offset 0xA002E000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_8/dma_gv/S_AXI_LITE/Reg] SEG_dma_gv_Reg8
  create_bd_addr_seg -range 0x00001000 -offset 0xA0033000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_9/dma_gv/S_AXI_LITE/Reg] SEG_dma_gv_Reg9
  create_bd_addr_seg -range 0x00001000 -offset 0xA0038000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_10/dma_gv/S_AXI_LITE/Reg] SEG_dma_gv_Reg10
  create_bd_addr_seg -range 0x00001000 -offset 0xA003D000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_11/dma_gv/S_AXI_LITE/Reg] SEG_dma_gv_Reg11
  create_bd_addr_seg -range 0x00001000 -offset 0xA0008000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs get_w_1/dma_nw/S_AXI_LITE/Reg] SEG_dma_nw_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA0003000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_1/dma_sv/S_AXI_LITE/Reg] SEG_dma_sv_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA0007000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs get_w_1/dma_sv/S_AXI_LITE/Reg] SEG_dma_sv_Reg1
  create_bd_addr_seg -range 0x00001000 -offset 0xA000F000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_2/dma_sv/S_AXI_LITE/Reg] SEG_dma_sv_Reg2
  create_bd_addr_seg -range 0x00001000 -offset 0xA0014000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_3/dma_sv/S_AXI_LITE/Reg] SEG_dma_sv_Reg3
  create_bd_addr_seg -range 0x00001000 -offset 0xA0019000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_4/dma_sv/S_AXI_LITE/Reg] SEG_dma_sv_Reg4
  create_bd_addr_seg -range 0x00001000 -offset 0xA001E000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_5/dma_sv/S_AXI_LITE/Reg] SEG_dma_sv_Reg5
  create_bd_addr_seg -range 0x00001000 -offset 0xA0023000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_6/dma_sv/S_AXI_LITE/Reg] SEG_dma_sv_Reg6
  create_bd_addr_seg -range 0x00001000 -offset 0xA0028000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_7/dma_sv/S_AXI_LITE/Reg] SEG_dma_sv_Reg7
  create_bd_addr_seg -range 0x00001000 -offset 0xA002D000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_8/dma_sv/S_AXI_LITE/Reg] SEG_dma_sv_Reg8
  create_bd_addr_seg -range 0x00001000 -offset 0xA0032000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_9/dma_sv/S_AXI_LITE/Reg] SEG_dma_sv_Reg9
  create_bd_addr_seg -range 0x00001000 -offset 0xA0037000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_10/dma_sv/S_AXI_LITE/Reg] SEG_dma_sv_Reg10
  create_bd_addr_seg -range 0x00001000 -offset 0xA003C000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_11/dma_sv/S_AXI_LITE/Reg] SEG_dma_sv_Reg11
  create_bd_addr_seg -range 0x00001000 -offset 0xA0000000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_1/dma_tm/S_AXI_LITE/Reg] SEG_dma_tm_Reg
  create_bd_addr_seg -range 0x00001000 -offset 0xA000C000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_2/dma_tm/S_AXI_LITE/Reg] SEG_dma_tm_Reg1
  create_bd_addr_seg -range 0x00001000 -offset 0xA0011000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_3/dma_tm/S_AXI_LITE/Reg] SEG_dma_tm_Reg2
  create_bd_addr_seg -range 0x00001000 -offset 0xA0016000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_4/dma_tm/S_AXI_LITE/Reg] SEG_dma_tm_Reg3
  create_bd_addr_seg -range 0x00001000 -offset 0xA001B000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_5/dma_tm/S_AXI_LITE/Reg] SEG_dma_tm_Reg4
  create_bd_addr_seg -range 0x00001000 -offset 0xA0020000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_6/dma_tm/S_AXI_LITE/Reg] SEG_dma_tm_Reg5
  create_bd_addr_seg -range 0x00001000 -offset 0xA0025000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_7/dma_tm/S_AXI_LITE/Reg] SEG_dma_tm_Reg6
  create_bd_addr_seg -range 0x00001000 -offset 0xA002A000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_8/dma_tm/S_AXI_LITE/Reg] SEG_dma_tm_Reg7
  create_bd_addr_seg -range 0x00001000 -offset 0xA002F000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_9/dma_tm/S_AXI_LITE/Reg] SEG_dma_tm_Reg8
  create_bd_addr_seg -range 0x00001000 -offset 0xA0034000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_10/dma_tm/S_AXI_LITE/Reg] SEG_dma_tm_Reg9
  create_bd_addr_seg -range 0x00001000 -offset 0xA0039000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs geometric_values_11/dma_tm/S_AXI_LITE/Reg] SEG_dma_tm_Reg10
  create_bd_addr_seg -range 0x00001000 -offset 0xA000B000 [get_bd_addr_spaces zynq_ultra_ps_e_0/Data] [get_bd_addr_segs test_predictions_1/dma_tp/S_AXI_LITE/Reg] SEG_dma_tp_Reg
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_1/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_1/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_1/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_1/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_1/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_1/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_1/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_1/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_1/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_1/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_2/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_2/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_2/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_2/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_2/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_2/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_2/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_2/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_2/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_2/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_3/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_3/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_3/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_3/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_3/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_3/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_3/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_3/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_3/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_3/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_4/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP0_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_4/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_QSPI] SEG_zynq_ultra_ps_e_0_HP0_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_4/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_4/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_4/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_4/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_4/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_4/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_4/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_4/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_5/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_5/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_5/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_5/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_5/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_5/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_5/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_5/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_5/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_5/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_6/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_6/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_6/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_6/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_6/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_6/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_6/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_6/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_6/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_6/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_7/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_7/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_7/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_7/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_7/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_7/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_7/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_7/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_7/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_7/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_8/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_8/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_8/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_8/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_8/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_8/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_8/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_8/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_8/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_8/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_9/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP2_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_9/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_QSPI] SEG_zynq_ultra_ps_e_0_HP2_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_9/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_9/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_9/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_9/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_9/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_9/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_9/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_9/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_10/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_10/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_10/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_10/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_10/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_10/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_10/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_10/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_10/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_10/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_11/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_11/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_11/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_11/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_11/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_11/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_11/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_11/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces geometric_values_11/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP3_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces geometric_values_11/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_QSPI] SEG_zynq_ultra_ps_e_0_HP3_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces get_w_1/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces get_w_1/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces get_w_1/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces get_w_1/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces get_w_1/dma_nw/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces get_w_1/dma_nw/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces get_w_1/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces get_w_1/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces test_predictions_1/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces test_predictions_1/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces test_predictions_1/dma_gv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces test_predictions_1/dma_gv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI
  create_bd_addr_seg -range 0x80000000 -offset 0x00000000 [get_bd_addr_spaces test_predictions_1/dma_tp/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_DDR_LOW] SEG_zynq_ultra_ps_e_0_HP1_DDR_LOW
  create_bd_addr_seg -range 0x20000000 -offset 0xC0000000 [get_bd_addr_spaces test_predictions_1/dma_tp/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_QSPI] SEG_zynq_ultra_ps_e_0_HP1_QSPI

  # Exclude Address Segments
  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_1/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_1/dma_cf/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_1/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_1/dma_ds/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_1/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_1/dma_gv/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_1/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_1/dma_sv/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_1/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_1/dma_tm/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_10/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_10/dma_cf/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_10/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_10/dma_ds/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_10/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_10/dma_gv/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_10/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_10/dma_sv/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_10/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_10/dma_tm/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_11/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_11/dma_cf/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_11/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_11/dma_ds/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_11/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_11/dma_gv/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_11/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_11/dma_sv/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_11/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_11/dma_tm/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_2/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_2/dma_cf/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_2/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_2/dma_ds/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_2/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_2/dma_gv/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_2/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_2/dma_sv/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_2/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_2/dma_tm/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_3/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_3/dma_cf/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_3/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_3/dma_ds/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_3/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_3/dma_gv/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_3/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_3/dma_sv/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_3/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_3/dma_tm/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_4/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP2/HP0_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_4/dma_cf/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP0_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_4/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_4/dma_ds/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_4/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_4/dma_gv/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_4/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_4/dma_sv/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_4/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_4/dma_tm/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_5/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_5/dma_cf/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_5/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_5/dma_ds/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_5/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_5/dma_gv/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_5/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_5/dma_sv/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_5/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_5/dma_tm/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_6/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_6/dma_cf/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_6/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_6/dma_ds/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_6/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_6/dma_gv/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_6/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_6/dma_sv/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_6/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_6/dma_tm/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_7/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_7/dma_cf/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_7/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_7/dma_ds/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_7/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_7/dma_gv/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_7/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_7/dma_sv/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_7/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_7/dma_tm/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_8/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_8/dma_cf/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_8/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_8/dma_ds/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_8/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_8/dma_gv/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_8/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_8/dma_sv/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_8/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_8/dma_tm/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_9/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP4/HP2_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_9/dma_cf/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP2_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_9/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_9/dma_ds/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_9/dma_gv/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_9/dma_gv/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_9/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_9/dma_sv/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces geometric_values_9/dma_tm/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP5/HP3_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs geometric_values_9/dma_tm/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP3_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces get_w_1/dma_cf/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs get_w_1/dma_cf/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces get_w_1/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs get_w_1/dma_ds/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces get_w_1/dma_nw/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs get_w_1/dma_nw/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces get_w_1/dma_sv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs get_w_1/dma_sv/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces test_predictions_1/dma_ds/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs test_predictions_1/dma_ds/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces test_predictions_1/dma_gv/Data_MM2S] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs test_predictions_1/dma_gv/Data_MM2S/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]

  create_bd_addr_seg -range 0x01000000 -offset 0xFF000000 [get_bd_addr_spaces test_predictions_1/dma_tp/Data_S2MM] [get_bd_addr_segs zynq_ultra_ps_e_0/SAXIGP3/HP1_LPS_OCM] SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM
  exclude_bd_addr_seg [get_bd_addr_segs test_predictions_1/dma_tp/Data_S2MM/SEG_zynq_ultra_ps_e_0_HP1_LPS_OCM]



  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


