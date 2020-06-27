# PYNQ-SVM-OpenHW-2020
A repository of my Xilinx Open Hardware 2020 submission including a demo of support vector machines on PYNQ, C++ source code and projects for HLS and tcl scripts to re-generate Vivado IPI overlay block designs.

The "DEMO" folder contains all files required to get the design up and running easily - simply copy the contents to a folder on your PYNQ-Z2 board's SD card and make sure you have version 2.5 or higher installed.

The "HLS PROJECTS" folder contains zip files of the Vivado HLS projects which can be opened and the source code inspected for all IP used in the designs.

The "OVERLAYS_JUPYTER_NOTEBOOKS" folder contains all overlays for linear/RBF SVM deployment and SVM training for both PYNQ-Z2 and ZCU104 development boards and associated software drivers

"SOURCE CODE" contains all source code files.

"VIVADO_PROJECTS" contains the tcl scripts and IP repositories you can use to re-assemble the block design in IP Integrator - in Vivado, go to "tool->run tcl script" and select the overlay you wish to see the block design for.
