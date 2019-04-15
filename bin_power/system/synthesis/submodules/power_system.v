/////////////////////////////////////////////////////////////////
// MODULE power_system
/////////////////////////////////////////////////////////////////
module power_system
(
   input logic clock,
   input logic clock2x,
   input logic resetn,
   // AVS avs_fpgasort_cra
   input logic avs_fpgasort_cra_read,
   input logic avs_fpgasort_cra_write,
   input logic [4:0] avs_fpgasort_cra_address,
   input logic [63:0] avs_fpgasort_cra_writedata,
   input logic [7:0] avs_fpgasort_cra_byteenable,
   output logic avs_fpgasort_cra_waitrequest,
   output logic [63:0] avs_fpgasort_cra_readdata,
   output logic avs_fpgasort_cra_readdatavalid,
   output logic kernel_irq,
   // AVM avm_memgmem0_port_0_0_rw
   output logic avm_memgmem0_port_0_0_rw_read,
   output logic avm_memgmem0_port_0_0_rw_write,
   output logic [4:0] avm_memgmem0_port_0_0_rw_burstcount,
   output logic [29:0] avm_memgmem0_port_0_0_rw_address,
   output logic [255:0] avm_memgmem0_port_0_0_rw_writedata,
   output logic [31:0] avm_memgmem0_port_0_0_rw_byteenable,
   input logic avm_memgmem0_port_0_0_rw_waitrequest,
   input logic [255:0] avm_memgmem0_port_0_0_rw_readdata,
   input logic avm_memgmem0_port_0_0_rw_readdatavalid,
   input logic avm_memgmem0_port_0_0_rw_writeack
);
   logic kernel_irqs;
   logic avm_kernel_rd_read [3];
   logic avm_kernel_rd_write [3];
   logic [4:0] avm_kernel_rd_burstcount [3];
   logic [29:0] avm_kernel_rd_address [3];
   logic [255:0] avm_kernel_rd_writedata [3];
   logic [31:0] avm_kernel_rd_byteenable [3];
   logic avm_kernel_rd_waitrequest [3];
   logic [255:0] avm_kernel_rd_readdata [3];
   logic avm_kernel_rd_readdatavalid [3];
   logic avm_kernel_rd_writeack [3];
   logic avm_kernel_wr_read [2];
   logic avm_kernel_wr_write [2];
   logic [4:0] avm_kernel_wr_burstcount [2];
   logic [29:0] avm_kernel_wr_address [2];
   logic [255:0] avm_kernel_wr_writedata [2];
   logic [31:0] avm_kernel_wr_byteenable [2];
   logic avm_kernel_wr_waitrequest [2];
   logic [255:0] avm_kernel_wr_readdata [2];
   logic avm_kernel_wr_readdatavalid [2];
   logic avm_kernel_wr_writeack [2];
   logic ic_avm_read [1];
   logic ic_avm_write [1];
   logic [4:0] ic_avm_burstcount [1];
   logic [29:0] ic_avm_address [1];
   logic [255:0] ic_avm_writedata [1];
   logic [31:0] ic_avm_byteenable [1];
   logic ic_avm_waitrequest [1];
   logic [255:0] ic_avm_readdata [1];
   logic ic_avm_readdatavalid [1];
   logic ic_avm_writeack [1];

   // INST fpgasort of fpgasort_top_wrapper
   fpgasort_top_wrapper fpgasort
   (
      .clock(clock),
      .clock2x(clock2x),
      .resetn(resetn),
      .cra_irq(kernel_irqs),
      // AVS avs_cra
      .avs_cra_read(avs_fpgasort_cra_read),
      .avs_cra_write(avs_fpgasort_cra_write),
      .avs_cra_address(avs_fpgasort_cra_address),
      .avs_cra_writedata(avs_fpgasort_cra_writedata),
      .avs_cra_byteenable(avs_fpgasort_cra_byteenable),
      .avs_cra_waitrequest(avs_fpgasort_cra_waitrequest),
      .avs_cra_readdata(avs_fpgasort_cra_readdata),
      .avs_cra_readdatavalid(avs_fpgasort_cra_readdatavalid),
      // AVM avm_local_bb2_ld__inst0
      .avm_local_bb2_ld__inst0_read(avm_kernel_rd_read[0]),
      .avm_local_bb2_ld__inst0_write(avm_kernel_rd_write[0]),
      .avm_local_bb2_ld__inst0_burstcount(avm_kernel_rd_burstcount[0]),
      .avm_local_bb2_ld__inst0_address(avm_kernel_rd_address[0]),
      .avm_local_bb2_ld__inst0_writedata(avm_kernel_rd_writedata[0]),
      .avm_local_bb2_ld__inst0_byteenable(avm_kernel_rd_byteenable[0]),
      .avm_local_bb2_ld__inst0_waitrequest(avm_kernel_rd_waitrequest[0]),
      .avm_local_bb2_ld__inst0_readdata(avm_kernel_rd_readdata[0]),
      .avm_local_bb2_ld__inst0_readdatavalid(avm_kernel_rd_readdatavalid[0]),
      .avm_local_bb2_ld__inst0_writeack(avm_kernel_rd_writeack[0]),
      // AVM avm_local_bb2_ld__u1_inst0
      .avm_local_bb2_ld__u1_inst0_read(avm_kernel_rd_read[1]),
      .avm_local_bb2_ld__u1_inst0_write(avm_kernel_rd_write[1]),
      .avm_local_bb2_ld__u1_inst0_burstcount(avm_kernel_rd_burstcount[1]),
      .avm_local_bb2_ld__u1_inst0_address(avm_kernel_rd_address[1]),
      .avm_local_bb2_ld__u1_inst0_writedata(avm_kernel_rd_writedata[1]),
      .avm_local_bb2_ld__u1_inst0_byteenable(avm_kernel_rd_byteenable[1]),
      .avm_local_bb2_ld__u1_inst0_waitrequest(avm_kernel_rd_waitrequest[1]),
      .avm_local_bb2_ld__u1_inst0_readdata(avm_kernel_rd_readdata[1]),
      .avm_local_bb2_ld__u1_inst0_readdatavalid(avm_kernel_rd_readdatavalid[1]),
      .avm_local_bb2_ld__u1_inst0_writeack(avm_kernel_rd_writeack[1]),
      // AVM avm_local_bb3_ld__inst0
      .avm_local_bb3_ld__inst0_read(avm_kernel_rd_read[2]),
      .avm_local_bb3_ld__inst0_write(avm_kernel_rd_write[2]),
      .avm_local_bb3_ld__inst0_burstcount(avm_kernel_rd_burstcount[2]),
      .avm_local_bb3_ld__inst0_address(avm_kernel_rd_address[2]),
      .avm_local_bb3_ld__inst0_writedata(avm_kernel_rd_writedata[2]),
      .avm_local_bb3_ld__inst0_byteenable(avm_kernel_rd_byteenable[2]),
      .avm_local_bb3_ld__inst0_waitrequest(avm_kernel_rd_waitrequest[2]),
      .avm_local_bb3_ld__inst0_readdata(avm_kernel_rd_readdata[2]),
      .avm_local_bb3_ld__inst0_readdatavalid(avm_kernel_rd_readdatavalid[2]),
      .avm_local_bb3_ld__inst0_writeack(avm_kernel_rd_writeack[2]),
      // AVM avm_local_bb3_st_c0_exe16_inst0
      .avm_local_bb3_st_c0_exe16_inst0_read(avm_kernel_wr_read[0]),
      .avm_local_bb3_st_c0_exe16_inst0_write(avm_kernel_wr_write[0]),
      .avm_local_bb3_st_c0_exe16_inst0_burstcount(avm_kernel_wr_burstcount[0]),
      .avm_local_bb3_st_c0_exe16_inst0_address(avm_kernel_wr_address[0]),
      .avm_local_bb3_st_c0_exe16_inst0_writedata(avm_kernel_wr_writedata[0]),
      .avm_local_bb3_st_c0_exe16_inst0_byteenable(avm_kernel_wr_byteenable[0]),
      .avm_local_bb3_st_c0_exe16_inst0_waitrequest(avm_kernel_wr_waitrequest[0]),
      .avm_local_bb3_st_c0_exe16_inst0_readdata(avm_kernel_wr_readdata[0]),
      .avm_local_bb3_st_c0_exe16_inst0_readdatavalid(avm_kernel_wr_readdatavalid[0]),
      .avm_local_bb3_st_c0_exe16_inst0_writeack(avm_kernel_wr_writeack[0]),
      // AVM avm_local_bb3_st_c1_exe1_inst0
      .avm_local_bb3_st_c1_exe1_inst0_read(avm_kernel_wr_read[1]),
      .avm_local_bb3_st_c1_exe1_inst0_write(avm_kernel_wr_write[1]),
      .avm_local_bb3_st_c1_exe1_inst0_burstcount(avm_kernel_wr_burstcount[1]),
      .avm_local_bb3_st_c1_exe1_inst0_address(avm_kernel_wr_address[1]),
      .avm_local_bb3_st_c1_exe1_inst0_writedata(avm_kernel_wr_writedata[1]),
      .avm_local_bb3_st_c1_exe1_inst0_byteenable(avm_kernel_wr_byteenable[1]),
      .avm_local_bb3_st_c1_exe1_inst0_waitrequest(avm_kernel_wr_waitrequest[1]),
      .avm_local_bb3_st_c1_exe1_inst0_readdata(avm_kernel_wr_readdata[1]),
      .avm_local_bb3_st_c1_exe1_inst0_readdatavalid(avm_kernel_wr_readdatavalid[1]),
      .avm_local_bb3_st_c1_exe1_inst0_writeack(avm_kernel_wr_writeack[1])
   );

   assign kernel_irq = |kernel_irqs;
   // INST lsu_ic_top of lsu_ic_top
   lsu_ic_top
   #(
      .AWIDTH(30),
      .SHIFT(30),
      .MWIDTH_BYTES(32),
      .BURST_CNT_W(5),
      .NUM_RD_PORT(3),
      .NUM_WR_PORT(2),
      .NUM_DIMM(1),
      .ENABLE_DUAL_RING(0),
      .ENABLE_MULTIPLE_WR_RING(0),
      .ENABLE_LAST_WAIT(0),
      .ENABLE_REORDER(0),
      .NUM_REORDER(1)
   )
   lsu_ic_top
   (
      .clk(clock),
      .resetn(resetn),
      .i_rd_request(avm_kernel_rd_read),
      .i_rd_address(avm_kernel_rd_address),
      .i_rd_burstcount(avm_kernel_rd_burstcount),
      .i_wr_byteenable(avm_kernel_wr_byteenable),
      .i_wr_address(avm_kernel_wr_address),
      .i_wr_request(avm_kernel_wr_write),
      .i_wr_burstcount(avm_kernel_wr_burstcount),
      .i_wr_writedata(avm_kernel_wr_writedata),
      .i_avm_waitrequest(ic_avm_waitrequest),
      .i_avm_readdata(ic_avm_readdata),
      .i_avm_readdatavalid(ic_avm_readdatavalid),
      .o_avm_byteenable(ic_avm_byteenable),
      .o_avm_address(ic_avm_address),
      .o_avm_read(ic_avm_read),
      .o_avm_write(ic_avm_write),
      .o_avm_burstcount(ic_avm_burstcount),
      .o_wr_waitrequest(avm_kernel_wr_waitrequest),
      .o_avm_writedata(ic_avm_writedata),
      .o_avm_writeack(avm_kernel_wr_writeack),
      .o_rd_waitrequest(avm_kernel_rd_waitrequest),
      .o_avm_readdata(avm_kernel_rd_readdata),
      .o_avm_readdatavalid(avm_kernel_rd_readdatavalid)
   );

   assign avm_memgmem0_port_0_0_rw_read = ic_avm_read[0];
   assign avm_memgmem0_port_0_0_rw_write = ic_avm_write[0];
   assign avm_memgmem0_port_0_0_rw_burstcount = ic_avm_burstcount[0];
   assign avm_memgmem0_port_0_0_rw_address = ic_avm_address[0];
   assign avm_memgmem0_port_0_0_rw_writedata = ic_avm_writedata[0];
   assign avm_memgmem0_port_0_0_rw_byteenable = ic_avm_byteenable[0];
   assign ic_avm_waitrequest[0] = avm_memgmem0_port_0_0_rw_waitrequest;
   assign ic_avm_readdata[0] = avm_memgmem0_port_0_0_rw_readdata;
   assign ic_avm_readdatavalid[0] = avm_memgmem0_port_0_0_rw_readdatavalid;
endmodule

/////////////////////////////////////////////////////////////////
// MODULE fpgasort_top_wrapper
/////////////////////////////////////////////////////////////////
module fpgasort_top_wrapper
(
   input logic clock,
   input logic clock2x,
   input logic resetn,
   output logic cra_irq,
   // AVS avs_cra
   input logic avs_cra_read,
   input logic avs_cra_write,
   input logic [4:0] avs_cra_address,
   input logic [63:0] avs_cra_writedata,
   input logic [7:0] avs_cra_byteenable,
   output logic avs_cra_waitrequest,
   output logic [63:0] avs_cra_readdata,
   output logic avs_cra_readdatavalid,
   // AVM avm_local_bb2_ld__inst0
   output logic avm_local_bb2_ld__inst0_read,
   output logic avm_local_bb2_ld__inst0_write,
   output logic [4:0] avm_local_bb2_ld__inst0_burstcount,
   output logic [29:0] avm_local_bb2_ld__inst0_address,
   output logic [255:0] avm_local_bb2_ld__inst0_writedata,
   output logic [31:0] avm_local_bb2_ld__inst0_byteenable,
   input logic avm_local_bb2_ld__inst0_waitrequest,
   input logic [255:0] avm_local_bb2_ld__inst0_readdata,
   input logic avm_local_bb2_ld__inst0_readdatavalid,
   input logic avm_local_bb2_ld__inst0_writeack,
   // AVM avm_local_bb2_ld__u1_inst0
   output logic avm_local_bb2_ld__u1_inst0_read,
   output logic avm_local_bb2_ld__u1_inst0_write,
   output logic [4:0] avm_local_bb2_ld__u1_inst0_burstcount,
   output logic [29:0] avm_local_bb2_ld__u1_inst0_address,
   output logic [255:0] avm_local_bb2_ld__u1_inst0_writedata,
   output logic [31:0] avm_local_bb2_ld__u1_inst0_byteenable,
   input logic avm_local_bb2_ld__u1_inst0_waitrequest,
   input logic [255:0] avm_local_bb2_ld__u1_inst0_readdata,
   input logic avm_local_bb2_ld__u1_inst0_readdatavalid,
   input logic avm_local_bb2_ld__u1_inst0_writeack,
   // AVM avm_local_bb3_ld__inst0
   output logic avm_local_bb3_ld__inst0_read,
   output logic avm_local_bb3_ld__inst0_write,
   output logic [4:0] avm_local_bb3_ld__inst0_burstcount,
   output logic [29:0] avm_local_bb3_ld__inst0_address,
   output logic [255:0] avm_local_bb3_ld__inst0_writedata,
   output logic [31:0] avm_local_bb3_ld__inst0_byteenable,
   input logic avm_local_bb3_ld__inst0_waitrequest,
   input logic [255:0] avm_local_bb3_ld__inst0_readdata,
   input logic avm_local_bb3_ld__inst0_readdatavalid,
   input logic avm_local_bb3_ld__inst0_writeack,
   // AVM avm_local_bb3_st_c0_exe16_inst0
   output logic avm_local_bb3_st_c0_exe16_inst0_read,
   output logic avm_local_bb3_st_c0_exe16_inst0_write,
   output logic [4:0] avm_local_bb3_st_c0_exe16_inst0_burstcount,
   output logic [29:0] avm_local_bb3_st_c0_exe16_inst0_address,
   output logic [255:0] avm_local_bb3_st_c0_exe16_inst0_writedata,
   output logic [31:0] avm_local_bb3_st_c0_exe16_inst0_byteenable,
   input logic avm_local_bb3_st_c0_exe16_inst0_waitrequest,
   input logic [255:0] avm_local_bb3_st_c0_exe16_inst0_readdata,
   input logic avm_local_bb3_st_c0_exe16_inst0_readdatavalid,
   input logic avm_local_bb3_st_c0_exe16_inst0_writeack,
   // AVM avm_local_bb3_st_c1_exe1_inst0
   output logic avm_local_bb3_st_c1_exe1_inst0_read,
   output logic avm_local_bb3_st_c1_exe1_inst0_write,
   output logic [4:0] avm_local_bb3_st_c1_exe1_inst0_burstcount,
   output logic [29:0] avm_local_bb3_st_c1_exe1_inst0_address,
   output logic [255:0] avm_local_bb3_st_c1_exe1_inst0_writedata,
   output logic [31:0] avm_local_bb3_st_c1_exe1_inst0_byteenable,
   input logic avm_local_bb3_st_c1_exe1_inst0_waitrequest,
   input logic [255:0] avm_local_bb3_st_c1_exe1_inst0_readdata,
   input logic avm_local_bb3_st_c1_exe1_inst0_readdatavalid,
   input logic avm_local_bb3_st_c1_exe1_inst0_writeack
);
   logic lmem_invalid_single_bit;

   // INST kernel of fpgasort_function_wrapper
   fpgasort_function_wrapper kernel
   (
      .local_router_hang(lmem_invalid_single_bit),
      .clock(clock),
      .clock2x(clock2x),
      .resetn(resetn),
      .cra_irq(cra_irq),
      // AVS avs_cra
      .avs_cra_read(avs_cra_read),
      .avs_cra_write(avs_cra_write),
      .avs_cra_address(avs_cra_address),
      .avs_cra_writedata(avs_cra_writedata),
      .avs_cra_byteenable(avs_cra_byteenable),
      .avs_cra_waitrequest(avs_cra_waitrequest),
      .avs_cra_readdata(avs_cra_readdata),
      .avs_cra_readdatavalid(avs_cra_readdatavalid),
      // AVM avm_local_bb2_ld__inst0
      .avm_local_bb2_ld__inst0_read(avm_local_bb2_ld__inst0_read),
      .avm_local_bb2_ld__inst0_write(avm_local_bb2_ld__inst0_write),
      .avm_local_bb2_ld__inst0_burstcount(avm_local_bb2_ld__inst0_burstcount),
      .avm_local_bb2_ld__inst0_address(avm_local_bb2_ld__inst0_address),
      .avm_local_bb2_ld__inst0_writedata(avm_local_bb2_ld__inst0_writedata),
      .avm_local_bb2_ld__inst0_byteenable(avm_local_bb2_ld__inst0_byteenable),
      .avm_local_bb2_ld__inst0_waitrequest(avm_local_bb2_ld__inst0_waitrequest),
      .avm_local_bb2_ld__inst0_readdata(avm_local_bb2_ld__inst0_readdata),
      .avm_local_bb2_ld__inst0_readdatavalid(avm_local_bb2_ld__inst0_readdatavalid),
      .avm_local_bb2_ld__inst0_writeack(avm_local_bb2_ld__inst0_writeack),
      // AVM avm_local_bb2_ld__u1_inst0
      .avm_local_bb2_ld__u1_inst0_read(avm_local_bb2_ld__u1_inst0_read),
      .avm_local_bb2_ld__u1_inst0_write(avm_local_bb2_ld__u1_inst0_write),
      .avm_local_bb2_ld__u1_inst0_burstcount(avm_local_bb2_ld__u1_inst0_burstcount),
      .avm_local_bb2_ld__u1_inst0_address(avm_local_bb2_ld__u1_inst0_address),
      .avm_local_bb2_ld__u1_inst0_writedata(avm_local_bb2_ld__u1_inst0_writedata),
      .avm_local_bb2_ld__u1_inst0_byteenable(avm_local_bb2_ld__u1_inst0_byteenable),
      .avm_local_bb2_ld__u1_inst0_waitrequest(avm_local_bb2_ld__u1_inst0_waitrequest),
      .avm_local_bb2_ld__u1_inst0_readdata(avm_local_bb2_ld__u1_inst0_readdata),
      .avm_local_bb2_ld__u1_inst0_readdatavalid(avm_local_bb2_ld__u1_inst0_readdatavalid),
      .avm_local_bb2_ld__u1_inst0_writeack(avm_local_bb2_ld__u1_inst0_writeack),
      // AVM avm_local_bb3_ld__inst0
      .avm_local_bb3_ld__inst0_read(avm_local_bb3_ld__inst0_read),
      .avm_local_bb3_ld__inst0_write(avm_local_bb3_ld__inst0_write),
      .avm_local_bb3_ld__inst0_burstcount(avm_local_bb3_ld__inst0_burstcount),
      .avm_local_bb3_ld__inst0_address(avm_local_bb3_ld__inst0_address),
      .avm_local_bb3_ld__inst0_writedata(avm_local_bb3_ld__inst0_writedata),
      .avm_local_bb3_ld__inst0_byteenable(avm_local_bb3_ld__inst0_byteenable),
      .avm_local_bb3_ld__inst0_waitrequest(avm_local_bb3_ld__inst0_waitrequest),
      .avm_local_bb3_ld__inst0_readdata(avm_local_bb3_ld__inst0_readdata),
      .avm_local_bb3_ld__inst0_readdatavalid(avm_local_bb3_ld__inst0_readdatavalid),
      .avm_local_bb3_ld__inst0_writeack(avm_local_bb3_ld__inst0_writeack),
      // AVM avm_local_bb3_st_c0_exe16_inst0
      .avm_local_bb3_st_c0_exe16_inst0_read(avm_local_bb3_st_c0_exe16_inst0_read),
      .avm_local_bb3_st_c0_exe16_inst0_write(avm_local_bb3_st_c0_exe16_inst0_write),
      .avm_local_bb3_st_c0_exe16_inst0_burstcount(avm_local_bb3_st_c0_exe16_inst0_burstcount),
      .avm_local_bb3_st_c0_exe16_inst0_address(avm_local_bb3_st_c0_exe16_inst0_address),
      .avm_local_bb3_st_c0_exe16_inst0_writedata(avm_local_bb3_st_c0_exe16_inst0_writedata),
      .avm_local_bb3_st_c0_exe16_inst0_byteenable(avm_local_bb3_st_c0_exe16_inst0_byteenable),
      .avm_local_bb3_st_c0_exe16_inst0_waitrequest(avm_local_bb3_st_c0_exe16_inst0_waitrequest),
      .avm_local_bb3_st_c0_exe16_inst0_readdata(avm_local_bb3_st_c0_exe16_inst0_readdata),
      .avm_local_bb3_st_c0_exe16_inst0_readdatavalid(avm_local_bb3_st_c0_exe16_inst0_readdatavalid),
      .avm_local_bb3_st_c0_exe16_inst0_writeack(avm_local_bb3_st_c0_exe16_inst0_writeack),
      // AVM avm_local_bb3_st_c1_exe1_inst0
      .avm_local_bb3_st_c1_exe1_inst0_read(avm_local_bb3_st_c1_exe1_inst0_read),
      .avm_local_bb3_st_c1_exe1_inst0_write(avm_local_bb3_st_c1_exe1_inst0_write),
      .avm_local_bb3_st_c1_exe1_inst0_burstcount(avm_local_bb3_st_c1_exe1_inst0_burstcount),
      .avm_local_bb3_st_c1_exe1_inst0_address(avm_local_bb3_st_c1_exe1_inst0_address),
      .avm_local_bb3_st_c1_exe1_inst0_writedata(avm_local_bb3_st_c1_exe1_inst0_writedata),
      .avm_local_bb3_st_c1_exe1_inst0_byteenable(avm_local_bb3_st_c1_exe1_inst0_byteenable),
      .avm_local_bb3_st_c1_exe1_inst0_waitrequest(avm_local_bb3_st_c1_exe1_inst0_waitrequest),
      .avm_local_bb3_st_c1_exe1_inst0_readdata(avm_local_bb3_st_c1_exe1_inst0_readdata),
      .avm_local_bb3_st_c1_exe1_inst0_readdatavalid(avm_local_bb3_st_c1_exe1_inst0_readdatavalid),
      .avm_local_bb3_st_c1_exe1_inst0_writeack(avm_local_bb3_st_c1_exe1_inst0_writeack)
   );

   assign lmem_invalid_single_bit = 'b0;
endmodule

