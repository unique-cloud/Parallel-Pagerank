// (C) 1992-2014 Altera Corporation. All rights reserved.                         
// Your use of Altera Corporation's design tools, logic functions and other       
// software and tools, and its AMPP partner logic functions, and any output       
// files any of the foregoing (including device programming or simulation         
// files), and any associated documentation or information are expressly subject  
// to the terms and conditions of the Altera Program License Subscription         
// Agreement, Altera MegaCore Function License Agreement, or other applicable     
// license agreement, including, without limitation, that your use is for the     
// sole purpose of programming logic devices manufactured by Altera and sold by   
// Altera or its authorized distributors.  Please refer to the applicable         
// agreement for further details.                                                 
    

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module scatter_basic_block_0
	(
		input 		clock,
		input 		resetn,
		input 		start,
		input 		valid_in,
		output 		stall_out,
		input [31:0] 		input_global_id_0,
		output 		valid_out,
		input 		stall_in,
		output [31:0] 		lvb_input_global_id_0,
		input [31:0] 		workgroup_size
	);


// Values used for debugging.  These are swept away by synthesis.
wire _entry;
wire _exit;
 reg [31:0] _num_entry_NO_SHIFT_REG;
 reg [31:0] _num_exit_NO_SHIFT_REG;
wire [31:0] _num_live;

assign _entry = ((&valid_in) & ~((|stall_out)));
assign _exit = ((&valid_out) & ~((|stall_in)));
assign _num_live = (_num_entry_NO_SHIFT_REG - _num_exit_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		_num_entry_NO_SHIFT_REG <= 32'h0;
		_num_exit_NO_SHIFT_REG <= 32'h0;
	end
	else
	begin
		if (_entry)
		begin
			_num_entry_NO_SHIFT_REG <= (_num_entry_NO_SHIFT_REG + 2'h1);
		end
		if (_exit)
		begin
			_num_exit_NO_SHIFT_REG <= (_num_exit_NO_SHIFT_REG + 2'h1);
		end
	end
end



// This section defines the behaviour of the MERGE node
wire merge_node_stall_in;
 reg merge_node_valid_out_NO_SHIFT_REG;
wire merge_stalled_by_successors;
 reg merge_block_selector_NO_SHIFT_REG;
 reg merge_node_valid_in_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_global_id_0_staging_reg_NO_SHIFT_REG;
 reg [31:0] local_lvm_input_global_id_0_NO_SHIFT_REG;
 reg is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
 reg invariant_valid_NO_SHIFT_REG;

assign merge_stalled_by_successors = (|(merge_node_stall_in & merge_node_valid_out_NO_SHIFT_REG));
assign stall_out = merge_node_valid_in_staging_reg_NO_SHIFT_REG;

always @(*)
begin
	if ((merge_node_valid_in_staging_reg_NO_SHIFT_REG | valid_in))
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b1;
	end
	else
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b0;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		input_global_id_0_staging_reg_NO_SHIFT_REG <= 'x;
		merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (((merge_block_selector_NO_SHIFT_REG != 1'b0) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_staging_reg_NO_SHIFT_REG))
			begin
				input_global_id_0_staging_reg_NO_SHIFT_REG <= input_global_id_0;
				merge_node_valid_in_staging_reg_NO_SHIFT_REG <= valid_in;
			end
		end
		else
		begin
			merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
		end
	end
end

always @(posedge clock)
begin
	if (~(merge_stalled_by_successors))
	begin
		case (merge_block_selector_NO_SHIFT_REG)
			1'b0:
			begin
				if (merge_node_valid_in_staging_reg_NO_SHIFT_REG)
				begin
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0_staging_reg_NO_SHIFT_REG;
				end
				else
				begin
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0;
				end
			end

			default:
			begin
			end

		endcase
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		merge_node_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (~(merge_stalled_by_successors))
		begin
			merge_node_valid_out_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
		end
		else
		begin
			if (~(merge_node_stall_in))
			begin
				merge_node_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		invariant_valid_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		invariant_valid_NO_SHIFT_REG <= (~(start) & (invariant_valid_NO_SHIFT_REG | is_merge_data_to_local_regs_valid_NO_SHIFT_REG));
	end
end


// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
 reg branch_node_valid_out_NO_SHIFT_REG;
wire branch_var__output_regs_ready;
wire combined_branch_stall_in_signal;
 reg [31:0] lvb_input_global_id_0_reg_NO_SHIFT_REG;

assign branch_var__inputs_ready = merge_node_valid_out_NO_SHIFT_REG;
assign branch_var__output_regs_ready = (~(stall_in) | ~(branch_node_valid_out_NO_SHIFT_REG));
assign merge_node_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign lvb_input_global_id_0 = lvb_input_global_id_0_reg_NO_SHIFT_REG;
assign valid_out = branch_node_valid_out_NO_SHIFT_REG;
assign combined_branch_stall_in_signal = stall_in;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		branch_node_valid_out_NO_SHIFT_REG <= 1'b0;
		lvb_input_global_id_0_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (branch_var__output_regs_ready)
		begin
			branch_node_valid_out_NO_SHIFT_REG <= branch_var__inputs_ready;
			lvb_input_global_id_0_reg_NO_SHIFT_REG <= local_lvm_input_global_id_0_NO_SHIFT_REG;
		end
		else
		begin
			if (~(combined_branch_stall_in_signal))
			begin
				branch_node_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module scatter_basic_block_1
	(
		input 		clock,
		input 		resetn,
		input [63:0] 		input_edge_arr,
		input [63:0] 		input_msg_arr,
		input [31:0] 		input_global_size_0,
		input [63:0] 		input_outCount_arr,
		input [63:0] 		input_rank,
		input 		valid_in,
		output 		stall_out,
		input [31:0] 		input_global_id_0,
		output 		valid_out,
		input 		stall_in,
		input [31:0] 		workgroup_size,
		input 		start,
		input [255:0] 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_readdata,
		input 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_readdatavalid,
		input 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_waitrequest,
		output [29:0] 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_address,
		output 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_read,
		output 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_write,
		input 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_writeack,
		output [255:0] 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_writedata,
		output [31:0] 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_byteenable,
		output [4:0] 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_burstcount,
		output 		local_bb1_ld_memcoalesce_edge_arr_load_0_active,
		input 		clock2x,
		input [255:0] 		avm_local_bb1_ld__readdata,
		input 		avm_local_bb1_ld__readdatavalid,
		input 		avm_local_bb1_ld__waitrequest,
		output [29:0] 		avm_local_bb1_ld__address,
		output 		avm_local_bb1_ld__read,
		output 		avm_local_bb1_ld__write,
		input 		avm_local_bb1_ld__writeack,
		output [255:0] 		avm_local_bb1_ld__writedata,
		output [31:0] 		avm_local_bb1_ld__byteenable,
		output [4:0] 		avm_local_bb1_ld__burstcount,
		output 		local_bb1_ld__active,
		input [255:0] 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_readdata,
		input 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_readdatavalid,
		input 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_waitrequest,
		output [29:0] 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_address,
		output 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_read,
		output 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_write,
		input 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_writeack,
		output [255:0] 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_writedata,
		output [31:0] 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_byteenable,
		output [4:0] 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_burstcount,
		output 		local_bb1_st_memcoalesce_edge_arr_extrValue_1_active,
		input [255:0] 		avm_local_bb1_ld__u0_readdata,
		input 		avm_local_bb1_ld__u0_readdatavalid,
		input 		avm_local_bb1_ld__u0_waitrequest,
		output [29:0] 		avm_local_bb1_ld__u0_address,
		output 		avm_local_bb1_ld__u0_read,
		output 		avm_local_bb1_ld__u0_write,
		input 		avm_local_bb1_ld__u0_writeack,
		output [255:0] 		avm_local_bb1_ld__u0_writedata,
		output [31:0] 		avm_local_bb1_ld__u0_byteenable,
		output [4:0] 		avm_local_bb1_ld__u0_burstcount,
		output 		local_bb1_ld__u0_active,
		input [255:0] 		avm_local_bb1_st_c0_exe1_readdata,
		input 		avm_local_bb1_st_c0_exe1_readdatavalid,
		input 		avm_local_bb1_st_c0_exe1_waitrequest,
		output [29:0] 		avm_local_bb1_st_c0_exe1_address,
		output 		avm_local_bb1_st_c0_exe1_read,
		output 		avm_local_bb1_st_c0_exe1_write,
		input 		avm_local_bb1_st_c0_exe1_writeack,
		output [255:0] 		avm_local_bb1_st_c0_exe1_writedata,
		output [31:0] 		avm_local_bb1_st_c0_exe1_byteenable,
		output [4:0] 		avm_local_bb1_st_c0_exe1_burstcount,
		output 		local_bb1_st_c0_exe1_active
	);


// Values used for debugging.  These are swept away by synthesis.
wire _entry;
wire _exit;
 reg [31:0] _num_entry_NO_SHIFT_REG;
 reg [31:0] _num_exit_NO_SHIFT_REG;
wire [31:0] _num_live;

assign _entry = ((&valid_in) & ~((|stall_out)));
assign _exit = ((&valid_out) & ~((|stall_in)));
assign _num_live = (_num_entry_NO_SHIFT_REG - _num_exit_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		_num_entry_NO_SHIFT_REG <= 32'h0;
		_num_exit_NO_SHIFT_REG <= 32'h0;
	end
	else
	begin
		if (_entry)
		begin
			_num_entry_NO_SHIFT_REG <= (_num_entry_NO_SHIFT_REG + 2'h1);
		end
		if (_exit)
		begin
			_num_exit_NO_SHIFT_REG <= (_num_exit_NO_SHIFT_REG + 2'h1);
		end
	end
end



// This section defines the behaviour of the MERGE node
wire merge_node_stall_in;
 reg merge_node_valid_out_NO_SHIFT_REG;
wire merge_stalled_by_successors;
 reg merge_block_selector_NO_SHIFT_REG;
 reg merge_node_valid_in_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_global_id_0_staging_reg_NO_SHIFT_REG;
 reg [31:0] local_lvm_input_global_id_0_NO_SHIFT_REG;
 reg is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
 reg invariant_valid_NO_SHIFT_REG;

assign merge_stalled_by_successors = (|(merge_node_stall_in & merge_node_valid_out_NO_SHIFT_REG));
assign stall_out = merge_node_valid_in_staging_reg_NO_SHIFT_REG;

always @(*)
begin
	if ((merge_node_valid_in_staging_reg_NO_SHIFT_REG | valid_in))
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b1;
	end
	else
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b0;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		input_global_id_0_staging_reg_NO_SHIFT_REG <= 'x;
		merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (((merge_block_selector_NO_SHIFT_REG != 1'b0) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_staging_reg_NO_SHIFT_REG))
			begin
				input_global_id_0_staging_reg_NO_SHIFT_REG <= input_global_id_0;
				merge_node_valid_in_staging_reg_NO_SHIFT_REG <= valid_in;
			end
		end
		else
		begin
			merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
		end
	end
end

always @(posedge clock)
begin
	if (~(merge_stalled_by_successors))
	begin
		case (merge_block_selector_NO_SHIFT_REG)
			1'b0:
			begin
				if (merge_node_valid_in_staging_reg_NO_SHIFT_REG)
				begin
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0_staging_reg_NO_SHIFT_REG;
				end
				else
				begin
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0;
				end
			end

			default:
			begin
			end

		endcase
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		merge_node_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (~(merge_stalled_by_successors))
		begin
			merge_node_valid_out_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
		end
		else
		begin
			if (~(merge_node_stall_in))
			begin
				merge_node_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		invariant_valid_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		invariant_valid_NO_SHIFT_REG <= (~(start) & (invariant_valid_NO_SHIFT_REG | is_merge_data_to_local_regs_valid_NO_SHIFT_REG));
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_idxprom_stall_local;
wire [63:0] local_bb1_idxprom;

assign local_bb1_idxprom[63:32] = 32'h0;
assign local_bb1_idxprom[31:0] = local_lvm_input_global_id_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_arrayidx_0_stall_local;
wire [63:0] local_bb1_arrayidx_0;

assign local_bb1_arrayidx_0 = (input_edge_arr + (local_bb1_idxprom << 6'h3));

// This section implements an unregistered operation.
// 
wire local_bb1_idxprom_valid_out_1;
wire local_bb1_idxprom_stall_in_1;
 reg local_bb1_idxprom_consumed_1_NO_SHIFT_REG;
wire local_bb1_memcoalesce_edge_arr_bitcast_0_valid_out;
wire local_bb1_memcoalesce_edge_arr_bitcast_0_stall_in;
 reg local_bb1_memcoalesce_edge_arr_bitcast_0_consumed_0_NO_SHIFT_REG;
wire local_bb1_memcoalesce_edge_arr_bitcast_0_inputs_ready;
wire local_bb1_memcoalesce_edge_arr_bitcast_0_stall_local;
wire [63:0] local_bb1_memcoalesce_edge_arr_bitcast_0;

assign local_bb1_memcoalesce_edge_arr_bitcast_0_inputs_ready = merge_node_valid_out_NO_SHIFT_REG;
assign local_bb1_memcoalesce_edge_arr_bitcast_0 = local_bb1_arrayidx_0;
assign local_bb1_memcoalesce_edge_arr_bitcast_0_stall_local = ((local_bb1_idxprom_stall_in_1 & ~(local_bb1_idxprom_consumed_1_NO_SHIFT_REG)) | (local_bb1_memcoalesce_edge_arr_bitcast_0_stall_in & ~(local_bb1_memcoalesce_edge_arr_bitcast_0_consumed_0_NO_SHIFT_REG)));
assign local_bb1_idxprom_valid_out_1 = (local_bb1_memcoalesce_edge_arr_bitcast_0_inputs_ready & ~(local_bb1_idxprom_consumed_1_NO_SHIFT_REG));
assign local_bb1_memcoalesce_edge_arr_bitcast_0_valid_out = (local_bb1_memcoalesce_edge_arr_bitcast_0_inputs_ready & ~(local_bb1_memcoalesce_edge_arr_bitcast_0_consumed_0_NO_SHIFT_REG));
assign merge_node_stall_in = (|local_bb1_memcoalesce_edge_arr_bitcast_0_stall_local);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_idxprom_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_memcoalesce_edge_arr_bitcast_0_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_idxprom_consumed_1_NO_SHIFT_REG <= (local_bb1_memcoalesce_edge_arr_bitcast_0_inputs_ready & (local_bb1_idxprom_consumed_1_NO_SHIFT_REG | ~(local_bb1_idxprom_stall_in_1)) & local_bb1_memcoalesce_edge_arr_bitcast_0_stall_local);
		local_bb1_memcoalesce_edge_arr_bitcast_0_consumed_0_NO_SHIFT_REG <= (local_bb1_memcoalesce_edge_arr_bitcast_0_inputs_ready & (local_bb1_memcoalesce_edge_arr_bitcast_0_consumed_0_NO_SHIFT_REG | ~(local_bb1_memcoalesce_edge_arr_bitcast_0_stall_in)) & local_bb1_memcoalesce_edge_arr_bitcast_0_stall_local);
	end
end


// Register node:
//  * latency = 161
//  * capacity = 161
 logic rnode_1to162_bb1_idxprom_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to162_bb1_idxprom_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_1to162_bb1_idxprom_0_NO_SHIFT_REG;
 logic rnode_1to162_bb1_idxprom_0_reg_162_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_1to162_bb1_idxprom_0_reg_162_NO_SHIFT_REG;
 logic rnode_1to162_bb1_idxprom_0_valid_out_reg_162_NO_SHIFT_REG;
 logic rnode_1to162_bb1_idxprom_0_stall_in_reg_162_NO_SHIFT_REG;
 logic rnode_1to162_bb1_idxprom_0_stall_out_reg_162_NO_SHIFT_REG;

acl_data_fifo rnode_1to162_bb1_idxprom_0_reg_162_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to162_bb1_idxprom_0_reg_162_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to162_bb1_idxprom_0_stall_in_reg_162_NO_SHIFT_REG),
	.valid_out(rnode_1to162_bb1_idxprom_0_valid_out_reg_162_NO_SHIFT_REG),
	.stall_out(rnode_1to162_bb1_idxprom_0_stall_out_reg_162_NO_SHIFT_REG),
	.data_in(local_bb1_idxprom),
	.data_out(rnode_1to162_bb1_idxprom_0_reg_162_NO_SHIFT_REG)
);

defparam rnode_1to162_bb1_idxprom_0_reg_162_fifo.DEPTH = 162;
defparam rnode_1to162_bb1_idxprom_0_reg_162_fifo.DATA_WIDTH = 64;
defparam rnode_1to162_bb1_idxprom_0_reg_162_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to162_bb1_idxprom_0_reg_162_fifo.IMPL = "ram";

assign rnode_1to162_bb1_idxprom_0_reg_162_inputs_ready_NO_SHIFT_REG = local_bb1_idxprom_valid_out_1;
assign local_bb1_idxprom_stall_in_1 = rnode_1to162_bb1_idxprom_0_stall_out_reg_162_NO_SHIFT_REG;
assign rnode_1to162_bb1_idxprom_0_NO_SHIFT_REG = rnode_1to162_bb1_idxprom_0_reg_162_NO_SHIFT_REG;
assign rnode_1to162_bb1_idxprom_0_stall_in_reg_162_NO_SHIFT_REG = rnode_1to162_bb1_idxprom_0_stall_in_NO_SHIFT_REG;
assign rnode_1to162_bb1_idxprom_0_valid_out_NO_SHIFT_REG = rnode_1to162_bb1_idxprom_0_valid_out_reg_162_NO_SHIFT_REG;

// This section implements a staging register.
// 
wire rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_valid_out;
wire rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_stall_in;
wire rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_inputs_ready;
wire rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_stall_local;
 reg rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_staging_valid_NO_SHIFT_REG;
wire rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_combined_valid;
 reg [63:0] rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_staging_reg_NO_SHIFT_REG;
wire [63:0] rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0;

assign rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_inputs_ready = local_bb1_memcoalesce_edge_arr_bitcast_0_valid_out;
assign rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0 = (rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_staging_valid_NO_SHIFT_REG ? rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_staging_reg_NO_SHIFT_REG : local_bb1_memcoalesce_edge_arr_bitcast_0);
assign rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_combined_valid = (rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_staging_valid_NO_SHIFT_REG | rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_inputs_ready);
assign rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_valid_out = rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_combined_valid;
assign rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_stall_local = rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_stall_in;
assign local_bb1_memcoalesce_edge_arr_bitcast_0_stall_in = (|rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_stall_local)
		begin
			if (~(rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_staging_valid_NO_SHIFT_REG))
			begin
				rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_staging_valid_NO_SHIFT_REG <= rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_inputs_ready;
			end
		end
		else
		begin
			rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_staging_valid_NO_SHIFT_REG))
		begin
			rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_staging_reg_NO_SHIFT_REG <= local_bb1_memcoalesce_edge_arr_bitcast_0;
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_162to163_bb1_idxprom_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_162to163_bb1_idxprom_0_stall_in_0_NO_SHIFT_REG;
 logic [63:0] rnode_162to163_bb1_idxprom_0_NO_SHIFT_REG;
 logic rnode_162to163_bb1_idxprom_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_162to163_bb1_idxprom_0_stall_in_1_NO_SHIFT_REG;
 logic [63:0] rnode_162to163_bb1_idxprom_1_NO_SHIFT_REG;
 logic rnode_162to163_bb1_idxprom_0_reg_163_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_162to163_bb1_idxprom_0_reg_163_NO_SHIFT_REG;
 logic rnode_162to163_bb1_idxprom_0_valid_out_0_reg_163_NO_SHIFT_REG;
 logic rnode_162to163_bb1_idxprom_0_stall_in_0_reg_163_NO_SHIFT_REG;
 logic rnode_162to163_bb1_idxprom_0_stall_out_reg_163_NO_SHIFT_REG;
 logic [63:0] rnode_162to163_bb1_idxprom_0_reg_163_NO_SHIFT_REG_fa;

acl_multi_fanout_adaptor rnode_162to163_bb1_idxprom_0_reg_163_fanout_adaptor (
	.clock(clock),
	.resetn(resetn),
	.data_in(rnode_162to163_bb1_idxprom_0_reg_163_NO_SHIFT_REG),
	.valid_in(rnode_162to163_bb1_idxprom_0_valid_out_0_reg_163_NO_SHIFT_REG),
	.stall_out(rnode_162to163_bb1_idxprom_0_stall_in_0_reg_163_NO_SHIFT_REG),
	.data_out(rnode_162to163_bb1_idxprom_0_reg_163_NO_SHIFT_REG_fa),
	.valid_out({rnode_162to163_bb1_idxprom_0_valid_out_0_NO_SHIFT_REG, rnode_162to163_bb1_idxprom_0_valid_out_1_NO_SHIFT_REG}),
	.stall_in({rnode_162to163_bb1_idxprom_0_stall_in_0_NO_SHIFT_REG, rnode_162to163_bb1_idxprom_0_stall_in_1_NO_SHIFT_REG})
);

defparam rnode_162to163_bb1_idxprom_0_reg_163_fanout_adaptor.DATA_WIDTH = 64;
defparam rnode_162to163_bb1_idxprom_0_reg_163_fanout_adaptor.NUM_FANOUTS = 2;

acl_data_fifo rnode_162to163_bb1_idxprom_0_reg_163_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_162to163_bb1_idxprom_0_reg_163_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_162to163_bb1_idxprom_0_stall_in_0_reg_163_NO_SHIFT_REG),
	.valid_out(rnode_162to163_bb1_idxprom_0_valid_out_0_reg_163_NO_SHIFT_REG),
	.stall_out(rnode_162to163_bb1_idxprom_0_stall_out_reg_163_NO_SHIFT_REG),
	.data_in(rnode_1to162_bb1_idxprom_0_NO_SHIFT_REG),
	.data_out(rnode_162to163_bb1_idxprom_0_reg_163_NO_SHIFT_REG)
);

defparam rnode_162to163_bb1_idxprom_0_reg_163_fifo.DEPTH = 2;
defparam rnode_162to163_bb1_idxprom_0_reg_163_fifo.DATA_WIDTH = 64;
defparam rnode_162to163_bb1_idxprom_0_reg_163_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_162to163_bb1_idxprom_0_reg_163_fifo.IMPL = "ll_reg";

assign rnode_162to163_bb1_idxprom_0_reg_163_inputs_ready_NO_SHIFT_REG = rnode_1to162_bb1_idxprom_0_valid_out_NO_SHIFT_REG;
assign rnode_1to162_bb1_idxprom_0_stall_in_NO_SHIFT_REG = rnode_162to163_bb1_idxprom_0_stall_out_reg_163_NO_SHIFT_REG;
assign rnode_162to163_bb1_idxprom_0_NO_SHIFT_REG = rnode_162to163_bb1_idxprom_0_reg_163_NO_SHIFT_REG_fa;
assign rnode_162to163_bb1_idxprom_1_NO_SHIFT_REG = rnode_162to163_bb1_idxprom_0_reg_163_NO_SHIFT_REG_fa;

// This section implements a registered operation.
// 
wire local_bb1_ld_memcoalesce_edge_arr_load_0_inputs_ready;
 reg local_bb1_ld_memcoalesce_edge_arr_load_0_valid_out_NO_SHIFT_REG;
wire local_bb1_ld_memcoalesce_edge_arr_load_0_stall_in;
wire local_bb1_ld_memcoalesce_edge_arr_load_0_output_regs_ready;
wire local_bb1_ld_memcoalesce_edge_arr_load_0_fu_stall_out;
wire local_bb1_ld_memcoalesce_edge_arr_load_0_fu_valid_out;
wire [63:0] local_bb1_ld_memcoalesce_edge_arr_load_0_lsu_dataout;
 reg [63:0] local_bb1_ld_memcoalesce_edge_arr_load_0_NO_SHIFT_REG;
wire local_bb1_ld_memcoalesce_edge_arr_load_0_causedstall;

lsu_top lsu_local_bb1_ld_memcoalesce_edge_arr_load_0 (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0),
	.stream_size(input_global_size_0),
	.stream_reset(valid_in),
	.o_stall(local_bb1_ld_memcoalesce_edge_arr_load_0_fu_stall_out),
	.i_valid(local_bb1_ld_memcoalesce_edge_arr_load_0_inputs_ready),
	.i_address(rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0),
	.i_writedata(),
	.i_cmpdata(),
	.i_predicate(1'b0),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb1_ld_memcoalesce_edge_arr_load_0_output_regs_ready)),
	.o_valid(local_bb1_ld_memcoalesce_edge_arr_load_0_fu_valid_out),
	.o_readdata(local_bb1_ld_memcoalesce_edge_arr_load_0_lsu_dataout),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb1_ld_memcoalesce_edge_arr_load_0_active),
	.avm_address(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_address),
	.avm_read(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_read),
	.avm_readdata(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_readdata),
	.avm_write(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_write),
	.avm_writeack(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_writeack),
	.avm_burstcount(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_burstcount),
	.avm_writedata(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_writedata),
	.avm_byteenable(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_byteenable),
	.avm_waitrequest(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_waitrequest),
	.avm_readdatavalid(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_readdatavalid),
	.profile_bw(),
	.profile_bw_incr(),
	.profile_total_ivalid(),
	.profile_total_req(),
	.profile_i_stall_count(),
	.profile_o_stall_count(),
	.profile_avm_readwrite_count(),
	.profile_avm_burstcount_total(),
	.profile_avm_burstcount_total_incr(),
	.profile_req_cache_hit_count(),
	.profile_extra_unaligned_reqs(),
	.profile_avm_stall()
);

defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.AWIDTH = 30;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.WIDTH_BYTES = 8;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.MWIDTH_BYTES = 32;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.ALIGNMENT_BYTES = 8;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.READ = 1;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.ATOMIC = 0;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.WIDTH = 64;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.MWIDTH = 256;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.ATOMIC_WIDTH = 3;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.KERNEL_SIDE_MEM_LATENCY = 2;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.MEMORY_SIDE_MEM_LATENCY = 58;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.USE_WRITE_ACK = 0;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.NUMBER_BANKS = 1;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.USEINPUTFIFO = 0;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.USECACHING = 0;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.USEOUTPUTFIFO = 1;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.HIGH_FMAX = 1;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.ADDRSPACE = 1;
defparam lsu_local_bb1_ld_memcoalesce_edge_arr_load_0.STYLE = "STREAMING";

assign local_bb1_ld_memcoalesce_edge_arr_load_0_inputs_ready = rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_valid_out;
assign local_bb1_ld_memcoalesce_edge_arr_load_0_output_regs_ready = (&(~(local_bb1_ld_memcoalesce_edge_arr_load_0_valid_out_NO_SHIFT_REG) | ~(local_bb1_ld_memcoalesce_edge_arr_load_0_stall_in)));
assign rstag_1to1_bb1_memcoalesce_edge_arr_bitcast_0_stall_in = (local_bb1_ld_memcoalesce_edge_arr_load_0_fu_stall_out | ~(local_bb1_ld_memcoalesce_edge_arr_load_0_inputs_ready));
assign local_bb1_ld_memcoalesce_edge_arr_load_0_causedstall = (local_bb1_ld_memcoalesce_edge_arr_load_0_inputs_ready && (local_bb1_ld_memcoalesce_edge_arr_load_0_fu_stall_out && !(~(local_bb1_ld_memcoalesce_edge_arr_load_0_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_ld_memcoalesce_edge_arr_load_0_NO_SHIFT_REG <= 'x;
		local_bb1_ld_memcoalesce_edge_arr_load_0_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_ld_memcoalesce_edge_arr_load_0_output_regs_ready)
		begin
			local_bb1_ld_memcoalesce_edge_arr_load_0_NO_SHIFT_REG <= local_bb1_ld_memcoalesce_edge_arr_load_0_lsu_dataout;
			local_bb1_ld_memcoalesce_edge_arr_load_0_valid_out_NO_SHIFT_REG <= local_bb1_ld_memcoalesce_edge_arr_load_0_fu_valid_out;
		end
		else
		begin
			if (~(local_bb1_ld_memcoalesce_edge_arr_load_0_stall_in))
			begin
				local_bb1_ld_memcoalesce_edge_arr_load_0_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_dest5_valid_out;
wire local_bb1_dest5_stall_in;
wire local_bb1_dest5_inputs_ready;
wire local_bb1_dest5_stall_local;
wire [63:0] local_bb1_dest5;

assign local_bb1_dest5_inputs_ready = rnode_162to163_bb1_idxprom_0_valid_out_0_NO_SHIFT_REG;
assign local_bb1_dest5 = (input_msg_arr + (rnode_162to163_bb1_idxprom_0_NO_SHIFT_REG << 6'h3));
assign local_bb1_dest5_valid_out = local_bb1_dest5_inputs_ready;
assign local_bb1_dest5_stall_local = local_bb1_dest5_stall_in;
assign rnode_162to163_bb1_idxprom_0_stall_in_0_NO_SHIFT_REG = (|local_bb1_dest5_stall_local);

// Register node:
//  * latency = 327
//  * capacity = 327
 logic rnode_163to490_bb1_idxprom_0_valid_out_NO_SHIFT_REG;
 logic rnode_163to490_bb1_idxprom_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_163to490_bb1_idxprom_0_NO_SHIFT_REG;
 logic rnode_163to490_bb1_idxprom_0_reg_490_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_163to490_bb1_idxprom_0_reg_490_NO_SHIFT_REG;
 logic rnode_163to490_bb1_idxprom_0_valid_out_reg_490_NO_SHIFT_REG;
 logic rnode_163to490_bb1_idxprom_0_stall_in_reg_490_NO_SHIFT_REG;
 logic rnode_163to490_bb1_idxprom_0_stall_out_reg_490_NO_SHIFT_REG;

acl_data_fifo rnode_163to490_bb1_idxprom_0_reg_490_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_163to490_bb1_idxprom_0_reg_490_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_163to490_bb1_idxprom_0_stall_in_reg_490_NO_SHIFT_REG),
	.valid_out(rnode_163to490_bb1_idxprom_0_valid_out_reg_490_NO_SHIFT_REG),
	.stall_out(rnode_163to490_bb1_idxprom_0_stall_out_reg_490_NO_SHIFT_REG),
	.data_in(rnode_162to163_bb1_idxprom_1_NO_SHIFT_REG),
	.data_out(rnode_163to490_bb1_idxprom_0_reg_490_NO_SHIFT_REG)
);

defparam rnode_163to490_bb1_idxprom_0_reg_490_fifo.DEPTH = 328;
defparam rnode_163to490_bb1_idxprom_0_reg_490_fifo.DATA_WIDTH = 64;
defparam rnode_163to490_bb1_idxprom_0_reg_490_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_163to490_bb1_idxprom_0_reg_490_fifo.IMPL = "ram";

assign rnode_163to490_bb1_idxprom_0_reg_490_inputs_ready_NO_SHIFT_REG = rnode_162to163_bb1_idxprom_0_valid_out_1_NO_SHIFT_REG;
assign rnode_162to163_bb1_idxprom_0_stall_in_1_NO_SHIFT_REG = rnode_163to490_bb1_idxprom_0_stall_out_reg_490_NO_SHIFT_REG;
assign rnode_163to490_bb1_idxprom_0_NO_SHIFT_REG = rnode_163to490_bb1_idxprom_0_reg_490_NO_SHIFT_REG;
assign rnode_163to490_bb1_idxprom_0_stall_in_reg_490_NO_SHIFT_REG = rnode_163to490_bb1_idxprom_0_stall_in_NO_SHIFT_REG;
assign rnode_163to490_bb1_idxprom_0_valid_out_NO_SHIFT_REG = rnode_163to490_bb1_idxprom_0_valid_out_reg_490_NO_SHIFT_REG;

// This section implements a staging register.
// 
wire rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_valid_out_0;
wire rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_stall_in_0;
 reg rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_consumed_0_NO_SHIFT_REG;
wire rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_valid_out_1;
wire rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_stall_in_1;
 reg rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_consumed_1_NO_SHIFT_REG;
wire rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_inputs_ready;
wire rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_stall_local;
 reg rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_staging_valid_NO_SHIFT_REG;
wire rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_combined_valid;
 reg [63:0] rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_staging_reg_NO_SHIFT_REG;
wire [63:0] rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0;

assign rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_inputs_ready = local_bb1_ld_memcoalesce_edge_arr_load_0_valid_out_NO_SHIFT_REG;
assign rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0 = (rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_staging_valid_NO_SHIFT_REG ? rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_staging_reg_NO_SHIFT_REG : local_bb1_ld_memcoalesce_edge_arr_load_0_NO_SHIFT_REG);
assign rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_combined_valid = (rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_staging_valid_NO_SHIFT_REG | rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_inputs_ready);
assign rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_stall_local = ((rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_stall_in_0 & ~(rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_consumed_0_NO_SHIFT_REG)) | (rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_stall_in_1 & ~(rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_consumed_1_NO_SHIFT_REG)));
assign rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_valid_out_0 = (rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_combined_valid & ~(rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_consumed_0_NO_SHIFT_REG));
assign rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_valid_out_1 = (rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_combined_valid & ~(rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_consumed_1_NO_SHIFT_REG));
assign local_bb1_ld_memcoalesce_edge_arr_load_0_stall_in = (|rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_stall_local)
		begin
			if (~(rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_staging_valid_NO_SHIFT_REG))
			begin
				rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_staging_valid_NO_SHIFT_REG <= rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_inputs_ready;
			end
		end
		else
		begin
			rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_staging_valid_NO_SHIFT_REG))
		begin
			rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_staging_reg_NO_SHIFT_REG <= local_bb1_ld_memcoalesce_edge_arr_load_0_NO_SHIFT_REG;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_consumed_0_NO_SHIFT_REG <= 1'b0;
		rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_consumed_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_consumed_0_NO_SHIFT_REG <= (rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_combined_valid & (rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_consumed_0_NO_SHIFT_REG | ~(rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_stall_in_0)) & rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_stall_local);
		rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_consumed_1_NO_SHIFT_REG <= (rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_combined_valid & (rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_consumed_1_NO_SHIFT_REG | ~(rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_stall_in_1)) & rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_490to491_bb1_idxprom_0_valid_out_NO_SHIFT_REG;
 logic rnode_490to491_bb1_idxprom_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_490to491_bb1_idxprom_0_NO_SHIFT_REG;
 logic rnode_490to491_bb1_idxprom_0_reg_491_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_490to491_bb1_idxprom_0_reg_491_NO_SHIFT_REG;
 logic rnode_490to491_bb1_idxprom_0_valid_out_reg_491_NO_SHIFT_REG;
 logic rnode_490to491_bb1_idxprom_0_stall_in_reg_491_NO_SHIFT_REG;
 logic rnode_490to491_bb1_idxprom_0_stall_out_reg_491_NO_SHIFT_REG;

acl_data_fifo rnode_490to491_bb1_idxprom_0_reg_491_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_490to491_bb1_idxprom_0_reg_491_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_490to491_bb1_idxprom_0_stall_in_reg_491_NO_SHIFT_REG),
	.valid_out(rnode_490to491_bb1_idxprom_0_valid_out_reg_491_NO_SHIFT_REG),
	.stall_out(rnode_490to491_bb1_idxprom_0_stall_out_reg_491_NO_SHIFT_REG),
	.data_in(rnode_163to490_bb1_idxprom_0_NO_SHIFT_REG),
	.data_out(rnode_490to491_bb1_idxprom_0_reg_491_NO_SHIFT_REG)
);

defparam rnode_490to491_bb1_idxprom_0_reg_491_fifo.DEPTH = 2;
defparam rnode_490to491_bb1_idxprom_0_reg_491_fifo.DATA_WIDTH = 64;
defparam rnode_490to491_bb1_idxprom_0_reg_491_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_490to491_bb1_idxprom_0_reg_491_fifo.IMPL = "ll_reg";

assign rnode_490to491_bb1_idxprom_0_reg_491_inputs_ready_NO_SHIFT_REG = rnode_163to490_bb1_idxprom_0_valid_out_NO_SHIFT_REG;
assign rnode_163to490_bb1_idxprom_0_stall_in_NO_SHIFT_REG = rnode_490to491_bb1_idxprom_0_stall_out_reg_491_NO_SHIFT_REG;
assign rnode_490to491_bb1_idxprom_0_NO_SHIFT_REG = rnode_490to491_bb1_idxprom_0_reg_491_NO_SHIFT_REG;
assign rnode_490to491_bb1_idxprom_0_stall_in_reg_491_NO_SHIFT_REG = rnode_490to491_bb1_idxprom_0_stall_in_NO_SHIFT_REG;
assign rnode_490to491_bb1_idxprom_0_valid_out_NO_SHIFT_REG = rnode_490to491_bb1_idxprom_0_valid_out_reg_491_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_memcoalesce_edge_arr_extrValue_1_valid_out;
wire local_bb1_memcoalesce_edge_arr_extrValue_1_stall_in;
wire local_bb1_memcoalesce_edge_arr_extrValue_1_inputs_ready;
wire local_bb1_memcoalesce_edge_arr_extrValue_1_stall_local;
wire [31:0] local_bb1_memcoalesce_edge_arr_extrValue_1;

assign local_bb1_memcoalesce_edge_arr_extrValue_1_inputs_ready = rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_valid_out_0;
assign local_bb1_memcoalesce_edge_arr_extrValue_1 = rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0[63:32];
assign local_bb1_memcoalesce_edge_arr_extrValue_1_valid_out = local_bb1_memcoalesce_edge_arr_extrValue_1_inputs_ready;
assign local_bb1_memcoalesce_edge_arr_extrValue_1_stall_local = local_bb1_memcoalesce_edge_arr_extrValue_1_stall_in;
assign rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_stall_in_0 = (|local_bb1_memcoalesce_edge_arr_extrValue_1_stall_local);

// This section implements an unregistered operation.
// 
wire local_bb1_memcoalesce_edge_arr_extrValue_0_stall_local;
wire [31:0] local_bb1_memcoalesce_edge_arr_extrValue_0;

assign local_bb1_memcoalesce_edge_arr_extrValue_0 = rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0[31:0];

// This section implements an unregistered operation.
// 
wire local_bb1_val_valid_out;
wire local_bb1_val_stall_in;
wire local_bb1_val_inputs_ready;
wire local_bb1_val_stall_local;
wire [63:0] local_bb1_val;

assign local_bb1_val_inputs_ready = rnode_490to491_bb1_idxprom_0_valid_out_NO_SHIFT_REG;
assign local_bb1_val = ((input_msg_arr + (rnode_490to491_bb1_idxprom_0_NO_SHIFT_REG << 6'h3)) + 64'h4);
assign local_bb1_val_valid_out = local_bb1_val_inputs_ready;
assign local_bb1_val_stall_local = local_bb1_val_stall_in;
assign rnode_490to491_bb1_idxprom_0_stall_in_NO_SHIFT_REG = (|local_bb1_val_stall_local);

// Register node:
//  * latency = 159
//  * capacity = 159
 logic rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_valid_out_NO_SHIFT_REG;
 logic rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_NO_SHIFT_REG;
 logic rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_162_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_162_NO_SHIFT_REG;
 logic rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_valid_out_reg_162_NO_SHIFT_REG;
 logic rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_in_reg_162_NO_SHIFT_REG;
 logic rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_out_reg_162_NO_SHIFT_REG;

acl_data_fifo rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_162_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_162_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_in_reg_162_NO_SHIFT_REG),
	.valid_out(rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_valid_out_reg_162_NO_SHIFT_REG),
	.stall_out(rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_out_reg_162_NO_SHIFT_REG),
	.data_in(local_bb1_memcoalesce_edge_arr_extrValue_1),
	.data_out(rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_162_NO_SHIFT_REG)
);

defparam rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_162_fifo.DEPTH = 160;
defparam rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_162_fifo.DATA_WIDTH = 32;
defparam rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_162_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_162_fifo.IMPL = "ram";

assign rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_162_inputs_ready_NO_SHIFT_REG = local_bb1_memcoalesce_edge_arr_extrValue_1_valid_out;
assign local_bb1_memcoalesce_edge_arr_extrValue_1_stall_in = rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_out_reg_162_NO_SHIFT_REG;
assign rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_NO_SHIFT_REG = rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_162_NO_SHIFT_REG;
assign rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_in_reg_162_NO_SHIFT_REG = rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_in_NO_SHIFT_REG;
assign rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_valid_out_NO_SHIFT_REG = rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_valid_out_reg_162_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_idxprom1_stall_local;
wire [63:0] local_bb1_idxprom1;

assign local_bb1_idxprom1[32] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[33] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[34] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[35] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[36] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[37] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[38] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[39] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[40] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[41] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[42] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[43] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[44] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[45] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[46] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[47] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[48] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[49] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[50] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[51] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[52] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[53] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[54] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[55] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[56] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[57] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[58] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[59] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[60] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[61] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[62] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[63] = local_bb1_memcoalesce_edge_arr_extrValue_0[31];
assign local_bb1_idxprom1[31:0] = local_bb1_memcoalesce_edge_arr_extrValue_0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_valid_out_NO_SHIFT_REG;
 logic rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_NO_SHIFT_REG;
 logic rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_163_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_163_NO_SHIFT_REG;
 logic rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_valid_out_reg_163_NO_SHIFT_REG;
 logic rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_in_reg_163_NO_SHIFT_REG;
 logic rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_out_reg_163_NO_SHIFT_REG;

acl_data_fifo rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_163_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_163_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_in_reg_163_NO_SHIFT_REG),
	.valid_out(rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_valid_out_reg_163_NO_SHIFT_REG),
	.stall_out(rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_out_reg_163_NO_SHIFT_REG),
	.data_in(rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_NO_SHIFT_REG),
	.data_out(rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_163_NO_SHIFT_REG)
);

defparam rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_163_fifo.DEPTH = 2;
defparam rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_163_fifo.DATA_WIDTH = 32;
defparam rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_163_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_163_fifo.IMPL = "ll_reg";

assign rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_163_inputs_ready_NO_SHIFT_REG = rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_valid_out_NO_SHIFT_REG;
assign rnode_3to162_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_in_NO_SHIFT_REG = rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_out_reg_163_NO_SHIFT_REG;
assign rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_NO_SHIFT_REG = rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_reg_163_NO_SHIFT_REG;
assign rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_in_reg_163_NO_SHIFT_REG = rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_in_NO_SHIFT_REG;
assign rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_valid_out_NO_SHIFT_REG = rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_valid_out_reg_163_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_arrayidx2_stall_local;
wire [63:0] local_bb1_arrayidx2;

assign local_bb1_arrayidx2 = (input_outCount_arr + (local_bb1_idxprom1 << 6'h2));

// This section implements an unregistered operation.
// 
wire local_bb1_arrayidx2_valid_out;
wire local_bb1_arrayidx2_stall_in;
 reg local_bb1_arrayidx2_consumed_0_NO_SHIFT_REG;
wire local_bb1_arrayidx8_valid_out;
wire local_bb1_arrayidx8_stall_in;
 reg local_bb1_arrayidx8_consumed_0_NO_SHIFT_REG;
wire local_bb1_arrayidx8_inputs_ready;
wire local_bb1_arrayidx8_stall_local;
wire [63:0] local_bb1_arrayidx8;

assign local_bb1_arrayidx8_inputs_ready = rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_valid_out_1;
assign local_bb1_arrayidx8 = (input_rank + (local_bb1_idxprom1 << 6'h2));
assign local_bb1_arrayidx8_stall_local = ((local_bb1_arrayidx2_stall_in & ~(local_bb1_arrayidx2_consumed_0_NO_SHIFT_REG)) | (local_bb1_arrayidx8_stall_in & ~(local_bb1_arrayidx8_consumed_0_NO_SHIFT_REG)));
assign local_bb1_arrayidx2_valid_out = (local_bb1_arrayidx8_inputs_ready & ~(local_bb1_arrayidx2_consumed_0_NO_SHIFT_REG));
assign local_bb1_arrayidx8_valid_out = (local_bb1_arrayidx8_inputs_ready & ~(local_bb1_arrayidx8_consumed_0_NO_SHIFT_REG));
assign rstag_3to3_bb1_ld_memcoalesce_edge_arr_load_0_stall_in_1 = (|local_bb1_arrayidx8_stall_local);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_arrayidx2_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_arrayidx8_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_arrayidx2_consumed_0_NO_SHIFT_REG <= (local_bb1_arrayidx8_inputs_ready & (local_bb1_arrayidx2_consumed_0_NO_SHIFT_REG | ~(local_bb1_arrayidx2_stall_in)) & local_bb1_arrayidx8_stall_local);
		local_bb1_arrayidx8_consumed_0_NO_SHIFT_REG <= (local_bb1_arrayidx8_inputs_ready & (local_bb1_arrayidx8_consumed_0_NO_SHIFT_REG | ~(local_bb1_arrayidx8_stall_in)) & local_bb1_arrayidx8_stall_local);
	end
end


// This section implements a staging register.
// 
wire rstag_3to3_bb1_arrayidx2_valid_out;
wire rstag_3to3_bb1_arrayidx2_stall_in;
wire rstag_3to3_bb1_arrayidx2_inputs_ready;
wire rstag_3to3_bb1_arrayidx2_stall_local;
 reg rstag_3to3_bb1_arrayidx2_staging_valid_NO_SHIFT_REG;
wire rstag_3to3_bb1_arrayidx2_combined_valid;
 reg [63:0] rstag_3to3_bb1_arrayidx2_staging_reg_NO_SHIFT_REG;
wire [63:0] rstag_3to3_bb1_arrayidx2;

assign rstag_3to3_bb1_arrayidx2_inputs_ready = local_bb1_arrayidx2_valid_out;
assign rstag_3to3_bb1_arrayidx2 = (rstag_3to3_bb1_arrayidx2_staging_valid_NO_SHIFT_REG ? rstag_3to3_bb1_arrayidx2_staging_reg_NO_SHIFT_REG : local_bb1_arrayidx2);
assign rstag_3to3_bb1_arrayidx2_combined_valid = (rstag_3to3_bb1_arrayidx2_staging_valid_NO_SHIFT_REG | rstag_3to3_bb1_arrayidx2_inputs_ready);
assign rstag_3to3_bb1_arrayidx2_valid_out = rstag_3to3_bb1_arrayidx2_combined_valid;
assign rstag_3to3_bb1_arrayidx2_stall_local = rstag_3to3_bb1_arrayidx2_stall_in;
assign local_bb1_arrayidx2_stall_in = (|rstag_3to3_bb1_arrayidx2_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_3to3_bb1_arrayidx2_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_3to3_bb1_arrayidx2_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_3to3_bb1_arrayidx2_stall_local)
		begin
			if (~(rstag_3to3_bb1_arrayidx2_staging_valid_NO_SHIFT_REG))
			begin
				rstag_3to3_bb1_arrayidx2_staging_valid_NO_SHIFT_REG <= rstag_3to3_bb1_arrayidx2_inputs_ready;
			end
		end
		else
		begin
			rstag_3to3_bb1_arrayidx2_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_3to3_bb1_arrayidx2_staging_valid_NO_SHIFT_REG))
		begin
			rstag_3to3_bb1_arrayidx2_staging_reg_NO_SHIFT_REG <= local_bb1_arrayidx2;
		end
	end
end


// Register node:
//  * latency = 301
//  * capacity = 301
 logic rnode_3to304_bb1_arrayidx8_0_valid_out_NO_SHIFT_REG;
 logic rnode_3to304_bb1_arrayidx8_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_3to304_bb1_arrayidx8_0_NO_SHIFT_REG;
 logic rnode_3to304_bb1_arrayidx8_0_reg_304_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_3to304_bb1_arrayidx8_0_reg_304_NO_SHIFT_REG;
 logic rnode_3to304_bb1_arrayidx8_0_valid_out_reg_304_NO_SHIFT_REG;
 logic rnode_3to304_bb1_arrayidx8_0_stall_in_reg_304_NO_SHIFT_REG;
 logic rnode_3to304_bb1_arrayidx8_0_stall_out_reg_304_NO_SHIFT_REG;

acl_data_fifo rnode_3to304_bb1_arrayidx8_0_reg_304_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_3to304_bb1_arrayidx8_0_reg_304_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_3to304_bb1_arrayidx8_0_stall_in_reg_304_NO_SHIFT_REG),
	.valid_out(rnode_3to304_bb1_arrayidx8_0_valid_out_reg_304_NO_SHIFT_REG),
	.stall_out(rnode_3to304_bb1_arrayidx8_0_stall_out_reg_304_NO_SHIFT_REG),
	.data_in(local_bb1_arrayidx8),
	.data_out(rnode_3to304_bb1_arrayidx8_0_reg_304_NO_SHIFT_REG)
);

defparam rnode_3to304_bb1_arrayidx8_0_reg_304_fifo.DEPTH = 302;
defparam rnode_3to304_bb1_arrayidx8_0_reg_304_fifo.DATA_WIDTH = 64;
defparam rnode_3to304_bb1_arrayidx8_0_reg_304_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_3to304_bb1_arrayidx8_0_reg_304_fifo.IMPL = "ram";

assign rnode_3to304_bb1_arrayidx8_0_reg_304_inputs_ready_NO_SHIFT_REG = local_bb1_arrayidx8_valid_out;
assign local_bb1_arrayidx8_stall_in = rnode_3to304_bb1_arrayidx8_0_stall_out_reg_304_NO_SHIFT_REG;
assign rnode_3to304_bb1_arrayidx8_0_NO_SHIFT_REG = rnode_3to304_bb1_arrayidx8_0_reg_304_NO_SHIFT_REG;
assign rnode_3to304_bb1_arrayidx8_0_stall_in_reg_304_NO_SHIFT_REG = rnode_3to304_bb1_arrayidx8_0_stall_in_NO_SHIFT_REG;
assign rnode_3to304_bb1_arrayidx8_0_valid_out_NO_SHIFT_REG = rnode_3to304_bb1_arrayidx8_0_valid_out_reg_304_NO_SHIFT_REG;

// This section implements a registered operation.
// 
wire local_bb1_ld__inputs_ready;
 reg local_bb1_ld__valid_out_NO_SHIFT_REG;
wire local_bb1_ld__stall_in;
wire local_bb1_ld__output_regs_ready;
wire local_bb1_ld__fu_stall_out;
wire local_bb1_ld__fu_valid_out;
wire [31:0] local_bb1_ld__lsu_dataout;
 reg [31:0] local_bb1_ld__NO_SHIFT_REG;
wire local_bb1_ld__causedstall;

lsu_top lsu_local_bb1_ld_ (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(),
	.stream_size(),
	.stream_reset(),
	.o_stall(local_bb1_ld__fu_stall_out),
	.i_valid(local_bb1_ld__inputs_ready),
	.i_address(rstag_3to3_bb1_arrayidx2),
	.i_writedata(),
	.i_cmpdata(),
	.i_predicate(1'b0),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb1_ld__output_regs_ready)),
	.o_valid(local_bb1_ld__fu_valid_out),
	.o_readdata(local_bb1_ld__lsu_dataout),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb1_ld__active),
	.avm_address(avm_local_bb1_ld__address),
	.avm_read(avm_local_bb1_ld__read),
	.avm_readdata(avm_local_bb1_ld__readdata),
	.avm_write(avm_local_bb1_ld__write),
	.avm_writeack(avm_local_bb1_ld__writeack),
	.avm_burstcount(avm_local_bb1_ld__burstcount),
	.avm_writedata(avm_local_bb1_ld__writedata),
	.avm_byteenable(avm_local_bb1_ld__byteenable),
	.avm_waitrequest(avm_local_bb1_ld__waitrequest),
	.avm_readdatavalid(avm_local_bb1_ld__readdatavalid),
	.profile_bw(),
	.profile_bw_incr(),
	.profile_total_ivalid(),
	.profile_total_req(),
	.profile_i_stall_count(),
	.profile_o_stall_count(),
	.profile_avm_readwrite_count(),
	.profile_avm_burstcount_total(),
	.profile_avm_burstcount_total_incr(),
	.profile_req_cache_hit_count(),
	.profile_extra_unaligned_reqs(),
	.profile_avm_stall()
);

defparam lsu_local_bb1_ld_.AWIDTH = 30;
defparam lsu_local_bb1_ld_.WIDTH_BYTES = 4;
defparam lsu_local_bb1_ld_.MWIDTH_BYTES = 32;
defparam lsu_local_bb1_ld_.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb1_ld_.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb1_ld_.READ = 1;
defparam lsu_local_bb1_ld_.ATOMIC = 0;
defparam lsu_local_bb1_ld_.WIDTH = 32;
defparam lsu_local_bb1_ld_.MWIDTH = 256;
defparam lsu_local_bb1_ld_.ATOMIC_WIDTH = 3;
defparam lsu_local_bb1_ld_.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb1_ld_.KERNEL_SIDE_MEM_LATENCY = 160;
defparam lsu_local_bb1_ld_.MEMORY_SIDE_MEM_LATENCY = 58;
defparam lsu_local_bb1_ld_.USE_WRITE_ACK = 0;
defparam lsu_local_bb1_ld_.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb1_ld_.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb1_ld_.NUMBER_BANKS = 1;
defparam lsu_local_bb1_ld_.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb1_ld_.USEINPUTFIFO = 0;
defparam lsu_local_bb1_ld_.USECACHING = 1;
defparam lsu_local_bb1_ld_.CACHESIZE = 256;
defparam lsu_local_bb1_ld_.USEOUTPUTFIFO = 1;
defparam lsu_local_bb1_ld_.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb1_ld_.HIGH_FMAX = 1;
defparam lsu_local_bb1_ld_.ADDRSPACE = 1;
defparam lsu_local_bb1_ld_.STYLE = "BURST-COALESCED";

assign local_bb1_ld__inputs_ready = rstag_3to3_bb1_arrayidx2_valid_out;
assign local_bb1_ld__output_regs_ready = (&(~(local_bb1_ld__valid_out_NO_SHIFT_REG) | ~(local_bb1_ld__stall_in)));
assign rstag_3to3_bb1_arrayidx2_stall_in = (local_bb1_ld__fu_stall_out | ~(local_bb1_ld__inputs_ready));
assign local_bb1_ld__causedstall = (local_bb1_ld__inputs_ready && (local_bb1_ld__fu_stall_out && !(~(local_bb1_ld__output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_ld__NO_SHIFT_REG <= 'x;
		local_bb1_ld__valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_ld__output_regs_ready)
		begin
			local_bb1_ld__NO_SHIFT_REG <= local_bb1_ld__lsu_dataout;
			local_bb1_ld__valid_out_NO_SHIFT_REG <= local_bb1_ld__fu_valid_out;
		end
		else
		begin
			if (~(local_bb1_ld__stall_in))
			begin
				local_bb1_ld__valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_304to305_bb1_arrayidx8_0_valid_out_NO_SHIFT_REG;
 logic rnode_304to305_bb1_arrayidx8_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_304to305_bb1_arrayidx8_0_NO_SHIFT_REG;
 logic rnode_304to305_bb1_arrayidx8_0_reg_305_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_304to305_bb1_arrayidx8_0_reg_305_NO_SHIFT_REG;
 logic rnode_304to305_bb1_arrayidx8_0_valid_out_reg_305_NO_SHIFT_REG;
 logic rnode_304to305_bb1_arrayidx8_0_stall_in_reg_305_NO_SHIFT_REG;
 logic rnode_304to305_bb1_arrayidx8_0_stall_out_reg_305_NO_SHIFT_REG;

acl_data_fifo rnode_304to305_bb1_arrayidx8_0_reg_305_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_304to305_bb1_arrayidx8_0_reg_305_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_304to305_bb1_arrayidx8_0_stall_in_reg_305_NO_SHIFT_REG),
	.valid_out(rnode_304to305_bb1_arrayidx8_0_valid_out_reg_305_NO_SHIFT_REG),
	.stall_out(rnode_304to305_bb1_arrayidx8_0_stall_out_reg_305_NO_SHIFT_REG),
	.data_in(rnode_3to304_bb1_arrayidx8_0_NO_SHIFT_REG),
	.data_out(rnode_304to305_bb1_arrayidx8_0_reg_305_NO_SHIFT_REG)
);

defparam rnode_304to305_bb1_arrayidx8_0_reg_305_fifo.DEPTH = 2;
defparam rnode_304to305_bb1_arrayidx8_0_reg_305_fifo.DATA_WIDTH = 64;
defparam rnode_304to305_bb1_arrayidx8_0_reg_305_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_304to305_bb1_arrayidx8_0_reg_305_fifo.IMPL = "ll_reg";

assign rnode_304to305_bb1_arrayidx8_0_reg_305_inputs_ready_NO_SHIFT_REG = rnode_3to304_bb1_arrayidx8_0_valid_out_NO_SHIFT_REG;
assign rnode_3to304_bb1_arrayidx8_0_stall_in_NO_SHIFT_REG = rnode_304to305_bb1_arrayidx8_0_stall_out_reg_305_NO_SHIFT_REG;
assign rnode_304to305_bb1_arrayidx8_0_NO_SHIFT_REG = rnode_304to305_bb1_arrayidx8_0_reg_305_NO_SHIFT_REG;
assign rnode_304to305_bb1_arrayidx8_0_stall_in_reg_305_NO_SHIFT_REG = rnode_304to305_bb1_arrayidx8_0_stall_in_NO_SHIFT_REG;
assign rnode_304to305_bb1_arrayidx8_0_valid_out_NO_SHIFT_REG = rnode_304to305_bb1_arrayidx8_0_valid_out_reg_305_NO_SHIFT_REG;

// This section implements a staging register.
// 
wire rstag_163to163_bb1_ld__valid_out_0;
wire rstag_163to163_bb1_ld__stall_in_0;
 reg rstag_163to163_bb1_ld__consumed_0_NO_SHIFT_REG;
wire rstag_163to163_bb1_ld__valid_out_1;
wire rstag_163to163_bb1_ld__stall_in_1;
 reg rstag_163to163_bb1_ld__consumed_1_NO_SHIFT_REG;
wire rstag_163to163_bb1_ld__inputs_ready;
wire rstag_163to163_bb1_ld__stall_local;
 reg rstag_163to163_bb1_ld__staging_valid_NO_SHIFT_REG;
wire rstag_163to163_bb1_ld__combined_valid;
 reg [31:0] rstag_163to163_bb1_ld__staging_reg_NO_SHIFT_REG;
wire [31:0] rstag_163to163_bb1_ld_;

assign rstag_163to163_bb1_ld__inputs_ready = local_bb1_ld__valid_out_NO_SHIFT_REG;
assign rstag_163to163_bb1_ld_ = (rstag_163to163_bb1_ld__staging_valid_NO_SHIFT_REG ? rstag_163to163_bb1_ld__staging_reg_NO_SHIFT_REG : local_bb1_ld__NO_SHIFT_REG);
assign rstag_163to163_bb1_ld__combined_valid = (rstag_163to163_bb1_ld__staging_valid_NO_SHIFT_REG | rstag_163to163_bb1_ld__inputs_ready);
assign rstag_163to163_bb1_ld__stall_local = ((rstag_163to163_bb1_ld__stall_in_0 & ~(rstag_163to163_bb1_ld__consumed_0_NO_SHIFT_REG)) | (rstag_163to163_bb1_ld__stall_in_1 & ~(rstag_163to163_bb1_ld__consumed_1_NO_SHIFT_REG)));
assign rstag_163to163_bb1_ld__valid_out_0 = (rstag_163to163_bb1_ld__combined_valid & ~(rstag_163to163_bb1_ld__consumed_0_NO_SHIFT_REG));
assign rstag_163to163_bb1_ld__valid_out_1 = (rstag_163to163_bb1_ld__combined_valid & ~(rstag_163to163_bb1_ld__consumed_1_NO_SHIFT_REG));
assign local_bb1_ld__stall_in = (|rstag_163to163_bb1_ld__staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_163to163_bb1_ld__staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_163to163_bb1_ld__staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_163to163_bb1_ld__stall_local)
		begin
			if (~(rstag_163to163_bb1_ld__staging_valid_NO_SHIFT_REG))
			begin
				rstag_163to163_bb1_ld__staging_valid_NO_SHIFT_REG <= rstag_163to163_bb1_ld__inputs_ready;
			end
		end
		else
		begin
			rstag_163to163_bb1_ld__staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_163to163_bb1_ld__staging_valid_NO_SHIFT_REG))
		begin
			rstag_163to163_bb1_ld__staging_reg_NO_SHIFT_REG <= local_bb1_ld__NO_SHIFT_REG;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_163to163_bb1_ld__consumed_0_NO_SHIFT_REG <= 1'b0;
		rstag_163to163_bb1_ld__consumed_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		rstag_163to163_bb1_ld__consumed_0_NO_SHIFT_REG <= (rstag_163to163_bb1_ld__combined_valid & (rstag_163to163_bb1_ld__consumed_0_NO_SHIFT_REG | ~(rstag_163to163_bb1_ld__stall_in_0)) & rstag_163to163_bb1_ld__stall_local);
		rstag_163to163_bb1_ld__consumed_1_NO_SHIFT_REG <= (rstag_163to163_bb1_ld__combined_valid & (rstag_163to163_bb1_ld__consumed_1_NO_SHIFT_REG | ~(rstag_163to163_bb1_ld__stall_in_1)) & rstag_163to163_bb1_ld__stall_local);
	end
end


// Register node:
//  * latency = 301
//  * capacity = 301
 logic rnode_163to464_bb1_ld__0_valid_out_NO_SHIFT_REG;
 logic rnode_163to464_bb1_ld__0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_163to464_bb1_ld__0_NO_SHIFT_REG;
 logic rnode_163to464_bb1_ld__0_reg_464_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_163to464_bb1_ld__0_reg_464_NO_SHIFT_REG;
 logic rnode_163to464_bb1_ld__0_valid_out_reg_464_NO_SHIFT_REG;
 logic rnode_163to464_bb1_ld__0_stall_in_reg_464_NO_SHIFT_REG;
 logic rnode_163to464_bb1_ld__0_stall_out_reg_464_NO_SHIFT_REG;

acl_data_fifo rnode_163to464_bb1_ld__0_reg_464_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_163to464_bb1_ld__0_reg_464_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_163to464_bb1_ld__0_stall_in_reg_464_NO_SHIFT_REG),
	.valid_out(rnode_163to464_bb1_ld__0_valid_out_reg_464_NO_SHIFT_REG),
	.stall_out(rnode_163to464_bb1_ld__0_stall_out_reg_464_NO_SHIFT_REG),
	.data_in(rstag_163to163_bb1_ld_),
	.data_out(rnode_163to464_bb1_ld__0_reg_464_NO_SHIFT_REG)
);

defparam rnode_163to464_bb1_ld__0_reg_464_fifo.DEPTH = 302;
defparam rnode_163to464_bb1_ld__0_reg_464_fifo.DATA_WIDTH = 32;
defparam rnode_163to464_bb1_ld__0_reg_464_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_163to464_bb1_ld__0_reg_464_fifo.IMPL = "ram";

assign rnode_163to464_bb1_ld__0_reg_464_inputs_ready_NO_SHIFT_REG = rstag_163to163_bb1_ld__valid_out_0;
assign rstag_163to163_bb1_ld__stall_in_0 = rnode_163to464_bb1_ld__0_stall_out_reg_464_NO_SHIFT_REG;
assign rnode_163to464_bb1_ld__0_NO_SHIFT_REG = rnode_163to464_bb1_ld__0_reg_464_NO_SHIFT_REG;
assign rnode_163to464_bb1_ld__0_stall_in_reg_464_NO_SHIFT_REG = rnode_163to464_bb1_ld__0_stall_in_NO_SHIFT_REG;
assign rnode_163to464_bb1_ld__0_valid_out_NO_SHIFT_REG = rnode_163to464_bb1_ld__0_valid_out_reg_464_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_var__stall_local;
wire [31:0] local_bb1_var_;

assign local_bb1_var_ = (rstag_163to163_bb1_ld_ & 32'h1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_464to465_bb1_ld__0_valid_out_NO_SHIFT_REG;
 logic rnode_464to465_bb1_ld__0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_464to465_bb1_ld__0_NO_SHIFT_REG;
 logic rnode_464to465_bb1_ld__0_reg_465_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_464to465_bb1_ld__0_reg_465_NO_SHIFT_REG;
 logic rnode_464to465_bb1_ld__0_valid_out_reg_465_NO_SHIFT_REG;
 logic rnode_464to465_bb1_ld__0_stall_in_reg_465_NO_SHIFT_REG;
 logic rnode_464to465_bb1_ld__0_stall_out_reg_465_NO_SHIFT_REG;

acl_data_fifo rnode_464to465_bb1_ld__0_reg_465_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_464to465_bb1_ld__0_reg_465_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_464to465_bb1_ld__0_stall_in_reg_465_NO_SHIFT_REG),
	.valid_out(rnode_464to465_bb1_ld__0_valid_out_reg_465_NO_SHIFT_REG),
	.stall_out(rnode_464to465_bb1_ld__0_stall_out_reg_465_NO_SHIFT_REG),
	.data_in(rnode_163to464_bb1_ld__0_NO_SHIFT_REG),
	.data_out(rnode_464to465_bb1_ld__0_reg_465_NO_SHIFT_REG)
);

defparam rnode_464to465_bb1_ld__0_reg_465_fifo.DEPTH = 2;
defparam rnode_464to465_bb1_ld__0_reg_465_fifo.DATA_WIDTH = 32;
defparam rnode_464to465_bb1_ld__0_reg_465_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_464to465_bb1_ld__0_reg_465_fifo.IMPL = "ll_reg";

assign rnode_464to465_bb1_ld__0_reg_465_inputs_ready_NO_SHIFT_REG = rnode_163to464_bb1_ld__0_valid_out_NO_SHIFT_REG;
assign rnode_163to464_bb1_ld__0_stall_in_NO_SHIFT_REG = rnode_464to465_bb1_ld__0_stall_out_reg_465_NO_SHIFT_REG;
assign rnode_464to465_bb1_ld__0_NO_SHIFT_REG = rnode_464to465_bb1_ld__0_reg_465_NO_SHIFT_REG;
assign rnode_464to465_bb1_ld__0_stall_in_reg_465_NO_SHIFT_REG = rnode_464to465_bb1_ld__0_stall_in_NO_SHIFT_REG;
assign rnode_464to465_bb1_ld__0_valid_out_NO_SHIFT_REG = rnode_464to465_bb1_ld__0_valid_out_reg_465_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1__toi1_intcast_valid_out;
wire local_bb1__toi1_intcast_stall_in;
wire local_bb1__toi1_intcast_inputs_ready;
wire local_bb1__toi1_intcast_stall_local;
wire local_bb1__toi1_intcast;

assign local_bb1__toi1_intcast_inputs_ready = rstag_163to163_bb1_ld__valid_out_1;
assign local_bb1__toi1_intcast = (local_bb1_var_ != 32'h0);
assign local_bb1__toi1_intcast_valid_out = local_bb1__toi1_intcast_inputs_ready;
assign local_bb1__toi1_intcast_stall_local = local_bb1__toi1_intcast_stall_in;
assign rstag_163to163_bb1_ld__stall_in_1 = (|local_bb1__toi1_intcast_stall_local);

// This section implements an unregistered operation.
// 
wire local_bb1_c0_eni1_stall_local;
wire [95:0] local_bb1_c0_eni1;

assign local_bb1_c0_eni1[31:0] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
assign local_bb1_c0_eni1[63:32] = rnode_464to465_bb1_ld__0_NO_SHIFT_REG;
assign local_bb1_c0_eni1[95:64] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;

// This section implements a registered operation.
// 
wire local_bb1_st_memcoalesce_edge_arr_extrValue_1_inputs_ready;
 reg local_bb1_st_memcoalesce_edge_arr_extrValue_1_valid_out_NO_SHIFT_REG;
wire local_bb1_st_memcoalesce_edge_arr_extrValue_1_stall_in;
wire local_bb1_st_memcoalesce_edge_arr_extrValue_1_output_regs_ready;
wire local_bb1_st_memcoalesce_edge_arr_extrValue_1_fu_stall_out;
wire local_bb1_st_memcoalesce_edge_arr_extrValue_1_fu_valid_out;
wire [31:0] local_bb1_st_memcoalesce_edge_arr_extrValue_1_lsu_wackout;
 reg local_bb1_st_memcoalesce_edge_arr_extrValue_1_NO_SHIFT_REG;
wire local_bb1_st_memcoalesce_edge_arr_extrValue_1_causedstall;

lsu_top lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1 (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(),
	.stream_size(),
	.stream_reset(),
	.o_stall(local_bb1_st_memcoalesce_edge_arr_extrValue_1_fu_stall_out),
	.i_valid(local_bb1_st_memcoalesce_edge_arr_extrValue_1_inputs_ready),
	.i_address(local_bb1_dest5),
	.i_writedata(rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_NO_SHIFT_REG),
	.i_cmpdata(),
	.i_predicate(1'b0),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb1_st_memcoalesce_edge_arr_extrValue_1_output_regs_ready)),
	.o_valid(local_bb1_st_memcoalesce_edge_arr_extrValue_1_fu_valid_out),
	.o_readdata(),
	.o_input_fifo_depth(),
	.o_writeack(local_bb1_st_memcoalesce_edge_arr_extrValue_1_lsu_wackout),
	.i_atomic_op(3'h0),
	.o_active(local_bb1_st_memcoalesce_edge_arr_extrValue_1_active),
	.avm_address(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_address),
	.avm_read(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_read),
	.avm_readdata(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_readdata),
	.avm_write(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_write),
	.avm_writeack(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_writeack),
	.avm_burstcount(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_burstcount),
	.avm_writedata(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_writedata),
	.avm_byteenable(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_byteenable),
	.avm_waitrequest(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_waitrequest),
	.avm_readdatavalid(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_readdatavalid),
	.profile_bw(),
	.profile_bw_incr(),
	.profile_total_ivalid(),
	.profile_total_req(),
	.profile_i_stall_count(),
	.profile_o_stall_count(),
	.profile_avm_readwrite_count(),
	.profile_avm_burstcount_total(),
	.profile_avm_burstcount_total_incr(),
	.profile_req_cache_hit_count(),
	.profile_extra_unaligned_reqs(),
	.profile_avm_stall()
);

defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.AWIDTH = 30;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.WIDTH_BYTES = 4;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.MWIDTH_BYTES = 32;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.ALIGNMENT_BYTES = 8;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.READ = 0;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.ATOMIC = 0;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.WIDTH = 32;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.MWIDTH = 256;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.ATOMIC_WIDTH = 3;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.KERNEL_SIDE_MEM_LATENCY = 142;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.MEMORY_SIDE_MEM_LATENCY = 14;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.USE_WRITE_ACK = 1;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.NUMBER_BANKS = 1;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.USEINPUTFIFO = 0;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.USECACHING = 0;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.USEOUTPUTFIFO = 1;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.HIGH_FMAX = 1;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.ADDRSPACE = 1;
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.STYLE = "BURST-COALESCED";
defparam lsu_local_bb1_st_memcoalesce_edge_arr_extrValue_1.USE_BYTE_EN = 0;

assign local_bb1_st_memcoalesce_edge_arr_extrValue_1_inputs_ready = (local_bb1_dest5_valid_out & local_bb1__toi1_intcast_valid_out & rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_valid_out_NO_SHIFT_REG);
assign local_bb1_st_memcoalesce_edge_arr_extrValue_1_output_regs_ready = (&(~(local_bb1_st_memcoalesce_edge_arr_extrValue_1_valid_out_NO_SHIFT_REG) | ~(local_bb1_st_memcoalesce_edge_arr_extrValue_1_stall_in)));
assign local_bb1_dest5_stall_in = (local_bb1_st_memcoalesce_edge_arr_extrValue_1_fu_stall_out | ~(local_bb1_st_memcoalesce_edge_arr_extrValue_1_inputs_ready));
assign local_bb1__toi1_intcast_stall_in = (local_bb1_st_memcoalesce_edge_arr_extrValue_1_fu_stall_out | ~(local_bb1_st_memcoalesce_edge_arr_extrValue_1_inputs_ready));
assign rnode_162to163_bb1_memcoalesce_edge_arr_extrValue_1_0_stall_in_NO_SHIFT_REG = (local_bb1_st_memcoalesce_edge_arr_extrValue_1_fu_stall_out | ~(local_bb1_st_memcoalesce_edge_arr_extrValue_1_inputs_ready));
assign local_bb1_st_memcoalesce_edge_arr_extrValue_1_causedstall = (local_bb1_st_memcoalesce_edge_arr_extrValue_1_inputs_ready && (local_bb1_st_memcoalesce_edge_arr_extrValue_1_fu_stall_out && !(~(local_bb1_st_memcoalesce_edge_arr_extrValue_1_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_st_memcoalesce_edge_arr_extrValue_1_NO_SHIFT_REG <= 'x;
		local_bb1_st_memcoalesce_edge_arr_extrValue_1_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_st_memcoalesce_edge_arr_extrValue_1_output_regs_ready)
		begin
			local_bb1_st_memcoalesce_edge_arr_extrValue_1_NO_SHIFT_REG <= local_bb1_st_memcoalesce_edge_arr_extrValue_1_lsu_wackout;
			local_bb1_st_memcoalesce_edge_arr_extrValue_1_valid_out_NO_SHIFT_REG <= local_bb1_st_memcoalesce_edge_arr_extrValue_1_fu_valid_out;
		end
		else
		begin
			if (~(local_bb1_st_memcoalesce_edge_arr_extrValue_1_stall_in))
			begin
				local_bb1_st_memcoalesce_edge_arr_extrValue_1_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements a staging register.
// 
wire rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_valid_out;
wire rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_stall_in;
wire rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_inputs_ready;
wire rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_stall_local;
 reg rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_staging_valid_NO_SHIFT_REG;
wire rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_combined_valid;
 reg rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_staging_reg_NO_SHIFT_REG;
wire rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1;

assign rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_inputs_ready = local_bb1_st_memcoalesce_edge_arr_extrValue_1_valid_out_NO_SHIFT_REG;
assign rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1 = (rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_staging_valid_NO_SHIFT_REG ? rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_staging_reg_NO_SHIFT_REG : local_bb1_st_memcoalesce_edge_arr_extrValue_1_NO_SHIFT_REG);
assign rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_combined_valid = (rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_staging_valid_NO_SHIFT_REG | rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_inputs_ready);
assign rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_valid_out = rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_combined_valid;
assign rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_stall_local = rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_stall_in;
assign local_bb1_st_memcoalesce_edge_arr_extrValue_1_stall_in = (|rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_stall_local)
		begin
			if (~(rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_staging_valid_NO_SHIFT_REG))
			begin
				rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_staging_valid_NO_SHIFT_REG <= rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_inputs_ready;
			end
		end
		else
		begin
			rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_staging_valid_NO_SHIFT_REG))
		begin
			rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_staging_reg_NO_SHIFT_REG <= local_bb1_st_memcoalesce_edge_arr_extrValue_1_NO_SHIFT_REG;
		end
	end
end


// This section implements a registered operation.
// 
wire local_bb1_ld__u0_inputs_ready;
 reg local_bb1_ld__u0_valid_out_NO_SHIFT_REG;
wire local_bb1_ld__u0_stall_in;
wire local_bb1_ld__u0_output_regs_ready;
wire local_bb1_ld__u0_fu_stall_out;
wire local_bb1_ld__u0_fu_valid_out;
wire [31:0] local_bb1_ld__u0_lsu_dataout;
 reg [31:0] local_bb1_ld__u0_NO_SHIFT_REG;
wire local_bb1_ld__u0_causedstall;

lsu_top lsu_local_bb1_ld__u0 (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(),
	.stream_size(),
	.stream_reset(),
	.o_stall(local_bb1_ld__u0_fu_stall_out),
	.i_valid(local_bb1_ld__u0_inputs_ready),
	.i_address(rnode_304to305_bb1_arrayidx8_0_NO_SHIFT_REG),
	.i_writedata(),
	.i_cmpdata(),
	.i_predicate(1'b0),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb1_ld__u0_output_regs_ready)),
	.o_valid(local_bb1_ld__u0_fu_valid_out),
	.o_readdata(local_bb1_ld__u0_lsu_dataout),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb1_ld__u0_active),
	.avm_address(avm_local_bb1_ld__u0_address),
	.avm_read(avm_local_bb1_ld__u0_read),
	.avm_readdata(avm_local_bb1_ld__u0_readdata),
	.avm_write(avm_local_bb1_ld__u0_write),
	.avm_writeack(avm_local_bb1_ld__u0_writeack),
	.avm_burstcount(avm_local_bb1_ld__u0_burstcount),
	.avm_writedata(avm_local_bb1_ld__u0_writedata),
	.avm_byteenable(avm_local_bb1_ld__u0_byteenable),
	.avm_waitrequest(avm_local_bb1_ld__u0_waitrequest),
	.avm_readdatavalid(avm_local_bb1_ld__u0_readdatavalid),
	.profile_bw(),
	.profile_bw_incr(),
	.profile_total_ivalid(),
	.profile_total_req(),
	.profile_i_stall_count(),
	.profile_o_stall_count(),
	.profile_avm_readwrite_count(),
	.profile_avm_burstcount_total(),
	.profile_avm_burstcount_total_incr(),
	.profile_req_cache_hit_count(),
	.profile_extra_unaligned_reqs(),
	.profile_avm_stall()
);

defparam lsu_local_bb1_ld__u0.AWIDTH = 30;
defparam lsu_local_bb1_ld__u0.WIDTH_BYTES = 4;
defparam lsu_local_bb1_ld__u0.MWIDTH_BYTES = 32;
defparam lsu_local_bb1_ld__u0.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb1_ld__u0.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb1_ld__u0.READ = 1;
defparam lsu_local_bb1_ld__u0.ATOMIC = 0;
defparam lsu_local_bb1_ld__u0.WIDTH = 32;
defparam lsu_local_bb1_ld__u0.MWIDTH = 256;
defparam lsu_local_bb1_ld__u0.ATOMIC_WIDTH = 3;
defparam lsu_local_bb1_ld__u0.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb1_ld__u0.KERNEL_SIDE_MEM_LATENCY = 160;
defparam lsu_local_bb1_ld__u0.MEMORY_SIDE_MEM_LATENCY = 58;
defparam lsu_local_bb1_ld__u0.USE_WRITE_ACK = 0;
defparam lsu_local_bb1_ld__u0.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb1_ld__u0.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb1_ld__u0.NUMBER_BANKS = 1;
defparam lsu_local_bb1_ld__u0.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb1_ld__u0.USEINPUTFIFO = 0;
defparam lsu_local_bb1_ld__u0.USECACHING = 0;
defparam lsu_local_bb1_ld__u0.USEOUTPUTFIFO = 1;
defparam lsu_local_bb1_ld__u0.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb1_ld__u0.HIGH_FMAX = 1;
defparam lsu_local_bb1_ld__u0.ADDRSPACE = 1;
defparam lsu_local_bb1_ld__u0.STYLE = "BURST-COALESCED";

assign local_bb1_ld__u0_inputs_ready = (rnode_304to305_bb1_arrayidx8_0_valid_out_NO_SHIFT_REG & rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_valid_out);
assign local_bb1_ld__u0_output_regs_ready = (&(~(local_bb1_ld__u0_valid_out_NO_SHIFT_REG) | ~(local_bb1_ld__u0_stall_in)));
assign rnode_304to305_bb1_arrayidx8_0_stall_in_NO_SHIFT_REG = (local_bb1_ld__u0_fu_stall_out | ~(local_bb1_ld__u0_inputs_ready));
assign rstag_305to305_bb1_st_memcoalesce_edge_arr_extrValue_1_stall_in = (local_bb1_ld__u0_fu_stall_out | ~(local_bb1_ld__u0_inputs_ready));
assign local_bb1_ld__u0_causedstall = (local_bb1_ld__u0_inputs_ready && (local_bb1_ld__u0_fu_stall_out && !(~(local_bb1_ld__u0_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_ld__u0_NO_SHIFT_REG <= 'x;
		local_bb1_ld__u0_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_ld__u0_output_regs_ready)
		begin
			local_bb1_ld__u0_NO_SHIFT_REG <= local_bb1_ld__u0_lsu_dataout;
			local_bb1_ld__u0_valid_out_NO_SHIFT_REG <= local_bb1_ld__u0_fu_valid_out;
		end
		else
		begin
			if (~(local_bb1_ld__u0_stall_in))
			begin
				local_bb1_ld__u0_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements a staging register.
// 
wire rstag_465to465_bb1_ld__u0_valid_out;
wire rstag_465to465_bb1_ld__u0_stall_in;
wire rstag_465to465_bb1_ld__u0_inputs_ready;
wire rstag_465to465_bb1_ld__u0_stall_local;
 reg rstag_465to465_bb1_ld__u0_staging_valid_NO_SHIFT_REG;
wire rstag_465to465_bb1_ld__u0_combined_valid;
 reg [31:0] rstag_465to465_bb1_ld__u0_staging_reg_NO_SHIFT_REG;
wire [31:0] rstag_465to465_bb1_ld__u0;

assign rstag_465to465_bb1_ld__u0_inputs_ready = local_bb1_ld__u0_valid_out_NO_SHIFT_REG;
assign rstag_465to465_bb1_ld__u0 = (rstag_465to465_bb1_ld__u0_staging_valid_NO_SHIFT_REG ? rstag_465to465_bb1_ld__u0_staging_reg_NO_SHIFT_REG : local_bb1_ld__u0_NO_SHIFT_REG);
assign rstag_465to465_bb1_ld__u0_combined_valid = (rstag_465to465_bb1_ld__u0_staging_valid_NO_SHIFT_REG | rstag_465to465_bb1_ld__u0_inputs_ready);
assign rstag_465to465_bb1_ld__u0_valid_out = rstag_465to465_bb1_ld__u0_combined_valid;
assign rstag_465to465_bb1_ld__u0_stall_local = rstag_465to465_bb1_ld__u0_stall_in;
assign local_bb1_ld__u0_stall_in = (|rstag_465to465_bb1_ld__u0_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_465to465_bb1_ld__u0_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_465to465_bb1_ld__u0_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_465to465_bb1_ld__u0_stall_local)
		begin
			if (~(rstag_465to465_bb1_ld__u0_staging_valid_NO_SHIFT_REG))
			begin
				rstag_465to465_bb1_ld__u0_staging_valid_NO_SHIFT_REG <= rstag_465to465_bb1_ld__u0_inputs_ready;
			end
		end
		else
		begin
			rstag_465to465_bb1_ld__u0_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_465to465_bb1_ld__u0_staging_valid_NO_SHIFT_REG))
		begin
			rstag_465to465_bb1_ld__u0_staging_reg_NO_SHIFT_REG <= local_bb1_ld__u0_NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c0_eni2_valid_out;
wire local_bb1_c0_eni2_stall_in;
wire local_bb1_c0_eni2_inputs_ready;
wire local_bb1_c0_eni2_stall_local;
wire [95:0] local_bb1_c0_eni2;

assign local_bb1_c0_eni2_inputs_ready = (rstag_465to465_bb1_ld__u0_valid_out & rnode_464to465_bb1_ld__0_valid_out_NO_SHIFT_REG);
assign local_bb1_c0_eni2[63:0] = local_bb1_c0_eni1[63:0];
assign local_bb1_c0_eni2[95:64] = rstag_465to465_bb1_ld__u0;
assign local_bb1_c0_eni2_valid_out = local_bb1_c0_eni2_inputs_ready;
assign local_bb1_c0_eni2_stall_local = local_bb1_c0_eni2_stall_in;
assign rstag_465to465_bb1_ld__u0_stall_in = (local_bb1_c0_eni2_stall_local | ~(local_bb1_c0_eni2_inputs_ready));
assign rnode_464to465_bb1_ld__0_stall_in_NO_SHIFT_REG = (local_bb1_c0_eni2_stall_local | ~(local_bb1_c0_eni2_inputs_ready));

// This section implements a registered operation.
// 
wire local_bb1_c0_enter_c0_eni2_inputs_ready;
 reg local_bb1_c0_enter_c0_eni2_valid_out_0_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni2_stall_in_0;
 reg local_bb1_c0_enter_c0_eni2_valid_out_1_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni2_stall_in_1;
wire local_bb1_c0_enter_c0_eni2_output_regs_ready;
 reg [95:0] local_bb1_c0_enter_c0_eni2_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni2_input_accepted;
wire local_bb1_c0_exit_c0_exi1_entry_stall;
wire local_bb1_c0_exit_c0_exi1_output_regs_ready;
wire [21:0] local_bb1_c0_exit_c0_exi1_valid_bits;
wire local_bb1_c0_exit_c0_exi1_phases;
wire local_bb1_c0_enter_c0_eni2_inc_pipelined_thread;
wire local_bb1_c0_enter_c0_eni2_dec_pipelined_thread;
wire local_bb1_c0_enter_c0_eni2_causedstall;

assign local_bb1_c0_enter_c0_eni2_inputs_ready = local_bb1_c0_eni2_valid_out;
assign local_bb1_c0_enter_c0_eni2_output_regs_ready = 1'b1;
assign local_bb1_c0_enter_c0_eni2_input_accepted = (local_bb1_c0_enter_c0_eni2_inputs_ready && !(local_bb1_c0_exit_c0_exi1_entry_stall));
assign local_bb1_c0_enter_c0_eni2_inc_pipelined_thread = 1'b1;
assign local_bb1_c0_enter_c0_eni2_dec_pipelined_thread = ~(1'b0);
assign local_bb1_c0_eni2_stall_in = ((~(local_bb1_c0_enter_c0_eni2_inputs_ready) | local_bb1_c0_exit_c0_exi1_entry_stall) | ~(1'b1));
assign local_bb1_c0_enter_c0_eni2_causedstall = (1'b1 && ((~(local_bb1_c0_enter_c0_eni2_inputs_ready) | local_bb1_c0_exit_c0_exi1_entry_stall) && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c0_enter_c0_eni2_NO_SHIFT_REG <= 'x;
		local_bb1_c0_enter_c0_eni2_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_c0_enter_c0_eni2_valid_out_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_c0_enter_c0_eni2_output_regs_ready)
		begin
			local_bb1_c0_enter_c0_eni2_NO_SHIFT_REG <= local_bb1_c0_eni2;
			local_bb1_c0_enter_c0_eni2_valid_out_0_NO_SHIFT_REG <= 1'b1;
			local_bb1_c0_enter_c0_eni2_valid_out_1_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb1_c0_enter_c0_eni2_stall_in_0))
			begin
				local_bb1_c0_enter_c0_eni2_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c0_enter_c0_eni2_stall_in_1))
			begin
				local_bb1_c0_enter_c0_eni2_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c0_ene1_valid_out;
wire local_bb1_c0_ene1_stall_in;
wire local_bb1_c0_ene1_inputs_ready;
wire local_bb1_c0_ene1_stall_local;
wire [31:0] local_bb1_c0_ene1;

assign local_bb1_c0_ene1_inputs_ready = local_bb1_c0_enter_c0_eni2_valid_out_0_NO_SHIFT_REG;
assign local_bb1_c0_ene1 = local_bb1_c0_enter_c0_eni2_NO_SHIFT_REG[63:32];
assign local_bb1_c0_ene1_valid_out = 1'b1;
assign local_bb1_c0_enter_c0_eni2_stall_in_0 = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_c0_ene2_valid_out;
wire local_bb1_c0_ene2_stall_in;
wire local_bb1_c0_ene2_inputs_ready;
wire local_bb1_c0_ene2_stall_local;
wire [31:0] local_bb1_c0_ene2;

assign local_bb1_c0_ene2_inputs_ready = local_bb1_c0_enter_c0_eni2_valid_out_1_NO_SHIFT_REG;
assign local_bb1_c0_ene2 = local_bb1_c0_enter_c0_eni2_NO_SHIFT_REG[95:64];
assign local_bb1_c0_ene2_valid_out = 1'b1;
assign local_bb1_c0_enter_c0_eni2_stall_in_1 = 1'b0;

// This section implements a registered operation.
// 
wire local_bb1_conv9_inputs_ready;
 reg local_bb1_conv9_valid_out_NO_SHIFT_REG;
wire local_bb1_conv9_stall_in;
wire local_bb1_conv9_output_regs_ready;
wire [31:0] local_bb1_conv9;
 reg local_bb1_conv9_valid_pipe_0_NO_SHIFT_REG;
 reg local_bb1_conv9_valid_pipe_1_NO_SHIFT_REG;
 reg local_bb1_conv9_valid_pipe_2_NO_SHIFT_REG;
 reg local_bb1_conv9_valid_pipe_3_NO_SHIFT_REG;
 reg local_bb1_conv9_valid_pipe_4_NO_SHIFT_REG;
wire local_bb1_conv9_causedstall;

acl_fp_uitofp fp_module_local_bb1_conv9 (
	.clock(clock),
	.dataa(local_bb1_c0_ene1),
	.enable(local_bb1_conv9_output_regs_ready),
	.result(local_bb1_conv9)
);


assign local_bb1_conv9_inputs_ready = 1'b1;
assign local_bb1_conv9_output_regs_ready = 1'b1;
assign local_bb1_c0_ene1_stall_in = 1'b0;
assign local_bb1_conv9_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_conv9_valid_pipe_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_conv9_valid_pipe_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_conv9_valid_pipe_2_NO_SHIFT_REG <= 1'b0;
		local_bb1_conv9_valid_pipe_3_NO_SHIFT_REG <= 1'b0;
		local_bb1_conv9_valid_pipe_4_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_conv9_output_regs_ready)
		begin
			local_bb1_conv9_valid_pipe_0_NO_SHIFT_REG <= 1'b1;
			local_bb1_conv9_valid_pipe_1_NO_SHIFT_REG <= local_bb1_conv9_valid_pipe_0_NO_SHIFT_REG;
			local_bb1_conv9_valid_pipe_2_NO_SHIFT_REG <= local_bb1_conv9_valid_pipe_1_NO_SHIFT_REG;
			local_bb1_conv9_valid_pipe_3_NO_SHIFT_REG <= local_bb1_conv9_valid_pipe_2_NO_SHIFT_REG;
			local_bb1_conv9_valid_pipe_4_NO_SHIFT_REG <= local_bb1_conv9_valid_pipe_3_NO_SHIFT_REG;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_conv9_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_conv9_output_regs_ready)
		begin
			local_bb1_conv9_valid_out_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb1_conv9_stall_in))
			begin
				local_bb1_conv9_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_466to467_bb1_c0_ene2_0_valid_out_NO_SHIFT_REG;
 logic rnode_466to467_bb1_c0_ene2_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_466to467_bb1_c0_ene2_0_NO_SHIFT_REG;
 logic rnode_466to467_bb1_c0_ene2_0_reg_467_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_466to467_bb1_c0_ene2_0_reg_467_NO_SHIFT_REG;
 logic rnode_466to467_bb1_c0_ene2_0_valid_out_reg_467_NO_SHIFT_REG;
 logic rnode_466to467_bb1_c0_ene2_0_stall_in_reg_467_NO_SHIFT_REG;
 logic rnode_466to467_bb1_c0_ene2_0_stall_out_reg_467_NO_SHIFT_REG;

acl_data_fifo rnode_466to467_bb1_c0_ene2_0_reg_467_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_466to467_bb1_c0_ene2_0_reg_467_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_466to467_bb1_c0_ene2_0_stall_in_reg_467_NO_SHIFT_REG),
	.valid_out(rnode_466to467_bb1_c0_ene2_0_valid_out_reg_467_NO_SHIFT_REG),
	.stall_out(rnode_466to467_bb1_c0_ene2_0_stall_out_reg_467_NO_SHIFT_REG),
	.data_in(local_bb1_c0_ene2),
	.data_out(rnode_466to467_bb1_c0_ene2_0_reg_467_NO_SHIFT_REG)
);

defparam rnode_466to467_bb1_c0_ene2_0_reg_467_fifo.DEPTH = 1;
defparam rnode_466to467_bb1_c0_ene2_0_reg_467_fifo.DATA_WIDTH = 32;
defparam rnode_466to467_bb1_c0_ene2_0_reg_467_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_466to467_bb1_c0_ene2_0_reg_467_fifo.IMPL = "shift_reg";

assign rnode_466to467_bb1_c0_ene2_0_reg_467_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_c0_ene2_stall_in = 1'b0;
assign rnode_466to467_bb1_c0_ene2_0_NO_SHIFT_REG = rnode_466to467_bb1_c0_ene2_0_reg_467_NO_SHIFT_REG;
assign rnode_466to467_bb1_c0_ene2_0_stall_in_reg_467_NO_SHIFT_REG = 1'b0;
assign rnode_466to467_bb1_c0_ene2_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 4
//  * capacity = 4
 logic rnode_467to471_bb1_c0_ene2_0_valid_out_NO_SHIFT_REG;
 logic rnode_467to471_bb1_c0_ene2_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_467to471_bb1_c0_ene2_0_NO_SHIFT_REG;
 logic rnode_467to471_bb1_c0_ene2_0_reg_471_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_467to471_bb1_c0_ene2_0_reg_471_NO_SHIFT_REG;
 logic rnode_467to471_bb1_c0_ene2_0_valid_out_reg_471_NO_SHIFT_REG;
 logic rnode_467to471_bb1_c0_ene2_0_stall_in_reg_471_NO_SHIFT_REG;
 logic rnode_467to471_bb1_c0_ene2_0_stall_out_reg_471_NO_SHIFT_REG;

acl_data_fifo rnode_467to471_bb1_c0_ene2_0_reg_471_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_467to471_bb1_c0_ene2_0_reg_471_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_467to471_bb1_c0_ene2_0_stall_in_reg_471_NO_SHIFT_REG),
	.valid_out(rnode_467to471_bb1_c0_ene2_0_valid_out_reg_471_NO_SHIFT_REG),
	.stall_out(rnode_467to471_bb1_c0_ene2_0_stall_out_reg_471_NO_SHIFT_REG),
	.data_in(rnode_466to467_bb1_c0_ene2_0_NO_SHIFT_REG),
	.data_out(rnode_467to471_bb1_c0_ene2_0_reg_471_NO_SHIFT_REG)
);

defparam rnode_467to471_bb1_c0_ene2_0_reg_471_fifo.DEPTH = 4;
defparam rnode_467to471_bb1_c0_ene2_0_reg_471_fifo.DATA_WIDTH = 32;
defparam rnode_467to471_bb1_c0_ene2_0_reg_471_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_467to471_bb1_c0_ene2_0_reg_471_fifo.IMPL = "shift_reg";

assign rnode_467to471_bb1_c0_ene2_0_reg_471_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_466to467_bb1_c0_ene2_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_467to471_bb1_c0_ene2_0_NO_SHIFT_REG = rnode_467to471_bb1_c0_ene2_0_reg_471_NO_SHIFT_REG;
assign rnode_467to471_bb1_c0_ene2_0_stall_in_reg_471_NO_SHIFT_REG = 1'b0;
assign rnode_467to471_bb1_c0_ene2_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_471to472_bb1_c0_ene2_0_valid_out_NO_SHIFT_REG;
 logic rnode_471to472_bb1_c0_ene2_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_471to472_bb1_c0_ene2_0_NO_SHIFT_REG;
 logic rnode_471to472_bb1_c0_ene2_0_reg_472_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_471to472_bb1_c0_ene2_0_reg_472_NO_SHIFT_REG;
 logic rnode_471to472_bb1_c0_ene2_0_valid_out_reg_472_NO_SHIFT_REG;
 logic rnode_471to472_bb1_c0_ene2_0_stall_in_reg_472_NO_SHIFT_REG;
 logic rnode_471to472_bb1_c0_ene2_0_stall_out_reg_472_NO_SHIFT_REG;

acl_data_fifo rnode_471to472_bb1_c0_ene2_0_reg_472_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_471to472_bb1_c0_ene2_0_reg_472_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_471to472_bb1_c0_ene2_0_stall_in_reg_472_NO_SHIFT_REG),
	.valid_out(rnode_471to472_bb1_c0_ene2_0_valid_out_reg_472_NO_SHIFT_REG),
	.stall_out(rnode_471to472_bb1_c0_ene2_0_stall_out_reg_472_NO_SHIFT_REG),
	.data_in(rnode_467to471_bb1_c0_ene2_0_NO_SHIFT_REG),
	.data_out(rnode_471to472_bb1_c0_ene2_0_reg_472_NO_SHIFT_REG)
);

defparam rnode_471to472_bb1_c0_ene2_0_reg_472_fifo.DEPTH = 1;
defparam rnode_471to472_bb1_c0_ene2_0_reg_472_fifo.DATA_WIDTH = 32;
defparam rnode_471to472_bb1_c0_ene2_0_reg_472_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_471to472_bb1_c0_ene2_0_reg_472_fifo.IMPL = "shift_reg";

assign rnode_471to472_bb1_c0_ene2_0_reg_472_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_467to471_bb1_c0_ene2_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_471to472_bb1_c0_ene2_0_NO_SHIFT_REG = rnode_471to472_bb1_c0_ene2_0_reg_472_NO_SHIFT_REG;
assign rnode_471to472_bb1_c0_ene2_0_stall_in_reg_472_NO_SHIFT_REG = 1'b0;
assign rnode_471to472_bb1_c0_ene2_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements a registered operation.
// 
wire local_bb1_div_inputs_ready;
 reg local_bb1_div_valid_out_NO_SHIFT_REG;
wire local_bb1_div_stall_in;
wire local_bb1_div_output_regs_ready;
wire [31:0] local_bb1_div;
 reg local_bb1_div_valid_pipe_0_NO_SHIFT_REG;
 reg local_bb1_div_valid_pipe_1_NO_SHIFT_REG;
 reg local_bb1_div_valid_pipe_2_NO_SHIFT_REG;
 reg local_bb1_div_valid_pipe_3_NO_SHIFT_REG;
 reg local_bb1_div_valid_pipe_4_NO_SHIFT_REG;
 reg local_bb1_div_valid_pipe_5_NO_SHIFT_REG;
 reg local_bb1_div_valid_pipe_6_NO_SHIFT_REG;
 reg local_bb1_div_valid_pipe_7_NO_SHIFT_REG;
 reg local_bb1_div_valid_pipe_8_NO_SHIFT_REG;
 reg local_bb1_div_valid_pipe_9_NO_SHIFT_REG;
 reg local_bb1_div_valid_pipe_10_NO_SHIFT_REG;
 reg local_bb1_div_valid_pipe_11_NO_SHIFT_REG;
 reg local_bb1_div_valid_pipe_12_NO_SHIFT_REG;
wire local_bb1_div_causedstall;

acl_fp_div_s5 fp_module_local_bb1_div (
	.clock(clock),
	.dataa(rnode_471to472_bb1_c0_ene2_0_NO_SHIFT_REG),
	.datab(local_bb1_conv9),
	.enable(local_bb1_div_output_regs_ready),
	.result(local_bb1_div)
);


assign local_bb1_div_inputs_ready = 1'b1;
assign local_bb1_div_output_regs_ready = 1'b1;
assign local_bb1_conv9_stall_in = 1'b0;
assign rnode_471to472_bb1_c0_ene2_0_stall_in_NO_SHIFT_REG = 1'b0;
assign local_bb1_div_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_div_valid_pipe_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_div_valid_pipe_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_div_valid_pipe_2_NO_SHIFT_REG <= 1'b0;
		local_bb1_div_valid_pipe_3_NO_SHIFT_REG <= 1'b0;
		local_bb1_div_valid_pipe_4_NO_SHIFT_REG <= 1'b0;
		local_bb1_div_valid_pipe_5_NO_SHIFT_REG <= 1'b0;
		local_bb1_div_valid_pipe_6_NO_SHIFT_REG <= 1'b0;
		local_bb1_div_valid_pipe_7_NO_SHIFT_REG <= 1'b0;
		local_bb1_div_valid_pipe_8_NO_SHIFT_REG <= 1'b0;
		local_bb1_div_valid_pipe_9_NO_SHIFT_REG <= 1'b0;
		local_bb1_div_valid_pipe_10_NO_SHIFT_REG <= 1'b0;
		local_bb1_div_valid_pipe_11_NO_SHIFT_REG <= 1'b0;
		local_bb1_div_valid_pipe_12_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_div_output_regs_ready)
		begin
			local_bb1_div_valid_pipe_0_NO_SHIFT_REG <= 1'b1;
			local_bb1_div_valid_pipe_1_NO_SHIFT_REG <= local_bb1_div_valid_pipe_0_NO_SHIFT_REG;
			local_bb1_div_valid_pipe_2_NO_SHIFT_REG <= local_bb1_div_valid_pipe_1_NO_SHIFT_REG;
			local_bb1_div_valid_pipe_3_NO_SHIFT_REG <= local_bb1_div_valid_pipe_2_NO_SHIFT_REG;
			local_bb1_div_valid_pipe_4_NO_SHIFT_REG <= local_bb1_div_valid_pipe_3_NO_SHIFT_REG;
			local_bb1_div_valid_pipe_5_NO_SHIFT_REG <= local_bb1_div_valid_pipe_4_NO_SHIFT_REG;
			local_bb1_div_valid_pipe_6_NO_SHIFT_REG <= local_bb1_div_valid_pipe_5_NO_SHIFT_REG;
			local_bb1_div_valid_pipe_7_NO_SHIFT_REG <= local_bb1_div_valid_pipe_6_NO_SHIFT_REG;
			local_bb1_div_valid_pipe_8_NO_SHIFT_REG <= local_bb1_div_valid_pipe_7_NO_SHIFT_REG;
			local_bb1_div_valid_pipe_9_NO_SHIFT_REG <= local_bb1_div_valid_pipe_8_NO_SHIFT_REG;
			local_bb1_div_valid_pipe_10_NO_SHIFT_REG <= local_bb1_div_valid_pipe_9_NO_SHIFT_REG;
			local_bb1_div_valid_pipe_11_NO_SHIFT_REG <= local_bb1_div_valid_pipe_10_NO_SHIFT_REG;
			local_bb1_div_valid_pipe_12_NO_SHIFT_REG <= local_bb1_div_valid_pipe_11_NO_SHIFT_REG;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_div_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_div_output_regs_ready)
		begin
			local_bb1_div_valid_out_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb1_div_stall_in))
			begin
				local_bb1_div_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c0_exi1_valid_out;
wire local_bb1_c0_exi1_stall_in;
wire local_bb1_c0_exi1_inputs_ready;
wire local_bb1_c0_exi1_stall_local;
wire [63:0] local_bb1_c0_exi1;

assign local_bb1_c0_exi1_inputs_ready = local_bb1_div_valid_out_NO_SHIFT_REG;
assign local_bb1_c0_exi1[31:0] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
assign local_bb1_c0_exi1[63:32] = local_bb1_div;
assign local_bb1_c0_exi1_valid_out = 1'b1;
assign local_bb1_div_stall_in = 1'b0;

// This section implements a registered operation.
// 
wire local_bb1_c0_exit_c0_exi1_inputs_ready;
 reg local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG;
wire local_bb1_c0_exit_c0_exi1_stall_in;
 reg [63:0] local_bb1_c0_exit_c0_exi1_NO_SHIFT_REG;
wire [63:0] local_bb1_c0_exit_c0_exi1_in;
wire local_bb1_c0_exit_c0_exi1_valid;
wire local_bb1_c0_exit_c0_exi1_causedstall;

acl_stall_free_sink local_bb1_c0_exit_c0_exi1_instance (
	.clock(clock),
	.resetn(resetn),
	.data_in(local_bb1_c0_exi1),
	.data_out(local_bb1_c0_exit_c0_exi1_in),
	.input_accepted(local_bb1_c0_enter_c0_eni2_input_accepted),
	.valid_out(local_bb1_c0_exit_c0_exi1_valid),
	.stall_in(~(local_bb1_c0_exit_c0_exi1_output_regs_ready)),
	.stall_entry(local_bb1_c0_exit_c0_exi1_entry_stall),
	.valids(local_bb1_c0_exit_c0_exi1_valid_bits),
	.IIphases(local_bb1_c0_exit_c0_exi1_phases),
	.inc_pipelined_thread(local_bb1_c0_enter_c0_eni2_inc_pipelined_thread),
	.dec_pipelined_thread(local_bb1_c0_enter_c0_eni2_dec_pipelined_thread)
);

defparam local_bb1_c0_exit_c0_exi1_instance.DATA_WIDTH = 64;
defparam local_bb1_c0_exit_c0_exi1_instance.PIPELINE_DEPTH = 26;
defparam local_bb1_c0_exit_c0_exi1_instance.SHARINGII = 1;
defparam local_bb1_c0_exit_c0_exi1_instance.SCHEDULEII = 1;

assign local_bb1_c0_exit_c0_exi1_inputs_ready = 1'b1;
assign local_bb1_c0_exit_c0_exi1_output_regs_ready = (&(~(local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG) | ~(local_bb1_c0_exit_c0_exi1_stall_in)));
assign local_bb1_c0_exi1_stall_in = 1'b0;
assign local_bb1_c0_exit_c0_exi1_causedstall = (1'b1 && (1'b0 && !(~(local_bb1_c0_exit_c0_exi1_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c0_exit_c0_exi1_NO_SHIFT_REG <= 'x;
		local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_c0_exit_c0_exi1_output_regs_ready)
		begin
			local_bb1_c0_exit_c0_exi1_NO_SHIFT_REG <= local_bb1_c0_exit_c0_exi1_in;
			local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG <= local_bb1_c0_exit_c0_exi1_valid;
		end
		else
		begin
			if (~(local_bb1_c0_exit_c0_exi1_stall_in))
			begin
				local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c0_exe1_valid_out;
wire local_bb1_c0_exe1_stall_in;
wire local_bb1_c0_exe1_inputs_ready;
wire local_bb1_c0_exe1_stall_local;
wire [31:0] local_bb1_c0_exe1;

assign local_bb1_c0_exe1_inputs_ready = local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG;
assign local_bb1_c0_exe1 = local_bb1_c0_exit_c0_exi1_NO_SHIFT_REG[63:32];
assign local_bb1_c0_exe1_valid_out = local_bb1_c0_exe1_inputs_ready;
assign local_bb1_c0_exe1_stall_local = local_bb1_c0_exe1_stall_in;
assign local_bb1_c0_exit_c0_exi1_stall_in = (|local_bb1_c0_exe1_stall_local);

// This section implements a registered operation.
// 
wire local_bb1_st_c0_exe1_inputs_ready;
 reg local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG;
wire local_bb1_st_c0_exe1_stall_in;
wire local_bb1_st_c0_exe1_output_regs_ready;
wire local_bb1_st_c0_exe1_fu_stall_out;
wire local_bb1_st_c0_exe1_fu_valid_out;
wire local_bb1_st_c0_exe1_causedstall;

lsu_top lsu_local_bb1_st_c0_exe1 (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(),
	.stream_size(),
	.stream_reset(),
	.o_stall(local_bb1_st_c0_exe1_fu_stall_out),
	.i_valid(local_bb1_st_c0_exe1_inputs_ready),
	.i_address(local_bb1_val),
	.i_writedata(local_bb1_c0_exe1),
	.i_cmpdata(),
	.i_predicate(1'b0),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb1_st_c0_exe1_output_regs_ready)),
	.o_valid(local_bb1_st_c0_exe1_fu_valid_out),
	.o_readdata(),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb1_st_c0_exe1_active),
	.avm_address(avm_local_bb1_st_c0_exe1_address),
	.avm_read(avm_local_bb1_st_c0_exe1_read),
	.avm_readdata(avm_local_bb1_st_c0_exe1_readdata),
	.avm_write(avm_local_bb1_st_c0_exe1_write),
	.avm_writeack(avm_local_bb1_st_c0_exe1_writeack),
	.avm_burstcount(avm_local_bb1_st_c0_exe1_burstcount),
	.avm_writedata(avm_local_bb1_st_c0_exe1_writedata),
	.avm_byteenable(avm_local_bb1_st_c0_exe1_byteenable),
	.avm_waitrequest(avm_local_bb1_st_c0_exe1_waitrequest),
	.avm_readdatavalid(avm_local_bb1_st_c0_exe1_readdatavalid),
	.profile_bw(),
	.profile_bw_incr(),
	.profile_total_ivalid(),
	.profile_total_req(),
	.profile_i_stall_count(),
	.profile_o_stall_count(),
	.profile_avm_readwrite_count(),
	.profile_avm_burstcount_total(),
	.profile_avm_burstcount_total_incr(),
	.profile_req_cache_hit_count(),
	.profile_extra_unaligned_reqs(),
	.profile_avm_stall()
);

defparam lsu_local_bb1_st_c0_exe1.AWIDTH = 30;
defparam lsu_local_bb1_st_c0_exe1.WIDTH_BYTES = 4;
defparam lsu_local_bb1_st_c0_exe1.MWIDTH_BYTES = 32;
defparam lsu_local_bb1_st_c0_exe1.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb1_st_c0_exe1.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb1_st_c0_exe1.READ = 0;
defparam lsu_local_bb1_st_c0_exe1.ATOMIC = 0;
defparam lsu_local_bb1_st_c0_exe1.WIDTH = 32;
defparam lsu_local_bb1_st_c0_exe1.MWIDTH = 256;
defparam lsu_local_bb1_st_c0_exe1.ATOMIC_WIDTH = 3;
defparam lsu_local_bb1_st_c0_exe1.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb1_st_c0_exe1.KERNEL_SIDE_MEM_LATENCY = 4;
defparam lsu_local_bb1_st_c0_exe1.MEMORY_SIDE_MEM_LATENCY = 14;
defparam lsu_local_bb1_st_c0_exe1.USE_WRITE_ACK = 0;
defparam lsu_local_bb1_st_c0_exe1.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb1_st_c0_exe1.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb1_st_c0_exe1.NUMBER_BANKS = 1;
defparam lsu_local_bb1_st_c0_exe1.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb1_st_c0_exe1.USEINPUTFIFO = 0;
defparam lsu_local_bb1_st_c0_exe1.USECACHING = 0;
defparam lsu_local_bb1_st_c0_exe1.USEOUTPUTFIFO = 1;
defparam lsu_local_bb1_st_c0_exe1.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb1_st_c0_exe1.HIGH_FMAX = 1;
defparam lsu_local_bb1_st_c0_exe1.ADDRSPACE = 1;
defparam lsu_local_bb1_st_c0_exe1.STYLE = "BURST-COALESCED";
defparam lsu_local_bb1_st_c0_exe1.USE_BYTE_EN = 0;

assign local_bb1_st_c0_exe1_inputs_ready = (local_bb1_c0_exe1_valid_out & local_bb1_val_valid_out);
assign local_bb1_st_c0_exe1_output_regs_ready = (&(~(local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG) | ~(local_bb1_st_c0_exe1_stall_in)));
assign local_bb1_c0_exe1_stall_in = (local_bb1_st_c0_exe1_fu_stall_out | ~(local_bb1_st_c0_exe1_inputs_ready));
assign local_bb1_val_stall_in = (local_bb1_st_c0_exe1_fu_stall_out | ~(local_bb1_st_c0_exe1_inputs_ready));
assign local_bb1_st_c0_exe1_causedstall = (local_bb1_st_c0_exe1_inputs_ready && (local_bb1_st_c0_exe1_fu_stall_out && !(~(local_bb1_st_c0_exe1_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_st_c0_exe1_output_regs_ready)
		begin
			local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG <= local_bb1_st_c0_exe1_fu_valid_out;
		end
		else
		begin
			if (~(local_bb1_st_c0_exe1_stall_in))
			begin
				local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements a staging register.
// 
wire rstag_495to495_bb1_st_c0_exe1_valid_out;
wire rstag_495to495_bb1_st_c0_exe1_stall_in;
wire rstag_495to495_bb1_st_c0_exe1_inputs_ready;
wire rstag_495to495_bb1_st_c0_exe1_stall_local;
 reg rstag_495to495_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG;
wire rstag_495to495_bb1_st_c0_exe1_combined_valid;

assign rstag_495to495_bb1_st_c0_exe1_inputs_ready = local_bb1_st_c0_exe1_valid_out_NO_SHIFT_REG;
assign rstag_495to495_bb1_st_c0_exe1_combined_valid = (rstag_495to495_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG | rstag_495to495_bb1_st_c0_exe1_inputs_ready);
assign rstag_495to495_bb1_st_c0_exe1_valid_out = rstag_495to495_bb1_st_c0_exe1_combined_valid;
assign rstag_495to495_bb1_st_c0_exe1_stall_local = rstag_495to495_bb1_st_c0_exe1_stall_in;
assign local_bb1_st_c0_exe1_stall_in = (|rstag_495to495_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_495to495_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (rstag_495to495_bb1_st_c0_exe1_stall_local)
		begin
			if (~(rstag_495to495_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG))
			begin
				rstag_495to495_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG <= rstag_495to495_bb1_st_c0_exe1_inputs_ready;
			end
		end
		else
		begin
			rstag_495to495_bb1_st_c0_exe1_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
	end
end


// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
wire branch_var__output_regs_ready;

assign branch_var__inputs_ready = rstag_495to495_bb1_st_c0_exe1_valid_out;
assign branch_var__output_regs_ready = ~(stall_in);
assign rstag_495to495_bb1_st_c0_exe1_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign valid_out = branch_var__inputs_ready;

endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module scatter_function
	(
		input 		clock,
		input 		resetn,
		input [31:0] 		input_global_id_0,
		output 		stall_out,
		input 		valid_in,
		output 		valid_out,
		input 		stall_in,
		input [31:0] 		workgroup_size,
		input [255:0] 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_readdata,
		input 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_readdatavalid,
		input 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_waitrequest,
		output [29:0] 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_address,
		output 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_read,
		output 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_write,
		input 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_writeack,
		output [255:0] 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_writedata,
		output [31:0] 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_byteenable,
		output [4:0] 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_burstcount,
		input [255:0] 		avm_local_bb1_ld__readdata,
		input 		avm_local_bb1_ld__readdatavalid,
		input 		avm_local_bb1_ld__waitrequest,
		output [29:0] 		avm_local_bb1_ld__address,
		output 		avm_local_bb1_ld__read,
		output 		avm_local_bb1_ld__write,
		input 		avm_local_bb1_ld__writeack,
		output [255:0] 		avm_local_bb1_ld__writedata,
		output [31:0] 		avm_local_bb1_ld__byteenable,
		output [4:0] 		avm_local_bb1_ld__burstcount,
		input [255:0] 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_readdata,
		input 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_readdatavalid,
		input 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_waitrequest,
		output [29:0] 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_address,
		output 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_read,
		output 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_write,
		input 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_writeack,
		output [255:0] 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_writedata,
		output [31:0] 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_byteenable,
		output [4:0] 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_burstcount,
		input [255:0] 		avm_local_bb1_ld__u0_readdata,
		input 		avm_local_bb1_ld__u0_readdatavalid,
		input 		avm_local_bb1_ld__u0_waitrequest,
		output [29:0] 		avm_local_bb1_ld__u0_address,
		output 		avm_local_bb1_ld__u0_read,
		output 		avm_local_bb1_ld__u0_write,
		input 		avm_local_bb1_ld__u0_writeack,
		output [255:0] 		avm_local_bb1_ld__u0_writedata,
		output [31:0] 		avm_local_bb1_ld__u0_byteenable,
		output [4:0] 		avm_local_bb1_ld__u0_burstcount,
		input [255:0] 		avm_local_bb1_st_c0_exe1_readdata,
		input 		avm_local_bb1_st_c0_exe1_readdatavalid,
		input 		avm_local_bb1_st_c0_exe1_waitrequest,
		output [29:0] 		avm_local_bb1_st_c0_exe1_address,
		output 		avm_local_bb1_st_c0_exe1_read,
		output 		avm_local_bb1_st_c0_exe1_write,
		input 		avm_local_bb1_st_c0_exe1_writeack,
		output [255:0] 		avm_local_bb1_st_c0_exe1_writedata,
		output [31:0] 		avm_local_bb1_st_c0_exe1_byteenable,
		output [4:0] 		avm_local_bb1_st_c0_exe1_burstcount,
		input 		start,
		input 		clock2x,
		input [63:0] 		input_edge_arr,
		input [63:0] 		input_msg_arr,
		input [31:0] 		input_global_size_0,
		input [63:0] 		input_outCount_arr,
		input [63:0] 		input_rank,
		output reg 		has_a_write_pending,
		output reg 		has_a_lsu_active
	);


wire [31:0] cur_cycle;
wire bb_0_stall_out;
wire bb_0_valid_out;
wire [31:0] bb_0_lvb_input_global_id_0;
wire bb_1_stall_out;
wire bb_1_valid_out;
wire bb_1_local_bb1_ld_memcoalesce_edge_arr_load_0_active;
wire bb_1_local_bb1_ld__active;
wire bb_1_local_bb1_st_memcoalesce_edge_arr_extrValue_1_active;
wire bb_1_local_bb1_ld__u0_active;
wire bb_1_local_bb1_st_c0_exe1_active;
wire [1:0] writes_pending;
wire [4:0] lsus_active;

scatter_basic_block_0 scatter_basic_block_0 (
	.clock(clock),
	.resetn(resetn),
	.start(start),
	.valid_in(valid_in),
	.stall_out(bb_0_stall_out),
	.input_global_id_0(input_global_id_0),
	.valid_out(bb_0_valid_out),
	.stall_in(bb_1_stall_out),
	.lvb_input_global_id_0(bb_0_lvb_input_global_id_0),
	.workgroup_size(workgroup_size)
);


scatter_basic_block_1 scatter_basic_block_1 (
	.clock(clock),
	.resetn(resetn),
	.input_edge_arr(input_edge_arr),
	.input_msg_arr(input_msg_arr),
	.input_global_size_0(input_global_size_0),
	.input_outCount_arr(input_outCount_arr),
	.input_rank(input_rank),
	.valid_in(bb_0_valid_out),
	.stall_out(bb_1_stall_out),
	.input_global_id_0(bb_0_lvb_input_global_id_0),
	.valid_out(bb_1_valid_out),
	.stall_in(stall_in),
	.workgroup_size(workgroup_size),
	.start(start),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_readdata(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_readdata),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_readdatavalid(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_readdatavalid),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_waitrequest(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_waitrequest),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_address(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_address),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_read(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_read),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_write(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_write),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_writeack(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_writeack),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_writedata(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_writedata),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_byteenable(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_byteenable),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_burstcount(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_burstcount),
	.local_bb1_ld_memcoalesce_edge_arr_load_0_active(bb_1_local_bb1_ld_memcoalesce_edge_arr_load_0_active),
	.clock2x(clock2x),
	.avm_local_bb1_ld__readdata(avm_local_bb1_ld__readdata),
	.avm_local_bb1_ld__readdatavalid(avm_local_bb1_ld__readdatavalid),
	.avm_local_bb1_ld__waitrequest(avm_local_bb1_ld__waitrequest),
	.avm_local_bb1_ld__address(avm_local_bb1_ld__address),
	.avm_local_bb1_ld__read(avm_local_bb1_ld__read),
	.avm_local_bb1_ld__write(avm_local_bb1_ld__write),
	.avm_local_bb1_ld__writeack(avm_local_bb1_ld__writeack),
	.avm_local_bb1_ld__writedata(avm_local_bb1_ld__writedata),
	.avm_local_bb1_ld__byteenable(avm_local_bb1_ld__byteenable),
	.avm_local_bb1_ld__burstcount(avm_local_bb1_ld__burstcount),
	.local_bb1_ld__active(bb_1_local_bb1_ld__active),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_readdata(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_readdata),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_readdatavalid(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_readdatavalid),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_waitrequest(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_waitrequest),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_address(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_address),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_read(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_read),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_write(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_write),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_writeack(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_writeack),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_writedata(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_writedata),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_byteenable(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_byteenable),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_burstcount(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_burstcount),
	.local_bb1_st_memcoalesce_edge_arr_extrValue_1_active(bb_1_local_bb1_st_memcoalesce_edge_arr_extrValue_1_active),
	.avm_local_bb1_ld__u0_readdata(avm_local_bb1_ld__u0_readdata),
	.avm_local_bb1_ld__u0_readdatavalid(avm_local_bb1_ld__u0_readdatavalid),
	.avm_local_bb1_ld__u0_waitrequest(avm_local_bb1_ld__u0_waitrequest),
	.avm_local_bb1_ld__u0_address(avm_local_bb1_ld__u0_address),
	.avm_local_bb1_ld__u0_read(avm_local_bb1_ld__u0_read),
	.avm_local_bb1_ld__u0_write(avm_local_bb1_ld__u0_write),
	.avm_local_bb1_ld__u0_writeack(avm_local_bb1_ld__u0_writeack),
	.avm_local_bb1_ld__u0_writedata(avm_local_bb1_ld__u0_writedata),
	.avm_local_bb1_ld__u0_byteenable(avm_local_bb1_ld__u0_byteenable),
	.avm_local_bb1_ld__u0_burstcount(avm_local_bb1_ld__u0_burstcount),
	.local_bb1_ld__u0_active(bb_1_local_bb1_ld__u0_active),
	.avm_local_bb1_st_c0_exe1_readdata(avm_local_bb1_st_c0_exe1_readdata),
	.avm_local_bb1_st_c0_exe1_readdatavalid(avm_local_bb1_st_c0_exe1_readdatavalid),
	.avm_local_bb1_st_c0_exe1_waitrequest(avm_local_bb1_st_c0_exe1_waitrequest),
	.avm_local_bb1_st_c0_exe1_address(avm_local_bb1_st_c0_exe1_address),
	.avm_local_bb1_st_c0_exe1_read(avm_local_bb1_st_c0_exe1_read),
	.avm_local_bb1_st_c0_exe1_write(avm_local_bb1_st_c0_exe1_write),
	.avm_local_bb1_st_c0_exe1_writeack(avm_local_bb1_st_c0_exe1_writeack),
	.avm_local_bb1_st_c0_exe1_writedata(avm_local_bb1_st_c0_exe1_writedata),
	.avm_local_bb1_st_c0_exe1_byteenable(avm_local_bb1_st_c0_exe1_byteenable),
	.avm_local_bb1_st_c0_exe1_burstcount(avm_local_bb1_st_c0_exe1_burstcount),
	.local_bb1_st_c0_exe1_active(bb_1_local_bb1_st_c0_exe1_active)
);


scatter_sys_cycle_time system_cycle_time_module (
	.clock(clock),
	.resetn(resetn),
	.cur_cycle(cur_cycle)
);


assign valid_out = bb_1_valid_out;
assign stall_out = bb_0_stall_out;
assign writes_pending[0] = bb_1_local_bb1_st_memcoalesce_edge_arr_extrValue_1_active;
assign writes_pending[1] = bb_1_local_bb1_st_c0_exe1_active;
assign lsus_active[0] = bb_1_local_bb1_ld_memcoalesce_edge_arr_load_0_active;
assign lsus_active[1] = bb_1_local_bb1_ld__active;
assign lsus_active[2] = bb_1_local_bb1_st_memcoalesce_edge_arr_extrValue_1_active;
assign lsus_active[3] = bb_1_local_bb1_ld__u0_active;
assign lsus_active[4] = bb_1_local_bb1_st_c0_exe1_active;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		has_a_write_pending <= 1'b0;
		has_a_lsu_active <= 1'b0;
	end
	else
	begin
		has_a_write_pending <= (|writes_pending);
		has_a_lsu_active <= (|lsus_active);
	end
end

endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module scatter_function_wrapper
	(
		input 		clock,
		input 		resetn,
		input 		clock2x,
		input 		local_router_hang,
		input 		avs_cra_read,
		input 		avs_cra_write,
		input [4:0] 		avs_cra_address,
		input [63:0] 		avs_cra_writedata,
		input [7:0] 		avs_cra_byteenable,
		output 		avs_cra_waitrequest,
		output reg [63:0] 		avs_cra_readdata,
		output reg 		avs_cra_readdatavalid,
		output 		cra_irq,
		input [255:0] 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_readdata,
		input 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_readdatavalid,
		input 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_waitrequest,
		output [29:0] 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_address,
		output 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_read,
		output 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_write,
		input 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_writeack,
		output [255:0] 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_writedata,
		output [31:0] 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_byteenable,
		output [4:0] 		avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_burstcount,
		input [255:0] 		avm_local_bb1_ld__inst0_readdata,
		input 		avm_local_bb1_ld__inst0_readdatavalid,
		input 		avm_local_bb1_ld__inst0_waitrequest,
		output [29:0] 		avm_local_bb1_ld__inst0_address,
		output 		avm_local_bb1_ld__inst0_read,
		output 		avm_local_bb1_ld__inst0_write,
		input 		avm_local_bb1_ld__inst0_writeack,
		output [255:0] 		avm_local_bb1_ld__inst0_writedata,
		output [31:0] 		avm_local_bb1_ld__inst0_byteenable,
		output [4:0] 		avm_local_bb1_ld__inst0_burstcount,
		input [255:0] 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_readdata,
		input 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_readdatavalid,
		input 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_waitrequest,
		output [29:0] 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_address,
		output 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_read,
		output 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_write,
		input 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_writeack,
		output [255:0] 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_writedata,
		output [31:0] 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_byteenable,
		output [4:0] 		avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_burstcount,
		input [255:0] 		avm_local_bb1_ld__u0_inst0_readdata,
		input 		avm_local_bb1_ld__u0_inst0_readdatavalid,
		input 		avm_local_bb1_ld__u0_inst0_waitrequest,
		output [29:0] 		avm_local_bb1_ld__u0_inst0_address,
		output 		avm_local_bb1_ld__u0_inst0_read,
		output 		avm_local_bb1_ld__u0_inst0_write,
		input 		avm_local_bb1_ld__u0_inst0_writeack,
		output [255:0] 		avm_local_bb1_ld__u0_inst0_writedata,
		output [31:0] 		avm_local_bb1_ld__u0_inst0_byteenable,
		output [4:0] 		avm_local_bb1_ld__u0_inst0_burstcount,
		input [255:0] 		avm_local_bb1_st_c0_exe1_inst0_readdata,
		input 		avm_local_bb1_st_c0_exe1_inst0_readdatavalid,
		input 		avm_local_bb1_st_c0_exe1_inst0_waitrequest,
		output [29:0] 		avm_local_bb1_st_c0_exe1_inst0_address,
		output 		avm_local_bb1_st_c0_exe1_inst0_read,
		output 		avm_local_bb1_st_c0_exe1_inst0_write,
		input 		avm_local_bb1_st_c0_exe1_inst0_writeack,
		output [255:0] 		avm_local_bb1_st_c0_exe1_inst0_writedata,
		output [31:0] 		avm_local_bb1_st_c0_exe1_inst0_byteenable,
		output [4:0] 		avm_local_bb1_st_c0_exe1_inst0_burstcount
	);

// Responsible for interfacing a kernel with the outside world. It comprises a
// slave interface to specify the kernel arguments and retain kernel status. 

// This section of the wrapper implements the slave interface.
// twoXclock_consumer uses clock2x, even if nobody inside the kernel does. Keeps interface to acl_iface consistent for all kernels.
 reg start_NO_SHIFT_REG;
 reg started_NO_SHIFT_REG;
wire finish;
 reg [31:0] status_NO_SHIFT_REG;
wire has_a_write_pending;
wire has_a_lsu_active;
 reg [287:0] kernel_arguments_NO_SHIFT_REG;
 reg twoXclock_consumer_NO_SHIFT_REG /* synthesis  preserve  noprune  */;
 reg [31:0] workgroup_size_NO_SHIFT_REG;
 reg [31:0] global_size_NO_SHIFT_REG[2:0];
 reg [31:0] num_groups_NO_SHIFT_REG[2:0];
 reg [31:0] local_size_NO_SHIFT_REG[2:0];
 reg [31:0] work_dim_NO_SHIFT_REG;
 reg [31:0] global_offset_NO_SHIFT_REG[2:0];
 reg [63:0] profile_data_NO_SHIFT_REG;
 reg [31:0] profile_ctrl_NO_SHIFT_REG;
 reg [63:0] profile_start_cycle_NO_SHIFT_REG;
 reg [63:0] profile_stop_cycle_NO_SHIFT_REG;
wire dispatched_all_groups;
wire [31:0] group_id_tmp[2:0];
wire [31:0] global_id_base_out[2:0];
wire start_out;
wire [31:0] local_id[0:0][2:0];
wire [31:0] global_id[0:0][2:0];
wire [31:0] group_id[0:0][2:0];
wire iter_valid_in;
wire iter_stall_out;
wire stall_in;
wire stall_out;
wire valid_in;
wire valid_out;

always @(posedge clock2x or negedge resetn)
begin
	if (~(resetn))
	begin
		twoXclock_consumer_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		twoXclock_consumer_NO_SHIFT_REG <= 1'b1;
	end
end



// Work group dispatcher is responsible for issuing work-groups to id iterator(s)
acl_work_group_dispatcher group_dispatcher (
	.clock(clock),
	.resetn(resetn),
	.start(start_NO_SHIFT_REG),
	.num_groups(num_groups_NO_SHIFT_REG),
	.local_size(local_size_NO_SHIFT_REG),
	.stall_in(iter_stall_out),
	.valid_out(iter_valid_in),
	.group_id_out(group_id_tmp),
	.global_id_base_out(global_id_base_out),
	.start_out(start_out),
	.dispatched_all_groups(dispatched_all_groups)
);

defparam group_dispatcher.NUM_COPIES = 1;
defparam group_dispatcher.RUN_FOREVER = 0;


// This section of the wrapper implements an Avalon Slave Interface used to configure a kernel invocation.
// The few words words contain the status and the workgroup size registers.
// The remaining addressable space is reserved for kernel arguments.
wire [63:0] bitenable;

assign bitenable[7:0] = (avs_cra_byteenable[0] ? 8'hFF : 8'h0);
assign bitenable[15:8] = (avs_cra_byteenable[1] ? 8'hFF : 8'h0);
assign bitenable[23:16] = (avs_cra_byteenable[2] ? 8'hFF : 8'h0);
assign bitenable[31:24] = (avs_cra_byteenable[3] ? 8'hFF : 8'h0);
assign bitenable[39:32] = (avs_cra_byteenable[4] ? 8'hFF : 8'h0);
assign bitenable[47:40] = (avs_cra_byteenable[5] ? 8'hFF : 8'h0);
assign bitenable[55:48] = (avs_cra_byteenable[6] ? 8'hFF : 8'h0);
assign bitenable[63:56] = (avs_cra_byteenable[7] ? 8'hFF : 8'h0);
assign avs_cra_waitrequest = 1'b0;
assign cra_irq = (status_NO_SHIFT_REG[1] | status_NO_SHIFT_REG[3]);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		start_NO_SHIFT_REG <= 1'b0;
		started_NO_SHIFT_REG <= 1'b0;
		kernel_arguments_NO_SHIFT_REG <= 288'h0;
		status_NO_SHIFT_REG <= 32'h30000;
		profile_ctrl_NO_SHIFT_REG <= 32'h4;
		profile_start_cycle_NO_SHIFT_REG <= 64'h0;
		profile_stop_cycle_NO_SHIFT_REG <= 64'hFFFFFFFFFFFFFFFF;
		work_dim_NO_SHIFT_REG <= 32'h0;
		workgroup_size_NO_SHIFT_REG <= 32'h0;
		global_size_NO_SHIFT_REG[0] <= 32'h0;
		global_size_NO_SHIFT_REG[1] <= 32'h0;
		global_size_NO_SHIFT_REG[2] <= 32'h0;
		num_groups_NO_SHIFT_REG[0] <= 32'h0;
		num_groups_NO_SHIFT_REG[1] <= 32'h0;
		num_groups_NO_SHIFT_REG[2] <= 32'h0;
		local_size_NO_SHIFT_REG[0] <= 32'h0;
		local_size_NO_SHIFT_REG[1] <= 32'h0;
		local_size_NO_SHIFT_REG[2] <= 32'h0;
		global_offset_NO_SHIFT_REG[0] <= 32'h0;
		global_offset_NO_SHIFT_REG[1] <= 32'h0;
		global_offset_NO_SHIFT_REG[2] <= 32'h0;
	end
	else
	begin
		if (avs_cra_write)
		begin
			case (avs_cra_address)
				5'h0:
				begin
					status_NO_SHIFT_REG[31:16] <= 16'h3;
					status_NO_SHIFT_REG[15:0] <= ((status_NO_SHIFT_REG[15:0] & ~(bitenable[15:0])) | (avs_cra_writedata[15:0] & bitenable[15:0]));
				end

				5'h1:
				begin
					profile_ctrl_NO_SHIFT_REG <= ((profile_ctrl_NO_SHIFT_REG & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'h3:
				begin
					profile_start_cycle_NO_SHIFT_REG[31:0] <= ((profile_start_cycle_NO_SHIFT_REG[31:0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					profile_start_cycle_NO_SHIFT_REG[63:32] <= ((profile_start_cycle_NO_SHIFT_REG[63:32] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'h4:
				begin
					profile_stop_cycle_NO_SHIFT_REG[31:0] <= ((profile_stop_cycle_NO_SHIFT_REG[31:0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					profile_stop_cycle_NO_SHIFT_REG[63:32] <= ((profile_stop_cycle_NO_SHIFT_REG[63:32] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'h5:
				begin
					work_dim_NO_SHIFT_REG <= ((work_dim_NO_SHIFT_REG & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					workgroup_size_NO_SHIFT_REG <= ((workgroup_size_NO_SHIFT_REG & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'h6:
				begin
					global_size_NO_SHIFT_REG[0] <= ((global_size_NO_SHIFT_REG[0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					global_size_NO_SHIFT_REG[1] <= ((global_size_NO_SHIFT_REG[1] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'h7:
				begin
					global_size_NO_SHIFT_REG[2] <= ((global_size_NO_SHIFT_REG[2] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					num_groups_NO_SHIFT_REG[0] <= ((num_groups_NO_SHIFT_REG[0] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'h8:
				begin
					num_groups_NO_SHIFT_REG[1] <= ((num_groups_NO_SHIFT_REG[1] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					num_groups_NO_SHIFT_REG[2] <= ((num_groups_NO_SHIFT_REG[2] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'h9:
				begin
					local_size_NO_SHIFT_REG[0] <= ((local_size_NO_SHIFT_REG[0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					local_size_NO_SHIFT_REG[1] <= ((local_size_NO_SHIFT_REG[1] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'hA:
				begin
					local_size_NO_SHIFT_REG[2] <= ((local_size_NO_SHIFT_REG[2] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					global_offset_NO_SHIFT_REG[0] <= ((global_offset_NO_SHIFT_REG[0] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'hB:
				begin
					global_offset_NO_SHIFT_REG[1] <= ((global_offset_NO_SHIFT_REG[1] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					global_offset_NO_SHIFT_REG[2] <= ((global_offset_NO_SHIFT_REG[2] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'hC:
				begin
					kernel_arguments_NO_SHIFT_REG[31:0] <= ((kernel_arguments_NO_SHIFT_REG[31:0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					kernel_arguments_NO_SHIFT_REG[63:32] <= ((kernel_arguments_NO_SHIFT_REG[63:32] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'hD:
				begin
					kernel_arguments_NO_SHIFT_REG[95:64] <= ((kernel_arguments_NO_SHIFT_REG[95:64] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					kernel_arguments_NO_SHIFT_REG[127:96] <= ((kernel_arguments_NO_SHIFT_REG[127:96] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'hE:
				begin
					kernel_arguments_NO_SHIFT_REG[159:128] <= ((kernel_arguments_NO_SHIFT_REG[159:128] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					kernel_arguments_NO_SHIFT_REG[191:160] <= ((kernel_arguments_NO_SHIFT_REG[191:160] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'hF:
				begin
					kernel_arguments_NO_SHIFT_REG[223:192] <= ((kernel_arguments_NO_SHIFT_REG[223:192] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					kernel_arguments_NO_SHIFT_REG[255:224] <= ((kernel_arguments_NO_SHIFT_REG[255:224] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'h10:
				begin
					kernel_arguments_NO_SHIFT_REG[287:256] <= ((kernel_arguments_NO_SHIFT_REG[287:256] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
				end

				default:
				begin
				end

			endcase
		end
		else
		begin
			if (status_NO_SHIFT_REG[0])
			begin
				start_NO_SHIFT_REG <= 1'b1;
			end
			if (start_NO_SHIFT_REG)
			begin
				status_NO_SHIFT_REG[0] <= 1'b0;
				started_NO_SHIFT_REG <= 1'b1;
			end
			if (started_NO_SHIFT_REG)
			begin
				start_NO_SHIFT_REG <= 1'b0;
			end
			if (finish)
			begin
				status_NO_SHIFT_REG[1] <= 1'b1;
				started_NO_SHIFT_REG <= 1'b0;
			end
		end
		status_NO_SHIFT_REG[11] <= local_router_hang;
		status_NO_SHIFT_REG[12] <= (|has_a_lsu_active);
		status_NO_SHIFT_REG[13] <= (|has_a_write_pending);
		status_NO_SHIFT_REG[14] <= (|valid_in);
		status_NO_SHIFT_REG[15] <= started_NO_SHIFT_REG;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		avs_cra_readdata <= 64'h0;
	end
	else
	begin
		case (avs_cra_address)
			5'h0:
			begin
				avs_cra_readdata[31:0] <= status_NO_SHIFT_REG;
				avs_cra_readdata[63:32] <= 32'h0;
			end

			5'h1:
			begin
				avs_cra_readdata[31:0] <= 'x;
				avs_cra_readdata[63:32] <= 32'h0;
			end

			5'h2:
			begin
				avs_cra_readdata[63:0] <= 64'h0;
			end

			5'h3:
			begin
				avs_cra_readdata[63:0] <= 64'h0;
			end

			5'h4:
			begin
				avs_cra_readdata[63:0] <= 64'h0;
			end

			5'h5:
			begin
				avs_cra_readdata[31:0] <= work_dim_NO_SHIFT_REG;
				avs_cra_readdata[63:32] <= workgroup_size_NO_SHIFT_REG;
			end

			5'h6:
			begin
				avs_cra_readdata[31:0] <= global_size_NO_SHIFT_REG[0];
				avs_cra_readdata[63:32] <= global_size_NO_SHIFT_REG[1];
			end

			5'h7:
			begin
				avs_cra_readdata[31:0] <= global_size_NO_SHIFT_REG[2];
				avs_cra_readdata[63:32] <= num_groups_NO_SHIFT_REG[0];
			end

			5'h8:
			begin
				avs_cra_readdata[31:0] <= num_groups_NO_SHIFT_REG[1];
				avs_cra_readdata[63:32] <= num_groups_NO_SHIFT_REG[2];
			end

			5'h9:
			begin
				avs_cra_readdata[31:0] <= local_size_NO_SHIFT_REG[0];
				avs_cra_readdata[63:32] <= local_size_NO_SHIFT_REG[1];
			end

			5'hA:
			begin
				avs_cra_readdata[31:0] <= local_size_NO_SHIFT_REG[2];
				avs_cra_readdata[63:32] <= global_offset_NO_SHIFT_REG[0];
			end

			5'hB:
			begin
				avs_cra_readdata[31:0] <= global_offset_NO_SHIFT_REG[1];
				avs_cra_readdata[63:32] <= global_offset_NO_SHIFT_REG[2];
			end

			5'hC:
			begin
				avs_cra_readdata[31:0] <= kernel_arguments_NO_SHIFT_REG[31:0];
				avs_cra_readdata[63:32] <= kernel_arguments_NO_SHIFT_REG[63:32];
			end

			5'hD:
			begin
				avs_cra_readdata[31:0] <= kernel_arguments_NO_SHIFT_REG[95:64];
				avs_cra_readdata[63:32] <= kernel_arguments_NO_SHIFT_REG[127:96];
			end

			5'hE:
			begin
				avs_cra_readdata[31:0] <= kernel_arguments_NO_SHIFT_REG[159:128];
				avs_cra_readdata[63:32] <= kernel_arguments_NO_SHIFT_REG[191:160];
			end

			5'hF:
			begin
				avs_cra_readdata[31:0] <= kernel_arguments_NO_SHIFT_REG[223:192];
				avs_cra_readdata[63:32] <= kernel_arguments_NO_SHIFT_REG[255:224];
			end

			5'h10:
			begin
				avs_cra_readdata[31:0] <= kernel_arguments_NO_SHIFT_REG[287:256];
				avs_cra_readdata[63:32] <= 32'h0;
			end

			default:
			begin
				avs_cra_readdata <= status_NO_SHIFT_REG;
			end

		endcase
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		avs_cra_readdatavalid <= 1'b0;
	end
	else
	begin
		avs_cra_readdatavalid <= (avs_cra_read & ~(avs_cra_waitrequest));
	end
end


// Handshaking signals used to control data through the pipeline

// Determine when the kernel is finished.
acl_kernel_finish_detector kernel_finish_detector (
	.clock(clock),
	.resetn(resetn),
	.start(start_NO_SHIFT_REG),
	.wg_size(workgroup_size_NO_SHIFT_REG),
	.wg_dispatch_valid_out(iter_valid_in),
	.wg_dispatch_stall_in(iter_stall_out),
	.dispatched_all_groups(dispatched_all_groups),
	.kernel_copy_valid_out(valid_out),
	.kernel_copy_stall_in(stall_in),
	.pending_writes(has_a_write_pending),
	.finish(finish)
);

defparam kernel_finish_detector.NUM_COPIES = 1;
defparam kernel_finish_detector.WG_SIZE_W = 32;

assign stall_in = 1'b0;

// Creating ID iterator and kernel instance for every requested kernel copy

// ID iterator is responsible for iterating over all local ids for given work-groups
acl_id_iterator id_iter_inst0 (
	.clock(clock),
	.resetn(resetn),
	.start(start_out),
	.valid_in(iter_valid_in),
	.stall_out(iter_stall_out),
	.stall_in(stall_out),
	.valid_out(valid_in),
	.group_id_in(group_id_tmp),
	.global_id_base_in(global_id_base_out),
	.local_size(local_size_NO_SHIFT_REG),
	.global_size(global_size_NO_SHIFT_REG),
	.local_id(local_id[0]),
	.global_id(global_id[0]),
	.group_id(group_id[0])
);



// This section instantiates a kernel function block
scatter_function scatter_function_inst0 (
	.clock(clock),
	.resetn(resetn),
	.input_global_id_0(global_id[0][0]),
	.stall_out(stall_out),
	.valid_in(valid_in),
	.valid_out(valid_out),
	.stall_in(stall_in),
	.workgroup_size(workgroup_size_NO_SHIFT_REG),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_readdata(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_readdata),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_readdatavalid(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_readdatavalid),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_waitrequest(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_waitrequest),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_address(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_address),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_read(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_read),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_write(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_write),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_writeack(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_writeack),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_writedata(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_writedata),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_byteenable(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_byteenable),
	.avm_local_bb1_ld_memcoalesce_edge_arr_load_0_burstcount(avm_local_bb1_ld_memcoalesce_edge_arr_load_0_inst0_burstcount),
	.avm_local_bb1_ld__readdata(avm_local_bb1_ld__inst0_readdata),
	.avm_local_bb1_ld__readdatavalid(avm_local_bb1_ld__inst0_readdatavalid),
	.avm_local_bb1_ld__waitrequest(avm_local_bb1_ld__inst0_waitrequest),
	.avm_local_bb1_ld__address(avm_local_bb1_ld__inst0_address),
	.avm_local_bb1_ld__read(avm_local_bb1_ld__inst0_read),
	.avm_local_bb1_ld__write(avm_local_bb1_ld__inst0_write),
	.avm_local_bb1_ld__writeack(avm_local_bb1_ld__inst0_writeack),
	.avm_local_bb1_ld__writedata(avm_local_bb1_ld__inst0_writedata),
	.avm_local_bb1_ld__byteenable(avm_local_bb1_ld__inst0_byteenable),
	.avm_local_bb1_ld__burstcount(avm_local_bb1_ld__inst0_burstcount),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_readdata(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_readdata),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_readdatavalid(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_readdatavalid),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_waitrequest(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_waitrequest),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_address(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_address),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_read(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_read),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_write(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_write),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_writeack(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_writeack),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_writedata(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_writedata),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_byteenable(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_byteenable),
	.avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_burstcount(avm_local_bb1_st_memcoalesce_edge_arr_extrValue_1_inst0_burstcount),
	.avm_local_bb1_ld__u0_readdata(avm_local_bb1_ld__u0_inst0_readdata),
	.avm_local_bb1_ld__u0_readdatavalid(avm_local_bb1_ld__u0_inst0_readdatavalid),
	.avm_local_bb1_ld__u0_waitrequest(avm_local_bb1_ld__u0_inst0_waitrequest),
	.avm_local_bb1_ld__u0_address(avm_local_bb1_ld__u0_inst0_address),
	.avm_local_bb1_ld__u0_read(avm_local_bb1_ld__u0_inst0_read),
	.avm_local_bb1_ld__u0_write(avm_local_bb1_ld__u0_inst0_write),
	.avm_local_bb1_ld__u0_writeack(avm_local_bb1_ld__u0_inst0_writeack),
	.avm_local_bb1_ld__u0_writedata(avm_local_bb1_ld__u0_inst0_writedata),
	.avm_local_bb1_ld__u0_byteenable(avm_local_bb1_ld__u0_inst0_byteenable),
	.avm_local_bb1_ld__u0_burstcount(avm_local_bb1_ld__u0_inst0_burstcount),
	.avm_local_bb1_st_c0_exe1_readdata(avm_local_bb1_st_c0_exe1_inst0_readdata),
	.avm_local_bb1_st_c0_exe1_readdatavalid(avm_local_bb1_st_c0_exe1_inst0_readdatavalid),
	.avm_local_bb1_st_c0_exe1_waitrequest(avm_local_bb1_st_c0_exe1_inst0_waitrequest),
	.avm_local_bb1_st_c0_exe1_address(avm_local_bb1_st_c0_exe1_inst0_address),
	.avm_local_bb1_st_c0_exe1_read(avm_local_bb1_st_c0_exe1_inst0_read),
	.avm_local_bb1_st_c0_exe1_write(avm_local_bb1_st_c0_exe1_inst0_write),
	.avm_local_bb1_st_c0_exe1_writeack(avm_local_bb1_st_c0_exe1_inst0_writeack),
	.avm_local_bb1_st_c0_exe1_writedata(avm_local_bb1_st_c0_exe1_inst0_writedata),
	.avm_local_bb1_st_c0_exe1_byteenable(avm_local_bb1_st_c0_exe1_inst0_byteenable),
	.avm_local_bb1_st_c0_exe1_burstcount(avm_local_bb1_st_c0_exe1_inst0_burstcount),
	.start(start_out),
	.clock2x(clock2x),
	.input_edge_arr(kernel_arguments_NO_SHIFT_REG[63:0]),
	.input_msg_arr(kernel_arguments_NO_SHIFT_REG[191:128]),
	.input_global_size_0(global_size_NO_SHIFT_REG[0]),
	.input_outCount_arr(kernel_arguments_NO_SHIFT_REG[127:64]),
	.input_rank(kernel_arguments_NO_SHIFT_REG[255:192]),
	.has_a_write_pending(has_a_write_pending),
	.has_a_lsu_active(has_a_lsu_active)
);



endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module scatter_sys_cycle_time
	(
		input 		clock,
		input 		resetn,
		output [31:0] 		cur_cycle
	);


 reg [31:0] cur_count_NO_SHIFT_REG;

assign cur_cycle = cur_count_NO_SHIFT_REG;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		cur_count_NO_SHIFT_REG <= 32'h0;
	end
	else
	begin
		cur_count_NO_SHIFT_REG <= (cur_count_NO_SHIFT_REG + 32'h1);
	end
end

endmodule

// (C) 1992-2014 Altera Corporation. All rights reserved.                         
// Your use of Altera Corporation's design tools, logic functions and other       
// software and tools, and its AMPP partner logic functions, and any output       
// files any of the foregoing (including device programming or simulation         
// files), and any associated documentation or information are expressly subject  
// to the terms and conditions of the Altera Program License Subscription         
// Agreement, Altera MegaCore Function License Agreement, or other applicable     
// license agreement, including, without limitation, that your use is for the     
// sole purpose of programming logic devices manufactured by Altera and sold by   
// Altera or its authorized distributors.  Please refer to the applicable         
// agreement for further details.                                                 
    

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module gather_basic_block_0
	(
		input 		clock,
		input 		resetn,
		input 		start,
		input [31:0] 		input_num_edges,
		input [31:0] 		input_num_nodes,
		input 		valid_in,
		output 		stall_out,
		input [31:0] 		input_global_id_0,
		output 		valid_out,
		input 		stall_in,
		output 		lvb_bb0_cmp1,
		output [31:0] 		lvb_bb0_div,
		output [31:0] 		lvb_input_global_id_0,
		input [31:0] 		workgroup_size
	);


// Values used for debugging.  These are swept away by synthesis.
wire _entry;
wire _exit;
 reg [31:0] _num_entry_NO_SHIFT_REG;
 reg [31:0] _num_exit_NO_SHIFT_REG;
wire [31:0] _num_live;

assign _entry = ((&valid_in) & ~((|stall_out)));
assign _exit = ((&valid_out) & ~((|stall_in)));
assign _num_live = (_num_entry_NO_SHIFT_REG - _num_exit_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		_num_entry_NO_SHIFT_REG <= 32'h0;
		_num_exit_NO_SHIFT_REG <= 32'h0;
	end
	else
	begin
		if (_entry)
		begin
			_num_entry_NO_SHIFT_REG <= (_num_entry_NO_SHIFT_REG + 2'h1);
		end
		if (_exit)
		begin
			_num_exit_NO_SHIFT_REG <= (_num_exit_NO_SHIFT_REG + 2'h1);
		end
	end
end



// This section defines the behaviour of the MERGE node
wire merge_node_stall_in_0;
 reg merge_node_valid_out_0_NO_SHIFT_REG;
wire merge_node_stall_in_1;
 reg merge_node_valid_out_1_NO_SHIFT_REG;
wire merge_node_stall_in_2;
 reg merge_node_valid_out_2_NO_SHIFT_REG;
wire merge_stalled_by_successors;
 reg merge_block_selector_NO_SHIFT_REG;
 reg merge_node_valid_in_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_global_id_0_staging_reg_NO_SHIFT_REG;
 reg [31:0] local_lvm_input_global_id_0_NO_SHIFT_REG;
 reg is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
 reg invariant_valid_NO_SHIFT_REG;

assign merge_stalled_by_successors = ((merge_node_stall_in_0 & merge_node_valid_out_0_NO_SHIFT_REG) | (merge_node_stall_in_1 & merge_node_valid_out_1_NO_SHIFT_REG) | (merge_node_stall_in_2 & merge_node_valid_out_2_NO_SHIFT_REG));
assign stall_out = merge_node_valid_in_staging_reg_NO_SHIFT_REG;

always @(*)
begin
	if ((merge_node_valid_in_staging_reg_NO_SHIFT_REG | valid_in))
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b1;
	end
	else
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b0;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		input_global_id_0_staging_reg_NO_SHIFT_REG <= 'x;
		merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (((merge_block_selector_NO_SHIFT_REG != 1'b0) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_staging_reg_NO_SHIFT_REG))
			begin
				input_global_id_0_staging_reg_NO_SHIFT_REG <= input_global_id_0;
				merge_node_valid_in_staging_reg_NO_SHIFT_REG <= valid_in;
			end
		end
		else
		begin
			merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
		end
	end
end

always @(posedge clock)
begin
	if (~(merge_stalled_by_successors))
	begin
		case (merge_block_selector_NO_SHIFT_REG)
			1'b0:
			begin
				if (merge_node_valid_in_staging_reg_NO_SHIFT_REG)
				begin
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0_staging_reg_NO_SHIFT_REG;
				end
				else
				begin
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0;
				end
			end

			default:
			begin
			end

		endcase
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		merge_node_valid_out_0_NO_SHIFT_REG <= 1'b0;
		merge_node_valid_out_1_NO_SHIFT_REG <= 1'b0;
		merge_node_valid_out_2_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (~(merge_stalled_by_successors))
		begin
			merge_node_valid_out_0_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
			merge_node_valid_out_1_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
			merge_node_valid_out_2_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
		end
		else
		begin
			if (~(merge_node_stall_in_0))
			begin
				merge_node_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(merge_node_stall_in_1))
			begin
				merge_node_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
			if (~(merge_node_stall_in_2))
			begin
				merge_node_valid_out_2_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		invariant_valid_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		invariant_valid_NO_SHIFT_REG <= (~(start) & (invariant_valid_NO_SHIFT_REG | is_merge_data_to_local_regs_valid_NO_SHIFT_REG));
	end
end


// This section implements a registered operation.
// 
wire local_bb0_cmp1_inputs_ready;
 reg local_bb0_cmp1_wii_reg_NO_SHIFT_REG;
 reg local_bb0_cmp1_valid_out_NO_SHIFT_REG;
wire local_bb0_cmp1_stall_in;
wire local_bb0_cmp1_output_regs_ready;
 reg local_bb0_cmp1_NO_SHIFT_REG;
wire local_bb0_cmp1_causedstall;

assign local_bb0_cmp1_inputs_ready = merge_node_valid_out_0_NO_SHIFT_REG;
assign local_bb0_cmp1_output_regs_ready = (~(local_bb0_cmp1_wii_reg_NO_SHIFT_REG) & (&(~(local_bb0_cmp1_valid_out_NO_SHIFT_REG) | ~(local_bb0_cmp1_stall_in))));
assign merge_node_stall_in_0 = (~(local_bb0_cmp1_wii_reg_NO_SHIFT_REG) & (~(local_bb0_cmp1_output_regs_ready) | ~(local_bb0_cmp1_inputs_ready)));
assign local_bb0_cmp1_causedstall = (local_bb0_cmp1_inputs_ready && (~(local_bb0_cmp1_output_regs_ready) && !(~(local_bb0_cmp1_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_cmp1_NO_SHIFT_REG <= 'x;
		local_bb0_cmp1_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_cmp1_NO_SHIFT_REG <= 'x;
			local_bb0_cmp1_valid_out_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_cmp1_output_regs_ready)
			begin
				local_bb0_cmp1_NO_SHIFT_REG <= (input_num_edges == 32'h0);
				local_bb0_cmp1_valid_out_NO_SHIFT_REG <= local_bb0_cmp1_inputs_ready;
			end
			else
			begin
				if (~(local_bb0_cmp1_stall_in))
				begin
					local_bb0_cmp1_valid_out_NO_SHIFT_REG <= local_bb0_cmp1_wii_reg_NO_SHIFT_REG;
				end
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_cmp1_wii_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_cmp1_wii_reg_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_cmp1_inputs_ready)
			begin
				local_bb0_cmp1_wii_reg_NO_SHIFT_REG <= 1'b1;
			end
		end
	end
end


// This section implements a registered operation.
// 
wire local_bb0_conv7_inputs_ready;
 reg local_bb0_conv7_wii_reg_NO_SHIFT_REG;
 reg local_bb0_conv7_valid_out_NO_SHIFT_REG;
wire local_bb0_conv7_stall_in;
wire local_bb0_conv7_output_regs_ready;
wire [31:0] local_bb0_conv7;
 reg local_bb0_conv7_valid_pipe_0_NO_SHIFT_REG;
 reg local_bb0_conv7_valid_pipe_1_NO_SHIFT_REG;
 reg local_bb0_conv7_valid_pipe_2_NO_SHIFT_REG;
 reg local_bb0_conv7_valid_pipe_3_NO_SHIFT_REG;
 reg local_bb0_conv7_valid_pipe_4_NO_SHIFT_REG;
wire local_bb0_conv7_causedstall;

acl_fp_uitofp fp_module_local_bb0_conv7 (
	.clock(clock),
	.dataa(input_num_nodes),
	.enable(local_bb0_conv7_output_regs_ready),
	.result(local_bb0_conv7)
);


assign local_bb0_conv7_inputs_ready = merge_node_valid_out_1_NO_SHIFT_REG;
assign local_bb0_conv7_output_regs_ready = (~(local_bb0_conv7_wii_reg_NO_SHIFT_REG) & (&(~(local_bb0_conv7_valid_out_NO_SHIFT_REG) | ~(local_bb0_conv7_stall_in))));
assign merge_node_stall_in_1 = (~(local_bb0_conv7_wii_reg_NO_SHIFT_REG) & (~(local_bb0_conv7_output_regs_ready) | ~(local_bb0_conv7_inputs_ready)));
assign local_bb0_conv7_causedstall = (local_bb0_conv7_inputs_ready && (~(local_bb0_conv7_output_regs_ready) && !(~(local_bb0_conv7_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_conv7_valid_pipe_0_NO_SHIFT_REG <= 1'b0;
		local_bb0_conv7_valid_pipe_1_NO_SHIFT_REG <= 1'b0;
		local_bb0_conv7_valid_pipe_2_NO_SHIFT_REG <= 1'b0;
		local_bb0_conv7_valid_pipe_3_NO_SHIFT_REG <= 1'b0;
		local_bb0_conv7_valid_pipe_4_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_conv7_valid_pipe_0_NO_SHIFT_REG <= 1'b0;
			local_bb0_conv7_valid_pipe_1_NO_SHIFT_REG <= 1'b0;
			local_bb0_conv7_valid_pipe_2_NO_SHIFT_REG <= 1'b0;
			local_bb0_conv7_valid_pipe_3_NO_SHIFT_REG <= 1'b0;
			local_bb0_conv7_valid_pipe_4_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_conv7_output_regs_ready)
			begin
				local_bb0_conv7_valid_pipe_0_NO_SHIFT_REG <= local_bb0_conv7_inputs_ready;
				local_bb0_conv7_valid_pipe_1_NO_SHIFT_REG <= local_bb0_conv7_valid_pipe_0_NO_SHIFT_REG;
				local_bb0_conv7_valid_pipe_2_NO_SHIFT_REG <= local_bb0_conv7_valid_pipe_1_NO_SHIFT_REG;
				local_bb0_conv7_valid_pipe_3_NO_SHIFT_REG <= local_bb0_conv7_valid_pipe_2_NO_SHIFT_REG;
				local_bb0_conv7_valid_pipe_4_NO_SHIFT_REG <= local_bb0_conv7_valid_pipe_3_NO_SHIFT_REG;
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_conv7_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_conv7_valid_out_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_conv7_output_regs_ready)
			begin
				local_bb0_conv7_valid_out_NO_SHIFT_REG <= local_bb0_conv7_valid_pipe_4_NO_SHIFT_REG;
			end
			else
			begin
				if (~(local_bb0_conv7_stall_in))
				begin
					local_bb0_conv7_valid_out_NO_SHIFT_REG <= local_bb0_conv7_wii_reg_NO_SHIFT_REG;
				end
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_conv7_wii_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_conv7_wii_reg_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_conv7_valid_pipe_4_NO_SHIFT_REG)
			begin
				local_bb0_conv7_wii_reg_NO_SHIFT_REG <= 1'b1;
			end
		end
	end
end


// This section implements a registered operation.
// 
wire local_bb0_div_inputs_ready;
 reg local_bb0_div_wii_reg_NO_SHIFT_REG;
 reg local_bb0_div_valid_out_NO_SHIFT_REG;
wire local_bb0_div_stall_in;
wire local_bb0_div_output_regs_ready;
wire [31:0] local_bb0_div;
 reg local_bb0_div_valid_pipe_0_NO_SHIFT_REG;
 reg local_bb0_div_valid_pipe_1_NO_SHIFT_REG;
 reg local_bb0_div_valid_pipe_2_NO_SHIFT_REG;
 reg local_bb0_div_valid_pipe_3_NO_SHIFT_REG;
 reg local_bb0_div_valid_pipe_4_NO_SHIFT_REG;
 reg local_bb0_div_valid_pipe_5_NO_SHIFT_REG;
 reg local_bb0_div_valid_pipe_6_NO_SHIFT_REG;
 reg local_bb0_div_valid_pipe_7_NO_SHIFT_REG;
 reg local_bb0_div_valid_pipe_8_NO_SHIFT_REG;
 reg local_bb0_div_valid_pipe_9_NO_SHIFT_REG;
 reg local_bb0_div_valid_pipe_10_NO_SHIFT_REG;
 reg local_bb0_div_valid_pipe_11_NO_SHIFT_REG;
 reg local_bb0_div_valid_pipe_12_NO_SHIFT_REG;
wire local_bb0_div_causedstall;

acl_fp_div_s5 fp_module_local_bb0_div (
	.clock(clock),
	.dataa(32'h3E199998),
	.datab(local_bb0_conv7),
	.enable(local_bb0_div_output_regs_ready),
	.result(local_bb0_div)
);


assign local_bb0_div_inputs_ready = local_bb0_conv7_valid_out_NO_SHIFT_REG;
assign local_bb0_div_output_regs_ready = (~(local_bb0_div_wii_reg_NO_SHIFT_REG) & (&(~(local_bb0_div_valid_out_NO_SHIFT_REG) | ~(local_bb0_div_stall_in))));
assign local_bb0_conv7_stall_in = (~(local_bb0_div_wii_reg_NO_SHIFT_REG) & (~(local_bb0_div_output_regs_ready) | ~(local_bb0_div_inputs_ready)));
assign local_bb0_div_causedstall = (local_bb0_div_inputs_ready && (~(local_bb0_div_output_regs_ready) && !(~(local_bb0_div_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_div_valid_pipe_0_NO_SHIFT_REG <= 1'b0;
		local_bb0_div_valid_pipe_1_NO_SHIFT_REG <= 1'b0;
		local_bb0_div_valid_pipe_2_NO_SHIFT_REG <= 1'b0;
		local_bb0_div_valid_pipe_3_NO_SHIFT_REG <= 1'b0;
		local_bb0_div_valid_pipe_4_NO_SHIFT_REG <= 1'b0;
		local_bb0_div_valid_pipe_5_NO_SHIFT_REG <= 1'b0;
		local_bb0_div_valid_pipe_6_NO_SHIFT_REG <= 1'b0;
		local_bb0_div_valid_pipe_7_NO_SHIFT_REG <= 1'b0;
		local_bb0_div_valid_pipe_8_NO_SHIFT_REG <= 1'b0;
		local_bb0_div_valid_pipe_9_NO_SHIFT_REG <= 1'b0;
		local_bb0_div_valid_pipe_10_NO_SHIFT_REG <= 1'b0;
		local_bb0_div_valid_pipe_11_NO_SHIFT_REG <= 1'b0;
		local_bb0_div_valid_pipe_12_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_div_valid_pipe_0_NO_SHIFT_REG <= 1'b0;
			local_bb0_div_valid_pipe_1_NO_SHIFT_REG <= 1'b0;
			local_bb0_div_valid_pipe_2_NO_SHIFT_REG <= 1'b0;
			local_bb0_div_valid_pipe_3_NO_SHIFT_REG <= 1'b0;
			local_bb0_div_valid_pipe_4_NO_SHIFT_REG <= 1'b0;
			local_bb0_div_valid_pipe_5_NO_SHIFT_REG <= 1'b0;
			local_bb0_div_valid_pipe_6_NO_SHIFT_REG <= 1'b0;
			local_bb0_div_valid_pipe_7_NO_SHIFT_REG <= 1'b0;
			local_bb0_div_valid_pipe_8_NO_SHIFT_REG <= 1'b0;
			local_bb0_div_valid_pipe_9_NO_SHIFT_REG <= 1'b0;
			local_bb0_div_valid_pipe_10_NO_SHIFT_REG <= 1'b0;
			local_bb0_div_valid_pipe_11_NO_SHIFT_REG <= 1'b0;
			local_bb0_div_valid_pipe_12_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_div_output_regs_ready)
			begin
				local_bb0_div_valid_pipe_0_NO_SHIFT_REG <= local_bb0_div_inputs_ready;
				local_bb0_div_valid_pipe_1_NO_SHIFT_REG <= local_bb0_div_valid_pipe_0_NO_SHIFT_REG;
				local_bb0_div_valid_pipe_2_NO_SHIFT_REG <= local_bb0_div_valid_pipe_1_NO_SHIFT_REG;
				local_bb0_div_valid_pipe_3_NO_SHIFT_REG <= local_bb0_div_valid_pipe_2_NO_SHIFT_REG;
				local_bb0_div_valid_pipe_4_NO_SHIFT_REG <= local_bb0_div_valid_pipe_3_NO_SHIFT_REG;
				local_bb0_div_valid_pipe_5_NO_SHIFT_REG <= local_bb0_div_valid_pipe_4_NO_SHIFT_REG;
				local_bb0_div_valid_pipe_6_NO_SHIFT_REG <= local_bb0_div_valid_pipe_5_NO_SHIFT_REG;
				local_bb0_div_valid_pipe_7_NO_SHIFT_REG <= local_bb0_div_valid_pipe_6_NO_SHIFT_REG;
				local_bb0_div_valid_pipe_8_NO_SHIFT_REG <= local_bb0_div_valid_pipe_7_NO_SHIFT_REG;
				local_bb0_div_valid_pipe_9_NO_SHIFT_REG <= local_bb0_div_valid_pipe_8_NO_SHIFT_REG;
				local_bb0_div_valid_pipe_10_NO_SHIFT_REG <= local_bb0_div_valid_pipe_9_NO_SHIFT_REG;
				local_bb0_div_valid_pipe_11_NO_SHIFT_REG <= local_bb0_div_valid_pipe_10_NO_SHIFT_REG;
				local_bb0_div_valid_pipe_12_NO_SHIFT_REG <= local_bb0_div_valid_pipe_11_NO_SHIFT_REG;
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_div_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_div_valid_out_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_div_output_regs_ready)
			begin
				local_bb0_div_valid_out_NO_SHIFT_REG <= local_bb0_div_valid_pipe_12_NO_SHIFT_REG;
			end
			else
			begin
				if (~(local_bb0_div_stall_in))
				begin
					local_bb0_div_valid_out_NO_SHIFT_REG <= local_bb0_div_wii_reg_NO_SHIFT_REG;
				end
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_div_wii_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_div_wii_reg_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_div_valid_pipe_12_NO_SHIFT_REG)
			begin
				local_bb0_div_wii_reg_NO_SHIFT_REG <= 1'b1;
			end
		end
	end
end


// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
 reg branch_node_valid_out_NO_SHIFT_REG;
wire branch_var__output_regs_ready;
wire combined_branch_stall_in_signal;
 reg lvb_bb0_cmp1_reg_NO_SHIFT_REG;
 reg [31:0] lvb_bb0_div_reg_NO_SHIFT_REG;
 reg [31:0] lvb_input_global_id_0_reg_NO_SHIFT_REG;

assign branch_var__inputs_ready = (local_bb0_div_valid_out_NO_SHIFT_REG & local_bb0_cmp1_valid_out_NO_SHIFT_REG & merge_node_valid_out_2_NO_SHIFT_REG);
assign branch_var__output_regs_ready = (~(stall_in) | ~(branch_node_valid_out_NO_SHIFT_REG));
assign local_bb0_div_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign local_bb0_cmp1_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign merge_node_stall_in_2 = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign lvb_bb0_cmp1 = lvb_bb0_cmp1_reg_NO_SHIFT_REG;
assign lvb_bb0_div = lvb_bb0_div_reg_NO_SHIFT_REG;
assign lvb_input_global_id_0 = lvb_input_global_id_0_reg_NO_SHIFT_REG;
assign valid_out = branch_node_valid_out_NO_SHIFT_REG;
assign combined_branch_stall_in_signal = stall_in;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		branch_node_valid_out_NO_SHIFT_REG <= 1'b0;
		lvb_bb0_cmp1_reg_NO_SHIFT_REG <= 'x;
		lvb_bb0_div_reg_NO_SHIFT_REG <= 'x;
		lvb_input_global_id_0_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (branch_var__output_regs_ready)
		begin
			branch_node_valid_out_NO_SHIFT_REG <= branch_var__inputs_ready;
			lvb_bb0_cmp1_reg_NO_SHIFT_REG <= local_bb0_cmp1_NO_SHIFT_REG;
			lvb_bb0_div_reg_NO_SHIFT_REG <= local_bb0_div;
			lvb_input_global_id_0_reg_NO_SHIFT_REG <= local_lvm_input_global_id_0_NO_SHIFT_REG;
		end
		else
		begin
			if (~(combined_branch_stall_in_signal))
			begin
				branch_node_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module gather_basic_block_1
	(
		input 		clock,
		input 		resetn,
		input [63:0] 		input_msg_arr,
		input [31:0] 		input_num_edges,
		input 		input_wii_cmp1,
		input [31:0] 		input_wii_div,
		input 		valid_in_0,
		output 		stall_out_0,
		input [63:0] 		input_indvars_iv_0,
		input [31:0] 		input_rank_new_02_0,
		input [31:0] 		input_global_id_0_0,
		input 		valid_in_1,
		output 		stall_out_1,
		input [63:0] 		input_indvars_iv_1,
		input [31:0] 		input_rank_new_02_1,
		input [31:0] 		input_global_id_0_1,
		output 		valid_out_0,
		input 		stall_in_0,
		output [63:0] 		lvb_bb1_indvars_iv_next_0,
		output [31:0] 		lvb_bb1_c0_exe1_0,
		output [31:0] 		lvb_input_global_id_0_0,
		output 		valid_out_1,
		input 		stall_in_1,
		output [63:0] 		lvb_bb1_indvars_iv_next_1,
		output [31:0] 		lvb_bb1_c0_exe1_1,
		output [31:0] 		lvb_input_global_id_0_1,
		input [31:0] 		workgroup_size,
		input 		start,
		input [255:0] 		avm_local_bb1_ld__readdata,
		input 		avm_local_bb1_ld__readdatavalid,
		input 		avm_local_bb1_ld__waitrequest,
		output [29:0] 		avm_local_bb1_ld__address,
		output 		avm_local_bb1_ld__read,
		output 		avm_local_bb1_ld__write,
		input 		avm_local_bb1_ld__writeack,
		output [255:0] 		avm_local_bb1_ld__writedata,
		output [31:0] 		avm_local_bb1_ld__byteenable,
		output [4:0] 		avm_local_bb1_ld__burstcount,
		output 		local_bb1_ld__active,
		input 		clock2x,
		input [255:0] 		avm_local_bb1_ld__u0_readdata,
		input 		avm_local_bb1_ld__u0_readdatavalid,
		input 		avm_local_bb1_ld__u0_waitrequest,
		output [29:0] 		avm_local_bb1_ld__u0_address,
		output 		avm_local_bb1_ld__u0_read,
		output 		avm_local_bb1_ld__u0_write,
		input 		avm_local_bb1_ld__u0_writeack,
		output [255:0] 		avm_local_bb1_ld__u0_writedata,
		output [31:0] 		avm_local_bb1_ld__u0_byteenable,
		output [4:0] 		avm_local_bb1_ld__u0_burstcount,
		output 		local_bb1_ld__u0_active
	);


// Values used for debugging.  These are swept away by synthesis.
wire _entry;
wire _exit;
 reg [31:0] _num_entry_NO_SHIFT_REG;
 reg [31:0] _num_exit_NO_SHIFT_REG;
wire [31:0] _num_live;

assign _entry = ((valid_in_0 & valid_in_1) & ~((stall_out_0 | stall_out_1)));
assign _exit = ((valid_out_0 & valid_out_1) & ~((stall_in_0 | stall_in_1)));
assign _num_live = (_num_entry_NO_SHIFT_REG - _num_exit_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		_num_entry_NO_SHIFT_REG <= 32'h0;
		_num_exit_NO_SHIFT_REG <= 32'h0;
	end
	else
	begin
		if (_entry)
		begin
			_num_entry_NO_SHIFT_REG <= (_num_entry_NO_SHIFT_REG + 2'h1);
		end
		if (_exit)
		begin
			_num_exit_NO_SHIFT_REG <= (_num_exit_NO_SHIFT_REG + 2'h1);
		end
	end
end



// This section defines the behaviour of the MERGE node
wire merge_node_stall_in_0;
 reg merge_node_valid_out_0_NO_SHIFT_REG;
wire merge_node_stall_in_1;
 reg merge_node_valid_out_1_NO_SHIFT_REG;
wire merge_node_stall_in_2;
 reg merge_node_valid_out_2_NO_SHIFT_REG;
wire merge_node_stall_in_3;
 reg merge_node_valid_out_3_NO_SHIFT_REG;
wire merge_node_stall_in_4;
 reg merge_node_valid_out_4_NO_SHIFT_REG;
wire merge_node_stall_in_5;
 reg merge_node_valid_out_5_NO_SHIFT_REG;
wire merge_stalled_by_successors;
 reg merge_block_selector_NO_SHIFT_REG;
 reg merge_node_valid_in_0_staging_reg_NO_SHIFT_REG;
 reg [63:0] input_indvars_iv_0_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_rank_new_02_0_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_global_id_0_0_staging_reg_NO_SHIFT_REG;
 reg [63:0] local_lvm_indvars_iv_NO_SHIFT_REG;
 reg [31:0] local_lvm_rank_new_02_NO_SHIFT_REG;
 reg [31:0] local_lvm_input_global_id_0_NO_SHIFT_REG;
 reg merge_node_valid_in_1_staging_reg_NO_SHIFT_REG;
 reg [63:0] input_indvars_iv_1_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_rank_new_02_1_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_global_id_0_1_staging_reg_NO_SHIFT_REG;
 reg is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
 reg invariant_valid_NO_SHIFT_REG;

assign merge_stalled_by_successors = ((merge_node_stall_in_0 & merge_node_valid_out_0_NO_SHIFT_REG) | (merge_node_stall_in_1 & merge_node_valid_out_1_NO_SHIFT_REG) | (merge_node_stall_in_2 & merge_node_valid_out_2_NO_SHIFT_REG) | (merge_node_stall_in_3 & merge_node_valid_out_3_NO_SHIFT_REG) | (merge_node_stall_in_4 & merge_node_valid_out_4_NO_SHIFT_REG) | (merge_node_stall_in_5 & merge_node_valid_out_5_NO_SHIFT_REG));
assign stall_out_0 = merge_node_valid_in_0_staging_reg_NO_SHIFT_REG;
assign stall_out_1 = merge_node_valid_in_1_staging_reg_NO_SHIFT_REG;

always @(*)
begin
	if ((merge_node_valid_in_0_staging_reg_NO_SHIFT_REG | valid_in_0))
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b1;
	end
	else
	begin
		if ((merge_node_valid_in_1_staging_reg_NO_SHIFT_REG | valid_in_1))
		begin
			merge_block_selector_NO_SHIFT_REG = 1'b1;
			is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b1;
		end
		else
		begin
			merge_block_selector_NO_SHIFT_REG = 1'b0;
			is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b0;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		input_indvars_iv_0_staging_reg_NO_SHIFT_REG <= 'x;
		input_rank_new_02_0_staging_reg_NO_SHIFT_REG <= 'x;
		input_global_id_0_0_staging_reg_NO_SHIFT_REG <= 'x;
		merge_node_valid_in_0_staging_reg_NO_SHIFT_REG <= 1'b0;
		input_indvars_iv_1_staging_reg_NO_SHIFT_REG <= 'x;
		input_rank_new_02_1_staging_reg_NO_SHIFT_REG <= 'x;
		input_global_id_0_1_staging_reg_NO_SHIFT_REG <= 'x;
		merge_node_valid_in_1_staging_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (((merge_block_selector_NO_SHIFT_REG != 1'b0) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_0_staging_reg_NO_SHIFT_REG))
			begin
				input_indvars_iv_0_staging_reg_NO_SHIFT_REG <= input_indvars_iv_0;
				input_rank_new_02_0_staging_reg_NO_SHIFT_REG <= input_rank_new_02_0;
				input_global_id_0_0_staging_reg_NO_SHIFT_REG <= input_global_id_0_0;
				merge_node_valid_in_0_staging_reg_NO_SHIFT_REG <= valid_in_0;
			end
		end
		else
		begin
			merge_node_valid_in_0_staging_reg_NO_SHIFT_REG <= 1'b0;
		end
		if (((merge_block_selector_NO_SHIFT_REG != 1'b1) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_1_staging_reg_NO_SHIFT_REG))
			begin
				input_indvars_iv_1_staging_reg_NO_SHIFT_REG <= input_indvars_iv_1;
				input_rank_new_02_1_staging_reg_NO_SHIFT_REG <= input_rank_new_02_1;
				input_global_id_0_1_staging_reg_NO_SHIFT_REG <= input_global_id_0_1;
				merge_node_valid_in_1_staging_reg_NO_SHIFT_REG <= valid_in_1;
			end
		end
		else
		begin
			merge_node_valid_in_1_staging_reg_NO_SHIFT_REG <= 1'b0;
		end
	end
end

always @(posedge clock)
begin
	if (~(merge_stalled_by_successors))
	begin
		case (merge_block_selector_NO_SHIFT_REG)
			1'b0:
			begin
				if (merge_node_valid_in_0_staging_reg_NO_SHIFT_REG)
				begin
					local_lvm_indvars_iv_NO_SHIFT_REG <= input_indvars_iv_0_staging_reg_NO_SHIFT_REG;
					local_lvm_rank_new_02_NO_SHIFT_REG <= input_rank_new_02_0_staging_reg_NO_SHIFT_REG;
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0_0_staging_reg_NO_SHIFT_REG;
				end
				else
				begin
					local_lvm_indvars_iv_NO_SHIFT_REG <= input_indvars_iv_0;
					local_lvm_rank_new_02_NO_SHIFT_REG <= input_rank_new_02_0;
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0_0;
				end
			end

			1'b1:
			begin
				if (merge_node_valid_in_1_staging_reg_NO_SHIFT_REG)
				begin
					local_lvm_indvars_iv_NO_SHIFT_REG <= input_indvars_iv_1_staging_reg_NO_SHIFT_REG;
					local_lvm_rank_new_02_NO_SHIFT_REG <= input_rank_new_02_1_staging_reg_NO_SHIFT_REG;
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0_1_staging_reg_NO_SHIFT_REG;
				end
				else
				begin
					local_lvm_indvars_iv_NO_SHIFT_REG <= input_indvars_iv_1;
					local_lvm_rank_new_02_NO_SHIFT_REG <= input_rank_new_02_1;
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0_1;
				end
			end

			default:
			begin
			end

		endcase
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		merge_node_valid_out_0_NO_SHIFT_REG <= 1'b0;
		merge_node_valid_out_1_NO_SHIFT_REG <= 1'b0;
		merge_node_valid_out_2_NO_SHIFT_REG <= 1'b0;
		merge_node_valid_out_3_NO_SHIFT_REG <= 1'b0;
		merge_node_valid_out_4_NO_SHIFT_REG <= 1'b0;
		merge_node_valid_out_5_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (~(merge_stalled_by_successors))
		begin
			merge_node_valid_out_0_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
			merge_node_valid_out_1_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
			merge_node_valid_out_2_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
			merge_node_valid_out_3_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
			merge_node_valid_out_4_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
			merge_node_valid_out_5_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
		end
		else
		begin
			if (~(merge_node_stall_in_0))
			begin
				merge_node_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(merge_node_stall_in_1))
			begin
				merge_node_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
			if (~(merge_node_stall_in_2))
			begin
				merge_node_valid_out_2_NO_SHIFT_REG <= 1'b0;
			end
			if (~(merge_node_stall_in_3))
			begin
				merge_node_valid_out_3_NO_SHIFT_REG <= 1'b0;
			end
			if (~(merge_node_stall_in_4))
			begin
				merge_node_valid_out_4_NO_SHIFT_REG <= 1'b0;
			end
			if (~(merge_node_stall_in_5))
			begin
				merge_node_valid_out_5_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		invariant_valid_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		invariant_valid_NO_SHIFT_REG <= (~(start) & (invariant_valid_NO_SHIFT_REG | is_merge_data_to_local_regs_valid_NO_SHIFT_REG));
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_dest_valid_out;
wire local_bb1_dest_stall_in;
wire local_bb1_dest_inputs_ready;
wire local_bb1_dest_stall_local;
wire [63:0] local_bb1_dest;

assign local_bb1_dest_inputs_ready = merge_node_valid_out_0_NO_SHIFT_REG;
assign local_bb1_dest = (input_msg_arr + (local_lvm_indvars_iv_NO_SHIFT_REG << 6'h3));
assign local_bb1_dest_valid_out = local_bb1_dest_inputs_ready;
assign local_bb1_dest_stall_local = local_bb1_dest_stall_in;
assign merge_node_stall_in_0 = (|local_bb1_dest_stall_local);

// Register node:
//  * latency = 159
//  * capacity = 159
 logic rnode_1to160_input_msg_arr_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to160_input_msg_arr_0_stall_in_NO_SHIFT_REG;
 logic rnode_1to160_input_msg_arr_0_reg_160_inputs_ready_NO_SHIFT_REG;
 logic rnode_1to160_input_msg_arr_0_valid_out_reg_160_NO_SHIFT_REG;
 logic rnode_1to160_input_msg_arr_0_stall_in_reg_160_NO_SHIFT_REG;
 logic rnode_1to160_input_msg_arr_0_stall_out_reg_160_NO_SHIFT_REG;

acl_data_fifo rnode_1to160_input_msg_arr_0_reg_160_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to160_input_msg_arr_0_reg_160_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to160_input_msg_arr_0_stall_in_reg_160_NO_SHIFT_REG),
	.valid_out(rnode_1to160_input_msg_arr_0_valid_out_reg_160_NO_SHIFT_REG),
	.stall_out(rnode_1to160_input_msg_arr_0_stall_out_reg_160_NO_SHIFT_REG),
	.data_in(),
	.data_out()
);

defparam rnode_1to160_input_msg_arr_0_reg_160_fifo.DEPTH = 160;
defparam rnode_1to160_input_msg_arr_0_reg_160_fifo.DATA_WIDTH = 0;
defparam rnode_1to160_input_msg_arr_0_reg_160_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to160_input_msg_arr_0_reg_160_fifo.IMPL = "ram";

assign rnode_1to160_input_msg_arr_0_reg_160_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_2_NO_SHIFT_REG;
assign merge_node_stall_in_2 = rnode_1to160_input_msg_arr_0_stall_out_reg_160_NO_SHIFT_REG;
assign rnode_1to160_input_msg_arr_0_stall_in_reg_160_NO_SHIFT_REG = rnode_1to160_input_msg_arr_0_stall_in_NO_SHIFT_REG;
assign rnode_1to160_input_msg_arr_0_valid_out_NO_SHIFT_REG = rnode_1to160_input_msg_arr_0_valid_out_reg_160_NO_SHIFT_REG;

// Register node:
//  * latency = 319
//  * capacity = 319
 logic rnode_1to320_rank_new_02_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to320_rank_new_02_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_1to320_rank_new_02_0_NO_SHIFT_REG;
 logic rnode_1to320_rank_new_02_0_reg_320_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_1to320_rank_new_02_0_reg_320_NO_SHIFT_REG;
 logic rnode_1to320_rank_new_02_0_valid_out_reg_320_NO_SHIFT_REG;
 logic rnode_1to320_rank_new_02_0_stall_in_reg_320_NO_SHIFT_REG;
 logic rnode_1to320_rank_new_02_0_stall_out_reg_320_NO_SHIFT_REG;

acl_data_fifo rnode_1to320_rank_new_02_0_reg_320_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to320_rank_new_02_0_reg_320_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to320_rank_new_02_0_stall_in_reg_320_NO_SHIFT_REG),
	.valid_out(rnode_1to320_rank_new_02_0_valid_out_reg_320_NO_SHIFT_REG),
	.stall_out(rnode_1to320_rank_new_02_0_stall_out_reg_320_NO_SHIFT_REG),
	.data_in(local_lvm_rank_new_02_NO_SHIFT_REG),
	.data_out(rnode_1to320_rank_new_02_0_reg_320_NO_SHIFT_REG)
);

defparam rnode_1to320_rank_new_02_0_reg_320_fifo.DEPTH = 320;
defparam rnode_1to320_rank_new_02_0_reg_320_fifo.DATA_WIDTH = 32;
defparam rnode_1to320_rank_new_02_0_reg_320_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to320_rank_new_02_0_reg_320_fifo.IMPL = "ram";

assign rnode_1to320_rank_new_02_0_reg_320_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_3_NO_SHIFT_REG;
assign merge_node_stall_in_3 = rnode_1to320_rank_new_02_0_stall_out_reg_320_NO_SHIFT_REG;
assign rnode_1to320_rank_new_02_0_NO_SHIFT_REG = rnode_1to320_rank_new_02_0_reg_320_NO_SHIFT_REG;
assign rnode_1to320_rank_new_02_0_stall_in_reg_320_NO_SHIFT_REG = rnode_1to320_rank_new_02_0_stall_in_NO_SHIFT_REG;
assign rnode_1to320_rank_new_02_0_valid_out_NO_SHIFT_REG = rnode_1to320_rank_new_02_0_valid_out_reg_320_NO_SHIFT_REG;

// Register node:
//  * latency = 159
//  * capacity = 159
 logic rnode_1to160_indvars_iv_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to160_indvars_iv_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_1to160_indvars_iv_0_NO_SHIFT_REG;
 logic rnode_1to160_indvars_iv_0_reg_160_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_1to160_indvars_iv_0_reg_160_NO_SHIFT_REG;
 logic rnode_1to160_indvars_iv_0_valid_out_reg_160_NO_SHIFT_REG;
 logic rnode_1to160_indvars_iv_0_stall_in_reg_160_NO_SHIFT_REG;
 logic rnode_1to160_indvars_iv_0_stall_out_reg_160_NO_SHIFT_REG;

acl_data_fifo rnode_1to160_indvars_iv_0_reg_160_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to160_indvars_iv_0_reg_160_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to160_indvars_iv_0_stall_in_reg_160_NO_SHIFT_REG),
	.valid_out(rnode_1to160_indvars_iv_0_valid_out_reg_160_NO_SHIFT_REG),
	.stall_out(rnode_1to160_indvars_iv_0_stall_out_reg_160_NO_SHIFT_REG),
	.data_in(local_lvm_indvars_iv_NO_SHIFT_REG),
	.data_out(rnode_1to160_indvars_iv_0_reg_160_NO_SHIFT_REG)
);

defparam rnode_1to160_indvars_iv_0_reg_160_fifo.DEPTH = 160;
defparam rnode_1to160_indvars_iv_0_reg_160_fifo.DATA_WIDTH = 64;
defparam rnode_1to160_indvars_iv_0_reg_160_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to160_indvars_iv_0_reg_160_fifo.IMPL = "ram";

assign rnode_1to160_indvars_iv_0_reg_160_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_4_NO_SHIFT_REG;
assign merge_node_stall_in_4 = rnode_1to160_indvars_iv_0_stall_out_reg_160_NO_SHIFT_REG;
assign rnode_1to160_indvars_iv_0_NO_SHIFT_REG = rnode_1to160_indvars_iv_0_reg_160_NO_SHIFT_REG;
assign rnode_1to160_indvars_iv_0_stall_in_reg_160_NO_SHIFT_REG = rnode_1to160_indvars_iv_0_stall_in_NO_SHIFT_REG;
assign rnode_1to160_indvars_iv_0_valid_out_NO_SHIFT_REG = rnode_1to160_indvars_iv_0_valid_out_reg_160_NO_SHIFT_REG;

// Register node:
//  * latency = 159
//  * capacity = 159
 logic rnode_1to160_input_global_id_0_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to160_input_global_id_0_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_1to160_input_global_id_0_0_NO_SHIFT_REG;
 logic rnode_1to160_input_global_id_0_0_reg_160_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_1to160_input_global_id_0_0_reg_160_NO_SHIFT_REG;
 logic rnode_1to160_input_global_id_0_0_valid_out_reg_160_NO_SHIFT_REG;
 logic rnode_1to160_input_global_id_0_0_stall_in_reg_160_NO_SHIFT_REG;
 logic rnode_1to160_input_global_id_0_0_stall_out_reg_160_NO_SHIFT_REG;

acl_data_fifo rnode_1to160_input_global_id_0_0_reg_160_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to160_input_global_id_0_0_reg_160_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to160_input_global_id_0_0_stall_in_reg_160_NO_SHIFT_REG),
	.valid_out(rnode_1to160_input_global_id_0_0_valid_out_reg_160_NO_SHIFT_REG),
	.stall_out(rnode_1to160_input_global_id_0_0_stall_out_reg_160_NO_SHIFT_REG),
	.data_in(local_lvm_input_global_id_0_NO_SHIFT_REG),
	.data_out(rnode_1to160_input_global_id_0_0_reg_160_NO_SHIFT_REG)
);

defparam rnode_1to160_input_global_id_0_0_reg_160_fifo.DEPTH = 160;
defparam rnode_1to160_input_global_id_0_0_reg_160_fifo.DATA_WIDTH = 32;
defparam rnode_1to160_input_global_id_0_0_reg_160_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to160_input_global_id_0_0_reg_160_fifo.IMPL = "ram";

assign rnode_1to160_input_global_id_0_0_reg_160_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_5_NO_SHIFT_REG;
assign merge_node_stall_in_5 = rnode_1to160_input_global_id_0_0_stall_out_reg_160_NO_SHIFT_REG;
assign rnode_1to160_input_global_id_0_0_NO_SHIFT_REG = rnode_1to160_input_global_id_0_0_reg_160_NO_SHIFT_REG;
assign rnode_1to160_input_global_id_0_0_stall_in_reg_160_NO_SHIFT_REG = rnode_1to160_input_global_id_0_0_stall_in_NO_SHIFT_REG;
assign rnode_1to160_input_global_id_0_0_valid_out_NO_SHIFT_REG = rnode_1to160_input_global_id_0_0_valid_out_reg_160_NO_SHIFT_REG;

// This section implements a registered operation.
// 
wire local_bb1_ld__inputs_ready;
 reg local_bb1_ld__valid_out_NO_SHIFT_REG;
wire local_bb1_ld__stall_in;
wire local_bb1_ld__output_regs_ready;
wire local_bb1_ld__fu_stall_out;
wire local_bb1_ld__fu_valid_out;
wire [31:0] local_bb1_ld__lsu_dataout;
 reg [31:0] local_bb1_ld__NO_SHIFT_REG;
wire local_bb1_ld__causedstall;

lsu_top lsu_local_bb1_ld_ (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(),
	.stream_size(),
	.stream_reset(),
	.o_stall(local_bb1_ld__fu_stall_out),
	.i_valid(local_bb1_ld__inputs_ready),
	.i_address(local_bb1_dest),
	.i_writedata(),
	.i_cmpdata(),
	.i_predicate(input_wii_cmp1),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb1_ld__output_regs_ready)),
	.o_valid(local_bb1_ld__fu_valid_out),
	.o_readdata(local_bb1_ld__lsu_dataout),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb1_ld__active),
	.avm_address(avm_local_bb1_ld__address),
	.avm_read(avm_local_bb1_ld__read),
	.avm_readdata(avm_local_bb1_ld__readdata),
	.avm_write(avm_local_bb1_ld__write),
	.avm_writeack(avm_local_bb1_ld__writeack),
	.avm_burstcount(avm_local_bb1_ld__burstcount),
	.avm_writedata(avm_local_bb1_ld__writedata),
	.avm_byteenable(avm_local_bb1_ld__byteenable),
	.avm_waitrequest(avm_local_bb1_ld__waitrequest),
	.avm_readdatavalid(avm_local_bb1_ld__readdatavalid),
	.profile_bw(),
	.profile_bw_incr(),
	.profile_total_ivalid(),
	.profile_total_req(),
	.profile_i_stall_count(),
	.profile_o_stall_count(),
	.profile_avm_readwrite_count(),
	.profile_avm_burstcount_total(),
	.profile_avm_burstcount_total_incr(),
	.profile_req_cache_hit_count(),
	.profile_extra_unaligned_reqs(),
	.profile_avm_stall()
);

defparam lsu_local_bb1_ld_.AWIDTH = 30;
defparam lsu_local_bb1_ld_.WIDTH_BYTES = 4;
defparam lsu_local_bb1_ld_.MWIDTH_BYTES = 32;
defparam lsu_local_bb1_ld_.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb1_ld_.ALIGNMENT_BYTES = 8;
defparam lsu_local_bb1_ld_.READ = 1;
defparam lsu_local_bb1_ld_.ATOMIC = 0;
defparam lsu_local_bb1_ld_.WIDTH = 32;
defparam lsu_local_bb1_ld_.MWIDTH = 256;
defparam lsu_local_bb1_ld_.ATOMIC_WIDTH = 3;
defparam lsu_local_bb1_ld_.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb1_ld_.KERNEL_SIDE_MEM_LATENCY = 160;
defparam lsu_local_bb1_ld_.MEMORY_SIDE_MEM_LATENCY = 122;
defparam lsu_local_bb1_ld_.USE_WRITE_ACK = 0;
defparam lsu_local_bb1_ld_.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb1_ld_.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb1_ld_.NUMBER_BANKS = 1;
defparam lsu_local_bb1_ld_.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb1_ld_.USEINPUTFIFO = 0;
defparam lsu_local_bb1_ld_.USECACHING = 1;
defparam lsu_local_bb1_ld_.CACHESIZE = 256;
defparam lsu_local_bb1_ld_.USEOUTPUTFIFO = 1;
defparam lsu_local_bb1_ld_.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb1_ld_.HIGH_FMAX = 1;
defparam lsu_local_bb1_ld_.ADDRSPACE = 1;
defparam lsu_local_bb1_ld_.STYLE = "BURST-COALESCED";

assign local_bb1_ld__inputs_ready = (local_bb1_dest_valid_out & merge_node_valid_out_1_NO_SHIFT_REG);
assign local_bb1_ld__output_regs_ready = (&(~(local_bb1_ld__valid_out_NO_SHIFT_REG) | ~(local_bb1_ld__stall_in)));
assign local_bb1_dest_stall_in = (local_bb1_ld__fu_stall_out | ~(local_bb1_ld__inputs_ready));
assign merge_node_stall_in_1 = (local_bb1_ld__fu_stall_out | ~(local_bb1_ld__inputs_ready));
assign local_bb1_ld__causedstall = (local_bb1_ld__inputs_ready && (local_bb1_ld__fu_stall_out && !(~(local_bb1_ld__output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_ld__NO_SHIFT_REG <= 'x;
		local_bb1_ld__valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_ld__output_regs_ready)
		begin
			local_bb1_ld__NO_SHIFT_REG <= local_bb1_ld__lsu_dataout;
			local_bb1_ld__valid_out_NO_SHIFT_REG <= local_bb1_ld__fu_valid_out;
		end
		else
		begin
			if (~(local_bb1_ld__stall_in))
			begin
				local_bb1_ld__valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_160to161_input_msg_arr_0_valid_out_NO_SHIFT_REG;
 logic rnode_160to161_input_msg_arr_0_stall_in_NO_SHIFT_REG;
 logic rnode_160to161_input_msg_arr_0_reg_161_inputs_ready_NO_SHIFT_REG;
 logic rnode_160to161_input_msg_arr_0_valid_out_reg_161_NO_SHIFT_REG;
 logic rnode_160to161_input_msg_arr_0_stall_in_reg_161_NO_SHIFT_REG;
 logic rnode_160to161_input_msg_arr_0_stall_out_reg_161_NO_SHIFT_REG;

acl_data_fifo rnode_160to161_input_msg_arr_0_reg_161_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_160to161_input_msg_arr_0_reg_161_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_160to161_input_msg_arr_0_stall_in_reg_161_NO_SHIFT_REG),
	.valid_out(rnode_160to161_input_msg_arr_0_valid_out_reg_161_NO_SHIFT_REG),
	.stall_out(rnode_160to161_input_msg_arr_0_stall_out_reg_161_NO_SHIFT_REG),
	.data_in(),
	.data_out()
);

defparam rnode_160to161_input_msg_arr_0_reg_161_fifo.DEPTH = 2;
defparam rnode_160to161_input_msg_arr_0_reg_161_fifo.DATA_WIDTH = 0;
defparam rnode_160to161_input_msg_arr_0_reg_161_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_160to161_input_msg_arr_0_reg_161_fifo.IMPL = "ll_reg";

assign rnode_160to161_input_msg_arr_0_reg_161_inputs_ready_NO_SHIFT_REG = rnode_1to160_input_msg_arr_0_valid_out_NO_SHIFT_REG;
assign rnode_1to160_input_msg_arr_0_stall_in_NO_SHIFT_REG = rnode_160to161_input_msg_arr_0_stall_out_reg_161_NO_SHIFT_REG;
assign rnode_160to161_input_msg_arr_0_stall_in_reg_161_NO_SHIFT_REG = rnode_160to161_input_msg_arr_0_stall_in_NO_SHIFT_REG;
assign rnode_160to161_input_msg_arr_0_valid_out_NO_SHIFT_REG = rnode_160to161_input_msg_arr_0_valid_out_reg_161_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_320to321_rank_new_02_0_valid_out_NO_SHIFT_REG;
 logic rnode_320to321_rank_new_02_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_320to321_rank_new_02_0_NO_SHIFT_REG;
 logic rnode_320to321_rank_new_02_0_reg_321_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_320to321_rank_new_02_0_reg_321_NO_SHIFT_REG;
 logic rnode_320to321_rank_new_02_0_valid_out_reg_321_NO_SHIFT_REG;
 logic rnode_320to321_rank_new_02_0_stall_in_reg_321_NO_SHIFT_REG;
 logic rnode_320to321_rank_new_02_0_stall_out_reg_321_NO_SHIFT_REG;

acl_data_fifo rnode_320to321_rank_new_02_0_reg_321_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_320to321_rank_new_02_0_reg_321_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_320to321_rank_new_02_0_stall_in_reg_321_NO_SHIFT_REG),
	.valid_out(rnode_320to321_rank_new_02_0_valid_out_reg_321_NO_SHIFT_REG),
	.stall_out(rnode_320to321_rank_new_02_0_stall_out_reg_321_NO_SHIFT_REG),
	.data_in(rnode_1to320_rank_new_02_0_NO_SHIFT_REG),
	.data_out(rnode_320to321_rank_new_02_0_reg_321_NO_SHIFT_REG)
);

defparam rnode_320to321_rank_new_02_0_reg_321_fifo.DEPTH = 2;
defparam rnode_320to321_rank_new_02_0_reg_321_fifo.DATA_WIDTH = 32;
defparam rnode_320to321_rank_new_02_0_reg_321_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_320to321_rank_new_02_0_reg_321_fifo.IMPL = "ll_reg";

assign rnode_320to321_rank_new_02_0_reg_321_inputs_ready_NO_SHIFT_REG = rnode_1to320_rank_new_02_0_valid_out_NO_SHIFT_REG;
assign rnode_1to320_rank_new_02_0_stall_in_NO_SHIFT_REG = rnode_320to321_rank_new_02_0_stall_out_reg_321_NO_SHIFT_REG;
assign rnode_320to321_rank_new_02_0_NO_SHIFT_REG = rnode_320to321_rank_new_02_0_reg_321_NO_SHIFT_REG;
assign rnode_320to321_rank_new_02_0_stall_in_reg_321_NO_SHIFT_REG = rnode_320to321_rank_new_02_0_stall_in_NO_SHIFT_REG;
assign rnode_320to321_rank_new_02_0_valid_out_NO_SHIFT_REG = rnode_320to321_rank_new_02_0_valid_out_reg_321_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_160to161_indvars_iv_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_160to161_indvars_iv_0_stall_in_0_NO_SHIFT_REG;
 logic [63:0] rnode_160to161_indvars_iv_0_NO_SHIFT_REG;
 logic rnode_160to161_indvars_iv_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_160to161_indvars_iv_0_stall_in_1_NO_SHIFT_REG;
 logic [63:0] rnode_160to161_indvars_iv_1_NO_SHIFT_REG;
 logic rnode_160to161_indvars_iv_0_reg_161_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_160to161_indvars_iv_0_reg_161_NO_SHIFT_REG;
 logic rnode_160to161_indvars_iv_0_valid_out_0_reg_161_NO_SHIFT_REG;
 logic rnode_160to161_indvars_iv_0_stall_in_0_reg_161_NO_SHIFT_REG;
 logic rnode_160to161_indvars_iv_0_stall_out_reg_161_NO_SHIFT_REG;
 logic [63:0] rnode_160to161_indvars_iv_0_reg_161_NO_SHIFT_REG_fa;

acl_multi_fanout_adaptor rnode_160to161_indvars_iv_0_reg_161_fanout_adaptor (
	.clock(clock),
	.resetn(resetn),
	.data_in(rnode_160to161_indvars_iv_0_reg_161_NO_SHIFT_REG),
	.valid_in(rnode_160to161_indvars_iv_0_valid_out_0_reg_161_NO_SHIFT_REG),
	.stall_out(rnode_160to161_indvars_iv_0_stall_in_0_reg_161_NO_SHIFT_REG),
	.data_out(rnode_160to161_indvars_iv_0_reg_161_NO_SHIFT_REG_fa),
	.valid_out({rnode_160to161_indvars_iv_0_valid_out_0_NO_SHIFT_REG, rnode_160to161_indvars_iv_0_valid_out_1_NO_SHIFT_REG}),
	.stall_in({rnode_160to161_indvars_iv_0_stall_in_0_NO_SHIFT_REG, rnode_160to161_indvars_iv_0_stall_in_1_NO_SHIFT_REG})
);

defparam rnode_160to161_indvars_iv_0_reg_161_fanout_adaptor.DATA_WIDTH = 64;
defparam rnode_160to161_indvars_iv_0_reg_161_fanout_adaptor.NUM_FANOUTS = 2;

acl_data_fifo rnode_160to161_indvars_iv_0_reg_161_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_160to161_indvars_iv_0_reg_161_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_160to161_indvars_iv_0_stall_in_0_reg_161_NO_SHIFT_REG),
	.valid_out(rnode_160to161_indvars_iv_0_valid_out_0_reg_161_NO_SHIFT_REG),
	.stall_out(rnode_160to161_indvars_iv_0_stall_out_reg_161_NO_SHIFT_REG),
	.data_in(rnode_1to160_indvars_iv_0_NO_SHIFT_REG),
	.data_out(rnode_160to161_indvars_iv_0_reg_161_NO_SHIFT_REG)
);

defparam rnode_160to161_indvars_iv_0_reg_161_fifo.DEPTH = 2;
defparam rnode_160to161_indvars_iv_0_reg_161_fifo.DATA_WIDTH = 64;
defparam rnode_160to161_indvars_iv_0_reg_161_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_160to161_indvars_iv_0_reg_161_fifo.IMPL = "ll_reg";

assign rnode_160to161_indvars_iv_0_reg_161_inputs_ready_NO_SHIFT_REG = rnode_1to160_indvars_iv_0_valid_out_NO_SHIFT_REG;
assign rnode_1to160_indvars_iv_0_stall_in_NO_SHIFT_REG = rnode_160to161_indvars_iv_0_stall_out_reg_161_NO_SHIFT_REG;
assign rnode_160to161_indvars_iv_0_NO_SHIFT_REG = rnode_160to161_indvars_iv_0_reg_161_NO_SHIFT_REG_fa;
assign rnode_160to161_indvars_iv_1_NO_SHIFT_REG = rnode_160to161_indvars_iv_0_reg_161_NO_SHIFT_REG_fa;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_160to161_input_global_id_0_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_160to161_input_global_id_0_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_160to161_input_global_id_0_0_NO_SHIFT_REG;
 logic rnode_160to161_input_global_id_0_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_160to161_input_global_id_0_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_160to161_input_global_id_0_1_NO_SHIFT_REG;
 logic rnode_160to161_input_global_id_0_0_reg_161_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_160to161_input_global_id_0_0_reg_161_NO_SHIFT_REG;
 logic rnode_160to161_input_global_id_0_0_valid_out_0_reg_161_NO_SHIFT_REG;
 logic rnode_160to161_input_global_id_0_0_stall_in_0_reg_161_NO_SHIFT_REG;
 logic rnode_160to161_input_global_id_0_0_stall_out_reg_161_NO_SHIFT_REG;
 logic [31:0] rnode_160to161_input_global_id_0_0_reg_161_NO_SHIFT_REG_fa;

acl_multi_fanout_adaptor rnode_160to161_input_global_id_0_0_reg_161_fanout_adaptor (
	.clock(clock),
	.resetn(resetn),
	.data_in(rnode_160to161_input_global_id_0_0_reg_161_NO_SHIFT_REG),
	.valid_in(rnode_160to161_input_global_id_0_0_valid_out_0_reg_161_NO_SHIFT_REG),
	.stall_out(rnode_160to161_input_global_id_0_0_stall_in_0_reg_161_NO_SHIFT_REG),
	.data_out(rnode_160to161_input_global_id_0_0_reg_161_NO_SHIFT_REG_fa),
	.valid_out({rnode_160to161_input_global_id_0_0_valid_out_0_NO_SHIFT_REG, rnode_160to161_input_global_id_0_0_valid_out_1_NO_SHIFT_REG}),
	.stall_in({rnode_160to161_input_global_id_0_0_stall_in_0_NO_SHIFT_REG, rnode_160to161_input_global_id_0_0_stall_in_1_NO_SHIFT_REG})
);

defparam rnode_160to161_input_global_id_0_0_reg_161_fanout_adaptor.DATA_WIDTH = 32;
defparam rnode_160to161_input_global_id_0_0_reg_161_fanout_adaptor.NUM_FANOUTS = 2;

acl_data_fifo rnode_160to161_input_global_id_0_0_reg_161_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_160to161_input_global_id_0_0_reg_161_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_160to161_input_global_id_0_0_stall_in_0_reg_161_NO_SHIFT_REG),
	.valid_out(rnode_160to161_input_global_id_0_0_valid_out_0_reg_161_NO_SHIFT_REG),
	.stall_out(rnode_160to161_input_global_id_0_0_stall_out_reg_161_NO_SHIFT_REG),
	.data_in(rnode_1to160_input_global_id_0_0_NO_SHIFT_REG),
	.data_out(rnode_160to161_input_global_id_0_0_reg_161_NO_SHIFT_REG)
);

defparam rnode_160to161_input_global_id_0_0_reg_161_fifo.DEPTH = 2;
defparam rnode_160to161_input_global_id_0_0_reg_161_fifo.DATA_WIDTH = 32;
defparam rnode_160to161_input_global_id_0_0_reg_161_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_160to161_input_global_id_0_0_reg_161_fifo.IMPL = "ll_reg";

assign rnode_160to161_input_global_id_0_0_reg_161_inputs_ready_NO_SHIFT_REG = rnode_1to160_input_global_id_0_0_valid_out_NO_SHIFT_REG;
assign rnode_1to160_input_global_id_0_0_stall_in_NO_SHIFT_REG = rnode_160to161_input_global_id_0_0_stall_out_reg_161_NO_SHIFT_REG;
assign rnode_160to161_input_global_id_0_0_NO_SHIFT_REG = rnode_160to161_input_global_id_0_0_reg_161_NO_SHIFT_REG_fa;
assign rnode_160to161_input_global_id_0_1_NO_SHIFT_REG = rnode_160to161_input_global_id_0_0_reg_161_NO_SHIFT_REG_fa;

// This section implements a staging register.
// 
wire rstag_161to161_bb1_ld__valid_out;
wire rstag_161to161_bb1_ld__stall_in;
wire rstag_161to161_bb1_ld__inputs_ready;
wire rstag_161to161_bb1_ld__stall_local;
 reg rstag_161to161_bb1_ld__staging_valid_NO_SHIFT_REG;
wire rstag_161to161_bb1_ld__combined_valid;
 reg [31:0] rstag_161to161_bb1_ld__staging_reg_NO_SHIFT_REG;
wire [31:0] rstag_161to161_bb1_ld_;

assign rstag_161to161_bb1_ld__inputs_ready = local_bb1_ld__valid_out_NO_SHIFT_REG;
assign rstag_161to161_bb1_ld_ = (rstag_161to161_bb1_ld__staging_valid_NO_SHIFT_REG ? rstag_161to161_bb1_ld__staging_reg_NO_SHIFT_REG : local_bb1_ld__NO_SHIFT_REG);
assign rstag_161to161_bb1_ld__combined_valid = (rstag_161to161_bb1_ld__staging_valid_NO_SHIFT_REG | rstag_161to161_bb1_ld__inputs_ready);
assign rstag_161to161_bb1_ld__valid_out = rstag_161to161_bb1_ld__combined_valid;
assign rstag_161to161_bb1_ld__stall_local = rstag_161to161_bb1_ld__stall_in;
assign local_bb1_ld__stall_in = (|rstag_161to161_bb1_ld__staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_161to161_bb1_ld__staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_161to161_bb1_ld__staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_161to161_bb1_ld__stall_local)
		begin
			if (~(rstag_161to161_bb1_ld__staging_valid_NO_SHIFT_REG))
			begin
				rstag_161to161_bb1_ld__staging_valid_NO_SHIFT_REG <= rstag_161to161_bb1_ld__inputs_ready;
			end
		end
		else
		begin
			rstag_161to161_bb1_ld__staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_161to161_bb1_ld__staging_valid_NO_SHIFT_REG))
		begin
			rstag_161to161_bb1_ld__staging_reg_NO_SHIFT_REG <= local_bb1_ld__NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c0_eni1_stall_local;
wire [127:0] local_bb1_c0_eni1;

assign local_bb1_c0_eni1[31:0] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
assign local_bb1_c0_eni1[63:32] = rnode_320to321_rank_new_02_0_NO_SHIFT_REG;
assign local_bb1_c0_eni1[127:64] = 64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;

// This section implements an unregistered operation.
// 
wire local_bb1_val_valid_out;
wire local_bb1_val_stall_in;
wire local_bb1_val_inputs_ready;
wire local_bb1_val_stall_local;
wire [63:0] local_bb1_val;

assign local_bb1_val_inputs_ready = (rnode_160to161_input_msg_arr_0_valid_out_NO_SHIFT_REG & rnode_160to161_indvars_iv_0_valid_out_0_NO_SHIFT_REG);
assign local_bb1_val = ((input_msg_arr + (rnode_160to161_indvars_iv_0_NO_SHIFT_REG << 6'h3)) + 64'h4);
assign local_bb1_val_valid_out = local_bb1_val_inputs_ready;
assign local_bb1_val_stall_local = local_bb1_val_stall_in;
assign rnode_160to161_input_msg_arr_0_stall_in_NO_SHIFT_REG = (local_bb1_val_stall_local | ~(local_bb1_val_inputs_ready));
assign rnode_160to161_indvars_iv_0_stall_in_0_NO_SHIFT_REG = (local_bb1_val_stall_local | ~(local_bb1_val_inputs_ready));

// Register node:
//  * latency = 170
//  * capacity = 170
 logic rnode_161to331_indvars_iv_0_valid_out_NO_SHIFT_REG;
 logic rnode_161to331_indvars_iv_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_161to331_indvars_iv_0_NO_SHIFT_REG;
 logic rnode_161to331_indvars_iv_0_reg_331_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_161to331_indvars_iv_0_reg_331_NO_SHIFT_REG;
 logic rnode_161to331_indvars_iv_0_valid_out_reg_331_NO_SHIFT_REG;
 logic rnode_161to331_indvars_iv_0_stall_in_reg_331_NO_SHIFT_REG;
 logic rnode_161to331_indvars_iv_0_stall_out_reg_331_NO_SHIFT_REG;

acl_data_fifo rnode_161to331_indvars_iv_0_reg_331_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_161to331_indvars_iv_0_reg_331_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_161to331_indvars_iv_0_stall_in_reg_331_NO_SHIFT_REG),
	.valid_out(rnode_161to331_indvars_iv_0_valid_out_reg_331_NO_SHIFT_REG),
	.stall_out(rnode_161to331_indvars_iv_0_stall_out_reg_331_NO_SHIFT_REG),
	.data_in(rnode_160to161_indvars_iv_1_NO_SHIFT_REG),
	.data_out(rnode_161to331_indvars_iv_0_reg_331_NO_SHIFT_REG)
);

defparam rnode_161to331_indvars_iv_0_reg_331_fifo.DEPTH = 171;
defparam rnode_161to331_indvars_iv_0_reg_331_fifo.DATA_WIDTH = 64;
defparam rnode_161to331_indvars_iv_0_reg_331_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_161to331_indvars_iv_0_reg_331_fifo.IMPL = "ram";

assign rnode_161to331_indvars_iv_0_reg_331_inputs_ready_NO_SHIFT_REG = rnode_160to161_indvars_iv_0_valid_out_1_NO_SHIFT_REG;
assign rnode_160to161_indvars_iv_0_stall_in_1_NO_SHIFT_REG = rnode_161to331_indvars_iv_0_stall_out_reg_331_NO_SHIFT_REG;
assign rnode_161to331_indvars_iv_0_NO_SHIFT_REG = rnode_161to331_indvars_iv_0_reg_331_NO_SHIFT_REG;
assign rnode_161to331_indvars_iv_0_stall_in_reg_331_NO_SHIFT_REG = rnode_161to331_indvars_iv_0_stall_in_NO_SHIFT_REG;
assign rnode_161to331_indvars_iv_0_valid_out_NO_SHIFT_REG = rnode_161to331_indvars_iv_0_valid_out_reg_331_NO_SHIFT_REG;

// Register node:
//  * latency = 171
//  * capacity = 171
 logic rnode_161to332_input_global_id_0_0_valid_out_NO_SHIFT_REG;
 logic rnode_161to332_input_global_id_0_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_161to332_input_global_id_0_0_NO_SHIFT_REG;
 logic rnode_161to332_input_global_id_0_0_reg_332_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_161to332_input_global_id_0_0_reg_332_NO_SHIFT_REG;
 logic rnode_161to332_input_global_id_0_0_valid_out_reg_332_NO_SHIFT_REG;
 logic rnode_161to332_input_global_id_0_0_stall_in_reg_332_NO_SHIFT_REG;
 logic rnode_161to332_input_global_id_0_0_stall_out_reg_332_NO_SHIFT_REG;

acl_data_fifo rnode_161to332_input_global_id_0_0_reg_332_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_161to332_input_global_id_0_0_reg_332_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_161to332_input_global_id_0_0_stall_in_reg_332_NO_SHIFT_REG),
	.valid_out(rnode_161to332_input_global_id_0_0_valid_out_reg_332_NO_SHIFT_REG),
	.stall_out(rnode_161to332_input_global_id_0_0_stall_out_reg_332_NO_SHIFT_REG),
	.data_in(rnode_160to161_input_global_id_0_1_NO_SHIFT_REG),
	.data_out(rnode_161to332_input_global_id_0_0_reg_332_NO_SHIFT_REG)
);

defparam rnode_161to332_input_global_id_0_0_reg_332_fifo.DEPTH = 172;
defparam rnode_161to332_input_global_id_0_0_reg_332_fifo.DATA_WIDTH = 32;
defparam rnode_161to332_input_global_id_0_0_reg_332_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_161to332_input_global_id_0_0_reg_332_fifo.IMPL = "ram";

assign rnode_161to332_input_global_id_0_0_reg_332_inputs_ready_NO_SHIFT_REG = rnode_160to161_input_global_id_0_0_valid_out_1_NO_SHIFT_REG;
assign rnode_160to161_input_global_id_0_0_stall_in_1_NO_SHIFT_REG = rnode_161to332_input_global_id_0_0_stall_out_reg_332_NO_SHIFT_REG;
assign rnode_161to332_input_global_id_0_0_NO_SHIFT_REG = rnode_161to332_input_global_id_0_0_reg_332_NO_SHIFT_REG;
assign rnode_161to332_input_global_id_0_0_stall_in_reg_332_NO_SHIFT_REG = rnode_161to332_input_global_id_0_0_stall_in_NO_SHIFT_REG;
assign rnode_161to332_input_global_id_0_0_valid_out_NO_SHIFT_REG = rnode_161to332_input_global_id_0_0_valid_out_reg_332_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_cmp2_stall_local;
wire local_bb1_cmp2;

assign local_bb1_cmp2 = (rstag_161to161_bb1_ld_ == rnode_160to161_input_global_id_0_0_NO_SHIFT_REG);

// This section implements a staging register.
// 
wire rstag_161to161_bb1_val_valid_out;
wire rstag_161to161_bb1_val_stall_in;
wire rstag_161to161_bb1_val_inputs_ready;
wire rstag_161to161_bb1_val_stall_local;
 reg rstag_161to161_bb1_val_staging_valid_NO_SHIFT_REG;
wire rstag_161to161_bb1_val_combined_valid;
 reg [63:0] rstag_161to161_bb1_val_staging_reg_NO_SHIFT_REG;
wire [63:0] rstag_161to161_bb1_val;

assign rstag_161to161_bb1_val_inputs_ready = local_bb1_val_valid_out;
assign rstag_161to161_bb1_val = (rstag_161to161_bb1_val_staging_valid_NO_SHIFT_REG ? rstag_161to161_bb1_val_staging_reg_NO_SHIFT_REG : local_bb1_val);
assign rstag_161to161_bb1_val_combined_valid = (rstag_161to161_bb1_val_staging_valid_NO_SHIFT_REG | rstag_161to161_bb1_val_inputs_ready);
assign rstag_161to161_bb1_val_valid_out = rstag_161to161_bb1_val_combined_valid;
assign rstag_161to161_bb1_val_stall_local = rstag_161to161_bb1_val_stall_in;
assign local_bb1_val_stall_in = (|rstag_161to161_bb1_val_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_161to161_bb1_val_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_161to161_bb1_val_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_161to161_bb1_val_stall_local)
		begin
			if (~(rstag_161to161_bb1_val_staging_valid_NO_SHIFT_REG))
			begin
				rstag_161to161_bb1_val_staging_valid_NO_SHIFT_REG <= rstag_161to161_bb1_val_inputs_ready;
			end
		end
		else
		begin
			rstag_161to161_bb1_val_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_161to161_bb1_val_staging_valid_NO_SHIFT_REG))
		begin
			rstag_161to161_bb1_val_staging_reg_NO_SHIFT_REG <= local_bb1_val;
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_331to332_indvars_iv_0_valid_out_NO_SHIFT_REG;
 logic rnode_331to332_indvars_iv_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_331to332_indvars_iv_0_NO_SHIFT_REG;
 logic rnode_331to332_indvars_iv_0_reg_332_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_331to332_indvars_iv_0_reg_332_NO_SHIFT_REG;
 logic rnode_331to332_indvars_iv_0_valid_out_reg_332_NO_SHIFT_REG;
 logic rnode_331to332_indvars_iv_0_stall_in_reg_332_NO_SHIFT_REG;
 logic rnode_331to332_indvars_iv_0_stall_out_reg_332_NO_SHIFT_REG;

acl_data_fifo rnode_331to332_indvars_iv_0_reg_332_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_331to332_indvars_iv_0_reg_332_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_331to332_indvars_iv_0_stall_in_reg_332_NO_SHIFT_REG),
	.valid_out(rnode_331to332_indvars_iv_0_valid_out_reg_332_NO_SHIFT_REG),
	.stall_out(rnode_331to332_indvars_iv_0_stall_out_reg_332_NO_SHIFT_REG),
	.data_in(rnode_161to331_indvars_iv_0_NO_SHIFT_REG),
	.data_out(rnode_331to332_indvars_iv_0_reg_332_NO_SHIFT_REG)
);

defparam rnode_331to332_indvars_iv_0_reg_332_fifo.DEPTH = 2;
defparam rnode_331to332_indvars_iv_0_reg_332_fifo.DATA_WIDTH = 64;
defparam rnode_331to332_indvars_iv_0_reg_332_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_331to332_indvars_iv_0_reg_332_fifo.IMPL = "ll_reg";

assign rnode_331to332_indvars_iv_0_reg_332_inputs_ready_NO_SHIFT_REG = rnode_161to331_indvars_iv_0_valid_out_NO_SHIFT_REG;
assign rnode_161to331_indvars_iv_0_stall_in_NO_SHIFT_REG = rnode_331to332_indvars_iv_0_stall_out_reg_332_NO_SHIFT_REG;
assign rnode_331to332_indvars_iv_0_NO_SHIFT_REG = rnode_331to332_indvars_iv_0_reg_332_NO_SHIFT_REG;
assign rnode_331to332_indvars_iv_0_stall_in_reg_332_NO_SHIFT_REG = rnode_331to332_indvars_iv_0_stall_in_NO_SHIFT_REG;
assign rnode_331to332_indvars_iv_0_valid_out_NO_SHIFT_REG = rnode_331to332_indvars_iv_0_valid_out_reg_332_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_332to333_input_global_id_0_0_valid_out_NO_SHIFT_REG;
 logic rnode_332to333_input_global_id_0_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_332to333_input_global_id_0_0_NO_SHIFT_REG;
 logic rnode_332to333_input_global_id_0_0_reg_333_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_332to333_input_global_id_0_0_reg_333_NO_SHIFT_REG;
 logic rnode_332to333_input_global_id_0_0_valid_out_reg_333_NO_SHIFT_REG;
 logic rnode_332to333_input_global_id_0_0_stall_in_reg_333_NO_SHIFT_REG;
 logic rnode_332to333_input_global_id_0_0_stall_out_reg_333_NO_SHIFT_REG;

acl_data_fifo rnode_332to333_input_global_id_0_0_reg_333_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_332to333_input_global_id_0_0_reg_333_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_332to333_input_global_id_0_0_stall_in_reg_333_NO_SHIFT_REG),
	.valid_out(rnode_332to333_input_global_id_0_0_valid_out_reg_333_NO_SHIFT_REG),
	.stall_out(rnode_332to333_input_global_id_0_0_stall_out_reg_333_NO_SHIFT_REG),
	.data_in(rnode_161to332_input_global_id_0_0_NO_SHIFT_REG),
	.data_out(rnode_332to333_input_global_id_0_0_reg_333_NO_SHIFT_REG)
);

defparam rnode_332to333_input_global_id_0_0_reg_333_fifo.DEPTH = 2;
defparam rnode_332to333_input_global_id_0_0_reg_333_fifo.DATA_WIDTH = 32;
defparam rnode_332to333_input_global_id_0_0_reg_333_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_332to333_input_global_id_0_0_reg_333_fifo.IMPL = "ll_reg";

assign rnode_332to333_input_global_id_0_0_reg_333_inputs_ready_NO_SHIFT_REG = rnode_161to332_input_global_id_0_0_valid_out_NO_SHIFT_REG;
assign rnode_161to332_input_global_id_0_0_stall_in_NO_SHIFT_REG = rnode_332to333_input_global_id_0_0_stall_out_reg_333_NO_SHIFT_REG;
assign rnode_332to333_input_global_id_0_0_NO_SHIFT_REG = rnode_332to333_input_global_id_0_0_reg_333_NO_SHIFT_REG;
assign rnode_332to333_input_global_id_0_0_stall_in_reg_333_NO_SHIFT_REG = rnode_332to333_input_global_id_0_0_stall_in_NO_SHIFT_REG;
assign rnode_332to333_input_global_id_0_0_valid_out_NO_SHIFT_REG = rnode_332to333_input_global_id_0_0_valid_out_reg_333_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_cmp2_xor_stall_local;
wire local_bb1_cmp2_xor;

assign local_bb1_cmp2_xor = (local_bb1_cmp2 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb1_indvars_iv_next_valid_out;
wire local_bb1_indvars_iv_next_stall_in;
wire local_bb1_indvars_iv_next_inputs_ready;
wire local_bb1_indvars_iv_next_stall_local;
wire [63:0] local_bb1_indvars_iv_next;

assign local_bb1_indvars_iv_next_inputs_ready = rnode_331to332_indvars_iv_0_valid_out_NO_SHIFT_REG;
assign local_bb1_indvars_iv_next = (rnode_331to332_indvars_iv_0_NO_SHIFT_REG + 64'h1);
assign local_bb1_indvars_iv_next_valid_out = local_bb1_indvars_iv_next_inputs_ready;
assign local_bb1_indvars_iv_next_stall_local = local_bb1_indvars_iv_next_stall_in;
assign rnode_331to332_indvars_iv_0_stall_in_NO_SHIFT_REG = (|local_bb1_indvars_iv_next_stall_local);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp2_valid_out_1;
wire local_bb1_cmp2_stall_in_1;
 reg local_bb1_cmp2_consumed_1_NO_SHIFT_REG;
wire local_bb1_cmp1_or12_valid_out;
wire local_bb1_cmp1_or12_stall_in;
 reg local_bb1_cmp1_or12_consumed_0_NO_SHIFT_REG;
wire local_bb1_cmp1_or12_inputs_ready;
wire local_bb1_cmp1_or12_stall_local;
wire local_bb1_cmp1_or12;

assign local_bb1_cmp1_or12_inputs_ready = (rnode_160to161_input_global_id_0_0_valid_out_0_NO_SHIFT_REG & rstag_161to161_bb1_ld__valid_out);
assign local_bb1_cmp1_or12 = (input_wii_cmp1 | local_bb1_cmp2_xor);
assign local_bb1_cmp1_or12_stall_local = ((local_bb1_cmp2_stall_in_1 & ~(local_bb1_cmp2_consumed_1_NO_SHIFT_REG)) | (local_bb1_cmp1_or12_stall_in & ~(local_bb1_cmp1_or12_consumed_0_NO_SHIFT_REG)));
assign local_bb1_cmp2_valid_out_1 = (local_bb1_cmp1_or12_inputs_ready & ~(local_bb1_cmp2_consumed_1_NO_SHIFT_REG));
assign local_bb1_cmp1_or12_valid_out = (local_bb1_cmp1_or12_inputs_ready & ~(local_bb1_cmp1_or12_consumed_0_NO_SHIFT_REG));
assign rnode_160to161_input_global_id_0_0_stall_in_0_NO_SHIFT_REG = (local_bb1_cmp1_or12_stall_local | ~(local_bb1_cmp1_or12_inputs_ready));
assign rstag_161to161_bb1_ld__stall_in = (local_bb1_cmp1_or12_stall_local | ~(local_bb1_cmp1_or12_inputs_ready));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_cmp2_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_cmp1_or12_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_cmp2_consumed_1_NO_SHIFT_REG <= (local_bb1_cmp1_or12_inputs_ready & (local_bb1_cmp2_consumed_1_NO_SHIFT_REG | ~(local_bb1_cmp2_stall_in_1)) & local_bb1_cmp1_or12_stall_local);
		local_bb1_cmp1_or12_consumed_0_NO_SHIFT_REG <= (local_bb1_cmp1_or12_inputs_ready & (local_bb1_cmp1_or12_consumed_0_NO_SHIFT_REG | ~(local_bb1_cmp1_or12_stall_in)) & local_bb1_cmp1_or12_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_332to333_bb1_indvars_iv_next_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_332to333_bb1_indvars_iv_next_0_stall_in_0_NO_SHIFT_REG;
 logic [63:0] rnode_332to333_bb1_indvars_iv_next_0_NO_SHIFT_REG;
 logic rnode_332to333_bb1_indvars_iv_next_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_332to333_bb1_indvars_iv_next_0_stall_in_1_NO_SHIFT_REG;
 logic [63:0] rnode_332to333_bb1_indvars_iv_next_1_NO_SHIFT_REG;
 logic rnode_332to333_bb1_indvars_iv_next_0_reg_333_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_332to333_bb1_indvars_iv_next_0_reg_333_NO_SHIFT_REG;
 logic rnode_332to333_bb1_indvars_iv_next_0_valid_out_0_reg_333_NO_SHIFT_REG;
 logic rnode_332to333_bb1_indvars_iv_next_0_stall_in_0_reg_333_NO_SHIFT_REG;
 logic rnode_332to333_bb1_indvars_iv_next_0_stall_out_reg_333_NO_SHIFT_REG;
 logic [63:0] rnode_332to333_bb1_indvars_iv_next_0_reg_333_NO_SHIFT_REG_fa;

acl_multi_fanout_adaptor rnode_332to333_bb1_indvars_iv_next_0_reg_333_fanout_adaptor (
	.clock(clock),
	.resetn(resetn),
	.data_in(rnode_332to333_bb1_indvars_iv_next_0_reg_333_NO_SHIFT_REG),
	.valid_in(rnode_332to333_bb1_indvars_iv_next_0_valid_out_0_reg_333_NO_SHIFT_REG),
	.stall_out(rnode_332to333_bb1_indvars_iv_next_0_stall_in_0_reg_333_NO_SHIFT_REG),
	.data_out(rnode_332to333_bb1_indvars_iv_next_0_reg_333_NO_SHIFT_REG_fa),
	.valid_out({rnode_332to333_bb1_indvars_iv_next_0_valid_out_0_NO_SHIFT_REG, rnode_332to333_bb1_indvars_iv_next_0_valid_out_1_NO_SHIFT_REG}),
	.stall_in({rnode_332to333_bb1_indvars_iv_next_0_stall_in_0_NO_SHIFT_REG, rnode_332to333_bb1_indvars_iv_next_0_stall_in_1_NO_SHIFT_REG})
);

defparam rnode_332to333_bb1_indvars_iv_next_0_reg_333_fanout_adaptor.DATA_WIDTH = 64;
defparam rnode_332to333_bb1_indvars_iv_next_0_reg_333_fanout_adaptor.NUM_FANOUTS = 2;

acl_data_fifo rnode_332to333_bb1_indvars_iv_next_0_reg_333_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_332to333_bb1_indvars_iv_next_0_reg_333_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_332to333_bb1_indvars_iv_next_0_stall_in_0_reg_333_NO_SHIFT_REG),
	.valid_out(rnode_332to333_bb1_indvars_iv_next_0_valid_out_0_reg_333_NO_SHIFT_REG),
	.stall_out(rnode_332to333_bb1_indvars_iv_next_0_stall_out_reg_333_NO_SHIFT_REG),
	.data_in(local_bb1_indvars_iv_next),
	.data_out(rnode_332to333_bb1_indvars_iv_next_0_reg_333_NO_SHIFT_REG)
);

defparam rnode_332to333_bb1_indvars_iv_next_0_reg_333_fifo.DEPTH = 2;
defparam rnode_332to333_bb1_indvars_iv_next_0_reg_333_fifo.DATA_WIDTH = 64;
defparam rnode_332to333_bb1_indvars_iv_next_0_reg_333_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_332to333_bb1_indvars_iv_next_0_reg_333_fifo.IMPL = "ll_reg";

assign rnode_332to333_bb1_indvars_iv_next_0_reg_333_inputs_ready_NO_SHIFT_REG = local_bb1_indvars_iv_next_valid_out;
assign local_bb1_indvars_iv_next_stall_in = rnode_332to333_bb1_indvars_iv_next_0_stall_out_reg_333_NO_SHIFT_REG;
assign rnode_332to333_bb1_indvars_iv_next_0_NO_SHIFT_REG = rnode_332to333_bb1_indvars_iv_next_0_reg_333_NO_SHIFT_REG_fa;
assign rnode_332to333_bb1_indvars_iv_next_1_NO_SHIFT_REG = rnode_332to333_bb1_indvars_iv_next_0_reg_333_NO_SHIFT_REG_fa;

// Register node:
//  * latency = 159
//  * capacity = 159
 logic rnode_161to320_bb1_cmp2_0_valid_out_NO_SHIFT_REG;
 logic rnode_161to320_bb1_cmp2_0_stall_in_NO_SHIFT_REG;
 logic rnode_161to320_bb1_cmp2_0_NO_SHIFT_REG;
 logic rnode_161to320_bb1_cmp2_0_reg_320_inputs_ready_NO_SHIFT_REG;
 logic rnode_161to320_bb1_cmp2_0_reg_320_NO_SHIFT_REG;
 logic rnode_161to320_bb1_cmp2_0_valid_out_reg_320_NO_SHIFT_REG;
 logic rnode_161to320_bb1_cmp2_0_stall_in_reg_320_NO_SHIFT_REG;
 logic rnode_161to320_bb1_cmp2_0_stall_out_reg_320_NO_SHIFT_REG;

acl_data_fifo rnode_161to320_bb1_cmp2_0_reg_320_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_161to320_bb1_cmp2_0_reg_320_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_161to320_bb1_cmp2_0_stall_in_reg_320_NO_SHIFT_REG),
	.valid_out(rnode_161to320_bb1_cmp2_0_valid_out_reg_320_NO_SHIFT_REG),
	.stall_out(rnode_161to320_bb1_cmp2_0_stall_out_reg_320_NO_SHIFT_REG),
	.data_in(local_bb1_cmp2),
	.data_out(rnode_161to320_bb1_cmp2_0_reg_320_NO_SHIFT_REG)
);

defparam rnode_161to320_bb1_cmp2_0_reg_320_fifo.DEPTH = 160;
defparam rnode_161to320_bb1_cmp2_0_reg_320_fifo.DATA_WIDTH = 1;
defparam rnode_161to320_bb1_cmp2_0_reg_320_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_161to320_bb1_cmp2_0_reg_320_fifo.IMPL = "ram";

assign rnode_161to320_bb1_cmp2_0_reg_320_inputs_ready_NO_SHIFT_REG = local_bb1_cmp2_valid_out_1;
assign local_bb1_cmp2_stall_in_1 = rnode_161to320_bb1_cmp2_0_stall_out_reg_320_NO_SHIFT_REG;
assign rnode_161to320_bb1_cmp2_0_NO_SHIFT_REG = rnode_161to320_bb1_cmp2_0_reg_320_NO_SHIFT_REG;
assign rnode_161to320_bb1_cmp2_0_stall_in_reg_320_NO_SHIFT_REG = rnode_161to320_bb1_cmp2_0_stall_in_NO_SHIFT_REG;
assign rnode_161to320_bb1_cmp2_0_valid_out_NO_SHIFT_REG = rnode_161to320_bb1_cmp2_0_valid_out_reg_320_NO_SHIFT_REG;

// This section implements a staging register.
// 
wire rstag_161to161_bb1_cmp1_or12_valid_out;
wire rstag_161to161_bb1_cmp1_or12_stall_in;
wire rstag_161to161_bb1_cmp1_or12_inputs_ready;
wire rstag_161to161_bb1_cmp1_or12_stall_local;
 reg rstag_161to161_bb1_cmp1_or12_staging_valid_NO_SHIFT_REG;
wire rstag_161to161_bb1_cmp1_or12_combined_valid;
 reg rstag_161to161_bb1_cmp1_or12_staging_reg_NO_SHIFT_REG;
wire rstag_161to161_bb1_cmp1_or12;

assign rstag_161to161_bb1_cmp1_or12_inputs_ready = local_bb1_cmp1_or12_valid_out;
assign rstag_161to161_bb1_cmp1_or12 = (rstag_161to161_bb1_cmp1_or12_staging_valid_NO_SHIFT_REG ? rstag_161to161_bb1_cmp1_or12_staging_reg_NO_SHIFT_REG : local_bb1_cmp1_or12);
assign rstag_161to161_bb1_cmp1_or12_combined_valid = (rstag_161to161_bb1_cmp1_or12_staging_valid_NO_SHIFT_REG | rstag_161to161_bb1_cmp1_or12_inputs_ready);
assign rstag_161to161_bb1_cmp1_or12_valid_out = rstag_161to161_bb1_cmp1_or12_combined_valid;
assign rstag_161to161_bb1_cmp1_or12_stall_local = rstag_161to161_bb1_cmp1_or12_stall_in;
assign local_bb1_cmp1_or12_stall_in = (|rstag_161to161_bb1_cmp1_or12_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_161to161_bb1_cmp1_or12_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_161to161_bb1_cmp1_or12_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_161to161_bb1_cmp1_or12_stall_local)
		begin
			if (~(rstag_161to161_bb1_cmp1_or12_staging_valid_NO_SHIFT_REG))
			begin
				rstag_161to161_bb1_cmp1_or12_staging_valid_NO_SHIFT_REG <= rstag_161to161_bb1_cmp1_or12_inputs_ready;
			end
		end
		else
		begin
			rstag_161to161_bb1_cmp1_or12_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_161to161_bb1_cmp1_or12_staging_valid_NO_SHIFT_REG))
		begin
			rstag_161to161_bb1_cmp1_or12_staging_reg_NO_SHIFT_REG <= local_bb1_cmp1_or12;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_lftr_wideiv_stall_local;
wire [31:0] local_bb1_lftr_wideiv;

assign local_bb1_lftr_wideiv = rnode_332to333_bb1_indvars_iv_next_0_NO_SHIFT_REG[31:0];

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_320to321_bb1_cmp2_0_valid_out_NO_SHIFT_REG;
 logic rnode_320to321_bb1_cmp2_0_stall_in_NO_SHIFT_REG;
 logic rnode_320to321_bb1_cmp2_0_NO_SHIFT_REG;
 logic rnode_320to321_bb1_cmp2_0_reg_321_inputs_ready_NO_SHIFT_REG;
 logic rnode_320to321_bb1_cmp2_0_reg_321_NO_SHIFT_REG;
 logic rnode_320to321_bb1_cmp2_0_valid_out_reg_321_NO_SHIFT_REG;
 logic rnode_320to321_bb1_cmp2_0_stall_in_reg_321_NO_SHIFT_REG;
 logic rnode_320to321_bb1_cmp2_0_stall_out_reg_321_NO_SHIFT_REG;

acl_data_fifo rnode_320to321_bb1_cmp2_0_reg_321_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_320to321_bb1_cmp2_0_reg_321_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_320to321_bb1_cmp2_0_stall_in_reg_321_NO_SHIFT_REG),
	.valid_out(rnode_320to321_bb1_cmp2_0_valid_out_reg_321_NO_SHIFT_REG),
	.stall_out(rnode_320to321_bb1_cmp2_0_stall_out_reg_321_NO_SHIFT_REG),
	.data_in(rnode_161to320_bb1_cmp2_0_NO_SHIFT_REG),
	.data_out(rnode_320to321_bb1_cmp2_0_reg_321_NO_SHIFT_REG)
);

defparam rnode_320to321_bb1_cmp2_0_reg_321_fifo.DEPTH = 2;
defparam rnode_320to321_bb1_cmp2_0_reg_321_fifo.DATA_WIDTH = 1;
defparam rnode_320to321_bb1_cmp2_0_reg_321_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_320to321_bb1_cmp2_0_reg_321_fifo.IMPL = "ll_reg";

assign rnode_320to321_bb1_cmp2_0_reg_321_inputs_ready_NO_SHIFT_REG = rnode_161to320_bb1_cmp2_0_valid_out_NO_SHIFT_REG;
assign rnode_161to320_bb1_cmp2_0_stall_in_NO_SHIFT_REG = rnode_320to321_bb1_cmp2_0_stall_out_reg_321_NO_SHIFT_REG;
assign rnode_320to321_bb1_cmp2_0_NO_SHIFT_REG = rnode_320to321_bb1_cmp2_0_reg_321_NO_SHIFT_REG;
assign rnode_320to321_bb1_cmp2_0_stall_in_reg_321_NO_SHIFT_REG = rnode_320to321_bb1_cmp2_0_stall_in_NO_SHIFT_REG;
assign rnode_320to321_bb1_cmp2_0_valid_out_NO_SHIFT_REG = rnode_320to321_bb1_cmp2_0_valid_out_reg_321_NO_SHIFT_REG;

// This section implements a registered operation.
// 
wire local_bb1_ld__u0_inputs_ready;
 reg local_bb1_ld__u0_valid_out_NO_SHIFT_REG;
wire local_bb1_ld__u0_stall_in;
wire local_bb1_ld__u0_output_regs_ready;
wire local_bb1_ld__u0_fu_stall_out;
wire local_bb1_ld__u0_fu_valid_out;
wire [31:0] local_bb1_ld__u0_lsu_dataout;
 reg [31:0] local_bb1_ld__u0_NO_SHIFT_REG;
wire local_bb1_ld__u0_causedstall;

lsu_top lsu_local_bb1_ld__u0 (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(),
	.stream_size(),
	.stream_reset(),
	.o_stall(local_bb1_ld__u0_fu_stall_out),
	.i_valid(local_bb1_ld__u0_inputs_ready),
	.i_address(rstag_161to161_bb1_val),
	.i_writedata(),
	.i_cmpdata(),
	.i_predicate(rstag_161to161_bb1_cmp1_or12),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb1_ld__u0_output_regs_ready)),
	.o_valid(local_bb1_ld__u0_fu_valid_out),
	.o_readdata(local_bb1_ld__u0_lsu_dataout),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb1_ld__u0_active),
	.avm_address(avm_local_bb1_ld__u0_address),
	.avm_read(avm_local_bb1_ld__u0_read),
	.avm_readdata(avm_local_bb1_ld__u0_readdata),
	.avm_write(avm_local_bb1_ld__u0_write),
	.avm_writeack(avm_local_bb1_ld__u0_writeack),
	.avm_burstcount(avm_local_bb1_ld__u0_burstcount),
	.avm_writedata(avm_local_bb1_ld__u0_writedata),
	.avm_byteenable(avm_local_bb1_ld__u0_byteenable),
	.avm_waitrequest(avm_local_bb1_ld__u0_waitrequest),
	.avm_readdatavalid(avm_local_bb1_ld__u0_readdatavalid),
	.profile_bw(),
	.profile_bw_incr(),
	.profile_total_ivalid(),
	.profile_total_req(),
	.profile_i_stall_count(),
	.profile_o_stall_count(),
	.profile_avm_readwrite_count(),
	.profile_avm_burstcount_total(),
	.profile_avm_burstcount_total_incr(),
	.profile_req_cache_hit_count(),
	.profile_extra_unaligned_reqs(),
	.profile_avm_stall()
);

defparam lsu_local_bb1_ld__u0.AWIDTH = 30;
defparam lsu_local_bb1_ld__u0.WIDTH_BYTES = 4;
defparam lsu_local_bb1_ld__u0.MWIDTH_BYTES = 32;
defparam lsu_local_bb1_ld__u0.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb1_ld__u0.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb1_ld__u0.READ = 1;
defparam lsu_local_bb1_ld__u0.ATOMIC = 0;
defparam lsu_local_bb1_ld__u0.WIDTH = 32;
defparam lsu_local_bb1_ld__u0.MWIDTH = 256;
defparam lsu_local_bb1_ld__u0.ATOMIC_WIDTH = 3;
defparam lsu_local_bb1_ld__u0.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb1_ld__u0.KERNEL_SIDE_MEM_LATENCY = 160;
defparam lsu_local_bb1_ld__u0.MEMORY_SIDE_MEM_LATENCY = 122;
defparam lsu_local_bb1_ld__u0.USE_WRITE_ACK = 0;
defparam lsu_local_bb1_ld__u0.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb1_ld__u0.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb1_ld__u0.NUMBER_BANKS = 1;
defparam lsu_local_bb1_ld__u0.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb1_ld__u0.USEINPUTFIFO = 0;
defparam lsu_local_bb1_ld__u0.USECACHING = 1;
defparam lsu_local_bb1_ld__u0.CACHESIZE = 256;
defparam lsu_local_bb1_ld__u0.USEOUTPUTFIFO = 1;
defparam lsu_local_bb1_ld__u0.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb1_ld__u0.HIGH_FMAX = 1;
defparam lsu_local_bb1_ld__u0.ADDRSPACE = 1;
defparam lsu_local_bb1_ld__u0.STYLE = "BURST-COALESCED";

assign local_bb1_ld__u0_inputs_ready = (rstag_161to161_bb1_cmp1_or12_valid_out & rstag_161to161_bb1_val_valid_out);
assign local_bb1_ld__u0_output_regs_ready = (&(~(local_bb1_ld__u0_valid_out_NO_SHIFT_REG) | ~(local_bb1_ld__u0_stall_in)));
assign rstag_161to161_bb1_cmp1_or12_stall_in = (local_bb1_ld__u0_fu_stall_out | ~(local_bb1_ld__u0_inputs_ready));
assign rstag_161to161_bb1_val_stall_in = (local_bb1_ld__u0_fu_stall_out | ~(local_bb1_ld__u0_inputs_ready));
assign local_bb1_ld__u0_causedstall = (local_bb1_ld__u0_inputs_ready && (local_bb1_ld__u0_fu_stall_out && !(~(local_bb1_ld__u0_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_ld__u0_NO_SHIFT_REG <= 'x;
		local_bb1_ld__u0_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_ld__u0_output_regs_ready)
		begin
			local_bb1_ld__u0_NO_SHIFT_REG <= local_bb1_ld__u0_lsu_dataout;
			local_bb1_ld__u0_valid_out_NO_SHIFT_REG <= local_bb1_ld__u0_fu_valid_out;
		end
		else
		begin
			if (~(local_bb1_ld__u0_stall_in))
			begin
				local_bb1_ld__u0_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_exitcond_stall_local;
wire local_bb1_exitcond;

assign local_bb1_exitcond = (local_bb1_lftr_wideiv == input_num_edges);

// This section implements a staging register.
// 
wire rstag_321to321_bb1_ld__u0_valid_out;
wire rstag_321to321_bb1_ld__u0_stall_in;
wire rstag_321to321_bb1_ld__u0_inputs_ready;
wire rstag_321to321_bb1_ld__u0_stall_local;
 reg rstag_321to321_bb1_ld__u0_staging_valid_NO_SHIFT_REG;
wire rstag_321to321_bb1_ld__u0_combined_valid;
 reg [31:0] rstag_321to321_bb1_ld__u0_staging_reg_NO_SHIFT_REG;
wire [31:0] rstag_321to321_bb1_ld__u0;

assign rstag_321to321_bb1_ld__u0_inputs_ready = local_bb1_ld__u0_valid_out_NO_SHIFT_REG;
assign rstag_321to321_bb1_ld__u0 = (rstag_321to321_bb1_ld__u0_staging_valid_NO_SHIFT_REG ? rstag_321to321_bb1_ld__u0_staging_reg_NO_SHIFT_REG : local_bb1_ld__u0_NO_SHIFT_REG);
assign rstag_321to321_bb1_ld__u0_combined_valid = (rstag_321to321_bb1_ld__u0_staging_valid_NO_SHIFT_REG | rstag_321to321_bb1_ld__u0_inputs_ready);
assign rstag_321to321_bb1_ld__u0_valid_out = rstag_321to321_bb1_ld__u0_combined_valid;
assign rstag_321to321_bb1_ld__u0_stall_local = rstag_321to321_bb1_ld__u0_stall_in;
assign local_bb1_ld__u0_stall_in = (|rstag_321to321_bb1_ld__u0_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_321to321_bb1_ld__u0_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_321to321_bb1_ld__u0_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_321to321_bb1_ld__u0_stall_local)
		begin
			if (~(rstag_321to321_bb1_ld__u0_staging_valid_NO_SHIFT_REG))
			begin
				rstag_321to321_bb1_ld__u0_staging_valid_NO_SHIFT_REG <= rstag_321to321_bb1_ld__u0_inputs_ready;
			end
		end
		else
		begin
			rstag_321to321_bb1_ld__u0_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_321to321_bb1_ld__u0_staging_valid_NO_SHIFT_REG))
		begin
			rstag_321to321_bb1_ld__u0_staging_reg_NO_SHIFT_REG <= local_bb1_ld__u0_NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_exitcond_GUARD_valid_out;
wire local_bb1_exitcond_GUARD_stall_in;
wire local_bb1_exitcond_GUARD_inputs_ready;
wire local_bb1_exitcond_GUARD_stall_local;
wire local_bb1_exitcond_GUARD;

assign local_bb1_exitcond_GUARD_inputs_ready = rnode_332to333_bb1_indvars_iv_next_0_valid_out_0_NO_SHIFT_REG;
assign local_bb1_exitcond_GUARD = (local_bb1_exitcond | input_wii_cmp1);
assign local_bb1_exitcond_GUARD_valid_out = local_bb1_exitcond_GUARD_inputs_ready;
assign local_bb1_exitcond_GUARD_stall_local = local_bb1_exitcond_GUARD_stall_in;
assign rnode_332to333_bb1_indvars_iv_next_0_stall_in_0_NO_SHIFT_REG = (|local_bb1_exitcond_GUARD_stall_local);

// This section implements an unregistered operation.
// 
wire local_bb1_c0_eni2_stall_local;
wire [127:0] local_bb1_c0_eni2;

assign local_bb1_c0_eni2[63:0] = local_bb1_c0_eni1[63:0];
assign local_bb1_c0_eni2[95:64] = rstag_321to321_bb1_ld__u0;
assign local_bb1_c0_eni2[127:96] = local_bb1_c0_eni1[127:96];

// This section implements an unregistered operation.
// 
wire local_bb1_c0_eni3_valid_out;
wire local_bb1_c0_eni3_stall_in;
wire local_bb1_c0_eni3_inputs_ready;
wire local_bb1_c0_eni3_stall_local;
wire [127:0] local_bb1_c0_eni3;

assign local_bb1_c0_eni3_inputs_ready = (rnode_320to321_rank_new_02_0_valid_out_NO_SHIFT_REG & rstag_321to321_bb1_ld__u0_valid_out & rnode_320to321_bb1_cmp2_0_valid_out_NO_SHIFT_REG);
assign local_bb1_c0_eni3[95:0] = local_bb1_c0_eni2[95:0];
assign local_bb1_c0_eni3[96] = rnode_320to321_bb1_cmp2_0_NO_SHIFT_REG;
assign local_bb1_c0_eni3[127:97] = local_bb1_c0_eni2[127:97];
assign local_bb1_c0_eni3_valid_out = local_bb1_c0_eni3_inputs_ready;
assign local_bb1_c0_eni3_stall_local = local_bb1_c0_eni3_stall_in;
assign rnode_320to321_rank_new_02_0_stall_in_NO_SHIFT_REG = (local_bb1_c0_eni3_stall_local | ~(local_bb1_c0_eni3_inputs_ready));
assign rstag_321to321_bb1_ld__u0_stall_in = (local_bb1_c0_eni3_stall_local | ~(local_bb1_c0_eni3_inputs_ready));
assign rnode_320to321_bb1_cmp2_0_stall_in_NO_SHIFT_REG = (local_bb1_c0_eni3_stall_local | ~(local_bb1_c0_eni3_inputs_ready));

// This section implements a registered operation.
// 
wire local_bb1_c0_enter_c0_eni3_inputs_ready;
 reg local_bb1_c0_enter_c0_eni3_valid_out_0_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni3_stall_in_0;
 reg local_bb1_c0_enter_c0_eni3_valid_out_1_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni3_stall_in_1;
 reg local_bb1_c0_enter_c0_eni3_valid_out_2_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni3_stall_in_2;
wire local_bb1_c0_enter_c0_eni3_output_regs_ready;
 reg [127:0] local_bb1_c0_enter_c0_eni3_NO_SHIFT_REG;
wire local_bb1_c0_enter_c0_eni3_input_accepted;
wire local_bb1_c0_exit_c0_exi1_entry_stall;
wire local_bb1_c0_exit_c0_exi1_output_regs_ready;
wire [7:0] local_bb1_c0_exit_c0_exi1_valid_bits;
wire local_bb1_c0_exit_c0_exi1_phases;
wire local_bb1_c0_enter_c0_eni3_inc_pipelined_thread;
wire local_bb1_c0_enter_c0_eni3_dec_pipelined_thread;
wire local_bb1_c0_enter_c0_eni3_causedstall;

assign local_bb1_c0_enter_c0_eni3_inputs_ready = local_bb1_c0_eni3_valid_out;
assign local_bb1_c0_enter_c0_eni3_output_regs_ready = 1'b1;
assign local_bb1_c0_enter_c0_eni3_input_accepted = (local_bb1_c0_enter_c0_eni3_inputs_ready && !(local_bb1_c0_exit_c0_exi1_entry_stall));
assign local_bb1_c0_enter_c0_eni3_inc_pipelined_thread = 1'b1;
assign local_bb1_c0_enter_c0_eni3_dec_pipelined_thread = ~(1'b0);
assign local_bb1_c0_eni3_stall_in = ((~(local_bb1_c0_enter_c0_eni3_inputs_ready) | local_bb1_c0_exit_c0_exi1_entry_stall) | ~(1'b1));
assign local_bb1_c0_enter_c0_eni3_causedstall = (1'b1 && ((~(local_bb1_c0_enter_c0_eni3_inputs_ready) | local_bb1_c0_exit_c0_exi1_entry_stall) && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c0_enter_c0_eni3_NO_SHIFT_REG <= 'x;
		local_bb1_c0_enter_c0_eni3_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_c0_enter_c0_eni3_valid_out_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_c0_enter_c0_eni3_valid_out_2_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_c0_enter_c0_eni3_output_regs_ready)
		begin
			local_bb1_c0_enter_c0_eni3_NO_SHIFT_REG <= local_bb1_c0_eni3;
			local_bb1_c0_enter_c0_eni3_valid_out_0_NO_SHIFT_REG <= 1'b1;
			local_bb1_c0_enter_c0_eni3_valid_out_1_NO_SHIFT_REG <= 1'b1;
			local_bb1_c0_enter_c0_eni3_valid_out_2_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb1_c0_enter_c0_eni3_stall_in_0))
			begin
				local_bb1_c0_enter_c0_eni3_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c0_enter_c0_eni3_stall_in_1))
			begin
				local_bb1_c0_enter_c0_eni3_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_c0_enter_c0_eni3_stall_in_2))
			begin
				local_bb1_c0_enter_c0_eni3_valid_out_2_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c0_ene1_stall_local;
wire [31:0] local_bb1_c0_ene1;

assign local_bb1_c0_ene1 = local_bb1_c0_enter_c0_eni3_NO_SHIFT_REG[63:32];

// This section implements an unregistered operation.
// 
wire local_bb1_c0_ene2_stall_local;
wire [31:0] local_bb1_c0_ene2;

assign local_bb1_c0_ene2 = local_bb1_c0_enter_c0_eni3_NO_SHIFT_REG[95:64];

// This section implements an unregistered operation.
// 
wire local_bb1_c0_ene3_valid_out;
wire local_bb1_c0_ene3_stall_in;
wire local_bb1_c0_ene3_inputs_ready;
wire local_bb1_c0_ene3_stall_local;
wire local_bb1_c0_ene3;

assign local_bb1_c0_ene3_inputs_ready = local_bb1_c0_enter_c0_eni3_valid_out_2_NO_SHIFT_REG;
assign local_bb1_c0_ene3 = local_bb1_c0_enter_c0_eni3_NO_SHIFT_REG[96];
assign local_bb1_c0_ene3_valid_out = 1'b1;
assign local_bb1_c0_enter_c0_eni3_stall_in_2 = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_var__stall_local;
wire [31:0] local_bb1_var_;

assign local_bb1_var_ = local_bb1_c0_ene1;

// This section implements an unregistered operation.
// 
wire local_bb1_var__u1_stall_local;
wire [31:0] local_bb1_var__u1;

assign local_bb1_var__u1 = local_bb1_c0_ene2;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_322to323_bb1_c0_ene3_0_valid_out_NO_SHIFT_REG;
 logic rnode_322to323_bb1_c0_ene3_0_stall_in_NO_SHIFT_REG;
 logic rnode_322to323_bb1_c0_ene3_0_NO_SHIFT_REG;
 logic rnode_322to323_bb1_c0_ene3_0_reg_323_inputs_ready_NO_SHIFT_REG;
 logic rnode_322to323_bb1_c0_ene3_0_reg_323_NO_SHIFT_REG;
 logic rnode_322to323_bb1_c0_ene3_0_valid_out_reg_323_NO_SHIFT_REG;
 logic rnode_322to323_bb1_c0_ene3_0_stall_in_reg_323_NO_SHIFT_REG;
 logic rnode_322to323_bb1_c0_ene3_0_stall_out_reg_323_NO_SHIFT_REG;

acl_data_fifo rnode_322to323_bb1_c0_ene3_0_reg_323_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_322to323_bb1_c0_ene3_0_reg_323_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_322to323_bb1_c0_ene3_0_stall_in_reg_323_NO_SHIFT_REG),
	.valid_out(rnode_322to323_bb1_c0_ene3_0_valid_out_reg_323_NO_SHIFT_REG),
	.stall_out(rnode_322to323_bb1_c0_ene3_0_stall_out_reg_323_NO_SHIFT_REG),
	.data_in(local_bb1_c0_ene3),
	.data_out(rnode_322to323_bb1_c0_ene3_0_reg_323_NO_SHIFT_REG)
);

defparam rnode_322to323_bb1_c0_ene3_0_reg_323_fifo.DEPTH = 1;
defparam rnode_322to323_bb1_c0_ene3_0_reg_323_fifo.DATA_WIDTH = 1;
defparam rnode_322to323_bb1_c0_ene3_0_reg_323_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_322to323_bb1_c0_ene3_0_reg_323_fifo.IMPL = "shift_reg";

assign rnode_322to323_bb1_c0_ene3_0_reg_323_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_c0_ene3_stall_in = 1'b0;
assign rnode_322to323_bb1_c0_ene3_0_NO_SHIFT_REG = rnode_322to323_bb1_c0_ene3_0_reg_323_NO_SHIFT_REG;
assign rnode_322to323_bb1_c0_ene3_0_stall_in_reg_323_NO_SHIFT_REG = 1'b0;
assign rnode_322to323_bb1_c0_ene3_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_and2_i_stall_local;
wire [31:0] local_bb1_and2_i;

assign local_bb1_and2_i = (local_bb1_var_ >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb1_and12_i_stall_local;
wire [31:0] local_bb1_and12_i;

assign local_bb1_and12_i = (local_bb1_var_ & 32'hFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_and_i_stall_local;
wire [31:0] local_bb1_and_i;

assign local_bb1_and_i = (local_bb1_var__u1 >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb1_and10_i_stall_local;
wire [31:0] local_bb1_and10_i;

assign local_bb1_and10_i = (local_bb1_var__u1 & 32'hFFFF);

// Register node:
//  * latency = 4
//  * capacity = 4
 logic rnode_323to327_bb1_c0_ene3_0_valid_out_NO_SHIFT_REG;
 logic rnode_323to327_bb1_c0_ene3_0_stall_in_NO_SHIFT_REG;
 logic rnode_323to327_bb1_c0_ene3_0_NO_SHIFT_REG;
 logic rnode_323to327_bb1_c0_ene3_0_reg_327_inputs_ready_NO_SHIFT_REG;
 logic rnode_323to327_bb1_c0_ene3_0_reg_327_NO_SHIFT_REG;
 logic rnode_323to327_bb1_c0_ene3_0_valid_out_reg_327_NO_SHIFT_REG;
 logic rnode_323to327_bb1_c0_ene3_0_stall_in_reg_327_NO_SHIFT_REG;
 logic rnode_323to327_bb1_c0_ene3_0_stall_out_reg_327_NO_SHIFT_REG;

acl_data_fifo rnode_323to327_bb1_c0_ene3_0_reg_327_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_323to327_bb1_c0_ene3_0_reg_327_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_323to327_bb1_c0_ene3_0_stall_in_reg_327_NO_SHIFT_REG),
	.valid_out(rnode_323to327_bb1_c0_ene3_0_valid_out_reg_327_NO_SHIFT_REG),
	.stall_out(rnode_323to327_bb1_c0_ene3_0_stall_out_reg_327_NO_SHIFT_REG),
	.data_in(rnode_322to323_bb1_c0_ene3_0_NO_SHIFT_REG),
	.data_out(rnode_323to327_bb1_c0_ene3_0_reg_327_NO_SHIFT_REG)
);

defparam rnode_323to327_bb1_c0_ene3_0_reg_327_fifo.DEPTH = 4;
defparam rnode_323to327_bb1_c0_ene3_0_reg_327_fifo.DATA_WIDTH = 1;
defparam rnode_323to327_bb1_c0_ene3_0_reg_327_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_323to327_bb1_c0_ene3_0_reg_327_fifo.IMPL = "shift_reg";

assign rnode_323to327_bb1_c0_ene3_0_reg_327_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_322to323_bb1_c0_ene3_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_323to327_bb1_c0_ene3_0_NO_SHIFT_REG = rnode_323to327_bb1_c0_ene3_0_reg_327_NO_SHIFT_REG;
assign rnode_323to327_bb1_c0_ene3_0_stall_in_reg_327_NO_SHIFT_REG = 1'b0;
assign rnode_323to327_bb1_c0_ene3_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_shr3_i_stall_local;
wire [31:0] local_bb1_shr3_i;

assign local_bb1_shr3_i = (local_bb1_and2_i & 32'h7FFF);

// This section implements an unregistered operation.
// 
wire local_bb1_shr_i_stall_local;
wire [31:0] local_bb1_shr_i;

assign local_bb1_shr_i = (local_bb1_and_i & 32'h7FFF);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp13_i_stall_local;
wire local_bb1_cmp13_i;

assign local_bb1_cmp13_i = (local_bb1_and10_i > local_bb1_and12_i);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_327to328_bb1_c0_ene3_0_valid_out_NO_SHIFT_REG;
 logic rnode_327to328_bb1_c0_ene3_0_stall_in_NO_SHIFT_REG;
 logic rnode_327to328_bb1_c0_ene3_0_NO_SHIFT_REG;
 logic rnode_327to328_bb1_c0_ene3_0_reg_328_inputs_ready_NO_SHIFT_REG;
 logic rnode_327to328_bb1_c0_ene3_0_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_c0_ene3_0_valid_out_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_c0_ene3_0_stall_in_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_c0_ene3_0_stall_out_reg_328_NO_SHIFT_REG;

acl_data_fifo rnode_327to328_bb1_c0_ene3_0_reg_328_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_327to328_bb1_c0_ene3_0_reg_328_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_327to328_bb1_c0_ene3_0_stall_in_reg_328_NO_SHIFT_REG),
	.valid_out(rnode_327to328_bb1_c0_ene3_0_valid_out_reg_328_NO_SHIFT_REG),
	.stall_out(rnode_327to328_bb1_c0_ene3_0_stall_out_reg_328_NO_SHIFT_REG),
	.data_in(rnode_323to327_bb1_c0_ene3_0_NO_SHIFT_REG),
	.data_out(rnode_327to328_bb1_c0_ene3_0_reg_328_NO_SHIFT_REG)
);

defparam rnode_327to328_bb1_c0_ene3_0_reg_328_fifo.DEPTH = 1;
defparam rnode_327to328_bb1_c0_ene3_0_reg_328_fifo.DATA_WIDTH = 1;
defparam rnode_327to328_bb1_c0_ene3_0_reg_328_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_327to328_bb1_c0_ene3_0_reg_328_fifo.IMPL = "shift_reg";

assign rnode_327to328_bb1_c0_ene3_0_reg_328_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_323to327_bb1_c0_ene3_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_327to328_bb1_c0_ene3_0_NO_SHIFT_REG = rnode_327to328_bb1_c0_ene3_0_reg_328_NO_SHIFT_REG;
assign rnode_327to328_bb1_c0_ene3_0_stall_in_reg_328_NO_SHIFT_REG = 1'b0;
assign rnode_327to328_bb1_c0_ene3_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_cmp_i_stall_local;
wire local_bb1_cmp_i;

assign local_bb1_cmp_i = (local_bb1_shr_i > local_bb1_shr3_i);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp8_i_stall_local;
wire local_bb1_cmp8_i;

assign local_bb1_cmp8_i = (local_bb1_shr_i == local_bb1_shr3_i);

// This section implements an unregistered operation.
// 
wire local_bb1___i_stall_local;
wire local_bb1___i;

assign local_bb1___i = (local_bb1_cmp8_i & local_bb1_cmp13_i);

// This section implements an unregistered operation.
// 
wire local_bb1__21_i_stall_local;
wire local_bb1__21_i;

assign local_bb1__21_i = (local_bb1_cmp_i | local_bb1___i);

// This section implements an unregistered operation.
// 
wire local_bb1__22_i_stall_local;
wire [31:0] local_bb1__22_i;

assign local_bb1__22_i = (local_bb1__21_i ? local_bb1_var_ : local_bb1_var__u1);

// This section implements an unregistered operation.
// 
wire local_bb1_c0_ene1_valid_out_1;
wire local_bb1_c0_ene1_stall_in_1;
 reg local_bb1_c0_ene1_consumed_1_NO_SHIFT_REG;
wire local_bb1__22_i_valid_out;
wire local_bb1__22_i_stall_in;
 reg local_bb1__22_i_consumed_0_NO_SHIFT_REG;
wire local_bb1__23_i_valid_out;
wire local_bb1__23_i_stall_in;
 reg local_bb1__23_i_consumed_0_NO_SHIFT_REG;
wire local_bb1__23_i_inputs_ready;
wire local_bb1__23_i_stall_local;
wire [31:0] local_bb1__23_i;

assign local_bb1__23_i_inputs_ready = (local_bb1_c0_enter_c0_eni3_valid_out_0_NO_SHIFT_REG & local_bb1_c0_enter_c0_eni3_valid_out_1_NO_SHIFT_REG);
assign local_bb1__23_i = (local_bb1__21_i ? local_bb1_var__u1 : local_bb1_var_);
assign local_bb1_c0_ene1_valid_out_1 = 1'b1;
assign local_bb1__22_i_valid_out = 1'b1;
assign local_bb1__23_i_valid_out = 1'b1;
assign local_bb1_c0_enter_c0_eni3_stall_in_0 = 1'b0;
assign local_bb1_c0_enter_c0_eni3_stall_in_1 = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c0_ene1_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb1__22_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1__23_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_c0_ene1_consumed_1_NO_SHIFT_REG <= (local_bb1__23_i_inputs_ready & (local_bb1_c0_ene1_consumed_1_NO_SHIFT_REG | ~(local_bb1_c0_ene1_stall_in_1)) & local_bb1__23_i_stall_local);
		local_bb1__22_i_consumed_0_NO_SHIFT_REG <= (local_bb1__23_i_inputs_ready & (local_bb1__22_i_consumed_0_NO_SHIFT_REG | ~(local_bb1__22_i_stall_in)) & local_bb1__23_i_stall_local);
		local_bb1__23_i_consumed_0_NO_SHIFT_REG <= (local_bb1__23_i_inputs_ready & (local_bb1__23_i_consumed_0_NO_SHIFT_REG | ~(local_bb1__23_i_stall_in)) & local_bb1__23_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_322to323_bb1_c0_ene1_0_valid_out_NO_SHIFT_REG;
 logic rnode_322to323_bb1_c0_ene1_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_322to323_bb1_c0_ene1_0_NO_SHIFT_REG;
 logic rnode_322to323_bb1_c0_ene1_0_reg_323_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_322to323_bb1_c0_ene1_0_reg_323_NO_SHIFT_REG;
 logic rnode_322to323_bb1_c0_ene1_0_valid_out_reg_323_NO_SHIFT_REG;
 logic rnode_322to323_bb1_c0_ene1_0_stall_in_reg_323_NO_SHIFT_REG;
 logic rnode_322to323_bb1_c0_ene1_0_stall_out_reg_323_NO_SHIFT_REG;

acl_data_fifo rnode_322to323_bb1_c0_ene1_0_reg_323_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_322to323_bb1_c0_ene1_0_reg_323_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_322to323_bb1_c0_ene1_0_stall_in_reg_323_NO_SHIFT_REG),
	.valid_out(rnode_322to323_bb1_c0_ene1_0_valid_out_reg_323_NO_SHIFT_REG),
	.stall_out(rnode_322to323_bb1_c0_ene1_0_stall_out_reg_323_NO_SHIFT_REG),
	.data_in(local_bb1_c0_ene1),
	.data_out(rnode_322to323_bb1_c0_ene1_0_reg_323_NO_SHIFT_REG)
);

defparam rnode_322to323_bb1_c0_ene1_0_reg_323_fifo.DEPTH = 1;
defparam rnode_322to323_bb1_c0_ene1_0_reg_323_fifo.DATA_WIDTH = 32;
defparam rnode_322to323_bb1_c0_ene1_0_reg_323_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_322to323_bb1_c0_ene1_0_reg_323_fifo.IMPL = "shift_reg";

assign rnode_322to323_bb1_c0_ene1_0_reg_323_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_c0_ene1_stall_in_1 = 1'b0;
assign rnode_322to323_bb1_c0_ene1_0_NO_SHIFT_REG = rnode_322to323_bb1_c0_ene1_0_reg_323_NO_SHIFT_REG;
assign rnode_322to323_bb1_c0_ene1_0_stall_in_reg_323_NO_SHIFT_REG = 1'b0;
assign rnode_322to323_bb1_c0_ene1_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_322to323_bb1__22_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_322to323_bb1__22_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_322to323_bb1__22_i_0_NO_SHIFT_REG;
 logic rnode_322to323_bb1__22_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_322to323_bb1__22_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_322to323_bb1__22_i_1_NO_SHIFT_REG;
 logic rnode_322to323_bb1__22_i_0_reg_323_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_322to323_bb1__22_i_0_reg_323_NO_SHIFT_REG;
 logic rnode_322to323_bb1__22_i_0_valid_out_0_reg_323_NO_SHIFT_REG;
 logic rnode_322to323_bb1__22_i_0_stall_in_0_reg_323_NO_SHIFT_REG;
 logic rnode_322to323_bb1__22_i_0_stall_out_reg_323_NO_SHIFT_REG;

acl_data_fifo rnode_322to323_bb1__22_i_0_reg_323_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_322to323_bb1__22_i_0_reg_323_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_322to323_bb1__22_i_0_stall_in_0_reg_323_NO_SHIFT_REG),
	.valid_out(rnode_322to323_bb1__22_i_0_valid_out_0_reg_323_NO_SHIFT_REG),
	.stall_out(rnode_322to323_bb1__22_i_0_stall_out_reg_323_NO_SHIFT_REG),
	.data_in(local_bb1__22_i),
	.data_out(rnode_322to323_bb1__22_i_0_reg_323_NO_SHIFT_REG)
);

defparam rnode_322to323_bb1__22_i_0_reg_323_fifo.DEPTH = 1;
defparam rnode_322to323_bb1__22_i_0_reg_323_fifo.DATA_WIDTH = 32;
defparam rnode_322to323_bb1__22_i_0_reg_323_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_322to323_bb1__22_i_0_reg_323_fifo.IMPL = "shift_reg";

assign rnode_322to323_bb1__22_i_0_reg_323_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1__22_i_stall_in = 1'b0;
assign rnode_322to323_bb1__22_i_0_stall_in_0_reg_323_NO_SHIFT_REG = 1'b0;
assign rnode_322to323_bb1__22_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_322to323_bb1__22_i_0_NO_SHIFT_REG = rnode_322to323_bb1__22_i_0_reg_323_NO_SHIFT_REG;
assign rnode_322to323_bb1__22_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_322to323_bb1__22_i_1_NO_SHIFT_REG = rnode_322to323_bb1__22_i_0_reg_323_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_322to323_bb1__23_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_322to323_bb1__23_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_322to323_bb1__23_i_0_NO_SHIFT_REG;
 logic rnode_322to323_bb1__23_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_322to323_bb1__23_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_322to323_bb1__23_i_1_NO_SHIFT_REG;
 logic rnode_322to323_bb1__23_i_0_reg_323_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_322to323_bb1__23_i_0_reg_323_NO_SHIFT_REG;
 logic rnode_322to323_bb1__23_i_0_valid_out_0_reg_323_NO_SHIFT_REG;
 logic rnode_322to323_bb1__23_i_0_stall_in_0_reg_323_NO_SHIFT_REG;
 logic rnode_322to323_bb1__23_i_0_stall_out_reg_323_NO_SHIFT_REG;

acl_data_fifo rnode_322to323_bb1__23_i_0_reg_323_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_322to323_bb1__23_i_0_reg_323_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_322to323_bb1__23_i_0_stall_in_0_reg_323_NO_SHIFT_REG),
	.valid_out(rnode_322to323_bb1__23_i_0_valid_out_0_reg_323_NO_SHIFT_REG),
	.stall_out(rnode_322to323_bb1__23_i_0_stall_out_reg_323_NO_SHIFT_REG),
	.data_in(local_bb1__23_i),
	.data_out(rnode_322to323_bb1__23_i_0_reg_323_NO_SHIFT_REG)
);

defparam rnode_322to323_bb1__23_i_0_reg_323_fifo.DEPTH = 1;
defparam rnode_322to323_bb1__23_i_0_reg_323_fifo.DATA_WIDTH = 32;
defparam rnode_322to323_bb1__23_i_0_reg_323_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_322to323_bb1__23_i_0_reg_323_fifo.IMPL = "shift_reg";

assign rnode_322to323_bb1__23_i_0_reg_323_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1__23_i_stall_in = 1'b0;
assign rnode_322to323_bb1__23_i_0_stall_in_0_reg_323_NO_SHIFT_REG = 1'b0;
assign rnode_322to323_bb1__23_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_322to323_bb1__23_i_0_NO_SHIFT_REG = rnode_322to323_bb1__23_i_0_reg_323_NO_SHIFT_REG;
assign rnode_322to323_bb1__23_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_322to323_bb1__23_i_1_NO_SHIFT_REG = rnode_322to323_bb1__23_i_0_reg_323_NO_SHIFT_REG;

// Register node:
//  * latency = 4
//  * capacity = 4
 logic rnode_323to327_bb1_c0_ene1_0_valid_out_NO_SHIFT_REG;
 logic rnode_323to327_bb1_c0_ene1_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_323to327_bb1_c0_ene1_0_NO_SHIFT_REG;
 logic rnode_323to327_bb1_c0_ene1_0_reg_327_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_323to327_bb1_c0_ene1_0_reg_327_NO_SHIFT_REG;
 logic rnode_323to327_bb1_c0_ene1_0_valid_out_reg_327_NO_SHIFT_REG;
 logic rnode_323to327_bb1_c0_ene1_0_stall_in_reg_327_NO_SHIFT_REG;
 logic rnode_323to327_bb1_c0_ene1_0_stall_out_reg_327_NO_SHIFT_REG;

acl_data_fifo rnode_323to327_bb1_c0_ene1_0_reg_327_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_323to327_bb1_c0_ene1_0_reg_327_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_323to327_bb1_c0_ene1_0_stall_in_reg_327_NO_SHIFT_REG),
	.valid_out(rnode_323to327_bb1_c0_ene1_0_valid_out_reg_327_NO_SHIFT_REG),
	.stall_out(rnode_323to327_bb1_c0_ene1_0_stall_out_reg_327_NO_SHIFT_REG),
	.data_in(rnode_322to323_bb1_c0_ene1_0_NO_SHIFT_REG),
	.data_out(rnode_323to327_bb1_c0_ene1_0_reg_327_NO_SHIFT_REG)
);

defparam rnode_323to327_bb1_c0_ene1_0_reg_327_fifo.DEPTH = 4;
defparam rnode_323to327_bb1_c0_ene1_0_reg_327_fifo.DATA_WIDTH = 32;
defparam rnode_323to327_bb1_c0_ene1_0_reg_327_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_323to327_bb1_c0_ene1_0_reg_327_fifo.IMPL = "shift_reg";

assign rnode_323to327_bb1_c0_ene1_0_reg_327_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_322to323_bb1_c0_ene1_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_323to327_bb1_c0_ene1_0_NO_SHIFT_REG = rnode_323to327_bb1_c0_ene1_0_reg_327_NO_SHIFT_REG;
assign rnode_323to327_bb1_c0_ene1_0_stall_in_reg_327_NO_SHIFT_REG = 1'b0;
assign rnode_323to327_bb1_c0_ene1_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_shr18_i_stall_local;
wire [31:0] local_bb1_shr18_i;

assign local_bb1_shr18_i = (rnode_322to323_bb1__22_i_0_NO_SHIFT_REG >> 32'h17);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_323to324_bb1__22_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_323to324_bb1__22_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_323to324_bb1__22_i_0_NO_SHIFT_REG;
 logic rnode_323to324_bb1__22_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_323to324_bb1__22_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_323to324_bb1__22_i_1_NO_SHIFT_REG;
 logic rnode_323to324_bb1__22_i_0_reg_324_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_323to324_bb1__22_i_0_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1__22_i_0_valid_out_0_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1__22_i_0_stall_in_0_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1__22_i_0_stall_out_reg_324_NO_SHIFT_REG;

acl_data_fifo rnode_323to324_bb1__22_i_0_reg_324_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_323to324_bb1__22_i_0_reg_324_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_323to324_bb1__22_i_0_stall_in_0_reg_324_NO_SHIFT_REG),
	.valid_out(rnode_323to324_bb1__22_i_0_valid_out_0_reg_324_NO_SHIFT_REG),
	.stall_out(rnode_323to324_bb1__22_i_0_stall_out_reg_324_NO_SHIFT_REG),
	.data_in(rnode_322to323_bb1__22_i_1_NO_SHIFT_REG),
	.data_out(rnode_323to324_bb1__22_i_0_reg_324_NO_SHIFT_REG)
);

defparam rnode_323to324_bb1__22_i_0_reg_324_fifo.DEPTH = 1;
defparam rnode_323to324_bb1__22_i_0_reg_324_fifo.DATA_WIDTH = 32;
defparam rnode_323to324_bb1__22_i_0_reg_324_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_323to324_bb1__22_i_0_reg_324_fifo.IMPL = "shift_reg";

assign rnode_323to324_bb1__22_i_0_reg_324_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_322to323_bb1__22_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1__22_i_0_stall_in_0_reg_324_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1__22_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_323to324_bb1__22_i_0_NO_SHIFT_REG = rnode_323to324_bb1__22_i_0_reg_324_NO_SHIFT_REG;
assign rnode_323to324_bb1__22_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_323to324_bb1__22_i_1_NO_SHIFT_REG = rnode_323to324_bb1__22_i_0_reg_324_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_shr16_i_stall_local;
wire [31:0] local_bb1_shr16_i;

assign local_bb1_shr16_i = (rnode_322to323_bb1__23_i_0_NO_SHIFT_REG >> 32'h17);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_323to324_bb1__23_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_323to324_bb1__23_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_323to324_bb1__23_i_0_NO_SHIFT_REG;
 logic rnode_323to324_bb1__23_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_323to324_bb1__23_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_323to324_bb1__23_i_1_NO_SHIFT_REG;
 logic rnode_323to324_bb1__23_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_323to324_bb1__23_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_323to324_bb1__23_i_2_NO_SHIFT_REG;
 logic rnode_323to324_bb1__23_i_0_reg_324_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_323to324_bb1__23_i_0_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1__23_i_0_valid_out_0_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1__23_i_0_stall_in_0_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1__23_i_0_stall_out_reg_324_NO_SHIFT_REG;

acl_data_fifo rnode_323to324_bb1__23_i_0_reg_324_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_323to324_bb1__23_i_0_reg_324_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_323to324_bb1__23_i_0_stall_in_0_reg_324_NO_SHIFT_REG),
	.valid_out(rnode_323to324_bb1__23_i_0_valid_out_0_reg_324_NO_SHIFT_REG),
	.stall_out(rnode_323to324_bb1__23_i_0_stall_out_reg_324_NO_SHIFT_REG),
	.data_in(rnode_322to323_bb1__23_i_1_NO_SHIFT_REG),
	.data_out(rnode_323to324_bb1__23_i_0_reg_324_NO_SHIFT_REG)
);

defparam rnode_323to324_bb1__23_i_0_reg_324_fifo.DEPTH = 1;
defparam rnode_323to324_bb1__23_i_0_reg_324_fifo.DATA_WIDTH = 32;
defparam rnode_323to324_bb1__23_i_0_reg_324_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_323to324_bb1__23_i_0_reg_324_fifo.IMPL = "shift_reg";

assign rnode_323to324_bb1__23_i_0_reg_324_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_322to323_bb1__23_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1__23_i_0_stall_in_0_reg_324_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1__23_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_323to324_bb1__23_i_0_NO_SHIFT_REG = rnode_323to324_bb1__23_i_0_reg_324_NO_SHIFT_REG;
assign rnode_323to324_bb1__23_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_323to324_bb1__23_i_1_NO_SHIFT_REG = rnode_323to324_bb1__23_i_0_reg_324_NO_SHIFT_REG;
assign rnode_323to324_bb1__23_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_323to324_bb1__23_i_2_NO_SHIFT_REG = rnode_323to324_bb1__23_i_0_reg_324_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_327to328_bb1_c0_ene1_0_valid_out_NO_SHIFT_REG;
 logic rnode_327to328_bb1_c0_ene1_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_327to328_bb1_c0_ene1_0_NO_SHIFT_REG;
 logic rnode_327to328_bb1_c0_ene1_0_reg_328_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_327to328_bb1_c0_ene1_0_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_c0_ene1_0_valid_out_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_c0_ene1_0_stall_in_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_c0_ene1_0_stall_out_reg_328_NO_SHIFT_REG;

acl_data_fifo rnode_327to328_bb1_c0_ene1_0_reg_328_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_327to328_bb1_c0_ene1_0_reg_328_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_327to328_bb1_c0_ene1_0_stall_in_reg_328_NO_SHIFT_REG),
	.valid_out(rnode_327to328_bb1_c0_ene1_0_valid_out_reg_328_NO_SHIFT_REG),
	.stall_out(rnode_327to328_bb1_c0_ene1_0_stall_out_reg_328_NO_SHIFT_REG),
	.data_in(rnode_323to327_bb1_c0_ene1_0_NO_SHIFT_REG),
	.data_out(rnode_327to328_bb1_c0_ene1_0_reg_328_NO_SHIFT_REG)
);

defparam rnode_327to328_bb1_c0_ene1_0_reg_328_fifo.DEPTH = 1;
defparam rnode_327to328_bb1_c0_ene1_0_reg_328_fifo.DATA_WIDTH = 32;
defparam rnode_327to328_bb1_c0_ene1_0_reg_328_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_327to328_bb1_c0_ene1_0_reg_328_fifo.IMPL = "shift_reg";

assign rnode_327to328_bb1_c0_ene1_0_reg_328_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_323to327_bb1_c0_ene1_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_327to328_bb1_c0_ene1_0_NO_SHIFT_REG = rnode_327to328_bb1_c0_ene1_0_reg_328_NO_SHIFT_REG;
assign rnode_327to328_bb1_c0_ene1_0_stall_in_reg_328_NO_SHIFT_REG = 1'b0;
assign rnode_327to328_bb1_c0_ene1_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_and19_i_stall_local;
wire [31:0] local_bb1_and19_i;

assign local_bb1_and19_i = (local_bb1_shr18_i & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_and21_i_stall_local;
wire [31:0] local_bb1_and21_i;

assign local_bb1_and21_i = (rnode_323to324_bb1__22_i_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_sub_i_stall_local;
wire [31:0] local_bb1_sub_i;

assign local_bb1_sub_i = (local_bb1_shr16_i - local_bb1_shr18_i);

// This section implements an unregistered operation.
// 
wire local_bb1_and20_i_stall_local;
wire [31:0] local_bb1_and20_i;

assign local_bb1_and20_i = (rnode_323to324_bb1__23_i_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_and35_i_valid_out;
wire local_bb1_and35_i_stall_in;
wire local_bb1_and35_i_inputs_ready;
wire local_bb1_and35_i_stall_local;
wire [31:0] local_bb1_and35_i;

assign local_bb1_and35_i_inputs_ready = rnode_323to324_bb1__23_i_0_valid_out_1_NO_SHIFT_REG;
assign local_bb1_and35_i = (rnode_323to324_bb1__23_i_1_NO_SHIFT_REG & 32'h80000000);
assign local_bb1_and35_i_valid_out = 1'b1;
assign rnode_323to324_bb1__23_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_xor_i_stall_local;
wire [31:0] local_bb1_xor_i;

assign local_bb1_xor_i = (rnode_323to324_bb1__23_i_2_NO_SHIFT_REG ^ rnode_323to324_bb1__22_i_1_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_lnot23_i_stall_local;
wire local_bb1_lnot23_i;

assign local_bb1_lnot23_i = (local_bb1_and19_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp27_i_stall_local;
wire local_bb1_cmp27_i;

assign local_bb1_cmp27_i = (local_bb1_and19_i == 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_lnot33_not_i_stall_local;
wire local_bb1_lnot33_not_i;

assign local_bb1_lnot33_not_i = (local_bb1_and21_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_or64_i_stall_local;
wire [31:0] local_bb1_or64_i;

assign local_bb1_or64_i = (local_bb1_and21_i << 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_and68_i_stall_local;
wire [31:0] local_bb1_and68_i;

assign local_bb1_and68_i = (local_bb1_sub_i & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_lnot30_i_stall_local;
wire local_bb1_lnot30_i;

assign local_bb1_lnot30_i = (local_bb1_and20_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_or_i_stall_local;
wire [31:0] local_bb1_or_i;

assign local_bb1_or_i = (local_bb1_and20_i << 32'h3);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_324to325_bb1_and35_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_324to325_bb1_and35_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_324to325_bb1_and35_i_0_NO_SHIFT_REG;
 logic rnode_324to325_bb1_and35_i_0_reg_325_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_324to325_bb1_and35_i_0_reg_325_NO_SHIFT_REG;
 logic rnode_324to325_bb1_and35_i_0_valid_out_reg_325_NO_SHIFT_REG;
 logic rnode_324to325_bb1_and35_i_0_stall_in_reg_325_NO_SHIFT_REG;
 logic rnode_324to325_bb1_and35_i_0_stall_out_reg_325_NO_SHIFT_REG;

acl_data_fifo rnode_324to325_bb1_and35_i_0_reg_325_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_324to325_bb1_and35_i_0_reg_325_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_324to325_bb1_and35_i_0_stall_in_reg_325_NO_SHIFT_REG),
	.valid_out(rnode_324to325_bb1_and35_i_0_valid_out_reg_325_NO_SHIFT_REG),
	.stall_out(rnode_324to325_bb1_and35_i_0_stall_out_reg_325_NO_SHIFT_REG),
	.data_in(local_bb1_and35_i),
	.data_out(rnode_324to325_bb1_and35_i_0_reg_325_NO_SHIFT_REG)
);

defparam rnode_324to325_bb1_and35_i_0_reg_325_fifo.DEPTH = 1;
defparam rnode_324to325_bb1_and35_i_0_reg_325_fifo.DATA_WIDTH = 32;
defparam rnode_324to325_bb1_and35_i_0_reg_325_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_324to325_bb1_and35_i_0_reg_325_fifo.IMPL = "shift_reg";

assign rnode_324to325_bb1_and35_i_0_reg_325_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and35_i_stall_in = 1'b0;
assign rnode_324to325_bb1_and35_i_0_NO_SHIFT_REG = rnode_324to325_bb1_and35_i_0_reg_325_NO_SHIFT_REG;
assign rnode_324to325_bb1_and35_i_0_stall_in_reg_325_NO_SHIFT_REG = 1'b0;
assign rnode_324to325_bb1_and35_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_cmp37_i_stall_local;
wire local_bb1_cmp37_i;

assign local_bb1_cmp37_i = ($signed(local_bb1_xor_i) < $signed(32'h0));

// This section implements an unregistered operation.
// 
wire local_bb1_xor_lobit_i_stall_local;
wire [31:0] local_bb1_xor_lobit_i;

assign local_bb1_xor_lobit_i = ($signed(local_bb1_xor_i) >>> 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb1_and36_lobit_i_stall_local;
wire [31:0] local_bb1_and36_lobit_i;

assign local_bb1_and36_lobit_i = (local_bb1_xor_i >> 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb1_shl65_i_stall_local;
wire [31:0] local_bb1_shl65_i;

assign local_bb1_shl65_i = (local_bb1_or64_i | 32'h4000000);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp69_i_stall_local;
wire local_bb1_cmp69_i;

assign local_bb1_cmp69_i = (local_bb1_and68_i > 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb1_lnot30_not_i_stall_local;
wire local_bb1_lnot30_not_i;

assign local_bb1_lnot30_not_i = (local_bb1_lnot30_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb1_shl_i_stall_local;
wire [31:0] local_bb1_shl_i;

assign local_bb1_shl_i = (local_bb1_or_i | 32'h4000000);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_325to326_bb1_and35_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and35_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_325to326_bb1_and35_i_0_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and35_i_0_reg_326_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_325to326_bb1_and35_i_0_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and35_i_0_valid_out_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and35_i_0_stall_in_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and35_i_0_stall_out_reg_326_NO_SHIFT_REG;

acl_data_fifo rnode_325to326_bb1_and35_i_0_reg_326_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_325to326_bb1_and35_i_0_reg_326_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_325to326_bb1_and35_i_0_stall_in_reg_326_NO_SHIFT_REG),
	.valid_out(rnode_325to326_bb1_and35_i_0_valid_out_reg_326_NO_SHIFT_REG),
	.stall_out(rnode_325to326_bb1_and35_i_0_stall_out_reg_326_NO_SHIFT_REG),
	.data_in(rnode_324to325_bb1_and35_i_0_NO_SHIFT_REG),
	.data_out(rnode_325to326_bb1_and35_i_0_reg_326_NO_SHIFT_REG)
);

defparam rnode_325to326_bb1_and35_i_0_reg_326_fifo.DEPTH = 1;
defparam rnode_325to326_bb1_and35_i_0_reg_326_fifo.DATA_WIDTH = 32;
defparam rnode_325to326_bb1_and35_i_0_reg_326_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_325to326_bb1_and35_i_0_reg_326_fifo.IMPL = "shift_reg";

assign rnode_325to326_bb1_and35_i_0_reg_326_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_324to325_bb1_and35_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1_and35_i_0_NO_SHIFT_REG = rnode_325to326_bb1_and35_i_0_reg_326_NO_SHIFT_REG;
assign rnode_325to326_bb1_and35_i_0_stall_in_reg_326_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1_and35_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_shr16_i_valid_out_1;
wire local_bb1_shr16_i_stall_in_1;
 reg local_bb1_shr16_i_consumed_1_NO_SHIFT_REG;
wire local_bb1_lnot23_i_valid_out;
wire local_bb1_lnot23_i_stall_in;
 reg local_bb1_lnot23_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_cmp27_i_valid_out;
wire local_bb1_cmp27_i_stall_in;
 reg local_bb1_cmp27_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_align_0_i_valid_out;
wire local_bb1_align_0_i_stall_in;
 reg local_bb1_align_0_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_align_0_i_inputs_ready;
wire local_bb1_align_0_i_stall_local;
wire [31:0] local_bb1_align_0_i;

assign local_bb1_align_0_i_inputs_ready = (rnode_322to323_bb1__22_i_0_valid_out_0_NO_SHIFT_REG & rnode_322to323_bb1__23_i_0_valid_out_0_NO_SHIFT_REG);
assign local_bb1_align_0_i = (local_bb1_cmp69_i ? 32'h1F : local_bb1_and68_i);
assign local_bb1_shr16_i_valid_out_1 = 1'b1;
assign local_bb1_lnot23_i_valid_out = 1'b1;
assign local_bb1_cmp27_i_valid_out = 1'b1;
assign local_bb1_align_0_i_valid_out = 1'b1;
assign rnode_322to323_bb1__22_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_322to323_bb1__23_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_shr16_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_lnot23_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_cmp27_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_align_0_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_shr16_i_consumed_1_NO_SHIFT_REG <= (local_bb1_align_0_i_inputs_ready & (local_bb1_shr16_i_consumed_1_NO_SHIFT_REG | ~(local_bb1_shr16_i_stall_in_1)) & local_bb1_align_0_i_stall_local);
		local_bb1_lnot23_i_consumed_0_NO_SHIFT_REG <= (local_bb1_align_0_i_inputs_ready & (local_bb1_lnot23_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_lnot23_i_stall_in)) & local_bb1_align_0_i_stall_local);
		local_bb1_cmp27_i_consumed_0_NO_SHIFT_REG <= (local_bb1_align_0_i_inputs_ready & (local_bb1_cmp27_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_cmp27_i_stall_in)) & local_bb1_align_0_i_stall_local);
		local_bb1_align_0_i_consumed_0_NO_SHIFT_REG <= (local_bb1_align_0_i_inputs_ready & (local_bb1_align_0_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_align_0_i_stall_in)) & local_bb1_align_0_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_326to327_bb1_and35_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_326to327_bb1_and35_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_326to327_bb1_and35_i_0_NO_SHIFT_REG;
 logic rnode_326to327_bb1_and35_i_0_reg_327_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_326to327_bb1_and35_i_0_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_and35_i_0_valid_out_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_and35_i_0_stall_in_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_and35_i_0_stall_out_reg_327_NO_SHIFT_REG;

acl_data_fifo rnode_326to327_bb1_and35_i_0_reg_327_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_326to327_bb1_and35_i_0_reg_327_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_326to327_bb1_and35_i_0_stall_in_reg_327_NO_SHIFT_REG),
	.valid_out(rnode_326to327_bb1_and35_i_0_valid_out_reg_327_NO_SHIFT_REG),
	.stall_out(rnode_326to327_bb1_and35_i_0_stall_out_reg_327_NO_SHIFT_REG),
	.data_in(rnode_325to326_bb1_and35_i_0_NO_SHIFT_REG),
	.data_out(rnode_326to327_bb1_and35_i_0_reg_327_NO_SHIFT_REG)
);

defparam rnode_326to327_bb1_and35_i_0_reg_327_fifo.DEPTH = 1;
defparam rnode_326to327_bb1_and35_i_0_reg_327_fifo.DATA_WIDTH = 32;
defparam rnode_326to327_bb1_and35_i_0_reg_327_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_326to327_bb1_and35_i_0_reg_327_fifo.IMPL = "shift_reg";

assign rnode_326to327_bb1_and35_i_0_reg_327_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_325to326_bb1_and35_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_and35_i_0_NO_SHIFT_REG = rnode_326to327_bb1_and35_i_0_reg_327_NO_SHIFT_REG;
assign rnode_326to327_bb1_and35_i_0_stall_in_reg_327_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_and35_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_323to324_bb1_shr16_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_323to324_bb1_shr16_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_323to324_bb1_shr16_i_0_NO_SHIFT_REG;
 logic rnode_323to324_bb1_shr16_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_323to324_bb1_shr16_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_323to324_bb1_shr16_i_1_NO_SHIFT_REG;
 logic rnode_323to324_bb1_shr16_i_0_reg_324_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_323to324_bb1_shr16_i_0_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1_shr16_i_0_valid_out_0_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1_shr16_i_0_stall_in_0_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1_shr16_i_0_stall_out_reg_324_NO_SHIFT_REG;

acl_data_fifo rnode_323to324_bb1_shr16_i_0_reg_324_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_323to324_bb1_shr16_i_0_reg_324_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_323to324_bb1_shr16_i_0_stall_in_0_reg_324_NO_SHIFT_REG),
	.valid_out(rnode_323to324_bb1_shr16_i_0_valid_out_0_reg_324_NO_SHIFT_REG),
	.stall_out(rnode_323to324_bb1_shr16_i_0_stall_out_reg_324_NO_SHIFT_REG),
	.data_in(local_bb1_shr16_i),
	.data_out(rnode_323to324_bb1_shr16_i_0_reg_324_NO_SHIFT_REG)
);

defparam rnode_323to324_bb1_shr16_i_0_reg_324_fifo.DEPTH = 1;
defparam rnode_323to324_bb1_shr16_i_0_reg_324_fifo.DATA_WIDTH = 32;
defparam rnode_323to324_bb1_shr16_i_0_reg_324_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_323to324_bb1_shr16_i_0_reg_324_fifo.IMPL = "shift_reg";

assign rnode_323to324_bb1_shr16_i_0_reg_324_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_shr16_i_stall_in_1 = 1'b0;
assign rnode_323to324_bb1_shr16_i_0_stall_in_0_reg_324_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1_shr16_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_323to324_bb1_shr16_i_0_NO_SHIFT_REG = rnode_323to324_bb1_shr16_i_0_reg_324_NO_SHIFT_REG;
assign rnode_323to324_bb1_shr16_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_323to324_bb1_shr16_i_1_NO_SHIFT_REG = rnode_323to324_bb1_shr16_i_0_reg_324_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_323to324_bb1_lnot23_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_323to324_bb1_lnot23_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_323to324_bb1_lnot23_i_0_NO_SHIFT_REG;
 logic rnode_323to324_bb1_lnot23_i_0_reg_324_inputs_ready_NO_SHIFT_REG;
 logic rnode_323to324_bb1_lnot23_i_0_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1_lnot23_i_0_valid_out_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1_lnot23_i_0_stall_in_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1_lnot23_i_0_stall_out_reg_324_NO_SHIFT_REG;

acl_data_fifo rnode_323to324_bb1_lnot23_i_0_reg_324_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_323to324_bb1_lnot23_i_0_reg_324_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_323to324_bb1_lnot23_i_0_stall_in_reg_324_NO_SHIFT_REG),
	.valid_out(rnode_323to324_bb1_lnot23_i_0_valid_out_reg_324_NO_SHIFT_REG),
	.stall_out(rnode_323to324_bb1_lnot23_i_0_stall_out_reg_324_NO_SHIFT_REG),
	.data_in(local_bb1_lnot23_i),
	.data_out(rnode_323to324_bb1_lnot23_i_0_reg_324_NO_SHIFT_REG)
);

defparam rnode_323to324_bb1_lnot23_i_0_reg_324_fifo.DEPTH = 1;
defparam rnode_323to324_bb1_lnot23_i_0_reg_324_fifo.DATA_WIDTH = 1;
defparam rnode_323to324_bb1_lnot23_i_0_reg_324_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_323to324_bb1_lnot23_i_0_reg_324_fifo.IMPL = "shift_reg";

assign rnode_323to324_bb1_lnot23_i_0_reg_324_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_lnot23_i_stall_in = 1'b0;
assign rnode_323to324_bb1_lnot23_i_0_NO_SHIFT_REG = rnode_323to324_bb1_lnot23_i_0_reg_324_NO_SHIFT_REG;
assign rnode_323to324_bb1_lnot23_i_0_stall_in_reg_324_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1_lnot23_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_323to324_bb1_cmp27_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_323to324_bb1_cmp27_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_323to324_bb1_cmp27_i_0_NO_SHIFT_REG;
 logic rnode_323to324_bb1_cmp27_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_323to324_bb1_cmp27_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_323to324_bb1_cmp27_i_1_NO_SHIFT_REG;
 logic rnode_323to324_bb1_cmp27_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_323to324_bb1_cmp27_i_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_323to324_bb1_cmp27_i_2_NO_SHIFT_REG;
 logic rnode_323to324_bb1_cmp27_i_0_reg_324_inputs_ready_NO_SHIFT_REG;
 logic rnode_323to324_bb1_cmp27_i_0_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1_cmp27_i_0_valid_out_0_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1_cmp27_i_0_stall_in_0_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1_cmp27_i_0_stall_out_reg_324_NO_SHIFT_REG;

acl_data_fifo rnode_323to324_bb1_cmp27_i_0_reg_324_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_323to324_bb1_cmp27_i_0_reg_324_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_323to324_bb1_cmp27_i_0_stall_in_0_reg_324_NO_SHIFT_REG),
	.valid_out(rnode_323to324_bb1_cmp27_i_0_valid_out_0_reg_324_NO_SHIFT_REG),
	.stall_out(rnode_323to324_bb1_cmp27_i_0_stall_out_reg_324_NO_SHIFT_REG),
	.data_in(local_bb1_cmp27_i),
	.data_out(rnode_323to324_bb1_cmp27_i_0_reg_324_NO_SHIFT_REG)
);

defparam rnode_323to324_bb1_cmp27_i_0_reg_324_fifo.DEPTH = 1;
defparam rnode_323to324_bb1_cmp27_i_0_reg_324_fifo.DATA_WIDTH = 1;
defparam rnode_323to324_bb1_cmp27_i_0_reg_324_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_323to324_bb1_cmp27_i_0_reg_324_fifo.IMPL = "shift_reg";

assign rnode_323to324_bb1_cmp27_i_0_reg_324_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cmp27_i_stall_in = 1'b0;
assign rnode_323to324_bb1_cmp27_i_0_stall_in_0_reg_324_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1_cmp27_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_323to324_bb1_cmp27_i_0_NO_SHIFT_REG = rnode_323to324_bb1_cmp27_i_0_reg_324_NO_SHIFT_REG;
assign rnode_323to324_bb1_cmp27_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_323to324_bb1_cmp27_i_1_NO_SHIFT_REG = rnode_323to324_bb1_cmp27_i_0_reg_324_NO_SHIFT_REG;
assign rnode_323to324_bb1_cmp27_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_323to324_bb1_cmp27_i_2_NO_SHIFT_REG = rnode_323to324_bb1_cmp27_i_0_reg_324_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_323to324_bb1_align_0_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_323to324_bb1_align_0_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_323to324_bb1_align_0_i_0_NO_SHIFT_REG;
 logic rnode_323to324_bb1_align_0_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_323to324_bb1_align_0_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_323to324_bb1_align_0_i_1_NO_SHIFT_REG;
 logic rnode_323to324_bb1_align_0_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_323to324_bb1_align_0_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_323to324_bb1_align_0_i_2_NO_SHIFT_REG;
 logic rnode_323to324_bb1_align_0_i_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_323to324_bb1_align_0_i_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_323to324_bb1_align_0_i_3_NO_SHIFT_REG;
 logic rnode_323to324_bb1_align_0_i_0_valid_out_4_NO_SHIFT_REG;
 logic rnode_323to324_bb1_align_0_i_0_stall_in_4_NO_SHIFT_REG;
 logic [31:0] rnode_323to324_bb1_align_0_i_4_NO_SHIFT_REG;
 logic rnode_323to324_bb1_align_0_i_0_reg_324_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_323to324_bb1_align_0_i_0_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1_align_0_i_0_valid_out_0_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1_align_0_i_0_stall_in_0_reg_324_NO_SHIFT_REG;
 logic rnode_323to324_bb1_align_0_i_0_stall_out_reg_324_NO_SHIFT_REG;

acl_data_fifo rnode_323to324_bb1_align_0_i_0_reg_324_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_323to324_bb1_align_0_i_0_reg_324_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_323to324_bb1_align_0_i_0_stall_in_0_reg_324_NO_SHIFT_REG),
	.valid_out(rnode_323to324_bb1_align_0_i_0_valid_out_0_reg_324_NO_SHIFT_REG),
	.stall_out(rnode_323to324_bb1_align_0_i_0_stall_out_reg_324_NO_SHIFT_REG),
	.data_in(local_bb1_align_0_i),
	.data_out(rnode_323to324_bb1_align_0_i_0_reg_324_NO_SHIFT_REG)
);

defparam rnode_323to324_bb1_align_0_i_0_reg_324_fifo.DEPTH = 1;
defparam rnode_323to324_bb1_align_0_i_0_reg_324_fifo.DATA_WIDTH = 32;
defparam rnode_323to324_bb1_align_0_i_0_reg_324_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_323to324_bb1_align_0_i_0_reg_324_fifo.IMPL = "shift_reg";

assign rnode_323to324_bb1_align_0_i_0_reg_324_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_align_0_i_stall_in = 1'b0;
assign rnode_323to324_bb1_align_0_i_0_stall_in_0_reg_324_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1_align_0_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_323to324_bb1_align_0_i_0_NO_SHIFT_REG = rnode_323to324_bb1_align_0_i_0_reg_324_NO_SHIFT_REG;
assign rnode_323to324_bb1_align_0_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_323to324_bb1_align_0_i_1_NO_SHIFT_REG = rnode_323to324_bb1_align_0_i_0_reg_324_NO_SHIFT_REG;
assign rnode_323to324_bb1_align_0_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_323to324_bb1_align_0_i_2_NO_SHIFT_REG = rnode_323to324_bb1_align_0_i_0_reg_324_NO_SHIFT_REG;
assign rnode_323to324_bb1_align_0_i_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_323to324_bb1_align_0_i_3_NO_SHIFT_REG = rnode_323to324_bb1_align_0_i_0_reg_324_NO_SHIFT_REG;
assign rnode_323to324_bb1_align_0_i_0_valid_out_4_NO_SHIFT_REG = 1'b1;
assign rnode_323to324_bb1_align_0_i_4_NO_SHIFT_REG = rnode_323to324_bb1_align_0_i_0_reg_324_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_and17_i_stall_local;
wire [31:0] local_bb1_and17_i;

assign local_bb1_and17_i = (rnode_323to324_bb1_shr16_i_0_NO_SHIFT_REG & 32'hFF);

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_324to326_bb1_shr16_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_324to326_bb1_shr16_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_324to326_bb1_shr16_i_0_NO_SHIFT_REG;
 logic rnode_324to326_bb1_shr16_i_0_reg_326_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_324to326_bb1_shr16_i_0_reg_326_NO_SHIFT_REG;
 logic rnode_324to326_bb1_shr16_i_0_valid_out_reg_326_NO_SHIFT_REG;
 logic rnode_324to326_bb1_shr16_i_0_stall_in_reg_326_NO_SHIFT_REG;
 logic rnode_324to326_bb1_shr16_i_0_stall_out_reg_326_NO_SHIFT_REG;

acl_data_fifo rnode_324to326_bb1_shr16_i_0_reg_326_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_324to326_bb1_shr16_i_0_reg_326_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_324to326_bb1_shr16_i_0_stall_in_reg_326_NO_SHIFT_REG),
	.valid_out(rnode_324to326_bb1_shr16_i_0_valid_out_reg_326_NO_SHIFT_REG),
	.stall_out(rnode_324to326_bb1_shr16_i_0_stall_out_reg_326_NO_SHIFT_REG),
	.data_in(rnode_323to324_bb1_shr16_i_1_NO_SHIFT_REG),
	.data_out(rnode_324to326_bb1_shr16_i_0_reg_326_NO_SHIFT_REG)
);

defparam rnode_324to326_bb1_shr16_i_0_reg_326_fifo.DEPTH = 2;
defparam rnode_324to326_bb1_shr16_i_0_reg_326_fifo.DATA_WIDTH = 32;
defparam rnode_324to326_bb1_shr16_i_0_reg_326_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_324to326_bb1_shr16_i_0_reg_326_fifo.IMPL = "shift_reg";

assign rnode_324to326_bb1_shr16_i_0_reg_326_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_323to324_bb1_shr16_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_324to326_bb1_shr16_i_0_NO_SHIFT_REG = rnode_324to326_bb1_shr16_i_0_reg_326_NO_SHIFT_REG;
assign rnode_324to326_bb1_shr16_i_0_stall_in_reg_326_NO_SHIFT_REG = 1'b0;
assign rnode_324to326_bb1_shr16_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1__28_i_stall_local;
wire [31:0] local_bb1__28_i;

assign local_bb1__28_i = (rnode_323to324_bb1_lnot23_i_0_NO_SHIFT_REG ? 32'h0 : local_bb1_shl65_i);

// This section implements an unregistered operation.
// 
wire local_bb1_brmerge_not_i_stall_local;
wire local_bb1_brmerge_not_i;

assign local_bb1_brmerge_not_i = (rnode_323to324_bb1_cmp27_i_0_NO_SHIFT_REG & local_bb1_lnot33_not_i);

// This section implements an unregistered operation.
// 
wire local_bb1_and93_i_stall_local;
wire [31:0] local_bb1_and93_i;

assign local_bb1_and93_i = (rnode_323to324_bb1_align_0_i_0_NO_SHIFT_REG & 32'h1C);

// This section implements an unregistered operation.
// 
wire local_bb1_and95_i_stall_local;
wire [31:0] local_bb1_and95_i;

assign local_bb1_and95_i = (rnode_323to324_bb1_align_0_i_1_NO_SHIFT_REG & 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb1_and115_i_stall_local;
wire [31:0] local_bb1_and115_i;

assign local_bb1_and115_i = (rnode_323to324_bb1_align_0_i_2_NO_SHIFT_REG & 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb1_and130_i_stall_local;
wire [31:0] local_bb1_and130_i;

assign local_bb1_and130_i = (rnode_323to324_bb1_align_0_i_3_NO_SHIFT_REG & 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_and149_i_stall_local;
wire [31:0] local_bb1_and149_i;

assign local_bb1_and149_i = (rnode_323to324_bb1_align_0_i_4_NO_SHIFT_REG & 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_lnot_i_stall_local;
wire local_bb1_lnot_i;

assign local_bb1_lnot_i = (local_bb1_and17_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp25_i_stall_local;
wire local_bb1_cmp25_i;

assign local_bb1_cmp25_i = (local_bb1_and17_i == 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_and72_i_stall_local;
wire [31:0] local_bb1_and72_i;

assign local_bb1_and72_i = (local_bb1__28_i >> 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_and75_i_stall_local;
wire [31:0] local_bb1_and75_i;

assign local_bb1_and75_i = (local_bb1__28_i & 32'hF0);

// This section implements an unregistered operation.
// 
wire local_bb1_and78_i_stall_local;
wire [31:0] local_bb1_and78_i;

assign local_bb1_and78_i = (local_bb1__28_i & 32'hF00);

// This section implements an unregistered operation.
// 
wire local_bb1_and90_i_stall_local;
wire [31:0] local_bb1_and90_i;

assign local_bb1_and90_i = (local_bb1__28_i & 32'h7000000);

// This section implements an unregistered operation.
// 
wire local_bb1_and87_i_stall_local;
wire [31:0] local_bb1_and87_i;

assign local_bb1_and87_i = (local_bb1__28_i & 32'hF00000);

// This section implements an unregistered operation.
// 
wire local_bb1_and84_i_stall_local;
wire [31:0] local_bb1_and84_i;

assign local_bb1_and84_i = (local_bb1__28_i & 32'hF0000);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u2_stall_local;
wire [31:0] local_bb1_var__u2;

assign local_bb1_var__u2 = (local_bb1__28_i & 32'hFFF8);

// This section implements an unregistered operation.
// 
wire local_bb1_brmerge_not_not_i_stall_local;
wire local_bb1_brmerge_not_not_i;

assign local_bb1_brmerge_not_not_i = (local_bb1_brmerge_not_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb1_shr94_i_stall_local;
wire [31:0] local_bb1_shr94_i;

assign local_bb1_shr94_i = (local_bb1__28_i >> local_bb1_and93_i);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp96_i_stall_local;
wire local_bb1_cmp96_i;

assign local_bb1_cmp96_i = (local_bb1_and95_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp116_i_stall_local;
wire local_bb1_cmp116_i;

assign local_bb1_cmp116_i = (local_bb1_and115_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp131_not_i_stall_local;
wire local_bb1_cmp131_not_i;

assign local_bb1_cmp131_not_i = (local_bb1_and130_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_Pivot20_i_stall_local;
wire local_bb1_Pivot20_i;

assign local_bb1_Pivot20_i = (local_bb1_and149_i < 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb1_SwitchLeaf_i_stall_local;
wire local_bb1_SwitchLeaf_i;

assign local_bb1_SwitchLeaf_i = (local_bb1_and149_i == 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1__27_i_stall_local;
wire [31:0] local_bb1__27_i;

assign local_bb1__27_i = (local_bb1_lnot_i ? 32'h0 : local_bb1_shl_i);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp25_not_i_stall_local;
wire local_bb1_cmp25_not_i;

assign local_bb1_cmp25_not_i = (local_bb1_cmp25_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb1_or_cond_not_i_stall_local;
wire local_bb1_or_cond_not_i;

assign local_bb1_or_cond_not_i = (local_bb1_cmp25_i & local_bb1_lnot30_not_i);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u3_stall_local;
wire local_bb1_var__u3;

assign local_bb1_var__u3 = (local_bb1_cmp25_i | rnode_323to324_bb1_cmp27_i_2_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_and72_tr_i_stall_local;
wire [7:0] local_bb1_and72_tr_i;

assign local_bb1_and72_tr_i = local_bb1_and72_i[7:0];

// This section implements an unregistered operation.
// 
wire local_bb1_cmp76_i_stall_local;
wire local_bb1_cmp76_i;

assign local_bb1_cmp76_i = (local_bb1_and75_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp79_i_stall_local;
wire local_bb1_cmp79_i;

assign local_bb1_cmp79_i = (local_bb1_and78_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp91_i_stall_local;
wire local_bb1_cmp91_i;

assign local_bb1_cmp91_i = (local_bb1_and90_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp88_i_stall_local;
wire local_bb1_cmp88_i;

assign local_bb1_cmp88_i = (local_bb1_and87_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp85_i_stall_local;
wire local_bb1_cmp85_i;

assign local_bb1_cmp85_i = (local_bb1_and84_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u4_stall_local;
wire local_bb1_var__u4;

assign local_bb1_var__u4 = (local_bb1_var__u2 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_7_i_stall_local;
wire local_bb1_reduction_7_i;

assign local_bb1_reduction_7_i = (local_bb1_cmp25_i & local_bb1_brmerge_not_not_i);

// This section implements an unregistered operation.
// 
wire local_bb1_and142_i_stall_local;
wire [31:0] local_bb1_and142_i;

assign local_bb1_and142_i = (local_bb1_shr94_i >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_shr150_i_stall_local;
wire [31:0] local_bb1_shr150_i;

assign local_bb1_shr150_i = (local_bb1_shr94_i >> local_bb1_and149_i);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u5_stall_local;
wire [31:0] local_bb1_var__u5;

assign local_bb1_var__u5 = (local_bb1_shr94_i & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_and146_i_stall_local;
wire [31:0] local_bb1_and146_i;

assign local_bb1_and146_i = (local_bb1_shr94_i >> 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb1_add_i_stall_local;
wire [31:0] local_bb1_add_i;

assign local_bb1_add_i = (local_bb1__27_i | local_bb1_and36_lobit_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or_cond_i_stall_local;
wire local_bb1_or_cond_i;

assign local_bb1_or_cond_i = (local_bb1_lnot30_i | local_bb1_cmp25_not_i);

// This section implements an unregistered operation.
// 
wire local_bb1__24_i_stall_local;
wire local_bb1__24_i;

assign local_bb1__24_i = (local_bb1_or_cond_not_i | local_bb1_brmerge_not_i);

// This section implements an unregistered operation.
// 
wire local_bb1_frombool74_i_stall_local;
wire [7:0] local_bb1_frombool74_i;

assign local_bb1_frombool74_i = (local_bb1_and72_tr_i & 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb1__31_v_i_stall_local;
wire local_bb1__31_v_i;

assign local_bb1__31_v_i = (local_bb1_cmp96_i ? local_bb1_cmp79_i : local_bb1_cmp91_i);

// This section implements an unregistered operation.
// 
wire local_bb1__30_v_i_stall_local;
wire local_bb1__30_v_i;

assign local_bb1__30_v_i = (local_bb1_cmp96_i ? local_bb1_cmp76_i : local_bb1_cmp88_i);

// This section implements an unregistered operation.
// 
wire local_bb1_frombool109_i_stall_local;
wire [7:0] local_bb1_frombool109_i;

assign local_bb1_frombool109_i[7:1] = 7'h0;
assign local_bb1_frombool109_i[0] = local_bb1_cmp85_i;

// This section implements an unregistered operation.
// 
wire local_bb1_or107_i_stall_local;
wire [31:0] local_bb1_or107_i;

assign local_bb1_or107_i[31:1] = 31'h0;
assign local_bb1_or107_i[0] = local_bb1_var__u4;

// This section implements an unregistered operation.
// 
wire local_bb1_var__u6_stall_local;
wire [31:0] local_bb1_var__u6;

assign local_bb1_var__u6 = (local_bb1_and146_i | local_bb1_shr94_i);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_8_i_stall_local;
wire local_bb1_reduction_8_i;

assign local_bb1_reduction_8_i = (rnode_323to324_bb1_cmp27_i_1_NO_SHIFT_REG & local_bb1_or_cond_i);

// This section implements an unregistered operation.
// 
wire local_bb1__31_i_stall_local;
wire [7:0] local_bb1__31_i;

assign local_bb1__31_i[7:1] = 7'h0;
assign local_bb1__31_i[0] = local_bb1__31_v_i;

// This section implements an unregistered operation.
// 
wire local_bb1__30_i_stall_local;
wire [7:0] local_bb1__30_i;

assign local_bb1__30_i[7:1] = 7'h0;
assign local_bb1__30_i[0] = local_bb1__30_v_i;

// This section implements an unregistered operation.
// 
wire local_bb1__29_i_stall_local;
wire [7:0] local_bb1__29_i;

assign local_bb1__29_i = (local_bb1_cmp96_i ? local_bb1_frombool74_i : local_bb1_frombool109_i);

// This section implements an unregistered operation.
// 
wire local_bb1__32_i_stall_local;
wire [31:0] local_bb1__32_i;

assign local_bb1__32_i = (local_bb1_cmp96_i ? 32'h0 : local_bb1_or107_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or1596_i_stall_local;
wire [31:0] local_bb1_or1596_i;

assign local_bb1_or1596_i = (local_bb1_var__u6 | local_bb1_and142_i);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_9_i_stall_local;
wire local_bb1_reduction_9_i;

assign local_bb1_reduction_9_i = (local_bb1_reduction_7_i & local_bb1_reduction_8_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or1237_i_stall_local;
wire [7:0] local_bb1_or1237_i;

assign local_bb1_or1237_i = (local_bb1__30_i | local_bb1__29_i);

// This section implements an unregistered operation.
// 
wire local_bb1__33_i_stall_local;
wire [7:0] local_bb1__33_i;

assign local_bb1__33_i = (local_bb1_cmp116_i ? local_bb1__29_i : local_bb1__31_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or162_i_stall_local;
wire [31:0] local_bb1_or162_i;

assign local_bb1_or162_i = (local_bb1_or1596_i & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1__26_i_stall_local;
wire local_bb1__26_i;

assign local_bb1__26_i = (local_bb1_reduction_9_i ? local_bb1_cmp37_i : local_bb1__24_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or123_i_stall_local;
wire [31:0] local_bb1_or123_i;

assign local_bb1_or123_i[31:8] = 24'h0;
assign local_bb1_or123_i[7:0] = local_bb1_or1237_i;

// This section implements an unregistered operation.
// 
wire local_bb1_var__u7_stall_local;
wire [7:0] local_bb1_var__u7;

assign local_bb1_var__u7 = (local_bb1__33_i & 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb1__37_v_i_stall_local;
wire [31:0] local_bb1__37_v_i;

assign local_bb1__37_v_i = (local_bb1_Pivot20_i ? 32'h0 : local_bb1_or162_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or124_i_stall_local;
wire [31:0] local_bb1_or124_i;

assign local_bb1_or124_i = (local_bb1_cmp116_i ? 32'h0 : local_bb1_or123_i);

// This section implements an unregistered operation.
// 
wire local_bb1_conv135_i_stall_local;
wire [31:0] local_bb1_conv135_i;

assign local_bb1_conv135_i[31:8] = 24'h0;
assign local_bb1_conv135_i[7:0] = local_bb1_var__u7;

// This section implements an unregistered operation.
// 
wire local_bb1__39_v_i_stall_local;
wire [31:0] local_bb1__39_v_i;

assign local_bb1__39_v_i = (local_bb1_SwitchLeaf_i ? local_bb1_var__u5 : local_bb1__37_v_i);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_3_i_stall_local;
wire [31:0] local_bb1_reduction_3_i;

assign local_bb1_reduction_3_i = (local_bb1__32_i | local_bb1_or124_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or136_i_stall_local;
wire [31:0] local_bb1_or136_i;

assign local_bb1_or136_i = (local_bb1_cmp131_not_i ? local_bb1_conv135_i : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_5_i_stall_local;
wire [31:0] local_bb1_reduction_5_i;

assign local_bb1_reduction_5_i = (local_bb1_shr150_i | local_bb1_reduction_3_i);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_4_i_stall_local;
wire [31:0] local_bb1_reduction_4_i;

assign local_bb1_reduction_4_i = (local_bb1_or136_i | local_bb1__39_v_i);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_6_i_stall_local;
wire [31:0] local_bb1_reduction_6_i;

assign local_bb1_reduction_6_i = (local_bb1_reduction_4_i | local_bb1_reduction_5_i);

// This section implements an unregistered operation.
// 
wire local_bb1_xor188_i_stall_local;
wire [31:0] local_bb1_xor188_i;

assign local_bb1_xor188_i = (local_bb1_reduction_6_i ^ local_bb1_xor_lobit_i);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp37_i_valid_out_1;
wire local_bb1_cmp37_i_stall_in_1;
 reg local_bb1_cmp37_i_consumed_1_NO_SHIFT_REG;
wire local_bb1__26_i_valid_out;
wire local_bb1__26_i_stall_in;
 reg local_bb1__26_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_add192_i_valid_out;
wire local_bb1_add192_i_stall_in;
 reg local_bb1_add192_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_and17_i_valid_out_2;
wire local_bb1_and17_i_stall_in_2;
 reg local_bb1_and17_i_consumed_2_NO_SHIFT_REG;
wire local_bb1_var__u3_valid_out;
wire local_bb1_var__u3_stall_in;
 reg local_bb1_var__u3_consumed_0_NO_SHIFT_REG;
wire local_bb1_add192_i_inputs_ready;
wire local_bb1_add192_i_stall_local;
wire [31:0] local_bb1_add192_i;

assign local_bb1_add192_i_inputs_ready = (rnode_323to324_bb1__22_i_0_valid_out_0_NO_SHIFT_REG & rnode_323to324_bb1_cmp27_i_0_valid_out_0_NO_SHIFT_REG & rnode_323to324_bb1_lnot23_i_0_valid_out_NO_SHIFT_REG & rnode_323to324_bb1__22_i_0_valid_out_1_NO_SHIFT_REG & rnode_323to324_bb1__23_i_0_valid_out_2_NO_SHIFT_REG & rnode_323to324_bb1__23_i_0_valid_out_0_NO_SHIFT_REG & rnode_323to324_bb1_cmp27_i_0_valid_out_1_NO_SHIFT_REG & rnode_323to324_bb1_shr16_i_0_valid_out_0_NO_SHIFT_REG & rnode_323to324_bb1_cmp27_i_0_valid_out_2_NO_SHIFT_REG & rnode_323to324_bb1_align_0_i_0_valid_out_0_NO_SHIFT_REG & rnode_323to324_bb1_align_0_i_0_valid_out_4_NO_SHIFT_REG & rnode_323to324_bb1_align_0_i_0_valid_out_1_NO_SHIFT_REG & rnode_323to324_bb1_align_0_i_0_valid_out_2_NO_SHIFT_REG & rnode_323to324_bb1_align_0_i_0_valid_out_3_NO_SHIFT_REG);
assign local_bb1_add192_i = (local_bb1_add_i + local_bb1_xor188_i);
assign local_bb1_cmp37_i_valid_out_1 = 1'b1;
assign local_bb1__26_i_valid_out = 1'b1;
assign local_bb1_add192_i_valid_out = 1'b1;
assign local_bb1_and17_i_valid_out_2 = 1'b1;
assign local_bb1_var__u3_valid_out = 1'b1;
assign rnode_323to324_bb1__22_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1_cmp27_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1_lnot23_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1__22_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1__23_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1__23_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1_cmp27_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1_shr16_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1_cmp27_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1_align_0_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1_align_0_i_0_stall_in_4_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1_align_0_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1_align_0_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_323to324_bb1_align_0_i_0_stall_in_3_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_cmp37_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb1__26_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_add192_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_and17_i_consumed_2_NO_SHIFT_REG <= 1'b0;
		local_bb1_var__u3_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_cmp37_i_consumed_1_NO_SHIFT_REG <= (local_bb1_add192_i_inputs_ready & (local_bb1_cmp37_i_consumed_1_NO_SHIFT_REG | ~(local_bb1_cmp37_i_stall_in_1)) & local_bb1_add192_i_stall_local);
		local_bb1__26_i_consumed_0_NO_SHIFT_REG <= (local_bb1_add192_i_inputs_ready & (local_bb1__26_i_consumed_0_NO_SHIFT_REG | ~(local_bb1__26_i_stall_in)) & local_bb1_add192_i_stall_local);
		local_bb1_add192_i_consumed_0_NO_SHIFT_REG <= (local_bb1_add192_i_inputs_ready & (local_bb1_add192_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_add192_i_stall_in)) & local_bb1_add192_i_stall_local);
		local_bb1_and17_i_consumed_2_NO_SHIFT_REG <= (local_bb1_add192_i_inputs_ready & (local_bb1_and17_i_consumed_2_NO_SHIFT_REG | ~(local_bb1_and17_i_stall_in_2)) & local_bb1_add192_i_stall_local);
		local_bb1_var__u3_consumed_0_NO_SHIFT_REG <= (local_bb1_add192_i_inputs_ready & (local_bb1_var__u3_consumed_0_NO_SHIFT_REG | ~(local_bb1_var__u3_stall_in)) & local_bb1_add192_i_stall_local);
	end
end


// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_324to326_bb1_cmp37_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_324to326_bb1_cmp37_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_324to326_bb1_cmp37_i_0_NO_SHIFT_REG;
 logic rnode_324to326_bb1_cmp37_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_324to326_bb1_cmp37_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_324to326_bb1_cmp37_i_1_NO_SHIFT_REG;
 logic rnode_324to326_bb1_cmp37_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_324to326_bb1_cmp37_i_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_324to326_bb1_cmp37_i_2_NO_SHIFT_REG;
 logic rnode_324to326_bb1_cmp37_i_0_reg_326_inputs_ready_NO_SHIFT_REG;
 logic rnode_324to326_bb1_cmp37_i_0_reg_326_NO_SHIFT_REG;
 logic rnode_324to326_bb1_cmp37_i_0_valid_out_0_reg_326_NO_SHIFT_REG;
 logic rnode_324to326_bb1_cmp37_i_0_stall_in_0_reg_326_NO_SHIFT_REG;
 logic rnode_324to326_bb1_cmp37_i_0_stall_out_reg_326_NO_SHIFT_REG;

acl_data_fifo rnode_324to326_bb1_cmp37_i_0_reg_326_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_324to326_bb1_cmp37_i_0_reg_326_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_324to326_bb1_cmp37_i_0_stall_in_0_reg_326_NO_SHIFT_REG),
	.valid_out(rnode_324to326_bb1_cmp37_i_0_valid_out_0_reg_326_NO_SHIFT_REG),
	.stall_out(rnode_324to326_bb1_cmp37_i_0_stall_out_reg_326_NO_SHIFT_REG),
	.data_in(local_bb1_cmp37_i),
	.data_out(rnode_324to326_bb1_cmp37_i_0_reg_326_NO_SHIFT_REG)
);

defparam rnode_324to326_bb1_cmp37_i_0_reg_326_fifo.DEPTH = 2;
defparam rnode_324to326_bb1_cmp37_i_0_reg_326_fifo.DATA_WIDTH = 1;
defparam rnode_324to326_bb1_cmp37_i_0_reg_326_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_324to326_bb1_cmp37_i_0_reg_326_fifo.IMPL = "shift_reg";

assign rnode_324to326_bb1_cmp37_i_0_reg_326_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cmp37_i_stall_in_1 = 1'b0;
assign rnode_324to326_bb1_cmp37_i_0_stall_in_0_reg_326_NO_SHIFT_REG = 1'b0;
assign rnode_324to326_bb1_cmp37_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_324to326_bb1_cmp37_i_0_NO_SHIFT_REG = rnode_324to326_bb1_cmp37_i_0_reg_326_NO_SHIFT_REG;
assign rnode_324to326_bb1_cmp37_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_324to326_bb1_cmp37_i_1_NO_SHIFT_REG = rnode_324to326_bb1_cmp37_i_0_reg_326_NO_SHIFT_REG;
assign rnode_324to326_bb1_cmp37_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_324to326_bb1_cmp37_i_2_NO_SHIFT_REG = rnode_324to326_bb1_cmp37_i_0_reg_326_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_324to325_bb1__26_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_324to325_bb1__26_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_324to325_bb1__26_i_0_NO_SHIFT_REG;
 logic rnode_324to325_bb1__26_i_0_reg_325_inputs_ready_NO_SHIFT_REG;
 logic rnode_324to325_bb1__26_i_0_reg_325_NO_SHIFT_REG;
 logic rnode_324to325_bb1__26_i_0_valid_out_reg_325_NO_SHIFT_REG;
 logic rnode_324to325_bb1__26_i_0_stall_in_reg_325_NO_SHIFT_REG;
 logic rnode_324to325_bb1__26_i_0_stall_out_reg_325_NO_SHIFT_REG;

acl_data_fifo rnode_324to325_bb1__26_i_0_reg_325_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_324to325_bb1__26_i_0_reg_325_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_324to325_bb1__26_i_0_stall_in_reg_325_NO_SHIFT_REG),
	.valid_out(rnode_324to325_bb1__26_i_0_valid_out_reg_325_NO_SHIFT_REG),
	.stall_out(rnode_324to325_bb1__26_i_0_stall_out_reg_325_NO_SHIFT_REG),
	.data_in(local_bb1__26_i),
	.data_out(rnode_324to325_bb1__26_i_0_reg_325_NO_SHIFT_REG)
);

defparam rnode_324to325_bb1__26_i_0_reg_325_fifo.DEPTH = 1;
defparam rnode_324to325_bb1__26_i_0_reg_325_fifo.DATA_WIDTH = 1;
defparam rnode_324to325_bb1__26_i_0_reg_325_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_324to325_bb1__26_i_0_reg_325_fifo.IMPL = "shift_reg";

assign rnode_324to325_bb1__26_i_0_reg_325_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1__26_i_stall_in = 1'b0;
assign rnode_324to325_bb1__26_i_0_NO_SHIFT_REG = rnode_324to325_bb1__26_i_0_reg_325_NO_SHIFT_REG;
assign rnode_324to325_bb1__26_i_0_stall_in_reg_325_NO_SHIFT_REG = 1'b0;
assign rnode_324to325_bb1__26_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_324to325_bb1_add192_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_324to325_bb1_add192_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_324to325_bb1_add192_i_0_NO_SHIFT_REG;
 logic rnode_324to325_bb1_add192_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_324to325_bb1_add192_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_324to325_bb1_add192_i_1_NO_SHIFT_REG;
 logic rnode_324to325_bb1_add192_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_324to325_bb1_add192_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_324to325_bb1_add192_i_2_NO_SHIFT_REG;
 logic rnode_324to325_bb1_add192_i_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_324to325_bb1_add192_i_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_324to325_bb1_add192_i_3_NO_SHIFT_REG;
 logic rnode_324to325_bb1_add192_i_0_reg_325_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_324to325_bb1_add192_i_0_reg_325_NO_SHIFT_REG;
 logic rnode_324to325_bb1_add192_i_0_valid_out_0_reg_325_NO_SHIFT_REG;
 logic rnode_324to325_bb1_add192_i_0_stall_in_0_reg_325_NO_SHIFT_REG;
 logic rnode_324to325_bb1_add192_i_0_stall_out_reg_325_NO_SHIFT_REG;

acl_data_fifo rnode_324to325_bb1_add192_i_0_reg_325_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_324to325_bb1_add192_i_0_reg_325_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_324to325_bb1_add192_i_0_stall_in_0_reg_325_NO_SHIFT_REG),
	.valid_out(rnode_324to325_bb1_add192_i_0_valid_out_0_reg_325_NO_SHIFT_REG),
	.stall_out(rnode_324to325_bb1_add192_i_0_stall_out_reg_325_NO_SHIFT_REG),
	.data_in(local_bb1_add192_i),
	.data_out(rnode_324to325_bb1_add192_i_0_reg_325_NO_SHIFT_REG)
);

defparam rnode_324to325_bb1_add192_i_0_reg_325_fifo.DEPTH = 1;
defparam rnode_324to325_bb1_add192_i_0_reg_325_fifo.DATA_WIDTH = 32;
defparam rnode_324to325_bb1_add192_i_0_reg_325_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_324to325_bb1_add192_i_0_reg_325_fifo.IMPL = "shift_reg";

assign rnode_324to325_bb1_add192_i_0_reg_325_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_add192_i_stall_in = 1'b0;
assign rnode_324to325_bb1_add192_i_0_stall_in_0_reg_325_NO_SHIFT_REG = 1'b0;
assign rnode_324to325_bb1_add192_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_324to325_bb1_add192_i_0_NO_SHIFT_REG = rnode_324to325_bb1_add192_i_0_reg_325_NO_SHIFT_REG;
assign rnode_324to325_bb1_add192_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_324to325_bb1_add192_i_1_NO_SHIFT_REG = rnode_324to325_bb1_add192_i_0_reg_325_NO_SHIFT_REG;
assign rnode_324to325_bb1_add192_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_324to325_bb1_add192_i_2_NO_SHIFT_REG = rnode_324to325_bb1_add192_i_0_reg_325_NO_SHIFT_REG;
assign rnode_324to325_bb1_add192_i_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_324to325_bb1_add192_i_3_NO_SHIFT_REG = rnode_324to325_bb1_add192_i_0_reg_325_NO_SHIFT_REG;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_324to326_bb1_and17_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_324to326_bb1_and17_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_324to326_bb1_and17_i_0_NO_SHIFT_REG;
 logic rnode_324to326_bb1_and17_i_0_reg_326_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_324to326_bb1_and17_i_0_reg_326_NO_SHIFT_REG;
 logic rnode_324to326_bb1_and17_i_0_valid_out_reg_326_NO_SHIFT_REG;
 logic rnode_324to326_bb1_and17_i_0_stall_in_reg_326_NO_SHIFT_REG;
 logic rnode_324to326_bb1_and17_i_0_stall_out_reg_326_NO_SHIFT_REG;

acl_data_fifo rnode_324to326_bb1_and17_i_0_reg_326_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_324to326_bb1_and17_i_0_reg_326_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_324to326_bb1_and17_i_0_stall_in_reg_326_NO_SHIFT_REG),
	.valid_out(rnode_324to326_bb1_and17_i_0_valid_out_reg_326_NO_SHIFT_REG),
	.stall_out(rnode_324to326_bb1_and17_i_0_stall_out_reg_326_NO_SHIFT_REG),
	.data_in(local_bb1_and17_i),
	.data_out(rnode_324to326_bb1_and17_i_0_reg_326_NO_SHIFT_REG)
);

defparam rnode_324to326_bb1_and17_i_0_reg_326_fifo.DEPTH = 2;
defparam rnode_324to326_bb1_and17_i_0_reg_326_fifo.DATA_WIDTH = 32;
defparam rnode_324to326_bb1_and17_i_0_reg_326_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_324to326_bb1_and17_i_0_reg_326_fifo.IMPL = "shift_reg";

assign rnode_324to326_bb1_and17_i_0_reg_326_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and17_i_stall_in_2 = 1'b0;
assign rnode_324to326_bb1_and17_i_0_NO_SHIFT_REG = rnode_324to326_bb1_and17_i_0_reg_326_NO_SHIFT_REG;
assign rnode_324to326_bb1_and17_i_0_stall_in_reg_326_NO_SHIFT_REG = 1'b0;
assign rnode_324to326_bb1_and17_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_324to325_bb1_var__u3_0_valid_out_NO_SHIFT_REG;
 logic rnode_324to325_bb1_var__u3_0_stall_in_NO_SHIFT_REG;
 logic rnode_324to325_bb1_var__u3_0_NO_SHIFT_REG;
 logic rnode_324to325_bb1_var__u3_0_reg_325_inputs_ready_NO_SHIFT_REG;
 logic rnode_324to325_bb1_var__u3_0_reg_325_NO_SHIFT_REG;
 logic rnode_324to325_bb1_var__u3_0_valid_out_reg_325_NO_SHIFT_REG;
 logic rnode_324to325_bb1_var__u3_0_stall_in_reg_325_NO_SHIFT_REG;
 logic rnode_324to325_bb1_var__u3_0_stall_out_reg_325_NO_SHIFT_REG;

acl_data_fifo rnode_324to325_bb1_var__u3_0_reg_325_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_324to325_bb1_var__u3_0_reg_325_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_324to325_bb1_var__u3_0_stall_in_reg_325_NO_SHIFT_REG),
	.valid_out(rnode_324to325_bb1_var__u3_0_valid_out_reg_325_NO_SHIFT_REG),
	.stall_out(rnode_324to325_bb1_var__u3_0_stall_out_reg_325_NO_SHIFT_REG),
	.data_in(local_bb1_var__u3),
	.data_out(rnode_324to325_bb1_var__u3_0_reg_325_NO_SHIFT_REG)
);

defparam rnode_324to325_bb1_var__u3_0_reg_325_fifo.DEPTH = 1;
defparam rnode_324to325_bb1_var__u3_0_reg_325_fifo.DATA_WIDTH = 1;
defparam rnode_324to325_bb1_var__u3_0_reg_325_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_324to325_bb1_var__u3_0_reg_325_fifo.IMPL = "shift_reg";

assign rnode_324to325_bb1_var__u3_0_reg_325_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_var__u3_stall_in = 1'b0;
assign rnode_324to325_bb1_var__u3_0_NO_SHIFT_REG = rnode_324to325_bb1_var__u3_0_reg_325_NO_SHIFT_REG;
assign rnode_324to325_bb1_var__u3_0_stall_in_reg_325_NO_SHIFT_REG = 1'b0;
assign rnode_324to325_bb1_var__u3_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_not_cmp37_i_stall_local;
wire local_bb1_not_cmp37_i;

assign local_bb1_not_cmp37_i = (rnode_324to326_bb1_cmp37_i_1_NO_SHIFT_REG ^ 1'b1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_325to326_bb1__26_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_325to326_bb1__26_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_325to326_bb1__26_i_0_NO_SHIFT_REG;
 logic rnode_325to326_bb1__26_i_0_reg_326_inputs_ready_NO_SHIFT_REG;
 logic rnode_325to326_bb1__26_i_0_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1__26_i_0_valid_out_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1__26_i_0_stall_in_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1__26_i_0_stall_out_reg_326_NO_SHIFT_REG;

acl_data_fifo rnode_325to326_bb1__26_i_0_reg_326_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_325to326_bb1__26_i_0_reg_326_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_325to326_bb1__26_i_0_stall_in_reg_326_NO_SHIFT_REG),
	.valid_out(rnode_325to326_bb1__26_i_0_valid_out_reg_326_NO_SHIFT_REG),
	.stall_out(rnode_325to326_bb1__26_i_0_stall_out_reg_326_NO_SHIFT_REG),
	.data_in(rnode_324to325_bb1__26_i_0_NO_SHIFT_REG),
	.data_out(rnode_325to326_bb1__26_i_0_reg_326_NO_SHIFT_REG)
);

defparam rnode_325to326_bb1__26_i_0_reg_326_fifo.DEPTH = 1;
defparam rnode_325to326_bb1__26_i_0_reg_326_fifo.DATA_WIDTH = 1;
defparam rnode_325to326_bb1__26_i_0_reg_326_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_325to326_bb1__26_i_0_reg_326_fifo.IMPL = "shift_reg";

assign rnode_325to326_bb1__26_i_0_reg_326_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_324to325_bb1__26_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1__26_i_0_NO_SHIFT_REG = rnode_325to326_bb1__26_i_0_reg_326_NO_SHIFT_REG;
assign rnode_325to326_bb1__26_i_0_stall_in_reg_326_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1__26_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_and193_i_valid_out;
wire local_bb1_and193_i_stall_in;
wire local_bb1_and193_i_inputs_ready;
wire local_bb1_and193_i_stall_local;
wire [31:0] local_bb1_and193_i;

assign local_bb1_and193_i_inputs_ready = rnode_324to325_bb1_add192_i_0_valid_out_0_NO_SHIFT_REG;
assign local_bb1_and193_i = (rnode_324to325_bb1_add192_i_0_NO_SHIFT_REG & 32'hFFFFFFF);
assign local_bb1_and193_i_valid_out = 1'b1;
assign rnode_324to325_bb1_add192_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_and195_i_valid_out;
wire local_bb1_and195_i_stall_in;
wire local_bb1_and195_i_inputs_ready;
wire local_bb1_and195_i_stall_local;
wire [31:0] local_bb1_and195_i;

assign local_bb1_and195_i_inputs_ready = rnode_324to325_bb1_add192_i_0_valid_out_1_NO_SHIFT_REG;
assign local_bb1_and195_i = (rnode_324to325_bb1_add192_i_1_NO_SHIFT_REG >> 32'h1B);
assign local_bb1_and195_i_valid_out = 1'b1;
assign rnode_324to325_bb1_add192_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_and198_i_valid_out;
wire local_bb1_and198_i_stall_in;
wire local_bb1_and198_i_inputs_ready;
wire local_bb1_and198_i_stall_local;
wire [31:0] local_bb1_and198_i;

assign local_bb1_and198_i_inputs_ready = rnode_324to325_bb1_add192_i_0_valid_out_2_NO_SHIFT_REG;
assign local_bb1_and198_i = (rnode_324to325_bb1_add192_i_2_NO_SHIFT_REG & 32'h1);
assign local_bb1_and198_i_valid_out = 1'b1;
assign rnode_324to325_bb1_add192_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb1_and201_i_stall_local;
wire [31:0] local_bb1_and201_i;

assign local_bb1_and201_i = (rnode_324to325_bb1_add192_i_3_NO_SHIFT_REG & 32'h7FFFFFF);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_325to326_bb1_var__u3_0_valid_out_NO_SHIFT_REG;
 logic rnode_325to326_bb1_var__u3_0_stall_in_NO_SHIFT_REG;
 logic rnode_325to326_bb1_var__u3_0_NO_SHIFT_REG;
 logic rnode_325to326_bb1_var__u3_0_reg_326_inputs_ready_NO_SHIFT_REG;
 logic rnode_325to326_bb1_var__u3_0_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1_var__u3_0_valid_out_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1_var__u3_0_stall_in_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1_var__u3_0_stall_out_reg_326_NO_SHIFT_REG;

acl_data_fifo rnode_325to326_bb1_var__u3_0_reg_326_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_325to326_bb1_var__u3_0_reg_326_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_325to326_bb1_var__u3_0_stall_in_reg_326_NO_SHIFT_REG),
	.valid_out(rnode_325to326_bb1_var__u3_0_valid_out_reg_326_NO_SHIFT_REG),
	.stall_out(rnode_325to326_bb1_var__u3_0_stall_out_reg_326_NO_SHIFT_REG),
	.data_in(rnode_324to325_bb1_var__u3_0_NO_SHIFT_REG),
	.data_out(rnode_325to326_bb1_var__u3_0_reg_326_NO_SHIFT_REG)
);

defparam rnode_325to326_bb1_var__u3_0_reg_326_fifo.DEPTH = 1;
defparam rnode_325to326_bb1_var__u3_0_reg_326_fifo.DATA_WIDTH = 1;
defparam rnode_325to326_bb1_var__u3_0_reg_326_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_325to326_bb1_var__u3_0_reg_326_fifo.IMPL = "shift_reg";

assign rnode_325to326_bb1_var__u3_0_reg_326_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_324to325_bb1_var__u3_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1_var__u3_0_NO_SHIFT_REG = rnode_325to326_bb1_var__u3_0_reg_326_NO_SHIFT_REG;
assign rnode_325to326_bb1_var__u3_0_stall_in_reg_326_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1_var__u3_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_326to327_bb1__26_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_326to327_bb1__26_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_326to327_bb1__26_i_0_NO_SHIFT_REG;
 logic rnode_326to327_bb1__26_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_326to327_bb1__26_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_326to327_bb1__26_i_1_NO_SHIFT_REG;
 logic rnode_326to327_bb1__26_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_326to327_bb1__26_i_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_326to327_bb1__26_i_2_NO_SHIFT_REG;
 logic rnode_326to327_bb1__26_i_0_reg_327_inputs_ready_NO_SHIFT_REG;
 logic rnode_326to327_bb1__26_i_0_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1__26_i_0_valid_out_0_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1__26_i_0_stall_in_0_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1__26_i_0_stall_out_reg_327_NO_SHIFT_REG;

acl_data_fifo rnode_326to327_bb1__26_i_0_reg_327_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_326to327_bb1__26_i_0_reg_327_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_326to327_bb1__26_i_0_stall_in_0_reg_327_NO_SHIFT_REG),
	.valid_out(rnode_326to327_bb1__26_i_0_valid_out_0_reg_327_NO_SHIFT_REG),
	.stall_out(rnode_326to327_bb1__26_i_0_stall_out_reg_327_NO_SHIFT_REG),
	.data_in(rnode_325to326_bb1__26_i_0_NO_SHIFT_REG),
	.data_out(rnode_326to327_bb1__26_i_0_reg_327_NO_SHIFT_REG)
);

defparam rnode_326to327_bb1__26_i_0_reg_327_fifo.DEPTH = 1;
defparam rnode_326to327_bb1__26_i_0_reg_327_fifo.DATA_WIDTH = 1;
defparam rnode_326to327_bb1__26_i_0_reg_327_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_326to327_bb1__26_i_0_reg_327_fifo.IMPL = "shift_reg";

assign rnode_326to327_bb1__26_i_0_reg_327_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_325to326_bb1__26_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1__26_i_0_stall_in_0_reg_327_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1__26_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_326to327_bb1__26_i_0_NO_SHIFT_REG = rnode_326to327_bb1__26_i_0_reg_327_NO_SHIFT_REG;
assign rnode_326to327_bb1__26_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_326to327_bb1__26_i_1_NO_SHIFT_REG = rnode_326to327_bb1__26_i_0_reg_327_NO_SHIFT_REG;
assign rnode_326to327_bb1__26_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_326to327_bb1__26_i_2_NO_SHIFT_REG = rnode_326to327_bb1__26_i_0_reg_327_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_325to326_bb1_and193_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and193_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_325to326_bb1_and193_i_0_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and193_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and193_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_325to326_bb1_and193_i_1_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and193_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and193_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_325to326_bb1_and193_i_2_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and193_i_0_reg_326_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_325to326_bb1_and193_i_0_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and193_i_0_valid_out_0_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and193_i_0_stall_in_0_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and193_i_0_stall_out_reg_326_NO_SHIFT_REG;

acl_data_fifo rnode_325to326_bb1_and193_i_0_reg_326_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_325to326_bb1_and193_i_0_reg_326_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_325to326_bb1_and193_i_0_stall_in_0_reg_326_NO_SHIFT_REG),
	.valid_out(rnode_325to326_bb1_and193_i_0_valid_out_0_reg_326_NO_SHIFT_REG),
	.stall_out(rnode_325to326_bb1_and193_i_0_stall_out_reg_326_NO_SHIFT_REG),
	.data_in(local_bb1_and193_i),
	.data_out(rnode_325to326_bb1_and193_i_0_reg_326_NO_SHIFT_REG)
);

defparam rnode_325to326_bb1_and193_i_0_reg_326_fifo.DEPTH = 1;
defparam rnode_325to326_bb1_and193_i_0_reg_326_fifo.DATA_WIDTH = 32;
defparam rnode_325to326_bb1_and193_i_0_reg_326_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_325to326_bb1_and193_i_0_reg_326_fifo.IMPL = "shift_reg";

assign rnode_325to326_bb1_and193_i_0_reg_326_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and193_i_stall_in = 1'b0;
assign rnode_325to326_bb1_and193_i_0_stall_in_0_reg_326_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1_and193_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_325to326_bb1_and193_i_0_NO_SHIFT_REG = rnode_325to326_bb1_and193_i_0_reg_326_NO_SHIFT_REG;
assign rnode_325to326_bb1_and193_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_325to326_bb1_and193_i_1_NO_SHIFT_REG = rnode_325to326_bb1_and193_i_0_reg_326_NO_SHIFT_REG;
assign rnode_325to326_bb1_and193_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_325to326_bb1_and193_i_2_NO_SHIFT_REG = rnode_325to326_bb1_and193_i_0_reg_326_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_325to326_bb1_and195_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and195_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_325to326_bb1_and195_i_0_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and195_i_0_reg_326_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_325to326_bb1_and195_i_0_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and195_i_0_valid_out_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and195_i_0_stall_in_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and195_i_0_stall_out_reg_326_NO_SHIFT_REG;

acl_data_fifo rnode_325to326_bb1_and195_i_0_reg_326_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_325to326_bb1_and195_i_0_reg_326_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_325to326_bb1_and195_i_0_stall_in_reg_326_NO_SHIFT_REG),
	.valid_out(rnode_325to326_bb1_and195_i_0_valid_out_reg_326_NO_SHIFT_REG),
	.stall_out(rnode_325to326_bb1_and195_i_0_stall_out_reg_326_NO_SHIFT_REG),
	.data_in(local_bb1_and195_i),
	.data_out(rnode_325to326_bb1_and195_i_0_reg_326_NO_SHIFT_REG)
);

defparam rnode_325to326_bb1_and195_i_0_reg_326_fifo.DEPTH = 1;
defparam rnode_325to326_bb1_and195_i_0_reg_326_fifo.DATA_WIDTH = 32;
defparam rnode_325to326_bb1_and195_i_0_reg_326_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_325to326_bb1_and195_i_0_reg_326_fifo.IMPL = "shift_reg";

assign rnode_325to326_bb1_and195_i_0_reg_326_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and195_i_stall_in = 1'b0;
assign rnode_325to326_bb1_and195_i_0_NO_SHIFT_REG = rnode_325to326_bb1_and195_i_0_reg_326_NO_SHIFT_REG;
assign rnode_325to326_bb1_and195_i_0_stall_in_reg_326_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1_and195_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_325to326_bb1_and198_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and198_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_325to326_bb1_and198_i_0_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and198_i_0_reg_326_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_325to326_bb1_and198_i_0_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and198_i_0_valid_out_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and198_i_0_stall_in_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1_and198_i_0_stall_out_reg_326_NO_SHIFT_REG;

acl_data_fifo rnode_325to326_bb1_and198_i_0_reg_326_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_325to326_bb1_and198_i_0_reg_326_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_325to326_bb1_and198_i_0_stall_in_reg_326_NO_SHIFT_REG),
	.valid_out(rnode_325to326_bb1_and198_i_0_valid_out_reg_326_NO_SHIFT_REG),
	.stall_out(rnode_325to326_bb1_and198_i_0_stall_out_reg_326_NO_SHIFT_REG),
	.data_in(local_bb1_and198_i),
	.data_out(rnode_325to326_bb1_and198_i_0_reg_326_NO_SHIFT_REG)
);

defparam rnode_325to326_bb1_and198_i_0_reg_326_fifo.DEPTH = 1;
defparam rnode_325to326_bb1_and198_i_0_reg_326_fifo.DATA_WIDTH = 32;
defparam rnode_325to326_bb1_and198_i_0_reg_326_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_325to326_bb1_and198_i_0_reg_326_fifo.IMPL = "shift_reg";

assign rnode_325to326_bb1_and198_i_0_reg_326_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and198_i_stall_in = 1'b0;
assign rnode_325to326_bb1_and198_i_0_NO_SHIFT_REG = rnode_325to326_bb1_and198_i_0_reg_326_NO_SHIFT_REG;
assign rnode_325to326_bb1_and198_i_0_stall_in_reg_326_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1_and198_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_shr_i_i_stall_local;
wire [31:0] local_bb1_shr_i_i;

assign local_bb1_shr_i_i = (local_bb1_and201_i >> 32'h1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_326to327_bb1_var__u3_0_valid_out_NO_SHIFT_REG;
 logic rnode_326to327_bb1_var__u3_0_stall_in_NO_SHIFT_REG;
 logic rnode_326to327_bb1_var__u3_0_NO_SHIFT_REG;
 logic rnode_326to327_bb1_var__u3_0_reg_327_inputs_ready_NO_SHIFT_REG;
 logic rnode_326to327_bb1_var__u3_0_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_var__u3_0_valid_out_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_var__u3_0_stall_in_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_var__u3_0_stall_out_reg_327_NO_SHIFT_REG;

acl_data_fifo rnode_326to327_bb1_var__u3_0_reg_327_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_326to327_bb1_var__u3_0_reg_327_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_326to327_bb1_var__u3_0_stall_in_reg_327_NO_SHIFT_REG),
	.valid_out(rnode_326to327_bb1_var__u3_0_valid_out_reg_327_NO_SHIFT_REG),
	.stall_out(rnode_326to327_bb1_var__u3_0_stall_out_reg_327_NO_SHIFT_REG),
	.data_in(rnode_325to326_bb1_var__u3_0_NO_SHIFT_REG),
	.data_out(rnode_326to327_bb1_var__u3_0_reg_327_NO_SHIFT_REG)
);

defparam rnode_326to327_bb1_var__u3_0_reg_327_fifo.DEPTH = 1;
defparam rnode_326to327_bb1_var__u3_0_reg_327_fifo.DATA_WIDTH = 1;
defparam rnode_326to327_bb1_var__u3_0_reg_327_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_326to327_bb1_var__u3_0_reg_327_fifo.IMPL = "shift_reg";

assign rnode_326to327_bb1_var__u3_0_reg_327_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_325to326_bb1_var__u3_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_var__u3_0_NO_SHIFT_REG = rnode_326to327_bb1_var__u3_0_reg_327_NO_SHIFT_REG;
assign rnode_326to327_bb1_var__u3_0_stall_in_reg_327_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_var__u3_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_cond292_i_stall_local;
wire [31:0] local_bb1_cond292_i;

assign local_bb1_cond292_i = (rnode_326to327_bb1__26_i_1_NO_SHIFT_REG ? 32'h400000 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u8_stall_local;
wire [31:0] local_bb1_var__u8;

assign local_bb1_var__u8[31:1] = 31'h0;
assign local_bb1_var__u8[0] = rnode_326to327_bb1__26_i_2_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_shr216_i_stall_local;
wire [31:0] local_bb1_shr216_i;

assign local_bb1_shr216_i = (rnode_325to326_bb1_and193_i_1_NO_SHIFT_REG >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1__pre_i_stall_local;
wire [31:0] local_bb1__pre_i;

assign local_bb1__pre_i = (rnode_325to326_bb1_and195_i_0_NO_SHIFT_REG & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_or_i_i_stall_local;
wire [31:0] local_bb1_or_i_i;

assign local_bb1_or_i_i = (local_bb1_shr_i_i | local_bb1_and201_i);

// This section implements an unregistered operation.
// 
wire local_bb1_lnot_ext_i_stall_local;
wire [31:0] local_bb1_lnot_ext_i;

assign local_bb1_lnot_ext_i = (local_bb1_var__u8 ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_or219_i_stall_local;
wire [31:0] local_bb1_or219_i;

assign local_bb1_or219_i = (local_bb1_shr216_i | rnode_325to326_bb1_and198_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_tobool213_i_stall_local;
wire local_bb1_tobool213_i;

assign local_bb1_tobool213_i = (local_bb1__pre_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_shr1_i_i_stall_local;
wire [31:0] local_bb1_shr1_i_i;

assign local_bb1_shr1_i_i = (local_bb1_or_i_i >> 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb1__40_demorgan_i_stall_local;
wire local_bb1__40_demorgan_i;

assign local_bb1__40_demorgan_i = (rnode_324to326_bb1_cmp37_i_0_NO_SHIFT_REG | local_bb1_tobool213_i);

// This section implements an unregistered operation.
// 
wire local_bb1__42_i_stall_local;
wire local_bb1__42_i;

assign local_bb1__42_i = (local_bb1_tobool213_i & local_bb1_not_cmp37_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or2_i_i_stall_local;
wire [31:0] local_bb1_or2_i_i;

assign local_bb1_or2_i_i = (local_bb1_shr1_i_i | local_bb1_or_i_i);

// This section implements an unregistered operation.
// 
wire local_bb1__43_i_stall_local;
wire [31:0] local_bb1__43_i;

assign local_bb1__43_i = (local_bb1__42_i ? 32'h0 : local_bb1__pre_i);

// This section implements an unregistered operation.
// 
wire local_bb1_shr3_i_i_stall_local;
wire [31:0] local_bb1_shr3_i_i;

assign local_bb1_shr3_i_i = (local_bb1_or2_i_i >> 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_or4_i_i_stall_local;
wire [31:0] local_bb1_or4_i_i;

assign local_bb1_or4_i_i = (local_bb1_shr3_i_i | local_bb1_or2_i_i);

// This section implements an unregistered operation.
// 
wire local_bb1_shr5_i_i_stall_local;
wire [31:0] local_bb1_shr5_i_i;

assign local_bb1_shr5_i_i = (local_bb1_or4_i_i >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb1_or6_i_i_stall_local;
wire [31:0] local_bb1_or6_i_i;

assign local_bb1_or6_i_i = (local_bb1_shr5_i_i | local_bb1_or4_i_i);

// This section implements an unregistered operation.
// 
wire local_bb1_shr7_i_i_stall_local;
wire [31:0] local_bb1_shr7_i_i;

assign local_bb1_shr7_i_i = (local_bb1_or6_i_i >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb1_or6_masked_i_i_stall_local;
wire [31:0] local_bb1_or6_masked_i_i;

assign local_bb1_or6_masked_i_i = (local_bb1_or6_i_i & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_neg_i_i_stall_local;
wire [31:0] local_bb1_neg_i_i;

assign local_bb1_neg_i_i = (local_bb1_or6_masked_i_i | local_bb1_shr7_i_i);

// This section implements an unregistered operation.
// 
wire local_bb1_and_i_i1_stall_local;
wire [31:0] local_bb1_and_i_i1;

assign local_bb1_and_i_i1 = (local_bb1_neg_i_i ^ 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1__and_i_i1_valid_out;
wire local_bb1__and_i_i1_stall_in;
wire local_bb1__and_i_i1_inputs_ready;
wire local_bb1__and_i_i1_stall_local;
wire [31:0] local_bb1__and_i_i1;

thirtysix_six_comp local_bb1__and_i_i1_popcnt_instance (
	.data(local_bb1_and_i_i1),
	.sum(local_bb1__and_i_i1)
);


assign local_bb1__and_i_i1_inputs_ready = rnode_324to325_bb1_add192_i_0_valid_out_3_NO_SHIFT_REG;
assign local_bb1__and_i_i1_valid_out = 1'b1;
assign rnode_324to325_bb1_add192_i_0_stall_in_3_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_325to326_bb1__and_i_i1_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_325to326_bb1__and_i_i1_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_325to326_bb1__and_i_i1_0_NO_SHIFT_REG;
 logic rnode_325to326_bb1__and_i_i1_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_325to326_bb1__and_i_i1_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_325to326_bb1__and_i_i1_1_NO_SHIFT_REG;
 logic rnode_325to326_bb1__and_i_i1_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_325to326_bb1__and_i_i1_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_325to326_bb1__and_i_i1_2_NO_SHIFT_REG;
 logic rnode_325to326_bb1__and_i_i1_0_reg_326_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_325to326_bb1__and_i_i1_0_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1__and_i_i1_0_valid_out_0_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1__and_i_i1_0_stall_in_0_reg_326_NO_SHIFT_REG;
 logic rnode_325to326_bb1__and_i_i1_0_stall_out_reg_326_NO_SHIFT_REG;

acl_data_fifo rnode_325to326_bb1__and_i_i1_0_reg_326_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_325to326_bb1__and_i_i1_0_reg_326_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_325to326_bb1__and_i_i1_0_stall_in_0_reg_326_NO_SHIFT_REG),
	.valid_out(rnode_325to326_bb1__and_i_i1_0_valid_out_0_reg_326_NO_SHIFT_REG),
	.stall_out(rnode_325to326_bb1__and_i_i1_0_stall_out_reg_326_NO_SHIFT_REG),
	.data_in(local_bb1__and_i_i1),
	.data_out(rnode_325to326_bb1__and_i_i1_0_reg_326_NO_SHIFT_REG)
);

defparam rnode_325to326_bb1__and_i_i1_0_reg_326_fifo.DEPTH = 1;
defparam rnode_325to326_bb1__and_i_i1_0_reg_326_fifo.DATA_WIDTH = 32;
defparam rnode_325to326_bb1__and_i_i1_0_reg_326_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_325to326_bb1__and_i_i1_0_reg_326_fifo.IMPL = "shift_reg";

assign rnode_325to326_bb1__and_i_i1_0_reg_326_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1__and_i_i1_stall_in = 1'b0;
assign rnode_325to326_bb1__and_i_i1_0_stall_in_0_reg_326_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1__and_i_i1_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_325to326_bb1__and_i_i1_0_NO_SHIFT_REG = rnode_325to326_bb1__and_i_i1_0_reg_326_NO_SHIFT_REG;
assign rnode_325to326_bb1__and_i_i1_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_325to326_bb1__and_i_i1_1_NO_SHIFT_REG = rnode_325to326_bb1__and_i_i1_0_reg_326_NO_SHIFT_REG;
assign rnode_325to326_bb1__and_i_i1_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_325to326_bb1__and_i_i1_2_NO_SHIFT_REG = rnode_325to326_bb1__and_i_i1_0_reg_326_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_and9_i_i_stall_local;
wire [31:0] local_bb1_and9_i_i;

assign local_bb1_and9_i_i = (rnode_325to326_bb1__and_i_i1_0_NO_SHIFT_REG & 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb1_and203_i_stall_local;
wire [31:0] local_bb1_and203_i;

assign local_bb1_and203_i = (rnode_325to326_bb1__and_i_i1_1_NO_SHIFT_REG & 32'h18);

// This section implements an unregistered operation.
// 
wire local_bb1_and206_i_stall_local;
wire [31:0] local_bb1_and206_i;

assign local_bb1_and206_i = (rnode_325to326_bb1__and_i_i1_2_NO_SHIFT_REG & 32'h7);

// This section implements an unregistered operation.
// 
wire local_bb1_sub239_i_stall_local;
wire [31:0] local_bb1_sub239_i;

assign local_bb1_sub239_i = (32'h0 - local_bb1_and9_i_i);

// This section implements an unregistered operation.
// 
wire local_bb1_shl204_i_stall_local;
wire [31:0] local_bb1_shl204_i;

assign local_bb1_shl204_i = (rnode_325to326_bb1_and193_i_0_NO_SHIFT_REG << local_bb1_and203_i);

// This section implements an unregistered operation.
// 
wire local_bb1_cond244_i_stall_local;
wire [31:0] local_bb1_cond244_i;

assign local_bb1_cond244_i = (rnode_324to326_bb1_cmp37_i_2_NO_SHIFT_REG ? local_bb1_sub239_i : local_bb1__43_i);

// This section implements an unregistered operation.
// 
wire local_bb1_and205_i_stall_local;
wire [31:0] local_bb1_and205_i;

assign local_bb1_and205_i = (local_bb1_shl204_i & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_add245_i_stall_local;
wire [31:0] local_bb1_add245_i;

assign local_bb1_add245_i = (local_bb1_cond244_i + rnode_324to326_bb1_and17_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_fold_i_stall_local;
wire [31:0] local_bb1_fold_i;

assign local_bb1_fold_i = (local_bb1_cond244_i + rnode_324to326_bb1_shr16_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_shl207_i_stall_local;
wire [31:0] local_bb1_shl207_i;

assign local_bb1_shl207_i = (local_bb1_and205_i << local_bb1_and206_i);

// This section implements an unregistered operation.
// 
wire local_bb1_and247_i_stall_local;
wire [31:0] local_bb1_and247_i;

assign local_bb1_and247_i = (local_bb1_add245_i & 32'h100);

// This section implements an unregistered operation.
// 
wire local_bb1_and250_i_stall_local;
wire [31:0] local_bb1_and250_i;

assign local_bb1_and250_i = (local_bb1_fold_i & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb1_and269_i_stall_local;
wire [31:0] local_bb1_and269_i;

assign local_bb1_and269_i = (local_bb1_fold_i << 32'h17);

// This section implements an unregistered operation.
// 
wire local_bb1_and208_i_stall_local;
wire [31:0] local_bb1_and208_i;

assign local_bb1_and208_i = (local_bb1_shl207_i & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_notlhs_i_stall_local;
wire local_bb1_notlhs_i;

assign local_bb1_notlhs_i = (local_bb1_and247_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_notrhs_i_stall_local;
wire local_bb1_notrhs_i;

assign local_bb1_notrhs_i = (local_bb1_and250_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1__44_i_stall_local;
wire [31:0] local_bb1__44_i;

assign local_bb1__44_i = (local_bb1__40_demorgan_i ? local_bb1_and208_i : local_bb1_or219_i);

// This section implements an unregistered operation.
// 
wire local_bb1_not__46_i_stall_local;
wire local_bb1_not__46_i;

assign local_bb1_not__46_i = (local_bb1_notrhs_i | local_bb1_notlhs_i);

// This section implements an unregistered operation.
// 
wire local_bb1__45_i_stall_local;
wire [31:0] local_bb1__45_i;

assign local_bb1__45_i = (local_bb1__42_i ? rnode_325to326_bb1_and193_i_2_NO_SHIFT_REG : local_bb1__44_i);

// This section implements an unregistered operation.
// 
wire local_bb1_and225_i_stall_local;
wire [31:0] local_bb1_and225_i;

assign local_bb1_and225_i = (local_bb1__45_i & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_and270_i_stall_local;
wire [31:0] local_bb1_and270_i;

assign local_bb1_and270_i = (local_bb1__45_i & 32'h7);

// This section implements an unregistered operation.
// 
wire local_bb1_shr271_i_stall_local;
wire [31:0] local_bb1_shr271_i;

assign local_bb1_shr271_i = (local_bb1__45_i >> 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp226_i_stall_local;
wire local_bb1_cmp226_i;

assign local_bb1_cmp226_i = (local_bb1_and225_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp296_i_stall_local;
wire local_bb1_cmp296_i;

assign local_bb1_cmp296_i = (local_bb1_and270_i > 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb1_and269_i_valid_out;
wire local_bb1_and269_i_stall_in;
 reg local_bb1_and269_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_add245_i_valid_out_1;
wire local_bb1_add245_i_stall_in_1;
 reg local_bb1_add245_i_consumed_1_NO_SHIFT_REG;
wire local_bb1_not__46_i_valid_out;
wire local_bb1_not__46_i_stall_in;
 reg local_bb1_not__46_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_not_cmp37_i_valid_out_1;
wire local_bb1_not_cmp37_i_stall_in_1;
 reg local_bb1_not_cmp37_i_consumed_1_NO_SHIFT_REG;
wire local_bb1_shr271_i_valid_out;
wire local_bb1_shr271_i_stall_in;
 reg local_bb1_shr271_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_cmp226_i_valid_out;
wire local_bb1_cmp226_i_stall_in;
 reg local_bb1_cmp226_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_cmp296_i_valid_out;
wire local_bb1_cmp296_i_stall_in;
 reg local_bb1_cmp296_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_cmp299_i_valid_out;
wire local_bb1_cmp299_i_stall_in;
 reg local_bb1_cmp299_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_cmp299_i_inputs_ready;
wire local_bb1_cmp299_i_stall_local;
wire local_bb1_cmp299_i;

assign local_bb1_cmp299_i_inputs_ready = (rnode_324to326_bb1_shr16_i_0_valid_out_NO_SHIFT_REG & rnode_324to326_bb1_cmp37_i_0_valid_out_2_NO_SHIFT_REG & rnode_324to326_bb1_and17_i_0_valid_out_NO_SHIFT_REG & rnode_324to326_bb1_cmp37_i_0_valid_out_0_NO_SHIFT_REG & rnode_325to326_bb1_and193_i_0_valid_out_2_NO_SHIFT_REG & rnode_324to326_bb1_cmp37_i_0_valid_out_1_NO_SHIFT_REG & rnode_325to326_bb1_and195_i_0_valid_out_NO_SHIFT_REG & rnode_325to326_bb1_and193_i_0_valid_out_1_NO_SHIFT_REG & rnode_325to326_bb1_and198_i_0_valid_out_NO_SHIFT_REG & rnode_325to326_bb1_and193_i_0_valid_out_0_NO_SHIFT_REG & rnode_325to326_bb1__and_i_i1_0_valid_out_1_NO_SHIFT_REG & rnode_325to326_bb1__and_i_i1_0_valid_out_2_NO_SHIFT_REG & rnode_325to326_bb1__and_i_i1_0_valid_out_0_NO_SHIFT_REG);
assign local_bb1_cmp299_i = (local_bb1_and270_i == 32'h4);
assign local_bb1_and269_i_valid_out = 1'b1;
assign local_bb1_add245_i_valid_out_1 = 1'b1;
assign local_bb1_not__46_i_valid_out = 1'b1;
assign local_bb1_not_cmp37_i_valid_out_1 = 1'b1;
assign local_bb1_shr271_i_valid_out = 1'b1;
assign local_bb1_cmp226_i_valid_out = 1'b1;
assign local_bb1_cmp296_i_valid_out = 1'b1;
assign local_bb1_cmp299_i_valid_out = 1'b1;
assign rnode_324to326_bb1_shr16_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_324to326_bb1_cmp37_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_324to326_bb1_and17_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_324to326_bb1_cmp37_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1_and193_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_324to326_bb1_cmp37_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1_and195_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1_and193_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1_and198_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1_and193_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1__and_i_i1_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1__and_i_i1_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_325to326_bb1__and_i_i1_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_and269_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_add245_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_not__46_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_not_cmp37_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_shr271_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_cmp226_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_cmp296_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_cmp299_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_and269_i_consumed_0_NO_SHIFT_REG <= (local_bb1_cmp299_i_inputs_ready & (local_bb1_and269_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_and269_i_stall_in)) & local_bb1_cmp299_i_stall_local);
		local_bb1_add245_i_consumed_1_NO_SHIFT_REG <= (local_bb1_cmp299_i_inputs_ready & (local_bb1_add245_i_consumed_1_NO_SHIFT_REG | ~(local_bb1_add245_i_stall_in_1)) & local_bb1_cmp299_i_stall_local);
		local_bb1_not__46_i_consumed_0_NO_SHIFT_REG <= (local_bb1_cmp299_i_inputs_ready & (local_bb1_not__46_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_not__46_i_stall_in)) & local_bb1_cmp299_i_stall_local);
		local_bb1_not_cmp37_i_consumed_1_NO_SHIFT_REG <= (local_bb1_cmp299_i_inputs_ready & (local_bb1_not_cmp37_i_consumed_1_NO_SHIFT_REG | ~(local_bb1_not_cmp37_i_stall_in_1)) & local_bb1_cmp299_i_stall_local);
		local_bb1_shr271_i_consumed_0_NO_SHIFT_REG <= (local_bb1_cmp299_i_inputs_ready & (local_bb1_shr271_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_shr271_i_stall_in)) & local_bb1_cmp299_i_stall_local);
		local_bb1_cmp226_i_consumed_0_NO_SHIFT_REG <= (local_bb1_cmp299_i_inputs_ready & (local_bb1_cmp226_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_cmp226_i_stall_in)) & local_bb1_cmp299_i_stall_local);
		local_bb1_cmp296_i_consumed_0_NO_SHIFT_REG <= (local_bb1_cmp299_i_inputs_ready & (local_bb1_cmp296_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_cmp296_i_stall_in)) & local_bb1_cmp299_i_stall_local);
		local_bb1_cmp299_i_consumed_0_NO_SHIFT_REG <= (local_bb1_cmp299_i_inputs_ready & (local_bb1_cmp299_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_cmp299_i_stall_in)) & local_bb1_cmp299_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_326to327_bb1_and269_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_326to327_bb1_and269_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_326to327_bb1_and269_i_0_NO_SHIFT_REG;
 logic rnode_326to327_bb1_and269_i_0_reg_327_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_326to327_bb1_and269_i_0_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_and269_i_0_valid_out_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_and269_i_0_stall_in_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_and269_i_0_stall_out_reg_327_NO_SHIFT_REG;

acl_data_fifo rnode_326to327_bb1_and269_i_0_reg_327_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_326to327_bb1_and269_i_0_reg_327_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_326to327_bb1_and269_i_0_stall_in_reg_327_NO_SHIFT_REG),
	.valid_out(rnode_326to327_bb1_and269_i_0_valid_out_reg_327_NO_SHIFT_REG),
	.stall_out(rnode_326to327_bb1_and269_i_0_stall_out_reg_327_NO_SHIFT_REG),
	.data_in(local_bb1_and269_i),
	.data_out(rnode_326to327_bb1_and269_i_0_reg_327_NO_SHIFT_REG)
);

defparam rnode_326to327_bb1_and269_i_0_reg_327_fifo.DEPTH = 1;
defparam rnode_326to327_bb1_and269_i_0_reg_327_fifo.DATA_WIDTH = 32;
defparam rnode_326to327_bb1_and269_i_0_reg_327_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_326to327_bb1_and269_i_0_reg_327_fifo.IMPL = "shift_reg";

assign rnode_326to327_bb1_and269_i_0_reg_327_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_and269_i_stall_in = 1'b0;
assign rnode_326to327_bb1_and269_i_0_NO_SHIFT_REG = rnode_326to327_bb1_and269_i_0_reg_327_NO_SHIFT_REG;
assign rnode_326to327_bb1_and269_i_0_stall_in_reg_327_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_and269_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_326to327_bb1_add245_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_326to327_bb1_add245_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_326to327_bb1_add245_i_0_NO_SHIFT_REG;
 logic rnode_326to327_bb1_add245_i_0_reg_327_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_326to327_bb1_add245_i_0_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_add245_i_0_valid_out_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_add245_i_0_stall_in_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_add245_i_0_stall_out_reg_327_NO_SHIFT_REG;

acl_data_fifo rnode_326to327_bb1_add245_i_0_reg_327_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_326to327_bb1_add245_i_0_reg_327_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_326to327_bb1_add245_i_0_stall_in_reg_327_NO_SHIFT_REG),
	.valid_out(rnode_326to327_bb1_add245_i_0_valid_out_reg_327_NO_SHIFT_REG),
	.stall_out(rnode_326to327_bb1_add245_i_0_stall_out_reg_327_NO_SHIFT_REG),
	.data_in(local_bb1_add245_i),
	.data_out(rnode_326to327_bb1_add245_i_0_reg_327_NO_SHIFT_REG)
);

defparam rnode_326to327_bb1_add245_i_0_reg_327_fifo.DEPTH = 1;
defparam rnode_326to327_bb1_add245_i_0_reg_327_fifo.DATA_WIDTH = 32;
defparam rnode_326to327_bb1_add245_i_0_reg_327_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_326to327_bb1_add245_i_0_reg_327_fifo.IMPL = "shift_reg";

assign rnode_326to327_bb1_add245_i_0_reg_327_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_add245_i_stall_in_1 = 1'b0;
assign rnode_326to327_bb1_add245_i_0_NO_SHIFT_REG = rnode_326to327_bb1_add245_i_0_reg_327_NO_SHIFT_REG;
assign rnode_326to327_bb1_add245_i_0_stall_in_reg_327_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_add245_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_326to327_bb1_not__46_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_326to327_bb1_not__46_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_326to327_bb1_not__46_i_0_NO_SHIFT_REG;
 logic rnode_326to327_bb1_not__46_i_0_reg_327_inputs_ready_NO_SHIFT_REG;
 logic rnode_326to327_bb1_not__46_i_0_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_not__46_i_0_valid_out_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_not__46_i_0_stall_in_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_not__46_i_0_stall_out_reg_327_NO_SHIFT_REG;

acl_data_fifo rnode_326to327_bb1_not__46_i_0_reg_327_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_326to327_bb1_not__46_i_0_reg_327_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_326to327_bb1_not__46_i_0_stall_in_reg_327_NO_SHIFT_REG),
	.valid_out(rnode_326to327_bb1_not__46_i_0_valid_out_reg_327_NO_SHIFT_REG),
	.stall_out(rnode_326to327_bb1_not__46_i_0_stall_out_reg_327_NO_SHIFT_REG),
	.data_in(local_bb1_not__46_i),
	.data_out(rnode_326to327_bb1_not__46_i_0_reg_327_NO_SHIFT_REG)
);

defparam rnode_326to327_bb1_not__46_i_0_reg_327_fifo.DEPTH = 1;
defparam rnode_326to327_bb1_not__46_i_0_reg_327_fifo.DATA_WIDTH = 1;
defparam rnode_326to327_bb1_not__46_i_0_reg_327_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_326to327_bb1_not__46_i_0_reg_327_fifo.IMPL = "shift_reg";

assign rnode_326to327_bb1_not__46_i_0_reg_327_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_not__46_i_stall_in = 1'b0;
assign rnode_326to327_bb1_not__46_i_0_NO_SHIFT_REG = rnode_326to327_bb1_not__46_i_0_reg_327_NO_SHIFT_REG;
assign rnode_326to327_bb1_not__46_i_0_stall_in_reg_327_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_not__46_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_326to327_bb1_not_cmp37_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_326to327_bb1_not_cmp37_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_326to327_bb1_not_cmp37_i_0_NO_SHIFT_REG;
 logic rnode_326to327_bb1_not_cmp37_i_0_reg_327_inputs_ready_NO_SHIFT_REG;
 logic rnode_326to327_bb1_not_cmp37_i_0_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_not_cmp37_i_0_valid_out_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_not_cmp37_i_0_stall_in_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_not_cmp37_i_0_stall_out_reg_327_NO_SHIFT_REG;

acl_data_fifo rnode_326to327_bb1_not_cmp37_i_0_reg_327_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_326to327_bb1_not_cmp37_i_0_reg_327_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_326to327_bb1_not_cmp37_i_0_stall_in_reg_327_NO_SHIFT_REG),
	.valid_out(rnode_326to327_bb1_not_cmp37_i_0_valid_out_reg_327_NO_SHIFT_REG),
	.stall_out(rnode_326to327_bb1_not_cmp37_i_0_stall_out_reg_327_NO_SHIFT_REG),
	.data_in(local_bb1_not_cmp37_i),
	.data_out(rnode_326to327_bb1_not_cmp37_i_0_reg_327_NO_SHIFT_REG)
);

defparam rnode_326to327_bb1_not_cmp37_i_0_reg_327_fifo.DEPTH = 1;
defparam rnode_326to327_bb1_not_cmp37_i_0_reg_327_fifo.DATA_WIDTH = 1;
defparam rnode_326to327_bb1_not_cmp37_i_0_reg_327_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_326to327_bb1_not_cmp37_i_0_reg_327_fifo.IMPL = "shift_reg";

assign rnode_326to327_bb1_not_cmp37_i_0_reg_327_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_not_cmp37_i_stall_in_1 = 1'b0;
assign rnode_326to327_bb1_not_cmp37_i_0_NO_SHIFT_REG = rnode_326to327_bb1_not_cmp37_i_0_reg_327_NO_SHIFT_REG;
assign rnode_326to327_bb1_not_cmp37_i_0_stall_in_reg_327_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_not_cmp37_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_326to327_bb1_shr271_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_326to327_bb1_shr271_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_326to327_bb1_shr271_i_0_NO_SHIFT_REG;
 logic rnode_326to327_bb1_shr271_i_0_reg_327_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_326to327_bb1_shr271_i_0_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_shr271_i_0_valid_out_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_shr271_i_0_stall_in_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_shr271_i_0_stall_out_reg_327_NO_SHIFT_REG;

acl_data_fifo rnode_326to327_bb1_shr271_i_0_reg_327_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_326to327_bb1_shr271_i_0_reg_327_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_326to327_bb1_shr271_i_0_stall_in_reg_327_NO_SHIFT_REG),
	.valid_out(rnode_326to327_bb1_shr271_i_0_valid_out_reg_327_NO_SHIFT_REG),
	.stall_out(rnode_326to327_bb1_shr271_i_0_stall_out_reg_327_NO_SHIFT_REG),
	.data_in(local_bb1_shr271_i),
	.data_out(rnode_326to327_bb1_shr271_i_0_reg_327_NO_SHIFT_REG)
);

defparam rnode_326to327_bb1_shr271_i_0_reg_327_fifo.DEPTH = 1;
defparam rnode_326to327_bb1_shr271_i_0_reg_327_fifo.DATA_WIDTH = 32;
defparam rnode_326to327_bb1_shr271_i_0_reg_327_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_326to327_bb1_shr271_i_0_reg_327_fifo.IMPL = "shift_reg";

assign rnode_326to327_bb1_shr271_i_0_reg_327_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_shr271_i_stall_in = 1'b0;
assign rnode_326to327_bb1_shr271_i_0_NO_SHIFT_REG = rnode_326to327_bb1_shr271_i_0_reg_327_NO_SHIFT_REG;
assign rnode_326to327_bb1_shr271_i_0_stall_in_reg_327_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_shr271_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_326to327_bb1_cmp226_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp226_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp226_i_0_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp226_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp226_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp226_i_1_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp226_i_0_reg_327_inputs_ready_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp226_i_0_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp226_i_0_valid_out_0_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp226_i_0_stall_in_0_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp226_i_0_stall_out_reg_327_NO_SHIFT_REG;

acl_data_fifo rnode_326to327_bb1_cmp226_i_0_reg_327_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_326to327_bb1_cmp226_i_0_reg_327_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_326to327_bb1_cmp226_i_0_stall_in_0_reg_327_NO_SHIFT_REG),
	.valid_out(rnode_326to327_bb1_cmp226_i_0_valid_out_0_reg_327_NO_SHIFT_REG),
	.stall_out(rnode_326to327_bb1_cmp226_i_0_stall_out_reg_327_NO_SHIFT_REG),
	.data_in(local_bb1_cmp226_i),
	.data_out(rnode_326to327_bb1_cmp226_i_0_reg_327_NO_SHIFT_REG)
);

defparam rnode_326to327_bb1_cmp226_i_0_reg_327_fifo.DEPTH = 1;
defparam rnode_326to327_bb1_cmp226_i_0_reg_327_fifo.DATA_WIDTH = 1;
defparam rnode_326to327_bb1_cmp226_i_0_reg_327_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_326to327_bb1_cmp226_i_0_reg_327_fifo.IMPL = "shift_reg";

assign rnode_326to327_bb1_cmp226_i_0_reg_327_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cmp226_i_stall_in = 1'b0;
assign rnode_326to327_bb1_cmp226_i_0_stall_in_0_reg_327_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_cmp226_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_326to327_bb1_cmp226_i_0_NO_SHIFT_REG = rnode_326to327_bb1_cmp226_i_0_reg_327_NO_SHIFT_REG;
assign rnode_326to327_bb1_cmp226_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_326to327_bb1_cmp226_i_1_NO_SHIFT_REG = rnode_326to327_bb1_cmp226_i_0_reg_327_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_326to327_bb1_cmp296_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp296_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp296_i_0_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp296_i_0_reg_327_inputs_ready_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp296_i_0_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp296_i_0_valid_out_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp296_i_0_stall_in_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp296_i_0_stall_out_reg_327_NO_SHIFT_REG;

acl_data_fifo rnode_326to327_bb1_cmp296_i_0_reg_327_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_326to327_bb1_cmp296_i_0_reg_327_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_326to327_bb1_cmp296_i_0_stall_in_reg_327_NO_SHIFT_REG),
	.valid_out(rnode_326to327_bb1_cmp296_i_0_valid_out_reg_327_NO_SHIFT_REG),
	.stall_out(rnode_326to327_bb1_cmp296_i_0_stall_out_reg_327_NO_SHIFT_REG),
	.data_in(local_bb1_cmp296_i),
	.data_out(rnode_326to327_bb1_cmp296_i_0_reg_327_NO_SHIFT_REG)
);

defparam rnode_326to327_bb1_cmp296_i_0_reg_327_fifo.DEPTH = 1;
defparam rnode_326to327_bb1_cmp296_i_0_reg_327_fifo.DATA_WIDTH = 1;
defparam rnode_326to327_bb1_cmp296_i_0_reg_327_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_326to327_bb1_cmp296_i_0_reg_327_fifo.IMPL = "shift_reg";

assign rnode_326to327_bb1_cmp296_i_0_reg_327_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cmp296_i_stall_in = 1'b0;
assign rnode_326to327_bb1_cmp296_i_0_NO_SHIFT_REG = rnode_326to327_bb1_cmp296_i_0_reg_327_NO_SHIFT_REG;
assign rnode_326to327_bb1_cmp296_i_0_stall_in_reg_327_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_cmp296_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_326to327_bb1_cmp299_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp299_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp299_i_0_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp299_i_0_reg_327_inputs_ready_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp299_i_0_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp299_i_0_valid_out_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp299_i_0_stall_in_reg_327_NO_SHIFT_REG;
 logic rnode_326to327_bb1_cmp299_i_0_stall_out_reg_327_NO_SHIFT_REG;

acl_data_fifo rnode_326to327_bb1_cmp299_i_0_reg_327_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_326to327_bb1_cmp299_i_0_reg_327_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_326to327_bb1_cmp299_i_0_stall_in_reg_327_NO_SHIFT_REG),
	.valid_out(rnode_326to327_bb1_cmp299_i_0_valid_out_reg_327_NO_SHIFT_REG),
	.stall_out(rnode_326to327_bb1_cmp299_i_0_stall_out_reg_327_NO_SHIFT_REG),
	.data_in(local_bb1_cmp299_i),
	.data_out(rnode_326to327_bb1_cmp299_i_0_reg_327_NO_SHIFT_REG)
);

defparam rnode_326to327_bb1_cmp299_i_0_reg_327_fifo.DEPTH = 1;
defparam rnode_326to327_bb1_cmp299_i_0_reg_327_fifo.DATA_WIDTH = 1;
defparam rnode_326to327_bb1_cmp299_i_0_reg_327_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_326to327_bb1_cmp299_i_0_reg_327_fifo.IMPL = "shift_reg";

assign rnode_326to327_bb1_cmp299_i_0_reg_327_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_cmp299_i_stall_in = 1'b0;
assign rnode_326to327_bb1_cmp299_i_0_NO_SHIFT_REG = rnode_326to327_bb1_cmp299_i_0_reg_327_NO_SHIFT_REG;
assign rnode_326to327_bb1_cmp299_i_0_stall_in_reg_327_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_cmp299_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_shl273_i_stall_local;
wire [31:0] local_bb1_shl273_i;

assign local_bb1_shl273_i = (rnode_326to327_bb1_and269_i_0_NO_SHIFT_REG & 32'h7F800000);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp258_i_stall_local;
wire local_bb1_cmp258_i;

assign local_bb1_cmp258_i = ($signed(rnode_326to327_bb1_add245_i_0_NO_SHIFT_REG) > $signed(32'hFE));

// This section implements an unregistered operation.
// 
wire local_bb1_and272_i_stall_local;
wire [31:0] local_bb1_and272_i;

assign local_bb1_and272_i = (rnode_326to327_bb1_shr271_i_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp226_not_i_stall_local;
wire local_bb1_cmp226_not_i;

assign local_bb1_cmp226_not_i = (rnode_326to327_bb1_cmp226_i_0_NO_SHIFT_REG ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb1__47_i_stall_local;
wire local_bb1__47_i;

assign local_bb1__47_i = (rnode_326to327_bb1_cmp226_i_1_NO_SHIFT_REG | rnode_326to327_bb1_not__46_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_cmp29649_i_stall_local;
wire [31:0] local_bb1_cmp29649_i;

assign local_bb1_cmp29649_i[31:1] = 31'h0;
assign local_bb1_cmp29649_i[0] = rnode_326to327_bb1_cmp296_i_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_conv300_i_stall_local;
wire [31:0] local_bb1_conv300_i;

assign local_bb1_conv300_i[31:1] = 31'h0;
assign local_bb1_conv300_i[0] = rnode_326to327_bb1_cmp299_i_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_or274_i_stall_local;
wire [31:0] local_bb1_or274_i;

assign local_bb1_or274_i = (local_bb1_and272_i | local_bb1_shl273_i);

// This section implements an unregistered operation.
// 
wire local_bb1_brmerge12_i_stall_local;
wire local_bb1_brmerge12_i;

assign local_bb1_brmerge12_i = (local_bb1_cmp226_not_i | rnode_326to327_bb1_not_cmp37_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_lnot262__i_stall_local;
wire local_bb1_lnot262__i;

assign local_bb1_lnot262__i = (local_bb1_cmp258_i & local_bb1_cmp226_not_i);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u9_stall_local;
wire [31:0] local_bb1_var__u9;

assign local_bb1_var__u9[31:1] = 31'h0;
assign local_bb1_var__u9[0] = local_bb1__47_i;

// This section implements an unregistered operation.
// 
wire local_bb1_resultSign_0_i_stall_local;
wire [31:0] local_bb1_resultSign_0_i;

assign local_bb1_resultSign_0_i = (local_bb1_brmerge12_i ? rnode_326to327_bb1_and35_i_0_NO_SHIFT_REG : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_or2662_i_stall_local;
wire local_bb1_or2662_i;

assign local_bb1_or2662_i = (rnode_326to327_bb1_var__u3_0_NO_SHIFT_REG | local_bb1_lnot262__i);

// This section implements an unregistered operation.
// 
wire local_bb1_or275_i_stall_local;
wire [31:0] local_bb1_or275_i;

assign local_bb1_or275_i = (local_bb1_or274_i | local_bb1_resultSign_0_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or2804_i_stall_local;
wire local_bb1_or2804_i;

assign local_bb1_or2804_i = (local_bb1__47_i | local_bb1_or2662_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or2875_i_stall_local;
wire local_bb1_or2875_i;

assign local_bb1_or2875_i = (local_bb1_or2662_i | rnode_326to327_bb1__26_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u10_stall_local;
wire [31:0] local_bb1_var__u10;

assign local_bb1_var__u10[31:1] = 31'h0;
assign local_bb1_var__u10[0] = local_bb1_or2662_i;

// This section implements an unregistered operation.
// 
wire local_bb1_cond282_i_stall_local;
wire [31:0] local_bb1_cond282_i;

assign local_bb1_cond282_i = (local_bb1_or2804_i ? 32'h80000000 : 32'hFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb1_cond289_i_stall_local;
wire [31:0] local_bb1_cond289_i;

assign local_bb1_cond289_i = (local_bb1_or2875_i ? 32'h7F800000 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb1_lnot_ext310_i_stall_local;
wire [31:0] local_bb1_lnot_ext310_i;

assign local_bb1_lnot_ext310_i = (local_bb1_var__u10 ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_and293_i_stall_local;
wire [31:0] local_bb1_and293_i;

assign local_bb1_and293_i = (local_bb1_cond282_i & local_bb1_or275_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or294_i_stall_local;
wire [31:0] local_bb1_or294_i;

assign local_bb1_or294_i = (local_bb1_cond289_i | local_bb1_cond292_i);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_0_i_stall_local;
wire [31:0] local_bb1_reduction_0_i;

assign local_bb1_reduction_0_i = (local_bb1_lnot_ext310_i & local_bb1_lnot_ext_i);

// This section implements an unregistered operation.
// 
wire local_bb1_and302_i_stall_local;
wire [31:0] local_bb1_and302_i;

assign local_bb1_and302_i = (local_bb1_conv300_i & local_bb1_and293_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or295_i_stall_local;
wire [31:0] local_bb1_or295_i;

assign local_bb1_or295_i = (local_bb1_or294_i | local_bb1_and293_i);

// This section implements an unregistered operation.
// 
wire local_bb1_or295_i_valid_out;
wire local_bb1_or295_i_stall_in;
 reg local_bb1_or295_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_var__u9_valid_out;
wire local_bb1_var__u9_stall_in;
 reg local_bb1_var__u9_consumed_0_NO_SHIFT_REG;
wire local_bb1_lor_ext_i_valid_out;
wire local_bb1_lor_ext_i_stall_in;
 reg local_bb1_lor_ext_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_reduction_0_i_valid_out;
wire local_bb1_reduction_0_i_stall_in;
 reg local_bb1_reduction_0_i_consumed_0_NO_SHIFT_REG;
wire local_bb1_lor_ext_i_inputs_ready;
wire local_bb1_lor_ext_i_stall_local;
wire [31:0] local_bb1_lor_ext_i;

assign local_bb1_lor_ext_i_inputs_ready = (rnode_326to327_bb1_and35_i_0_valid_out_NO_SHIFT_REG & rnode_326to327_bb1_not_cmp37_i_0_valid_out_NO_SHIFT_REG & rnode_326to327_bb1_and269_i_0_valid_out_NO_SHIFT_REG & rnode_326to327_bb1_add245_i_0_valid_out_NO_SHIFT_REG & rnode_326to327_bb1_var__u3_0_valid_out_NO_SHIFT_REG & rnode_326to327_bb1__26_i_0_valid_out_0_NO_SHIFT_REG & rnode_326to327_bb1__26_i_0_valid_out_1_NO_SHIFT_REG & rnode_326to327_bb1_cmp226_i_0_valid_out_1_NO_SHIFT_REG & rnode_326to327_bb1_not__46_i_0_valid_out_NO_SHIFT_REG & rnode_326to327_bb1_shr271_i_0_valid_out_NO_SHIFT_REG & rnode_326to327_bb1__26_i_0_valid_out_2_NO_SHIFT_REG & rnode_326to327_bb1_cmp226_i_0_valid_out_0_NO_SHIFT_REG & rnode_326to327_bb1_cmp296_i_0_valid_out_NO_SHIFT_REG & rnode_326to327_bb1_cmp299_i_0_valid_out_NO_SHIFT_REG);
assign local_bb1_lor_ext_i = (local_bb1_cmp29649_i | local_bb1_and302_i);
assign local_bb1_or295_i_valid_out = 1'b1;
assign local_bb1_var__u9_valid_out = 1'b1;
assign local_bb1_lor_ext_i_valid_out = 1'b1;
assign local_bb1_reduction_0_i_valid_out = 1'b1;
assign rnode_326to327_bb1_and35_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_not_cmp37_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_and269_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_add245_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_var__u3_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1__26_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1__26_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_cmp226_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_not__46_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_shr271_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1__26_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_cmp226_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_cmp296_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_326to327_bb1_cmp299_i_0_stall_in_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_or295_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_var__u9_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_lor_ext_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_reduction_0_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_or295_i_consumed_0_NO_SHIFT_REG <= (local_bb1_lor_ext_i_inputs_ready & (local_bb1_or295_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_or295_i_stall_in)) & local_bb1_lor_ext_i_stall_local);
		local_bb1_var__u9_consumed_0_NO_SHIFT_REG <= (local_bb1_lor_ext_i_inputs_ready & (local_bb1_var__u9_consumed_0_NO_SHIFT_REG | ~(local_bb1_var__u9_stall_in)) & local_bb1_lor_ext_i_stall_local);
		local_bb1_lor_ext_i_consumed_0_NO_SHIFT_REG <= (local_bb1_lor_ext_i_inputs_ready & (local_bb1_lor_ext_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_lor_ext_i_stall_in)) & local_bb1_lor_ext_i_stall_local);
		local_bb1_reduction_0_i_consumed_0_NO_SHIFT_REG <= (local_bb1_lor_ext_i_inputs_ready & (local_bb1_reduction_0_i_consumed_0_NO_SHIFT_REG | ~(local_bb1_reduction_0_i_stall_in)) & local_bb1_lor_ext_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_327to328_bb1_or295_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_327to328_bb1_or295_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_327to328_bb1_or295_i_0_NO_SHIFT_REG;
 logic rnode_327to328_bb1_or295_i_0_reg_328_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_327to328_bb1_or295_i_0_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_or295_i_0_valid_out_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_or295_i_0_stall_in_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_or295_i_0_stall_out_reg_328_NO_SHIFT_REG;

acl_data_fifo rnode_327to328_bb1_or295_i_0_reg_328_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_327to328_bb1_or295_i_0_reg_328_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_327to328_bb1_or295_i_0_stall_in_reg_328_NO_SHIFT_REG),
	.valid_out(rnode_327to328_bb1_or295_i_0_valid_out_reg_328_NO_SHIFT_REG),
	.stall_out(rnode_327to328_bb1_or295_i_0_stall_out_reg_328_NO_SHIFT_REG),
	.data_in(local_bb1_or295_i),
	.data_out(rnode_327to328_bb1_or295_i_0_reg_328_NO_SHIFT_REG)
);

defparam rnode_327to328_bb1_or295_i_0_reg_328_fifo.DEPTH = 1;
defparam rnode_327to328_bb1_or295_i_0_reg_328_fifo.DATA_WIDTH = 32;
defparam rnode_327to328_bb1_or295_i_0_reg_328_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_327to328_bb1_or295_i_0_reg_328_fifo.IMPL = "shift_reg";

assign rnode_327to328_bb1_or295_i_0_reg_328_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_or295_i_stall_in = 1'b0;
assign rnode_327to328_bb1_or295_i_0_NO_SHIFT_REG = rnode_327to328_bb1_or295_i_0_reg_328_NO_SHIFT_REG;
assign rnode_327to328_bb1_or295_i_0_stall_in_reg_328_NO_SHIFT_REG = 1'b0;
assign rnode_327to328_bb1_or295_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_327to328_bb1_var__u9_0_valid_out_NO_SHIFT_REG;
 logic rnode_327to328_bb1_var__u9_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_327to328_bb1_var__u9_0_NO_SHIFT_REG;
 logic rnode_327to328_bb1_var__u9_0_reg_328_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_327to328_bb1_var__u9_0_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_var__u9_0_valid_out_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_var__u9_0_stall_in_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_var__u9_0_stall_out_reg_328_NO_SHIFT_REG;

acl_data_fifo rnode_327to328_bb1_var__u9_0_reg_328_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_327to328_bb1_var__u9_0_reg_328_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_327to328_bb1_var__u9_0_stall_in_reg_328_NO_SHIFT_REG),
	.valid_out(rnode_327to328_bb1_var__u9_0_valid_out_reg_328_NO_SHIFT_REG),
	.stall_out(rnode_327to328_bb1_var__u9_0_stall_out_reg_328_NO_SHIFT_REG),
	.data_in(local_bb1_var__u9),
	.data_out(rnode_327to328_bb1_var__u9_0_reg_328_NO_SHIFT_REG)
);

defparam rnode_327to328_bb1_var__u9_0_reg_328_fifo.DEPTH = 1;
defparam rnode_327to328_bb1_var__u9_0_reg_328_fifo.DATA_WIDTH = 32;
defparam rnode_327to328_bb1_var__u9_0_reg_328_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_327to328_bb1_var__u9_0_reg_328_fifo.IMPL = "shift_reg";

assign rnode_327to328_bb1_var__u9_0_reg_328_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_var__u9_stall_in = 1'b0;
assign rnode_327to328_bb1_var__u9_0_NO_SHIFT_REG = rnode_327to328_bb1_var__u9_0_reg_328_NO_SHIFT_REG;
assign rnode_327to328_bb1_var__u9_0_stall_in_reg_328_NO_SHIFT_REG = 1'b0;
assign rnode_327to328_bb1_var__u9_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_327to328_bb1_lor_ext_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_327to328_bb1_lor_ext_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_327to328_bb1_lor_ext_i_0_NO_SHIFT_REG;
 logic rnode_327to328_bb1_lor_ext_i_0_reg_328_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_327to328_bb1_lor_ext_i_0_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_lor_ext_i_0_valid_out_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_lor_ext_i_0_stall_in_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_lor_ext_i_0_stall_out_reg_328_NO_SHIFT_REG;

acl_data_fifo rnode_327to328_bb1_lor_ext_i_0_reg_328_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_327to328_bb1_lor_ext_i_0_reg_328_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_327to328_bb1_lor_ext_i_0_stall_in_reg_328_NO_SHIFT_REG),
	.valid_out(rnode_327to328_bb1_lor_ext_i_0_valid_out_reg_328_NO_SHIFT_REG),
	.stall_out(rnode_327to328_bb1_lor_ext_i_0_stall_out_reg_328_NO_SHIFT_REG),
	.data_in(local_bb1_lor_ext_i),
	.data_out(rnode_327to328_bb1_lor_ext_i_0_reg_328_NO_SHIFT_REG)
);

defparam rnode_327to328_bb1_lor_ext_i_0_reg_328_fifo.DEPTH = 1;
defparam rnode_327to328_bb1_lor_ext_i_0_reg_328_fifo.DATA_WIDTH = 32;
defparam rnode_327to328_bb1_lor_ext_i_0_reg_328_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_327to328_bb1_lor_ext_i_0_reg_328_fifo.IMPL = "shift_reg";

assign rnode_327to328_bb1_lor_ext_i_0_reg_328_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_lor_ext_i_stall_in = 1'b0;
assign rnode_327to328_bb1_lor_ext_i_0_NO_SHIFT_REG = rnode_327to328_bb1_lor_ext_i_0_reg_328_NO_SHIFT_REG;
assign rnode_327to328_bb1_lor_ext_i_0_stall_in_reg_328_NO_SHIFT_REG = 1'b0;
assign rnode_327to328_bb1_lor_ext_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_327to328_bb1_reduction_0_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_327to328_bb1_reduction_0_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_327to328_bb1_reduction_0_i_0_NO_SHIFT_REG;
 logic rnode_327to328_bb1_reduction_0_i_0_reg_328_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_327to328_bb1_reduction_0_i_0_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_reduction_0_i_0_valid_out_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_reduction_0_i_0_stall_in_reg_328_NO_SHIFT_REG;
 logic rnode_327to328_bb1_reduction_0_i_0_stall_out_reg_328_NO_SHIFT_REG;

acl_data_fifo rnode_327to328_bb1_reduction_0_i_0_reg_328_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_327to328_bb1_reduction_0_i_0_reg_328_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_327to328_bb1_reduction_0_i_0_stall_in_reg_328_NO_SHIFT_REG),
	.valid_out(rnode_327to328_bb1_reduction_0_i_0_valid_out_reg_328_NO_SHIFT_REG),
	.stall_out(rnode_327to328_bb1_reduction_0_i_0_stall_out_reg_328_NO_SHIFT_REG),
	.data_in(local_bb1_reduction_0_i),
	.data_out(rnode_327to328_bb1_reduction_0_i_0_reg_328_NO_SHIFT_REG)
);

defparam rnode_327to328_bb1_reduction_0_i_0_reg_328_fifo.DEPTH = 1;
defparam rnode_327to328_bb1_reduction_0_i_0_reg_328_fifo.DATA_WIDTH = 32;
defparam rnode_327to328_bb1_reduction_0_i_0_reg_328_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_327to328_bb1_reduction_0_i_0_reg_328_fifo.IMPL = "shift_reg";

assign rnode_327to328_bb1_reduction_0_i_0_reg_328_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb1_reduction_0_i_stall_in = 1'b0;
assign rnode_327to328_bb1_reduction_0_i_0_NO_SHIFT_REG = rnode_327to328_bb1_reduction_0_i_0_reg_328_NO_SHIFT_REG;
assign rnode_327to328_bb1_reduction_0_i_0_stall_in_reg_328_NO_SHIFT_REG = 1'b0;
assign rnode_327to328_bb1_reduction_0_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb1_lnot_ext314_i_stall_local;
wire [31:0] local_bb1_lnot_ext314_i;

assign local_bb1_lnot_ext314_i = (rnode_327to328_bb1_var__u9_0_NO_SHIFT_REG ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_1_i_stall_local;
wire [31:0] local_bb1_reduction_1_i;

assign local_bb1_reduction_1_i = (local_bb1_lnot_ext314_i & rnode_327to328_bb1_lor_ext_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_reduction_2_i_stall_local;
wire [31:0] local_bb1_reduction_2_i;

assign local_bb1_reduction_2_i = (rnode_327to328_bb1_reduction_0_i_0_NO_SHIFT_REG & local_bb1_reduction_1_i);

// This section implements an unregistered operation.
// 
wire local_bb1_add320_i_stall_local;
wire [31:0] local_bb1_add320_i;

assign local_bb1_add320_i = (local_bb1_reduction_2_i + rnode_327to328_bb1_or295_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_var__u11_stall_local;
wire [31:0] local_bb1_var__u11;

assign local_bb1_var__u11 = local_bb1_add320_i;

// This section implements an unregistered operation.
// 
wire local_bb1___stall_local;
wire [31:0] local_bb1__;

assign local_bb1__ = (rnode_327to328_bb1_c0_ene3_0_NO_SHIFT_REG ? local_bb1_var__u11 : rnode_327to328_bb1_c0_ene1_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb1_c0_exi1_valid_out;
wire local_bb1_c0_exi1_stall_in;
wire local_bb1_c0_exi1_inputs_ready;
wire local_bb1_c0_exi1_stall_local;
wire [63:0] local_bb1_c0_exi1;

assign local_bb1_c0_exi1_inputs_ready = (rnode_327to328_bb1_c0_ene1_0_valid_out_NO_SHIFT_REG & rnode_327to328_bb1_c0_ene3_0_valid_out_NO_SHIFT_REG & rnode_327to328_bb1_or295_i_0_valid_out_NO_SHIFT_REG & rnode_327to328_bb1_reduction_0_i_0_valid_out_NO_SHIFT_REG & rnode_327to328_bb1_var__u9_0_valid_out_NO_SHIFT_REG & rnode_327to328_bb1_lor_ext_i_0_valid_out_NO_SHIFT_REG);
assign local_bb1_c0_exi1[31:0] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
assign local_bb1_c0_exi1[63:32] = local_bb1__;
assign local_bb1_c0_exi1_valid_out = 1'b1;
assign rnode_327to328_bb1_c0_ene1_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_327to328_bb1_c0_ene3_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_327to328_bb1_or295_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_327to328_bb1_reduction_0_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_327to328_bb1_var__u9_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_327to328_bb1_lor_ext_i_0_stall_in_NO_SHIFT_REG = 1'b0;

// This section implements a registered operation.
// 
wire local_bb1_c0_exit_c0_exi1_inputs_ready;
 reg local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG;
wire local_bb1_c0_exit_c0_exi1_stall_in;
 reg [63:0] local_bb1_c0_exit_c0_exi1_NO_SHIFT_REG;
wire [63:0] local_bb1_c0_exit_c0_exi1_in;
wire local_bb1_c0_exit_c0_exi1_valid;
wire local_bb1_c0_exit_c0_exi1_causedstall;

acl_stall_free_sink local_bb1_c0_exit_c0_exi1_instance (
	.clock(clock),
	.resetn(resetn),
	.data_in(local_bb1_c0_exi1),
	.data_out(local_bb1_c0_exit_c0_exi1_in),
	.input_accepted(local_bb1_c0_enter_c0_eni3_input_accepted),
	.valid_out(local_bb1_c0_exit_c0_exi1_valid),
	.stall_in(~(local_bb1_c0_exit_c0_exi1_output_regs_ready)),
	.stall_entry(local_bb1_c0_exit_c0_exi1_entry_stall),
	.valids(local_bb1_c0_exit_c0_exi1_valid_bits),
	.IIphases(local_bb1_c0_exit_c0_exi1_phases),
	.inc_pipelined_thread(local_bb1_c0_enter_c0_eni3_inc_pipelined_thread),
	.dec_pipelined_thread(local_bb1_c0_enter_c0_eni3_dec_pipelined_thread)
);

defparam local_bb1_c0_exit_c0_exi1_instance.DATA_WIDTH = 64;
defparam local_bb1_c0_exit_c0_exi1_instance.PIPELINE_DEPTH = 12;
defparam local_bb1_c0_exit_c0_exi1_instance.SHARINGII = 1;
defparam local_bb1_c0_exit_c0_exi1_instance.SCHEDULEII = 1;

assign local_bb1_c0_exit_c0_exi1_inputs_ready = 1'b1;
assign local_bb1_c0_exit_c0_exi1_output_regs_ready = (&(~(local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG) | ~(local_bb1_c0_exit_c0_exi1_stall_in)));
assign local_bb1_c0_exi1_stall_in = 1'b0;
assign local_bb1_c0_exit_c0_exi1_causedstall = (1'b1 && (1'b0 && !(~(local_bb1_c0_exit_c0_exi1_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_c0_exit_c0_exi1_NO_SHIFT_REG <= 'x;
		local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_c0_exit_c0_exi1_output_regs_ready)
		begin
			local_bb1_c0_exit_c0_exi1_NO_SHIFT_REG <= local_bb1_c0_exit_c0_exi1_in;
			local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG <= local_bb1_c0_exit_c0_exi1_valid;
		end
		else
		begin
			if (~(local_bb1_c0_exit_c0_exi1_stall_in))
			begin
				local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_c0_exe1_valid_out;
wire local_bb1_c0_exe1_stall_in;
wire local_bb1_c0_exe1_inputs_ready;
wire local_bb1_c0_exe1_stall_local;
wire [31:0] local_bb1_c0_exe1;

assign local_bb1_c0_exe1_inputs_ready = local_bb1_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG;
assign local_bb1_c0_exe1 = local_bb1_c0_exit_c0_exi1_NO_SHIFT_REG[63:32];
assign local_bb1_c0_exe1_valid_out = local_bb1_c0_exe1_inputs_ready;
assign local_bb1_c0_exe1_stall_local = local_bb1_c0_exe1_stall_in;
assign local_bb1_c0_exit_c0_exi1_stall_in = (|local_bb1_c0_exe1_stall_local);

// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
 reg branch_node_valid_out_0_NO_SHIFT_REG;
 reg branch_compare_result_NO_SHIFT_REG;
wire branch_var__output_regs_ready;
wire combined_branch_stall_in_signal;
 reg [63:0] lvb_bb1_indvars_iv_next_0_reg_NO_SHIFT_REG;
 reg [31:0] lvb_bb1_c0_exe1_0_reg_NO_SHIFT_REG;
 reg [31:0] lvb_input_global_id_0_0_reg_NO_SHIFT_REG;

assign branch_var__inputs_ready = (local_bb1_c0_exe1_valid_out & local_bb1_exitcond_GUARD_valid_out & rnode_332to333_bb1_indvars_iv_next_0_valid_out_1_NO_SHIFT_REG & rnode_332to333_input_global_id_0_0_valid_out_NO_SHIFT_REG);
assign branch_var__output_regs_ready = (~(branch_node_valid_out_0_NO_SHIFT_REG) | (((branch_compare_result_NO_SHIFT_REG != 1'b1) & ~(stall_in_1)) | (~((branch_compare_result_NO_SHIFT_REG != 1'b1)) & ~(stall_in_0))));
assign local_bb1_c0_exe1_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign local_bb1_exitcond_GUARD_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign rnode_332to333_bb1_indvars_iv_next_0_stall_in_1_NO_SHIFT_REG = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign rnode_332to333_input_global_id_0_0_stall_in_NO_SHIFT_REG = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign lvb_bb1_indvars_iv_next_0 = lvb_bb1_indvars_iv_next_0_reg_NO_SHIFT_REG;
assign lvb_bb1_indvars_iv_next_1 = lvb_bb1_indvars_iv_next_0_reg_NO_SHIFT_REG;
assign lvb_bb1_c0_exe1_0 = lvb_bb1_c0_exe1_0_reg_NO_SHIFT_REG;
assign lvb_bb1_c0_exe1_1 = lvb_bb1_c0_exe1_0_reg_NO_SHIFT_REG;
assign lvb_input_global_id_0_0 = lvb_input_global_id_0_0_reg_NO_SHIFT_REG;
assign lvb_input_global_id_0_1 = lvb_input_global_id_0_0_reg_NO_SHIFT_REG;
assign valid_out_0 = (~((branch_compare_result_NO_SHIFT_REG != 1'b1)) & branch_node_valid_out_0_NO_SHIFT_REG);
assign valid_out_1 = ((branch_compare_result_NO_SHIFT_REG != 1'b1) & branch_node_valid_out_0_NO_SHIFT_REG);
assign combined_branch_stall_in_signal = ((((branch_compare_result_NO_SHIFT_REG != 1'b1) & branch_node_valid_out_0_NO_SHIFT_REG) & stall_in_1) | ((~((branch_compare_result_NO_SHIFT_REG != 1'b1)) & branch_node_valid_out_0_NO_SHIFT_REG) & stall_in_0));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		branch_node_valid_out_0_NO_SHIFT_REG <= 1'b0;
		lvb_bb1_indvars_iv_next_0_reg_NO_SHIFT_REG <= 'x;
		lvb_bb1_c0_exe1_0_reg_NO_SHIFT_REG <= 'x;
		lvb_input_global_id_0_0_reg_NO_SHIFT_REG <= 'x;
		branch_compare_result_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (branch_var__output_regs_ready)
		begin
			branch_node_valid_out_0_NO_SHIFT_REG <= branch_var__inputs_ready;
			lvb_bb1_indvars_iv_next_0_reg_NO_SHIFT_REG <= rnode_332to333_bb1_indvars_iv_next_1_NO_SHIFT_REG;
			lvb_bb1_c0_exe1_0_reg_NO_SHIFT_REG <= local_bb1_c0_exe1;
			lvb_input_global_id_0_0_reg_NO_SHIFT_REG <= rnode_332to333_input_global_id_0_0_NO_SHIFT_REG;
			branch_compare_result_NO_SHIFT_REG <= local_bb1_exitcond_GUARD;
		end
		else
		begin
			if (~(combined_branch_stall_in_signal))
			begin
				branch_node_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module gather_basic_block_2
	(
		input 		clock,
		input 		resetn,
		input [63:0] 		input_rank,
		input [63:0] 		input_err_arr,
		input [31:0] 		input_global_size_0,
		input [31:0] 		input_sink_val,
		input 		input_wii_cmp1,
		input [31:0] 		input_wii_div,
		input 		valid_in,
		output 		stall_out,
		input [31:0] 		input_c0_exe1,
		input [31:0] 		input_global_id_0,
		output 		valid_out,
		input 		stall_in,
		input [31:0] 		workgroup_size,
		input 		start,
		input [255:0] 		avm_local_bb2_ld__readdata,
		input 		avm_local_bb2_ld__readdatavalid,
		input 		avm_local_bb2_ld__waitrequest,
		output [29:0] 		avm_local_bb2_ld__address,
		output 		avm_local_bb2_ld__read,
		output 		avm_local_bb2_ld__write,
		input 		avm_local_bb2_ld__writeack,
		output [255:0] 		avm_local_bb2_ld__writedata,
		output [31:0] 		avm_local_bb2_ld__byteenable,
		output [4:0] 		avm_local_bb2_ld__burstcount,
		output 		local_bb2_ld__active,
		input 		clock2x,
		input [255:0] 		avm_local_bb2_st_c0_exe2_readdata,
		input 		avm_local_bb2_st_c0_exe2_readdatavalid,
		input 		avm_local_bb2_st_c0_exe2_waitrequest,
		output [29:0] 		avm_local_bb2_st_c0_exe2_address,
		output 		avm_local_bb2_st_c0_exe2_read,
		output 		avm_local_bb2_st_c0_exe2_write,
		input 		avm_local_bb2_st_c0_exe2_writeack,
		output [255:0] 		avm_local_bb2_st_c0_exe2_writedata,
		output [31:0] 		avm_local_bb2_st_c0_exe2_byteenable,
		output [4:0] 		avm_local_bb2_st_c0_exe2_burstcount,
		output 		local_bb2_st_c0_exe2_active,
		input [255:0] 		avm_local_bb2_st_c0_exe18_readdata,
		input 		avm_local_bb2_st_c0_exe18_readdatavalid,
		input 		avm_local_bb2_st_c0_exe18_waitrequest,
		output [29:0] 		avm_local_bb2_st_c0_exe18_address,
		output 		avm_local_bb2_st_c0_exe18_read,
		output 		avm_local_bb2_st_c0_exe18_write,
		input 		avm_local_bb2_st_c0_exe18_writeack,
		output [255:0] 		avm_local_bb2_st_c0_exe18_writedata,
		output [31:0] 		avm_local_bb2_st_c0_exe18_byteenable,
		output [4:0] 		avm_local_bb2_st_c0_exe18_burstcount,
		output 		local_bb2_st_c0_exe18_active
	);


// Values used for debugging.  These are swept away by synthesis.
wire _entry;
wire _exit;
 reg [31:0] _num_entry_NO_SHIFT_REG;
 reg [31:0] _num_exit_NO_SHIFT_REG;
wire [31:0] _num_live;

assign _entry = ((&valid_in) & ~((|stall_out)));
assign _exit = ((&valid_out) & ~((|stall_in)));
assign _num_live = (_num_entry_NO_SHIFT_REG - _num_exit_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		_num_entry_NO_SHIFT_REG <= 32'h0;
		_num_exit_NO_SHIFT_REG <= 32'h0;
	end
	else
	begin
		if (_entry)
		begin
			_num_entry_NO_SHIFT_REG <= (_num_entry_NO_SHIFT_REG + 2'h1);
		end
		if (_exit)
		begin
			_num_exit_NO_SHIFT_REG <= (_num_exit_NO_SHIFT_REG + 2'h1);
		end
	end
end



// This section defines the behaviour of the MERGE node
wire merge_node_stall_in_0;
 reg merge_node_valid_out_0_NO_SHIFT_REG;
wire merge_node_stall_in_1;
 reg merge_node_valid_out_1_NO_SHIFT_REG;
wire merge_stalled_by_successors;
 reg merge_block_selector_NO_SHIFT_REG;
 reg merge_node_valid_in_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_c0_exe1_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_global_id_0_staging_reg_NO_SHIFT_REG;
 reg [31:0] local_lvm_c0_exe1_NO_SHIFT_REG;
 reg [31:0] local_lvm_input_global_id_0_NO_SHIFT_REG;
 reg is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
 reg invariant_valid_NO_SHIFT_REG;

assign merge_stalled_by_successors = ((merge_node_stall_in_0 & merge_node_valid_out_0_NO_SHIFT_REG) | (merge_node_stall_in_1 & merge_node_valid_out_1_NO_SHIFT_REG));
assign stall_out = merge_node_valid_in_staging_reg_NO_SHIFT_REG;

always @(*)
begin
	if ((merge_node_valid_in_staging_reg_NO_SHIFT_REG | valid_in))
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b1;
	end
	else
	begin
		merge_block_selector_NO_SHIFT_REG = 1'b0;
		is_merge_data_to_local_regs_valid_NO_SHIFT_REG = 1'b0;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		input_c0_exe1_staging_reg_NO_SHIFT_REG <= 'x;
		input_global_id_0_staging_reg_NO_SHIFT_REG <= 'x;
		merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (((merge_block_selector_NO_SHIFT_REG != 1'b0) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_staging_reg_NO_SHIFT_REG))
			begin
				input_c0_exe1_staging_reg_NO_SHIFT_REG <= input_c0_exe1;
				input_global_id_0_staging_reg_NO_SHIFT_REG <= input_global_id_0;
				merge_node_valid_in_staging_reg_NO_SHIFT_REG <= valid_in;
			end
		end
		else
		begin
			merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
		end
	end
end

always @(posedge clock)
begin
	if (~(merge_stalled_by_successors))
	begin
		case (merge_block_selector_NO_SHIFT_REG)
			1'b0:
			begin
				if (merge_node_valid_in_staging_reg_NO_SHIFT_REG)
				begin
					local_lvm_c0_exe1_NO_SHIFT_REG <= input_c0_exe1_staging_reg_NO_SHIFT_REG;
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0_staging_reg_NO_SHIFT_REG;
				end
				else
				begin
					local_lvm_c0_exe1_NO_SHIFT_REG <= input_c0_exe1;
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0;
				end
			end

			default:
			begin
			end

		endcase
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		merge_node_valid_out_0_NO_SHIFT_REG <= 1'b0;
		merge_node_valid_out_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (~(merge_stalled_by_successors))
		begin
			merge_node_valid_out_0_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
			merge_node_valid_out_1_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
		end
		else
		begin
			if (~(merge_node_stall_in_0))
			begin
				merge_node_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(merge_node_stall_in_1))
			begin
				merge_node_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		invariant_valid_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		invariant_valid_NO_SHIFT_REG <= (~(start) & (invariant_valid_NO_SHIFT_REG | is_merge_data_to_local_regs_valid_NO_SHIFT_REG));
	end
end


// This section implements an unregistered operation.
// 
wire local_bb2_idxprom9_stall_local;
wire [63:0] local_bb2_idxprom9;

assign local_bb2_idxprom9[63:32] = 32'h0;
assign local_bb2_idxprom9[31:0] = local_lvm_input_global_id_0_NO_SHIFT_REG;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_1to3_c0_exe1_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to3_c0_exe1_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_1to3_c0_exe1_0_NO_SHIFT_REG;
 logic rnode_1to3_c0_exe1_0_reg_3_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_1to3_c0_exe1_0_reg_3_NO_SHIFT_REG;
 logic rnode_1to3_c0_exe1_0_valid_out_reg_3_NO_SHIFT_REG;
 logic rnode_1to3_c0_exe1_0_stall_in_reg_3_NO_SHIFT_REG;
 logic rnode_1to3_c0_exe1_0_stall_out_reg_3_NO_SHIFT_REG;

acl_data_fifo rnode_1to3_c0_exe1_0_reg_3_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to3_c0_exe1_0_reg_3_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to3_c0_exe1_0_stall_in_reg_3_NO_SHIFT_REG),
	.valid_out(rnode_1to3_c0_exe1_0_valid_out_reg_3_NO_SHIFT_REG),
	.stall_out(rnode_1to3_c0_exe1_0_stall_out_reg_3_NO_SHIFT_REG),
	.data_in(local_lvm_c0_exe1_NO_SHIFT_REG),
	.data_out(rnode_1to3_c0_exe1_0_reg_3_NO_SHIFT_REG)
);

defparam rnode_1to3_c0_exe1_0_reg_3_fifo.DEPTH = 3;
defparam rnode_1to3_c0_exe1_0_reg_3_fifo.DATA_WIDTH = 32;
defparam rnode_1to3_c0_exe1_0_reg_3_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to3_c0_exe1_0_reg_3_fifo.IMPL = "ll_reg";

assign rnode_1to3_c0_exe1_0_reg_3_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_1_NO_SHIFT_REG;
assign merge_node_stall_in_1 = rnode_1to3_c0_exe1_0_stall_out_reg_3_NO_SHIFT_REG;
assign rnode_1to3_c0_exe1_0_NO_SHIFT_REG = rnode_1to3_c0_exe1_0_reg_3_NO_SHIFT_REG;
assign rnode_1to3_c0_exe1_0_stall_in_reg_3_NO_SHIFT_REG = rnode_1to3_c0_exe1_0_stall_in_NO_SHIFT_REG;
assign rnode_1to3_c0_exe1_0_valid_out_NO_SHIFT_REG = rnode_1to3_c0_exe1_0_valid_out_reg_3_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_idxprom9_valid_out_1;
wire local_bb2_idxprom9_stall_in_1;
 reg local_bb2_idxprom9_consumed_1_NO_SHIFT_REG;
wire local_bb2_arrayidx10_valid_out;
wire local_bb2_arrayidx10_stall_in;
 reg local_bb2_arrayidx10_consumed_0_NO_SHIFT_REG;
wire local_bb2_arrayidx10_inputs_ready;
wire local_bb2_arrayidx10_stall_local;
wire [63:0] local_bb2_arrayidx10;

assign local_bb2_arrayidx10_inputs_ready = merge_node_valid_out_0_NO_SHIFT_REG;
assign local_bb2_arrayidx10 = (input_rank + (local_bb2_idxprom9 << 6'h2));
assign local_bb2_arrayidx10_stall_local = ((local_bb2_idxprom9_stall_in_1 & ~(local_bb2_idxprom9_consumed_1_NO_SHIFT_REG)) | (local_bb2_arrayidx10_stall_in & ~(local_bb2_arrayidx10_consumed_0_NO_SHIFT_REG)));
assign local_bb2_idxprom9_valid_out_1 = (local_bb2_arrayidx10_inputs_ready & ~(local_bb2_idxprom9_consumed_1_NO_SHIFT_REG));
assign local_bb2_arrayidx10_valid_out = (local_bb2_arrayidx10_inputs_ready & ~(local_bb2_arrayidx10_consumed_0_NO_SHIFT_REG));
assign merge_node_stall_in_0 = (|local_bb2_arrayidx10_stall_local);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_idxprom9_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb2_arrayidx10_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_idxprom9_consumed_1_NO_SHIFT_REG <= (local_bb2_arrayidx10_inputs_ready & (local_bb2_idxprom9_consumed_1_NO_SHIFT_REG | ~(local_bb2_idxprom9_stall_in_1)) & local_bb2_arrayidx10_stall_local);
		local_bb2_arrayidx10_consumed_0_NO_SHIFT_REG <= (local_bb2_arrayidx10_inputs_ready & (local_bb2_arrayidx10_consumed_0_NO_SHIFT_REG | ~(local_bb2_arrayidx10_stall_in)) & local_bb2_arrayidx10_stall_local);
	end
end


// This section implements an unregistered operation.
// 
wire local_bb2_c0_eni11_stall_local;
wire [95:0] local_bb2_c0_eni11;

assign local_bb2_c0_eni11[31:0] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
assign local_bb2_c0_eni11[63:32] = rnode_1to3_c0_exe1_0_NO_SHIFT_REG;
assign local_bb2_c0_eni11[95:64] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;

// Register node:
//  * latency = 31
//  * capacity = 31
 logic rnode_1to32_bb2_idxprom9_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to32_bb2_idxprom9_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_1to32_bb2_idxprom9_0_NO_SHIFT_REG;
 logic rnode_1to32_bb2_idxprom9_0_reg_32_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_1to32_bb2_idxprom9_0_reg_32_NO_SHIFT_REG;
 logic rnode_1to32_bb2_idxprom9_0_valid_out_reg_32_NO_SHIFT_REG;
 logic rnode_1to32_bb2_idxprom9_0_stall_in_reg_32_NO_SHIFT_REG;
 logic rnode_1to32_bb2_idxprom9_0_stall_out_reg_32_NO_SHIFT_REG;

acl_data_fifo rnode_1to32_bb2_idxprom9_0_reg_32_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to32_bb2_idxprom9_0_reg_32_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to32_bb2_idxprom9_0_stall_in_reg_32_NO_SHIFT_REG),
	.valid_out(rnode_1to32_bb2_idxprom9_0_valid_out_reg_32_NO_SHIFT_REG),
	.stall_out(rnode_1to32_bb2_idxprom9_0_stall_out_reg_32_NO_SHIFT_REG),
	.data_in(local_bb2_idxprom9),
	.data_out(rnode_1to32_bb2_idxprom9_0_reg_32_NO_SHIFT_REG)
);

defparam rnode_1to32_bb2_idxprom9_0_reg_32_fifo.DEPTH = 32;
defparam rnode_1to32_bb2_idxprom9_0_reg_32_fifo.DATA_WIDTH = 64;
defparam rnode_1to32_bb2_idxprom9_0_reg_32_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to32_bb2_idxprom9_0_reg_32_fifo.IMPL = "ram";

assign rnode_1to32_bb2_idxprom9_0_reg_32_inputs_ready_NO_SHIFT_REG = local_bb2_idxprom9_valid_out_1;
assign local_bb2_idxprom9_stall_in_1 = rnode_1to32_bb2_idxprom9_0_stall_out_reg_32_NO_SHIFT_REG;
assign rnode_1to32_bb2_idxprom9_0_NO_SHIFT_REG = rnode_1to32_bb2_idxprom9_0_reg_32_NO_SHIFT_REG;
assign rnode_1to32_bb2_idxprom9_0_stall_in_reg_32_NO_SHIFT_REG = rnode_1to32_bb2_idxprom9_0_stall_in_NO_SHIFT_REG;
assign rnode_1to32_bb2_idxprom9_0_valid_out_NO_SHIFT_REG = rnode_1to32_bb2_idxprom9_0_valid_out_reg_32_NO_SHIFT_REG;

// This section implements a staging register.
// 
wire rstag_1to1_bb2_arrayidx10_valid_out_0;
wire rstag_1to1_bb2_arrayidx10_stall_in_0;
 reg rstag_1to1_bb2_arrayidx10_consumed_0_NO_SHIFT_REG;
wire rstag_1to1_bb2_arrayidx10_valid_out_1;
wire rstag_1to1_bb2_arrayidx10_stall_in_1;
 reg rstag_1to1_bb2_arrayidx10_consumed_1_NO_SHIFT_REG;
wire rstag_1to1_bb2_arrayidx10_inputs_ready;
wire rstag_1to1_bb2_arrayidx10_stall_local;
 reg rstag_1to1_bb2_arrayidx10_staging_valid_NO_SHIFT_REG;
wire rstag_1to1_bb2_arrayidx10_combined_valid;
 reg [63:0] rstag_1to1_bb2_arrayidx10_staging_reg_NO_SHIFT_REG;
wire [63:0] rstag_1to1_bb2_arrayidx10;

assign rstag_1to1_bb2_arrayidx10_inputs_ready = local_bb2_arrayidx10_valid_out;
assign rstag_1to1_bb2_arrayidx10 = (rstag_1to1_bb2_arrayidx10_staging_valid_NO_SHIFT_REG ? rstag_1to1_bb2_arrayidx10_staging_reg_NO_SHIFT_REG : local_bb2_arrayidx10);
assign rstag_1to1_bb2_arrayidx10_combined_valid = (rstag_1to1_bb2_arrayidx10_staging_valid_NO_SHIFT_REG | rstag_1to1_bb2_arrayidx10_inputs_ready);
assign rstag_1to1_bb2_arrayidx10_stall_local = ((rstag_1to1_bb2_arrayidx10_stall_in_0 & ~(rstag_1to1_bb2_arrayidx10_consumed_0_NO_SHIFT_REG)) | (rstag_1to1_bb2_arrayidx10_stall_in_1 & ~(rstag_1to1_bb2_arrayidx10_consumed_1_NO_SHIFT_REG)));
assign rstag_1to1_bb2_arrayidx10_valid_out_0 = (rstag_1to1_bb2_arrayidx10_combined_valid & ~(rstag_1to1_bb2_arrayidx10_consumed_0_NO_SHIFT_REG));
assign rstag_1to1_bb2_arrayidx10_valid_out_1 = (rstag_1to1_bb2_arrayidx10_combined_valid & ~(rstag_1to1_bb2_arrayidx10_consumed_1_NO_SHIFT_REG));
assign local_bb2_arrayidx10_stall_in = (|rstag_1to1_bb2_arrayidx10_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_1to1_bb2_arrayidx10_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_1to1_bb2_arrayidx10_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_1to1_bb2_arrayidx10_stall_local)
		begin
			if (~(rstag_1to1_bb2_arrayidx10_staging_valid_NO_SHIFT_REG))
			begin
				rstag_1to1_bb2_arrayidx10_staging_valid_NO_SHIFT_REG <= rstag_1to1_bb2_arrayidx10_inputs_ready;
			end
		end
		else
		begin
			rstag_1to1_bb2_arrayidx10_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_1to1_bb2_arrayidx10_staging_valid_NO_SHIFT_REG))
		begin
			rstag_1to1_bb2_arrayidx10_staging_reg_NO_SHIFT_REG <= local_bb2_arrayidx10;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_1to1_bb2_arrayidx10_consumed_0_NO_SHIFT_REG <= 1'b0;
		rstag_1to1_bb2_arrayidx10_consumed_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		rstag_1to1_bb2_arrayidx10_consumed_0_NO_SHIFT_REG <= (rstag_1to1_bb2_arrayidx10_combined_valid & (rstag_1to1_bb2_arrayidx10_consumed_0_NO_SHIFT_REG | ~(rstag_1to1_bb2_arrayidx10_stall_in_0)) & rstag_1to1_bb2_arrayidx10_stall_local);
		rstag_1to1_bb2_arrayidx10_consumed_1_NO_SHIFT_REG <= (rstag_1to1_bb2_arrayidx10_combined_valid & (rstag_1to1_bb2_arrayidx10_consumed_1_NO_SHIFT_REG | ~(rstag_1to1_bb2_arrayidx10_stall_in_1)) & rstag_1to1_bb2_arrayidx10_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_32to33_bb2_idxprom9_0_valid_out_NO_SHIFT_REG;
 logic rnode_32to33_bb2_idxprom9_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_32to33_bb2_idxprom9_0_NO_SHIFT_REG;
 logic rnode_32to33_bb2_idxprom9_0_reg_33_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_32to33_bb2_idxprom9_0_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb2_idxprom9_0_valid_out_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb2_idxprom9_0_stall_in_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb2_idxprom9_0_stall_out_reg_33_NO_SHIFT_REG;

acl_data_fifo rnode_32to33_bb2_idxprom9_0_reg_33_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_32to33_bb2_idxprom9_0_reg_33_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_32to33_bb2_idxprom9_0_stall_in_reg_33_NO_SHIFT_REG),
	.valid_out(rnode_32to33_bb2_idxprom9_0_valid_out_reg_33_NO_SHIFT_REG),
	.stall_out(rnode_32to33_bb2_idxprom9_0_stall_out_reg_33_NO_SHIFT_REG),
	.data_in(rnode_1to32_bb2_idxprom9_0_NO_SHIFT_REG),
	.data_out(rnode_32to33_bb2_idxprom9_0_reg_33_NO_SHIFT_REG)
);

defparam rnode_32to33_bb2_idxprom9_0_reg_33_fifo.DEPTH = 2;
defparam rnode_32to33_bb2_idxprom9_0_reg_33_fifo.DATA_WIDTH = 64;
defparam rnode_32to33_bb2_idxprom9_0_reg_33_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_32to33_bb2_idxprom9_0_reg_33_fifo.IMPL = "ll_reg";

assign rnode_32to33_bb2_idxprom9_0_reg_33_inputs_ready_NO_SHIFT_REG = rnode_1to32_bb2_idxprom9_0_valid_out_NO_SHIFT_REG;
assign rnode_1to32_bb2_idxprom9_0_stall_in_NO_SHIFT_REG = rnode_32to33_bb2_idxprom9_0_stall_out_reg_33_NO_SHIFT_REG;
assign rnode_32to33_bb2_idxprom9_0_NO_SHIFT_REG = rnode_32to33_bb2_idxprom9_0_reg_33_NO_SHIFT_REG;
assign rnode_32to33_bb2_idxprom9_0_stall_in_reg_33_NO_SHIFT_REG = rnode_32to33_bb2_idxprom9_0_stall_in_NO_SHIFT_REG;
assign rnode_32to33_bb2_idxprom9_0_valid_out_NO_SHIFT_REG = rnode_32to33_bb2_idxprom9_0_valid_out_reg_33_NO_SHIFT_REG;

// Register node:
//  * latency = 191
//  * capacity = 191
 logic rnode_1to192_bb2_arrayidx10_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to192_bb2_arrayidx10_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_1to192_bb2_arrayidx10_0_NO_SHIFT_REG;
 logic rnode_1to192_bb2_arrayidx10_0_reg_192_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_1to192_bb2_arrayidx10_0_reg_192_NO_SHIFT_REG;
 logic rnode_1to192_bb2_arrayidx10_0_valid_out_reg_192_NO_SHIFT_REG;
 logic rnode_1to192_bb2_arrayidx10_0_stall_in_reg_192_NO_SHIFT_REG;
 logic rnode_1to192_bb2_arrayidx10_0_stall_out_reg_192_NO_SHIFT_REG;

acl_data_fifo rnode_1to192_bb2_arrayidx10_0_reg_192_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to192_bb2_arrayidx10_0_reg_192_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to192_bb2_arrayidx10_0_stall_in_reg_192_NO_SHIFT_REG),
	.valid_out(rnode_1to192_bb2_arrayidx10_0_valid_out_reg_192_NO_SHIFT_REG),
	.stall_out(rnode_1to192_bb2_arrayidx10_0_stall_out_reg_192_NO_SHIFT_REG),
	.data_in(rstag_1to1_bb2_arrayidx10),
	.data_out(rnode_1to192_bb2_arrayidx10_0_reg_192_NO_SHIFT_REG)
);

defparam rnode_1to192_bb2_arrayidx10_0_reg_192_fifo.DEPTH = 192;
defparam rnode_1to192_bb2_arrayidx10_0_reg_192_fifo.DATA_WIDTH = 64;
defparam rnode_1to192_bb2_arrayidx10_0_reg_192_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to192_bb2_arrayidx10_0_reg_192_fifo.IMPL = "ram";

assign rnode_1to192_bb2_arrayidx10_0_reg_192_inputs_ready_NO_SHIFT_REG = rstag_1to1_bb2_arrayidx10_valid_out_0;
assign rstag_1to1_bb2_arrayidx10_stall_in_0 = rnode_1to192_bb2_arrayidx10_0_stall_out_reg_192_NO_SHIFT_REG;
assign rnode_1to192_bb2_arrayidx10_0_NO_SHIFT_REG = rnode_1to192_bb2_arrayidx10_0_reg_192_NO_SHIFT_REG;
assign rnode_1to192_bb2_arrayidx10_0_stall_in_reg_192_NO_SHIFT_REG = rnode_1to192_bb2_arrayidx10_0_stall_in_NO_SHIFT_REG;
assign rnode_1to192_bb2_arrayidx10_0_valid_out_NO_SHIFT_REG = rnode_1to192_bb2_arrayidx10_0_valid_out_reg_192_NO_SHIFT_REG;

// This section implements a registered operation.
// 
wire local_bb2_ld__inputs_ready;
 reg local_bb2_ld__valid_out_NO_SHIFT_REG;
wire local_bb2_ld__stall_in;
wire local_bb2_ld__output_regs_ready;
wire local_bb2_ld__fu_stall_out;
wire local_bb2_ld__fu_valid_out;
wire [31:0] local_bb2_ld__lsu_dataout;
 reg [31:0] local_bb2_ld__NO_SHIFT_REG;
wire local_bb2_ld__causedstall;

lsu_top lsu_local_bb2_ld_ (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(rstag_1to1_bb2_arrayidx10),
	.stream_size(input_global_size_0),
	.stream_reset(valid_in),
	.o_stall(local_bb2_ld__fu_stall_out),
	.i_valid(local_bb2_ld__inputs_ready),
	.i_address(rstag_1to1_bb2_arrayidx10),
	.i_writedata(),
	.i_cmpdata(),
	.i_predicate(1'b0),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb2_ld__output_regs_ready)),
	.o_valid(local_bb2_ld__fu_valid_out),
	.o_readdata(local_bb2_ld__lsu_dataout),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb2_ld__active),
	.avm_address(avm_local_bb2_ld__address),
	.avm_read(avm_local_bb2_ld__read),
	.avm_readdata(avm_local_bb2_ld__readdata),
	.avm_write(avm_local_bb2_ld__write),
	.avm_writeack(avm_local_bb2_ld__writeack),
	.avm_burstcount(avm_local_bb2_ld__burstcount),
	.avm_writedata(avm_local_bb2_ld__writedata),
	.avm_byteenable(avm_local_bb2_ld__byteenable),
	.avm_waitrequest(avm_local_bb2_ld__waitrequest),
	.avm_readdatavalid(avm_local_bb2_ld__readdatavalid),
	.profile_bw(),
	.profile_bw_incr(),
	.profile_total_ivalid(),
	.profile_total_req(),
	.profile_i_stall_count(),
	.profile_o_stall_count(),
	.profile_avm_readwrite_count(),
	.profile_avm_burstcount_total(),
	.profile_avm_burstcount_total_incr(),
	.profile_req_cache_hit_count(),
	.profile_extra_unaligned_reqs(),
	.profile_avm_stall()
);

defparam lsu_local_bb2_ld_.AWIDTH = 30;
defparam lsu_local_bb2_ld_.WIDTH_BYTES = 4;
defparam lsu_local_bb2_ld_.MWIDTH_BYTES = 32;
defparam lsu_local_bb2_ld_.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb2_ld_.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb2_ld_.READ = 1;
defparam lsu_local_bb2_ld_.ATOMIC = 0;
defparam lsu_local_bb2_ld_.WIDTH = 32;
defparam lsu_local_bb2_ld_.MWIDTH = 256;
defparam lsu_local_bb2_ld_.ATOMIC_WIDTH = 3;
defparam lsu_local_bb2_ld_.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb2_ld_.KERNEL_SIDE_MEM_LATENCY = 2;
defparam lsu_local_bb2_ld_.MEMORY_SIDE_MEM_LATENCY = 122;
defparam lsu_local_bb2_ld_.USE_WRITE_ACK = 0;
defparam lsu_local_bb2_ld_.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb2_ld_.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb2_ld_.NUMBER_BANKS = 1;
defparam lsu_local_bb2_ld_.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb2_ld_.USEINPUTFIFO = 0;
defparam lsu_local_bb2_ld_.USECACHING = 0;
defparam lsu_local_bb2_ld_.USEOUTPUTFIFO = 1;
defparam lsu_local_bb2_ld_.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb2_ld_.HIGH_FMAX = 1;
defparam lsu_local_bb2_ld_.ADDRSPACE = 1;
defparam lsu_local_bb2_ld_.STYLE = "STREAMING";

assign local_bb2_ld__inputs_ready = rstag_1to1_bb2_arrayidx10_valid_out_1;
assign local_bb2_ld__output_regs_ready = (&(~(local_bb2_ld__valid_out_NO_SHIFT_REG) | ~(local_bb2_ld__stall_in)));
assign rstag_1to1_bb2_arrayidx10_stall_in_1 = (local_bb2_ld__fu_stall_out | ~(local_bb2_ld__inputs_ready));
assign local_bb2_ld__causedstall = (local_bb2_ld__inputs_ready && (local_bb2_ld__fu_stall_out && !(~(local_bb2_ld__output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_ld__NO_SHIFT_REG <= 'x;
		local_bb2_ld__valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb2_ld__output_regs_ready)
		begin
			local_bb2_ld__NO_SHIFT_REG <= local_bb2_ld__lsu_dataout;
			local_bb2_ld__valid_out_NO_SHIFT_REG <= local_bb2_ld__fu_valid_out;
		end
		else
		begin
			if (~(local_bb2_ld__stall_in))
			begin
				local_bb2_ld__valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb2_arrayidx14_valid_out;
wire local_bb2_arrayidx14_stall_in;
wire local_bb2_arrayidx14_inputs_ready;
wire local_bb2_arrayidx14_stall_local;
wire [63:0] local_bb2_arrayidx14;

assign local_bb2_arrayidx14_inputs_ready = rnode_32to33_bb2_idxprom9_0_valid_out_NO_SHIFT_REG;
assign local_bb2_arrayidx14 = (input_err_arr + (rnode_32to33_bb2_idxprom9_0_NO_SHIFT_REG << 6'h2));
assign local_bb2_arrayidx14_valid_out = local_bb2_arrayidx14_inputs_ready;
assign local_bb2_arrayidx14_stall_local = local_bb2_arrayidx14_stall_in;
assign rnode_32to33_bb2_idxprom9_0_stall_in_NO_SHIFT_REG = (|local_bb2_arrayidx14_stall_local);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_192to193_bb2_arrayidx10_0_valid_out_NO_SHIFT_REG;
 logic rnode_192to193_bb2_arrayidx10_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_192to193_bb2_arrayidx10_0_NO_SHIFT_REG;
 logic rnode_192to193_bb2_arrayidx10_0_reg_193_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_192to193_bb2_arrayidx10_0_reg_193_NO_SHIFT_REG;
 logic rnode_192to193_bb2_arrayidx10_0_valid_out_reg_193_NO_SHIFT_REG;
 logic rnode_192to193_bb2_arrayidx10_0_stall_in_reg_193_NO_SHIFT_REG;
 logic rnode_192to193_bb2_arrayidx10_0_stall_out_reg_193_NO_SHIFT_REG;

acl_data_fifo rnode_192to193_bb2_arrayidx10_0_reg_193_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_192to193_bb2_arrayidx10_0_reg_193_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_192to193_bb2_arrayidx10_0_stall_in_reg_193_NO_SHIFT_REG),
	.valid_out(rnode_192to193_bb2_arrayidx10_0_valid_out_reg_193_NO_SHIFT_REG),
	.stall_out(rnode_192to193_bb2_arrayidx10_0_stall_out_reg_193_NO_SHIFT_REG),
	.data_in(rnode_1to192_bb2_arrayidx10_0_NO_SHIFT_REG),
	.data_out(rnode_192to193_bb2_arrayidx10_0_reg_193_NO_SHIFT_REG)
);

defparam rnode_192to193_bb2_arrayidx10_0_reg_193_fifo.DEPTH = 2;
defparam rnode_192to193_bb2_arrayidx10_0_reg_193_fifo.DATA_WIDTH = 64;
defparam rnode_192to193_bb2_arrayidx10_0_reg_193_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_192to193_bb2_arrayidx10_0_reg_193_fifo.IMPL = "ll_reg";

assign rnode_192to193_bb2_arrayidx10_0_reg_193_inputs_ready_NO_SHIFT_REG = rnode_1to192_bb2_arrayidx10_0_valid_out_NO_SHIFT_REG;
assign rnode_1to192_bb2_arrayidx10_0_stall_in_NO_SHIFT_REG = rnode_192to193_bb2_arrayidx10_0_stall_out_reg_193_NO_SHIFT_REG;
assign rnode_192to193_bb2_arrayidx10_0_NO_SHIFT_REG = rnode_192to193_bb2_arrayidx10_0_reg_193_NO_SHIFT_REG;
assign rnode_192to193_bb2_arrayidx10_0_stall_in_reg_193_NO_SHIFT_REG = rnode_192to193_bb2_arrayidx10_0_stall_in_NO_SHIFT_REG;
assign rnode_192to193_bb2_arrayidx10_0_valid_out_NO_SHIFT_REG = rnode_192to193_bb2_arrayidx10_0_valid_out_reg_193_NO_SHIFT_REG;

// This section implements a staging register.
// 
wire rstag_3to3_bb2_ld__valid_out;
wire rstag_3to3_bb2_ld__stall_in;
wire rstag_3to3_bb2_ld__inputs_ready;
wire rstag_3to3_bb2_ld__stall_local;
 reg rstag_3to3_bb2_ld__staging_valid_NO_SHIFT_REG;
wire rstag_3to3_bb2_ld__combined_valid;
 reg [31:0] rstag_3to3_bb2_ld__staging_reg_NO_SHIFT_REG;
wire [31:0] rstag_3to3_bb2_ld_;

assign rstag_3to3_bb2_ld__inputs_ready = local_bb2_ld__valid_out_NO_SHIFT_REG;
assign rstag_3to3_bb2_ld_ = (rstag_3to3_bb2_ld__staging_valid_NO_SHIFT_REG ? rstag_3to3_bb2_ld__staging_reg_NO_SHIFT_REG : local_bb2_ld__NO_SHIFT_REG);
assign rstag_3to3_bb2_ld__combined_valid = (rstag_3to3_bb2_ld__staging_valid_NO_SHIFT_REG | rstag_3to3_bb2_ld__inputs_ready);
assign rstag_3to3_bb2_ld__valid_out = rstag_3to3_bb2_ld__combined_valid;
assign rstag_3to3_bb2_ld__stall_local = rstag_3to3_bb2_ld__stall_in;
assign local_bb2_ld__stall_in = (|rstag_3to3_bb2_ld__staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_3to3_bb2_ld__staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_3to3_bb2_ld__staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_3to3_bb2_ld__stall_local)
		begin
			if (~(rstag_3to3_bb2_ld__staging_valid_NO_SHIFT_REG))
			begin
				rstag_3to3_bb2_ld__staging_valid_NO_SHIFT_REG <= rstag_3to3_bb2_ld__inputs_ready;
			end
		end
		else
		begin
			rstag_3to3_bb2_ld__staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_3to3_bb2_ld__staging_valid_NO_SHIFT_REG))
		begin
			rstag_3to3_bb2_ld__staging_reg_NO_SHIFT_REG <= local_bb2_ld__NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb2_c0_eni22_valid_out;
wire local_bb2_c0_eni22_stall_in;
wire local_bb2_c0_eni22_inputs_ready;
wire local_bb2_c0_eni22_stall_local;
wire [95:0] local_bb2_c0_eni22;

assign local_bb2_c0_eni22_inputs_ready = (rnode_1to3_c0_exe1_0_valid_out_NO_SHIFT_REG & rstag_3to3_bb2_ld__valid_out);
assign local_bb2_c0_eni22[63:0] = local_bb2_c0_eni11[63:0];
assign local_bb2_c0_eni22[95:64] = rstag_3to3_bb2_ld_;
assign local_bb2_c0_eni22_valid_out = local_bb2_c0_eni22_inputs_ready;
assign local_bb2_c0_eni22_stall_local = local_bb2_c0_eni22_stall_in;
assign rnode_1to3_c0_exe1_0_stall_in_NO_SHIFT_REG = (local_bb2_c0_eni22_stall_local | ~(local_bb2_c0_eni22_inputs_ready));
assign rstag_3to3_bb2_ld__stall_in = (local_bb2_c0_eni22_stall_local | ~(local_bb2_c0_eni22_inputs_ready));

// This section implements a registered operation.
// 
wire local_bb2_c0_enter3_c0_eni22_inputs_ready;
 reg local_bb2_c0_enter3_c0_eni22_valid_out_0_NO_SHIFT_REG;
wire local_bb2_c0_enter3_c0_eni22_stall_in_0;
 reg local_bb2_c0_enter3_c0_eni22_valid_out_1_NO_SHIFT_REG;
wire local_bb2_c0_enter3_c0_eni22_stall_in_1;
wire local_bb2_c0_enter3_c0_eni22_output_regs_ready;
 reg [95:0] local_bb2_c0_enter3_c0_eni22_NO_SHIFT_REG;
wire local_bb2_c0_enter3_c0_eni22_input_accepted;
wire local_bb2_c0_exit7_c0_exi2_entry_stall;
wire local_bb2_c0_exit7_c0_exi2_output_regs_ready;
wire [25:0] local_bb2_c0_exit7_c0_exi2_valid_bits;
wire local_bb2_c0_exit7_c0_exi2_phases;
wire local_bb2_c0_enter3_c0_eni22_inc_pipelined_thread;
wire local_bb2_c0_enter3_c0_eni22_dec_pipelined_thread;
wire local_bb2_c0_enter3_c0_eni22_causedstall;

assign local_bb2_c0_enter3_c0_eni22_inputs_ready = local_bb2_c0_eni22_valid_out;
assign local_bb2_c0_enter3_c0_eni22_output_regs_ready = 1'b1;
assign local_bb2_c0_enter3_c0_eni22_input_accepted = (local_bb2_c0_enter3_c0_eni22_inputs_ready && !(local_bb2_c0_exit7_c0_exi2_entry_stall));
assign local_bb2_c0_enter3_c0_eni22_inc_pipelined_thread = 1'b1;
assign local_bb2_c0_enter3_c0_eni22_dec_pipelined_thread = ~(1'b0);
assign local_bb2_c0_eni22_stall_in = ((~(local_bb2_c0_enter3_c0_eni22_inputs_ready) | local_bb2_c0_exit7_c0_exi2_entry_stall) | ~(1'b1));
assign local_bb2_c0_enter3_c0_eni22_causedstall = (1'b1 && ((~(local_bb2_c0_enter3_c0_eni22_inputs_ready) | local_bb2_c0_exit7_c0_exi2_entry_stall) && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_c0_enter3_c0_eni22_NO_SHIFT_REG <= 'x;
		local_bb2_c0_enter3_c0_eni22_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_c0_enter3_c0_eni22_valid_out_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb2_c0_enter3_c0_eni22_output_regs_ready)
		begin
			local_bb2_c0_enter3_c0_eni22_NO_SHIFT_REG <= local_bb2_c0_eni22;
			local_bb2_c0_enter3_c0_eni22_valid_out_0_NO_SHIFT_REG <= 1'b1;
			local_bb2_c0_enter3_c0_eni22_valid_out_1_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb2_c0_enter3_c0_eni22_stall_in_0))
			begin
				local_bb2_c0_enter3_c0_eni22_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb2_c0_enter3_c0_eni22_stall_in_1))
			begin
				local_bb2_c0_enter3_c0_eni22_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb2_c0_ene14_stall_local;
wire [31:0] local_bb2_c0_ene14;

assign local_bb2_c0_ene14 = local_bb2_c0_enter3_c0_eni22_NO_SHIFT_REG[63:32];

// This section implements an unregistered operation.
// 
wire local_bb2_c0_ene25_valid_out;
wire local_bb2_c0_ene25_stall_in;
wire local_bb2_c0_ene25_inputs_ready;
wire local_bb2_c0_ene25_stall_local;
wire [31:0] local_bb2_c0_ene25;

assign local_bb2_c0_ene25_inputs_ready = local_bb2_c0_enter3_c0_eni22_valid_out_1_NO_SHIFT_REG;
assign local_bb2_c0_ene25 = local_bb2_c0_enter3_c0_eni22_NO_SHIFT_REG[95:64];
assign local_bb2_c0_ene25_valid_out = 1'b1;
assign local_bb2_c0_enter3_c0_eni22_stall_in_1 = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_var__stall_local;
wire [31:0] local_bb2_var_;

assign local_bb2_var_ = local_bb2_c0_ene14;

// This section implements an unregistered operation.
// 
wire local_bb2_var__u12_stall_local;
wire [31:0] local_bb2_var__u12;

assign local_bb2_var__u12 = input_sink_val;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_4to5_bb2_c0_ene25_0_valid_out_NO_SHIFT_REG;
 logic rnode_4to5_bb2_c0_ene25_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb2_c0_ene25_0_NO_SHIFT_REG;
 logic rnode_4to5_bb2_c0_ene25_0_reg_5_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb2_c0_ene25_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb2_c0_ene25_0_valid_out_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb2_c0_ene25_0_stall_in_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb2_c0_ene25_0_stall_out_reg_5_NO_SHIFT_REG;

acl_data_fifo rnode_4to5_bb2_c0_ene25_0_reg_5_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_4to5_bb2_c0_ene25_0_reg_5_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_4to5_bb2_c0_ene25_0_stall_in_reg_5_NO_SHIFT_REG),
	.valid_out(rnode_4to5_bb2_c0_ene25_0_valid_out_reg_5_NO_SHIFT_REG),
	.stall_out(rnode_4to5_bb2_c0_ene25_0_stall_out_reg_5_NO_SHIFT_REG),
	.data_in(local_bb2_c0_ene25),
	.data_out(rnode_4to5_bb2_c0_ene25_0_reg_5_NO_SHIFT_REG)
);

defparam rnode_4to5_bb2_c0_ene25_0_reg_5_fifo.DEPTH = 1;
defparam rnode_4to5_bb2_c0_ene25_0_reg_5_fifo.DATA_WIDTH = 32;
defparam rnode_4to5_bb2_c0_ene25_0_reg_5_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_4to5_bb2_c0_ene25_0_reg_5_fifo.IMPL = "shift_reg";

assign rnode_4to5_bb2_c0_ene25_0_reg_5_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_c0_ene25_stall_in = 1'b0;
assign rnode_4to5_bb2_c0_ene25_0_NO_SHIFT_REG = rnode_4to5_bb2_c0_ene25_0_reg_5_NO_SHIFT_REG;
assign rnode_4to5_bb2_c0_ene25_0_stall_in_reg_5_NO_SHIFT_REG = 1'b0;
assign rnode_4to5_bb2_c0_ene25_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_var__u13_stall_local;
wire [31:0] local_bb2_var__u13;

assign local_bb2_var__u13 = (input_wii_cmp1 ? 32'h0 : local_bb2_var_);

// This section implements an unregistered operation.
// 
wire local_bb2_and_i307_stall_local;
wire [31:0] local_bb2_and_i307;

assign local_bb2_and_i307 = (local_bb2_var__u12 >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb2_and10_i313_stall_local;
wire [31:0] local_bb2_and10_i313;

assign local_bb2_and10_i313 = (local_bb2_var__u12 & 32'hFFFF);

// Register node:
//  * latency = 16
//  * capacity = 16
 logic rnode_5to21_bb2_c0_ene25_0_valid_out_NO_SHIFT_REG;
 logic rnode_5to21_bb2_c0_ene25_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_5to21_bb2_c0_ene25_0_NO_SHIFT_REG;
 logic rnode_5to21_bb2_c0_ene25_0_reg_21_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_5to21_bb2_c0_ene25_0_reg_21_NO_SHIFT_REG;
 logic rnode_5to21_bb2_c0_ene25_0_valid_out_reg_21_NO_SHIFT_REG;
 logic rnode_5to21_bb2_c0_ene25_0_stall_in_reg_21_NO_SHIFT_REG;
 logic rnode_5to21_bb2_c0_ene25_0_stall_out_reg_21_NO_SHIFT_REG;

acl_data_fifo rnode_5to21_bb2_c0_ene25_0_reg_21_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to21_bb2_c0_ene25_0_reg_21_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to21_bb2_c0_ene25_0_stall_in_reg_21_NO_SHIFT_REG),
	.valid_out(rnode_5to21_bb2_c0_ene25_0_valid_out_reg_21_NO_SHIFT_REG),
	.stall_out(rnode_5to21_bb2_c0_ene25_0_stall_out_reg_21_NO_SHIFT_REG),
	.data_in(rnode_4to5_bb2_c0_ene25_0_NO_SHIFT_REG),
	.data_out(rnode_5to21_bb2_c0_ene25_0_reg_21_NO_SHIFT_REG)
);

defparam rnode_5to21_bb2_c0_ene25_0_reg_21_fifo.DEPTH = 16;
defparam rnode_5to21_bb2_c0_ene25_0_reg_21_fifo.DATA_WIDTH = 32;
defparam rnode_5to21_bb2_c0_ene25_0_reg_21_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to21_bb2_c0_ene25_0_reg_21_fifo.IMPL = "shift_reg";

assign rnode_5to21_bb2_c0_ene25_0_reg_21_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_4to5_bb2_c0_ene25_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_5to21_bb2_c0_ene25_0_NO_SHIFT_REG = rnode_5to21_bb2_c0_ene25_0_reg_21_NO_SHIFT_REG;
assign rnode_5to21_bb2_c0_ene25_0_stall_in_reg_21_NO_SHIFT_REG = 1'b0;
assign rnode_5to21_bb2_c0_ene25_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_and2_i309_stall_local;
wire [31:0] local_bb2_and2_i309;

assign local_bb2_and2_i309 = (local_bb2_var__u13 >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb2_and12_i314_stall_local;
wire [31:0] local_bb2_and12_i314;

assign local_bb2_and12_i314 = (local_bb2_var__u13 & 32'hFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_shr_i308_stall_local;
wire [31:0] local_bb2_shr_i308;

assign local_bb2_shr_i308 = (local_bb2_and_i307 & 32'h7FFF);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_21to22_bb2_c0_ene25_0_valid_out_NO_SHIFT_REG;
 logic rnode_21to22_bb2_c0_ene25_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_21to22_bb2_c0_ene25_0_NO_SHIFT_REG;
 logic rnode_21to22_bb2_c0_ene25_0_reg_22_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_21to22_bb2_c0_ene25_0_reg_22_NO_SHIFT_REG;
 logic rnode_21to22_bb2_c0_ene25_0_valid_out_reg_22_NO_SHIFT_REG;
 logic rnode_21to22_bb2_c0_ene25_0_stall_in_reg_22_NO_SHIFT_REG;
 logic rnode_21to22_bb2_c0_ene25_0_stall_out_reg_22_NO_SHIFT_REG;

acl_data_fifo rnode_21to22_bb2_c0_ene25_0_reg_22_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_21to22_bb2_c0_ene25_0_reg_22_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_21to22_bb2_c0_ene25_0_stall_in_reg_22_NO_SHIFT_REG),
	.valid_out(rnode_21to22_bb2_c0_ene25_0_valid_out_reg_22_NO_SHIFT_REG),
	.stall_out(rnode_21to22_bb2_c0_ene25_0_stall_out_reg_22_NO_SHIFT_REG),
	.data_in(rnode_5to21_bb2_c0_ene25_0_NO_SHIFT_REG),
	.data_out(rnode_21to22_bb2_c0_ene25_0_reg_22_NO_SHIFT_REG)
);

defparam rnode_21to22_bb2_c0_ene25_0_reg_22_fifo.DEPTH = 1;
defparam rnode_21to22_bb2_c0_ene25_0_reg_22_fifo.DATA_WIDTH = 32;
defparam rnode_21to22_bb2_c0_ene25_0_reg_22_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_21to22_bb2_c0_ene25_0_reg_22_fifo.IMPL = "shift_reg";

assign rnode_21to22_bb2_c0_ene25_0_reg_22_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_5to21_bb2_c0_ene25_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_21to22_bb2_c0_ene25_0_NO_SHIFT_REG = rnode_21to22_bb2_c0_ene25_0_reg_22_NO_SHIFT_REG;
assign rnode_21to22_bb2_c0_ene25_0_stall_in_reg_22_NO_SHIFT_REG = 1'b0;
assign rnode_21to22_bb2_c0_ene25_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_shr3_i310_stall_local;
wire [31:0] local_bb2_shr3_i310;

assign local_bb2_shr3_i310 = (local_bb2_and2_i309 & 32'h7FFF);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp13_i315_stall_local;
wire local_bb2_cmp13_i315;

assign local_bb2_cmp13_i315 = (local_bb2_and10_i313 > local_bb2_and12_i314);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u14_stall_local;
wire [31:0] local_bb2_var__u14;

assign local_bb2_var__u14 = rnode_21to22_bb2_c0_ene25_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_cmp_i311_stall_local;
wire local_bb2_cmp_i311;

assign local_bb2_cmp_i311 = (local_bb2_shr_i308 > local_bb2_shr3_i310);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp8_i312_stall_local;
wire local_bb2_cmp8_i312;

assign local_bb2_cmp8_i312 = (local_bb2_shr_i308 == local_bb2_shr3_i310);

// This section implements an unregistered operation.
// 
wire local_bb2_xor_i2_stall_local;
wire [31:0] local_bb2_xor_i2;

assign local_bb2_xor_i2 = (local_bb2_var__u14 ^ 32'h80000000);

// This section implements an unregistered operation.
// 
wire local_bb2___i316_stall_local;
wire local_bb2___i316;

assign local_bb2___i316 = (local_bb2_cmp8_i312 & local_bb2_cmp13_i315);

// This section implements an unregistered operation.
// 
wire local_bb2_and_i3_stall_local;
wire [31:0] local_bb2_and_i3;

assign local_bb2_and_i3 = (local_bb2_xor_i2 >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb2_and10_i9_stall_local;
wire [31:0] local_bb2_and10_i9;

assign local_bb2_and10_i9 = (local_bb2_xor_i2 & 32'hFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2__21_i317_stall_local;
wire local_bb2__21_i317;

assign local_bb2__21_i317 = (local_bb2_cmp_i311 | local_bb2___i316);

// This section implements an unregistered operation.
// 
wire local_bb2_shr_i4_stall_local;
wire [31:0] local_bb2_shr_i4;

assign local_bb2_shr_i4 = (local_bb2_and_i3 & 32'h7FFF);

// This section implements an unregistered operation.
// 
wire local_bb2__22_i318_stall_local;
wire [31:0] local_bb2__22_i318;

assign local_bb2__22_i318 = (local_bb2__21_i317 ? local_bb2_var__u13 : local_bb2_var__u12);

// This section implements an unregistered operation.
// 
wire local_bb2_c0_ene14_valid_out_2;
wire local_bb2_c0_ene14_stall_in_2;
 reg local_bb2_c0_ene14_consumed_2_NO_SHIFT_REG;
wire local_bb2__22_i318_valid_out;
wire local_bb2__22_i318_stall_in;
 reg local_bb2__22_i318_consumed_0_NO_SHIFT_REG;
wire local_bb2__23_i319_valid_out;
wire local_bb2__23_i319_stall_in;
 reg local_bb2__23_i319_consumed_0_NO_SHIFT_REG;
wire local_bb2__23_i319_inputs_ready;
wire local_bb2__23_i319_stall_local;
wire [31:0] local_bb2__23_i319;

assign local_bb2__23_i319_inputs_ready = local_bb2_c0_enter3_c0_eni22_valid_out_0_NO_SHIFT_REG;
assign local_bb2__23_i319 = (local_bb2__21_i317 ? local_bb2_var__u12 : local_bb2_var__u13);
assign local_bb2_c0_ene14_valid_out_2 = 1'b1;
assign local_bb2__22_i318_valid_out = 1'b1;
assign local_bb2__23_i319_valid_out = 1'b1;
assign local_bb2_c0_enter3_c0_eni22_stall_in_0 = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_c0_ene14_consumed_2_NO_SHIFT_REG <= 1'b0;
		local_bb2__22_i318_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2__23_i319_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_c0_ene14_consumed_2_NO_SHIFT_REG <= (local_bb2__23_i319_inputs_ready & (local_bb2_c0_ene14_consumed_2_NO_SHIFT_REG | ~(local_bb2_c0_ene14_stall_in_2)) & local_bb2__23_i319_stall_local);
		local_bb2__22_i318_consumed_0_NO_SHIFT_REG <= (local_bb2__23_i319_inputs_ready & (local_bb2__22_i318_consumed_0_NO_SHIFT_REG | ~(local_bb2__22_i318_stall_in)) & local_bb2__23_i319_stall_local);
		local_bb2__23_i319_consumed_0_NO_SHIFT_REG <= (local_bb2__23_i319_inputs_ready & (local_bb2__23_i319_consumed_0_NO_SHIFT_REG | ~(local_bb2__23_i319_stall_in)) & local_bb2__23_i319_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_4to5_bb2_c0_ene14_0_valid_out_NO_SHIFT_REG;
 logic rnode_4to5_bb2_c0_ene14_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb2_c0_ene14_0_NO_SHIFT_REG;
 logic rnode_4to5_bb2_c0_ene14_0_reg_5_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb2_c0_ene14_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb2_c0_ene14_0_valid_out_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb2_c0_ene14_0_stall_in_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb2_c0_ene14_0_stall_out_reg_5_NO_SHIFT_REG;

acl_data_fifo rnode_4to5_bb2_c0_ene14_0_reg_5_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_4to5_bb2_c0_ene14_0_reg_5_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_4to5_bb2_c0_ene14_0_stall_in_reg_5_NO_SHIFT_REG),
	.valid_out(rnode_4to5_bb2_c0_ene14_0_valid_out_reg_5_NO_SHIFT_REG),
	.stall_out(rnode_4to5_bb2_c0_ene14_0_stall_out_reg_5_NO_SHIFT_REG),
	.data_in(local_bb2_c0_ene14),
	.data_out(rnode_4to5_bb2_c0_ene14_0_reg_5_NO_SHIFT_REG)
);

defparam rnode_4to5_bb2_c0_ene14_0_reg_5_fifo.DEPTH = 1;
defparam rnode_4to5_bb2_c0_ene14_0_reg_5_fifo.DATA_WIDTH = 32;
defparam rnode_4to5_bb2_c0_ene14_0_reg_5_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_4to5_bb2_c0_ene14_0_reg_5_fifo.IMPL = "shift_reg";

assign rnode_4to5_bb2_c0_ene14_0_reg_5_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_c0_ene14_stall_in_2 = 1'b0;
assign rnode_4to5_bb2_c0_ene14_0_NO_SHIFT_REG = rnode_4to5_bb2_c0_ene14_0_reg_5_NO_SHIFT_REG;
assign rnode_4to5_bb2_c0_ene14_0_stall_in_reg_5_NO_SHIFT_REG = 1'b0;
assign rnode_4to5_bb2_c0_ene14_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_4to5_bb2__22_i318_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_4to5_bb2__22_i318_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb2__22_i318_0_NO_SHIFT_REG;
 logic rnode_4to5_bb2__22_i318_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_4to5_bb2__22_i318_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb2__22_i318_1_NO_SHIFT_REG;
 logic rnode_4to5_bb2__22_i318_0_reg_5_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb2__22_i318_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb2__22_i318_0_valid_out_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb2__22_i318_0_stall_in_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb2__22_i318_0_stall_out_reg_5_NO_SHIFT_REG;

acl_data_fifo rnode_4to5_bb2__22_i318_0_reg_5_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_4to5_bb2__22_i318_0_reg_5_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_4to5_bb2__22_i318_0_stall_in_0_reg_5_NO_SHIFT_REG),
	.valid_out(rnode_4to5_bb2__22_i318_0_valid_out_0_reg_5_NO_SHIFT_REG),
	.stall_out(rnode_4to5_bb2__22_i318_0_stall_out_reg_5_NO_SHIFT_REG),
	.data_in(local_bb2__22_i318),
	.data_out(rnode_4to5_bb2__22_i318_0_reg_5_NO_SHIFT_REG)
);

defparam rnode_4to5_bb2__22_i318_0_reg_5_fifo.DEPTH = 1;
defparam rnode_4to5_bb2__22_i318_0_reg_5_fifo.DATA_WIDTH = 32;
defparam rnode_4to5_bb2__22_i318_0_reg_5_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_4to5_bb2__22_i318_0_reg_5_fifo.IMPL = "shift_reg";

assign rnode_4to5_bb2__22_i318_0_reg_5_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__22_i318_stall_in = 1'b0;
assign rnode_4to5_bb2__22_i318_0_stall_in_0_reg_5_NO_SHIFT_REG = 1'b0;
assign rnode_4to5_bb2__22_i318_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_4to5_bb2__22_i318_0_NO_SHIFT_REG = rnode_4to5_bb2__22_i318_0_reg_5_NO_SHIFT_REG;
assign rnode_4to5_bb2__22_i318_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_4to5_bb2__22_i318_1_NO_SHIFT_REG = rnode_4to5_bb2__22_i318_0_reg_5_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_4to5_bb2__23_i319_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_4to5_bb2__23_i319_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb2__23_i319_0_NO_SHIFT_REG;
 logic rnode_4to5_bb2__23_i319_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_4to5_bb2__23_i319_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb2__23_i319_1_NO_SHIFT_REG;
 logic rnode_4to5_bb2__23_i319_0_reg_5_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb2__23_i319_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb2__23_i319_0_valid_out_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb2__23_i319_0_stall_in_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb2__23_i319_0_stall_out_reg_5_NO_SHIFT_REG;

acl_data_fifo rnode_4to5_bb2__23_i319_0_reg_5_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_4to5_bb2__23_i319_0_reg_5_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_4to5_bb2__23_i319_0_stall_in_0_reg_5_NO_SHIFT_REG),
	.valid_out(rnode_4to5_bb2__23_i319_0_valid_out_0_reg_5_NO_SHIFT_REG),
	.stall_out(rnode_4to5_bb2__23_i319_0_stall_out_reg_5_NO_SHIFT_REG),
	.data_in(local_bb2__23_i319),
	.data_out(rnode_4to5_bb2__23_i319_0_reg_5_NO_SHIFT_REG)
);

defparam rnode_4to5_bb2__23_i319_0_reg_5_fifo.DEPTH = 1;
defparam rnode_4to5_bb2__23_i319_0_reg_5_fifo.DATA_WIDTH = 32;
defparam rnode_4to5_bb2__23_i319_0_reg_5_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_4to5_bb2__23_i319_0_reg_5_fifo.IMPL = "shift_reg";

assign rnode_4to5_bb2__23_i319_0_reg_5_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__23_i319_stall_in = 1'b0;
assign rnode_4to5_bb2__23_i319_0_stall_in_0_reg_5_NO_SHIFT_REG = 1'b0;
assign rnode_4to5_bb2__23_i319_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_4to5_bb2__23_i319_0_NO_SHIFT_REG = rnode_4to5_bb2__23_i319_0_reg_5_NO_SHIFT_REG;
assign rnode_4to5_bb2__23_i319_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_4to5_bb2__23_i319_1_NO_SHIFT_REG = rnode_4to5_bb2__23_i319_0_reg_5_NO_SHIFT_REG;

// Register node:
//  * latency = 9
//  * capacity = 9
 logic rnode_5to14_bb2_c0_ene14_0_valid_out_NO_SHIFT_REG;
 logic rnode_5to14_bb2_c0_ene14_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_5to14_bb2_c0_ene14_0_NO_SHIFT_REG;
 logic rnode_5to14_bb2_c0_ene14_0_reg_14_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_5to14_bb2_c0_ene14_0_reg_14_NO_SHIFT_REG;
 logic rnode_5to14_bb2_c0_ene14_0_valid_out_reg_14_NO_SHIFT_REG;
 logic rnode_5to14_bb2_c0_ene14_0_stall_in_reg_14_NO_SHIFT_REG;
 logic rnode_5to14_bb2_c0_ene14_0_stall_out_reg_14_NO_SHIFT_REG;

acl_data_fifo rnode_5to14_bb2_c0_ene14_0_reg_14_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to14_bb2_c0_ene14_0_reg_14_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to14_bb2_c0_ene14_0_stall_in_reg_14_NO_SHIFT_REG),
	.valid_out(rnode_5to14_bb2_c0_ene14_0_valid_out_reg_14_NO_SHIFT_REG),
	.stall_out(rnode_5to14_bb2_c0_ene14_0_stall_out_reg_14_NO_SHIFT_REG),
	.data_in(rnode_4to5_bb2_c0_ene14_0_NO_SHIFT_REG),
	.data_out(rnode_5to14_bb2_c0_ene14_0_reg_14_NO_SHIFT_REG)
);

defparam rnode_5to14_bb2_c0_ene14_0_reg_14_fifo.DEPTH = 9;
defparam rnode_5to14_bb2_c0_ene14_0_reg_14_fifo.DATA_WIDTH = 32;
defparam rnode_5to14_bb2_c0_ene14_0_reg_14_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to14_bb2_c0_ene14_0_reg_14_fifo.IMPL = "shift_reg";

assign rnode_5to14_bb2_c0_ene14_0_reg_14_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_4to5_bb2_c0_ene14_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_5to14_bb2_c0_ene14_0_NO_SHIFT_REG = rnode_5to14_bb2_c0_ene14_0_reg_14_NO_SHIFT_REG;
assign rnode_5to14_bb2_c0_ene14_0_stall_in_reg_14_NO_SHIFT_REG = 1'b0;
assign rnode_5to14_bb2_c0_ene14_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_shr18_i322_stall_local;
wire [31:0] local_bb2_shr18_i322;

assign local_bb2_shr18_i322 = (rnode_4to5_bb2__22_i318_0_NO_SHIFT_REG >> 32'h17);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_5to6_bb2__22_i318_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_5to6_bb2__22_i318_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb2__22_i318_0_NO_SHIFT_REG;
 logic rnode_5to6_bb2__22_i318_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_5to6_bb2__22_i318_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb2__22_i318_1_NO_SHIFT_REG;
 logic rnode_5to6_bb2__22_i318_0_reg_6_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb2__22_i318_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2__22_i318_0_valid_out_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2__22_i318_0_stall_in_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2__22_i318_0_stall_out_reg_6_NO_SHIFT_REG;

acl_data_fifo rnode_5to6_bb2__22_i318_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to6_bb2__22_i318_0_reg_6_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to6_bb2__22_i318_0_stall_in_0_reg_6_NO_SHIFT_REG),
	.valid_out(rnode_5to6_bb2__22_i318_0_valid_out_0_reg_6_NO_SHIFT_REG),
	.stall_out(rnode_5to6_bb2__22_i318_0_stall_out_reg_6_NO_SHIFT_REG),
	.data_in(rnode_4to5_bb2__22_i318_1_NO_SHIFT_REG),
	.data_out(rnode_5to6_bb2__22_i318_0_reg_6_NO_SHIFT_REG)
);

defparam rnode_5to6_bb2__22_i318_0_reg_6_fifo.DEPTH = 1;
defparam rnode_5to6_bb2__22_i318_0_reg_6_fifo.DATA_WIDTH = 32;
defparam rnode_5to6_bb2__22_i318_0_reg_6_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to6_bb2__22_i318_0_reg_6_fifo.IMPL = "shift_reg";

assign rnode_5to6_bb2__22_i318_0_reg_6_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_4to5_bb2__22_i318_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2__22_i318_0_stall_in_0_reg_6_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2__22_i318_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb2__22_i318_0_NO_SHIFT_REG = rnode_5to6_bb2__22_i318_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb2__22_i318_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb2__22_i318_1_NO_SHIFT_REG = rnode_5to6_bb2__22_i318_0_reg_6_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_shr16_i320_stall_local;
wire [31:0] local_bb2_shr16_i320;

assign local_bb2_shr16_i320 = (rnode_4to5_bb2__23_i319_0_NO_SHIFT_REG >> 32'h17);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_5to6_bb2__23_i319_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_5to6_bb2__23_i319_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb2__23_i319_0_NO_SHIFT_REG;
 logic rnode_5to6_bb2__23_i319_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_5to6_bb2__23_i319_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb2__23_i319_1_NO_SHIFT_REG;
 logic rnode_5to6_bb2__23_i319_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_5to6_bb2__23_i319_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb2__23_i319_2_NO_SHIFT_REG;
 logic rnode_5to6_bb2__23_i319_0_reg_6_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb2__23_i319_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2__23_i319_0_valid_out_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2__23_i319_0_stall_in_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2__23_i319_0_stall_out_reg_6_NO_SHIFT_REG;

acl_data_fifo rnode_5to6_bb2__23_i319_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to6_bb2__23_i319_0_reg_6_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to6_bb2__23_i319_0_stall_in_0_reg_6_NO_SHIFT_REG),
	.valid_out(rnode_5to6_bb2__23_i319_0_valid_out_0_reg_6_NO_SHIFT_REG),
	.stall_out(rnode_5to6_bb2__23_i319_0_stall_out_reg_6_NO_SHIFT_REG),
	.data_in(rnode_4to5_bb2__23_i319_1_NO_SHIFT_REG),
	.data_out(rnode_5to6_bb2__23_i319_0_reg_6_NO_SHIFT_REG)
);

defparam rnode_5to6_bb2__23_i319_0_reg_6_fifo.DEPTH = 1;
defparam rnode_5to6_bb2__23_i319_0_reg_6_fifo.DATA_WIDTH = 32;
defparam rnode_5to6_bb2__23_i319_0_reg_6_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to6_bb2__23_i319_0_reg_6_fifo.IMPL = "shift_reg";

assign rnode_5to6_bb2__23_i319_0_reg_6_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_4to5_bb2__23_i319_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2__23_i319_0_stall_in_0_reg_6_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2__23_i319_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb2__23_i319_0_NO_SHIFT_REG = rnode_5to6_bb2__23_i319_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb2__23_i319_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb2__23_i319_1_NO_SHIFT_REG = rnode_5to6_bb2__23_i319_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb2__23_i319_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb2__23_i319_2_NO_SHIFT_REG = rnode_5to6_bb2__23_i319_0_reg_6_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_14to15_bb2_c0_ene14_0_valid_out_NO_SHIFT_REG;
 logic rnode_14to15_bb2_c0_ene14_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_14to15_bb2_c0_ene14_0_NO_SHIFT_REG;
 logic rnode_14to15_bb2_c0_ene14_0_reg_15_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_14to15_bb2_c0_ene14_0_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb2_c0_ene14_0_valid_out_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb2_c0_ene14_0_stall_in_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb2_c0_ene14_0_stall_out_reg_15_NO_SHIFT_REG;

acl_data_fifo rnode_14to15_bb2_c0_ene14_0_reg_15_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_14to15_bb2_c0_ene14_0_reg_15_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_14to15_bb2_c0_ene14_0_stall_in_reg_15_NO_SHIFT_REG),
	.valid_out(rnode_14to15_bb2_c0_ene14_0_valid_out_reg_15_NO_SHIFT_REG),
	.stall_out(rnode_14to15_bb2_c0_ene14_0_stall_out_reg_15_NO_SHIFT_REG),
	.data_in(rnode_5to14_bb2_c0_ene14_0_NO_SHIFT_REG),
	.data_out(rnode_14to15_bb2_c0_ene14_0_reg_15_NO_SHIFT_REG)
);

defparam rnode_14to15_bb2_c0_ene14_0_reg_15_fifo.DEPTH = 1;
defparam rnode_14to15_bb2_c0_ene14_0_reg_15_fifo.DATA_WIDTH = 32;
defparam rnode_14to15_bb2_c0_ene14_0_reg_15_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_14to15_bb2_c0_ene14_0_reg_15_fifo.IMPL = "shift_reg";

assign rnode_14to15_bb2_c0_ene14_0_reg_15_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_5to14_bb2_c0_ene14_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_14to15_bb2_c0_ene14_0_NO_SHIFT_REG = rnode_14to15_bb2_c0_ene14_0_reg_15_NO_SHIFT_REG;
assign rnode_14to15_bb2_c0_ene14_0_stall_in_reg_15_NO_SHIFT_REG = 1'b0;
assign rnode_14to15_bb2_c0_ene14_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_and19_i323_stall_local;
wire [31:0] local_bb2_and19_i323;

assign local_bb2_and19_i323 = (local_bb2_shr18_i322 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and21_i325_stall_local;
wire [31:0] local_bb2_and21_i325;

assign local_bb2_and21_i325 = (rnode_5to6_bb2__22_i318_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_sub_i352_stall_local;
wire [31:0] local_bb2_sub_i352;

assign local_bb2_sub_i352 = (local_bb2_shr16_i320 - local_bb2_shr18_i322);

// This section implements an unregistered operation.
// 
wire local_bb2_and20_i324_stall_local;
wire [31:0] local_bb2_and20_i324;

assign local_bb2_and20_i324 = (rnode_5to6_bb2__23_i319_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and35_i330_valid_out;
wire local_bb2_and35_i330_stall_in;
wire local_bb2_and35_i330_inputs_ready;
wire local_bb2_and35_i330_stall_local;
wire [31:0] local_bb2_and35_i330;

assign local_bb2_and35_i330_inputs_ready = rnode_5to6_bb2__23_i319_0_valid_out_1_NO_SHIFT_REG;
assign local_bb2_and35_i330 = (rnode_5to6_bb2__23_i319_1_NO_SHIFT_REG & 32'h80000000);
assign local_bb2_and35_i330_valid_out = 1'b1;
assign rnode_5to6_bb2__23_i319_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_xor_i331_stall_local;
wire [31:0] local_bb2_xor_i331;

assign local_bb2_xor_i331 = (rnode_5to6_bb2__23_i319_2_NO_SHIFT_REG ^ rnode_5to6_bb2__22_i318_1_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u15_stall_local;
wire [31:0] local_bb2_var__u15;

assign local_bb2_var__u15 = input_wii_div;

// This section implements an unregistered operation.
// 
wire local_bb2_lnot23_i327_stall_local;
wire local_bb2_lnot23_i327;

assign local_bb2_lnot23_i327 = (local_bb2_and19_i323 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp27_i329_stall_local;
wire local_bb2_cmp27_i329;

assign local_bb2_cmp27_i329 = (local_bb2_and19_i323 == 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot33_not_i336_stall_local;
wire local_bb2_lnot33_not_i336;

assign local_bb2_lnot33_not_i336 = (local_bb2_and21_i325 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or64_i349_stall_local;
wire [31:0] local_bb2_or64_i349;

assign local_bb2_or64_i349 = (local_bb2_and21_i325 << 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb2_and68_i353_stall_local;
wire [31:0] local_bb2_and68_i353;

assign local_bb2_and68_i353 = (local_bb2_sub_i352 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot30_i334_stall_local;
wire local_bb2_lnot30_i334;

assign local_bb2_lnot30_i334 = (local_bb2_and20_i324 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or_i346_stall_local;
wire [31:0] local_bb2_or_i346;

assign local_bb2_or_i346 = (local_bb2_and20_i324 << 32'h3);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb2_and35_i330_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb2_and35_i330_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb2_and35_i330_0_NO_SHIFT_REG;
 logic rnode_6to7_bb2_and35_i330_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb2_and35_i330_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb2_and35_i330_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb2_and35_i330_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb2_and35_i330_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb2_and35_i330_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb2_and35_i330_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb2_and35_i330_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb2_and35_i330_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb2_and35_i330_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in(local_bb2_and35_i330),
	.data_out(rnode_6to7_bb2_and35_i330_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb2_and35_i330_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb2_and35_i330_0_reg_7_fifo.DATA_WIDTH = 32;
defparam rnode_6to7_bb2_and35_i330_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb2_and35_i330_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb2_and35_i330_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and35_i330_stall_in = 1'b0;
assign rnode_6to7_bb2_and35_i330_0_NO_SHIFT_REG = rnode_6to7_bb2_and35_i330_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb2_and35_i330_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb2_and35_i330_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_cmp37_i332_stall_local;
wire local_bb2_cmp37_i332;

assign local_bb2_cmp37_i332 = ($signed(local_bb2_xor_i331) < $signed(32'h0));

// This section implements an unregistered operation.
// 
wire local_bb2_xor_lobit_i405_stall_local;
wire [31:0] local_bb2_xor_lobit_i405;

assign local_bb2_xor_lobit_i405 = ($signed(local_bb2_xor_i331) >>> 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb2_and36_lobit_i407_stall_local;
wire [31:0] local_bb2_and36_lobit_i407;

assign local_bb2_and36_lobit_i407 = (local_bb2_xor_i331 >> 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb2_and_i98_stall_local;
wire [31:0] local_bb2_and_i98;

assign local_bb2_and_i98 = (local_bb2_var__u15 >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb2_and10_i104_stall_local;
wire [31:0] local_bb2_and10_i104;

assign local_bb2_and10_i104 = (local_bb2_var__u15 & 32'hFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_shl65_i350_stall_local;
wire [31:0] local_bb2_shl65_i350;

assign local_bb2_shl65_i350 = (local_bb2_or64_i349 | 32'h4000000);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp69_i354_stall_local;
wire local_bb2_cmp69_i354;

assign local_bb2_cmp69_i354 = (local_bb2_and68_i353 > 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot30_not_i338_stall_local;
wire local_bb2_lnot30_not_i338;

assign local_bb2_lnot30_not_i338 = (local_bb2_lnot30_i334 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_shl_i347_stall_local;
wire [31:0] local_bb2_shl_i347;

assign local_bb2_shl_i347 = (local_bb2_or_i346 | 32'h4000000);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb2_and35_i330_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and35_i330_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb2_and35_i330_0_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and35_i330_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb2_and35_i330_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and35_i330_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and35_i330_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and35_i330_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb2_and35_i330_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb2_and35_i330_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb2_and35_i330_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb2_and35_i330_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb2_and35_i330_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(rnode_6to7_bb2_and35_i330_0_NO_SHIFT_REG),
	.data_out(rnode_7to8_bb2_and35_i330_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb2_and35_i330_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb2_and35_i330_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb2_and35_i330_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb2_and35_i330_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb2_and35_i330_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb2_and35_i330_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2_and35_i330_0_NO_SHIFT_REG = rnode_7to8_bb2_and35_i330_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb2_and35_i330_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2_and35_i330_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_shr_i99_stall_local;
wire [31:0] local_bb2_shr_i99;

assign local_bb2_shr_i99 = (local_bb2_and_i98 & 32'h7FFF);

// This section implements an unregistered operation.
// 
wire local_bb2_shr16_i320_valid_out_1;
wire local_bb2_shr16_i320_stall_in_1;
 reg local_bb2_shr16_i320_consumed_1_NO_SHIFT_REG;
wire local_bb2_lnot23_i327_valid_out;
wire local_bb2_lnot23_i327_stall_in;
 reg local_bb2_lnot23_i327_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp27_i329_valid_out;
wire local_bb2_cmp27_i329_stall_in;
 reg local_bb2_cmp27_i329_consumed_0_NO_SHIFT_REG;
wire local_bb2_align_0_i355_valid_out;
wire local_bb2_align_0_i355_stall_in;
 reg local_bb2_align_0_i355_consumed_0_NO_SHIFT_REG;
wire local_bb2_align_0_i355_inputs_ready;
wire local_bb2_align_0_i355_stall_local;
wire [31:0] local_bb2_align_0_i355;

assign local_bb2_align_0_i355_inputs_ready = (rnode_4to5_bb2__22_i318_0_valid_out_0_NO_SHIFT_REG & rnode_4to5_bb2__23_i319_0_valid_out_0_NO_SHIFT_REG);
assign local_bb2_align_0_i355 = (local_bb2_cmp69_i354 ? 32'h1F : local_bb2_and68_i353);
assign local_bb2_shr16_i320_valid_out_1 = 1'b1;
assign local_bb2_lnot23_i327_valid_out = 1'b1;
assign local_bb2_cmp27_i329_valid_out = 1'b1;
assign local_bb2_align_0_i355_valid_out = 1'b1;
assign rnode_4to5_bb2__22_i318_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_4to5_bb2__23_i319_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_shr16_i320_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb2_lnot23_i327_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp27_i329_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_align_0_i355_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_shr16_i320_consumed_1_NO_SHIFT_REG <= (local_bb2_align_0_i355_inputs_ready & (local_bb2_shr16_i320_consumed_1_NO_SHIFT_REG | ~(local_bb2_shr16_i320_stall_in_1)) & local_bb2_align_0_i355_stall_local);
		local_bb2_lnot23_i327_consumed_0_NO_SHIFT_REG <= (local_bb2_align_0_i355_inputs_ready & (local_bb2_lnot23_i327_consumed_0_NO_SHIFT_REG | ~(local_bb2_lnot23_i327_stall_in)) & local_bb2_align_0_i355_stall_local);
		local_bb2_cmp27_i329_consumed_0_NO_SHIFT_REG <= (local_bb2_align_0_i355_inputs_ready & (local_bb2_cmp27_i329_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp27_i329_stall_in)) & local_bb2_align_0_i355_stall_local);
		local_bb2_align_0_i355_consumed_0_NO_SHIFT_REG <= (local_bb2_align_0_i355_inputs_ready & (local_bb2_align_0_i355_consumed_0_NO_SHIFT_REG | ~(local_bb2_align_0_i355_stall_in)) & local_bb2_align_0_i355_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb2_and35_i330_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb2_and35_i330_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb2_and35_i330_0_NO_SHIFT_REG;
 logic rnode_8to9_bb2_and35_i330_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb2_and35_i330_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_and35_i330_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_and35_i330_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_and35_i330_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb2_and35_i330_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb2_and35_i330_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb2_and35_i330_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb2_and35_i330_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb2_and35_i330_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(rnode_7to8_bb2_and35_i330_0_NO_SHIFT_REG),
	.data_out(rnode_8to9_bb2_and35_i330_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb2_and35_i330_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb2_and35_i330_0_reg_9_fifo.DATA_WIDTH = 32;
defparam rnode_8to9_bb2_and35_i330_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb2_and35_i330_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb2_and35_i330_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb2_and35_i330_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_and35_i330_0_NO_SHIFT_REG = rnode_8to9_bb2_and35_i330_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb2_and35_i330_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_and35_i330_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_5to6_bb2_shr16_i320_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_5to6_bb2_shr16_i320_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb2_shr16_i320_0_NO_SHIFT_REG;
 logic rnode_5to6_bb2_shr16_i320_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_5to6_bb2_shr16_i320_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb2_shr16_i320_1_NO_SHIFT_REG;
 logic rnode_5to6_bb2_shr16_i320_0_reg_6_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb2_shr16_i320_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2_shr16_i320_0_valid_out_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2_shr16_i320_0_stall_in_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2_shr16_i320_0_stall_out_reg_6_NO_SHIFT_REG;

acl_data_fifo rnode_5to6_bb2_shr16_i320_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to6_bb2_shr16_i320_0_reg_6_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to6_bb2_shr16_i320_0_stall_in_0_reg_6_NO_SHIFT_REG),
	.valid_out(rnode_5to6_bb2_shr16_i320_0_valid_out_0_reg_6_NO_SHIFT_REG),
	.stall_out(rnode_5to6_bb2_shr16_i320_0_stall_out_reg_6_NO_SHIFT_REG),
	.data_in(local_bb2_shr16_i320),
	.data_out(rnode_5to6_bb2_shr16_i320_0_reg_6_NO_SHIFT_REG)
);

defparam rnode_5to6_bb2_shr16_i320_0_reg_6_fifo.DEPTH = 1;
defparam rnode_5to6_bb2_shr16_i320_0_reg_6_fifo.DATA_WIDTH = 32;
defparam rnode_5to6_bb2_shr16_i320_0_reg_6_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to6_bb2_shr16_i320_0_reg_6_fifo.IMPL = "shift_reg";

assign rnode_5to6_bb2_shr16_i320_0_reg_6_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_shr16_i320_stall_in_1 = 1'b0;
assign rnode_5to6_bb2_shr16_i320_0_stall_in_0_reg_6_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2_shr16_i320_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb2_shr16_i320_0_NO_SHIFT_REG = rnode_5to6_bb2_shr16_i320_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb2_shr16_i320_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb2_shr16_i320_1_NO_SHIFT_REG = rnode_5to6_bb2_shr16_i320_0_reg_6_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_5to6_bb2_lnot23_i327_0_valid_out_NO_SHIFT_REG;
 logic rnode_5to6_bb2_lnot23_i327_0_stall_in_NO_SHIFT_REG;
 logic rnode_5to6_bb2_lnot23_i327_0_NO_SHIFT_REG;
 logic rnode_5to6_bb2_lnot23_i327_0_reg_6_inputs_ready_NO_SHIFT_REG;
 logic rnode_5to6_bb2_lnot23_i327_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2_lnot23_i327_0_valid_out_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2_lnot23_i327_0_stall_in_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2_lnot23_i327_0_stall_out_reg_6_NO_SHIFT_REG;

acl_data_fifo rnode_5to6_bb2_lnot23_i327_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to6_bb2_lnot23_i327_0_reg_6_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to6_bb2_lnot23_i327_0_stall_in_reg_6_NO_SHIFT_REG),
	.valid_out(rnode_5to6_bb2_lnot23_i327_0_valid_out_reg_6_NO_SHIFT_REG),
	.stall_out(rnode_5to6_bb2_lnot23_i327_0_stall_out_reg_6_NO_SHIFT_REG),
	.data_in(local_bb2_lnot23_i327),
	.data_out(rnode_5to6_bb2_lnot23_i327_0_reg_6_NO_SHIFT_REG)
);

defparam rnode_5to6_bb2_lnot23_i327_0_reg_6_fifo.DEPTH = 1;
defparam rnode_5to6_bb2_lnot23_i327_0_reg_6_fifo.DATA_WIDTH = 1;
defparam rnode_5to6_bb2_lnot23_i327_0_reg_6_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to6_bb2_lnot23_i327_0_reg_6_fifo.IMPL = "shift_reg";

assign rnode_5to6_bb2_lnot23_i327_0_reg_6_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_lnot23_i327_stall_in = 1'b0;
assign rnode_5to6_bb2_lnot23_i327_0_NO_SHIFT_REG = rnode_5to6_bb2_lnot23_i327_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb2_lnot23_i327_0_stall_in_reg_6_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2_lnot23_i327_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_5to6_bb2_cmp27_i329_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_5to6_bb2_cmp27_i329_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_5to6_bb2_cmp27_i329_0_NO_SHIFT_REG;
 logic rnode_5to6_bb2_cmp27_i329_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_5to6_bb2_cmp27_i329_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_5to6_bb2_cmp27_i329_1_NO_SHIFT_REG;
 logic rnode_5to6_bb2_cmp27_i329_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_5to6_bb2_cmp27_i329_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_5to6_bb2_cmp27_i329_2_NO_SHIFT_REG;
 logic rnode_5to6_bb2_cmp27_i329_0_reg_6_inputs_ready_NO_SHIFT_REG;
 logic rnode_5to6_bb2_cmp27_i329_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2_cmp27_i329_0_valid_out_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2_cmp27_i329_0_stall_in_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2_cmp27_i329_0_stall_out_reg_6_NO_SHIFT_REG;

acl_data_fifo rnode_5to6_bb2_cmp27_i329_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to6_bb2_cmp27_i329_0_reg_6_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to6_bb2_cmp27_i329_0_stall_in_0_reg_6_NO_SHIFT_REG),
	.valid_out(rnode_5to6_bb2_cmp27_i329_0_valid_out_0_reg_6_NO_SHIFT_REG),
	.stall_out(rnode_5to6_bb2_cmp27_i329_0_stall_out_reg_6_NO_SHIFT_REG),
	.data_in(local_bb2_cmp27_i329),
	.data_out(rnode_5to6_bb2_cmp27_i329_0_reg_6_NO_SHIFT_REG)
);

defparam rnode_5to6_bb2_cmp27_i329_0_reg_6_fifo.DEPTH = 1;
defparam rnode_5to6_bb2_cmp27_i329_0_reg_6_fifo.DATA_WIDTH = 1;
defparam rnode_5to6_bb2_cmp27_i329_0_reg_6_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to6_bb2_cmp27_i329_0_reg_6_fifo.IMPL = "shift_reg";

assign rnode_5to6_bb2_cmp27_i329_0_reg_6_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp27_i329_stall_in = 1'b0;
assign rnode_5to6_bb2_cmp27_i329_0_stall_in_0_reg_6_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2_cmp27_i329_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb2_cmp27_i329_0_NO_SHIFT_REG = rnode_5to6_bb2_cmp27_i329_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb2_cmp27_i329_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb2_cmp27_i329_1_NO_SHIFT_REG = rnode_5to6_bb2_cmp27_i329_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb2_cmp27_i329_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb2_cmp27_i329_2_NO_SHIFT_REG = rnode_5to6_bb2_cmp27_i329_0_reg_6_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_5to6_bb2_align_0_i355_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_5to6_bb2_align_0_i355_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb2_align_0_i355_0_NO_SHIFT_REG;
 logic rnode_5to6_bb2_align_0_i355_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_5to6_bb2_align_0_i355_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb2_align_0_i355_1_NO_SHIFT_REG;
 logic rnode_5to6_bb2_align_0_i355_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_5to6_bb2_align_0_i355_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb2_align_0_i355_2_NO_SHIFT_REG;
 logic rnode_5to6_bb2_align_0_i355_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_5to6_bb2_align_0_i355_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb2_align_0_i355_3_NO_SHIFT_REG;
 logic rnode_5to6_bb2_align_0_i355_0_valid_out_4_NO_SHIFT_REG;
 logic rnode_5to6_bb2_align_0_i355_0_stall_in_4_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb2_align_0_i355_4_NO_SHIFT_REG;
 logic rnode_5to6_bb2_align_0_i355_0_reg_6_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_5to6_bb2_align_0_i355_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2_align_0_i355_0_valid_out_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2_align_0_i355_0_stall_in_0_reg_6_NO_SHIFT_REG;
 logic rnode_5to6_bb2_align_0_i355_0_stall_out_reg_6_NO_SHIFT_REG;

acl_data_fifo rnode_5to6_bb2_align_0_i355_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to6_bb2_align_0_i355_0_reg_6_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to6_bb2_align_0_i355_0_stall_in_0_reg_6_NO_SHIFT_REG),
	.valid_out(rnode_5to6_bb2_align_0_i355_0_valid_out_0_reg_6_NO_SHIFT_REG),
	.stall_out(rnode_5to6_bb2_align_0_i355_0_stall_out_reg_6_NO_SHIFT_REG),
	.data_in(local_bb2_align_0_i355),
	.data_out(rnode_5to6_bb2_align_0_i355_0_reg_6_NO_SHIFT_REG)
);

defparam rnode_5to6_bb2_align_0_i355_0_reg_6_fifo.DEPTH = 1;
defparam rnode_5to6_bb2_align_0_i355_0_reg_6_fifo.DATA_WIDTH = 32;
defparam rnode_5to6_bb2_align_0_i355_0_reg_6_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to6_bb2_align_0_i355_0_reg_6_fifo.IMPL = "shift_reg";

assign rnode_5to6_bb2_align_0_i355_0_reg_6_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_align_0_i355_stall_in = 1'b0;
assign rnode_5to6_bb2_align_0_i355_0_stall_in_0_reg_6_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2_align_0_i355_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb2_align_0_i355_0_NO_SHIFT_REG = rnode_5to6_bb2_align_0_i355_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb2_align_0_i355_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb2_align_0_i355_1_NO_SHIFT_REG = rnode_5to6_bb2_align_0_i355_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb2_align_0_i355_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb2_align_0_i355_2_NO_SHIFT_REG = rnode_5to6_bb2_align_0_i355_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb2_align_0_i355_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb2_align_0_i355_3_NO_SHIFT_REG = rnode_5to6_bb2_align_0_i355_0_reg_6_NO_SHIFT_REG;
assign rnode_5to6_bb2_align_0_i355_0_valid_out_4_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb2_align_0_i355_4_NO_SHIFT_REG = rnode_5to6_bb2_align_0_i355_0_reg_6_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_and17_i321_stall_local;
wire [31:0] local_bb2_and17_i321;

assign local_bb2_and17_i321 = (rnode_5to6_bb2_shr16_i320_0_NO_SHIFT_REG & 32'hFF);

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_6to8_bb2_shr16_i320_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to8_bb2_shr16_i320_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_6to8_bb2_shr16_i320_0_NO_SHIFT_REG;
 logic rnode_6to8_bb2_shr16_i320_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to8_bb2_shr16_i320_0_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb2_shr16_i320_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb2_shr16_i320_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb2_shr16_i320_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_6to8_bb2_shr16_i320_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to8_bb2_shr16_i320_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to8_bb2_shr16_i320_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_6to8_bb2_shr16_i320_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_6to8_bb2_shr16_i320_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(rnode_5to6_bb2_shr16_i320_1_NO_SHIFT_REG),
	.data_out(rnode_6to8_bb2_shr16_i320_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_6to8_bb2_shr16_i320_0_reg_8_fifo.DEPTH = 2;
defparam rnode_6to8_bb2_shr16_i320_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_6to8_bb2_shr16_i320_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to8_bb2_shr16_i320_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_6to8_bb2_shr16_i320_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_5to6_bb2_shr16_i320_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_6to8_bb2_shr16_i320_0_NO_SHIFT_REG = rnode_6to8_bb2_shr16_i320_0_reg_8_NO_SHIFT_REG;
assign rnode_6to8_bb2_shr16_i320_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_6to8_bb2_shr16_i320_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2__28_i351_stall_local;
wire [31:0] local_bb2__28_i351;

assign local_bb2__28_i351 = (rnode_5to6_bb2_lnot23_i327_0_NO_SHIFT_REG ? 32'h0 : local_bb2_shl65_i350);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge_not_i337_stall_local;
wire local_bb2_brmerge_not_i337;

assign local_bb2_brmerge_not_i337 = (rnode_5to6_bb2_cmp27_i329_0_NO_SHIFT_REG & local_bb2_lnot33_not_i336);

// This section implements an unregistered operation.
// 
wire local_bb2_and93_i363_stall_local;
wire [31:0] local_bb2_and93_i363;

assign local_bb2_and93_i363 = (rnode_5to6_bb2_align_0_i355_0_NO_SHIFT_REG & 32'h1C);

// This section implements an unregistered operation.
// 
wire local_bb2_and95_i365_stall_local;
wire [31:0] local_bb2_and95_i365;

assign local_bb2_and95_i365 = (rnode_5to6_bb2_align_0_i355_1_NO_SHIFT_REG & 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb2_and115_i381_stall_local;
wire [31:0] local_bb2_and115_i381;

assign local_bb2_and115_i381 = (rnode_5to6_bb2_align_0_i355_2_NO_SHIFT_REG & 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb2_and130_i387_stall_local;
wire [31:0] local_bb2_and130_i387;

assign local_bb2_and130_i387 = (rnode_5to6_bb2_align_0_i355_3_NO_SHIFT_REG & 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb2_and149_i392_stall_local;
wire [31:0] local_bb2_and149_i392;

assign local_bb2_and149_i392 = (rnode_5to6_bb2_align_0_i355_4_NO_SHIFT_REG & 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_i326_stall_local;
wire local_bb2_lnot_i326;

assign local_bb2_lnot_i326 = (local_bb2_and17_i321 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp25_i328_stall_local;
wire local_bb2_cmp25_i328;

assign local_bb2_cmp25_i328 = (local_bb2_and17_i321 == 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and72_i356_stall_local;
wire [31:0] local_bb2_and72_i356;

assign local_bb2_and72_i356 = (local_bb2__28_i351 >> 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb2_and75_i359_stall_local;
wire [31:0] local_bb2_and75_i359;

assign local_bb2_and75_i359 = (local_bb2__28_i351 & 32'hF0);

// This section implements an unregistered operation.
// 
wire local_bb2_and78_i361_stall_local;
wire [31:0] local_bb2_and78_i361;

assign local_bb2_and78_i361 = (local_bb2__28_i351 & 32'hF00);

// This section implements an unregistered operation.
// 
wire local_bb2_and90_i367_stall_local;
wire [31:0] local_bb2_and90_i367;

assign local_bb2_and90_i367 = (local_bb2__28_i351 & 32'h7000000);

// This section implements an unregistered operation.
// 
wire local_bb2_and87_i368_stall_local;
wire [31:0] local_bb2_and87_i368;

assign local_bb2_and87_i368 = (local_bb2__28_i351 & 32'hF00000);

// This section implements an unregistered operation.
// 
wire local_bb2_and84_i369_stall_local;
wire [31:0] local_bb2_and84_i369;

assign local_bb2_and84_i369 = (local_bb2__28_i351 & 32'hF0000);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u16_stall_local;
wire [31:0] local_bb2_var__u16;

assign local_bb2_var__u16 = (local_bb2__28_i351 & 32'hFFF8);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge_not_not_i341_stall_local;
wire local_bb2_brmerge_not_not_i341;

assign local_bb2_brmerge_not_not_i341 = (local_bb2_brmerge_not_i337 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_shr94_i364_stall_local;
wire [31:0] local_bb2_shr94_i364;

assign local_bb2_shr94_i364 = (local_bb2__28_i351 >> local_bb2_and93_i363);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp96_i366_stall_local;
wire local_bb2_cmp96_i366;

assign local_bb2_cmp96_i366 = (local_bb2_and95_i365 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp116_i382_stall_local;
wire local_bb2_cmp116_i382;

assign local_bb2_cmp116_i382 = (local_bb2_and115_i381 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp131_not_i389_stall_local;
wire local_bb2_cmp131_not_i389;

assign local_bb2_cmp131_not_i389 = (local_bb2_and130_i387 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_Pivot20_i394_stall_local;
wire local_bb2_Pivot20_i394;

assign local_bb2_Pivot20_i394 = (local_bb2_and149_i392 < 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb2_SwitchLeaf_i395_stall_local;
wire local_bb2_SwitchLeaf_i395;

assign local_bb2_SwitchLeaf_i395 = (local_bb2_and149_i392 == 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2__27_i348_stall_local;
wire [31:0] local_bb2__27_i348;

assign local_bb2__27_i348 = (local_bb2_lnot_i326 ? 32'h0 : local_bb2_shl_i347);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp25_not_i333_stall_local;
wire local_bb2_cmp25_not_i333;

assign local_bb2_cmp25_not_i333 = (local_bb2_cmp25_i328 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_or_cond_not_i339_stall_local;
wire local_bb2_or_cond_not_i339;

assign local_bb2_or_cond_not_i339 = (local_bb2_cmp25_i328 & local_bb2_lnot30_not_i338);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u17_stall_local;
wire local_bb2_var__u17;

assign local_bb2_var__u17 = (local_bb2_cmp25_i328 | rnode_5to6_bb2_cmp27_i329_2_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_and72_tr_i357_stall_local;
wire [7:0] local_bb2_and72_tr_i357;

assign local_bb2_and72_tr_i357 = local_bb2_and72_i356[7:0];

// This section implements an unregistered operation.
// 
wire local_bb2_cmp76_i360_stall_local;
wire local_bb2_cmp76_i360;

assign local_bb2_cmp76_i360 = (local_bb2_and75_i359 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp79_i362_stall_local;
wire local_bb2_cmp79_i362;

assign local_bb2_cmp79_i362 = (local_bb2_and78_i361 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp91_i370_stall_local;
wire local_bb2_cmp91_i370;

assign local_bb2_cmp91_i370 = (local_bb2_and90_i367 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp88_i371_stall_local;
wire local_bb2_cmp88_i371;

assign local_bb2_cmp88_i371 = (local_bb2_and87_i368 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp85_i372_stall_local;
wire local_bb2_cmp85_i372;

assign local_bb2_cmp85_i372 = (local_bb2_and84_i369 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u18_stall_local;
wire local_bb2_var__u18;

assign local_bb2_var__u18 = (local_bb2_var__u16 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_7_i342_stall_local;
wire local_bb2_reduction_7_i342;

assign local_bb2_reduction_7_i342 = (local_bb2_cmp25_i328 & local_bb2_brmerge_not_not_i341);

// This section implements an unregistered operation.
// 
wire local_bb2_and142_i391_stall_local;
wire [31:0] local_bb2_and142_i391;

assign local_bb2_and142_i391 = (local_bb2_shr94_i364 >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_shr150_i393_stall_local;
wire [31:0] local_bb2_shr150_i393;

assign local_bb2_shr150_i393 = (local_bb2_shr94_i364 >> local_bb2_and149_i392);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u19_stall_local;
wire [31:0] local_bb2_var__u19;

assign local_bb2_var__u19 = (local_bb2_shr94_i364 & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_and146_i396_stall_local;
wire [31:0] local_bb2_and146_i396;

assign local_bb2_and146_i396 = (local_bb2_shr94_i364 >> 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb2_add_i408_stall_local;
wire [31:0] local_bb2_add_i408;

assign local_bb2_add_i408 = (local_bb2__27_i348 | local_bb2_and36_lobit_i407);

// This section implements an unregistered operation.
// 
wire local_bb2_or_cond_i335_stall_local;
wire local_bb2_or_cond_i335;

assign local_bb2_or_cond_i335 = (local_bb2_lnot30_i334 | local_bb2_cmp25_not_i333);

// This section implements an unregistered operation.
// 
wire local_bb2__24_i340_stall_local;
wire local_bb2__24_i340;

assign local_bb2__24_i340 = (local_bb2_or_cond_not_i339 | local_bb2_brmerge_not_i337);

// This section implements an unregistered operation.
// 
wire local_bb2_frombool74_i358_stall_local;
wire [7:0] local_bb2_frombool74_i358;

assign local_bb2_frombool74_i358 = (local_bb2_and72_tr_i357 & 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb2__31_v_i378_stall_local;
wire local_bb2__31_v_i378;

assign local_bb2__31_v_i378 = (local_bb2_cmp96_i366 ? local_bb2_cmp79_i362 : local_bb2_cmp91_i370);

// This section implements an unregistered operation.
// 
wire local_bb2__30_v_i376_stall_local;
wire local_bb2__30_v_i376;

assign local_bb2__30_v_i376 = (local_bb2_cmp96_i366 ? local_bb2_cmp76_i360 : local_bb2_cmp88_i371);

// This section implements an unregistered operation.
// 
wire local_bb2_frombool109_i374_stall_local;
wire [7:0] local_bb2_frombool109_i374;

assign local_bb2_frombool109_i374[7:1] = 7'h0;
assign local_bb2_frombool109_i374[0] = local_bb2_cmp85_i372;

// This section implements an unregistered operation.
// 
wire local_bb2_or107_i373_stall_local;
wire [31:0] local_bb2_or107_i373;

assign local_bb2_or107_i373[31:1] = 31'h0;
assign local_bb2_or107_i373[0] = local_bb2_var__u18;

// This section implements an unregistered operation.
// 
wire local_bb2_var__u20_stall_local;
wire [31:0] local_bb2_var__u20;

assign local_bb2_var__u20 = (local_bb2_and146_i396 | local_bb2_shr94_i364);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_8_i343_stall_local;
wire local_bb2_reduction_8_i343;

assign local_bb2_reduction_8_i343 = (rnode_5to6_bb2_cmp27_i329_1_NO_SHIFT_REG & local_bb2_or_cond_i335);

// This section implements an unregistered operation.
// 
wire local_bb2__31_i379_stall_local;
wire [7:0] local_bb2__31_i379;

assign local_bb2__31_i379[7:1] = 7'h0;
assign local_bb2__31_i379[0] = local_bb2__31_v_i378;

// This section implements an unregistered operation.
// 
wire local_bb2__30_i377_stall_local;
wire [7:0] local_bb2__30_i377;

assign local_bb2__30_i377[7:1] = 7'h0;
assign local_bb2__30_i377[0] = local_bb2__30_v_i376;

// This section implements an unregistered operation.
// 
wire local_bb2__29_i375_stall_local;
wire [7:0] local_bb2__29_i375;

assign local_bb2__29_i375 = (local_bb2_cmp96_i366 ? local_bb2_frombool74_i358 : local_bb2_frombool109_i374);

// This section implements an unregistered operation.
// 
wire local_bb2__32_i380_stall_local;
wire [31:0] local_bb2__32_i380;

assign local_bb2__32_i380 = (local_bb2_cmp96_i366 ? 32'h0 : local_bb2_or107_i373);

// This section implements an unregistered operation.
// 
wire local_bb2_or1596_i397_stall_local;
wire [31:0] local_bb2_or1596_i397;

assign local_bb2_or1596_i397 = (local_bb2_var__u20 | local_bb2_and142_i391);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_9_i344_stall_local;
wire local_bb2_reduction_9_i344;

assign local_bb2_reduction_9_i344 = (local_bb2_reduction_7_i342 & local_bb2_reduction_8_i343);

// This section implements an unregistered operation.
// 
wire local_bb2_or1237_i383_stall_local;
wire [7:0] local_bb2_or1237_i383;

assign local_bb2_or1237_i383 = (local_bb2__30_i377 | local_bb2__29_i375);

// This section implements an unregistered operation.
// 
wire local_bb2__33_i385_stall_local;
wire [7:0] local_bb2__33_i385;

assign local_bb2__33_i385 = (local_bb2_cmp116_i382 ? local_bb2__29_i375 : local_bb2__31_i379);

// This section implements an unregistered operation.
// 
wire local_bb2_or162_i398_stall_local;
wire [31:0] local_bb2_or162_i398;

assign local_bb2_or162_i398 = (local_bb2_or1596_i397 & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2__26_i345_stall_local;
wire local_bb2__26_i345;

assign local_bb2__26_i345 = (local_bb2_reduction_9_i344 ? local_bb2_cmp37_i332 : local_bb2__24_i340);

// This section implements an unregistered operation.
// 
wire local_bb2_or123_i384_stall_local;
wire [31:0] local_bb2_or123_i384;

assign local_bb2_or123_i384[31:8] = 24'h0;
assign local_bb2_or123_i384[7:0] = local_bb2_or1237_i383;

// This section implements an unregistered operation.
// 
wire local_bb2_var__u21_stall_local;
wire [7:0] local_bb2_var__u21;

assign local_bb2_var__u21 = (local_bb2__33_i385 & 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb2__37_v_i399_stall_local;
wire [31:0] local_bb2__37_v_i399;

assign local_bb2__37_v_i399 = (local_bb2_Pivot20_i394 ? 32'h0 : local_bb2_or162_i398);

// This section implements an unregistered operation.
// 
wire local_bb2_or124_i386_stall_local;
wire [31:0] local_bb2_or124_i386;

assign local_bb2_or124_i386 = (local_bb2_cmp116_i382 ? 32'h0 : local_bb2_or123_i384);

// This section implements an unregistered operation.
// 
wire local_bb2_conv135_i388_stall_local;
wire [31:0] local_bb2_conv135_i388;

assign local_bb2_conv135_i388[31:8] = 24'h0;
assign local_bb2_conv135_i388[7:0] = local_bb2_var__u21;

// This section implements an unregistered operation.
// 
wire local_bb2__39_v_i400_stall_local;
wire [31:0] local_bb2__39_v_i400;

assign local_bb2__39_v_i400 = (local_bb2_SwitchLeaf_i395 ? local_bb2_var__u19 : local_bb2__37_v_i399);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_3_i401_stall_local;
wire [31:0] local_bb2_reduction_3_i401;

assign local_bb2_reduction_3_i401 = (local_bb2__32_i380 | local_bb2_or124_i386);

// This section implements an unregistered operation.
// 
wire local_bb2_or136_i390_stall_local;
wire [31:0] local_bb2_or136_i390;

assign local_bb2_or136_i390 = (local_bb2_cmp131_not_i389 ? local_bb2_conv135_i388 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_5_i403_stall_local;
wire [31:0] local_bb2_reduction_5_i403;

assign local_bb2_reduction_5_i403 = (local_bb2_shr150_i393 | local_bb2_reduction_3_i401);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_4_i402_stall_local;
wire [31:0] local_bb2_reduction_4_i402;

assign local_bb2_reduction_4_i402 = (local_bb2_or136_i390 | local_bb2__39_v_i400);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_6_i404_stall_local;
wire [31:0] local_bb2_reduction_6_i404;

assign local_bb2_reduction_6_i404 = (local_bb2_reduction_4_i402 | local_bb2_reduction_5_i403);

// This section implements an unregistered operation.
// 
wire local_bb2_xor188_i406_stall_local;
wire [31:0] local_bb2_xor188_i406;

assign local_bb2_xor188_i406 = (local_bb2_reduction_6_i404 ^ local_bb2_xor_lobit_i405);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp37_i332_valid_out_1;
wire local_bb2_cmp37_i332_stall_in_1;
 reg local_bb2_cmp37_i332_consumed_1_NO_SHIFT_REG;
wire local_bb2__26_i345_valid_out;
wire local_bb2__26_i345_stall_in;
 reg local_bb2__26_i345_consumed_0_NO_SHIFT_REG;
wire local_bb2_add192_i409_valid_out;
wire local_bb2_add192_i409_stall_in;
 reg local_bb2_add192_i409_consumed_0_NO_SHIFT_REG;
wire local_bb2_and17_i321_valid_out_2;
wire local_bb2_and17_i321_stall_in_2;
 reg local_bb2_and17_i321_consumed_2_NO_SHIFT_REG;
wire local_bb2_var__u17_valid_out;
wire local_bb2_var__u17_stall_in;
 reg local_bb2_var__u17_consumed_0_NO_SHIFT_REG;
wire local_bb2_add192_i409_inputs_ready;
wire local_bb2_add192_i409_stall_local;
wire [31:0] local_bb2_add192_i409;

assign local_bb2_add192_i409_inputs_ready = (rnode_5to6_bb2__22_i318_0_valid_out_0_NO_SHIFT_REG & rnode_5to6_bb2_cmp27_i329_0_valid_out_0_NO_SHIFT_REG & rnode_5to6_bb2_lnot23_i327_0_valid_out_NO_SHIFT_REG & rnode_5to6_bb2__22_i318_0_valid_out_1_NO_SHIFT_REG & rnode_5to6_bb2__23_i319_0_valid_out_2_NO_SHIFT_REG & rnode_5to6_bb2__23_i319_0_valid_out_0_NO_SHIFT_REG & rnode_5to6_bb2_cmp27_i329_0_valid_out_1_NO_SHIFT_REG & rnode_5to6_bb2_shr16_i320_0_valid_out_0_NO_SHIFT_REG & rnode_5to6_bb2_cmp27_i329_0_valid_out_2_NO_SHIFT_REG & rnode_5to6_bb2_align_0_i355_0_valid_out_0_NO_SHIFT_REG & rnode_5to6_bb2_align_0_i355_0_valid_out_4_NO_SHIFT_REG & rnode_5to6_bb2_align_0_i355_0_valid_out_1_NO_SHIFT_REG & rnode_5to6_bb2_align_0_i355_0_valid_out_2_NO_SHIFT_REG & rnode_5to6_bb2_align_0_i355_0_valid_out_3_NO_SHIFT_REG);
assign local_bb2_add192_i409 = (local_bb2_add_i408 + local_bb2_xor188_i406);
assign local_bb2_cmp37_i332_valid_out_1 = 1'b1;
assign local_bb2__26_i345_valid_out = 1'b1;
assign local_bb2_add192_i409_valid_out = 1'b1;
assign local_bb2_and17_i321_valid_out_2 = 1'b1;
assign local_bb2_var__u17_valid_out = 1'b1;
assign rnode_5to6_bb2__22_i318_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2_cmp27_i329_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2_lnot23_i327_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2__22_i318_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2__23_i319_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2__23_i319_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2_cmp27_i329_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2_shr16_i320_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2_cmp27_i329_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2_align_0_i355_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2_align_0_i355_0_stall_in_4_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2_align_0_i355_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2_align_0_i355_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_5to6_bb2_align_0_i355_0_stall_in_3_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_cmp37_i332_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb2__26_i345_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_add192_i409_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_and17_i321_consumed_2_NO_SHIFT_REG <= 1'b0;
		local_bb2_var__u17_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_cmp37_i332_consumed_1_NO_SHIFT_REG <= (local_bb2_add192_i409_inputs_ready & (local_bb2_cmp37_i332_consumed_1_NO_SHIFT_REG | ~(local_bb2_cmp37_i332_stall_in_1)) & local_bb2_add192_i409_stall_local);
		local_bb2__26_i345_consumed_0_NO_SHIFT_REG <= (local_bb2_add192_i409_inputs_ready & (local_bb2__26_i345_consumed_0_NO_SHIFT_REG | ~(local_bb2__26_i345_stall_in)) & local_bb2_add192_i409_stall_local);
		local_bb2_add192_i409_consumed_0_NO_SHIFT_REG <= (local_bb2_add192_i409_inputs_ready & (local_bb2_add192_i409_consumed_0_NO_SHIFT_REG | ~(local_bb2_add192_i409_stall_in)) & local_bb2_add192_i409_stall_local);
		local_bb2_and17_i321_consumed_2_NO_SHIFT_REG <= (local_bb2_add192_i409_inputs_ready & (local_bb2_and17_i321_consumed_2_NO_SHIFT_REG | ~(local_bb2_and17_i321_stall_in_2)) & local_bb2_add192_i409_stall_local);
		local_bb2_var__u17_consumed_0_NO_SHIFT_REG <= (local_bb2_add192_i409_inputs_ready & (local_bb2_var__u17_consumed_0_NO_SHIFT_REG | ~(local_bb2_var__u17_stall_in)) & local_bb2_add192_i409_stall_local);
	end
end


// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_6to8_bb2_cmp37_i332_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_6to8_bb2_cmp37_i332_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_6to8_bb2_cmp37_i332_0_NO_SHIFT_REG;
 logic rnode_6to8_bb2_cmp37_i332_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_6to8_bb2_cmp37_i332_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_6to8_bb2_cmp37_i332_1_NO_SHIFT_REG;
 logic rnode_6to8_bb2_cmp37_i332_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_6to8_bb2_cmp37_i332_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_6to8_bb2_cmp37_i332_2_NO_SHIFT_REG;
 logic rnode_6to8_bb2_cmp37_i332_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic rnode_6to8_bb2_cmp37_i332_0_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb2_cmp37_i332_0_valid_out_0_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb2_cmp37_i332_0_stall_in_0_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb2_cmp37_i332_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_6to8_bb2_cmp37_i332_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to8_bb2_cmp37_i332_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to8_bb2_cmp37_i332_0_stall_in_0_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_6to8_bb2_cmp37_i332_0_valid_out_0_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_6to8_bb2_cmp37_i332_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(local_bb2_cmp37_i332),
	.data_out(rnode_6to8_bb2_cmp37_i332_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_6to8_bb2_cmp37_i332_0_reg_8_fifo.DEPTH = 2;
defparam rnode_6to8_bb2_cmp37_i332_0_reg_8_fifo.DATA_WIDTH = 1;
defparam rnode_6to8_bb2_cmp37_i332_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to8_bb2_cmp37_i332_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_6to8_bb2_cmp37_i332_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp37_i332_stall_in_1 = 1'b0;
assign rnode_6to8_bb2_cmp37_i332_0_stall_in_0_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_6to8_bb2_cmp37_i332_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_6to8_bb2_cmp37_i332_0_NO_SHIFT_REG = rnode_6to8_bb2_cmp37_i332_0_reg_8_NO_SHIFT_REG;
assign rnode_6to8_bb2_cmp37_i332_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_6to8_bb2_cmp37_i332_1_NO_SHIFT_REG = rnode_6to8_bb2_cmp37_i332_0_reg_8_NO_SHIFT_REG;
assign rnode_6to8_bb2_cmp37_i332_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_6to8_bb2_cmp37_i332_2_NO_SHIFT_REG = rnode_6to8_bb2_cmp37_i332_0_reg_8_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb2__26_i345_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb2__26_i345_0_stall_in_NO_SHIFT_REG;
 logic rnode_6to7_bb2__26_i345_0_NO_SHIFT_REG;
 logic rnode_6to7_bb2__26_i345_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic rnode_6to7_bb2__26_i345_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb2__26_i345_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb2__26_i345_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb2__26_i345_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb2__26_i345_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb2__26_i345_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb2__26_i345_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb2__26_i345_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb2__26_i345_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in(local_bb2__26_i345),
	.data_out(rnode_6to7_bb2__26_i345_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb2__26_i345_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb2__26_i345_0_reg_7_fifo.DATA_WIDTH = 1;
defparam rnode_6to7_bb2__26_i345_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb2__26_i345_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb2__26_i345_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__26_i345_stall_in = 1'b0;
assign rnode_6to7_bb2__26_i345_0_NO_SHIFT_REG = rnode_6to7_bb2__26_i345_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb2__26_i345_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb2__26_i345_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb2_add192_i409_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_6to7_bb2_add192_i409_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb2_add192_i409_0_NO_SHIFT_REG;
 logic rnode_6to7_bb2_add192_i409_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_6to7_bb2_add192_i409_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb2_add192_i409_1_NO_SHIFT_REG;
 logic rnode_6to7_bb2_add192_i409_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_6to7_bb2_add192_i409_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb2_add192_i409_2_NO_SHIFT_REG;
 logic rnode_6to7_bb2_add192_i409_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_6to7_bb2_add192_i409_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb2_add192_i409_3_NO_SHIFT_REG;
 logic rnode_6to7_bb2_add192_i409_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to7_bb2_add192_i409_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb2_add192_i409_0_valid_out_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb2_add192_i409_0_stall_in_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb2_add192_i409_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb2_add192_i409_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb2_add192_i409_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb2_add192_i409_0_stall_in_0_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb2_add192_i409_0_valid_out_0_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb2_add192_i409_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in(local_bb2_add192_i409),
	.data_out(rnode_6to7_bb2_add192_i409_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb2_add192_i409_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb2_add192_i409_0_reg_7_fifo.DATA_WIDTH = 32;
defparam rnode_6to7_bb2_add192_i409_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb2_add192_i409_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb2_add192_i409_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_add192_i409_stall_in = 1'b0;
assign rnode_6to7_bb2_add192_i409_0_stall_in_0_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb2_add192_i409_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb2_add192_i409_0_NO_SHIFT_REG = rnode_6to7_bb2_add192_i409_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb2_add192_i409_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb2_add192_i409_1_NO_SHIFT_REG = rnode_6to7_bb2_add192_i409_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb2_add192_i409_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb2_add192_i409_2_NO_SHIFT_REG = rnode_6to7_bb2_add192_i409_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb2_add192_i409_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb2_add192_i409_3_NO_SHIFT_REG = rnode_6to7_bb2_add192_i409_0_reg_7_NO_SHIFT_REG;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_6to8_bb2_and17_i321_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to8_bb2_and17_i321_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_6to8_bb2_and17_i321_0_NO_SHIFT_REG;
 logic rnode_6to8_bb2_and17_i321_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_6to8_bb2_and17_i321_0_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb2_and17_i321_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb2_and17_i321_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_6to8_bb2_and17_i321_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_6to8_bb2_and17_i321_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to8_bb2_and17_i321_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to8_bb2_and17_i321_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_6to8_bb2_and17_i321_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_6to8_bb2_and17_i321_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(local_bb2_and17_i321),
	.data_out(rnode_6to8_bb2_and17_i321_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_6to8_bb2_and17_i321_0_reg_8_fifo.DEPTH = 2;
defparam rnode_6to8_bb2_and17_i321_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_6to8_bb2_and17_i321_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to8_bb2_and17_i321_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_6to8_bb2_and17_i321_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and17_i321_stall_in_2 = 1'b0;
assign rnode_6to8_bb2_and17_i321_0_NO_SHIFT_REG = rnode_6to8_bb2_and17_i321_0_reg_8_NO_SHIFT_REG;
assign rnode_6to8_bb2_and17_i321_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_6to8_bb2_and17_i321_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_6to7_bb2_var__u17_0_valid_out_NO_SHIFT_REG;
 logic rnode_6to7_bb2_var__u17_0_stall_in_NO_SHIFT_REG;
 logic rnode_6to7_bb2_var__u17_0_NO_SHIFT_REG;
 logic rnode_6to7_bb2_var__u17_0_reg_7_inputs_ready_NO_SHIFT_REG;
 logic rnode_6to7_bb2_var__u17_0_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb2_var__u17_0_valid_out_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb2_var__u17_0_stall_in_reg_7_NO_SHIFT_REG;
 logic rnode_6to7_bb2_var__u17_0_stall_out_reg_7_NO_SHIFT_REG;

acl_data_fifo rnode_6to7_bb2_var__u17_0_reg_7_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_6to7_bb2_var__u17_0_reg_7_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_6to7_bb2_var__u17_0_stall_in_reg_7_NO_SHIFT_REG),
	.valid_out(rnode_6to7_bb2_var__u17_0_valid_out_reg_7_NO_SHIFT_REG),
	.stall_out(rnode_6to7_bb2_var__u17_0_stall_out_reg_7_NO_SHIFT_REG),
	.data_in(local_bb2_var__u17),
	.data_out(rnode_6to7_bb2_var__u17_0_reg_7_NO_SHIFT_REG)
);

defparam rnode_6to7_bb2_var__u17_0_reg_7_fifo.DEPTH = 1;
defparam rnode_6to7_bb2_var__u17_0_reg_7_fifo.DATA_WIDTH = 1;
defparam rnode_6to7_bb2_var__u17_0_reg_7_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_6to7_bb2_var__u17_0_reg_7_fifo.IMPL = "shift_reg";

assign rnode_6to7_bb2_var__u17_0_reg_7_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_var__u17_stall_in = 1'b0;
assign rnode_6to7_bb2_var__u17_0_NO_SHIFT_REG = rnode_6to7_bb2_var__u17_0_reg_7_NO_SHIFT_REG;
assign rnode_6to7_bb2_var__u17_0_stall_in_reg_7_NO_SHIFT_REG = 1'b0;
assign rnode_6to7_bb2_var__u17_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_not_cmp37_i438_stall_local;
wire local_bb2_not_cmp37_i438;

assign local_bb2_not_cmp37_i438 = (rnode_6to8_bb2_cmp37_i332_1_NO_SHIFT_REG ^ 1'b1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb2__26_i345_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb2__26_i345_0_stall_in_NO_SHIFT_REG;
 logic rnode_7to8_bb2__26_i345_0_NO_SHIFT_REG;
 logic rnode_7to8_bb2__26_i345_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic rnode_7to8_bb2__26_i345_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2__26_i345_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2__26_i345_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2__26_i345_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb2__26_i345_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb2__26_i345_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb2__26_i345_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb2__26_i345_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb2__26_i345_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(rnode_6to7_bb2__26_i345_0_NO_SHIFT_REG),
	.data_out(rnode_7to8_bb2__26_i345_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb2__26_i345_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb2__26_i345_0_reg_8_fifo.DATA_WIDTH = 1;
defparam rnode_7to8_bb2__26_i345_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb2__26_i345_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb2__26_i345_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb2__26_i345_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2__26_i345_0_NO_SHIFT_REG = rnode_7to8_bb2__26_i345_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb2__26_i345_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2__26_i345_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_and193_i410_valid_out;
wire local_bb2_and193_i410_stall_in;
wire local_bb2_and193_i410_inputs_ready;
wire local_bb2_and193_i410_stall_local;
wire [31:0] local_bb2_and193_i410;

assign local_bb2_and193_i410_inputs_ready = rnode_6to7_bb2_add192_i409_0_valid_out_0_NO_SHIFT_REG;
assign local_bb2_and193_i410 = (rnode_6to7_bb2_add192_i409_0_NO_SHIFT_REG & 32'hFFFFFFF);
assign local_bb2_and193_i410_valid_out = 1'b1;
assign rnode_6to7_bb2_add192_i409_0_stall_in_0_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_and195_i411_valid_out;
wire local_bb2_and195_i411_stall_in;
wire local_bb2_and195_i411_inputs_ready;
wire local_bb2_and195_i411_stall_local;
wire [31:0] local_bb2_and195_i411;

assign local_bb2_and195_i411_inputs_ready = rnode_6to7_bb2_add192_i409_0_valid_out_1_NO_SHIFT_REG;
assign local_bb2_and195_i411 = (rnode_6to7_bb2_add192_i409_1_NO_SHIFT_REG >> 32'h1B);
assign local_bb2_and195_i411_valid_out = 1'b1;
assign rnode_6to7_bb2_add192_i409_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_and198_i412_valid_out;
wire local_bb2_and198_i412_stall_in;
wire local_bb2_and198_i412_inputs_ready;
wire local_bb2_and198_i412_stall_local;
wire [31:0] local_bb2_and198_i412;

assign local_bb2_and198_i412_inputs_ready = rnode_6to7_bb2_add192_i409_0_valid_out_2_NO_SHIFT_REG;
assign local_bb2_and198_i412 = (rnode_6to7_bb2_add192_i409_2_NO_SHIFT_REG & 32'h1);
assign local_bb2_and198_i412_valid_out = 1'b1;
assign rnode_6to7_bb2_add192_i409_0_stall_in_2_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_and201_i413_stall_local;
wire [31:0] local_bb2_and201_i413;

assign local_bb2_and201_i413 = (rnode_6to7_bb2_add192_i409_3_NO_SHIFT_REG & 32'h7FFFFFF);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb2_var__u17_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb2_var__u17_0_stall_in_NO_SHIFT_REG;
 logic rnode_7to8_bb2_var__u17_0_NO_SHIFT_REG;
 logic rnode_7to8_bb2_var__u17_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic rnode_7to8_bb2_var__u17_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2_var__u17_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2_var__u17_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2_var__u17_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb2_var__u17_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb2_var__u17_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb2_var__u17_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb2_var__u17_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb2_var__u17_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(rnode_6to7_bb2_var__u17_0_NO_SHIFT_REG),
	.data_out(rnode_7to8_bb2_var__u17_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb2_var__u17_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb2_var__u17_0_reg_8_fifo.DATA_WIDTH = 1;
defparam rnode_7to8_bb2_var__u17_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb2_var__u17_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb2_var__u17_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_6to7_bb2_var__u17_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2_var__u17_0_NO_SHIFT_REG = rnode_7to8_bb2_var__u17_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb2_var__u17_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2_var__u17_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb2__26_i345_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_8to9_bb2__26_i345_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_8to9_bb2__26_i345_0_NO_SHIFT_REG;
 logic rnode_8to9_bb2__26_i345_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_8to9_bb2__26_i345_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_8to9_bb2__26_i345_1_NO_SHIFT_REG;
 logic rnode_8to9_bb2__26_i345_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_8to9_bb2__26_i345_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_8to9_bb2__26_i345_2_NO_SHIFT_REG;
 logic rnode_8to9_bb2__26_i345_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic rnode_8to9_bb2__26_i345_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2__26_i345_0_valid_out_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2__26_i345_0_stall_in_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2__26_i345_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb2__26_i345_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb2__26_i345_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb2__26_i345_0_stall_in_0_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb2__26_i345_0_valid_out_0_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb2__26_i345_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(rnode_7to8_bb2__26_i345_0_NO_SHIFT_REG),
	.data_out(rnode_8to9_bb2__26_i345_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb2__26_i345_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb2__26_i345_0_reg_9_fifo.DATA_WIDTH = 1;
defparam rnode_8to9_bb2__26_i345_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb2__26_i345_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb2__26_i345_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb2__26_i345_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2__26_i345_0_stall_in_0_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2__26_i345_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_8to9_bb2__26_i345_0_NO_SHIFT_REG = rnode_8to9_bb2__26_i345_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb2__26_i345_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_8to9_bb2__26_i345_1_NO_SHIFT_REG = rnode_8to9_bb2__26_i345_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb2__26_i345_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_8to9_bb2__26_i345_2_NO_SHIFT_REG = rnode_8to9_bb2__26_i345_0_reg_9_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb2_and193_i410_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and193_i410_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb2_and193_i410_0_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and193_i410_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and193_i410_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb2_and193_i410_1_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and193_i410_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and193_i410_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb2_and193_i410_2_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and193_i410_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb2_and193_i410_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and193_i410_0_valid_out_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and193_i410_0_stall_in_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and193_i410_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb2_and193_i410_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb2_and193_i410_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb2_and193_i410_0_stall_in_0_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb2_and193_i410_0_valid_out_0_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb2_and193_i410_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(local_bb2_and193_i410),
	.data_out(rnode_7to8_bb2_and193_i410_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb2_and193_i410_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb2_and193_i410_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb2_and193_i410_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb2_and193_i410_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb2_and193_i410_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and193_i410_stall_in = 1'b0;
assign rnode_7to8_bb2_and193_i410_0_stall_in_0_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2_and193_i410_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb2_and193_i410_0_NO_SHIFT_REG = rnode_7to8_bb2_and193_i410_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb2_and193_i410_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb2_and193_i410_1_NO_SHIFT_REG = rnode_7to8_bb2_and193_i410_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb2_and193_i410_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb2_and193_i410_2_NO_SHIFT_REG = rnode_7to8_bb2_and193_i410_0_reg_8_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb2_and195_i411_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and195_i411_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb2_and195_i411_0_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and195_i411_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb2_and195_i411_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and195_i411_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and195_i411_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and195_i411_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb2_and195_i411_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb2_and195_i411_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb2_and195_i411_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb2_and195_i411_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb2_and195_i411_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(local_bb2_and195_i411),
	.data_out(rnode_7to8_bb2_and195_i411_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb2_and195_i411_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb2_and195_i411_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb2_and195_i411_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb2_and195_i411_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb2_and195_i411_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and195_i411_stall_in = 1'b0;
assign rnode_7to8_bb2_and195_i411_0_NO_SHIFT_REG = rnode_7to8_bb2_and195_i411_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb2_and195_i411_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2_and195_i411_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb2_and198_i412_0_valid_out_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and198_i412_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb2_and198_i412_0_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and198_i412_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb2_and198_i412_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and198_i412_0_valid_out_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and198_i412_0_stall_in_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2_and198_i412_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb2_and198_i412_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb2_and198_i412_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb2_and198_i412_0_stall_in_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb2_and198_i412_0_valid_out_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb2_and198_i412_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(local_bb2_and198_i412),
	.data_out(rnode_7to8_bb2_and198_i412_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb2_and198_i412_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb2_and198_i412_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb2_and198_i412_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb2_and198_i412_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb2_and198_i412_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and198_i412_stall_in = 1'b0;
assign rnode_7to8_bb2_and198_i412_0_NO_SHIFT_REG = rnode_7to8_bb2_and198_i412_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb2_and198_i412_0_stall_in_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2_and198_i412_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_shr_i_i414_stall_local;
wire [31:0] local_bb2_shr_i_i414;

assign local_bb2_shr_i_i414 = (local_bb2_and201_i413 >> 32'h1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb2_var__u17_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb2_var__u17_0_stall_in_NO_SHIFT_REG;
 logic rnode_8to9_bb2_var__u17_0_NO_SHIFT_REG;
 logic rnode_8to9_bb2_var__u17_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic rnode_8to9_bb2_var__u17_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_var__u17_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_var__u17_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_var__u17_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb2_var__u17_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb2_var__u17_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb2_var__u17_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb2_var__u17_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb2_var__u17_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(rnode_7to8_bb2_var__u17_0_NO_SHIFT_REG),
	.data_out(rnode_8to9_bb2_var__u17_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb2_var__u17_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb2_var__u17_0_reg_9_fifo.DATA_WIDTH = 1;
defparam rnode_8to9_bb2_var__u17_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb2_var__u17_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb2_var__u17_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb2_var__u17_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_var__u17_0_NO_SHIFT_REG = rnode_8to9_bb2_var__u17_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb2_var__u17_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_var__u17_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_cond292_i472_stall_local;
wire [31:0] local_bb2_cond292_i472;

assign local_bb2_cond292_i472 = (rnode_8to9_bb2__26_i345_1_NO_SHIFT_REG ? 32'h400000 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u22_stall_local;
wire [31:0] local_bb2_var__u22;

assign local_bb2_var__u22[31:1] = 31'h0;
assign local_bb2_var__u22[0] = rnode_8to9_bb2__26_i345_2_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_shr216_i435_stall_local;
wire [31:0] local_bb2_shr216_i435;

assign local_bb2_shr216_i435 = (rnode_7to8_bb2_and193_i410_1_NO_SHIFT_REG >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2__pre_i433_stall_local;
wire [31:0] local_bb2__pre_i433;

assign local_bb2__pre_i433 = (rnode_7to8_bb2_and195_i411_0_NO_SHIFT_REG & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_or_i_i415_stall_local;
wire [31:0] local_bb2_or_i_i415;

assign local_bb2_or_i_i415 = (local_bb2_shr_i_i414 | local_bb2_and201_i413);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_ext_i482_stall_local;
wire [31:0] local_bb2_lnot_ext_i482;

assign local_bb2_lnot_ext_i482 = (local_bb2_var__u22 ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_or219_i436_stall_local;
wire [31:0] local_bb2_or219_i436;

assign local_bb2_or219_i436 = (local_bb2_shr216_i435 | rnode_7to8_bb2_and198_i412_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_tobool213_i434_stall_local;
wire local_bb2_tobool213_i434;

assign local_bb2_tobool213_i434 = (local_bb2__pre_i433 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_shr1_i_i416_stall_local;
wire [31:0] local_bb2_shr1_i_i416;

assign local_bb2_shr1_i_i416 = (local_bb2_or_i_i415 >> 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb2__40_demorgan_i437_stall_local;
wire local_bb2__40_demorgan_i437;

assign local_bb2__40_demorgan_i437 = (rnode_6to8_bb2_cmp37_i332_0_NO_SHIFT_REG | local_bb2_tobool213_i434);

// This section implements an unregistered operation.
// 
wire local_bb2__42_i439_stall_local;
wire local_bb2__42_i439;

assign local_bb2__42_i439 = (local_bb2_tobool213_i434 & local_bb2_not_cmp37_i438);

// This section implements an unregistered operation.
// 
wire local_bb2_or2_i_i417_stall_local;
wire [31:0] local_bb2_or2_i_i417;

assign local_bb2_or2_i_i417 = (local_bb2_shr1_i_i416 | local_bb2_or_i_i415);

// This section implements an unregistered operation.
// 
wire local_bb2__43_i440_stall_local;
wire [31:0] local_bb2__43_i440;

assign local_bb2__43_i440 = (local_bb2__42_i439 ? 32'h0 : local_bb2__pre_i433);

// This section implements an unregistered operation.
// 
wire local_bb2_shr3_i_i418_stall_local;
wire [31:0] local_bb2_shr3_i_i418;

assign local_bb2_shr3_i_i418 = (local_bb2_or2_i_i417 >> 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb2_or4_i_i419_stall_local;
wire [31:0] local_bb2_or4_i_i419;

assign local_bb2_or4_i_i419 = (local_bb2_shr3_i_i418 | local_bb2_or2_i_i417);

// This section implements an unregistered operation.
// 
wire local_bb2_shr5_i_i420_stall_local;
wire [31:0] local_bb2_shr5_i_i420;

assign local_bb2_shr5_i_i420 = (local_bb2_or4_i_i419 >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb2_or6_i_i421_stall_local;
wire [31:0] local_bb2_or6_i_i421;

assign local_bb2_or6_i_i421 = (local_bb2_shr5_i_i420 | local_bb2_or4_i_i419);

// This section implements an unregistered operation.
// 
wire local_bb2_shr7_i_i422_stall_local;
wire [31:0] local_bb2_shr7_i_i422;

assign local_bb2_shr7_i_i422 = (local_bb2_or6_i_i421 >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb2_or6_masked_i_i423_stall_local;
wire [31:0] local_bb2_or6_masked_i_i423;

assign local_bb2_or6_masked_i_i423 = (local_bb2_or6_i_i421 & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_neg_i_i424_stall_local;
wire [31:0] local_bb2_neg_i_i424;

assign local_bb2_neg_i_i424 = (local_bb2_or6_masked_i_i423 | local_bb2_shr7_i_i422);

// This section implements an unregistered operation.
// 
wire local_bb2_and_i_i425_stall_local;
wire [31:0] local_bb2_and_i_i425;

assign local_bb2_and_i_i425 = (local_bb2_neg_i_i424 ^ 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2__and_i_i425_valid_out;
wire local_bb2__and_i_i425_stall_in;
wire local_bb2__and_i_i425_inputs_ready;
wire local_bb2__and_i_i425_stall_local;
wire [31:0] local_bb2__and_i_i425;

thirtysix_six_comp local_bb2__and_i_i425_popcnt_instance (
	.data(local_bb2_and_i_i425),
	.sum(local_bb2__and_i_i425)
);


assign local_bb2__and_i_i425_inputs_ready = rnode_6to7_bb2_add192_i409_0_valid_out_3_NO_SHIFT_REG;
assign local_bb2__and_i_i425_valid_out = 1'b1;
assign rnode_6to7_bb2_add192_i409_0_stall_in_3_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_7to8_bb2__and_i_i425_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_7to8_bb2__and_i_i425_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb2__and_i_i425_0_NO_SHIFT_REG;
 logic rnode_7to8_bb2__and_i_i425_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_7to8_bb2__and_i_i425_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb2__and_i_i425_1_NO_SHIFT_REG;
 logic rnode_7to8_bb2__and_i_i425_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_7to8_bb2__and_i_i425_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb2__and_i_i425_2_NO_SHIFT_REG;
 logic rnode_7to8_bb2__and_i_i425_0_reg_8_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_7to8_bb2__and_i_i425_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2__and_i_i425_0_valid_out_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2__and_i_i425_0_stall_in_0_reg_8_NO_SHIFT_REG;
 logic rnode_7to8_bb2__and_i_i425_0_stall_out_reg_8_NO_SHIFT_REG;

acl_data_fifo rnode_7to8_bb2__and_i_i425_0_reg_8_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_7to8_bb2__and_i_i425_0_reg_8_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_7to8_bb2__and_i_i425_0_stall_in_0_reg_8_NO_SHIFT_REG),
	.valid_out(rnode_7to8_bb2__and_i_i425_0_valid_out_0_reg_8_NO_SHIFT_REG),
	.stall_out(rnode_7to8_bb2__and_i_i425_0_stall_out_reg_8_NO_SHIFT_REG),
	.data_in(local_bb2__and_i_i425),
	.data_out(rnode_7to8_bb2__and_i_i425_0_reg_8_NO_SHIFT_REG)
);

defparam rnode_7to8_bb2__and_i_i425_0_reg_8_fifo.DEPTH = 1;
defparam rnode_7to8_bb2__and_i_i425_0_reg_8_fifo.DATA_WIDTH = 32;
defparam rnode_7to8_bb2__and_i_i425_0_reg_8_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_7to8_bb2__and_i_i425_0_reg_8_fifo.IMPL = "shift_reg";

assign rnode_7to8_bb2__and_i_i425_0_reg_8_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__and_i_i425_stall_in = 1'b0;
assign rnode_7to8_bb2__and_i_i425_0_stall_in_0_reg_8_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2__and_i_i425_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb2__and_i_i425_0_NO_SHIFT_REG = rnode_7to8_bb2__and_i_i425_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb2__and_i_i425_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb2__and_i_i425_1_NO_SHIFT_REG = rnode_7to8_bb2__and_i_i425_0_reg_8_NO_SHIFT_REG;
assign rnode_7to8_bb2__and_i_i425_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_7to8_bb2__and_i_i425_2_NO_SHIFT_REG = rnode_7to8_bb2__and_i_i425_0_reg_8_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_and9_i_i426_stall_local;
wire [31:0] local_bb2_and9_i_i426;

assign local_bb2_and9_i_i426 = (rnode_7to8_bb2__and_i_i425_0_NO_SHIFT_REG & 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb2_and203_i427_stall_local;
wire [31:0] local_bb2_and203_i427;

assign local_bb2_and203_i427 = (rnode_7to8_bb2__and_i_i425_1_NO_SHIFT_REG & 32'h18);

// This section implements an unregistered operation.
// 
wire local_bb2_and206_i429_stall_local;
wire [31:0] local_bb2_and206_i429;

assign local_bb2_and206_i429 = (rnode_7to8_bb2__and_i_i425_2_NO_SHIFT_REG & 32'h7);

// This section implements an unregistered operation.
// 
wire local_bb2_sub239_i448_stall_local;
wire [31:0] local_bb2_sub239_i448;

assign local_bb2_sub239_i448 = (32'h0 - local_bb2_and9_i_i426);

// This section implements an unregistered operation.
// 
wire local_bb2_shl204_i428_stall_local;
wire [31:0] local_bb2_shl204_i428;

assign local_bb2_shl204_i428 = (rnode_7to8_bb2_and193_i410_0_NO_SHIFT_REG << local_bb2_and203_i427);

// This section implements an unregistered operation.
// 
wire local_bb2_cond244_i449_stall_local;
wire [31:0] local_bb2_cond244_i449;

assign local_bb2_cond244_i449 = (rnode_6to8_bb2_cmp37_i332_2_NO_SHIFT_REG ? local_bb2_sub239_i448 : local_bb2__43_i440);

// This section implements an unregistered operation.
// 
wire local_bb2_and205_i430_stall_local;
wire [31:0] local_bb2_and205_i430;

assign local_bb2_and205_i430 = (local_bb2_shl204_i428 & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_add245_i450_stall_local;
wire [31:0] local_bb2_add245_i450;

assign local_bb2_add245_i450 = (local_bb2_cond244_i449 + rnode_6to8_bb2_and17_i321_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_fold_i452_stall_local;
wire [31:0] local_bb2_fold_i452;

assign local_bb2_fold_i452 = (local_bb2_cond244_i449 + rnode_6to8_bb2_shr16_i320_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_shl207_i431_stall_local;
wire [31:0] local_bb2_shl207_i431;

assign local_bb2_shl207_i431 = (local_bb2_and205_i430 << local_bb2_and206_i429);

// This section implements an unregistered operation.
// 
wire local_bb2_and250_i453_stall_local;
wire [31:0] local_bb2_and250_i453;

assign local_bb2_and250_i453 = (local_bb2_fold_i452 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and269_i464_stall_local;
wire [31:0] local_bb2_and269_i464;

assign local_bb2_and269_i464 = (local_bb2_fold_i452 << 32'h17);

// This section implements an unregistered operation.
// 
wire local_bb2_and208_i432_stall_local;
wire [31:0] local_bb2_and208_i432;

assign local_bb2_and208_i432 = (local_bb2_shl207_i431 & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_notrhs_i455_stall_local;
wire local_bb2_notrhs_i455;

assign local_bb2_notrhs_i455 = (local_bb2_and250_i453 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2__44_i441_stall_local;
wire [31:0] local_bb2__44_i441;

assign local_bb2__44_i441 = (local_bb2__40_demorgan_i437 ? local_bb2_and208_i432 : local_bb2_or219_i436);

// This section implements an unregistered operation.
// 
wire local_bb2__45_i442_stall_local;
wire [31:0] local_bb2__45_i442;

assign local_bb2__45_i442 = (local_bb2__42_i439 ? rnode_7to8_bb2_and193_i410_2_NO_SHIFT_REG : local_bb2__44_i441);

// This section implements an unregistered operation.
// 
wire local_bb2_and225_i443_stall_local;
wire [31:0] local_bb2_and225_i443;

assign local_bb2_and225_i443 = (local_bb2__45_i442 & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and270_i461_stall_local;
wire [31:0] local_bb2_and270_i461;

assign local_bb2_and270_i461 = (local_bb2__45_i442 & 32'h7);

// This section implements an unregistered operation.
// 
wire local_bb2_shr271_i462_stall_local;
wire [31:0] local_bb2_shr271_i462;

assign local_bb2_shr271_i462 = (local_bb2__45_i442 >> 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp226_i444_stall_local;
wire local_bb2_cmp226_i444;

assign local_bb2_cmp226_i444 = (local_bb2_and225_i443 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp296_i476_stall_local;
wire local_bb2_cmp296_i476;

assign local_bb2_cmp296_i476 = (local_bb2_and270_i461 > 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb2_and269_i464_valid_out;
wire local_bb2_and269_i464_stall_in;
 reg local_bb2_and269_i464_consumed_0_NO_SHIFT_REG;
wire local_bb2_add245_i450_valid_out;
wire local_bb2_add245_i450_stall_in;
 reg local_bb2_add245_i450_consumed_0_NO_SHIFT_REG;
wire local_bb2_notrhs_i455_valid_out;
wire local_bb2_notrhs_i455_stall_in;
 reg local_bb2_notrhs_i455_consumed_0_NO_SHIFT_REG;
wire local_bb2_not_cmp37_i438_valid_out_1;
wire local_bb2_not_cmp37_i438_stall_in_1;
 reg local_bb2_not_cmp37_i438_consumed_1_NO_SHIFT_REG;
wire local_bb2_shr271_i462_valid_out;
wire local_bb2_shr271_i462_stall_in;
 reg local_bb2_shr271_i462_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp226_i444_valid_out;
wire local_bb2_cmp226_i444_stall_in;
 reg local_bb2_cmp226_i444_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp296_i476_valid_out;
wire local_bb2_cmp296_i476_stall_in;
 reg local_bb2_cmp296_i476_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp299_i477_valid_out;
wire local_bb2_cmp299_i477_stall_in;
 reg local_bb2_cmp299_i477_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp299_i477_inputs_ready;
wire local_bb2_cmp299_i477_stall_local;
wire local_bb2_cmp299_i477;

assign local_bb2_cmp299_i477_inputs_ready = (rnode_6to8_bb2_shr16_i320_0_valid_out_NO_SHIFT_REG & rnode_6to8_bb2_cmp37_i332_0_valid_out_2_NO_SHIFT_REG & rnode_6to8_bb2_and17_i321_0_valid_out_NO_SHIFT_REG & rnode_6to8_bb2_cmp37_i332_0_valid_out_0_NO_SHIFT_REG & rnode_7to8_bb2_and193_i410_0_valid_out_2_NO_SHIFT_REG & rnode_6to8_bb2_cmp37_i332_0_valid_out_1_NO_SHIFT_REG & rnode_7to8_bb2_and195_i411_0_valid_out_NO_SHIFT_REG & rnode_7to8_bb2_and193_i410_0_valid_out_1_NO_SHIFT_REG & rnode_7to8_bb2_and198_i412_0_valid_out_NO_SHIFT_REG & rnode_7to8_bb2_and193_i410_0_valid_out_0_NO_SHIFT_REG & rnode_7to8_bb2__and_i_i425_0_valid_out_1_NO_SHIFT_REG & rnode_7to8_bb2__and_i_i425_0_valid_out_2_NO_SHIFT_REG & rnode_7to8_bb2__and_i_i425_0_valid_out_0_NO_SHIFT_REG);
assign local_bb2_cmp299_i477 = (local_bb2_and270_i461 == 32'h4);
assign local_bb2_and269_i464_valid_out = 1'b1;
assign local_bb2_add245_i450_valid_out = 1'b1;
assign local_bb2_notrhs_i455_valid_out = 1'b1;
assign local_bb2_not_cmp37_i438_valid_out_1 = 1'b1;
assign local_bb2_shr271_i462_valid_out = 1'b1;
assign local_bb2_cmp226_i444_valid_out = 1'b1;
assign local_bb2_cmp296_i476_valid_out = 1'b1;
assign local_bb2_cmp299_i477_valid_out = 1'b1;
assign rnode_6to8_bb2_shr16_i320_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_6to8_bb2_cmp37_i332_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_6to8_bb2_and17_i321_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_6to8_bb2_cmp37_i332_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2_and193_i410_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_6to8_bb2_cmp37_i332_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2_and195_i411_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2_and193_i410_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2_and198_i412_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2_and193_i410_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2__and_i_i425_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2__and_i_i425_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_7to8_bb2__and_i_i425_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_and269_i464_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_add245_i450_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_notrhs_i455_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_not_cmp37_i438_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb2_shr271_i462_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp226_i444_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp296_i476_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp299_i477_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_and269_i464_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i477_inputs_ready & (local_bb2_and269_i464_consumed_0_NO_SHIFT_REG | ~(local_bb2_and269_i464_stall_in)) & local_bb2_cmp299_i477_stall_local);
		local_bb2_add245_i450_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i477_inputs_ready & (local_bb2_add245_i450_consumed_0_NO_SHIFT_REG | ~(local_bb2_add245_i450_stall_in)) & local_bb2_cmp299_i477_stall_local);
		local_bb2_notrhs_i455_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i477_inputs_ready & (local_bb2_notrhs_i455_consumed_0_NO_SHIFT_REG | ~(local_bb2_notrhs_i455_stall_in)) & local_bb2_cmp299_i477_stall_local);
		local_bb2_not_cmp37_i438_consumed_1_NO_SHIFT_REG <= (local_bb2_cmp299_i477_inputs_ready & (local_bb2_not_cmp37_i438_consumed_1_NO_SHIFT_REG | ~(local_bb2_not_cmp37_i438_stall_in_1)) & local_bb2_cmp299_i477_stall_local);
		local_bb2_shr271_i462_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i477_inputs_ready & (local_bb2_shr271_i462_consumed_0_NO_SHIFT_REG | ~(local_bb2_shr271_i462_stall_in)) & local_bb2_cmp299_i477_stall_local);
		local_bb2_cmp226_i444_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i477_inputs_ready & (local_bb2_cmp226_i444_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp226_i444_stall_in)) & local_bb2_cmp299_i477_stall_local);
		local_bb2_cmp296_i476_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i477_inputs_ready & (local_bb2_cmp296_i476_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp296_i476_stall_in)) & local_bb2_cmp299_i477_stall_local);
		local_bb2_cmp299_i477_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i477_inputs_ready & (local_bb2_cmp299_i477_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp299_i477_stall_in)) & local_bb2_cmp299_i477_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb2_and269_i464_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb2_and269_i464_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb2_and269_i464_0_NO_SHIFT_REG;
 logic rnode_8to9_bb2_and269_i464_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb2_and269_i464_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_and269_i464_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_and269_i464_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_and269_i464_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb2_and269_i464_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb2_and269_i464_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb2_and269_i464_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb2_and269_i464_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb2_and269_i464_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb2_and269_i464),
	.data_out(rnode_8to9_bb2_and269_i464_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb2_and269_i464_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb2_and269_i464_0_reg_9_fifo.DATA_WIDTH = 32;
defparam rnode_8to9_bb2_and269_i464_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb2_and269_i464_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb2_and269_i464_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and269_i464_stall_in = 1'b0;
assign rnode_8to9_bb2_and269_i464_0_NO_SHIFT_REG = rnode_8to9_bb2_and269_i464_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb2_and269_i464_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_and269_i464_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb2_add245_i450_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_8to9_bb2_add245_i450_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb2_add245_i450_0_NO_SHIFT_REG;
 logic rnode_8to9_bb2_add245_i450_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_8to9_bb2_add245_i450_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb2_add245_i450_1_NO_SHIFT_REG;
 logic rnode_8to9_bb2_add245_i450_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb2_add245_i450_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_add245_i450_0_valid_out_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_add245_i450_0_stall_in_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_add245_i450_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb2_add245_i450_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb2_add245_i450_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb2_add245_i450_0_stall_in_0_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb2_add245_i450_0_valid_out_0_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb2_add245_i450_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb2_add245_i450),
	.data_out(rnode_8to9_bb2_add245_i450_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb2_add245_i450_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb2_add245_i450_0_reg_9_fifo.DATA_WIDTH = 32;
defparam rnode_8to9_bb2_add245_i450_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb2_add245_i450_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb2_add245_i450_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_add245_i450_stall_in = 1'b0;
assign rnode_8to9_bb2_add245_i450_0_stall_in_0_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_add245_i450_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_8to9_bb2_add245_i450_0_NO_SHIFT_REG = rnode_8to9_bb2_add245_i450_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb2_add245_i450_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_8to9_bb2_add245_i450_1_NO_SHIFT_REG = rnode_8to9_bb2_add245_i450_0_reg_9_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb2_notrhs_i455_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb2_notrhs_i455_0_stall_in_NO_SHIFT_REG;
 logic rnode_8to9_bb2_notrhs_i455_0_NO_SHIFT_REG;
 logic rnode_8to9_bb2_notrhs_i455_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic rnode_8to9_bb2_notrhs_i455_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_notrhs_i455_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_notrhs_i455_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_notrhs_i455_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb2_notrhs_i455_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb2_notrhs_i455_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb2_notrhs_i455_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb2_notrhs_i455_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb2_notrhs_i455_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb2_notrhs_i455),
	.data_out(rnode_8to9_bb2_notrhs_i455_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb2_notrhs_i455_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb2_notrhs_i455_0_reg_9_fifo.DATA_WIDTH = 1;
defparam rnode_8to9_bb2_notrhs_i455_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb2_notrhs_i455_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb2_notrhs_i455_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_notrhs_i455_stall_in = 1'b0;
assign rnode_8to9_bb2_notrhs_i455_0_NO_SHIFT_REG = rnode_8to9_bb2_notrhs_i455_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb2_notrhs_i455_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_notrhs_i455_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb2_not_cmp37_i438_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb2_not_cmp37_i438_0_stall_in_NO_SHIFT_REG;
 logic rnode_8to9_bb2_not_cmp37_i438_0_NO_SHIFT_REG;
 logic rnode_8to9_bb2_not_cmp37_i438_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic rnode_8to9_bb2_not_cmp37_i438_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_not_cmp37_i438_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_not_cmp37_i438_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_not_cmp37_i438_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb2_not_cmp37_i438_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb2_not_cmp37_i438_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb2_not_cmp37_i438_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb2_not_cmp37_i438_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb2_not_cmp37_i438_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb2_not_cmp37_i438),
	.data_out(rnode_8to9_bb2_not_cmp37_i438_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb2_not_cmp37_i438_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb2_not_cmp37_i438_0_reg_9_fifo.DATA_WIDTH = 1;
defparam rnode_8to9_bb2_not_cmp37_i438_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb2_not_cmp37_i438_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb2_not_cmp37_i438_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_not_cmp37_i438_stall_in_1 = 1'b0;
assign rnode_8to9_bb2_not_cmp37_i438_0_NO_SHIFT_REG = rnode_8to9_bb2_not_cmp37_i438_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb2_not_cmp37_i438_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_not_cmp37_i438_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb2_shr271_i462_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb2_shr271_i462_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb2_shr271_i462_0_NO_SHIFT_REG;
 logic rnode_8to9_bb2_shr271_i462_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_8to9_bb2_shr271_i462_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_shr271_i462_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_shr271_i462_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_shr271_i462_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb2_shr271_i462_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb2_shr271_i462_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb2_shr271_i462_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb2_shr271_i462_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb2_shr271_i462_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb2_shr271_i462),
	.data_out(rnode_8to9_bb2_shr271_i462_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb2_shr271_i462_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb2_shr271_i462_0_reg_9_fifo.DATA_WIDTH = 32;
defparam rnode_8to9_bb2_shr271_i462_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb2_shr271_i462_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb2_shr271_i462_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_shr271_i462_stall_in = 1'b0;
assign rnode_8to9_bb2_shr271_i462_0_NO_SHIFT_REG = rnode_8to9_bb2_shr271_i462_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb2_shr271_i462_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_shr271_i462_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb2_cmp226_i444_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp226_i444_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp226_i444_0_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp226_i444_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp226_i444_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp226_i444_1_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp226_i444_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp226_i444_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp226_i444_0_valid_out_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp226_i444_0_stall_in_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp226_i444_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb2_cmp226_i444_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb2_cmp226_i444_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb2_cmp226_i444_0_stall_in_0_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb2_cmp226_i444_0_valid_out_0_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb2_cmp226_i444_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb2_cmp226_i444),
	.data_out(rnode_8to9_bb2_cmp226_i444_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb2_cmp226_i444_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb2_cmp226_i444_0_reg_9_fifo.DATA_WIDTH = 1;
defparam rnode_8to9_bb2_cmp226_i444_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb2_cmp226_i444_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb2_cmp226_i444_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp226_i444_stall_in = 1'b0;
assign rnode_8to9_bb2_cmp226_i444_0_stall_in_0_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_cmp226_i444_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_8to9_bb2_cmp226_i444_0_NO_SHIFT_REG = rnode_8to9_bb2_cmp226_i444_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb2_cmp226_i444_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_8to9_bb2_cmp226_i444_1_NO_SHIFT_REG = rnode_8to9_bb2_cmp226_i444_0_reg_9_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb2_cmp296_i476_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp296_i476_0_stall_in_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp296_i476_0_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp296_i476_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp296_i476_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp296_i476_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp296_i476_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp296_i476_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb2_cmp296_i476_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb2_cmp296_i476_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb2_cmp296_i476_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb2_cmp296_i476_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb2_cmp296_i476_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb2_cmp296_i476),
	.data_out(rnode_8to9_bb2_cmp296_i476_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb2_cmp296_i476_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb2_cmp296_i476_0_reg_9_fifo.DATA_WIDTH = 1;
defparam rnode_8to9_bb2_cmp296_i476_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb2_cmp296_i476_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb2_cmp296_i476_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp296_i476_stall_in = 1'b0;
assign rnode_8to9_bb2_cmp296_i476_0_NO_SHIFT_REG = rnode_8to9_bb2_cmp296_i476_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb2_cmp296_i476_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_cmp296_i476_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_8to9_bb2_cmp299_i477_0_valid_out_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp299_i477_0_stall_in_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp299_i477_0_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp299_i477_0_reg_9_inputs_ready_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp299_i477_0_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp299_i477_0_valid_out_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp299_i477_0_stall_in_reg_9_NO_SHIFT_REG;
 logic rnode_8to9_bb2_cmp299_i477_0_stall_out_reg_9_NO_SHIFT_REG;

acl_data_fifo rnode_8to9_bb2_cmp299_i477_0_reg_9_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_8to9_bb2_cmp299_i477_0_reg_9_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_8to9_bb2_cmp299_i477_0_stall_in_reg_9_NO_SHIFT_REG),
	.valid_out(rnode_8to9_bb2_cmp299_i477_0_valid_out_reg_9_NO_SHIFT_REG),
	.stall_out(rnode_8to9_bb2_cmp299_i477_0_stall_out_reg_9_NO_SHIFT_REG),
	.data_in(local_bb2_cmp299_i477),
	.data_out(rnode_8to9_bb2_cmp299_i477_0_reg_9_NO_SHIFT_REG)
);

defparam rnode_8to9_bb2_cmp299_i477_0_reg_9_fifo.DEPTH = 1;
defparam rnode_8to9_bb2_cmp299_i477_0_reg_9_fifo.DATA_WIDTH = 1;
defparam rnode_8to9_bb2_cmp299_i477_0_reg_9_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_8to9_bb2_cmp299_i477_0_reg_9_fifo.IMPL = "shift_reg";

assign rnode_8to9_bb2_cmp299_i477_0_reg_9_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp299_i477_stall_in = 1'b0;
assign rnode_8to9_bb2_cmp299_i477_0_NO_SHIFT_REG = rnode_8to9_bb2_cmp299_i477_0_reg_9_NO_SHIFT_REG;
assign rnode_8to9_bb2_cmp299_i477_0_stall_in_reg_9_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_cmp299_i477_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_shl273_i465_stall_local;
wire [31:0] local_bb2_shl273_i465;

assign local_bb2_shl273_i465 = (rnode_8to9_bb2_and269_i464_0_NO_SHIFT_REG & 32'h7F800000);

// This section implements an unregistered operation.
// 
wire local_bb2_and247_i451_stall_local;
wire [31:0] local_bb2_and247_i451;

assign local_bb2_and247_i451 = (rnode_8to9_bb2_add245_i450_0_NO_SHIFT_REG & 32'h100);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp258_i458_stall_local;
wire local_bb2_cmp258_i458;

assign local_bb2_cmp258_i458 = ($signed(rnode_8to9_bb2_add245_i450_1_NO_SHIFT_REG) > $signed(32'hFE));

// This section implements an unregistered operation.
// 
wire local_bb2_and272_i463_stall_local;
wire [31:0] local_bb2_and272_i463;

assign local_bb2_and272_i463 = (rnode_8to9_bb2_shr271_i462_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp226_not_i445_stall_local;
wire local_bb2_cmp226_not_i445;

assign local_bb2_cmp226_not_i445 = (rnode_8to9_bb2_cmp226_i444_0_NO_SHIFT_REG ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp29649_i480_stall_local;
wire [31:0] local_bb2_cmp29649_i480;

assign local_bb2_cmp29649_i480[31:1] = 31'h0;
assign local_bb2_cmp29649_i480[0] = rnode_8to9_bb2_cmp296_i476_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_conv300_i478_stall_local;
wire [31:0] local_bb2_conv300_i478;

assign local_bb2_conv300_i478[31:1] = 31'h0;
assign local_bb2_conv300_i478[0] = rnode_8to9_bb2_cmp299_i477_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_notlhs_i454_stall_local;
wire local_bb2_notlhs_i454;

assign local_bb2_notlhs_i454 = (local_bb2_and247_i451 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or274_i466_stall_local;
wire [31:0] local_bb2_or274_i466;

assign local_bb2_or274_i466 = (local_bb2_and272_i463 | local_bb2_shl273_i465);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge12_i446_stall_local;
wire local_bb2_brmerge12_i446;

assign local_bb2_brmerge12_i446 = (local_bb2_cmp226_not_i445 | rnode_8to9_bb2_not_cmp37_i438_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot262__i459_stall_local;
wire local_bb2_lnot262__i459;

assign local_bb2_lnot262__i459 = (local_bb2_cmp258_i458 & local_bb2_cmp226_not_i445);

// This section implements an unregistered operation.
// 
wire local_bb2_not__46_i456_stall_local;
wire local_bb2_not__46_i456;

assign local_bb2_not__46_i456 = (rnode_8to9_bb2_notrhs_i455_0_NO_SHIFT_REG | local_bb2_notlhs_i454);

// This section implements an unregistered operation.
// 
wire local_bb2_resultSign_0_i447_stall_local;
wire [31:0] local_bb2_resultSign_0_i447;

assign local_bb2_resultSign_0_i447 = (local_bb2_brmerge12_i446 ? rnode_8to9_bb2_and35_i330_0_NO_SHIFT_REG : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or2662_i460_stall_local;
wire local_bb2_or2662_i460;

assign local_bb2_or2662_i460 = (rnode_8to9_bb2_var__u17_0_NO_SHIFT_REG | local_bb2_lnot262__i459);

// This section implements an unregistered operation.
// 
wire local_bb2__47_i457_stall_local;
wire local_bb2__47_i457;

assign local_bb2__47_i457 = (rnode_8to9_bb2_cmp226_i444_1_NO_SHIFT_REG | local_bb2_not__46_i456);

// This section implements an unregistered operation.
// 
wire local_bb2_or275_i467_stall_local;
wire [31:0] local_bb2_or275_i467;

assign local_bb2_or275_i467 = (local_bb2_or274_i466 | local_bb2_resultSign_0_i447);

// This section implements an unregistered operation.
// 
wire local_bb2_or2875_i470_stall_local;
wire local_bb2_or2875_i470;

assign local_bb2_or2875_i470 = (local_bb2_or2662_i460 | rnode_8to9_bb2__26_i345_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u23_stall_local;
wire [31:0] local_bb2_var__u23;

assign local_bb2_var__u23[31:1] = 31'h0;
assign local_bb2_var__u23[0] = local_bb2_or2662_i460;

// This section implements an unregistered operation.
// 
wire local_bb2_or2804_i468_stall_local;
wire local_bb2_or2804_i468;

assign local_bb2_or2804_i468 = (local_bb2__47_i457 | local_bb2_or2662_i460);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u24_stall_local;
wire [31:0] local_bb2_var__u24;

assign local_bb2_var__u24[31:1] = 31'h0;
assign local_bb2_var__u24[0] = local_bb2__47_i457;

// This section implements an unregistered operation.
// 
wire local_bb2_cond289_i471_stall_local;
wire [31:0] local_bb2_cond289_i471;

assign local_bb2_cond289_i471 = (local_bb2_or2875_i470 ? 32'h7F800000 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_ext310_i483_stall_local;
wire [31:0] local_bb2_lnot_ext310_i483;

assign local_bb2_lnot_ext310_i483 = (local_bb2_var__u23 ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_cond282_i469_stall_local;
wire [31:0] local_bb2_cond282_i469;

assign local_bb2_cond282_i469 = (local_bb2_or2804_i468 ? 32'h80000000 : 32'hFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_or294_i474_stall_local;
wire [31:0] local_bb2_or294_i474;

assign local_bb2_or294_i474 = (local_bb2_cond289_i471 | local_bb2_cond292_i472);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_0_i485_stall_local;
wire [31:0] local_bb2_reduction_0_i485;

assign local_bb2_reduction_0_i485 = (local_bb2_lnot_ext310_i483 & local_bb2_lnot_ext_i482);

// This section implements an unregistered operation.
// 
wire local_bb2_and293_i473_stall_local;
wire [31:0] local_bb2_and293_i473;

assign local_bb2_and293_i473 = (local_bb2_cond282_i469 & local_bb2_or275_i467);

// This section implements an unregistered operation.
// 
wire local_bb2_or295_i475_stall_local;
wire [31:0] local_bb2_or295_i475;

assign local_bb2_or295_i475 = (local_bb2_or294_i474 | local_bb2_and293_i473);

// This section implements an unregistered operation.
// 
wire local_bb2_and302_i479_stall_local;
wire [31:0] local_bb2_and302_i479;

assign local_bb2_and302_i479 = (local_bb2_conv300_i478 & local_bb2_and293_i473);

// This section implements an unregistered operation.
// 
wire local_bb2_or295_i475_valid_out;
wire local_bb2_or295_i475_stall_in;
 reg local_bb2_or295_i475_consumed_0_NO_SHIFT_REG;
wire local_bb2_var__u24_valid_out;
wire local_bb2_var__u24_stall_in;
 reg local_bb2_var__u24_consumed_0_NO_SHIFT_REG;
wire local_bb2_lor_ext_i481_valid_out;
wire local_bb2_lor_ext_i481_stall_in;
 reg local_bb2_lor_ext_i481_consumed_0_NO_SHIFT_REG;
wire local_bb2_reduction_0_i485_valid_out;
wire local_bb2_reduction_0_i485_stall_in;
 reg local_bb2_reduction_0_i485_consumed_0_NO_SHIFT_REG;
wire local_bb2_lor_ext_i481_inputs_ready;
wire local_bb2_lor_ext_i481_stall_local;
wire [31:0] local_bb2_lor_ext_i481;

assign local_bb2_lor_ext_i481_inputs_ready = (rnode_8to9_bb2_and35_i330_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb2_not_cmp37_i438_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb2_and269_i464_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb2_add245_i450_0_valid_out_1_NO_SHIFT_REG & rnode_8to9_bb2_var__u17_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb2__26_i345_0_valid_out_0_NO_SHIFT_REG & rnode_8to9_bb2__26_i345_0_valid_out_1_NO_SHIFT_REG & rnode_8to9_bb2_add245_i450_0_valid_out_0_NO_SHIFT_REG & rnode_8to9_bb2_notrhs_i455_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb2_cmp226_i444_0_valid_out_1_NO_SHIFT_REG & rnode_8to9_bb2_shr271_i462_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb2__26_i345_0_valid_out_2_NO_SHIFT_REG & rnode_8to9_bb2_cmp226_i444_0_valid_out_0_NO_SHIFT_REG & rnode_8to9_bb2_cmp296_i476_0_valid_out_NO_SHIFT_REG & rnode_8to9_bb2_cmp299_i477_0_valid_out_NO_SHIFT_REG);
assign local_bb2_lor_ext_i481 = (local_bb2_cmp29649_i480 | local_bb2_and302_i479);
assign local_bb2_or295_i475_valid_out = 1'b1;
assign local_bb2_var__u24_valid_out = 1'b1;
assign local_bb2_lor_ext_i481_valid_out = 1'b1;
assign local_bb2_reduction_0_i485_valid_out = 1'b1;
assign rnode_8to9_bb2_and35_i330_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_not_cmp37_i438_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_and269_i464_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_add245_i450_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_var__u17_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2__26_i345_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2__26_i345_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_add245_i450_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_notrhs_i455_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_cmp226_i444_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_shr271_i462_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2__26_i345_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_cmp226_i444_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_cmp296_i476_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_8to9_bb2_cmp299_i477_0_stall_in_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_or295_i475_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_var__u24_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_lor_ext_i481_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_reduction_0_i485_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_or295_i475_consumed_0_NO_SHIFT_REG <= (local_bb2_lor_ext_i481_inputs_ready & (local_bb2_or295_i475_consumed_0_NO_SHIFT_REG | ~(local_bb2_or295_i475_stall_in)) & local_bb2_lor_ext_i481_stall_local);
		local_bb2_var__u24_consumed_0_NO_SHIFT_REG <= (local_bb2_lor_ext_i481_inputs_ready & (local_bb2_var__u24_consumed_0_NO_SHIFT_REG | ~(local_bb2_var__u24_stall_in)) & local_bb2_lor_ext_i481_stall_local);
		local_bb2_lor_ext_i481_consumed_0_NO_SHIFT_REG <= (local_bb2_lor_ext_i481_inputs_ready & (local_bb2_lor_ext_i481_consumed_0_NO_SHIFT_REG | ~(local_bb2_lor_ext_i481_stall_in)) & local_bb2_lor_ext_i481_stall_local);
		local_bb2_reduction_0_i485_consumed_0_NO_SHIFT_REG <= (local_bb2_lor_ext_i481_inputs_ready & (local_bb2_reduction_0_i485_consumed_0_NO_SHIFT_REG | ~(local_bb2_reduction_0_i485_stall_in)) & local_bb2_lor_ext_i481_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_9to10_bb2_or295_i475_0_valid_out_NO_SHIFT_REG;
 logic rnode_9to10_bb2_or295_i475_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb2_or295_i475_0_NO_SHIFT_REG;
 logic rnode_9to10_bb2_or295_i475_0_reg_10_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb2_or295_i475_0_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb2_or295_i475_0_valid_out_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb2_or295_i475_0_stall_in_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb2_or295_i475_0_stall_out_reg_10_NO_SHIFT_REG;

acl_data_fifo rnode_9to10_bb2_or295_i475_0_reg_10_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_9to10_bb2_or295_i475_0_reg_10_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_9to10_bb2_or295_i475_0_stall_in_reg_10_NO_SHIFT_REG),
	.valid_out(rnode_9to10_bb2_or295_i475_0_valid_out_reg_10_NO_SHIFT_REG),
	.stall_out(rnode_9to10_bb2_or295_i475_0_stall_out_reg_10_NO_SHIFT_REG),
	.data_in(local_bb2_or295_i475),
	.data_out(rnode_9to10_bb2_or295_i475_0_reg_10_NO_SHIFT_REG)
);

defparam rnode_9to10_bb2_or295_i475_0_reg_10_fifo.DEPTH = 1;
defparam rnode_9to10_bb2_or295_i475_0_reg_10_fifo.DATA_WIDTH = 32;
defparam rnode_9to10_bb2_or295_i475_0_reg_10_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_9to10_bb2_or295_i475_0_reg_10_fifo.IMPL = "shift_reg";

assign rnode_9to10_bb2_or295_i475_0_reg_10_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_or295_i475_stall_in = 1'b0;
assign rnode_9to10_bb2_or295_i475_0_NO_SHIFT_REG = rnode_9to10_bb2_or295_i475_0_reg_10_NO_SHIFT_REG;
assign rnode_9to10_bb2_or295_i475_0_stall_in_reg_10_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb2_or295_i475_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_9to10_bb2_var__u24_0_valid_out_NO_SHIFT_REG;
 logic rnode_9to10_bb2_var__u24_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb2_var__u24_0_NO_SHIFT_REG;
 logic rnode_9to10_bb2_var__u24_0_reg_10_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb2_var__u24_0_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb2_var__u24_0_valid_out_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb2_var__u24_0_stall_in_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb2_var__u24_0_stall_out_reg_10_NO_SHIFT_REG;

acl_data_fifo rnode_9to10_bb2_var__u24_0_reg_10_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_9to10_bb2_var__u24_0_reg_10_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_9to10_bb2_var__u24_0_stall_in_reg_10_NO_SHIFT_REG),
	.valid_out(rnode_9to10_bb2_var__u24_0_valid_out_reg_10_NO_SHIFT_REG),
	.stall_out(rnode_9to10_bb2_var__u24_0_stall_out_reg_10_NO_SHIFT_REG),
	.data_in(local_bb2_var__u24),
	.data_out(rnode_9to10_bb2_var__u24_0_reg_10_NO_SHIFT_REG)
);

defparam rnode_9to10_bb2_var__u24_0_reg_10_fifo.DEPTH = 1;
defparam rnode_9to10_bb2_var__u24_0_reg_10_fifo.DATA_WIDTH = 32;
defparam rnode_9to10_bb2_var__u24_0_reg_10_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_9to10_bb2_var__u24_0_reg_10_fifo.IMPL = "shift_reg";

assign rnode_9to10_bb2_var__u24_0_reg_10_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_var__u24_stall_in = 1'b0;
assign rnode_9to10_bb2_var__u24_0_NO_SHIFT_REG = rnode_9to10_bb2_var__u24_0_reg_10_NO_SHIFT_REG;
assign rnode_9to10_bb2_var__u24_0_stall_in_reg_10_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb2_var__u24_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_9to10_bb2_lor_ext_i481_0_valid_out_NO_SHIFT_REG;
 logic rnode_9to10_bb2_lor_ext_i481_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb2_lor_ext_i481_0_NO_SHIFT_REG;
 logic rnode_9to10_bb2_lor_ext_i481_0_reg_10_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb2_lor_ext_i481_0_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb2_lor_ext_i481_0_valid_out_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb2_lor_ext_i481_0_stall_in_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb2_lor_ext_i481_0_stall_out_reg_10_NO_SHIFT_REG;

acl_data_fifo rnode_9to10_bb2_lor_ext_i481_0_reg_10_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_9to10_bb2_lor_ext_i481_0_reg_10_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_9to10_bb2_lor_ext_i481_0_stall_in_reg_10_NO_SHIFT_REG),
	.valid_out(rnode_9to10_bb2_lor_ext_i481_0_valid_out_reg_10_NO_SHIFT_REG),
	.stall_out(rnode_9to10_bb2_lor_ext_i481_0_stall_out_reg_10_NO_SHIFT_REG),
	.data_in(local_bb2_lor_ext_i481),
	.data_out(rnode_9to10_bb2_lor_ext_i481_0_reg_10_NO_SHIFT_REG)
);

defparam rnode_9to10_bb2_lor_ext_i481_0_reg_10_fifo.DEPTH = 1;
defparam rnode_9to10_bb2_lor_ext_i481_0_reg_10_fifo.DATA_WIDTH = 32;
defparam rnode_9to10_bb2_lor_ext_i481_0_reg_10_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_9to10_bb2_lor_ext_i481_0_reg_10_fifo.IMPL = "shift_reg";

assign rnode_9to10_bb2_lor_ext_i481_0_reg_10_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_lor_ext_i481_stall_in = 1'b0;
assign rnode_9to10_bb2_lor_ext_i481_0_NO_SHIFT_REG = rnode_9to10_bb2_lor_ext_i481_0_reg_10_NO_SHIFT_REG;
assign rnode_9to10_bb2_lor_ext_i481_0_stall_in_reg_10_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb2_lor_ext_i481_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_9to10_bb2_reduction_0_i485_0_valid_out_NO_SHIFT_REG;
 logic rnode_9to10_bb2_reduction_0_i485_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb2_reduction_0_i485_0_NO_SHIFT_REG;
 logic rnode_9to10_bb2_reduction_0_i485_0_reg_10_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_9to10_bb2_reduction_0_i485_0_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb2_reduction_0_i485_0_valid_out_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb2_reduction_0_i485_0_stall_in_reg_10_NO_SHIFT_REG;
 logic rnode_9to10_bb2_reduction_0_i485_0_stall_out_reg_10_NO_SHIFT_REG;

acl_data_fifo rnode_9to10_bb2_reduction_0_i485_0_reg_10_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_9to10_bb2_reduction_0_i485_0_reg_10_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_9to10_bb2_reduction_0_i485_0_stall_in_reg_10_NO_SHIFT_REG),
	.valid_out(rnode_9to10_bb2_reduction_0_i485_0_valid_out_reg_10_NO_SHIFT_REG),
	.stall_out(rnode_9to10_bb2_reduction_0_i485_0_stall_out_reg_10_NO_SHIFT_REG),
	.data_in(local_bb2_reduction_0_i485),
	.data_out(rnode_9to10_bb2_reduction_0_i485_0_reg_10_NO_SHIFT_REG)
);

defparam rnode_9to10_bb2_reduction_0_i485_0_reg_10_fifo.DEPTH = 1;
defparam rnode_9to10_bb2_reduction_0_i485_0_reg_10_fifo.DATA_WIDTH = 32;
defparam rnode_9to10_bb2_reduction_0_i485_0_reg_10_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_9to10_bb2_reduction_0_i485_0_reg_10_fifo.IMPL = "shift_reg";

assign rnode_9to10_bb2_reduction_0_i485_0_reg_10_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_reduction_0_i485_stall_in = 1'b0;
assign rnode_9to10_bb2_reduction_0_i485_0_NO_SHIFT_REG = rnode_9to10_bb2_reduction_0_i485_0_reg_10_NO_SHIFT_REG;
assign rnode_9to10_bb2_reduction_0_i485_0_stall_in_reg_10_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb2_reduction_0_i485_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_ext314_i484_stall_local;
wire [31:0] local_bb2_lnot_ext314_i484;

assign local_bb2_lnot_ext314_i484 = (rnode_9to10_bb2_var__u24_0_NO_SHIFT_REG ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_1_i486_stall_local;
wire [31:0] local_bb2_reduction_1_i486;

assign local_bb2_reduction_1_i486 = (local_bb2_lnot_ext314_i484 & rnode_9to10_bb2_lor_ext_i481_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_2_i487_stall_local;
wire [31:0] local_bb2_reduction_2_i487;

assign local_bb2_reduction_2_i487 = (rnode_9to10_bb2_reduction_0_i485_0_NO_SHIFT_REG & local_bb2_reduction_1_i486);

// This section implements an unregistered operation.
// 
wire local_bb2_add320_i488_stall_local;
wire [31:0] local_bb2_add320_i488;

assign local_bb2_add320_i488 = (local_bb2_reduction_2_i487 + rnode_9to10_bb2_or295_i475_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_shr_i280_stall_local;
wire [31:0] local_bb2_shr_i280;

assign local_bb2_shr_i280 = (local_bb2_add320_i488 >> 32'h17);

// This section implements an unregistered operation.
// 
wire local_bb2_and4_i_stall_local;
wire [31:0] local_bb2_and4_i;

assign local_bb2_and4_i = (local_bb2_add320_i488 & 32'h80000000);

// This section implements an unregistered operation.
// 
wire local_bb2_and5_i_stall_local;
wire [31:0] local_bb2_and5_i;

assign local_bb2_and5_i = (local_bb2_add320_i488 & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot14_not_i_stall_local;
wire local_bb2_lnot14_not_i;

assign local_bb2_lnot14_not_i = (local_bb2_and5_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or_i291_stall_local;
wire [31:0] local_bb2_or_i291;

assign local_bb2_or_i291 = (local_bb2_and5_i | 32'h800000);

// This section implements an unregistered operation.
// 
wire local_bb2_shr_i280_valid_out;
wire local_bb2_shr_i280_stall_in;
 reg local_bb2_shr_i280_consumed_0_NO_SHIFT_REG;
wire local_bb2_and4_i_valid_out;
wire local_bb2_and4_i_stall_in;
 reg local_bb2_and4_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_lnot14_not_i_valid_out;
wire local_bb2_lnot14_not_i_stall_in;
 reg local_bb2_lnot14_not_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_conv_i_i_valid_out;
wire local_bb2_conv_i_i_stall_in;
 reg local_bb2_conv_i_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_conv_i_i_inputs_ready;
wire local_bb2_conv_i_i_stall_local;
wire [63:0] local_bb2_conv_i_i;

assign local_bb2_conv_i_i_inputs_ready = (rnode_9to10_bb2_or295_i475_0_valid_out_NO_SHIFT_REG & rnode_9to10_bb2_reduction_0_i485_0_valid_out_NO_SHIFT_REG & rnode_9to10_bb2_var__u24_0_valid_out_NO_SHIFT_REG & rnode_9to10_bb2_lor_ext_i481_0_valid_out_NO_SHIFT_REG);
assign local_bb2_conv_i_i[63:32] = 32'h0;
assign local_bb2_conv_i_i[31:0] = local_bb2_or_i291;
assign local_bb2_shr_i280_valid_out = 1'b1;
assign local_bb2_and4_i_valid_out = 1'b1;
assign local_bb2_lnot14_not_i_valid_out = 1'b1;
assign local_bb2_conv_i_i_valid_out = 1'b1;
assign rnode_9to10_bb2_or295_i475_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb2_reduction_0_i485_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb2_var__u24_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_9to10_bb2_lor_ext_i481_0_stall_in_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_shr_i280_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_and4_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_lnot14_not_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_conv_i_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_shr_i280_consumed_0_NO_SHIFT_REG <= (local_bb2_conv_i_i_inputs_ready & (local_bb2_shr_i280_consumed_0_NO_SHIFT_REG | ~(local_bb2_shr_i280_stall_in)) & local_bb2_conv_i_i_stall_local);
		local_bb2_and4_i_consumed_0_NO_SHIFT_REG <= (local_bb2_conv_i_i_inputs_ready & (local_bb2_and4_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_and4_i_stall_in)) & local_bb2_conv_i_i_stall_local);
		local_bb2_lnot14_not_i_consumed_0_NO_SHIFT_REG <= (local_bb2_conv_i_i_inputs_ready & (local_bb2_lnot14_not_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_lnot14_not_i_stall_in)) & local_bb2_conv_i_i_stall_local);
		local_bb2_conv_i_i_consumed_0_NO_SHIFT_REG <= (local_bb2_conv_i_i_inputs_ready & (local_bb2_conv_i_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_conv_i_i_stall_in)) & local_bb2_conv_i_i_stall_local);
	end
end


// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_10to12_bb2_shr_i280_0_valid_out_NO_SHIFT_REG;
 logic rnode_10to12_bb2_shr_i280_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_10to12_bb2_shr_i280_0_NO_SHIFT_REG;
 logic rnode_10to12_bb2_shr_i280_0_reg_12_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_10to12_bb2_shr_i280_0_reg_12_NO_SHIFT_REG;
 logic rnode_10to12_bb2_shr_i280_0_valid_out_reg_12_NO_SHIFT_REG;
 logic rnode_10to12_bb2_shr_i280_0_stall_in_reg_12_NO_SHIFT_REG;
 logic rnode_10to12_bb2_shr_i280_0_stall_out_reg_12_NO_SHIFT_REG;

acl_data_fifo rnode_10to12_bb2_shr_i280_0_reg_12_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_10to12_bb2_shr_i280_0_reg_12_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_10to12_bb2_shr_i280_0_stall_in_reg_12_NO_SHIFT_REG),
	.valid_out(rnode_10to12_bb2_shr_i280_0_valid_out_reg_12_NO_SHIFT_REG),
	.stall_out(rnode_10to12_bb2_shr_i280_0_stall_out_reg_12_NO_SHIFT_REG),
	.data_in(local_bb2_shr_i280),
	.data_out(rnode_10to12_bb2_shr_i280_0_reg_12_NO_SHIFT_REG)
);

defparam rnode_10to12_bb2_shr_i280_0_reg_12_fifo.DEPTH = 2;
defparam rnode_10to12_bb2_shr_i280_0_reg_12_fifo.DATA_WIDTH = 32;
defparam rnode_10to12_bb2_shr_i280_0_reg_12_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_10to12_bb2_shr_i280_0_reg_12_fifo.IMPL = "shift_reg";

assign rnode_10to12_bb2_shr_i280_0_reg_12_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_shr_i280_stall_in = 1'b0;
assign rnode_10to12_bb2_shr_i280_0_NO_SHIFT_REG = rnode_10to12_bb2_shr_i280_0_reg_12_NO_SHIFT_REG;
assign rnode_10to12_bb2_shr_i280_0_stall_in_reg_12_NO_SHIFT_REG = 1'b0;
assign rnode_10to12_bb2_shr_i280_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_10to11_bb2_and4_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_10to11_bb2_and4_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_10to11_bb2_and4_i_0_NO_SHIFT_REG;
 logic rnode_10to11_bb2_and4_i_0_reg_11_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_10to11_bb2_and4_i_0_reg_11_NO_SHIFT_REG;
 logic rnode_10to11_bb2_and4_i_0_valid_out_reg_11_NO_SHIFT_REG;
 logic rnode_10to11_bb2_and4_i_0_stall_in_reg_11_NO_SHIFT_REG;
 logic rnode_10to11_bb2_and4_i_0_stall_out_reg_11_NO_SHIFT_REG;

acl_data_fifo rnode_10to11_bb2_and4_i_0_reg_11_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_10to11_bb2_and4_i_0_reg_11_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_10to11_bb2_and4_i_0_stall_in_reg_11_NO_SHIFT_REG),
	.valid_out(rnode_10to11_bb2_and4_i_0_valid_out_reg_11_NO_SHIFT_REG),
	.stall_out(rnode_10to11_bb2_and4_i_0_stall_out_reg_11_NO_SHIFT_REG),
	.data_in(local_bb2_and4_i),
	.data_out(rnode_10to11_bb2_and4_i_0_reg_11_NO_SHIFT_REG)
);

defparam rnode_10to11_bb2_and4_i_0_reg_11_fifo.DEPTH = 1;
defparam rnode_10to11_bb2_and4_i_0_reg_11_fifo.DATA_WIDTH = 32;
defparam rnode_10to11_bb2_and4_i_0_reg_11_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_10to11_bb2_and4_i_0_reg_11_fifo.IMPL = "shift_reg";

assign rnode_10to11_bb2_and4_i_0_reg_11_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and4_i_stall_in = 1'b0;
assign rnode_10to11_bb2_and4_i_0_NO_SHIFT_REG = rnode_10to11_bb2_and4_i_0_reg_11_NO_SHIFT_REG;
assign rnode_10to11_bb2_and4_i_0_stall_in_reg_11_NO_SHIFT_REG = 1'b0;
assign rnode_10to11_bb2_and4_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_10to11_bb2_lnot14_not_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_10to11_bb2_lnot14_not_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_10to11_bb2_lnot14_not_i_0_NO_SHIFT_REG;
 logic rnode_10to11_bb2_lnot14_not_i_0_reg_11_inputs_ready_NO_SHIFT_REG;
 logic rnode_10to11_bb2_lnot14_not_i_0_reg_11_NO_SHIFT_REG;
 logic rnode_10to11_bb2_lnot14_not_i_0_valid_out_reg_11_NO_SHIFT_REG;
 logic rnode_10to11_bb2_lnot14_not_i_0_stall_in_reg_11_NO_SHIFT_REG;
 logic rnode_10to11_bb2_lnot14_not_i_0_stall_out_reg_11_NO_SHIFT_REG;

acl_data_fifo rnode_10to11_bb2_lnot14_not_i_0_reg_11_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_10to11_bb2_lnot14_not_i_0_reg_11_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_10to11_bb2_lnot14_not_i_0_stall_in_reg_11_NO_SHIFT_REG),
	.valid_out(rnode_10to11_bb2_lnot14_not_i_0_valid_out_reg_11_NO_SHIFT_REG),
	.stall_out(rnode_10to11_bb2_lnot14_not_i_0_stall_out_reg_11_NO_SHIFT_REG),
	.data_in(local_bb2_lnot14_not_i),
	.data_out(rnode_10to11_bb2_lnot14_not_i_0_reg_11_NO_SHIFT_REG)
);

defparam rnode_10to11_bb2_lnot14_not_i_0_reg_11_fifo.DEPTH = 1;
defparam rnode_10to11_bb2_lnot14_not_i_0_reg_11_fifo.DATA_WIDTH = 1;
defparam rnode_10to11_bb2_lnot14_not_i_0_reg_11_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_10to11_bb2_lnot14_not_i_0_reg_11_fifo.IMPL = "shift_reg";

assign rnode_10to11_bb2_lnot14_not_i_0_reg_11_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_lnot14_not_i_stall_in = 1'b0;
assign rnode_10to11_bb2_lnot14_not_i_0_NO_SHIFT_REG = rnode_10to11_bb2_lnot14_not_i_0_reg_11_NO_SHIFT_REG;
assign rnode_10to11_bb2_lnot14_not_i_0_stall_in_reg_11_NO_SHIFT_REG = 1'b0;
assign rnode_10to11_bb2_lnot14_not_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements a registered operation.
// 
wire local_bb2_mul_i_i_inputs_ready;
 reg local_bb2_mul_i_i_valid_out_0_NO_SHIFT_REG;
wire local_bb2_mul_i_i_stall_in_0;
 reg local_bb2_mul_i_i_valid_out_1_NO_SHIFT_REG;
wire local_bb2_mul_i_i_stall_in_1;
wire local_bb2_mul_i_i_output_regs_ready;
wire [63:0] local_bb2_mul_i_i;
 reg local_bb2_mul_i_i_valid_pipe_0_NO_SHIFT_REG;
 reg local_bb2_mul_i_i_valid_pipe_1_NO_SHIFT_REG;
wire local_bb2_mul_i_i_causedstall;

acl_int_mult64s_s5 int_module_local_bb2_mul_i_i (
	.clock(clock),
	.dataa(local_bb2_conv_i_i),
	.datab(64'hD9999A),
	.enable(local_bb2_mul_i_i_output_regs_ready),
	.result(local_bb2_mul_i_i)
);

defparam int_module_local_bb2_mul_i_i.INPUT1_WIDTH = 24;
defparam int_module_local_bb2_mul_i_i.INPUT2_WIDTH = 24;

assign local_bb2_mul_i_i_inputs_ready = 1'b1;
assign local_bb2_mul_i_i_output_regs_ready = 1'b1;
assign local_bb2_conv_i_i_stall_in = 1'b0;
assign local_bb2_mul_i_i_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_mul_i_i_valid_pipe_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_mul_i_i_valid_pipe_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb2_mul_i_i_output_regs_ready)
		begin
			local_bb2_mul_i_i_valid_pipe_0_NO_SHIFT_REG <= 1'b1;
			local_bb2_mul_i_i_valid_pipe_1_NO_SHIFT_REG <= local_bb2_mul_i_i_valid_pipe_0_NO_SHIFT_REG;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_mul_i_i_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_mul_i_i_valid_out_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb2_mul_i_i_output_regs_ready)
		begin
			local_bb2_mul_i_i_valid_out_0_NO_SHIFT_REG <= 1'b1;
			local_bb2_mul_i_i_valid_out_1_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb2_mul_i_i_stall_in_0))
			begin
				local_bb2_mul_i_i_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb2_mul_i_i_stall_in_1))
			begin
				local_bb2_mul_i_i_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb2_and_i281_stall_local;
wire [31:0] local_bb2_and_i281;

assign local_bb2_and_i281 = (rnode_10to12_bb2_shr_i280_0_NO_SHIFT_REG & 32'hFF);

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_11to13_bb2_and4_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_11to13_bb2_and4_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_11to13_bb2_and4_i_0_NO_SHIFT_REG;
 logic rnode_11to13_bb2_and4_i_0_reg_13_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_11to13_bb2_and4_i_0_reg_13_NO_SHIFT_REG;
 logic rnode_11to13_bb2_and4_i_0_valid_out_reg_13_NO_SHIFT_REG;
 logic rnode_11to13_bb2_and4_i_0_stall_in_reg_13_NO_SHIFT_REG;
 logic rnode_11to13_bb2_and4_i_0_stall_out_reg_13_NO_SHIFT_REG;

acl_data_fifo rnode_11to13_bb2_and4_i_0_reg_13_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_11to13_bb2_and4_i_0_reg_13_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_11to13_bb2_and4_i_0_stall_in_reg_13_NO_SHIFT_REG),
	.valid_out(rnode_11to13_bb2_and4_i_0_valid_out_reg_13_NO_SHIFT_REG),
	.stall_out(rnode_11to13_bb2_and4_i_0_stall_out_reg_13_NO_SHIFT_REG),
	.data_in(rnode_10to11_bb2_and4_i_0_NO_SHIFT_REG),
	.data_out(rnode_11to13_bb2_and4_i_0_reg_13_NO_SHIFT_REG)
);

defparam rnode_11to13_bb2_and4_i_0_reg_13_fifo.DEPTH = 2;
defparam rnode_11to13_bb2_and4_i_0_reg_13_fifo.DATA_WIDTH = 32;
defparam rnode_11to13_bb2_and4_i_0_reg_13_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_11to13_bb2_and4_i_0_reg_13_fifo.IMPL = "shift_reg";

assign rnode_11to13_bb2_and4_i_0_reg_13_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_10to11_bb2_and4_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_11to13_bb2_and4_i_0_NO_SHIFT_REG = rnode_11to13_bb2_and4_i_0_reg_13_NO_SHIFT_REG;
assign rnode_11to13_bb2_and4_i_0_stall_in_reg_13_NO_SHIFT_REG = 1'b0;
assign rnode_11to13_bb2_and4_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_11to13_bb2_lnot14_not_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_11to13_bb2_lnot14_not_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_11to13_bb2_lnot14_not_i_0_NO_SHIFT_REG;
 logic rnode_11to13_bb2_lnot14_not_i_0_reg_13_inputs_ready_NO_SHIFT_REG;
 logic rnode_11to13_bb2_lnot14_not_i_0_reg_13_NO_SHIFT_REG;
 logic rnode_11to13_bb2_lnot14_not_i_0_valid_out_reg_13_NO_SHIFT_REG;
 logic rnode_11to13_bb2_lnot14_not_i_0_stall_in_reg_13_NO_SHIFT_REG;
 logic rnode_11to13_bb2_lnot14_not_i_0_stall_out_reg_13_NO_SHIFT_REG;

acl_data_fifo rnode_11to13_bb2_lnot14_not_i_0_reg_13_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_11to13_bb2_lnot14_not_i_0_reg_13_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_11to13_bb2_lnot14_not_i_0_stall_in_reg_13_NO_SHIFT_REG),
	.valid_out(rnode_11to13_bb2_lnot14_not_i_0_valid_out_reg_13_NO_SHIFT_REG),
	.stall_out(rnode_11to13_bb2_lnot14_not_i_0_stall_out_reg_13_NO_SHIFT_REG),
	.data_in(rnode_10to11_bb2_lnot14_not_i_0_NO_SHIFT_REG),
	.data_out(rnode_11to13_bb2_lnot14_not_i_0_reg_13_NO_SHIFT_REG)
);

defparam rnode_11to13_bb2_lnot14_not_i_0_reg_13_fifo.DEPTH = 2;
defparam rnode_11to13_bb2_lnot14_not_i_0_reg_13_fifo.DATA_WIDTH = 1;
defparam rnode_11to13_bb2_lnot14_not_i_0_reg_13_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_11to13_bb2_lnot14_not_i_0_reg_13_fifo.IMPL = "shift_reg";

assign rnode_11to13_bb2_lnot14_not_i_0_reg_13_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_10to11_bb2_lnot14_not_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_11to13_bb2_lnot14_not_i_0_NO_SHIFT_REG = rnode_11to13_bb2_lnot14_not_i_0_reg_13_NO_SHIFT_REG;
assign rnode_11to13_bb2_lnot14_not_i_0_stall_in_reg_13_NO_SHIFT_REG = 1'b0;
assign rnode_11to13_bb2_lnot14_not_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_conv3_i_i_stall_local;
wire [31:0] local_bb2_conv3_i_i;

assign local_bb2_conv3_i_i = local_bb2_mul_i_i[31:0];

// This section implements an unregistered operation.
// 
wire local_bb2_var__u25_stall_local;
wire [63:0] local_bb2_var__u25;

assign local_bb2_var__u25 = (local_bb2_mul_i_i >> 64'h18);

// This section implements an unregistered operation.
// 
wire local_bb2_and_i281_valid_out_1;
wire local_bb2_and_i281_stall_in_1;
 reg local_bb2_and_i281_consumed_1_NO_SHIFT_REG;
wire local_bb2_add_i292_valid_out;
wire local_bb2_add_i292_stall_in;
 reg local_bb2_add_i292_consumed_0_NO_SHIFT_REG;
wire local_bb2_add_i292_inputs_ready;
wire local_bb2_add_i292_stall_local;
wire [31:0] local_bb2_add_i292;

assign local_bb2_add_i292_inputs_ready = rnode_10to12_bb2_shr_i280_0_valid_out_NO_SHIFT_REG;
assign local_bb2_add_i292 = (local_bb2_and_i281 + 32'h7E);
assign local_bb2_and_i281_valid_out_1 = 1'b1;
assign local_bb2_add_i292_valid_out = 1'b1;
assign rnode_10to12_bb2_shr_i280_0_stall_in_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_and_i281_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb2_add_i292_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_and_i281_consumed_1_NO_SHIFT_REG <= (local_bb2_add_i292_inputs_ready & (local_bb2_and_i281_consumed_1_NO_SHIFT_REG | ~(local_bb2_and_i281_stall_in_1)) & local_bb2_add_i292_stall_local);
		local_bb2_add_i292_consumed_0_NO_SHIFT_REG <= (local_bb2_add_i292_inputs_ready & (local_bb2_add_i292_consumed_0_NO_SHIFT_REG | ~(local_bb2_add_i292_stall_in)) & local_bb2_add_i292_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_13to14_bb2_and4_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_13to14_bb2_and4_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_13to14_bb2_and4_i_0_NO_SHIFT_REG;
 logic rnode_13to14_bb2_and4_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_13to14_bb2_and4_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_13to14_bb2_and4_i_1_NO_SHIFT_REG;
 logic rnode_13to14_bb2_and4_i_0_reg_14_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_13to14_bb2_and4_i_0_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_and4_i_0_valid_out_0_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_and4_i_0_stall_in_0_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_and4_i_0_stall_out_reg_14_NO_SHIFT_REG;

acl_data_fifo rnode_13to14_bb2_and4_i_0_reg_14_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_13to14_bb2_and4_i_0_reg_14_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_13to14_bb2_and4_i_0_stall_in_0_reg_14_NO_SHIFT_REG),
	.valid_out(rnode_13to14_bb2_and4_i_0_valid_out_0_reg_14_NO_SHIFT_REG),
	.stall_out(rnode_13to14_bb2_and4_i_0_stall_out_reg_14_NO_SHIFT_REG),
	.data_in(rnode_11to13_bb2_and4_i_0_NO_SHIFT_REG),
	.data_out(rnode_13to14_bb2_and4_i_0_reg_14_NO_SHIFT_REG)
);

defparam rnode_13to14_bb2_and4_i_0_reg_14_fifo.DEPTH = 1;
defparam rnode_13to14_bb2_and4_i_0_reg_14_fifo.DATA_WIDTH = 32;
defparam rnode_13to14_bb2_and4_i_0_reg_14_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_13to14_bb2_and4_i_0_reg_14_fifo.IMPL = "shift_reg";

assign rnode_13to14_bb2_and4_i_0_reg_14_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_11to13_bb2_and4_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2_and4_i_0_stall_in_0_reg_14_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2_and4_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_13to14_bb2_and4_i_0_NO_SHIFT_REG = rnode_13to14_bb2_and4_i_0_reg_14_NO_SHIFT_REG;
assign rnode_13to14_bb2_and4_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_13to14_bb2_and4_i_1_NO_SHIFT_REG = rnode_13to14_bb2_and4_i_0_reg_14_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_13to14_bb2_lnot14_not_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_13to14_bb2_lnot14_not_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_13to14_bb2_lnot14_not_i_0_NO_SHIFT_REG;
 logic rnode_13to14_bb2_lnot14_not_i_0_reg_14_inputs_ready_NO_SHIFT_REG;
 logic rnode_13to14_bb2_lnot14_not_i_0_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_lnot14_not_i_0_valid_out_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_lnot14_not_i_0_stall_in_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_lnot14_not_i_0_stall_out_reg_14_NO_SHIFT_REG;

acl_data_fifo rnode_13to14_bb2_lnot14_not_i_0_reg_14_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_13to14_bb2_lnot14_not_i_0_reg_14_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_13to14_bb2_lnot14_not_i_0_stall_in_reg_14_NO_SHIFT_REG),
	.valid_out(rnode_13to14_bb2_lnot14_not_i_0_valid_out_reg_14_NO_SHIFT_REG),
	.stall_out(rnode_13to14_bb2_lnot14_not_i_0_stall_out_reg_14_NO_SHIFT_REG),
	.data_in(rnode_11to13_bb2_lnot14_not_i_0_NO_SHIFT_REG),
	.data_out(rnode_13to14_bb2_lnot14_not_i_0_reg_14_NO_SHIFT_REG)
);

defparam rnode_13to14_bb2_lnot14_not_i_0_reg_14_fifo.DEPTH = 1;
defparam rnode_13to14_bb2_lnot14_not_i_0_reg_14_fifo.DATA_WIDTH = 1;
defparam rnode_13to14_bb2_lnot14_not_i_0_reg_14_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_13to14_bb2_lnot14_not_i_0_reg_14_fifo.IMPL = "shift_reg";

assign rnode_13to14_bb2_lnot14_not_i_0_reg_14_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_11to13_bb2_lnot14_not_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2_lnot14_not_i_0_NO_SHIFT_REG = rnode_13to14_bb2_lnot14_not_i_0_reg_14_NO_SHIFT_REG;
assign rnode_13to14_bb2_lnot14_not_i_0_stall_in_reg_14_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2_lnot14_not_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_shr_i16_i_stall_local;
wire [31:0] local_bb2_shr_i16_i;

assign local_bb2_shr_i16_i = (local_bb2_conv3_i_i >> 32'h18);

// This section implements an unregistered operation.
// 
wire local_bb2_shl1_i18_i_stall_local;
wire [31:0] local_bb2_shl1_i18_i;

assign local_bb2_shl1_i18_i = (local_bb2_conv3_i_i << 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u26_stall_local;
wire [31:0] local_bb2_var__u26;

assign local_bb2_var__u26 = (local_bb2_conv3_i_i >> 32'h17);

// This section implements an unregistered operation.
// 
wire local_bb2_shl1_i_i_stall_local;
wire [31:0] local_bb2_shl1_i_i;

assign local_bb2_shl1_i_i = (local_bb2_conv3_i_i << 32'h9);

// This section implements an unregistered operation.
// 
wire local_bb2__tr_i_stall_local;
wire [31:0] local_bb2__tr_i;

assign local_bb2__tr_i = local_bb2_var__u25[31:0];

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_12to13_bb2_and_i281_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_12to13_bb2_and_i281_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_12to13_bb2_and_i281_0_NO_SHIFT_REG;
 logic rnode_12to13_bb2_and_i281_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_12to13_bb2_and_i281_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_12to13_bb2_and_i281_1_NO_SHIFT_REG;
 logic rnode_12to13_bb2_and_i281_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_12to13_bb2_and_i281_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_12to13_bb2_and_i281_2_NO_SHIFT_REG;
 logic rnode_12to13_bb2_and_i281_0_reg_13_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_12to13_bb2_and_i281_0_reg_13_NO_SHIFT_REG;
 logic rnode_12to13_bb2_and_i281_0_valid_out_0_reg_13_NO_SHIFT_REG;
 logic rnode_12to13_bb2_and_i281_0_stall_in_0_reg_13_NO_SHIFT_REG;
 logic rnode_12to13_bb2_and_i281_0_stall_out_reg_13_NO_SHIFT_REG;

acl_data_fifo rnode_12to13_bb2_and_i281_0_reg_13_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_12to13_bb2_and_i281_0_reg_13_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_12to13_bb2_and_i281_0_stall_in_0_reg_13_NO_SHIFT_REG),
	.valid_out(rnode_12to13_bb2_and_i281_0_valid_out_0_reg_13_NO_SHIFT_REG),
	.stall_out(rnode_12to13_bb2_and_i281_0_stall_out_reg_13_NO_SHIFT_REG),
	.data_in(local_bb2_and_i281),
	.data_out(rnode_12to13_bb2_and_i281_0_reg_13_NO_SHIFT_REG)
);

defparam rnode_12to13_bb2_and_i281_0_reg_13_fifo.DEPTH = 1;
defparam rnode_12to13_bb2_and_i281_0_reg_13_fifo.DATA_WIDTH = 32;
defparam rnode_12to13_bb2_and_i281_0_reg_13_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_12to13_bb2_and_i281_0_reg_13_fifo.IMPL = "shift_reg";

assign rnode_12to13_bb2_and_i281_0_reg_13_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and_i281_stall_in_1 = 1'b0;
assign rnode_12to13_bb2_and_i281_0_stall_in_0_reg_13_NO_SHIFT_REG = 1'b0;
assign rnode_12to13_bb2_and_i281_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_12to13_bb2_and_i281_0_NO_SHIFT_REG = rnode_12to13_bb2_and_i281_0_reg_13_NO_SHIFT_REG;
assign rnode_12to13_bb2_and_i281_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_12to13_bb2_and_i281_1_NO_SHIFT_REG = rnode_12to13_bb2_and_i281_0_reg_13_NO_SHIFT_REG;
assign rnode_12to13_bb2_and_i281_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_12to13_bb2_and_i281_2_NO_SHIFT_REG = rnode_12to13_bb2_and_i281_0_reg_13_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_12to13_bb2_add_i292_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_12to13_bb2_add_i292_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_12to13_bb2_add_i292_0_NO_SHIFT_REG;
 logic rnode_12to13_bb2_add_i292_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_12to13_bb2_add_i292_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_12to13_bb2_add_i292_1_NO_SHIFT_REG;
 logic rnode_12to13_bb2_add_i292_0_reg_13_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_12to13_bb2_add_i292_0_reg_13_NO_SHIFT_REG;
 logic rnode_12to13_bb2_add_i292_0_valid_out_0_reg_13_NO_SHIFT_REG;
 logic rnode_12to13_bb2_add_i292_0_stall_in_0_reg_13_NO_SHIFT_REG;
 logic rnode_12to13_bb2_add_i292_0_stall_out_reg_13_NO_SHIFT_REG;

acl_data_fifo rnode_12to13_bb2_add_i292_0_reg_13_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_12to13_bb2_add_i292_0_reg_13_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_12to13_bb2_add_i292_0_stall_in_0_reg_13_NO_SHIFT_REG),
	.valid_out(rnode_12to13_bb2_add_i292_0_valid_out_0_reg_13_NO_SHIFT_REG),
	.stall_out(rnode_12to13_bb2_add_i292_0_stall_out_reg_13_NO_SHIFT_REG),
	.data_in(local_bb2_add_i292),
	.data_out(rnode_12to13_bb2_add_i292_0_reg_13_NO_SHIFT_REG)
);

defparam rnode_12to13_bb2_add_i292_0_reg_13_fifo.DEPTH = 1;
defparam rnode_12to13_bb2_add_i292_0_reg_13_fifo.DATA_WIDTH = 32;
defparam rnode_12to13_bb2_add_i292_0_reg_13_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_12to13_bb2_add_i292_0_reg_13_fifo.IMPL = "shift_reg";

assign rnode_12to13_bb2_add_i292_0_reg_13_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_add_i292_stall_in = 1'b0;
assign rnode_12to13_bb2_add_i292_0_stall_in_0_reg_13_NO_SHIFT_REG = 1'b0;
assign rnode_12to13_bb2_add_i292_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_12to13_bb2_add_i292_0_NO_SHIFT_REG = rnode_12to13_bb2_add_i292_0_reg_13_NO_SHIFT_REG;
assign rnode_12to13_bb2_add_i292_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_12to13_bb2_add_i292_1_NO_SHIFT_REG = rnode_12to13_bb2_add_i292_0_reg_13_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_shr_i_i293_stall_local;
wire [31:0] local_bb2_shr_i_i293;

assign local_bb2_shr_i_i293 = (local_bb2_var__u26 & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_shl_i15_i_stall_local;
wire [31:0] local_bb2_shl_i15_i;

assign local_bb2_shl_i15_i = (local_bb2__tr_i & 32'hFFFF00);

// This section implements an unregistered operation.
// 
wire local_bb2_and48_i_stall_local;
wire [31:0] local_bb2_and48_i;

assign local_bb2_and48_i = (local_bb2__tr_i & 32'h800000);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_i283_valid_out;
wire local_bb2_lnot_i283_stall_in;
wire local_bb2_lnot_i283_inputs_ready;
wire local_bb2_lnot_i283_stall_local;
wire local_bb2_lnot_i283;

assign local_bb2_lnot_i283_inputs_ready = rnode_12to13_bb2_and_i281_0_valid_out_0_NO_SHIFT_REG;
assign local_bb2_lnot_i283 = (rnode_12to13_bb2_and_i281_0_NO_SHIFT_REG == 32'h0);
assign local_bb2_lnot_i283_valid_out = 1'b1;
assign rnode_12to13_bb2_and_i281_0_stall_in_0_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_cmp_i284_valid_out;
wire local_bb2_cmp_i284_stall_in;
wire local_bb2_cmp_i284_inputs_ready;
wire local_bb2_cmp_i284_stall_local;
wire local_bb2_cmp_i284;

assign local_bb2_cmp_i284_inputs_ready = rnode_12to13_bb2_and_i281_0_valid_out_1_NO_SHIFT_REG;
assign local_bb2_cmp_i284 = (rnode_12to13_bb2_and_i281_1_NO_SHIFT_REG == 32'hFF);
assign local_bb2_cmp_i284_valid_out = 1'b1;
assign rnode_12to13_bb2_and_i281_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_inc_i_stall_local;
wire [31:0] local_bb2_inc_i;

assign local_bb2_inc_i = (rnode_12to13_bb2_and_i281_2_NO_SHIFT_REG + 32'h7F);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp50_not_i_stall_local;
wire local_bb2_cmp50_not_i;

assign local_bb2_cmp50_not_i = (rnode_12to13_bb2_add_i292_0_NO_SHIFT_REG != 32'h7F);

// This section implements an unregistered operation.
// 
wire local_bb2_or_i17_i_stall_local;
wire [31:0] local_bb2_or_i17_i;

assign local_bb2_or_i17_i = (local_bb2_shl_i15_i | local_bb2_shr_i16_i);

// This section implements an unregistered operation.
// 
wire local_bb2_tobool49_i_stall_local;
wire local_bb2_tobool49_i;

assign local_bb2_tobool49_i = (local_bb2_and48_i == 32'h0);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_13to14_bb2_lnot_i283_0_valid_out_NO_SHIFT_REG;
 logic rnode_13to14_bb2_lnot_i283_0_stall_in_NO_SHIFT_REG;
 logic rnode_13to14_bb2_lnot_i283_0_NO_SHIFT_REG;
 logic rnode_13to14_bb2_lnot_i283_0_reg_14_inputs_ready_NO_SHIFT_REG;
 logic rnode_13to14_bb2_lnot_i283_0_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_lnot_i283_0_valid_out_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_lnot_i283_0_stall_in_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_lnot_i283_0_stall_out_reg_14_NO_SHIFT_REG;

acl_data_fifo rnode_13to14_bb2_lnot_i283_0_reg_14_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_13to14_bb2_lnot_i283_0_reg_14_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_13to14_bb2_lnot_i283_0_stall_in_reg_14_NO_SHIFT_REG),
	.valid_out(rnode_13to14_bb2_lnot_i283_0_valid_out_reg_14_NO_SHIFT_REG),
	.stall_out(rnode_13to14_bb2_lnot_i283_0_stall_out_reg_14_NO_SHIFT_REG),
	.data_in(local_bb2_lnot_i283),
	.data_out(rnode_13to14_bb2_lnot_i283_0_reg_14_NO_SHIFT_REG)
);

defparam rnode_13to14_bb2_lnot_i283_0_reg_14_fifo.DEPTH = 1;
defparam rnode_13to14_bb2_lnot_i283_0_reg_14_fifo.DATA_WIDTH = 1;
defparam rnode_13to14_bb2_lnot_i283_0_reg_14_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_13to14_bb2_lnot_i283_0_reg_14_fifo.IMPL = "shift_reg";

assign rnode_13to14_bb2_lnot_i283_0_reg_14_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_lnot_i283_stall_in = 1'b0;
assign rnode_13to14_bb2_lnot_i283_0_NO_SHIFT_REG = rnode_13to14_bb2_lnot_i283_0_reg_14_NO_SHIFT_REG;
assign rnode_13to14_bb2_lnot_i283_0_stall_in_reg_14_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2_lnot_i283_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_13to14_bb2_cmp_i284_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp_i284_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp_i284_0_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp_i284_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp_i284_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp_i284_1_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp_i284_0_reg_14_inputs_ready_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp_i284_0_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp_i284_0_valid_out_0_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp_i284_0_stall_in_0_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp_i284_0_stall_out_reg_14_NO_SHIFT_REG;

acl_data_fifo rnode_13to14_bb2_cmp_i284_0_reg_14_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_13to14_bb2_cmp_i284_0_reg_14_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_13to14_bb2_cmp_i284_0_stall_in_0_reg_14_NO_SHIFT_REG),
	.valid_out(rnode_13to14_bb2_cmp_i284_0_valid_out_0_reg_14_NO_SHIFT_REG),
	.stall_out(rnode_13to14_bb2_cmp_i284_0_stall_out_reg_14_NO_SHIFT_REG),
	.data_in(local_bb2_cmp_i284),
	.data_out(rnode_13to14_bb2_cmp_i284_0_reg_14_NO_SHIFT_REG)
);

defparam rnode_13to14_bb2_cmp_i284_0_reg_14_fifo.DEPTH = 1;
defparam rnode_13to14_bb2_cmp_i284_0_reg_14_fifo.DATA_WIDTH = 1;
defparam rnode_13to14_bb2_cmp_i284_0_reg_14_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_13to14_bb2_cmp_i284_0_reg_14_fifo.IMPL = "shift_reg";

assign rnode_13to14_bb2_cmp_i284_0_reg_14_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp_i284_stall_in = 1'b0;
assign rnode_13to14_bb2_cmp_i284_0_stall_in_0_reg_14_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2_cmp_i284_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_13to14_bb2_cmp_i284_0_NO_SHIFT_REG = rnode_13to14_bb2_cmp_i284_0_reg_14_NO_SHIFT_REG;
assign rnode_13to14_bb2_cmp_i284_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_13to14_bb2_cmp_i284_1_NO_SHIFT_REG = rnode_13to14_bb2_cmp_i284_0_reg_14_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_shl_i_i_stall_local;
wire [31:0] local_bb2_shl_i_i;

assign local_bb2_shl_i_i = (local_bb2_or_i17_i << 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2__31_i295_stall_local;
wire local_bb2__31_i295;

assign local_bb2__31_i295 = (local_bb2_tobool49_i & local_bb2_cmp50_not_i);

// This section implements an unregistered operation.
// 
wire local_bb2__28_i289_stall_local;
wire local_bb2__28_i289;

assign local_bb2__28_i289 = (rnode_13to14_bb2_cmp_i284_0_NO_SHIFT_REG & rnode_13to14_bb2_lnot14_not_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_or_i_i294_stall_local;
wire [31:0] local_bb2_or_i_i294;

assign local_bb2_or_i_i294 = (local_bb2_shl_i_i | local_bb2_shr_i_i293);

// This section implements an unregistered operation.
// 
wire local_bb2__32_i296_stall_local;
wire [31:0] local_bb2__32_i296;

assign local_bb2__32_i296 = (local_bb2__31_i295 ? local_bb2_shl1_i_i : local_bb2_shl1_i18_i);

// This section implements an unregistered operation.
// 
wire local_bb2__36_i_stall_local;
wire [31:0] local_bb2__36_i;

assign local_bb2__36_i = (local_bb2__31_i295 ? rnode_12to13_bb2_add_i292_1_NO_SHIFT_REG : 32'h7F);

// This section implements an unregistered operation.
// 
wire local_bb2__34_i_stall_local;
wire [31:0] local_bb2__34_i;

assign local_bb2__34_i = (local_bb2__31_i295 ? local_bb2_or_i_i294 : local_bb2_or_i17_i);

// This section implements an unregistered operation.
// 
wire local_bb2__33_i297_stall_local;
wire [31:0] local_bb2__33_i297;

assign local_bb2__33_i297 = (local_bb2_tobool49_i ? local_bb2__32_i296 : local_bb2_shl1_i18_i);

// This section implements an unregistered operation.
// 
wire local_bb2__37_i_stall_local;
wire [31:0] local_bb2__37_i;

assign local_bb2__37_i = (local_bb2_tobool49_i ? local_bb2__36_i : local_bb2_inc_i);

// This section implements an unregistered operation.
// 
wire local_bb2__35_i_stall_local;
wire [31:0] local_bb2__35_i;

assign local_bb2__35_i = (local_bb2_tobool49_i ? local_bb2__34_i : local_bb2_or_i17_i);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp77_i303_stall_local;
wire local_bb2_cmp77_i303;

assign local_bb2_cmp77_i303 = (local_bb2__33_i297 > 32'h80000000);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u27_stall_local;
wire local_bb2_var__u27;

assign local_bb2_var__u27 = ($signed(local_bb2__33_i297) < $signed(32'h0));

// This section implements an unregistered operation.
// 
wire local_bb2_and75_i300_stall_local;
wire [31:0] local_bb2_and75_i300;

assign local_bb2_and75_i300 = (local_bb2__35_i & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and83_i_stall_local;
wire [31:0] local_bb2_and83_i;

assign local_bb2_and83_i = (local_bb2__35_i & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_tobool84_i_stall_local;
wire local_bb2_tobool84_i;

assign local_bb2_tobool84_i = (local_bb2_and83_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2__37_i_valid_out;
wire local_bb2__37_i_stall_in;
 reg local_bb2__37_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp77_i303_valid_out;
wire local_bb2_cmp77_i303_stall_in;
 reg local_bb2_cmp77_i303_consumed_0_NO_SHIFT_REG;
wire local_bb2_and75_i300_valid_out;
wire local_bb2_and75_i300_stall_in;
 reg local_bb2_and75_i300_consumed_0_NO_SHIFT_REG;
wire local_bb2__39_i_valid_out;
wire local_bb2__39_i_stall_in;
 reg local_bb2__39_i_consumed_0_NO_SHIFT_REG;
wire local_bb2__39_i_inputs_ready;
wire local_bb2__39_i_stall_local;
wire local_bb2__39_i;

assign local_bb2__39_i_inputs_ready = (rnode_12to13_bb2_and_i281_0_valid_out_2_NO_SHIFT_REG & rnode_12to13_bb2_add_i292_0_valid_out_1_NO_SHIFT_REG & local_bb2_mul_i_i_valid_out_0_NO_SHIFT_REG & rnode_12to13_bb2_add_i292_0_valid_out_0_NO_SHIFT_REG & local_bb2_mul_i_i_valid_out_1_NO_SHIFT_REG);
assign local_bb2__39_i = (local_bb2_tobool84_i & local_bb2_var__u27);
assign local_bb2__37_i_valid_out = 1'b1;
assign local_bb2_cmp77_i303_valid_out = 1'b1;
assign local_bb2_and75_i300_valid_out = 1'b1;
assign local_bb2__39_i_valid_out = 1'b1;
assign rnode_12to13_bb2_and_i281_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_12to13_bb2_add_i292_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign local_bb2_mul_i_i_stall_in_0 = 1'b0;
assign rnode_12to13_bb2_add_i292_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign local_bb2_mul_i_i_stall_in_1 = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2__37_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp77_i303_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_and75_i300_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2__39_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2__37_i_consumed_0_NO_SHIFT_REG <= (local_bb2__39_i_inputs_ready & (local_bb2__37_i_consumed_0_NO_SHIFT_REG | ~(local_bb2__37_i_stall_in)) & local_bb2__39_i_stall_local);
		local_bb2_cmp77_i303_consumed_0_NO_SHIFT_REG <= (local_bb2__39_i_inputs_ready & (local_bb2_cmp77_i303_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp77_i303_stall_in)) & local_bb2__39_i_stall_local);
		local_bb2_and75_i300_consumed_0_NO_SHIFT_REG <= (local_bb2__39_i_inputs_ready & (local_bb2_and75_i300_consumed_0_NO_SHIFT_REG | ~(local_bb2_and75_i300_stall_in)) & local_bb2__39_i_stall_local);
		local_bb2__39_i_consumed_0_NO_SHIFT_REG <= (local_bb2__39_i_inputs_ready & (local_bb2__39_i_consumed_0_NO_SHIFT_REG | ~(local_bb2__39_i_stall_in)) & local_bb2__39_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_13to14_bb2__37_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_13to14_bb2__37_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_13to14_bb2__37_i_0_NO_SHIFT_REG;
 logic rnode_13to14_bb2__37_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_13to14_bb2__37_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_13to14_bb2__37_i_1_NO_SHIFT_REG;
 logic rnode_13to14_bb2__37_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_13to14_bb2__37_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_13to14_bb2__37_i_2_NO_SHIFT_REG;
 logic rnode_13to14_bb2__37_i_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_13to14_bb2__37_i_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_13to14_bb2__37_i_3_NO_SHIFT_REG;
 logic rnode_13to14_bb2__37_i_0_reg_14_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_13to14_bb2__37_i_0_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2__37_i_0_valid_out_0_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2__37_i_0_stall_in_0_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2__37_i_0_stall_out_reg_14_NO_SHIFT_REG;

acl_data_fifo rnode_13to14_bb2__37_i_0_reg_14_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_13to14_bb2__37_i_0_reg_14_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_13to14_bb2__37_i_0_stall_in_0_reg_14_NO_SHIFT_REG),
	.valid_out(rnode_13to14_bb2__37_i_0_valid_out_0_reg_14_NO_SHIFT_REG),
	.stall_out(rnode_13to14_bb2__37_i_0_stall_out_reg_14_NO_SHIFT_REG),
	.data_in(local_bb2__37_i),
	.data_out(rnode_13to14_bb2__37_i_0_reg_14_NO_SHIFT_REG)
);

defparam rnode_13to14_bb2__37_i_0_reg_14_fifo.DEPTH = 1;
defparam rnode_13to14_bb2__37_i_0_reg_14_fifo.DATA_WIDTH = 32;
defparam rnode_13to14_bb2__37_i_0_reg_14_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_13to14_bb2__37_i_0_reg_14_fifo.IMPL = "shift_reg";

assign rnode_13to14_bb2__37_i_0_reg_14_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__37_i_stall_in = 1'b0;
assign rnode_13to14_bb2__37_i_0_stall_in_0_reg_14_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2__37_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_13to14_bb2__37_i_0_NO_SHIFT_REG = rnode_13to14_bb2__37_i_0_reg_14_NO_SHIFT_REG;
assign rnode_13to14_bb2__37_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_13to14_bb2__37_i_1_NO_SHIFT_REG = rnode_13to14_bb2__37_i_0_reg_14_NO_SHIFT_REG;
assign rnode_13to14_bb2__37_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_13to14_bb2__37_i_2_NO_SHIFT_REG = rnode_13to14_bb2__37_i_0_reg_14_NO_SHIFT_REG;
assign rnode_13to14_bb2__37_i_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_13to14_bb2__37_i_3_NO_SHIFT_REG = rnode_13to14_bb2__37_i_0_reg_14_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_13to14_bb2_cmp77_i303_0_valid_out_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp77_i303_0_stall_in_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp77_i303_0_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp77_i303_0_reg_14_inputs_ready_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp77_i303_0_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp77_i303_0_valid_out_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp77_i303_0_stall_in_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_cmp77_i303_0_stall_out_reg_14_NO_SHIFT_REG;

acl_data_fifo rnode_13to14_bb2_cmp77_i303_0_reg_14_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_13to14_bb2_cmp77_i303_0_reg_14_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_13to14_bb2_cmp77_i303_0_stall_in_reg_14_NO_SHIFT_REG),
	.valid_out(rnode_13to14_bb2_cmp77_i303_0_valid_out_reg_14_NO_SHIFT_REG),
	.stall_out(rnode_13to14_bb2_cmp77_i303_0_stall_out_reg_14_NO_SHIFT_REG),
	.data_in(local_bb2_cmp77_i303),
	.data_out(rnode_13to14_bb2_cmp77_i303_0_reg_14_NO_SHIFT_REG)
);

defparam rnode_13to14_bb2_cmp77_i303_0_reg_14_fifo.DEPTH = 1;
defparam rnode_13to14_bb2_cmp77_i303_0_reg_14_fifo.DATA_WIDTH = 1;
defparam rnode_13to14_bb2_cmp77_i303_0_reg_14_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_13to14_bb2_cmp77_i303_0_reg_14_fifo.IMPL = "shift_reg";

assign rnode_13to14_bb2_cmp77_i303_0_reg_14_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp77_i303_stall_in = 1'b0;
assign rnode_13to14_bb2_cmp77_i303_0_NO_SHIFT_REG = rnode_13to14_bb2_cmp77_i303_0_reg_14_NO_SHIFT_REG;
assign rnode_13to14_bb2_cmp77_i303_0_stall_in_reg_14_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2_cmp77_i303_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_13to14_bb2_and75_i300_0_valid_out_NO_SHIFT_REG;
 logic rnode_13to14_bb2_and75_i300_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_13to14_bb2_and75_i300_0_NO_SHIFT_REG;
 logic rnode_13to14_bb2_and75_i300_0_reg_14_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_13to14_bb2_and75_i300_0_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_and75_i300_0_valid_out_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_and75_i300_0_stall_in_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2_and75_i300_0_stall_out_reg_14_NO_SHIFT_REG;

acl_data_fifo rnode_13to14_bb2_and75_i300_0_reg_14_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_13to14_bb2_and75_i300_0_reg_14_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_13to14_bb2_and75_i300_0_stall_in_reg_14_NO_SHIFT_REG),
	.valid_out(rnode_13to14_bb2_and75_i300_0_valid_out_reg_14_NO_SHIFT_REG),
	.stall_out(rnode_13to14_bb2_and75_i300_0_stall_out_reg_14_NO_SHIFT_REG),
	.data_in(local_bb2_and75_i300),
	.data_out(rnode_13to14_bb2_and75_i300_0_reg_14_NO_SHIFT_REG)
);

defparam rnode_13to14_bb2_and75_i300_0_reg_14_fifo.DEPTH = 1;
defparam rnode_13to14_bb2_and75_i300_0_reg_14_fifo.DATA_WIDTH = 32;
defparam rnode_13to14_bb2_and75_i300_0_reg_14_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_13to14_bb2_and75_i300_0_reg_14_fifo.IMPL = "shift_reg";

assign rnode_13to14_bb2_and75_i300_0_reg_14_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and75_i300_stall_in = 1'b0;
assign rnode_13to14_bb2_and75_i300_0_NO_SHIFT_REG = rnode_13to14_bb2_and75_i300_0_reg_14_NO_SHIFT_REG;
assign rnode_13to14_bb2_and75_i300_0_stall_in_reg_14_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2_and75_i300_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_13to14_bb2__39_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_13to14_bb2__39_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_13to14_bb2__39_i_0_NO_SHIFT_REG;
 logic rnode_13to14_bb2__39_i_0_reg_14_inputs_ready_NO_SHIFT_REG;
 logic rnode_13to14_bb2__39_i_0_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2__39_i_0_valid_out_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2__39_i_0_stall_in_reg_14_NO_SHIFT_REG;
 logic rnode_13to14_bb2__39_i_0_stall_out_reg_14_NO_SHIFT_REG;

acl_data_fifo rnode_13to14_bb2__39_i_0_reg_14_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_13to14_bb2__39_i_0_reg_14_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_13to14_bb2__39_i_0_stall_in_reg_14_NO_SHIFT_REG),
	.valid_out(rnode_13to14_bb2__39_i_0_valid_out_reg_14_NO_SHIFT_REG),
	.stall_out(rnode_13to14_bb2__39_i_0_stall_out_reg_14_NO_SHIFT_REG),
	.data_in(local_bb2__39_i),
	.data_out(rnode_13to14_bb2__39_i_0_reg_14_NO_SHIFT_REG)
);

defparam rnode_13to14_bb2__39_i_0_reg_14_fifo.DEPTH = 1;
defparam rnode_13to14_bb2__39_i_0_reg_14_fifo.DATA_WIDTH = 1;
defparam rnode_13to14_bb2__39_i_0_reg_14_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_13to14_bb2__39_i_0_reg_14_fifo.IMPL = "shift_reg";

assign rnode_13to14_bb2__39_i_0_reg_14_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__39_i_stall_in = 1'b0;
assign rnode_13to14_bb2__39_i_0_NO_SHIFT_REG = rnode_13to14_bb2__39_i_0_reg_14_NO_SHIFT_REG;
assign rnode_13to14_bb2__39_i_0_stall_in_reg_14_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2__39_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_cmp53_i_stall_local;
wire local_bb2_cmp53_i;

assign local_bb2_cmp53_i = (rnode_13to14_bb2__37_i_0_NO_SHIFT_REG > 32'h17D);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp68_i_stall_local;
wire local_bb2_cmp68_i;

assign local_bb2_cmp68_i = (rnode_13to14_bb2__37_i_1_NO_SHIFT_REG < 32'h80);

// This section implements an unregistered operation.
// 
wire local_bb2_sub_i301_stall_local;
wire [31:0] local_bb2_sub_i301;

assign local_bb2_sub_i301 = (rnode_13to14_bb2__37_i_2_NO_SHIFT_REG << 32'h17);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp71_not_i_stall_local;
wire local_bb2_cmp71_not_i;

assign local_bb2_cmp71_not_i = (rnode_13to14_bb2__37_i_3_NO_SHIFT_REG != 32'h7F);

// This section implements an unregistered operation.
// 
wire local_bb2__40_i_stall_local;
wire local_bb2__40_i;

assign local_bb2__40_i = (rnode_13to14_bb2_cmp77_i303_0_NO_SHIFT_REG | rnode_13to14_bb2__39_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_or581_i_stall_local;
wire local_bb2_or581_i;

assign local_bb2_or581_i = (rnode_13to14_bb2_cmp_i284_1_NO_SHIFT_REG | local_bb2_cmp53_i);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u28_stall_local;
wire [31:0] local_bb2_var__u28;

assign local_bb2_var__u28[31:1] = 31'h0;
assign local_bb2_var__u28[0] = local_bb2_cmp68_i;

// This section implements an unregistered operation.
// 
wire local_bb2_and74_i_stall_local;
wire [31:0] local_bb2_and74_i;

assign local_bb2_and74_i = (local_bb2_sub_i301 + 32'h40800000);

// This section implements an unregistered operation.
// 
wire local_bb2_cond_i_stall_local;
wire [31:0] local_bb2_cond_i;

assign local_bb2_cond_i[31:1] = 31'h0;
assign local_bb2_cond_i[0] = local_bb2__40_i;

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_2_i299_stall_local;
wire local_bb2_reduction_2_i299;

assign local_bb2_reduction_2_i299 = (rnode_13to14_bb2_lnot_i283_0_NO_SHIFT_REG | local_bb2_or581_i);

// This section implements an unregistered operation.
// 
wire local_bb2_cond111_i_stall_local;
wire [31:0] local_bb2_cond111_i;

assign local_bb2_cond111_i = (local_bb2_or581_i ? 32'h7F800000 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_shl_i302_stall_local;
wire [31:0] local_bb2_shl_i302;

assign local_bb2_shl_i302 = (local_bb2_and74_i & 32'h7F800000);

// This section implements an unregistered operation.
// 
wire local_bb2_conv101_i_stall_local;
wire [31:0] local_bb2_conv101_i;

assign local_bb2_conv101_i[31:1] = 31'h0;
assign local_bb2_conv101_i[0] = local_bb2_reduction_2_i299;

// This section implements an unregistered operation.
// 
wire local_bb2_or76_i_stall_local;
wire [31:0] local_bb2_or76_i;

assign local_bb2_or76_i = (local_bb2_shl_i302 | rnode_13to14_bb2_and75_i300_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_add87_i_stall_local;
wire [31:0] local_bb2_add87_i;

assign local_bb2_add87_i = (local_bb2_cond_i + local_bb2_or76_i);

// This section implements an unregistered operation.
// 
wire local_bb2_and88_i304_stall_local;
wire [31:0] local_bb2_and88_i304;

assign local_bb2_and88_i304 = (local_bb2_add87_i & 32'h7FFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and90_i305_stall_local;
wire [31:0] local_bb2_and90_i305;

assign local_bb2_and90_i305 = (local_bb2_add87_i & 32'h800000);

// This section implements an unregistered operation.
// 
wire local_bb2_or89_i_stall_local;
wire [31:0] local_bb2_or89_i;

assign local_bb2_or89_i = (local_bb2_and88_i304 | rnode_13to14_bb2_and4_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp91_i306_stall_local;
wire local_bb2_cmp91_i306;

assign local_bb2_cmp91_i306 = (local_bb2_and90_i305 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge14_i_stall_local;
wire local_bb2_brmerge14_i;

assign local_bb2_brmerge14_i = (local_bb2_cmp91_i306 | local_bb2_cmp71_not_i);

// This section implements an unregistered operation.
// 
wire local_bb2_conv99_i_stall_local;
wire [31:0] local_bb2_conv99_i;

assign local_bb2_conv99_i = (local_bb2_brmerge14_i ? local_bb2_var__u28 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or102_i_stall_local;
wire [31:0] local_bb2_or102_i;

assign local_bb2_or102_i = (local_bb2_conv99_i | local_bb2_conv101_i);

// This section implements an unregistered operation.
// 
wire local_bb2_tobool103_i_stall_local;
wire local_bb2_tobool103_i;

assign local_bb2_tobool103_i = (local_bb2_or102_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cond107_i_stall_local;
wire [31:0] local_bb2_cond107_i;

assign local_bb2_cond107_i = (local_bb2_tobool103_i ? rnode_13to14_bb2_and4_i_1_NO_SHIFT_REG : 32'hFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and108_i_stall_local;
wire [31:0] local_bb2_and108_i;

assign local_bb2_and108_i = (local_bb2_cond107_i & local_bb2_or89_i);

// This section implements an unregistered operation.
// 
wire local_bb2_or112_i_stall_local;
wire [31:0] local_bb2_or112_i;

assign local_bb2_or112_i = (local_bb2_and108_i | local_bb2_cond111_i);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u29_valid_out;
wire local_bb2_var__u29_stall_in;
wire local_bb2_var__u29_inputs_ready;
wire local_bb2_var__u29_stall_local;
wire [31:0] local_bb2_var__u29;

assign local_bb2_var__u29_inputs_ready = (rnode_13to14_bb2_and4_i_0_valid_out_0_NO_SHIFT_REG & rnode_13to14_bb2_and4_i_0_valid_out_1_NO_SHIFT_REG & rnode_13to14_bb2_cmp_i284_0_valid_out_0_NO_SHIFT_REG & rnode_13to14_bb2_lnot14_not_i_0_valid_out_NO_SHIFT_REG & rnode_13to14_bb2_lnot_i283_0_valid_out_NO_SHIFT_REG & rnode_13to14_bb2_cmp_i284_0_valid_out_1_NO_SHIFT_REG & rnode_13to14_bb2__37_i_0_valid_out_0_NO_SHIFT_REG & rnode_13to14_bb2__37_i_0_valid_out_1_NO_SHIFT_REG & rnode_13to14_bb2__37_i_0_valid_out_3_NO_SHIFT_REG & rnode_13to14_bb2__37_i_0_valid_out_2_NO_SHIFT_REG & rnode_13to14_bb2_and75_i300_0_valid_out_NO_SHIFT_REG & rnode_13to14_bb2_cmp77_i303_0_valid_out_NO_SHIFT_REG & rnode_13to14_bb2__39_i_0_valid_out_NO_SHIFT_REG);
assign local_bb2_var__u29 = (local_bb2__28_i289 ? 32'h7FC00000 : local_bb2_or112_i);
assign local_bb2_var__u29_valid_out = 1'b1;
assign rnode_13to14_bb2_and4_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2_and4_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2_cmp_i284_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2_lnot14_not_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2_lnot_i283_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2_cmp_i284_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2__37_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2__37_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2__37_i_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2__37_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2_and75_i300_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2_cmp77_i303_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_13to14_bb2__39_i_0_stall_in_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_14to15_bb2_var__u29_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_14to15_bb2_var__u29_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_14to15_bb2_var__u29_0_NO_SHIFT_REG;
 logic rnode_14to15_bb2_var__u29_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_14to15_bb2_var__u29_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_14to15_bb2_var__u29_1_NO_SHIFT_REG;
 logic rnode_14to15_bb2_var__u29_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_14to15_bb2_var__u29_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_14to15_bb2_var__u29_2_NO_SHIFT_REG;
 logic rnode_14to15_bb2_var__u29_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_14to15_bb2_var__u29_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_14to15_bb2_var__u29_3_NO_SHIFT_REG;
 logic rnode_14to15_bb2_var__u29_0_reg_15_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_14to15_bb2_var__u29_0_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb2_var__u29_0_valid_out_0_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb2_var__u29_0_stall_in_0_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb2_var__u29_0_stall_out_reg_15_NO_SHIFT_REG;

acl_data_fifo rnode_14to15_bb2_var__u29_0_reg_15_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_14to15_bb2_var__u29_0_reg_15_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_14to15_bb2_var__u29_0_stall_in_0_reg_15_NO_SHIFT_REG),
	.valid_out(rnode_14to15_bb2_var__u29_0_valid_out_0_reg_15_NO_SHIFT_REG),
	.stall_out(rnode_14to15_bb2_var__u29_0_stall_out_reg_15_NO_SHIFT_REG),
	.data_in(local_bb2_var__u29),
	.data_out(rnode_14to15_bb2_var__u29_0_reg_15_NO_SHIFT_REG)
);

defparam rnode_14to15_bb2_var__u29_0_reg_15_fifo.DEPTH = 1;
defparam rnode_14to15_bb2_var__u29_0_reg_15_fifo.DATA_WIDTH = 32;
defparam rnode_14to15_bb2_var__u29_0_reg_15_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_14to15_bb2_var__u29_0_reg_15_fifo.IMPL = "shift_reg";

assign rnode_14to15_bb2_var__u29_0_reg_15_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_var__u29_stall_in = 1'b0;
assign rnode_14to15_bb2_var__u29_0_stall_in_0_reg_15_NO_SHIFT_REG = 1'b0;
assign rnode_14to15_bb2_var__u29_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_14to15_bb2_var__u29_0_NO_SHIFT_REG = rnode_14to15_bb2_var__u29_0_reg_15_NO_SHIFT_REG;
assign rnode_14to15_bb2_var__u29_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_14to15_bb2_var__u29_1_NO_SHIFT_REG = rnode_14to15_bb2_var__u29_0_reg_15_NO_SHIFT_REG;
assign rnode_14to15_bb2_var__u29_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_14to15_bb2_var__u29_2_NO_SHIFT_REG = rnode_14to15_bb2_var__u29_0_reg_15_NO_SHIFT_REG;
assign rnode_14to15_bb2_var__u29_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_14to15_bb2_var__u29_3_NO_SHIFT_REG = rnode_14to15_bb2_var__u29_0_reg_15_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_and2_i100_stall_local;
wire [31:0] local_bb2_and2_i100;

assign local_bb2_and2_i100 = (rnode_14to15_bb2_var__u29_0_NO_SHIFT_REG >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb2_and12_i105_stall_local;
wire [31:0] local_bb2_and12_i105;

assign local_bb2_and12_i105 = (rnode_14to15_bb2_var__u29_1_NO_SHIFT_REG & 32'hFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_shr3_i101_stall_local;
wire [31:0] local_bb2_shr3_i101;

assign local_bb2_shr3_i101 = (local_bb2_and2_i100 & 32'h7FFF);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp13_i106_stall_local;
wire local_bb2_cmp13_i106;

assign local_bb2_cmp13_i106 = (local_bb2_and10_i104 > local_bb2_and12_i105);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp_i102_stall_local;
wire local_bb2_cmp_i102;

assign local_bb2_cmp_i102 = (local_bb2_shr_i99 > local_bb2_shr3_i101);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp8_i103_stall_local;
wire local_bb2_cmp8_i103;

assign local_bb2_cmp8_i103 = (local_bb2_shr_i99 == local_bb2_shr3_i101);

// This section implements an unregistered operation.
// 
wire local_bb2___i107_stall_local;
wire local_bb2___i107;

assign local_bb2___i107 = (local_bb2_cmp8_i103 & local_bb2_cmp13_i106);

// This section implements an unregistered operation.
// 
wire local_bb2__21_i108_stall_local;
wire local_bb2__21_i108;

assign local_bb2__21_i108 = (local_bb2_cmp_i102 | local_bb2___i107);

// This section implements an unregistered operation.
// 
wire local_bb2__22_i109_stall_local;
wire [31:0] local_bb2__22_i109;

assign local_bb2__22_i109 = (local_bb2__21_i108 ? rnode_14to15_bb2_var__u29_2_NO_SHIFT_REG : local_bb2_var__u15);

// This section implements an unregistered operation.
// 
wire local_bb2__22_i109_valid_out;
wire local_bb2__22_i109_stall_in;
 reg local_bb2__22_i109_consumed_0_NO_SHIFT_REG;
wire local_bb2__23_i110_valid_out;
wire local_bb2__23_i110_stall_in;
 reg local_bb2__23_i110_consumed_0_NO_SHIFT_REG;
wire local_bb2__23_i110_inputs_ready;
wire local_bb2__23_i110_stall_local;
wire [31:0] local_bb2__23_i110;

assign local_bb2__23_i110_inputs_ready = (rnode_14to15_bb2_c0_ene14_0_valid_out_NO_SHIFT_REG & rnode_14to15_bb2_var__u29_0_valid_out_2_NO_SHIFT_REG & rnode_14to15_bb2_var__u29_0_valid_out_3_NO_SHIFT_REG & rnode_14to15_bb2_var__u29_0_valid_out_1_NO_SHIFT_REG & rnode_14to15_bb2_var__u29_0_valid_out_0_NO_SHIFT_REG);
assign local_bb2__23_i110 = (local_bb2__21_i108 ? local_bb2_var__u15 : rnode_14to15_bb2_var__u29_3_NO_SHIFT_REG);
assign local_bb2__22_i109_valid_out = 1'b1;
assign local_bb2__23_i110_valid_out = 1'b1;
assign rnode_14to15_bb2_c0_ene14_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_14to15_bb2_var__u29_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_14to15_bb2_var__u29_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_14to15_bb2_var__u29_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_14to15_bb2_var__u29_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2__22_i109_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2__23_i110_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2__22_i109_consumed_0_NO_SHIFT_REG <= (local_bb2__23_i110_inputs_ready & (local_bb2__22_i109_consumed_0_NO_SHIFT_REG | ~(local_bb2__22_i109_stall_in)) & local_bb2__23_i110_stall_local);
		local_bb2__23_i110_consumed_0_NO_SHIFT_REG <= (local_bb2__23_i110_inputs_ready & (local_bb2__23_i110_consumed_0_NO_SHIFT_REG | ~(local_bb2__23_i110_stall_in)) & local_bb2__23_i110_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb2__22_i109_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_15to16_bb2__22_i109_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_15to16_bb2__22_i109_0_NO_SHIFT_REG;
 logic rnode_15to16_bb2__22_i109_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_15to16_bb2__22_i109_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_15to16_bb2__22_i109_1_NO_SHIFT_REG;
 logic rnode_15to16_bb2__22_i109_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_15to16_bb2__22_i109_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb2__22_i109_0_valid_out_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb2__22_i109_0_stall_in_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb2__22_i109_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb2__22_i109_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb2__22_i109_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb2__22_i109_0_stall_in_0_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb2__22_i109_0_valid_out_0_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb2__22_i109_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb2__22_i109),
	.data_out(rnode_15to16_bb2__22_i109_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb2__22_i109_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb2__22_i109_0_reg_16_fifo.DATA_WIDTH = 32;
defparam rnode_15to16_bb2__22_i109_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb2__22_i109_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb2__22_i109_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__22_i109_stall_in = 1'b0;
assign rnode_15to16_bb2__22_i109_0_stall_in_0_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb2__22_i109_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb2__22_i109_0_NO_SHIFT_REG = rnode_15to16_bb2__22_i109_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb2__22_i109_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb2__22_i109_1_NO_SHIFT_REG = rnode_15to16_bb2__22_i109_0_reg_16_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_15to16_bb2__23_i110_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_15to16_bb2__23_i110_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_15to16_bb2__23_i110_0_NO_SHIFT_REG;
 logic rnode_15to16_bb2__23_i110_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_15to16_bb2__23_i110_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_15to16_bb2__23_i110_1_NO_SHIFT_REG;
 logic rnode_15to16_bb2__23_i110_0_reg_16_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_15to16_bb2__23_i110_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb2__23_i110_0_valid_out_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb2__23_i110_0_stall_in_0_reg_16_NO_SHIFT_REG;
 logic rnode_15to16_bb2__23_i110_0_stall_out_reg_16_NO_SHIFT_REG;

acl_data_fifo rnode_15to16_bb2__23_i110_0_reg_16_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_15to16_bb2__23_i110_0_reg_16_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_15to16_bb2__23_i110_0_stall_in_0_reg_16_NO_SHIFT_REG),
	.valid_out(rnode_15to16_bb2__23_i110_0_valid_out_0_reg_16_NO_SHIFT_REG),
	.stall_out(rnode_15to16_bb2__23_i110_0_stall_out_reg_16_NO_SHIFT_REG),
	.data_in(local_bb2__23_i110),
	.data_out(rnode_15to16_bb2__23_i110_0_reg_16_NO_SHIFT_REG)
);

defparam rnode_15to16_bb2__23_i110_0_reg_16_fifo.DEPTH = 1;
defparam rnode_15to16_bb2__23_i110_0_reg_16_fifo.DATA_WIDTH = 32;
defparam rnode_15to16_bb2__23_i110_0_reg_16_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_15to16_bb2__23_i110_0_reg_16_fifo.IMPL = "shift_reg";

assign rnode_15to16_bb2__23_i110_0_reg_16_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__23_i110_stall_in = 1'b0;
assign rnode_15to16_bb2__23_i110_0_stall_in_0_reg_16_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb2__23_i110_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb2__23_i110_0_NO_SHIFT_REG = rnode_15to16_bb2__23_i110_0_reg_16_NO_SHIFT_REG;
assign rnode_15to16_bb2__23_i110_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb2__23_i110_1_NO_SHIFT_REG = rnode_15to16_bb2__23_i110_0_reg_16_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_shr18_i113_stall_local;
wire [31:0] local_bb2_shr18_i113;

assign local_bb2_shr18_i113 = (rnode_15to16_bb2__22_i109_0_NO_SHIFT_REG >> 32'h17);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_16to17_bb2__22_i109_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_16to17_bb2__22_i109_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2__22_i109_0_NO_SHIFT_REG;
 logic rnode_16to17_bb2__22_i109_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_16to17_bb2__22_i109_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2__22_i109_1_NO_SHIFT_REG;
 logic rnode_16to17_bb2__22_i109_0_reg_17_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2__22_i109_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2__22_i109_0_valid_out_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2__22_i109_0_stall_in_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2__22_i109_0_stall_out_reg_17_NO_SHIFT_REG;

acl_data_fifo rnode_16to17_bb2__22_i109_0_reg_17_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_16to17_bb2__22_i109_0_reg_17_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_16to17_bb2__22_i109_0_stall_in_0_reg_17_NO_SHIFT_REG),
	.valid_out(rnode_16to17_bb2__22_i109_0_valid_out_0_reg_17_NO_SHIFT_REG),
	.stall_out(rnode_16to17_bb2__22_i109_0_stall_out_reg_17_NO_SHIFT_REG),
	.data_in(rnode_15to16_bb2__22_i109_1_NO_SHIFT_REG),
	.data_out(rnode_16to17_bb2__22_i109_0_reg_17_NO_SHIFT_REG)
);

defparam rnode_16to17_bb2__22_i109_0_reg_17_fifo.DEPTH = 1;
defparam rnode_16to17_bb2__22_i109_0_reg_17_fifo.DATA_WIDTH = 32;
defparam rnode_16to17_bb2__22_i109_0_reg_17_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_16to17_bb2__22_i109_0_reg_17_fifo.IMPL = "shift_reg";

assign rnode_16to17_bb2__22_i109_0_reg_17_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb2__22_i109_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2__22_i109_0_stall_in_0_reg_17_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2__22_i109_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_16to17_bb2__22_i109_0_NO_SHIFT_REG = rnode_16to17_bb2__22_i109_0_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb2__22_i109_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_16to17_bb2__22_i109_1_NO_SHIFT_REG = rnode_16to17_bb2__22_i109_0_reg_17_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_shr16_i111_stall_local;
wire [31:0] local_bb2_shr16_i111;

assign local_bb2_shr16_i111 = (rnode_15to16_bb2__23_i110_0_NO_SHIFT_REG >> 32'h17);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_16to17_bb2__23_i110_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_16to17_bb2__23_i110_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2__23_i110_0_NO_SHIFT_REG;
 logic rnode_16to17_bb2__23_i110_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_16to17_bb2__23_i110_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2__23_i110_1_NO_SHIFT_REG;
 logic rnode_16to17_bb2__23_i110_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_16to17_bb2__23_i110_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2__23_i110_2_NO_SHIFT_REG;
 logic rnode_16to17_bb2__23_i110_0_reg_17_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2__23_i110_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2__23_i110_0_valid_out_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2__23_i110_0_stall_in_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2__23_i110_0_stall_out_reg_17_NO_SHIFT_REG;

acl_data_fifo rnode_16to17_bb2__23_i110_0_reg_17_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_16to17_bb2__23_i110_0_reg_17_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_16to17_bb2__23_i110_0_stall_in_0_reg_17_NO_SHIFT_REG),
	.valid_out(rnode_16to17_bb2__23_i110_0_valid_out_0_reg_17_NO_SHIFT_REG),
	.stall_out(rnode_16to17_bb2__23_i110_0_stall_out_reg_17_NO_SHIFT_REG),
	.data_in(rnode_15to16_bb2__23_i110_1_NO_SHIFT_REG),
	.data_out(rnode_16to17_bb2__23_i110_0_reg_17_NO_SHIFT_REG)
);

defparam rnode_16to17_bb2__23_i110_0_reg_17_fifo.DEPTH = 1;
defparam rnode_16to17_bb2__23_i110_0_reg_17_fifo.DATA_WIDTH = 32;
defparam rnode_16to17_bb2__23_i110_0_reg_17_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_16to17_bb2__23_i110_0_reg_17_fifo.IMPL = "shift_reg";

assign rnode_16to17_bb2__23_i110_0_reg_17_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_15to16_bb2__23_i110_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2__23_i110_0_stall_in_0_reg_17_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2__23_i110_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_16to17_bb2__23_i110_0_NO_SHIFT_REG = rnode_16to17_bb2__23_i110_0_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb2__23_i110_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_16to17_bb2__23_i110_1_NO_SHIFT_REG = rnode_16to17_bb2__23_i110_0_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb2__23_i110_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_16to17_bb2__23_i110_2_NO_SHIFT_REG = rnode_16to17_bb2__23_i110_0_reg_17_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_and19_i114_stall_local;
wire [31:0] local_bb2_and19_i114;

assign local_bb2_and19_i114 = (local_bb2_shr18_i113 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and21_i116_stall_local;
wire [31:0] local_bb2_and21_i116;

assign local_bb2_and21_i116 = (rnode_16to17_bb2__22_i109_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_sub_i143_stall_local;
wire [31:0] local_bb2_sub_i143;

assign local_bb2_sub_i143 = (local_bb2_shr16_i111 - local_bb2_shr18_i113);

// This section implements an unregistered operation.
// 
wire local_bb2_and20_i115_stall_local;
wire [31:0] local_bb2_and20_i115;

assign local_bb2_and20_i115 = (rnode_16to17_bb2__23_i110_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and35_i121_valid_out;
wire local_bb2_and35_i121_stall_in;
wire local_bb2_and35_i121_inputs_ready;
wire local_bb2_and35_i121_stall_local;
wire [31:0] local_bb2_and35_i121;

assign local_bb2_and35_i121_inputs_ready = rnode_16to17_bb2__23_i110_0_valid_out_1_NO_SHIFT_REG;
assign local_bb2_and35_i121 = (rnode_16to17_bb2__23_i110_1_NO_SHIFT_REG & 32'h80000000);
assign local_bb2_and35_i121_valid_out = 1'b1;
assign rnode_16to17_bb2__23_i110_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_xor_i122_stall_local;
wire [31:0] local_bb2_xor_i122;

assign local_bb2_xor_i122 = (rnode_16to17_bb2__23_i110_2_NO_SHIFT_REG ^ rnode_16to17_bb2__22_i109_1_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot23_i118_stall_local;
wire local_bb2_lnot23_i118;

assign local_bb2_lnot23_i118 = (local_bb2_and19_i114 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp27_i120_stall_local;
wire local_bb2_cmp27_i120;

assign local_bb2_cmp27_i120 = (local_bb2_and19_i114 == 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot33_not_i127_stall_local;
wire local_bb2_lnot33_not_i127;

assign local_bb2_lnot33_not_i127 = (local_bb2_and21_i116 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or64_i140_stall_local;
wire [31:0] local_bb2_or64_i140;

assign local_bb2_or64_i140 = (local_bb2_and21_i116 << 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb2_and68_i144_stall_local;
wire [31:0] local_bb2_and68_i144;

assign local_bb2_and68_i144 = (local_bb2_sub_i143 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot30_i125_stall_local;
wire local_bb2_lnot30_i125;

assign local_bb2_lnot30_i125 = (local_bb2_and20_i115 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or_i137_stall_local;
wire [31:0] local_bb2_or_i137;

assign local_bb2_or_i137 = (local_bb2_and20_i115 << 32'h3);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_17to18_bb2_and35_i121_0_valid_out_NO_SHIFT_REG;
 logic rnode_17to18_bb2_and35_i121_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_17to18_bb2_and35_i121_0_NO_SHIFT_REG;
 logic rnode_17to18_bb2_and35_i121_0_reg_18_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_17to18_bb2_and35_i121_0_reg_18_NO_SHIFT_REG;
 logic rnode_17to18_bb2_and35_i121_0_valid_out_reg_18_NO_SHIFT_REG;
 logic rnode_17to18_bb2_and35_i121_0_stall_in_reg_18_NO_SHIFT_REG;
 logic rnode_17to18_bb2_and35_i121_0_stall_out_reg_18_NO_SHIFT_REG;

acl_data_fifo rnode_17to18_bb2_and35_i121_0_reg_18_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_17to18_bb2_and35_i121_0_reg_18_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_17to18_bb2_and35_i121_0_stall_in_reg_18_NO_SHIFT_REG),
	.valid_out(rnode_17to18_bb2_and35_i121_0_valid_out_reg_18_NO_SHIFT_REG),
	.stall_out(rnode_17to18_bb2_and35_i121_0_stall_out_reg_18_NO_SHIFT_REG),
	.data_in(local_bb2_and35_i121),
	.data_out(rnode_17to18_bb2_and35_i121_0_reg_18_NO_SHIFT_REG)
);

defparam rnode_17to18_bb2_and35_i121_0_reg_18_fifo.DEPTH = 1;
defparam rnode_17to18_bb2_and35_i121_0_reg_18_fifo.DATA_WIDTH = 32;
defparam rnode_17to18_bb2_and35_i121_0_reg_18_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_17to18_bb2_and35_i121_0_reg_18_fifo.IMPL = "shift_reg";

assign rnode_17to18_bb2_and35_i121_0_reg_18_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and35_i121_stall_in = 1'b0;
assign rnode_17to18_bb2_and35_i121_0_NO_SHIFT_REG = rnode_17to18_bb2_and35_i121_0_reg_18_NO_SHIFT_REG;
assign rnode_17to18_bb2_and35_i121_0_stall_in_reg_18_NO_SHIFT_REG = 1'b0;
assign rnode_17to18_bb2_and35_i121_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_cmp37_i123_stall_local;
wire local_bb2_cmp37_i123;

assign local_bb2_cmp37_i123 = ($signed(local_bb2_xor_i122) < $signed(32'h0));

// This section implements an unregistered operation.
// 
wire local_bb2_xor_lobit_i196_stall_local;
wire [31:0] local_bb2_xor_lobit_i196;

assign local_bb2_xor_lobit_i196 = ($signed(local_bb2_xor_i122) >>> 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb2_and36_lobit_i198_stall_local;
wire [31:0] local_bb2_and36_lobit_i198;

assign local_bb2_and36_lobit_i198 = (local_bb2_xor_i122 >> 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb2_shl65_i141_stall_local;
wire [31:0] local_bb2_shl65_i141;

assign local_bb2_shl65_i141 = (local_bb2_or64_i140 | 32'h4000000);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp69_i145_stall_local;
wire local_bb2_cmp69_i145;

assign local_bb2_cmp69_i145 = (local_bb2_and68_i144 > 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot30_not_i129_stall_local;
wire local_bb2_lnot30_not_i129;

assign local_bb2_lnot30_not_i129 = (local_bb2_lnot30_i125 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_shl_i138_stall_local;
wire [31:0] local_bb2_shl_i138;

assign local_bb2_shl_i138 = (local_bb2_or_i137 | 32'h4000000);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_18to19_bb2_and35_i121_0_valid_out_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and35_i121_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_18to19_bb2_and35_i121_0_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and35_i121_0_reg_19_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_18to19_bb2_and35_i121_0_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and35_i121_0_valid_out_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and35_i121_0_stall_in_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and35_i121_0_stall_out_reg_19_NO_SHIFT_REG;

acl_data_fifo rnode_18to19_bb2_and35_i121_0_reg_19_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_18to19_bb2_and35_i121_0_reg_19_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_18to19_bb2_and35_i121_0_stall_in_reg_19_NO_SHIFT_REG),
	.valid_out(rnode_18to19_bb2_and35_i121_0_valid_out_reg_19_NO_SHIFT_REG),
	.stall_out(rnode_18to19_bb2_and35_i121_0_stall_out_reg_19_NO_SHIFT_REG),
	.data_in(rnode_17to18_bb2_and35_i121_0_NO_SHIFT_REG),
	.data_out(rnode_18to19_bb2_and35_i121_0_reg_19_NO_SHIFT_REG)
);

defparam rnode_18to19_bb2_and35_i121_0_reg_19_fifo.DEPTH = 1;
defparam rnode_18to19_bb2_and35_i121_0_reg_19_fifo.DATA_WIDTH = 32;
defparam rnode_18to19_bb2_and35_i121_0_reg_19_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_18to19_bb2_and35_i121_0_reg_19_fifo.IMPL = "shift_reg";

assign rnode_18to19_bb2_and35_i121_0_reg_19_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_17to18_bb2_and35_i121_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2_and35_i121_0_NO_SHIFT_REG = rnode_18to19_bb2_and35_i121_0_reg_19_NO_SHIFT_REG;
assign rnode_18to19_bb2_and35_i121_0_stall_in_reg_19_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2_and35_i121_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_align_0_i146_stall_local;
wire [31:0] local_bb2_align_0_i146;

assign local_bb2_align_0_i146 = (local_bb2_cmp69_i145 ? 32'h1F : local_bb2_and68_i144);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_19to20_bb2_and35_i121_0_valid_out_NO_SHIFT_REG;
 logic rnode_19to20_bb2_and35_i121_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_19to20_bb2_and35_i121_0_NO_SHIFT_REG;
 logic rnode_19to20_bb2_and35_i121_0_reg_20_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_19to20_bb2_and35_i121_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_and35_i121_0_valid_out_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_and35_i121_0_stall_in_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_and35_i121_0_stall_out_reg_20_NO_SHIFT_REG;

acl_data_fifo rnode_19to20_bb2_and35_i121_0_reg_20_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_19to20_bb2_and35_i121_0_reg_20_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_19to20_bb2_and35_i121_0_stall_in_reg_20_NO_SHIFT_REG),
	.valid_out(rnode_19to20_bb2_and35_i121_0_valid_out_reg_20_NO_SHIFT_REG),
	.stall_out(rnode_19to20_bb2_and35_i121_0_stall_out_reg_20_NO_SHIFT_REG),
	.data_in(rnode_18to19_bb2_and35_i121_0_NO_SHIFT_REG),
	.data_out(rnode_19to20_bb2_and35_i121_0_reg_20_NO_SHIFT_REG)
);

defparam rnode_19to20_bb2_and35_i121_0_reg_20_fifo.DEPTH = 1;
defparam rnode_19to20_bb2_and35_i121_0_reg_20_fifo.DATA_WIDTH = 32;
defparam rnode_19to20_bb2_and35_i121_0_reg_20_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_19to20_bb2_and35_i121_0_reg_20_fifo.IMPL = "shift_reg";

assign rnode_19to20_bb2_and35_i121_0_reg_20_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_18to19_bb2_and35_i121_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_and35_i121_0_NO_SHIFT_REG = rnode_19to20_bb2_and35_i121_0_reg_20_NO_SHIFT_REG;
assign rnode_19to20_bb2_and35_i121_0_stall_in_reg_20_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_and35_i121_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_and93_i154_stall_local;
wire [31:0] local_bb2_and93_i154;

assign local_bb2_and93_i154 = (local_bb2_align_0_i146 & 32'h1C);

// This section implements an unregistered operation.
// 
wire local_bb2_and95_i156_stall_local;
wire [31:0] local_bb2_and95_i156;

assign local_bb2_and95_i156 = (local_bb2_align_0_i146 & 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb2_and115_i172_stall_local;
wire [31:0] local_bb2_and115_i172;

assign local_bb2_and115_i172 = (local_bb2_align_0_i146 & 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb2_and130_i178_stall_local;
wire [31:0] local_bb2_and130_i178;

assign local_bb2_and130_i178 = (local_bb2_align_0_i146 & 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb2_shr16_i111_valid_out_1;
wire local_bb2_shr16_i111_stall_in_1;
 reg local_bb2_shr16_i111_consumed_1_NO_SHIFT_REG;
wire local_bb2_lnot23_i118_valid_out;
wire local_bb2_lnot23_i118_stall_in;
 reg local_bb2_lnot23_i118_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp27_i120_valid_out;
wire local_bb2_cmp27_i120_stall_in;
 reg local_bb2_cmp27_i120_consumed_0_NO_SHIFT_REG;
wire local_bb2_and93_i154_valid_out;
wire local_bb2_and93_i154_stall_in;
 reg local_bb2_and93_i154_consumed_0_NO_SHIFT_REG;
wire local_bb2_and95_i156_valid_out;
wire local_bb2_and95_i156_stall_in;
 reg local_bb2_and95_i156_consumed_0_NO_SHIFT_REG;
wire local_bb2_and115_i172_valid_out;
wire local_bb2_and115_i172_stall_in;
 reg local_bb2_and115_i172_consumed_0_NO_SHIFT_REG;
wire local_bb2_and130_i178_valid_out;
wire local_bb2_and130_i178_stall_in;
 reg local_bb2_and130_i178_consumed_0_NO_SHIFT_REG;
wire local_bb2_and149_i183_valid_out;
wire local_bb2_and149_i183_stall_in;
 reg local_bb2_and149_i183_consumed_0_NO_SHIFT_REG;
wire local_bb2_and149_i183_inputs_ready;
wire local_bb2_and149_i183_stall_local;
wire [31:0] local_bb2_and149_i183;

assign local_bb2_and149_i183_inputs_ready = (rnode_15to16_bb2__22_i109_0_valid_out_0_NO_SHIFT_REG & rnode_15to16_bb2__23_i110_0_valid_out_0_NO_SHIFT_REG);
assign local_bb2_and149_i183 = (local_bb2_align_0_i146 & 32'h3);
assign local_bb2_shr16_i111_valid_out_1 = 1'b1;
assign local_bb2_lnot23_i118_valid_out = 1'b1;
assign local_bb2_cmp27_i120_valid_out = 1'b1;
assign local_bb2_and93_i154_valid_out = 1'b1;
assign local_bb2_and95_i156_valid_out = 1'b1;
assign local_bb2_and115_i172_valid_out = 1'b1;
assign local_bb2_and130_i178_valid_out = 1'b1;
assign local_bb2_and149_i183_valid_out = 1'b1;
assign rnode_15to16_bb2__22_i109_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_15to16_bb2__23_i110_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_shr16_i111_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb2_lnot23_i118_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp27_i120_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_and93_i154_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_and95_i156_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_and115_i172_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_and130_i178_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_and149_i183_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_shr16_i111_consumed_1_NO_SHIFT_REG <= (local_bb2_and149_i183_inputs_ready & (local_bb2_shr16_i111_consumed_1_NO_SHIFT_REG | ~(local_bb2_shr16_i111_stall_in_1)) & local_bb2_and149_i183_stall_local);
		local_bb2_lnot23_i118_consumed_0_NO_SHIFT_REG <= (local_bb2_and149_i183_inputs_ready & (local_bb2_lnot23_i118_consumed_0_NO_SHIFT_REG | ~(local_bb2_lnot23_i118_stall_in)) & local_bb2_and149_i183_stall_local);
		local_bb2_cmp27_i120_consumed_0_NO_SHIFT_REG <= (local_bb2_and149_i183_inputs_ready & (local_bb2_cmp27_i120_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp27_i120_stall_in)) & local_bb2_and149_i183_stall_local);
		local_bb2_and93_i154_consumed_0_NO_SHIFT_REG <= (local_bb2_and149_i183_inputs_ready & (local_bb2_and93_i154_consumed_0_NO_SHIFT_REG | ~(local_bb2_and93_i154_stall_in)) & local_bb2_and149_i183_stall_local);
		local_bb2_and95_i156_consumed_0_NO_SHIFT_REG <= (local_bb2_and149_i183_inputs_ready & (local_bb2_and95_i156_consumed_0_NO_SHIFT_REG | ~(local_bb2_and95_i156_stall_in)) & local_bb2_and149_i183_stall_local);
		local_bb2_and115_i172_consumed_0_NO_SHIFT_REG <= (local_bb2_and149_i183_inputs_ready & (local_bb2_and115_i172_consumed_0_NO_SHIFT_REG | ~(local_bb2_and115_i172_stall_in)) & local_bb2_and149_i183_stall_local);
		local_bb2_and130_i178_consumed_0_NO_SHIFT_REG <= (local_bb2_and149_i183_inputs_ready & (local_bb2_and130_i178_consumed_0_NO_SHIFT_REG | ~(local_bb2_and130_i178_stall_in)) & local_bb2_and149_i183_stall_local);
		local_bb2_and149_i183_consumed_0_NO_SHIFT_REG <= (local_bb2_and149_i183_inputs_ready & (local_bb2_and149_i183_consumed_0_NO_SHIFT_REG | ~(local_bb2_and149_i183_stall_in)) & local_bb2_and149_i183_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_16to17_bb2_shr16_i111_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_16to17_bb2_shr16_i111_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2_shr16_i111_0_NO_SHIFT_REG;
 logic rnode_16to17_bb2_shr16_i111_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_16to17_bb2_shr16_i111_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2_shr16_i111_1_NO_SHIFT_REG;
 logic rnode_16to17_bb2_shr16_i111_0_reg_17_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2_shr16_i111_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_shr16_i111_0_valid_out_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_shr16_i111_0_stall_in_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_shr16_i111_0_stall_out_reg_17_NO_SHIFT_REG;

acl_data_fifo rnode_16to17_bb2_shr16_i111_0_reg_17_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_16to17_bb2_shr16_i111_0_reg_17_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_16to17_bb2_shr16_i111_0_stall_in_0_reg_17_NO_SHIFT_REG),
	.valid_out(rnode_16to17_bb2_shr16_i111_0_valid_out_0_reg_17_NO_SHIFT_REG),
	.stall_out(rnode_16to17_bb2_shr16_i111_0_stall_out_reg_17_NO_SHIFT_REG),
	.data_in(local_bb2_shr16_i111),
	.data_out(rnode_16to17_bb2_shr16_i111_0_reg_17_NO_SHIFT_REG)
);

defparam rnode_16to17_bb2_shr16_i111_0_reg_17_fifo.DEPTH = 1;
defparam rnode_16to17_bb2_shr16_i111_0_reg_17_fifo.DATA_WIDTH = 32;
defparam rnode_16to17_bb2_shr16_i111_0_reg_17_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_16to17_bb2_shr16_i111_0_reg_17_fifo.IMPL = "shift_reg";

assign rnode_16to17_bb2_shr16_i111_0_reg_17_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_shr16_i111_stall_in_1 = 1'b0;
assign rnode_16to17_bb2_shr16_i111_0_stall_in_0_reg_17_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_shr16_i111_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_16to17_bb2_shr16_i111_0_NO_SHIFT_REG = rnode_16to17_bb2_shr16_i111_0_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb2_shr16_i111_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_16to17_bb2_shr16_i111_1_NO_SHIFT_REG = rnode_16to17_bb2_shr16_i111_0_reg_17_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_16to17_bb2_lnot23_i118_0_valid_out_NO_SHIFT_REG;
 logic rnode_16to17_bb2_lnot23_i118_0_stall_in_NO_SHIFT_REG;
 logic rnode_16to17_bb2_lnot23_i118_0_NO_SHIFT_REG;
 logic rnode_16to17_bb2_lnot23_i118_0_reg_17_inputs_ready_NO_SHIFT_REG;
 logic rnode_16to17_bb2_lnot23_i118_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_lnot23_i118_0_valid_out_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_lnot23_i118_0_stall_in_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_lnot23_i118_0_stall_out_reg_17_NO_SHIFT_REG;

acl_data_fifo rnode_16to17_bb2_lnot23_i118_0_reg_17_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_16to17_bb2_lnot23_i118_0_reg_17_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_16to17_bb2_lnot23_i118_0_stall_in_reg_17_NO_SHIFT_REG),
	.valid_out(rnode_16to17_bb2_lnot23_i118_0_valid_out_reg_17_NO_SHIFT_REG),
	.stall_out(rnode_16to17_bb2_lnot23_i118_0_stall_out_reg_17_NO_SHIFT_REG),
	.data_in(local_bb2_lnot23_i118),
	.data_out(rnode_16to17_bb2_lnot23_i118_0_reg_17_NO_SHIFT_REG)
);

defparam rnode_16to17_bb2_lnot23_i118_0_reg_17_fifo.DEPTH = 1;
defparam rnode_16to17_bb2_lnot23_i118_0_reg_17_fifo.DATA_WIDTH = 1;
defparam rnode_16to17_bb2_lnot23_i118_0_reg_17_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_16to17_bb2_lnot23_i118_0_reg_17_fifo.IMPL = "shift_reg";

assign rnode_16to17_bb2_lnot23_i118_0_reg_17_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_lnot23_i118_stall_in = 1'b0;
assign rnode_16to17_bb2_lnot23_i118_0_NO_SHIFT_REG = rnode_16to17_bb2_lnot23_i118_0_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb2_lnot23_i118_0_stall_in_reg_17_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_lnot23_i118_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_16to17_bb2_cmp27_i120_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_16to17_bb2_cmp27_i120_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_16to17_bb2_cmp27_i120_0_NO_SHIFT_REG;
 logic rnode_16to17_bb2_cmp27_i120_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_16to17_bb2_cmp27_i120_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_16to17_bb2_cmp27_i120_1_NO_SHIFT_REG;
 logic rnode_16to17_bb2_cmp27_i120_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_16to17_bb2_cmp27_i120_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_16to17_bb2_cmp27_i120_2_NO_SHIFT_REG;
 logic rnode_16to17_bb2_cmp27_i120_0_reg_17_inputs_ready_NO_SHIFT_REG;
 logic rnode_16to17_bb2_cmp27_i120_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_cmp27_i120_0_valid_out_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_cmp27_i120_0_stall_in_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_cmp27_i120_0_stall_out_reg_17_NO_SHIFT_REG;

acl_data_fifo rnode_16to17_bb2_cmp27_i120_0_reg_17_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_16to17_bb2_cmp27_i120_0_reg_17_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_16to17_bb2_cmp27_i120_0_stall_in_0_reg_17_NO_SHIFT_REG),
	.valid_out(rnode_16to17_bb2_cmp27_i120_0_valid_out_0_reg_17_NO_SHIFT_REG),
	.stall_out(rnode_16to17_bb2_cmp27_i120_0_stall_out_reg_17_NO_SHIFT_REG),
	.data_in(local_bb2_cmp27_i120),
	.data_out(rnode_16to17_bb2_cmp27_i120_0_reg_17_NO_SHIFT_REG)
);

defparam rnode_16to17_bb2_cmp27_i120_0_reg_17_fifo.DEPTH = 1;
defparam rnode_16to17_bb2_cmp27_i120_0_reg_17_fifo.DATA_WIDTH = 1;
defparam rnode_16to17_bb2_cmp27_i120_0_reg_17_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_16to17_bb2_cmp27_i120_0_reg_17_fifo.IMPL = "shift_reg";

assign rnode_16to17_bb2_cmp27_i120_0_reg_17_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp27_i120_stall_in = 1'b0;
assign rnode_16to17_bb2_cmp27_i120_0_stall_in_0_reg_17_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_cmp27_i120_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_16to17_bb2_cmp27_i120_0_NO_SHIFT_REG = rnode_16to17_bb2_cmp27_i120_0_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb2_cmp27_i120_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_16to17_bb2_cmp27_i120_1_NO_SHIFT_REG = rnode_16to17_bb2_cmp27_i120_0_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb2_cmp27_i120_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_16to17_bb2_cmp27_i120_2_NO_SHIFT_REG = rnode_16to17_bb2_cmp27_i120_0_reg_17_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_16to17_bb2_and93_i154_0_valid_out_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and93_i154_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2_and93_i154_0_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and93_i154_0_reg_17_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2_and93_i154_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and93_i154_0_valid_out_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and93_i154_0_stall_in_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and93_i154_0_stall_out_reg_17_NO_SHIFT_REG;

acl_data_fifo rnode_16to17_bb2_and93_i154_0_reg_17_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_16to17_bb2_and93_i154_0_reg_17_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_16to17_bb2_and93_i154_0_stall_in_reg_17_NO_SHIFT_REG),
	.valid_out(rnode_16to17_bb2_and93_i154_0_valid_out_reg_17_NO_SHIFT_REG),
	.stall_out(rnode_16to17_bb2_and93_i154_0_stall_out_reg_17_NO_SHIFT_REG),
	.data_in(local_bb2_and93_i154),
	.data_out(rnode_16to17_bb2_and93_i154_0_reg_17_NO_SHIFT_REG)
);

defparam rnode_16to17_bb2_and93_i154_0_reg_17_fifo.DEPTH = 1;
defparam rnode_16to17_bb2_and93_i154_0_reg_17_fifo.DATA_WIDTH = 32;
defparam rnode_16to17_bb2_and93_i154_0_reg_17_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_16to17_bb2_and93_i154_0_reg_17_fifo.IMPL = "shift_reg";

assign rnode_16to17_bb2_and93_i154_0_reg_17_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and93_i154_stall_in = 1'b0;
assign rnode_16to17_bb2_and93_i154_0_NO_SHIFT_REG = rnode_16to17_bb2_and93_i154_0_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb2_and93_i154_0_stall_in_reg_17_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_and93_i154_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_16to17_bb2_and95_i156_0_valid_out_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and95_i156_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2_and95_i156_0_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and95_i156_0_reg_17_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2_and95_i156_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and95_i156_0_valid_out_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and95_i156_0_stall_in_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and95_i156_0_stall_out_reg_17_NO_SHIFT_REG;

acl_data_fifo rnode_16to17_bb2_and95_i156_0_reg_17_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_16to17_bb2_and95_i156_0_reg_17_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_16to17_bb2_and95_i156_0_stall_in_reg_17_NO_SHIFT_REG),
	.valid_out(rnode_16to17_bb2_and95_i156_0_valid_out_reg_17_NO_SHIFT_REG),
	.stall_out(rnode_16to17_bb2_and95_i156_0_stall_out_reg_17_NO_SHIFT_REG),
	.data_in(local_bb2_and95_i156),
	.data_out(rnode_16to17_bb2_and95_i156_0_reg_17_NO_SHIFT_REG)
);

defparam rnode_16to17_bb2_and95_i156_0_reg_17_fifo.DEPTH = 1;
defparam rnode_16to17_bb2_and95_i156_0_reg_17_fifo.DATA_WIDTH = 32;
defparam rnode_16to17_bb2_and95_i156_0_reg_17_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_16to17_bb2_and95_i156_0_reg_17_fifo.IMPL = "shift_reg";

assign rnode_16to17_bb2_and95_i156_0_reg_17_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and95_i156_stall_in = 1'b0;
assign rnode_16to17_bb2_and95_i156_0_NO_SHIFT_REG = rnode_16to17_bb2_and95_i156_0_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb2_and95_i156_0_stall_in_reg_17_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_and95_i156_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_16to17_bb2_and115_i172_0_valid_out_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and115_i172_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2_and115_i172_0_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and115_i172_0_reg_17_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2_and115_i172_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and115_i172_0_valid_out_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and115_i172_0_stall_in_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and115_i172_0_stall_out_reg_17_NO_SHIFT_REG;

acl_data_fifo rnode_16to17_bb2_and115_i172_0_reg_17_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_16to17_bb2_and115_i172_0_reg_17_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_16to17_bb2_and115_i172_0_stall_in_reg_17_NO_SHIFT_REG),
	.valid_out(rnode_16to17_bb2_and115_i172_0_valid_out_reg_17_NO_SHIFT_REG),
	.stall_out(rnode_16to17_bb2_and115_i172_0_stall_out_reg_17_NO_SHIFT_REG),
	.data_in(local_bb2_and115_i172),
	.data_out(rnode_16to17_bb2_and115_i172_0_reg_17_NO_SHIFT_REG)
);

defparam rnode_16to17_bb2_and115_i172_0_reg_17_fifo.DEPTH = 1;
defparam rnode_16to17_bb2_and115_i172_0_reg_17_fifo.DATA_WIDTH = 32;
defparam rnode_16to17_bb2_and115_i172_0_reg_17_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_16to17_bb2_and115_i172_0_reg_17_fifo.IMPL = "shift_reg";

assign rnode_16to17_bb2_and115_i172_0_reg_17_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and115_i172_stall_in = 1'b0;
assign rnode_16to17_bb2_and115_i172_0_NO_SHIFT_REG = rnode_16to17_bb2_and115_i172_0_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb2_and115_i172_0_stall_in_reg_17_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_and115_i172_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_16to17_bb2_and130_i178_0_valid_out_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and130_i178_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2_and130_i178_0_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and130_i178_0_reg_17_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2_and130_i178_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and130_i178_0_valid_out_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and130_i178_0_stall_in_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and130_i178_0_stall_out_reg_17_NO_SHIFT_REG;

acl_data_fifo rnode_16to17_bb2_and130_i178_0_reg_17_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_16to17_bb2_and130_i178_0_reg_17_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_16to17_bb2_and130_i178_0_stall_in_reg_17_NO_SHIFT_REG),
	.valid_out(rnode_16to17_bb2_and130_i178_0_valid_out_reg_17_NO_SHIFT_REG),
	.stall_out(rnode_16to17_bb2_and130_i178_0_stall_out_reg_17_NO_SHIFT_REG),
	.data_in(local_bb2_and130_i178),
	.data_out(rnode_16to17_bb2_and130_i178_0_reg_17_NO_SHIFT_REG)
);

defparam rnode_16to17_bb2_and130_i178_0_reg_17_fifo.DEPTH = 1;
defparam rnode_16to17_bb2_and130_i178_0_reg_17_fifo.DATA_WIDTH = 32;
defparam rnode_16to17_bb2_and130_i178_0_reg_17_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_16to17_bb2_and130_i178_0_reg_17_fifo.IMPL = "shift_reg";

assign rnode_16to17_bb2_and130_i178_0_reg_17_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and130_i178_stall_in = 1'b0;
assign rnode_16to17_bb2_and130_i178_0_NO_SHIFT_REG = rnode_16to17_bb2_and130_i178_0_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb2_and130_i178_0_stall_in_reg_17_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_and130_i178_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_16to17_bb2_and149_i183_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and149_i183_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2_and149_i183_0_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and149_i183_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and149_i183_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2_and149_i183_1_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and149_i183_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and149_i183_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2_and149_i183_2_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and149_i183_0_reg_17_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_16to17_bb2_and149_i183_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and149_i183_0_valid_out_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and149_i183_0_stall_in_0_reg_17_NO_SHIFT_REG;
 logic rnode_16to17_bb2_and149_i183_0_stall_out_reg_17_NO_SHIFT_REG;

acl_data_fifo rnode_16to17_bb2_and149_i183_0_reg_17_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_16to17_bb2_and149_i183_0_reg_17_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_16to17_bb2_and149_i183_0_stall_in_0_reg_17_NO_SHIFT_REG),
	.valid_out(rnode_16to17_bb2_and149_i183_0_valid_out_0_reg_17_NO_SHIFT_REG),
	.stall_out(rnode_16to17_bb2_and149_i183_0_stall_out_reg_17_NO_SHIFT_REG),
	.data_in(local_bb2_and149_i183),
	.data_out(rnode_16to17_bb2_and149_i183_0_reg_17_NO_SHIFT_REG)
);

defparam rnode_16to17_bb2_and149_i183_0_reg_17_fifo.DEPTH = 1;
defparam rnode_16to17_bb2_and149_i183_0_reg_17_fifo.DATA_WIDTH = 32;
defparam rnode_16to17_bb2_and149_i183_0_reg_17_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_16to17_bb2_and149_i183_0_reg_17_fifo.IMPL = "shift_reg";

assign rnode_16to17_bb2_and149_i183_0_reg_17_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and149_i183_stall_in = 1'b0;
assign rnode_16to17_bb2_and149_i183_0_stall_in_0_reg_17_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_and149_i183_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_16to17_bb2_and149_i183_0_NO_SHIFT_REG = rnode_16to17_bb2_and149_i183_0_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb2_and149_i183_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_16to17_bb2_and149_i183_1_NO_SHIFT_REG = rnode_16to17_bb2_and149_i183_0_reg_17_NO_SHIFT_REG;
assign rnode_16to17_bb2_and149_i183_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_16to17_bb2_and149_i183_2_NO_SHIFT_REG = rnode_16to17_bb2_and149_i183_0_reg_17_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_and17_i112_stall_local;
wire [31:0] local_bb2_and17_i112;

assign local_bb2_and17_i112 = (rnode_16to17_bb2_shr16_i111_0_NO_SHIFT_REG & 32'hFF);

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_17to19_bb2_shr16_i111_0_valid_out_NO_SHIFT_REG;
 logic rnode_17to19_bb2_shr16_i111_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_17to19_bb2_shr16_i111_0_NO_SHIFT_REG;
 logic rnode_17to19_bb2_shr16_i111_0_reg_19_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_17to19_bb2_shr16_i111_0_reg_19_NO_SHIFT_REG;
 logic rnode_17to19_bb2_shr16_i111_0_valid_out_reg_19_NO_SHIFT_REG;
 logic rnode_17to19_bb2_shr16_i111_0_stall_in_reg_19_NO_SHIFT_REG;
 logic rnode_17to19_bb2_shr16_i111_0_stall_out_reg_19_NO_SHIFT_REG;

acl_data_fifo rnode_17to19_bb2_shr16_i111_0_reg_19_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_17to19_bb2_shr16_i111_0_reg_19_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_17to19_bb2_shr16_i111_0_stall_in_reg_19_NO_SHIFT_REG),
	.valid_out(rnode_17to19_bb2_shr16_i111_0_valid_out_reg_19_NO_SHIFT_REG),
	.stall_out(rnode_17to19_bb2_shr16_i111_0_stall_out_reg_19_NO_SHIFT_REG),
	.data_in(rnode_16to17_bb2_shr16_i111_1_NO_SHIFT_REG),
	.data_out(rnode_17to19_bb2_shr16_i111_0_reg_19_NO_SHIFT_REG)
);

defparam rnode_17to19_bb2_shr16_i111_0_reg_19_fifo.DEPTH = 2;
defparam rnode_17to19_bb2_shr16_i111_0_reg_19_fifo.DATA_WIDTH = 32;
defparam rnode_17to19_bb2_shr16_i111_0_reg_19_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_17to19_bb2_shr16_i111_0_reg_19_fifo.IMPL = "shift_reg";

assign rnode_17to19_bb2_shr16_i111_0_reg_19_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_16to17_bb2_shr16_i111_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_17to19_bb2_shr16_i111_0_NO_SHIFT_REG = rnode_17to19_bb2_shr16_i111_0_reg_19_NO_SHIFT_REG;
assign rnode_17to19_bb2_shr16_i111_0_stall_in_reg_19_NO_SHIFT_REG = 1'b0;
assign rnode_17to19_bb2_shr16_i111_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2__28_i142_stall_local;
wire [31:0] local_bb2__28_i142;

assign local_bb2__28_i142 = (rnode_16to17_bb2_lnot23_i118_0_NO_SHIFT_REG ? 32'h0 : local_bb2_shl65_i141);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge_not_i128_stall_local;
wire local_bb2_brmerge_not_i128;

assign local_bb2_brmerge_not_i128 = (rnode_16to17_bb2_cmp27_i120_0_NO_SHIFT_REG & local_bb2_lnot33_not_i127);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp96_i157_stall_local;
wire local_bb2_cmp96_i157;

assign local_bb2_cmp96_i157 = (rnode_16to17_bb2_and95_i156_0_NO_SHIFT_REG == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp116_i173_stall_local;
wire local_bb2_cmp116_i173;

assign local_bb2_cmp116_i173 = (rnode_16to17_bb2_and115_i172_0_NO_SHIFT_REG == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp131_not_i180_stall_local;
wire local_bb2_cmp131_not_i180;

assign local_bb2_cmp131_not_i180 = (rnode_16to17_bb2_and130_i178_0_NO_SHIFT_REG != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_Pivot20_i185_stall_local;
wire local_bb2_Pivot20_i185;

assign local_bb2_Pivot20_i185 = (rnode_16to17_bb2_and149_i183_1_NO_SHIFT_REG < 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb2_SwitchLeaf_i186_stall_local;
wire local_bb2_SwitchLeaf_i186;

assign local_bb2_SwitchLeaf_i186 = (rnode_16to17_bb2_and149_i183_2_NO_SHIFT_REG == 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_i117_stall_local;
wire local_bb2_lnot_i117;

assign local_bb2_lnot_i117 = (local_bb2_and17_i112 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp25_i119_stall_local;
wire local_bb2_cmp25_i119;

assign local_bb2_cmp25_i119 = (local_bb2_and17_i112 == 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and72_i147_stall_local;
wire [31:0] local_bb2_and72_i147;

assign local_bb2_and72_i147 = (local_bb2__28_i142 >> 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb2_and75_i150_stall_local;
wire [31:0] local_bb2_and75_i150;

assign local_bb2_and75_i150 = (local_bb2__28_i142 & 32'hF0);

// This section implements an unregistered operation.
// 
wire local_bb2_and78_i152_stall_local;
wire [31:0] local_bb2_and78_i152;

assign local_bb2_and78_i152 = (local_bb2__28_i142 & 32'hF00);

// This section implements an unregistered operation.
// 
wire local_bb2_shr94_i155_stall_local;
wire [31:0] local_bb2_shr94_i155;

assign local_bb2_shr94_i155 = (local_bb2__28_i142 >> rnode_16to17_bb2_and93_i154_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_and90_i158_stall_local;
wire [31:0] local_bb2_and90_i158;

assign local_bb2_and90_i158 = (local_bb2__28_i142 & 32'h7000000);

// This section implements an unregistered operation.
// 
wire local_bb2_and87_i159_stall_local;
wire [31:0] local_bb2_and87_i159;

assign local_bb2_and87_i159 = (local_bb2__28_i142 & 32'hF00000);

// This section implements an unregistered operation.
// 
wire local_bb2_and84_i160_stall_local;
wire [31:0] local_bb2_and84_i160;

assign local_bb2_and84_i160 = (local_bb2__28_i142 & 32'hF0000);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u30_stall_local;
wire [31:0] local_bb2_var__u30;

assign local_bb2_var__u30 = (local_bb2__28_i142 & 32'hFFF8);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge_not_not_i132_stall_local;
wire local_bb2_brmerge_not_not_i132;

assign local_bb2_brmerge_not_not_i132 = (local_bb2_brmerge_not_i128 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2__27_i139_stall_local;
wire [31:0] local_bb2__27_i139;

assign local_bb2__27_i139 = (local_bb2_lnot_i117 ? 32'h0 : local_bb2_shl_i138);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp25_not_i124_stall_local;
wire local_bb2_cmp25_not_i124;

assign local_bb2_cmp25_not_i124 = (local_bb2_cmp25_i119 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_or_cond_not_i130_stall_local;
wire local_bb2_or_cond_not_i130;

assign local_bb2_or_cond_not_i130 = (local_bb2_cmp25_i119 & local_bb2_lnot30_not_i129);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u31_stall_local;
wire local_bb2_var__u31;

assign local_bb2_var__u31 = (local_bb2_cmp25_i119 | rnode_16to17_bb2_cmp27_i120_2_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_and72_tr_i148_stall_local;
wire [7:0] local_bb2_and72_tr_i148;

assign local_bb2_and72_tr_i148 = local_bb2_and72_i147[7:0];

// This section implements an unregistered operation.
// 
wire local_bb2_cmp76_i151_stall_local;
wire local_bb2_cmp76_i151;

assign local_bb2_cmp76_i151 = (local_bb2_and75_i150 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp79_i153_stall_local;
wire local_bb2_cmp79_i153;

assign local_bb2_cmp79_i153 = (local_bb2_and78_i152 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_and142_i182_stall_local;
wire [31:0] local_bb2_and142_i182;

assign local_bb2_and142_i182 = (local_bb2_shr94_i155 >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_shr150_i184_stall_local;
wire [31:0] local_bb2_shr150_i184;

assign local_bb2_shr150_i184 = (local_bb2_shr94_i155 >> rnode_16to17_bb2_and149_i183_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u32_stall_local;
wire [31:0] local_bb2_var__u32;

assign local_bb2_var__u32 = (local_bb2_shr94_i155 & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_and146_i187_stall_local;
wire [31:0] local_bb2_and146_i187;

assign local_bb2_and146_i187 = (local_bb2_shr94_i155 >> 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp91_i161_stall_local;
wire local_bb2_cmp91_i161;

assign local_bb2_cmp91_i161 = (local_bb2_and90_i158 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp88_i162_stall_local;
wire local_bb2_cmp88_i162;

assign local_bb2_cmp88_i162 = (local_bb2_and87_i159 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp85_i163_stall_local;
wire local_bb2_cmp85_i163;

assign local_bb2_cmp85_i163 = (local_bb2_and84_i160 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u33_stall_local;
wire local_bb2_var__u33;

assign local_bb2_var__u33 = (local_bb2_var__u30 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_7_i133_stall_local;
wire local_bb2_reduction_7_i133;

assign local_bb2_reduction_7_i133 = (local_bb2_cmp25_i119 & local_bb2_brmerge_not_not_i132);

// This section implements an unregistered operation.
// 
wire local_bb2_add_i199_stall_local;
wire [31:0] local_bb2_add_i199;

assign local_bb2_add_i199 = (local_bb2__27_i139 | local_bb2_and36_lobit_i198);

// This section implements an unregistered operation.
// 
wire local_bb2_or_cond_i126_stall_local;
wire local_bb2_or_cond_i126;

assign local_bb2_or_cond_i126 = (local_bb2_lnot30_i125 | local_bb2_cmp25_not_i124);

// This section implements an unregistered operation.
// 
wire local_bb2__24_i131_stall_local;
wire local_bb2__24_i131;

assign local_bb2__24_i131 = (local_bb2_or_cond_not_i130 | local_bb2_brmerge_not_i128);

// This section implements an unregistered operation.
// 
wire local_bb2_frombool74_i149_stall_local;
wire [7:0] local_bb2_frombool74_i149;

assign local_bb2_frombool74_i149 = (local_bb2_and72_tr_i148 & 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u34_stall_local;
wire [31:0] local_bb2_var__u34;

assign local_bb2_var__u34 = (local_bb2_and146_i187 | local_bb2_shr94_i155);

// This section implements an unregistered operation.
// 
wire local_bb2__31_v_i169_stall_local;
wire local_bb2__31_v_i169;

assign local_bb2__31_v_i169 = (local_bb2_cmp96_i157 ? local_bb2_cmp79_i153 : local_bb2_cmp91_i161);

// This section implements an unregistered operation.
// 
wire local_bb2__30_v_i167_stall_local;
wire local_bb2__30_v_i167;

assign local_bb2__30_v_i167 = (local_bb2_cmp96_i157 ? local_bb2_cmp76_i151 : local_bb2_cmp88_i162);

// This section implements an unregistered operation.
// 
wire local_bb2_frombool109_i165_stall_local;
wire [7:0] local_bb2_frombool109_i165;

assign local_bb2_frombool109_i165[7:1] = 7'h0;
assign local_bb2_frombool109_i165[0] = local_bb2_cmp85_i163;

// This section implements an unregistered operation.
// 
wire local_bb2_or107_i164_stall_local;
wire [31:0] local_bb2_or107_i164;

assign local_bb2_or107_i164[31:1] = 31'h0;
assign local_bb2_or107_i164[0] = local_bb2_var__u33;

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_8_i134_stall_local;
wire local_bb2_reduction_8_i134;

assign local_bb2_reduction_8_i134 = (rnode_16to17_bb2_cmp27_i120_1_NO_SHIFT_REG & local_bb2_or_cond_i126);

// This section implements an unregistered operation.
// 
wire local_bb2_or1596_i188_stall_local;
wire [31:0] local_bb2_or1596_i188;

assign local_bb2_or1596_i188 = (local_bb2_var__u34 | local_bb2_and142_i182);

// This section implements an unregistered operation.
// 
wire local_bb2__31_i170_stall_local;
wire [7:0] local_bb2__31_i170;

assign local_bb2__31_i170[7:1] = 7'h0;
assign local_bb2__31_i170[0] = local_bb2__31_v_i169;

// This section implements an unregistered operation.
// 
wire local_bb2__30_i168_stall_local;
wire [7:0] local_bb2__30_i168;

assign local_bb2__30_i168[7:1] = 7'h0;
assign local_bb2__30_i168[0] = local_bb2__30_v_i167;

// This section implements an unregistered operation.
// 
wire local_bb2__29_i166_stall_local;
wire [7:0] local_bb2__29_i166;

assign local_bb2__29_i166 = (local_bb2_cmp96_i157 ? local_bb2_frombool74_i149 : local_bb2_frombool109_i165);

// This section implements an unregistered operation.
// 
wire local_bb2__32_i171_stall_local;
wire [31:0] local_bb2__32_i171;

assign local_bb2__32_i171 = (local_bb2_cmp96_i157 ? 32'h0 : local_bb2_or107_i164);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_9_i135_stall_local;
wire local_bb2_reduction_9_i135;

assign local_bb2_reduction_9_i135 = (local_bb2_reduction_7_i133 & local_bb2_reduction_8_i134);

// This section implements an unregistered operation.
// 
wire local_bb2_or162_i189_stall_local;
wire [31:0] local_bb2_or162_i189;

assign local_bb2_or162_i189 = (local_bb2_or1596_i188 & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_or1237_i174_stall_local;
wire [7:0] local_bb2_or1237_i174;

assign local_bb2_or1237_i174 = (local_bb2__30_i168 | local_bb2__29_i166);

// This section implements an unregistered operation.
// 
wire local_bb2__33_i176_stall_local;
wire [7:0] local_bb2__33_i176;

assign local_bb2__33_i176 = (local_bb2_cmp116_i173 ? local_bb2__29_i166 : local_bb2__31_i170);

// This section implements an unregistered operation.
// 
wire local_bb2__26_i136_stall_local;
wire local_bb2__26_i136;

assign local_bb2__26_i136 = (local_bb2_reduction_9_i135 ? local_bb2_cmp37_i123 : local_bb2__24_i131);

// This section implements an unregistered operation.
// 
wire local_bb2__37_v_i190_stall_local;
wire [31:0] local_bb2__37_v_i190;

assign local_bb2__37_v_i190 = (local_bb2_Pivot20_i185 ? 32'h0 : local_bb2_or162_i189);

// This section implements an unregistered operation.
// 
wire local_bb2_or123_i175_stall_local;
wire [31:0] local_bb2_or123_i175;

assign local_bb2_or123_i175[31:8] = 24'h0;
assign local_bb2_or123_i175[7:0] = local_bb2_or1237_i174;

// This section implements an unregistered operation.
// 
wire local_bb2_var__u35_stall_local;
wire [7:0] local_bb2_var__u35;

assign local_bb2_var__u35 = (local_bb2__33_i176 & 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb2__39_v_i191_stall_local;
wire [31:0] local_bb2__39_v_i191;

assign local_bb2__39_v_i191 = (local_bb2_SwitchLeaf_i186 ? local_bb2_var__u32 : local_bb2__37_v_i190);

// This section implements an unregistered operation.
// 
wire local_bb2_or124_i177_stall_local;
wire [31:0] local_bb2_or124_i177;

assign local_bb2_or124_i177 = (local_bb2_cmp116_i173 ? 32'h0 : local_bb2_or123_i175);

// This section implements an unregistered operation.
// 
wire local_bb2_conv135_i179_stall_local;
wire [31:0] local_bb2_conv135_i179;

assign local_bb2_conv135_i179[31:8] = 24'h0;
assign local_bb2_conv135_i179[7:0] = local_bb2_var__u35;

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_3_i192_stall_local;
wire [31:0] local_bb2_reduction_3_i192;

assign local_bb2_reduction_3_i192 = (local_bb2__32_i171 | local_bb2_or124_i177);

// This section implements an unregistered operation.
// 
wire local_bb2_or136_i181_stall_local;
wire [31:0] local_bb2_or136_i181;

assign local_bb2_or136_i181 = (local_bb2_cmp131_not_i180 ? local_bb2_conv135_i179 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_5_i194_stall_local;
wire [31:0] local_bb2_reduction_5_i194;

assign local_bb2_reduction_5_i194 = (local_bb2_shr150_i184 | local_bb2_reduction_3_i192);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_4_i193_stall_local;
wire [31:0] local_bb2_reduction_4_i193;

assign local_bb2_reduction_4_i193 = (local_bb2_or136_i181 | local_bb2__39_v_i191);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_6_i195_stall_local;
wire [31:0] local_bb2_reduction_6_i195;

assign local_bb2_reduction_6_i195 = (local_bb2_reduction_4_i193 | local_bb2_reduction_5_i194);

// This section implements an unregistered operation.
// 
wire local_bb2_xor188_i197_stall_local;
wire [31:0] local_bb2_xor188_i197;

assign local_bb2_xor188_i197 = (local_bb2_reduction_6_i195 ^ local_bb2_xor_lobit_i196);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp37_i123_valid_out_1;
wire local_bb2_cmp37_i123_stall_in_1;
 reg local_bb2_cmp37_i123_consumed_1_NO_SHIFT_REG;
wire local_bb2__26_i136_valid_out;
wire local_bb2__26_i136_stall_in;
 reg local_bb2__26_i136_consumed_0_NO_SHIFT_REG;
wire local_bb2_add192_i200_valid_out;
wire local_bb2_add192_i200_stall_in;
 reg local_bb2_add192_i200_consumed_0_NO_SHIFT_REG;
wire local_bb2_and17_i112_valid_out_2;
wire local_bb2_and17_i112_stall_in_2;
 reg local_bb2_and17_i112_consumed_2_NO_SHIFT_REG;
wire local_bb2_var__u31_valid_out;
wire local_bb2_var__u31_stall_in;
 reg local_bb2_var__u31_consumed_0_NO_SHIFT_REG;
wire local_bb2_add192_i200_inputs_ready;
wire local_bb2_add192_i200_stall_local;
wire [31:0] local_bb2_add192_i200;

assign local_bb2_add192_i200_inputs_ready = (rnode_16to17_bb2__22_i109_0_valid_out_0_NO_SHIFT_REG & rnode_16to17_bb2_cmp27_i120_0_valid_out_0_NO_SHIFT_REG & rnode_16to17_bb2_lnot23_i118_0_valid_out_NO_SHIFT_REG & rnode_16to17_bb2_and93_i154_0_valid_out_NO_SHIFT_REG & rnode_16to17_bb2__22_i109_0_valid_out_1_NO_SHIFT_REG & rnode_16to17_bb2__23_i110_0_valid_out_2_NO_SHIFT_REG & rnode_16to17_bb2__23_i110_0_valid_out_0_NO_SHIFT_REG & rnode_16to17_bb2_cmp27_i120_0_valid_out_1_NO_SHIFT_REG & rnode_16to17_bb2_shr16_i111_0_valid_out_0_NO_SHIFT_REG & rnode_16to17_bb2_cmp27_i120_0_valid_out_2_NO_SHIFT_REG & rnode_16to17_bb2_and149_i183_0_valid_out_0_NO_SHIFT_REG & rnode_16to17_bb2_and95_i156_0_valid_out_NO_SHIFT_REG & rnode_16to17_bb2_and149_i183_0_valid_out_2_NO_SHIFT_REG & rnode_16to17_bb2_and115_i172_0_valid_out_NO_SHIFT_REG & rnode_16to17_bb2_and130_i178_0_valid_out_NO_SHIFT_REG & rnode_16to17_bb2_and149_i183_0_valid_out_1_NO_SHIFT_REG);
assign local_bb2_add192_i200 = (local_bb2_add_i199 + local_bb2_xor188_i197);
assign local_bb2_cmp37_i123_valid_out_1 = 1'b1;
assign local_bb2__26_i136_valid_out = 1'b1;
assign local_bb2_add192_i200_valid_out = 1'b1;
assign local_bb2_and17_i112_valid_out_2 = 1'b1;
assign local_bb2_var__u31_valid_out = 1'b1;
assign rnode_16to17_bb2__22_i109_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_cmp27_i120_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_lnot23_i118_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_and93_i154_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2__22_i109_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2__23_i110_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2__23_i110_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_cmp27_i120_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_shr16_i111_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_cmp27_i120_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_and149_i183_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_and95_i156_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_and149_i183_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_and115_i172_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_and130_i178_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_16to17_bb2_and149_i183_0_stall_in_1_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_cmp37_i123_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb2__26_i136_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_add192_i200_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_and17_i112_consumed_2_NO_SHIFT_REG <= 1'b0;
		local_bb2_var__u31_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_cmp37_i123_consumed_1_NO_SHIFT_REG <= (local_bb2_add192_i200_inputs_ready & (local_bb2_cmp37_i123_consumed_1_NO_SHIFT_REG | ~(local_bb2_cmp37_i123_stall_in_1)) & local_bb2_add192_i200_stall_local);
		local_bb2__26_i136_consumed_0_NO_SHIFT_REG <= (local_bb2_add192_i200_inputs_ready & (local_bb2__26_i136_consumed_0_NO_SHIFT_REG | ~(local_bb2__26_i136_stall_in)) & local_bb2_add192_i200_stall_local);
		local_bb2_add192_i200_consumed_0_NO_SHIFT_REG <= (local_bb2_add192_i200_inputs_ready & (local_bb2_add192_i200_consumed_0_NO_SHIFT_REG | ~(local_bb2_add192_i200_stall_in)) & local_bb2_add192_i200_stall_local);
		local_bb2_and17_i112_consumed_2_NO_SHIFT_REG <= (local_bb2_add192_i200_inputs_ready & (local_bb2_and17_i112_consumed_2_NO_SHIFT_REG | ~(local_bb2_and17_i112_stall_in_2)) & local_bb2_add192_i200_stall_local);
		local_bb2_var__u31_consumed_0_NO_SHIFT_REG <= (local_bb2_add192_i200_inputs_ready & (local_bb2_var__u31_consumed_0_NO_SHIFT_REG | ~(local_bb2_var__u31_stall_in)) & local_bb2_add192_i200_stall_local);
	end
end


// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_17to19_bb2_cmp37_i123_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_17to19_bb2_cmp37_i123_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_17to19_bb2_cmp37_i123_0_NO_SHIFT_REG;
 logic rnode_17to19_bb2_cmp37_i123_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_17to19_bb2_cmp37_i123_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_17to19_bb2_cmp37_i123_1_NO_SHIFT_REG;
 logic rnode_17to19_bb2_cmp37_i123_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_17to19_bb2_cmp37_i123_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_17to19_bb2_cmp37_i123_2_NO_SHIFT_REG;
 logic rnode_17to19_bb2_cmp37_i123_0_reg_19_inputs_ready_NO_SHIFT_REG;
 logic rnode_17to19_bb2_cmp37_i123_0_reg_19_NO_SHIFT_REG;
 logic rnode_17to19_bb2_cmp37_i123_0_valid_out_0_reg_19_NO_SHIFT_REG;
 logic rnode_17to19_bb2_cmp37_i123_0_stall_in_0_reg_19_NO_SHIFT_REG;
 logic rnode_17to19_bb2_cmp37_i123_0_stall_out_reg_19_NO_SHIFT_REG;

acl_data_fifo rnode_17to19_bb2_cmp37_i123_0_reg_19_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_17to19_bb2_cmp37_i123_0_reg_19_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_17to19_bb2_cmp37_i123_0_stall_in_0_reg_19_NO_SHIFT_REG),
	.valid_out(rnode_17to19_bb2_cmp37_i123_0_valid_out_0_reg_19_NO_SHIFT_REG),
	.stall_out(rnode_17to19_bb2_cmp37_i123_0_stall_out_reg_19_NO_SHIFT_REG),
	.data_in(local_bb2_cmp37_i123),
	.data_out(rnode_17to19_bb2_cmp37_i123_0_reg_19_NO_SHIFT_REG)
);

defparam rnode_17to19_bb2_cmp37_i123_0_reg_19_fifo.DEPTH = 2;
defparam rnode_17to19_bb2_cmp37_i123_0_reg_19_fifo.DATA_WIDTH = 1;
defparam rnode_17to19_bb2_cmp37_i123_0_reg_19_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_17to19_bb2_cmp37_i123_0_reg_19_fifo.IMPL = "shift_reg";

assign rnode_17to19_bb2_cmp37_i123_0_reg_19_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp37_i123_stall_in_1 = 1'b0;
assign rnode_17to19_bb2_cmp37_i123_0_stall_in_0_reg_19_NO_SHIFT_REG = 1'b0;
assign rnode_17to19_bb2_cmp37_i123_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_17to19_bb2_cmp37_i123_0_NO_SHIFT_REG = rnode_17to19_bb2_cmp37_i123_0_reg_19_NO_SHIFT_REG;
assign rnode_17to19_bb2_cmp37_i123_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_17to19_bb2_cmp37_i123_1_NO_SHIFT_REG = rnode_17to19_bb2_cmp37_i123_0_reg_19_NO_SHIFT_REG;
assign rnode_17to19_bb2_cmp37_i123_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_17to19_bb2_cmp37_i123_2_NO_SHIFT_REG = rnode_17to19_bb2_cmp37_i123_0_reg_19_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_17to18_bb2__26_i136_0_valid_out_NO_SHIFT_REG;
 logic rnode_17to18_bb2__26_i136_0_stall_in_NO_SHIFT_REG;
 logic rnode_17to18_bb2__26_i136_0_NO_SHIFT_REG;
 logic rnode_17to18_bb2__26_i136_0_reg_18_inputs_ready_NO_SHIFT_REG;
 logic rnode_17to18_bb2__26_i136_0_reg_18_NO_SHIFT_REG;
 logic rnode_17to18_bb2__26_i136_0_valid_out_reg_18_NO_SHIFT_REG;
 logic rnode_17to18_bb2__26_i136_0_stall_in_reg_18_NO_SHIFT_REG;
 logic rnode_17to18_bb2__26_i136_0_stall_out_reg_18_NO_SHIFT_REG;

acl_data_fifo rnode_17to18_bb2__26_i136_0_reg_18_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_17to18_bb2__26_i136_0_reg_18_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_17to18_bb2__26_i136_0_stall_in_reg_18_NO_SHIFT_REG),
	.valid_out(rnode_17to18_bb2__26_i136_0_valid_out_reg_18_NO_SHIFT_REG),
	.stall_out(rnode_17to18_bb2__26_i136_0_stall_out_reg_18_NO_SHIFT_REG),
	.data_in(local_bb2__26_i136),
	.data_out(rnode_17to18_bb2__26_i136_0_reg_18_NO_SHIFT_REG)
);

defparam rnode_17to18_bb2__26_i136_0_reg_18_fifo.DEPTH = 1;
defparam rnode_17to18_bb2__26_i136_0_reg_18_fifo.DATA_WIDTH = 1;
defparam rnode_17to18_bb2__26_i136_0_reg_18_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_17to18_bb2__26_i136_0_reg_18_fifo.IMPL = "shift_reg";

assign rnode_17to18_bb2__26_i136_0_reg_18_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__26_i136_stall_in = 1'b0;
assign rnode_17to18_bb2__26_i136_0_NO_SHIFT_REG = rnode_17to18_bb2__26_i136_0_reg_18_NO_SHIFT_REG;
assign rnode_17to18_bb2__26_i136_0_stall_in_reg_18_NO_SHIFT_REG = 1'b0;
assign rnode_17to18_bb2__26_i136_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_17to18_bb2_add192_i200_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_17to18_bb2_add192_i200_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_17to18_bb2_add192_i200_0_NO_SHIFT_REG;
 logic rnode_17to18_bb2_add192_i200_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_17to18_bb2_add192_i200_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_17to18_bb2_add192_i200_1_NO_SHIFT_REG;
 logic rnode_17to18_bb2_add192_i200_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_17to18_bb2_add192_i200_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_17to18_bb2_add192_i200_2_NO_SHIFT_REG;
 logic rnode_17to18_bb2_add192_i200_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_17to18_bb2_add192_i200_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_17to18_bb2_add192_i200_3_NO_SHIFT_REG;
 logic rnode_17to18_bb2_add192_i200_0_reg_18_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_17to18_bb2_add192_i200_0_reg_18_NO_SHIFT_REG;
 logic rnode_17to18_bb2_add192_i200_0_valid_out_0_reg_18_NO_SHIFT_REG;
 logic rnode_17to18_bb2_add192_i200_0_stall_in_0_reg_18_NO_SHIFT_REG;
 logic rnode_17to18_bb2_add192_i200_0_stall_out_reg_18_NO_SHIFT_REG;

acl_data_fifo rnode_17to18_bb2_add192_i200_0_reg_18_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_17to18_bb2_add192_i200_0_reg_18_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_17to18_bb2_add192_i200_0_stall_in_0_reg_18_NO_SHIFT_REG),
	.valid_out(rnode_17to18_bb2_add192_i200_0_valid_out_0_reg_18_NO_SHIFT_REG),
	.stall_out(rnode_17to18_bb2_add192_i200_0_stall_out_reg_18_NO_SHIFT_REG),
	.data_in(local_bb2_add192_i200),
	.data_out(rnode_17to18_bb2_add192_i200_0_reg_18_NO_SHIFT_REG)
);

defparam rnode_17to18_bb2_add192_i200_0_reg_18_fifo.DEPTH = 1;
defparam rnode_17to18_bb2_add192_i200_0_reg_18_fifo.DATA_WIDTH = 32;
defparam rnode_17to18_bb2_add192_i200_0_reg_18_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_17to18_bb2_add192_i200_0_reg_18_fifo.IMPL = "shift_reg";

assign rnode_17to18_bb2_add192_i200_0_reg_18_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_add192_i200_stall_in = 1'b0;
assign rnode_17to18_bb2_add192_i200_0_stall_in_0_reg_18_NO_SHIFT_REG = 1'b0;
assign rnode_17to18_bb2_add192_i200_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_17to18_bb2_add192_i200_0_NO_SHIFT_REG = rnode_17to18_bb2_add192_i200_0_reg_18_NO_SHIFT_REG;
assign rnode_17to18_bb2_add192_i200_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_17to18_bb2_add192_i200_1_NO_SHIFT_REG = rnode_17to18_bb2_add192_i200_0_reg_18_NO_SHIFT_REG;
assign rnode_17to18_bb2_add192_i200_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_17to18_bb2_add192_i200_2_NO_SHIFT_REG = rnode_17to18_bb2_add192_i200_0_reg_18_NO_SHIFT_REG;
assign rnode_17to18_bb2_add192_i200_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_17to18_bb2_add192_i200_3_NO_SHIFT_REG = rnode_17to18_bb2_add192_i200_0_reg_18_NO_SHIFT_REG;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_17to19_bb2_and17_i112_0_valid_out_NO_SHIFT_REG;
 logic rnode_17to19_bb2_and17_i112_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_17to19_bb2_and17_i112_0_NO_SHIFT_REG;
 logic rnode_17to19_bb2_and17_i112_0_reg_19_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_17to19_bb2_and17_i112_0_reg_19_NO_SHIFT_REG;
 logic rnode_17to19_bb2_and17_i112_0_valid_out_reg_19_NO_SHIFT_REG;
 logic rnode_17to19_bb2_and17_i112_0_stall_in_reg_19_NO_SHIFT_REG;
 logic rnode_17to19_bb2_and17_i112_0_stall_out_reg_19_NO_SHIFT_REG;

acl_data_fifo rnode_17to19_bb2_and17_i112_0_reg_19_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_17to19_bb2_and17_i112_0_reg_19_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_17to19_bb2_and17_i112_0_stall_in_reg_19_NO_SHIFT_REG),
	.valid_out(rnode_17to19_bb2_and17_i112_0_valid_out_reg_19_NO_SHIFT_REG),
	.stall_out(rnode_17to19_bb2_and17_i112_0_stall_out_reg_19_NO_SHIFT_REG),
	.data_in(local_bb2_and17_i112),
	.data_out(rnode_17to19_bb2_and17_i112_0_reg_19_NO_SHIFT_REG)
);

defparam rnode_17to19_bb2_and17_i112_0_reg_19_fifo.DEPTH = 2;
defparam rnode_17to19_bb2_and17_i112_0_reg_19_fifo.DATA_WIDTH = 32;
defparam rnode_17to19_bb2_and17_i112_0_reg_19_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_17to19_bb2_and17_i112_0_reg_19_fifo.IMPL = "shift_reg";

assign rnode_17to19_bb2_and17_i112_0_reg_19_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and17_i112_stall_in_2 = 1'b0;
assign rnode_17to19_bb2_and17_i112_0_NO_SHIFT_REG = rnode_17to19_bb2_and17_i112_0_reg_19_NO_SHIFT_REG;
assign rnode_17to19_bb2_and17_i112_0_stall_in_reg_19_NO_SHIFT_REG = 1'b0;
assign rnode_17to19_bb2_and17_i112_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_17to18_bb2_var__u31_0_valid_out_NO_SHIFT_REG;
 logic rnode_17to18_bb2_var__u31_0_stall_in_NO_SHIFT_REG;
 logic rnode_17to18_bb2_var__u31_0_NO_SHIFT_REG;
 logic rnode_17to18_bb2_var__u31_0_reg_18_inputs_ready_NO_SHIFT_REG;
 logic rnode_17to18_bb2_var__u31_0_reg_18_NO_SHIFT_REG;
 logic rnode_17to18_bb2_var__u31_0_valid_out_reg_18_NO_SHIFT_REG;
 logic rnode_17to18_bb2_var__u31_0_stall_in_reg_18_NO_SHIFT_REG;
 logic rnode_17to18_bb2_var__u31_0_stall_out_reg_18_NO_SHIFT_REG;

acl_data_fifo rnode_17to18_bb2_var__u31_0_reg_18_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_17to18_bb2_var__u31_0_reg_18_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_17to18_bb2_var__u31_0_stall_in_reg_18_NO_SHIFT_REG),
	.valid_out(rnode_17to18_bb2_var__u31_0_valid_out_reg_18_NO_SHIFT_REG),
	.stall_out(rnode_17to18_bb2_var__u31_0_stall_out_reg_18_NO_SHIFT_REG),
	.data_in(local_bb2_var__u31),
	.data_out(rnode_17to18_bb2_var__u31_0_reg_18_NO_SHIFT_REG)
);

defparam rnode_17to18_bb2_var__u31_0_reg_18_fifo.DEPTH = 1;
defparam rnode_17to18_bb2_var__u31_0_reg_18_fifo.DATA_WIDTH = 1;
defparam rnode_17to18_bb2_var__u31_0_reg_18_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_17to18_bb2_var__u31_0_reg_18_fifo.IMPL = "shift_reg";

assign rnode_17to18_bb2_var__u31_0_reg_18_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_var__u31_stall_in = 1'b0;
assign rnode_17to18_bb2_var__u31_0_NO_SHIFT_REG = rnode_17to18_bb2_var__u31_0_reg_18_NO_SHIFT_REG;
assign rnode_17to18_bb2_var__u31_0_stall_in_reg_18_NO_SHIFT_REG = 1'b0;
assign rnode_17to18_bb2_var__u31_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_not_cmp37_i229_stall_local;
wire local_bb2_not_cmp37_i229;

assign local_bb2_not_cmp37_i229 = (rnode_17to19_bb2_cmp37_i123_1_NO_SHIFT_REG ^ 1'b1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_18to19_bb2__26_i136_0_valid_out_NO_SHIFT_REG;
 logic rnode_18to19_bb2__26_i136_0_stall_in_NO_SHIFT_REG;
 logic rnode_18to19_bb2__26_i136_0_NO_SHIFT_REG;
 logic rnode_18to19_bb2__26_i136_0_reg_19_inputs_ready_NO_SHIFT_REG;
 logic rnode_18to19_bb2__26_i136_0_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2__26_i136_0_valid_out_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2__26_i136_0_stall_in_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2__26_i136_0_stall_out_reg_19_NO_SHIFT_REG;

acl_data_fifo rnode_18to19_bb2__26_i136_0_reg_19_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_18to19_bb2__26_i136_0_reg_19_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_18to19_bb2__26_i136_0_stall_in_reg_19_NO_SHIFT_REG),
	.valid_out(rnode_18to19_bb2__26_i136_0_valid_out_reg_19_NO_SHIFT_REG),
	.stall_out(rnode_18to19_bb2__26_i136_0_stall_out_reg_19_NO_SHIFT_REG),
	.data_in(rnode_17to18_bb2__26_i136_0_NO_SHIFT_REG),
	.data_out(rnode_18to19_bb2__26_i136_0_reg_19_NO_SHIFT_REG)
);

defparam rnode_18to19_bb2__26_i136_0_reg_19_fifo.DEPTH = 1;
defparam rnode_18to19_bb2__26_i136_0_reg_19_fifo.DATA_WIDTH = 1;
defparam rnode_18to19_bb2__26_i136_0_reg_19_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_18to19_bb2__26_i136_0_reg_19_fifo.IMPL = "shift_reg";

assign rnode_18to19_bb2__26_i136_0_reg_19_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_17to18_bb2__26_i136_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2__26_i136_0_NO_SHIFT_REG = rnode_18to19_bb2__26_i136_0_reg_19_NO_SHIFT_REG;
assign rnode_18to19_bb2__26_i136_0_stall_in_reg_19_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2__26_i136_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_and193_i201_valid_out;
wire local_bb2_and193_i201_stall_in;
wire local_bb2_and193_i201_inputs_ready;
wire local_bb2_and193_i201_stall_local;
wire [31:0] local_bb2_and193_i201;

assign local_bb2_and193_i201_inputs_ready = rnode_17to18_bb2_add192_i200_0_valid_out_0_NO_SHIFT_REG;
assign local_bb2_and193_i201 = (rnode_17to18_bb2_add192_i200_0_NO_SHIFT_REG & 32'hFFFFFFF);
assign local_bb2_and193_i201_valid_out = 1'b1;
assign rnode_17to18_bb2_add192_i200_0_stall_in_0_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_and195_i202_valid_out;
wire local_bb2_and195_i202_stall_in;
wire local_bb2_and195_i202_inputs_ready;
wire local_bb2_and195_i202_stall_local;
wire [31:0] local_bb2_and195_i202;

assign local_bb2_and195_i202_inputs_ready = rnode_17to18_bb2_add192_i200_0_valid_out_1_NO_SHIFT_REG;
assign local_bb2_and195_i202 = (rnode_17to18_bb2_add192_i200_1_NO_SHIFT_REG >> 32'h1B);
assign local_bb2_and195_i202_valid_out = 1'b1;
assign rnode_17to18_bb2_add192_i200_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_and198_i203_valid_out;
wire local_bb2_and198_i203_stall_in;
wire local_bb2_and198_i203_inputs_ready;
wire local_bb2_and198_i203_stall_local;
wire [31:0] local_bb2_and198_i203;

assign local_bb2_and198_i203_inputs_ready = rnode_17to18_bb2_add192_i200_0_valid_out_2_NO_SHIFT_REG;
assign local_bb2_and198_i203 = (rnode_17to18_bb2_add192_i200_2_NO_SHIFT_REG & 32'h1);
assign local_bb2_and198_i203_valid_out = 1'b1;
assign rnode_17to18_bb2_add192_i200_0_stall_in_2_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_and201_i204_stall_local;
wire [31:0] local_bb2_and201_i204;

assign local_bb2_and201_i204 = (rnode_17to18_bb2_add192_i200_3_NO_SHIFT_REG & 32'h7FFFFFF);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_18to19_bb2_var__u31_0_valid_out_NO_SHIFT_REG;
 logic rnode_18to19_bb2_var__u31_0_stall_in_NO_SHIFT_REG;
 logic rnode_18to19_bb2_var__u31_0_NO_SHIFT_REG;
 logic rnode_18to19_bb2_var__u31_0_reg_19_inputs_ready_NO_SHIFT_REG;
 logic rnode_18to19_bb2_var__u31_0_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2_var__u31_0_valid_out_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2_var__u31_0_stall_in_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2_var__u31_0_stall_out_reg_19_NO_SHIFT_REG;

acl_data_fifo rnode_18to19_bb2_var__u31_0_reg_19_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_18to19_bb2_var__u31_0_reg_19_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_18to19_bb2_var__u31_0_stall_in_reg_19_NO_SHIFT_REG),
	.valid_out(rnode_18to19_bb2_var__u31_0_valid_out_reg_19_NO_SHIFT_REG),
	.stall_out(rnode_18to19_bb2_var__u31_0_stall_out_reg_19_NO_SHIFT_REG),
	.data_in(rnode_17to18_bb2_var__u31_0_NO_SHIFT_REG),
	.data_out(rnode_18to19_bb2_var__u31_0_reg_19_NO_SHIFT_REG)
);

defparam rnode_18to19_bb2_var__u31_0_reg_19_fifo.DEPTH = 1;
defparam rnode_18to19_bb2_var__u31_0_reg_19_fifo.DATA_WIDTH = 1;
defparam rnode_18to19_bb2_var__u31_0_reg_19_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_18to19_bb2_var__u31_0_reg_19_fifo.IMPL = "shift_reg";

assign rnode_18to19_bb2_var__u31_0_reg_19_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_17to18_bb2_var__u31_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2_var__u31_0_NO_SHIFT_REG = rnode_18to19_bb2_var__u31_0_reg_19_NO_SHIFT_REG;
assign rnode_18to19_bb2_var__u31_0_stall_in_reg_19_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2_var__u31_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_19to20_bb2__26_i136_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_19to20_bb2__26_i136_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_19to20_bb2__26_i136_0_NO_SHIFT_REG;
 logic rnode_19to20_bb2__26_i136_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_19to20_bb2__26_i136_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_19to20_bb2__26_i136_1_NO_SHIFT_REG;
 logic rnode_19to20_bb2__26_i136_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_19to20_bb2__26_i136_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_19to20_bb2__26_i136_2_NO_SHIFT_REG;
 logic rnode_19to20_bb2__26_i136_0_reg_20_inputs_ready_NO_SHIFT_REG;
 logic rnode_19to20_bb2__26_i136_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2__26_i136_0_valid_out_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2__26_i136_0_stall_in_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2__26_i136_0_stall_out_reg_20_NO_SHIFT_REG;

acl_data_fifo rnode_19to20_bb2__26_i136_0_reg_20_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_19to20_bb2__26_i136_0_reg_20_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_19to20_bb2__26_i136_0_stall_in_0_reg_20_NO_SHIFT_REG),
	.valid_out(rnode_19to20_bb2__26_i136_0_valid_out_0_reg_20_NO_SHIFT_REG),
	.stall_out(rnode_19to20_bb2__26_i136_0_stall_out_reg_20_NO_SHIFT_REG),
	.data_in(rnode_18to19_bb2__26_i136_0_NO_SHIFT_REG),
	.data_out(rnode_19to20_bb2__26_i136_0_reg_20_NO_SHIFT_REG)
);

defparam rnode_19to20_bb2__26_i136_0_reg_20_fifo.DEPTH = 1;
defparam rnode_19to20_bb2__26_i136_0_reg_20_fifo.DATA_WIDTH = 1;
defparam rnode_19to20_bb2__26_i136_0_reg_20_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_19to20_bb2__26_i136_0_reg_20_fifo.IMPL = "shift_reg";

assign rnode_19to20_bb2__26_i136_0_reg_20_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_18to19_bb2__26_i136_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2__26_i136_0_stall_in_0_reg_20_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2__26_i136_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_19to20_bb2__26_i136_0_NO_SHIFT_REG = rnode_19to20_bb2__26_i136_0_reg_20_NO_SHIFT_REG;
assign rnode_19to20_bb2__26_i136_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_19to20_bb2__26_i136_1_NO_SHIFT_REG = rnode_19to20_bb2__26_i136_0_reg_20_NO_SHIFT_REG;
assign rnode_19to20_bb2__26_i136_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_19to20_bb2__26_i136_2_NO_SHIFT_REG = rnode_19to20_bb2__26_i136_0_reg_20_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_18to19_bb2_and193_i201_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and193_i201_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_18to19_bb2_and193_i201_0_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and193_i201_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and193_i201_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_18to19_bb2_and193_i201_1_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and193_i201_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and193_i201_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_18to19_bb2_and193_i201_2_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and193_i201_0_reg_19_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_18to19_bb2_and193_i201_0_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and193_i201_0_valid_out_0_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and193_i201_0_stall_in_0_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and193_i201_0_stall_out_reg_19_NO_SHIFT_REG;

acl_data_fifo rnode_18to19_bb2_and193_i201_0_reg_19_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_18to19_bb2_and193_i201_0_reg_19_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_18to19_bb2_and193_i201_0_stall_in_0_reg_19_NO_SHIFT_REG),
	.valid_out(rnode_18to19_bb2_and193_i201_0_valid_out_0_reg_19_NO_SHIFT_REG),
	.stall_out(rnode_18to19_bb2_and193_i201_0_stall_out_reg_19_NO_SHIFT_REG),
	.data_in(local_bb2_and193_i201),
	.data_out(rnode_18to19_bb2_and193_i201_0_reg_19_NO_SHIFT_REG)
);

defparam rnode_18to19_bb2_and193_i201_0_reg_19_fifo.DEPTH = 1;
defparam rnode_18to19_bb2_and193_i201_0_reg_19_fifo.DATA_WIDTH = 32;
defparam rnode_18to19_bb2_and193_i201_0_reg_19_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_18to19_bb2_and193_i201_0_reg_19_fifo.IMPL = "shift_reg";

assign rnode_18to19_bb2_and193_i201_0_reg_19_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and193_i201_stall_in = 1'b0;
assign rnode_18to19_bb2_and193_i201_0_stall_in_0_reg_19_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2_and193_i201_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_18to19_bb2_and193_i201_0_NO_SHIFT_REG = rnode_18to19_bb2_and193_i201_0_reg_19_NO_SHIFT_REG;
assign rnode_18to19_bb2_and193_i201_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_18to19_bb2_and193_i201_1_NO_SHIFT_REG = rnode_18to19_bb2_and193_i201_0_reg_19_NO_SHIFT_REG;
assign rnode_18to19_bb2_and193_i201_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_18to19_bb2_and193_i201_2_NO_SHIFT_REG = rnode_18to19_bb2_and193_i201_0_reg_19_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_18to19_bb2_and195_i202_0_valid_out_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and195_i202_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_18to19_bb2_and195_i202_0_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and195_i202_0_reg_19_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_18to19_bb2_and195_i202_0_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and195_i202_0_valid_out_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and195_i202_0_stall_in_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and195_i202_0_stall_out_reg_19_NO_SHIFT_REG;

acl_data_fifo rnode_18to19_bb2_and195_i202_0_reg_19_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_18to19_bb2_and195_i202_0_reg_19_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_18to19_bb2_and195_i202_0_stall_in_reg_19_NO_SHIFT_REG),
	.valid_out(rnode_18to19_bb2_and195_i202_0_valid_out_reg_19_NO_SHIFT_REG),
	.stall_out(rnode_18to19_bb2_and195_i202_0_stall_out_reg_19_NO_SHIFT_REG),
	.data_in(local_bb2_and195_i202),
	.data_out(rnode_18to19_bb2_and195_i202_0_reg_19_NO_SHIFT_REG)
);

defparam rnode_18to19_bb2_and195_i202_0_reg_19_fifo.DEPTH = 1;
defparam rnode_18to19_bb2_and195_i202_0_reg_19_fifo.DATA_WIDTH = 32;
defparam rnode_18to19_bb2_and195_i202_0_reg_19_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_18to19_bb2_and195_i202_0_reg_19_fifo.IMPL = "shift_reg";

assign rnode_18to19_bb2_and195_i202_0_reg_19_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and195_i202_stall_in = 1'b0;
assign rnode_18to19_bb2_and195_i202_0_NO_SHIFT_REG = rnode_18to19_bb2_and195_i202_0_reg_19_NO_SHIFT_REG;
assign rnode_18to19_bb2_and195_i202_0_stall_in_reg_19_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2_and195_i202_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_18to19_bb2_and198_i203_0_valid_out_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and198_i203_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_18to19_bb2_and198_i203_0_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and198_i203_0_reg_19_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_18to19_bb2_and198_i203_0_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and198_i203_0_valid_out_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and198_i203_0_stall_in_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2_and198_i203_0_stall_out_reg_19_NO_SHIFT_REG;

acl_data_fifo rnode_18to19_bb2_and198_i203_0_reg_19_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_18to19_bb2_and198_i203_0_reg_19_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_18to19_bb2_and198_i203_0_stall_in_reg_19_NO_SHIFT_REG),
	.valid_out(rnode_18to19_bb2_and198_i203_0_valid_out_reg_19_NO_SHIFT_REG),
	.stall_out(rnode_18to19_bb2_and198_i203_0_stall_out_reg_19_NO_SHIFT_REG),
	.data_in(local_bb2_and198_i203),
	.data_out(rnode_18to19_bb2_and198_i203_0_reg_19_NO_SHIFT_REG)
);

defparam rnode_18to19_bb2_and198_i203_0_reg_19_fifo.DEPTH = 1;
defparam rnode_18to19_bb2_and198_i203_0_reg_19_fifo.DATA_WIDTH = 32;
defparam rnode_18to19_bb2_and198_i203_0_reg_19_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_18to19_bb2_and198_i203_0_reg_19_fifo.IMPL = "shift_reg";

assign rnode_18to19_bb2_and198_i203_0_reg_19_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and198_i203_stall_in = 1'b0;
assign rnode_18to19_bb2_and198_i203_0_NO_SHIFT_REG = rnode_18to19_bb2_and198_i203_0_reg_19_NO_SHIFT_REG;
assign rnode_18to19_bb2_and198_i203_0_stall_in_reg_19_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2_and198_i203_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_shr_i_i205_stall_local;
wire [31:0] local_bb2_shr_i_i205;

assign local_bb2_shr_i_i205 = (local_bb2_and201_i204 >> 32'h1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_19to20_bb2_var__u31_0_valid_out_NO_SHIFT_REG;
 logic rnode_19to20_bb2_var__u31_0_stall_in_NO_SHIFT_REG;
 logic rnode_19to20_bb2_var__u31_0_NO_SHIFT_REG;
 logic rnode_19to20_bb2_var__u31_0_reg_20_inputs_ready_NO_SHIFT_REG;
 logic rnode_19to20_bb2_var__u31_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_var__u31_0_valid_out_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_var__u31_0_stall_in_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_var__u31_0_stall_out_reg_20_NO_SHIFT_REG;

acl_data_fifo rnode_19to20_bb2_var__u31_0_reg_20_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_19to20_bb2_var__u31_0_reg_20_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_19to20_bb2_var__u31_0_stall_in_reg_20_NO_SHIFT_REG),
	.valid_out(rnode_19to20_bb2_var__u31_0_valid_out_reg_20_NO_SHIFT_REG),
	.stall_out(rnode_19to20_bb2_var__u31_0_stall_out_reg_20_NO_SHIFT_REG),
	.data_in(rnode_18to19_bb2_var__u31_0_NO_SHIFT_REG),
	.data_out(rnode_19to20_bb2_var__u31_0_reg_20_NO_SHIFT_REG)
);

defparam rnode_19to20_bb2_var__u31_0_reg_20_fifo.DEPTH = 1;
defparam rnode_19to20_bb2_var__u31_0_reg_20_fifo.DATA_WIDTH = 1;
defparam rnode_19to20_bb2_var__u31_0_reg_20_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_19to20_bb2_var__u31_0_reg_20_fifo.IMPL = "shift_reg";

assign rnode_19to20_bb2_var__u31_0_reg_20_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_18to19_bb2_var__u31_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_var__u31_0_NO_SHIFT_REG = rnode_19to20_bb2_var__u31_0_reg_20_NO_SHIFT_REG;
assign rnode_19to20_bb2_var__u31_0_stall_in_reg_20_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_var__u31_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_cond292_i263_stall_local;
wire [31:0] local_bb2_cond292_i263;

assign local_bb2_cond292_i263 = (rnode_19to20_bb2__26_i136_1_NO_SHIFT_REG ? 32'h400000 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u36_stall_local;
wire [31:0] local_bb2_var__u36;

assign local_bb2_var__u36[31:1] = 31'h0;
assign local_bb2_var__u36[0] = rnode_19to20_bb2__26_i136_2_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_shr216_i226_stall_local;
wire [31:0] local_bb2_shr216_i226;

assign local_bb2_shr216_i226 = (rnode_18to19_bb2_and193_i201_1_NO_SHIFT_REG >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2__pre_i224_stall_local;
wire [31:0] local_bb2__pre_i224;

assign local_bb2__pre_i224 = (rnode_18to19_bb2_and195_i202_0_NO_SHIFT_REG & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_or_i_i206_stall_local;
wire [31:0] local_bb2_or_i_i206;

assign local_bb2_or_i_i206 = (local_bb2_shr_i_i205 | local_bb2_and201_i204);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_ext_i273_stall_local;
wire [31:0] local_bb2_lnot_ext_i273;

assign local_bb2_lnot_ext_i273 = (local_bb2_var__u36 ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_or219_i227_stall_local;
wire [31:0] local_bb2_or219_i227;

assign local_bb2_or219_i227 = (local_bb2_shr216_i226 | rnode_18to19_bb2_and198_i203_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_tobool213_i225_stall_local;
wire local_bb2_tobool213_i225;

assign local_bb2_tobool213_i225 = (local_bb2__pre_i224 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_shr1_i_i207_stall_local;
wire [31:0] local_bb2_shr1_i_i207;

assign local_bb2_shr1_i_i207 = (local_bb2_or_i_i206 >> 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb2__40_demorgan_i228_stall_local;
wire local_bb2__40_demorgan_i228;

assign local_bb2__40_demorgan_i228 = (rnode_17to19_bb2_cmp37_i123_0_NO_SHIFT_REG | local_bb2_tobool213_i225);

// This section implements an unregistered operation.
// 
wire local_bb2__42_i230_stall_local;
wire local_bb2__42_i230;

assign local_bb2__42_i230 = (local_bb2_tobool213_i225 & local_bb2_not_cmp37_i229);

// This section implements an unregistered operation.
// 
wire local_bb2_or2_i_i208_stall_local;
wire [31:0] local_bb2_or2_i_i208;

assign local_bb2_or2_i_i208 = (local_bb2_shr1_i_i207 | local_bb2_or_i_i206);

// This section implements an unregistered operation.
// 
wire local_bb2__43_i231_stall_local;
wire [31:0] local_bb2__43_i231;

assign local_bb2__43_i231 = (local_bb2__42_i230 ? 32'h0 : local_bb2__pre_i224);

// This section implements an unregistered operation.
// 
wire local_bb2_shr3_i_i209_stall_local;
wire [31:0] local_bb2_shr3_i_i209;

assign local_bb2_shr3_i_i209 = (local_bb2_or2_i_i208 >> 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb2_or4_i_i210_stall_local;
wire [31:0] local_bb2_or4_i_i210;

assign local_bb2_or4_i_i210 = (local_bb2_shr3_i_i209 | local_bb2_or2_i_i208);

// This section implements an unregistered operation.
// 
wire local_bb2_shr5_i_i211_stall_local;
wire [31:0] local_bb2_shr5_i_i211;

assign local_bb2_shr5_i_i211 = (local_bb2_or4_i_i210 >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb2_or6_i_i212_stall_local;
wire [31:0] local_bb2_or6_i_i212;

assign local_bb2_or6_i_i212 = (local_bb2_shr5_i_i211 | local_bb2_or4_i_i210);

// This section implements an unregistered operation.
// 
wire local_bb2_shr7_i_i213_stall_local;
wire [31:0] local_bb2_shr7_i_i213;

assign local_bb2_shr7_i_i213 = (local_bb2_or6_i_i212 >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb2_or6_masked_i_i214_stall_local;
wire [31:0] local_bb2_or6_masked_i_i214;

assign local_bb2_or6_masked_i_i214 = (local_bb2_or6_i_i212 & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_neg_i_i215_stall_local;
wire [31:0] local_bb2_neg_i_i215;

assign local_bb2_neg_i_i215 = (local_bb2_or6_masked_i_i214 | local_bb2_shr7_i_i213);

// This section implements an unregistered operation.
// 
wire local_bb2_and_i_i216_stall_local;
wire [31:0] local_bb2_and_i_i216;

assign local_bb2_and_i_i216 = (local_bb2_neg_i_i215 ^ 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2__and_i_i216_valid_out;
wire local_bb2__and_i_i216_stall_in;
wire local_bb2__and_i_i216_inputs_ready;
wire local_bb2__and_i_i216_stall_local;
wire [31:0] local_bb2__and_i_i216;

thirtysix_six_comp local_bb2__and_i_i216_popcnt_instance (
	.data(local_bb2_and_i_i216),
	.sum(local_bb2__and_i_i216)
);


assign local_bb2__and_i_i216_inputs_ready = rnode_17to18_bb2_add192_i200_0_valid_out_3_NO_SHIFT_REG;
assign local_bb2__and_i_i216_valid_out = 1'b1;
assign rnode_17to18_bb2_add192_i200_0_stall_in_3_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_18to19_bb2__and_i_i216_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_18to19_bb2__and_i_i216_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_18to19_bb2__and_i_i216_0_NO_SHIFT_REG;
 logic rnode_18to19_bb2__and_i_i216_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_18to19_bb2__and_i_i216_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_18to19_bb2__and_i_i216_1_NO_SHIFT_REG;
 logic rnode_18to19_bb2__and_i_i216_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_18to19_bb2__and_i_i216_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_18to19_bb2__and_i_i216_2_NO_SHIFT_REG;
 logic rnode_18to19_bb2__and_i_i216_0_reg_19_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_18to19_bb2__and_i_i216_0_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2__and_i_i216_0_valid_out_0_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2__and_i_i216_0_stall_in_0_reg_19_NO_SHIFT_REG;
 logic rnode_18to19_bb2__and_i_i216_0_stall_out_reg_19_NO_SHIFT_REG;

acl_data_fifo rnode_18to19_bb2__and_i_i216_0_reg_19_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_18to19_bb2__and_i_i216_0_reg_19_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_18to19_bb2__and_i_i216_0_stall_in_0_reg_19_NO_SHIFT_REG),
	.valid_out(rnode_18to19_bb2__and_i_i216_0_valid_out_0_reg_19_NO_SHIFT_REG),
	.stall_out(rnode_18to19_bb2__and_i_i216_0_stall_out_reg_19_NO_SHIFT_REG),
	.data_in(local_bb2__and_i_i216),
	.data_out(rnode_18to19_bb2__and_i_i216_0_reg_19_NO_SHIFT_REG)
);

defparam rnode_18to19_bb2__and_i_i216_0_reg_19_fifo.DEPTH = 1;
defparam rnode_18to19_bb2__and_i_i216_0_reg_19_fifo.DATA_WIDTH = 32;
defparam rnode_18to19_bb2__and_i_i216_0_reg_19_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_18to19_bb2__and_i_i216_0_reg_19_fifo.IMPL = "shift_reg";

assign rnode_18to19_bb2__and_i_i216_0_reg_19_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__and_i_i216_stall_in = 1'b0;
assign rnode_18to19_bb2__and_i_i216_0_stall_in_0_reg_19_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2__and_i_i216_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_18to19_bb2__and_i_i216_0_NO_SHIFT_REG = rnode_18to19_bb2__and_i_i216_0_reg_19_NO_SHIFT_REG;
assign rnode_18to19_bb2__and_i_i216_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_18to19_bb2__and_i_i216_1_NO_SHIFT_REG = rnode_18to19_bb2__and_i_i216_0_reg_19_NO_SHIFT_REG;
assign rnode_18to19_bb2__and_i_i216_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_18to19_bb2__and_i_i216_2_NO_SHIFT_REG = rnode_18to19_bb2__and_i_i216_0_reg_19_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_and9_i_i217_stall_local;
wire [31:0] local_bb2_and9_i_i217;

assign local_bb2_and9_i_i217 = (rnode_18to19_bb2__and_i_i216_0_NO_SHIFT_REG & 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb2_and203_i218_stall_local;
wire [31:0] local_bb2_and203_i218;

assign local_bb2_and203_i218 = (rnode_18to19_bb2__and_i_i216_1_NO_SHIFT_REG & 32'h18);

// This section implements an unregistered operation.
// 
wire local_bb2_and206_i220_stall_local;
wire [31:0] local_bb2_and206_i220;

assign local_bb2_and206_i220 = (rnode_18to19_bb2__and_i_i216_2_NO_SHIFT_REG & 32'h7);

// This section implements an unregistered operation.
// 
wire local_bb2_sub239_i239_stall_local;
wire [31:0] local_bb2_sub239_i239;

assign local_bb2_sub239_i239 = (32'h0 - local_bb2_and9_i_i217);

// This section implements an unregistered operation.
// 
wire local_bb2_shl204_i219_stall_local;
wire [31:0] local_bb2_shl204_i219;

assign local_bb2_shl204_i219 = (rnode_18to19_bb2_and193_i201_0_NO_SHIFT_REG << local_bb2_and203_i218);

// This section implements an unregistered operation.
// 
wire local_bb2_cond244_i240_stall_local;
wire [31:0] local_bb2_cond244_i240;

assign local_bb2_cond244_i240 = (rnode_17to19_bb2_cmp37_i123_2_NO_SHIFT_REG ? local_bb2_sub239_i239 : local_bb2__43_i231);

// This section implements an unregistered operation.
// 
wire local_bb2_and205_i221_stall_local;
wire [31:0] local_bb2_and205_i221;

assign local_bb2_and205_i221 = (local_bb2_shl204_i219 & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_add245_i241_stall_local;
wire [31:0] local_bb2_add245_i241;

assign local_bb2_add245_i241 = (local_bb2_cond244_i240 + rnode_17to19_bb2_and17_i112_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_fold_i243_stall_local;
wire [31:0] local_bb2_fold_i243;

assign local_bb2_fold_i243 = (local_bb2_cond244_i240 + rnode_17to19_bb2_shr16_i111_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_shl207_i222_stall_local;
wire [31:0] local_bb2_shl207_i222;

assign local_bb2_shl207_i222 = (local_bb2_and205_i221 << local_bb2_and206_i220);

// This section implements an unregistered operation.
// 
wire local_bb2_and250_i244_stall_local;
wire [31:0] local_bb2_and250_i244;

assign local_bb2_and250_i244 = (local_bb2_fold_i243 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and269_i255_stall_local;
wire [31:0] local_bb2_and269_i255;

assign local_bb2_and269_i255 = (local_bb2_fold_i243 << 32'h17);

// This section implements an unregistered operation.
// 
wire local_bb2_and208_i223_stall_local;
wire [31:0] local_bb2_and208_i223;

assign local_bb2_and208_i223 = (local_bb2_shl207_i222 & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_notrhs_i246_stall_local;
wire local_bb2_notrhs_i246;

assign local_bb2_notrhs_i246 = (local_bb2_and250_i244 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2__44_i232_stall_local;
wire [31:0] local_bb2__44_i232;

assign local_bb2__44_i232 = (local_bb2__40_demorgan_i228 ? local_bb2_and208_i223 : local_bb2_or219_i227);

// This section implements an unregistered operation.
// 
wire local_bb2__45_i233_stall_local;
wire [31:0] local_bb2__45_i233;

assign local_bb2__45_i233 = (local_bb2__42_i230 ? rnode_18to19_bb2_and193_i201_2_NO_SHIFT_REG : local_bb2__44_i232);

// This section implements an unregistered operation.
// 
wire local_bb2_and225_i234_stall_local;
wire [31:0] local_bb2_and225_i234;

assign local_bb2_and225_i234 = (local_bb2__45_i233 & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and270_i252_stall_local;
wire [31:0] local_bb2_and270_i252;

assign local_bb2_and270_i252 = (local_bb2__45_i233 & 32'h7);

// This section implements an unregistered operation.
// 
wire local_bb2_shr271_i253_stall_local;
wire [31:0] local_bb2_shr271_i253;

assign local_bb2_shr271_i253 = (local_bb2__45_i233 >> 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp226_i235_stall_local;
wire local_bb2_cmp226_i235;

assign local_bb2_cmp226_i235 = (local_bb2_and225_i234 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp296_i267_stall_local;
wire local_bb2_cmp296_i267;

assign local_bb2_cmp296_i267 = (local_bb2_and270_i252 > 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb2_and269_i255_valid_out;
wire local_bb2_and269_i255_stall_in;
 reg local_bb2_and269_i255_consumed_0_NO_SHIFT_REG;
wire local_bb2_add245_i241_valid_out;
wire local_bb2_add245_i241_stall_in;
 reg local_bb2_add245_i241_consumed_0_NO_SHIFT_REG;
wire local_bb2_notrhs_i246_valid_out;
wire local_bb2_notrhs_i246_stall_in;
 reg local_bb2_notrhs_i246_consumed_0_NO_SHIFT_REG;
wire local_bb2_not_cmp37_i229_valid_out_1;
wire local_bb2_not_cmp37_i229_stall_in_1;
 reg local_bb2_not_cmp37_i229_consumed_1_NO_SHIFT_REG;
wire local_bb2_shr271_i253_valid_out;
wire local_bb2_shr271_i253_stall_in;
 reg local_bb2_shr271_i253_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp226_i235_valid_out;
wire local_bb2_cmp226_i235_stall_in;
 reg local_bb2_cmp226_i235_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp296_i267_valid_out;
wire local_bb2_cmp296_i267_stall_in;
 reg local_bb2_cmp296_i267_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp299_i268_valid_out;
wire local_bb2_cmp299_i268_stall_in;
 reg local_bb2_cmp299_i268_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp299_i268_inputs_ready;
wire local_bb2_cmp299_i268_stall_local;
wire local_bb2_cmp299_i268;

assign local_bb2_cmp299_i268_inputs_ready = (rnode_17to19_bb2_shr16_i111_0_valid_out_NO_SHIFT_REG & rnode_17to19_bb2_cmp37_i123_0_valid_out_2_NO_SHIFT_REG & rnode_17to19_bb2_and17_i112_0_valid_out_NO_SHIFT_REG & rnode_17to19_bb2_cmp37_i123_0_valid_out_0_NO_SHIFT_REG & rnode_18to19_bb2_and193_i201_0_valid_out_2_NO_SHIFT_REG & rnode_17to19_bb2_cmp37_i123_0_valid_out_1_NO_SHIFT_REG & rnode_18to19_bb2_and195_i202_0_valid_out_NO_SHIFT_REG & rnode_18to19_bb2_and193_i201_0_valid_out_1_NO_SHIFT_REG & rnode_18to19_bb2_and198_i203_0_valid_out_NO_SHIFT_REG & rnode_18to19_bb2_and193_i201_0_valid_out_0_NO_SHIFT_REG & rnode_18to19_bb2__and_i_i216_0_valid_out_1_NO_SHIFT_REG & rnode_18to19_bb2__and_i_i216_0_valid_out_2_NO_SHIFT_REG & rnode_18to19_bb2__and_i_i216_0_valid_out_0_NO_SHIFT_REG);
assign local_bb2_cmp299_i268 = (local_bb2_and270_i252 == 32'h4);
assign local_bb2_and269_i255_valid_out = 1'b1;
assign local_bb2_add245_i241_valid_out = 1'b1;
assign local_bb2_notrhs_i246_valid_out = 1'b1;
assign local_bb2_not_cmp37_i229_valid_out_1 = 1'b1;
assign local_bb2_shr271_i253_valid_out = 1'b1;
assign local_bb2_cmp226_i235_valid_out = 1'b1;
assign local_bb2_cmp296_i267_valid_out = 1'b1;
assign local_bb2_cmp299_i268_valid_out = 1'b1;
assign rnode_17to19_bb2_shr16_i111_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_17to19_bb2_cmp37_i123_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_17to19_bb2_and17_i112_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_17to19_bb2_cmp37_i123_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2_and193_i201_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_17to19_bb2_cmp37_i123_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2_and195_i202_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2_and193_i201_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2_and198_i203_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2_and193_i201_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2__and_i_i216_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2__and_i_i216_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_18to19_bb2__and_i_i216_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_and269_i255_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_add245_i241_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_notrhs_i246_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_not_cmp37_i229_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb2_shr271_i253_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp226_i235_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp296_i267_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp299_i268_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_and269_i255_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i268_inputs_ready & (local_bb2_and269_i255_consumed_0_NO_SHIFT_REG | ~(local_bb2_and269_i255_stall_in)) & local_bb2_cmp299_i268_stall_local);
		local_bb2_add245_i241_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i268_inputs_ready & (local_bb2_add245_i241_consumed_0_NO_SHIFT_REG | ~(local_bb2_add245_i241_stall_in)) & local_bb2_cmp299_i268_stall_local);
		local_bb2_notrhs_i246_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i268_inputs_ready & (local_bb2_notrhs_i246_consumed_0_NO_SHIFT_REG | ~(local_bb2_notrhs_i246_stall_in)) & local_bb2_cmp299_i268_stall_local);
		local_bb2_not_cmp37_i229_consumed_1_NO_SHIFT_REG <= (local_bb2_cmp299_i268_inputs_ready & (local_bb2_not_cmp37_i229_consumed_1_NO_SHIFT_REG | ~(local_bb2_not_cmp37_i229_stall_in_1)) & local_bb2_cmp299_i268_stall_local);
		local_bb2_shr271_i253_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i268_inputs_ready & (local_bb2_shr271_i253_consumed_0_NO_SHIFT_REG | ~(local_bb2_shr271_i253_stall_in)) & local_bb2_cmp299_i268_stall_local);
		local_bb2_cmp226_i235_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i268_inputs_ready & (local_bb2_cmp226_i235_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp226_i235_stall_in)) & local_bb2_cmp299_i268_stall_local);
		local_bb2_cmp296_i267_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i268_inputs_ready & (local_bb2_cmp296_i267_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp296_i267_stall_in)) & local_bb2_cmp299_i268_stall_local);
		local_bb2_cmp299_i268_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i268_inputs_ready & (local_bb2_cmp299_i268_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp299_i268_stall_in)) & local_bb2_cmp299_i268_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_19to20_bb2_and269_i255_0_valid_out_NO_SHIFT_REG;
 logic rnode_19to20_bb2_and269_i255_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_19to20_bb2_and269_i255_0_NO_SHIFT_REG;
 logic rnode_19to20_bb2_and269_i255_0_reg_20_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_19to20_bb2_and269_i255_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_and269_i255_0_valid_out_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_and269_i255_0_stall_in_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_and269_i255_0_stall_out_reg_20_NO_SHIFT_REG;

acl_data_fifo rnode_19to20_bb2_and269_i255_0_reg_20_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_19to20_bb2_and269_i255_0_reg_20_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_19to20_bb2_and269_i255_0_stall_in_reg_20_NO_SHIFT_REG),
	.valid_out(rnode_19to20_bb2_and269_i255_0_valid_out_reg_20_NO_SHIFT_REG),
	.stall_out(rnode_19to20_bb2_and269_i255_0_stall_out_reg_20_NO_SHIFT_REG),
	.data_in(local_bb2_and269_i255),
	.data_out(rnode_19to20_bb2_and269_i255_0_reg_20_NO_SHIFT_REG)
);

defparam rnode_19to20_bb2_and269_i255_0_reg_20_fifo.DEPTH = 1;
defparam rnode_19to20_bb2_and269_i255_0_reg_20_fifo.DATA_WIDTH = 32;
defparam rnode_19to20_bb2_and269_i255_0_reg_20_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_19to20_bb2_and269_i255_0_reg_20_fifo.IMPL = "shift_reg";

assign rnode_19to20_bb2_and269_i255_0_reg_20_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and269_i255_stall_in = 1'b0;
assign rnode_19to20_bb2_and269_i255_0_NO_SHIFT_REG = rnode_19to20_bb2_and269_i255_0_reg_20_NO_SHIFT_REG;
assign rnode_19to20_bb2_and269_i255_0_stall_in_reg_20_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_and269_i255_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_19to20_bb2_add245_i241_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_19to20_bb2_add245_i241_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_19to20_bb2_add245_i241_0_NO_SHIFT_REG;
 logic rnode_19to20_bb2_add245_i241_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_19to20_bb2_add245_i241_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_19to20_bb2_add245_i241_1_NO_SHIFT_REG;
 logic rnode_19to20_bb2_add245_i241_0_reg_20_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_19to20_bb2_add245_i241_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_add245_i241_0_valid_out_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_add245_i241_0_stall_in_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_add245_i241_0_stall_out_reg_20_NO_SHIFT_REG;

acl_data_fifo rnode_19to20_bb2_add245_i241_0_reg_20_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_19to20_bb2_add245_i241_0_reg_20_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_19to20_bb2_add245_i241_0_stall_in_0_reg_20_NO_SHIFT_REG),
	.valid_out(rnode_19to20_bb2_add245_i241_0_valid_out_0_reg_20_NO_SHIFT_REG),
	.stall_out(rnode_19to20_bb2_add245_i241_0_stall_out_reg_20_NO_SHIFT_REG),
	.data_in(local_bb2_add245_i241),
	.data_out(rnode_19to20_bb2_add245_i241_0_reg_20_NO_SHIFT_REG)
);

defparam rnode_19to20_bb2_add245_i241_0_reg_20_fifo.DEPTH = 1;
defparam rnode_19to20_bb2_add245_i241_0_reg_20_fifo.DATA_WIDTH = 32;
defparam rnode_19to20_bb2_add245_i241_0_reg_20_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_19to20_bb2_add245_i241_0_reg_20_fifo.IMPL = "shift_reg";

assign rnode_19to20_bb2_add245_i241_0_reg_20_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_add245_i241_stall_in = 1'b0;
assign rnode_19to20_bb2_add245_i241_0_stall_in_0_reg_20_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_add245_i241_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_19to20_bb2_add245_i241_0_NO_SHIFT_REG = rnode_19to20_bb2_add245_i241_0_reg_20_NO_SHIFT_REG;
assign rnode_19to20_bb2_add245_i241_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_19to20_bb2_add245_i241_1_NO_SHIFT_REG = rnode_19to20_bb2_add245_i241_0_reg_20_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_19to20_bb2_notrhs_i246_0_valid_out_NO_SHIFT_REG;
 logic rnode_19to20_bb2_notrhs_i246_0_stall_in_NO_SHIFT_REG;
 logic rnode_19to20_bb2_notrhs_i246_0_NO_SHIFT_REG;
 logic rnode_19to20_bb2_notrhs_i246_0_reg_20_inputs_ready_NO_SHIFT_REG;
 logic rnode_19to20_bb2_notrhs_i246_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_notrhs_i246_0_valid_out_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_notrhs_i246_0_stall_in_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_notrhs_i246_0_stall_out_reg_20_NO_SHIFT_REG;

acl_data_fifo rnode_19to20_bb2_notrhs_i246_0_reg_20_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_19to20_bb2_notrhs_i246_0_reg_20_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_19to20_bb2_notrhs_i246_0_stall_in_reg_20_NO_SHIFT_REG),
	.valid_out(rnode_19to20_bb2_notrhs_i246_0_valid_out_reg_20_NO_SHIFT_REG),
	.stall_out(rnode_19to20_bb2_notrhs_i246_0_stall_out_reg_20_NO_SHIFT_REG),
	.data_in(local_bb2_notrhs_i246),
	.data_out(rnode_19to20_bb2_notrhs_i246_0_reg_20_NO_SHIFT_REG)
);

defparam rnode_19to20_bb2_notrhs_i246_0_reg_20_fifo.DEPTH = 1;
defparam rnode_19to20_bb2_notrhs_i246_0_reg_20_fifo.DATA_WIDTH = 1;
defparam rnode_19to20_bb2_notrhs_i246_0_reg_20_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_19to20_bb2_notrhs_i246_0_reg_20_fifo.IMPL = "shift_reg";

assign rnode_19to20_bb2_notrhs_i246_0_reg_20_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_notrhs_i246_stall_in = 1'b0;
assign rnode_19to20_bb2_notrhs_i246_0_NO_SHIFT_REG = rnode_19to20_bb2_notrhs_i246_0_reg_20_NO_SHIFT_REG;
assign rnode_19to20_bb2_notrhs_i246_0_stall_in_reg_20_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_notrhs_i246_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_19to20_bb2_not_cmp37_i229_0_valid_out_NO_SHIFT_REG;
 logic rnode_19to20_bb2_not_cmp37_i229_0_stall_in_NO_SHIFT_REG;
 logic rnode_19to20_bb2_not_cmp37_i229_0_NO_SHIFT_REG;
 logic rnode_19to20_bb2_not_cmp37_i229_0_reg_20_inputs_ready_NO_SHIFT_REG;
 logic rnode_19to20_bb2_not_cmp37_i229_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_not_cmp37_i229_0_valid_out_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_not_cmp37_i229_0_stall_in_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_not_cmp37_i229_0_stall_out_reg_20_NO_SHIFT_REG;

acl_data_fifo rnode_19to20_bb2_not_cmp37_i229_0_reg_20_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_19to20_bb2_not_cmp37_i229_0_reg_20_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_19to20_bb2_not_cmp37_i229_0_stall_in_reg_20_NO_SHIFT_REG),
	.valid_out(rnode_19to20_bb2_not_cmp37_i229_0_valid_out_reg_20_NO_SHIFT_REG),
	.stall_out(rnode_19to20_bb2_not_cmp37_i229_0_stall_out_reg_20_NO_SHIFT_REG),
	.data_in(local_bb2_not_cmp37_i229),
	.data_out(rnode_19to20_bb2_not_cmp37_i229_0_reg_20_NO_SHIFT_REG)
);

defparam rnode_19to20_bb2_not_cmp37_i229_0_reg_20_fifo.DEPTH = 1;
defparam rnode_19to20_bb2_not_cmp37_i229_0_reg_20_fifo.DATA_WIDTH = 1;
defparam rnode_19to20_bb2_not_cmp37_i229_0_reg_20_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_19to20_bb2_not_cmp37_i229_0_reg_20_fifo.IMPL = "shift_reg";

assign rnode_19to20_bb2_not_cmp37_i229_0_reg_20_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_not_cmp37_i229_stall_in_1 = 1'b0;
assign rnode_19to20_bb2_not_cmp37_i229_0_NO_SHIFT_REG = rnode_19to20_bb2_not_cmp37_i229_0_reg_20_NO_SHIFT_REG;
assign rnode_19to20_bb2_not_cmp37_i229_0_stall_in_reg_20_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_not_cmp37_i229_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_19to20_bb2_shr271_i253_0_valid_out_NO_SHIFT_REG;
 logic rnode_19to20_bb2_shr271_i253_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_19to20_bb2_shr271_i253_0_NO_SHIFT_REG;
 logic rnode_19to20_bb2_shr271_i253_0_reg_20_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_19to20_bb2_shr271_i253_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_shr271_i253_0_valid_out_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_shr271_i253_0_stall_in_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_shr271_i253_0_stall_out_reg_20_NO_SHIFT_REG;

acl_data_fifo rnode_19to20_bb2_shr271_i253_0_reg_20_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_19to20_bb2_shr271_i253_0_reg_20_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_19to20_bb2_shr271_i253_0_stall_in_reg_20_NO_SHIFT_REG),
	.valid_out(rnode_19to20_bb2_shr271_i253_0_valid_out_reg_20_NO_SHIFT_REG),
	.stall_out(rnode_19to20_bb2_shr271_i253_0_stall_out_reg_20_NO_SHIFT_REG),
	.data_in(local_bb2_shr271_i253),
	.data_out(rnode_19to20_bb2_shr271_i253_0_reg_20_NO_SHIFT_REG)
);

defparam rnode_19to20_bb2_shr271_i253_0_reg_20_fifo.DEPTH = 1;
defparam rnode_19to20_bb2_shr271_i253_0_reg_20_fifo.DATA_WIDTH = 32;
defparam rnode_19to20_bb2_shr271_i253_0_reg_20_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_19to20_bb2_shr271_i253_0_reg_20_fifo.IMPL = "shift_reg";

assign rnode_19to20_bb2_shr271_i253_0_reg_20_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_shr271_i253_stall_in = 1'b0;
assign rnode_19to20_bb2_shr271_i253_0_NO_SHIFT_REG = rnode_19to20_bb2_shr271_i253_0_reg_20_NO_SHIFT_REG;
assign rnode_19to20_bb2_shr271_i253_0_stall_in_reg_20_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_shr271_i253_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_19to20_bb2_cmp226_i235_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp226_i235_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp226_i235_0_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp226_i235_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp226_i235_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp226_i235_1_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp226_i235_0_reg_20_inputs_ready_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp226_i235_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp226_i235_0_valid_out_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp226_i235_0_stall_in_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp226_i235_0_stall_out_reg_20_NO_SHIFT_REG;

acl_data_fifo rnode_19to20_bb2_cmp226_i235_0_reg_20_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_19to20_bb2_cmp226_i235_0_reg_20_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_19to20_bb2_cmp226_i235_0_stall_in_0_reg_20_NO_SHIFT_REG),
	.valid_out(rnode_19to20_bb2_cmp226_i235_0_valid_out_0_reg_20_NO_SHIFT_REG),
	.stall_out(rnode_19to20_bb2_cmp226_i235_0_stall_out_reg_20_NO_SHIFT_REG),
	.data_in(local_bb2_cmp226_i235),
	.data_out(rnode_19to20_bb2_cmp226_i235_0_reg_20_NO_SHIFT_REG)
);

defparam rnode_19to20_bb2_cmp226_i235_0_reg_20_fifo.DEPTH = 1;
defparam rnode_19to20_bb2_cmp226_i235_0_reg_20_fifo.DATA_WIDTH = 1;
defparam rnode_19to20_bb2_cmp226_i235_0_reg_20_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_19to20_bb2_cmp226_i235_0_reg_20_fifo.IMPL = "shift_reg";

assign rnode_19to20_bb2_cmp226_i235_0_reg_20_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp226_i235_stall_in = 1'b0;
assign rnode_19to20_bb2_cmp226_i235_0_stall_in_0_reg_20_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_cmp226_i235_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_19to20_bb2_cmp226_i235_0_NO_SHIFT_REG = rnode_19to20_bb2_cmp226_i235_0_reg_20_NO_SHIFT_REG;
assign rnode_19to20_bb2_cmp226_i235_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_19to20_bb2_cmp226_i235_1_NO_SHIFT_REG = rnode_19to20_bb2_cmp226_i235_0_reg_20_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_19to20_bb2_cmp296_i267_0_valid_out_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp296_i267_0_stall_in_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp296_i267_0_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp296_i267_0_reg_20_inputs_ready_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp296_i267_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp296_i267_0_valid_out_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp296_i267_0_stall_in_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp296_i267_0_stall_out_reg_20_NO_SHIFT_REG;

acl_data_fifo rnode_19to20_bb2_cmp296_i267_0_reg_20_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_19to20_bb2_cmp296_i267_0_reg_20_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_19to20_bb2_cmp296_i267_0_stall_in_reg_20_NO_SHIFT_REG),
	.valid_out(rnode_19to20_bb2_cmp296_i267_0_valid_out_reg_20_NO_SHIFT_REG),
	.stall_out(rnode_19to20_bb2_cmp296_i267_0_stall_out_reg_20_NO_SHIFT_REG),
	.data_in(local_bb2_cmp296_i267),
	.data_out(rnode_19to20_bb2_cmp296_i267_0_reg_20_NO_SHIFT_REG)
);

defparam rnode_19to20_bb2_cmp296_i267_0_reg_20_fifo.DEPTH = 1;
defparam rnode_19to20_bb2_cmp296_i267_0_reg_20_fifo.DATA_WIDTH = 1;
defparam rnode_19to20_bb2_cmp296_i267_0_reg_20_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_19to20_bb2_cmp296_i267_0_reg_20_fifo.IMPL = "shift_reg";

assign rnode_19to20_bb2_cmp296_i267_0_reg_20_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp296_i267_stall_in = 1'b0;
assign rnode_19to20_bb2_cmp296_i267_0_NO_SHIFT_REG = rnode_19to20_bb2_cmp296_i267_0_reg_20_NO_SHIFT_REG;
assign rnode_19to20_bb2_cmp296_i267_0_stall_in_reg_20_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_cmp296_i267_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_19to20_bb2_cmp299_i268_0_valid_out_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp299_i268_0_stall_in_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp299_i268_0_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp299_i268_0_reg_20_inputs_ready_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp299_i268_0_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp299_i268_0_valid_out_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp299_i268_0_stall_in_reg_20_NO_SHIFT_REG;
 logic rnode_19to20_bb2_cmp299_i268_0_stall_out_reg_20_NO_SHIFT_REG;

acl_data_fifo rnode_19to20_bb2_cmp299_i268_0_reg_20_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_19to20_bb2_cmp299_i268_0_reg_20_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_19to20_bb2_cmp299_i268_0_stall_in_reg_20_NO_SHIFT_REG),
	.valid_out(rnode_19to20_bb2_cmp299_i268_0_valid_out_reg_20_NO_SHIFT_REG),
	.stall_out(rnode_19to20_bb2_cmp299_i268_0_stall_out_reg_20_NO_SHIFT_REG),
	.data_in(local_bb2_cmp299_i268),
	.data_out(rnode_19to20_bb2_cmp299_i268_0_reg_20_NO_SHIFT_REG)
);

defparam rnode_19to20_bb2_cmp299_i268_0_reg_20_fifo.DEPTH = 1;
defparam rnode_19to20_bb2_cmp299_i268_0_reg_20_fifo.DATA_WIDTH = 1;
defparam rnode_19to20_bb2_cmp299_i268_0_reg_20_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_19to20_bb2_cmp299_i268_0_reg_20_fifo.IMPL = "shift_reg";

assign rnode_19to20_bb2_cmp299_i268_0_reg_20_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp299_i268_stall_in = 1'b0;
assign rnode_19to20_bb2_cmp299_i268_0_NO_SHIFT_REG = rnode_19to20_bb2_cmp299_i268_0_reg_20_NO_SHIFT_REG;
assign rnode_19to20_bb2_cmp299_i268_0_stall_in_reg_20_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_cmp299_i268_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_shl273_i256_stall_local;
wire [31:0] local_bb2_shl273_i256;

assign local_bb2_shl273_i256 = (rnode_19to20_bb2_and269_i255_0_NO_SHIFT_REG & 32'h7F800000);

// This section implements an unregistered operation.
// 
wire local_bb2_and247_i242_stall_local;
wire [31:0] local_bb2_and247_i242;

assign local_bb2_and247_i242 = (rnode_19to20_bb2_add245_i241_0_NO_SHIFT_REG & 32'h100);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp258_i249_stall_local;
wire local_bb2_cmp258_i249;

assign local_bb2_cmp258_i249 = ($signed(rnode_19to20_bb2_add245_i241_1_NO_SHIFT_REG) > $signed(32'hFE));

// This section implements an unregistered operation.
// 
wire local_bb2_and272_i254_stall_local;
wire [31:0] local_bb2_and272_i254;

assign local_bb2_and272_i254 = (rnode_19to20_bb2_shr271_i253_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp226_not_i236_stall_local;
wire local_bb2_cmp226_not_i236;

assign local_bb2_cmp226_not_i236 = (rnode_19to20_bb2_cmp226_i235_0_NO_SHIFT_REG ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp29649_i271_stall_local;
wire [31:0] local_bb2_cmp29649_i271;

assign local_bb2_cmp29649_i271[31:1] = 31'h0;
assign local_bb2_cmp29649_i271[0] = rnode_19to20_bb2_cmp296_i267_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_conv300_i269_stall_local;
wire [31:0] local_bb2_conv300_i269;

assign local_bb2_conv300_i269[31:1] = 31'h0;
assign local_bb2_conv300_i269[0] = rnode_19to20_bb2_cmp299_i268_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_notlhs_i245_stall_local;
wire local_bb2_notlhs_i245;

assign local_bb2_notlhs_i245 = (local_bb2_and247_i242 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or274_i257_stall_local;
wire [31:0] local_bb2_or274_i257;

assign local_bb2_or274_i257 = (local_bb2_and272_i254 | local_bb2_shl273_i256);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge12_i237_stall_local;
wire local_bb2_brmerge12_i237;

assign local_bb2_brmerge12_i237 = (local_bb2_cmp226_not_i236 | rnode_19to20_bb2_not_cmp37_i229_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot262__i250_stall_local;
wire local_bb2_lnot262__i250;

assign local_bb2_lnot262__i250 = (local_bb2_cmp258_i249 & local_bb2_cmp226_not_i236);

// This section implements an unregistered operation.
// 
wire local_bb2_not__46_i247_stall_local;
wire local_bb2_not__46_i247;

assign local_bb2_not__46_i247 = (rnode_19to20_bb2_notrhs_i246_0_NO_SHIFT_REG | local_bb2_notlhs_i245);

// This section implements an unregistered operation.
// 
wire local_bb2_resultSign_0_i238_stall_local;
wire [31:0] local_bb2_resultSign_0_i238;

assign local_bb2_resultSign_0_i238 = (local_bb2_brmerge12_i237 ? rnode_19to20_bb2_and35_i121_0_NO_SHIFT_REG : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or2662_i251_stall_local;
wire local_bb2_or2662_i251;

assign local_bb2_or2662_i251 = (rnode_19to20_bb2_var__u31_0_NO_SHIFT_REG | local_bb2_lnot262__i250);

// This section implements an unregistered operation.
// 
wire local_bb2__47_i248_stall_local;
wire local_bb2__47_i248;

assign local_bb2__47_i248 = (rnode_19to20_bb2_cmp226_i235_1_NO_SHIFT_REG | local_bb2_not__46_i247);

// This section implements an unregistered operation.
// 
wire local_bb2_or275_i258_stall_local;
wire [31:0] local_bb2_or275_i258;

assign local_bb2_or275_i258 = (local_bb2_or274_i257 | local_bb2_resultSign_0_i238);

// This section implements an unregistered operation.
// 
wire local_bb2_or2875_i261_stall_local;
wire local_bb2_or2875_i261;

assign local_bb2_or2875_i261 = (local_bb2_or2662_i251 | rnode_19to20_bb2__26_i136_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u37_stall_local;
wire [31:0] local_bb2_var__u37;

assign local_bb2_var__u37[31:1] = 31'h0;
assign local_bb2_var__u37[0] = local_bb2_or2662_i251;

// This section implements an unregistered operation.
// 
wire local_bb2_or2804_i259_stall_local;
wire local_bb2_or2804_i259;

assign local_bb2_or2804_i259 = (local_bb2__47_i248 | local_bb2_or2662_i251);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u38_stall_local;
wire [31:0] local_bb2_var__u38;

assign local_bb2_var__u38[31:1] = 31'h0;
assign local_bb2_var__u38[0] = local_bb2__47_i248;

// This section implements an unregistered operation.
// 
wire local_bb2_cond289_i262_stall_local;
wire [31:0] local_bb2_cond289_i262;

assign local_bb2_cond289_i262 = (local_bb2_or2875_i261 ? 32'h7F800000 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_ext310_i274_stall_local;
wire [31:0] local_bb2_lnot_ext310_i274;

assign local_bb2_lnot_ext310_i274 = (local_bb2_var__u37 ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_cond282_i260_stall_local;
wire [31:0] local_bb2_cond282_i260;

assign local_bb2_cond282_i260 = (local_bb2_or2804_i259 ? 32'h80000000 : 32'hFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_or294_i265_stall_local;
wire [31:0] local_bb2_or294_i265;

assign local_bb2_or294_i265 = (local_bb2_cond289_i262 | local_bb2_cond292_i263);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_0_i276_stall_local;
wire [31:0] local_bb2_reduction_0_i276;

assign local_bb2_reduction_0_i276 = (local_bb2_lnot_ext310_i274 & local_bb2_lnot_ext_i273);

// This section implements an unregistered operation.
// 
wire local_bb2_and293_i264_stall_local;
wire [31:0] local_bb2_and293_i264;

assign local_bb2_and293_i264 = (local_bb2_cond282_i260 & local_bb2_or275_i258);

// This section implements an unregistered operation.
// 
wire local_bb2_or295_i266_stall_local;
wire [31:0] local_bb2_or295_i266;

assign local_bb2_or295_i266 = (local_bb2_or294_i265 | local_bb2_and293_i264);

// This section implements an unregistered operation.
// 
wire local_bb2_and302_i270_stall_local;
wire [31:0] local_bb2_and302_i270;

assign local_bb2_and302_i270 = (local_bb2_conv300_i269 & local_bb2_and293_i264);

// This section implements an unregistered operation.
// 
wire local_bb2_or295_i266_valid_out;
wire local_bb2_or295_i266_stall_in;
 reg local_bb2_or295_i266_consumed_0_NO_SHIFT_REG;
wire local_bb2_var__u38_valid_out;
wire local_bb2_var__u38_stall_in;
 reg local_bb2_var__u38_consumed_0_NO_SHIFT_REG;
wire local_bb2_lor_ext_i272_valid_out;
wire local_bb2_lor_ext_i272_stall_in;
 reg local_bb2_lor_ext_i272_consumed_0_NO_SHIFT_REG;
wire local_bb2_reduction_0_i276_valid_out;
wire local_bb2_reduction_0_i276_stall_in;
 reg local_bb2_reduction_0_i276_consumed_0_NO_SHIFT_REG;
wire local_bb2_lor_ext_i272_inputs_ready;
wire local_bb2_lor_ext_i272_stall_local;
wire [31:0] local_bb2_lor_ext_i272;

assign local_bb2_lor_ext_i272_inputs_ready = (rnode_19to20_bb2_and35_i121_0_valid_out_NO_SHIFT_REG & rnode_19to20_bb2_not_cmp37_i229_0_valid_out_NO_SHIFT_REG & rnode_19to20_bb2_and269_i255_0_valid_out_NO_SHIFT_REG & rnode_19to20_bb2_add245_i241_0_valid_out_1_NO_SHIFT_REG & rnode_19to20_bb2_var__u31_0_valid_out_NO_SHIFT_REG & rnode_19to20_bb2__26_i136_0_valid_out_0_NO_SHIFT_REG & rnode_19to20_bb2__26_i136_0_valid_out_1_NO_SHIFT_REG & rnode_19to20_bb2_add245_i241_0_valid_out_0_NO_SHIFT_REG & rnode_19to20_bb2_notrhs_i246_0_valid_out_NO_SHIFT_REG & rnode_19to20_bb2_cmp226_i235_0_valid_out_1_NO_SHIFT_REG & rnode_19to20_bb2_shr271_i253_0_valid_out_NO_SHIFT_REG & rnode_19to20_bb2__26_i136_0_valid_out_2_NO_SHIFT_REG & rnode_19to20_bb2_cmp226_i235_0_valid_out_0_NO_SHIFT_REG & rnode_19to20_bb2_cmp296_i267_0_valid_out_NO_SHIFT_REG & rnode_19to20_bb2_cmp299_i268_0_valid_out_NO_SHIFT_REG);
assign local_bb2_lor_ext_i272 = (local_bb2_cmp29649_i271 | local_bb2_and302_i270);
assign local_bb2_or295_i266_valid_out = 1'b1;
assign local_bb2_var__u38_valid_out = 1'b1;
assign local_bb2_lor_ext_i272_valid_out = 1'b1;
assign local_bb2_reduction_0_i276_valid_out = 1'b1;
assign rnode_19to20_bb2_and35_i121_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_not_cmp37_i229_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_and269_i255_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_add245_i241_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_var__u31_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2__26_i136_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2__26_i136_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_add245_i241_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_notrhs_i246_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_cmp226_i235_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_shr271_i253_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2__26_i136_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_cmp226_i235_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_cmp296_i267_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_19to20_bb2_cmp299_i268_0_stall_in_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_or295_i266_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_var__u38_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_lor_ext_i272_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_reduction_0_i276_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_or295_i266_consumed_0_NO_SHIFT_REG <= (local_bb2_lor_ext_i272_inputs_ready & (local_bb2_or295_i266_consumed_0_NO_SHIFT_REG | ~(local_bb2_or295_i266_stall_in)) & local_bb2_lor_ext_i272_stall_local);
		local_bb2_var__u38_consumed_0_NO_SHIFT_REG <= (local_bb2_lor_ext_i272_inputs_ready & (local_bb2_var__u38_consumed_0_NO_SHIFT_REG | ~(local_bb2_var__u38_stall_in)) & local_bb2_lor_ext_i272_stall_local);
		local_bb2_lor_ext_i272_consumed_0_NO_SHIFT_REG <= (local_bb2_lor_ext_i272_inputs_ready & (local_bb2_lor_ext_i272_consumed_0_NO_SHIFT_REG | ~(local_bb2_lor_ext_i272_stall_in)) & local_bb2_lor_ext_i272_stall_local);
		local_bb2_reduction_0_i276_consumed_0_NO_SHIFT_REG <= (local_bb2_lor_ext_i272_inputs_ready & (local_bb2_reduction_0_i276_consumed_0_NO_SHIFT_REG | ~(local_bb2_reduction_0_i276_stall_in)) & local_bb2_lor_ext_i272_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_20to21_bb2_or295_i266_0_valid_out_NO_SHIFT_REG;
 logic rnode_20to21_bb2_or295_i266_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_20to21_bb2_or295_i266_0_NO_SHIFT_REG;
 logic rnode_20to21_bb2_or295_i266_0_reg_21_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_20to21_bb2_or295_i266_0_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb2_or295_i266_0_valid_out_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb2_or295_i266_0_stall_in_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb2_or295_i266_0_stall_out_reg_21_NO_SHIFT_REG;

acl_data_fifo rnode_20to21_bb2_or295_i266_0_reg_21_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_20to21_bb2_or295_i266_0_reg_21_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_20to21_bb2_or295_i266_0_stall_in_reg_21_NO_SHIFT_REG),
	.valid_out(rnode_20to21_bb2_or295_i266_0_valid_out_reg_21_NO_SHIFT_REG),
	.stall_out(rnode_20to21_bb2_or295_i266_0_stall_out_reg_21_NO_SHIFT_REG),
	.data_in(local_bb2_or295_i266),
	.data_out(rnode_20to21_bb2_or295_i266_0_reg_21_NO_SHIFT_REG)
);

defparam rnode_20to21_bb2_or295_i266_0_reg_21_fifo.DEPTH = 1;
defparam rnode_20to21_bb2_or295_i266_0_reg_21_fifo.DATA_WIDTH = 32;
defparam rnode_20to21_bb2_or295_i266_0_reg_21_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_20to21_bb2_or295_i266_0_reg_21_fifo.IMPL = "shift_reg";

assign rnode_20to21_bb2_or295_i266_0_reg_21_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_or295_i266_stall_in = 1'b0;
assign rnode_20to21_bb2_or295_i266_0_NO_SHIFT_REG = rnode_20to21_bb2_or295_i266_0_reg_21_NO_SHIFT_REG;
assign rnode_20to21_bb2_or295_i266_0_stall_in_reg_21_NO_SHIFT_REG = 1'b0;
assign rnode_20to21_bb2_or295_i266_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_20to21_bb2_var__u38_0_valid_out_NO_SHIFT_REG;
 logic rnode_20to21_bb2_var__u38_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_20to21_bb2_var__u38_0_NO_SHIFT_REG;
 logic rnode_20to21_bb2_var__u38_0_reg_21_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_20to21_bb2_var__u38_0_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb2_var__u38_0_valid_out_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb2_var__u38_0_stall_in_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb2_var__u38_0_stall_out_reg_21_NO_SHIFT_REG;

acl_data_fifo rnode_20to21_bb2_var__u38_0_reg_21_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_20to21_bb2_var__u38_0_reg_21_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_20to21_bb2_var__u38_0_stall_in_reg_21_NO_SHIFT_REG),
	.valid_out(rnode_20to21_bb2_var__u38_0_valid_out_reg_21_NO_SHIFT_REG),
	.stall_out(rnode_20to21_bb2_var__u38_0_stall_out_reg_21_NO_SHIFT_REG),
	.data_in(local_bb2_var__u38),
	.data_out(rnode_20to21_bb2_var__u38_0_reg_21_NO_SHIFT_REG)
);

defparam rnode_20to21_bb2_var__u38_0_reg_21_fifo.DEPTH = 1;
defparam rnode_20to21_bb2_var__u38_0_reg_21_fifo.DATA_WIDTH = 32;
defparam rnode_20to21_bb2_var__u38_0_reg_21_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_20to21_bb2_var__u38_0_reg_21_fifo.IMPL = "shift_reg";

assign rnode_20to21_bb2_var__u38_0_reg_21_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_var__u38_stall_in = 1'b0;
assign rnode_20to21_bb2_var__u38_0_NO_SHIFT_REG = rnode_20to21_bb2_var__u38_0_reg_21_NO_SHIFT_REG;
assign rnode_20to21_bb2_var__u38_0_stall_in_reg_21_NO_SHIFT_REG = 1'b0;
assign rnode_20to21_bb2_var__u38_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_20to21_bb2_lor_ext_i272_0_valid_out_NO_SHIFT_REG;
 logic rnode_20to21_bb2_lor_ext_i272_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_20to21_bb2_lor_ext_i272_0_NO_SHIFT_REG;
 logic rnode_20to21_bb2_lor_ext_i272_0_reg_21_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_20to21_bb2_lor_ext_i272_0_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb2_lor_ext_i272_0_valid_out_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb2_lor_ext_i272_0_stall_in_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb2_lor_ext_i272_0_stall_out_reg_21_NO_SHIFT_REG;

acl_data_fifo rnode_20to21_bb2_lor_ext_i272_0_reg_21_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_20to21_bb2_lor_ext_i272_0_reg_21_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_20to21_bb2_lor_ext_i272_0_stall_in_reg_21_NO_SHIFT_REG),
	.valid_out(rnode_20to21_bb2_lor_ext_i272_0_valid_out_reg_21_NO_SHIFT_REG),
	.stall_out(rnode_20to21_bb2_lor_ext_i272_0_stall_out_reg_21_NO_SHIFT_REG),
	.data_in(local_bb2_lor_ext_i272),
	.data_out(rnode_20to21_bb2_lor_ext_i272_0_reg_21_NO_SHIFT_REG)
);

defparam rnode_20to21_bb2_lor_ext_i272_0_reg_21_fifo.DEPTH = 1;
defparam rnode_20to21_bb2_lor_ext_i272_0_reg_21_fifo.DATA_WIDTH = 32;
defparam rnode_20to21_bb2_lor_ext_i272_0_reg_21_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_20to21_bb2_lor_ext_i272_0_reg_21_fifo.IMPL = "shift_reg";

assign rnode_20to21_bb2_lor_ext_i272_0_reg_21_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_lor_ext_i272_stall_in = 1'b0;
assign rnode_20to21_bb2_lor_ext_i272_0_NO_SHIFT_REG = rnode_20to21_bb2_lor_ext_i272_0_reg_21_NO_SHIFT_REG;
assign rnode_20to21_bb2_lor_ext_i272_0_stall_in_reg_21_NO_SHIFT_REG = 1'b0;
assign rnode_20to21_bb2_lor_ext_i272_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_20to21_bb2_reduction_0_i276_0_valid_out_NO_SHIFT_REG;
 logic rnode_20to21_bb2_reduction_0_i276_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_20to21_bb2_reduction_0_i276_0_NO_SHIFT_REG;
 logic rnode_20to21_bb2_reduction_0_i276_0_reg_21_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_20to21_bb2_reduction_0_i276_0_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb2_reduction_0_i276_0_valid_out_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb2_reduction_0_i276_0_stall_in_reg_21_NO_SHIFT_REG;
 logic rnode_20to21_bb2_reduction_0_i276_0_stall_out_reg_21_NO_SHIFT_REG;

acl_data_fifo rnode_20to21_bb2_reduction_0_i276_0_reg_21_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_20to21_bb2_reduction_0_i276_0_reg_21_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_20to21_bb2_reduction_0_i276_0_stall_in_reg_21_NO_SHIFT_REG),
	.valid_out(rnode_20to21_bb2_reduction_0_i276_0_valid_out_reg_21_NO_SHIFT_REG),
	.stall_out(rnode_20to21_bb2_reduction_0_i276_0_stall_out_reg_21_NO_SHIFT_REG),
	.data_in(local_bb2_reduction_0_i276),
	.data_out(rnode_20to21_bb2_reduction_0_i276_0_reg_21_NO_SHIFT_REG)
);

defparam rnode_20to21_bb2_reduction_0_i276_0_reg_21_fifo.DEPTH = 1;
defparam rnode_20to21_bb2_reduction_0_i276_0_reg_21_fifo.DATA_WIDTH = 32;
defparam rnode_20to21_bb2_reduction_0_i276_0_reg_21_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_20to21_bb2_reduction_0_i276_0_reg_21_fifo.IMPL = "shift_reg";

assign rnode_20to21_bb2_reduction_0_i276_0_reg_21_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_reduction_0_i276_stall_in = 1'b0;
assign rnode_20to21_bb2_reduction_0_i276_0_NO_SHIFT_REG = rnode_20to21_bb2_reduction_0_i276_0_reg_21_NO_SHIFT_REG;
assign rnode_20to21_bb2_reduction_0_i276_0_stall_in_reg_21_NO_SHIFT_REG = 1'b0;
assign rnode_20to21_bb2_reduction_0_i276_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_ext314_i275_stall_local;
wire [31:0] local_bb2_lnot_ext314_i275;

assign local_bb2_lnot_ext314_i275 = (rnode_20to21_bb2_var__u38_0_NO_SHIFT_REG ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_1_i277_stall_local;
wire [31:0] local_bb2_reduction_1_i277;

assign local_bb2_reduction_1_i277 = (local_bb2_lnot_ext314_i275 & rnode_20to21_bb2_lor_ext_i272_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_2_i278_stall_local;
wire [31:0] local_bb2_reduction_2_i278;

assign local_bb2_reduction_2_i278 = (rnode_20to21_bb2_reduction_0_i276_0_NO_SHIFT_REG & local_bb2_reduction_1_i277);

// This section implements an unregistered operation.
// 
wire local_bb2_add320_i279_valid_out;
wire local_bb2_add320_i279_stall_in;
wire local_bb2_add320_i279_inputs_ready;
wire local_bb2_add320_i279_stall_local;
wire [31:0] local_bb2_add320_i279;

assign local_bb2_add320_i279_inputs_ready = (rnode_20to21_bb2_or295_i266_0_valid_out_NO_SHIFT_REG & rnode_20to21_bb2_reduction_0_i276_0_valid_out_NO_SHIFT_REG & rnode_20to21_bb2_var__u38_0_valid_out_NO_SHIFT_REG & rnode_20to21_bb2_lor_ext_i272_0_valid_out_NO_SHIFT_REG);
assign local_bb2_add320_i279 = (local_bb2_reduction_2_i278 + rnode_20to21_bb2_or295_i266_0_NO_SHIFT_REG);
assign local_bb2_add320_i279_valid_out = 1'b1;
assign rnode_20to21_bb2_or295_i266_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_20to21_bb2_reduction_0_i276_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_20to21_bb2_var__u38_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_20to21_bb2_lor_ext_i272_0_stall_in_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_21to22_bb2_add320_i279_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_21to22_bb2_add320_i279_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_21to22_bb2_add320_i279_0_NO_SHIFT_REG;
 logic rnode_21to22_bb2_add320_i279_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_21to22_bb2_add320_i279_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_21to22_bb2_add320_i279_1_NO_SHIFT_REG;
 logic rnode_21to22_bb2_add320_i279_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_21to22_bb2_add320_i279_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_21to22_bb2_add320_i279_2_NO_SHIFT_REG;
 logic rnode_21to22_bb2_add320_i279_0_reg_22_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_21to22_bb2_add320_i279_0_reg_22_NO_SHIFT_REG;
 logic rnode_21to22_bb2_add320_i279_0_valid_out_0_reg_22_NO_SHIFT_REG;
 logic rnode_21to22_bb2_add320_i279_0_stall_in_0_reg_22_NO_SHIFT_REG;
 logic rnode_21to22_bb2_add320_i279_0_stall_out_reg_22_NO_SHIFT_REG;

acl_data_fifo rnode_21to22_bb2_add320_i279_0_reg_22_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_21to22_bb2_add320_i279_0_reg_22_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_21to22_bb2_add320_i279_0_stall_in_0_reg_22_NO_SHIFT_REG),
	.valid_out(rnode_21to22_bb2_add320_i279_0_valid_out_0_reg_22_NO_SHIFT_REG),
	.stall_out(rnode_21to22_bb2_add320_i279_0_stall_out_reg_22_NO_SHIFT_REG),
	.data_in(local_bb2_add320_i279),
	.data_out(rnode_21to22_bb2_add320_i279_0_reg_22_NO_SHIFT_REG)
);

defparam rnode_21to22_bb2_add320_i279_0_reg_22_fifo.DEPTH = 1;
defparam rnode_21to22_bb2_add320_i279_0_reg_22_fifo.DATA_WIDTH = 32;
defparam rnode_21to22_bb2_add320_i279_0_reg_22_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_21to22_bb2_add320_i279_0_reg_22_fifo.IMPL = "shift_reg";

assign rnode_21to22_bb2_add320_i279_0_reg_22_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_add320_i279_stall_in = 1'b0;
assign rnode_21to22_bb2_add320_i279_0_stall_in_0_reg_22_NO_SHIFT_REG = 1'b0;
assign rnode_21to22_bb2_add320_i279_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_21to22_bb2_add320_i279_0_NO_SHIFT_REG = rnode_21to22_bb2_add320_i279_0_reg_22_NO_SHIFT_REG;
assign rnode_21to22_bb2_add320_i279_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_21to22_bb2_add320_i279_1_NO_SHIFT_REG = rnode_21to22_bb2_add320_i279_0_reg_22_NO_SHIFT_REG;
assign rnode_21to22_bb2_add320_i279_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_21to22_bb2_add320_i279_2_NO_SHIFT_REG = rnode_21to22_bb2_add320_i279_0_reg_22_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_and2_i5_stall_local;
wire [31:0] local_bb2_and2_i5;

assign local_bb2_and2_i5 = (rnode_21to22_bb2_add320_i279_0_NO_SHIFT_REG >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb2_and12_i10_stall_local;
wire [31:0] local_bb2_and12_i10;

assign local_bb2_and12_i10 = (rnode_21to22_bb2_add320_i279_1_NO_SHIFT_REG & 32'hFFFF);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_22to23_bb2_add320_i279_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_22to23_bb2_add320_i279_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_22to23_bb2_add320_i279_0_NO_SHIFT_REG;
 logic rnode_22to23_bb2_add320_i279_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_22to23_bb2_add320_i279_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_22to23_bb2_add320_i279_1_NO_SHIFT_REG;
 logic rnode_22to23_bb2_add320_i279_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_22to23_bb2_add320_i279_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_22to23_bb2_add320_i279_2_NO_SHIFT_REG;
 logic rnode_22to23_bb2_add320_i279_0_reg_23_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_22to23_bb2_add320_i279_0_reg_23_NO_SHIFT_REG;
 logic rnode_22to23_bb2_add320_i279_0_valid_out_0_reg_23_NO_SHIFT_REG;
 logic rnode_22to23_bb2_add320_i279_0_stall_in_0_reg_23_NO_SHIFT_REG;
 logic rnode_22to23_bb2_add320_i279_0_stall_out_reg_23_NO_SHIFT_REG;

acl_data_fifo rnode_22to23_bb2_add320_i279_0_reg_23_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_22to23_bb2_add320_i279_0_reg_23_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_22to23_bb2_add320_i279_0_stall_in_0_reg_23_NO_SHIFT_REG),
	.valid_out(rnode_22to23_bb2_add320_i279_0_valid_out_0_reg_23_NO_SHIFT_REG),
	.stall_out(rnode_22to23_bb2_add320_i279_0_stall_out_reg_23_NO_SHIFT_REG),
	.data_in(rnode_21to22_bb2_add320_i279_2_NO_SHIFT_REG),
	.data_out(rnode_22to23_bb2_add320_i279_0_reg_23_NO_SHIFT_REG)
);

defparam rnode_22to23_bb2_add320_i279_0_reg_23_fifo.DEPTH = 1;
defparam rnode_22to23_bb2_add320_i279_0_reg_23_fifo.DATA_WIDTH = 32;
defparam rnode_22to23_bb2_add320_i279_0_reg_23_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_22to23_bb2_add320_i279_0_reg_23_fifo.IMPL = "shift_reg";

assign rnode_22to23_bb2_add320_i279_0_reg_23_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_21to22_bb2_add320_i279_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_22to23_bb2_add320_i279_0_stall_in_0_reg_23_NO_SHIFT_REG = 1'b0;
assign rnode_22to23_bb2_add320_i279_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_22to23_bb2_add320_i279_0_NO_SHIFT_REG = rnode_22to23_bb2_add320_i279_0_reg_23_NO_SHIFT_REG;
assign rnode_22to23_bb2_add320_i279_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_22to23_bb2_add320_i279_1_NO_SHIFT_REG = rnode_22to23_bb2_add320_i279_0_reg_23_NO_SHIFT_REG;
assign rnode_22to23_bb2_add320_i279_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_22to23_bb2_add320_i279_2_NO_SHIFT_REG = rnode_22to23_bb2_add320_i279_0_reg_23_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_shr3_i6_stall_local;
wire [31:0] local_bb2_shr3_i6;

assign local_bb2_shr3_i6 = (local_bb2_and2_i5 & 32'h7FFF);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp13_i11_stall_local;
wire local_bb2_cmp13_i11;

assign local_bb2_cmp13_i11 = (local_bb2_and10_i9 > local_bb2_and12_i10);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_23to24_bb2_add320_i279_0_valid_out_NO_SHIFT_REG;
 logic rnode_23to24_bb2_add320_i279_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2_add320_i279_0_NO_SHIFT_REG;
 logic rnode_23to24_bb2_add320_i279_0_reg_24_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2_add320_i279_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2_add320_i279_0_valid_out_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2_add320_i279_0_stall_in_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2_add320_i279_0_stall_out_reg_24_NO_SHIFT_REG;

acl_data_fifo rnode_23to24_bb2_add320_i279_0_reg_24_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_23to24_bb2_add320_i279_0_reg_24_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_23to24_bb2_add320_i279_0_stall_in_reg_24_NO_SHIFT_REG),
	.valid_out(rnode_23to24_bb2_add320_i279_0_valid_out_reg_24_NO_SHIFT_REG),
	.stall_out(rnode_23to24_bb2_add320_i279_0_stall_out_reg_24_NO_SHIFT_REG),
	.data_in(rnode_22to23_bb2_add320_i279_2_NO_SHIFT_REG),
	.data_out(rnode_23to24_bb2_add320_i279_0_reg_24_NO_SHIFT_REG)
);

defparam rnode_23to24_bb2_add320_i279_0_reg_24_fifo.DEPTH = 1;
defparam rnode_23to24_bb2_add320_i279_0_reg_24_fifo.DATA_WIDTH = 32;
defparam rnode_23to24_bb2_add320_i279_0_reg_24_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_23to24_bb2_add320_i279_0_reg_24_fifo.IMPL = "shift_reg";

assign rnode_23to24_bb2_add320_i279_0_reg_24_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_22to23_bb2_add320_i279_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2_add320_i279_0_NO_SHIFT_REG = rnode_23to24_bb2_add320_i279_0_reg_24_NO_SHIFT_REG;
assign rnode_23to24_bb2_add320_i279_0_stall_in_reg_24_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2_add320_i279_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_cmp_i7_stall_local;
wire local_bb2_cmp_i7;

assign local_bb2_cmp_i7 = (local_bb2_shr_i4 > local_bb2_shr3_i6);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp8_i8_stall_local;
wire local_bb2_cmp8_i8;

assign local_bb2_cmp8_i8 = (local_bb2_shr_i4 == local_bb2_shr3_i6);

// Register node:
//  * latency = 3
//  * capacity = 3
 logic rnode_24to27_bb2_add320_i279_0_valid_out_NO_SHIFT_REG;
 logic rnode_24to27_bb2_add320_i279_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_24to27_bb2_add320_i279_0_NO_SHIFT_REG;
 logic rnode_24to27_bb2_add320_i279_0_reg_27_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_24to27_bb2_add320_i279_0_reg_27_NO_SHIFT_REG;
 logic rnode_24to27_bb2_add320_i279_0_valid_out_reg_27_NO_SHIFT_REG;
 logic rnode_24to27_bb2_add320_i279_0_stall_in_reg_27_NO_SHIFT_REG;
 logic rnode_24to27_bb2_add320_i279_0_stall_out_reg_27_NO_SHIFT_REG;

acl_data_fifo rnode_24to27_bb2_add320_i279_0_reg_27_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_24to27_bb2_add320_i279_0_reg_27_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_24to27_bb2_add320_i279_0_stall_in_reg_27_NO_SHIFT_REG),
	.valid_out(rnode_24to27_bb2_add320_i279_0_valid_out_reg_27_NO_SHIFT_REG),
	.stall_out(rnode_24to27_bb2_add320_i279_0_stall_out_reg_27_NO_SHIFT_REG),
	.data_in(rnode_23to24_bb2_add320_i279_0_NO_SHIFT_REG),
	.data_out(rnode_24to27_bb2_add320_i279_0_reg_27_NO_SHIFT_REG)
);

defparam rnode_24to27_bb2_add320_i279_0_reg_27_fifo.DEPTH = 3;
defparam rnode_24to27_bb2_add320_i279_0_reg_27_fifo.DATA_WIDTH = 32;
defparam rnode_24to27_bb2_add320_i279_0_reg_27_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_24to27_bb2_add320_i279_0_reg_27_fifo.IMPL = "shift_reg";

assign rnode_24to27_bb2_add320_i279_0_reg_27_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2_add320_i279_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_24to27_bb2_add320_i279_0_NO_SHIFT_REG = rnode_24to27_bb2_add320_i279_0_reg_27_NO_SHIFT_REG;
assign rnode_24to27_bb2_add320_i279_0_stall_in_reg_27_NO_SHIFT_REG = 1'b0;
assign rnode_24to27_bb2_add320_i279_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2___i12_stall_local;
wire local_bb2___i12;

assign local_bb2___i12 = (local_bb2_cmp8_i8 & local_bb2_cmp13_i11);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_27to28_bb2_add320_i279_0_valid_out_NO_SHIFT_REG;
 logic rnode_27to28_bb2_add320_i279_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_27to28_bb2_add320_i279_0_NO_SHIFT_REG;
 logic rnode_27to28_bb2_add320_i279_0_reg_28_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_27to28_bb2_add320_i279_0_reg_28_NO_SHIFT_REG;
 logic rnode_27to28_bb2_add320_i279_0_valid_out_reg_28_NO_SHIFT_REG;
 logic rnode_27to28_bb2_add320_i279_0_stall_in_reg_28_NO_SHIFT_REG;
 logic rnode_27to28_bb2_add320_i279_0_stall_out_reg_28_NO_SHIFT_REG;

acl_data_fifo rnode_27to28_bb2_add320_i279_0_reg_28_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_27to28_bb2_add320_i279_0_reg_28_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_27to28_bb2_add320_i279_0_stall_in_reg_28_NO_SHIFT_REG),
	.valid_out(rnode_27to28_bb2_add320_i279_0_valid_out_reg_28_NO_SHIFT_REG),
	.stall_out(rnode_27to28_bb2_add320_i279_0_stall_out_reg_28_NO_SHIFT_REG),
	.data_in(rnode_24to27_bb2_add320_i279_0_NO_SHIFT_REG),
	.data_out(rnode_27to28_bb2_add320_i279_0_reg_28_NO_SHIFT_REG)
);

defparam rnode_27to28_bb2_add320_i279_0_reg_28_fifo.DEPTH = 1;
defparam rnode_27to28_bb2_add320_i279_0_reg_28_fifo.DATA_WIDTH = 32;
defparam rnode_27to28_bb2_add320_i279_0_reg_28_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_27to28_bb2_add320_i279_0_reg_28_fifo.IMPL = "shift_reg";

assign rnode_27to28_bb2_add320_i279_0_reg_28_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_24to27_bb2_add320_i279_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_27to28_bb2_add320_i279_0_NO_SHIFT_REG = rnode_27to28_bb2_add320_i279_0_reg_28_NO_SHIFT_REG;
assign rnode_27to28_bb2_add320_i279_0_stall_in_reg_28_NO_SHIFT_REG = 1'b0;
assign rnode_27to28_bb2_add320_i279_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_xor_i2_valid_out_2;
wire local_bb2_xor_i2_stall_in_2;
 reg local_bb2_xor_i2_consumed_2_NO_SHIFT_REG;
wire local_bb2__21_i13_valid_out;
wire local_bb2__21_i13_stall_in;
 reg local_bb2__21_i13_consumed_0_NO_SHIFT_REG;
wire local_bb2__21_i13_inputs_ready;
wire local_bb2__21_i13_stall_local;
wire local_bb2__21_i13;

assign local_bb2__21_i13_inputs_ready = (rnode_21to22_bb2_c0_ene25_0_valid_out_NO_SHIFT_REG & rnode_21to22_bb2_add320_i279_0_valid_out_1_NO_SHIFT_REG & rnode_21to22_bb2_add320_i279_0_valid_out_0_NO_SHIFT_REG);
assign local_bb2__21_i13 = (local_bb2_cmp_i7 | local_bb2___i12);
assign local_bb2_xor_i2_valid_out_2 = 1'b1;
assign local_bb2__21_i13_valid_out = 1'b1;
assign rnode_21to22_bb2_c0_ene25_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_21to22_bb2_add320_i279_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_21to22_bb2_add320_i279_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_xor_i2_consumed_2_NO_SHIFT_REG <= 1'b0;
		local_bb2__21_i13_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_xor_i2_consumed_2_NO_SHIFT_REG <= (local_bb2__21_i13_inputs_ready & (local_bb2_xor_i2_consumed_2_NO_SHIFT_REG | ~(local_bb2_xor_i2_stall_in_2)) & local_bb2__21_i13_stall_local);
		local_bb2__21_i13_consumed_0_NO_SHIFT_REG <= (local_bb2__21_i13_inputs_ready & (local_bb2__21_i13_consumed_0_NO_SHIFT_REG | ~(local_bb2__21_i13_stall_in)) & local_bb2__21_i13_stall_local);
	end
end


// This section implements an unregistered operation.
// 
wire local_bb2_var__u39_stall_local;
wire [31:0] local_bb2_var__u39;

assign local_bb2_var__u39 = rnode_27to28_bb2_add320_i279_0_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_22to23_bb2_xor_i2_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_22to23_bb2_xor_i2_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_22to23_bb2_xor_i2_0_NO_SHIFT_REG;
 logic rnode_22to23_bb2_xor_i2_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_22to23_bb2_xor_i2_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_22to23_bb2_xor_i2_1_NO_SHIFT_REG;
 logic rnode_22to23_bb2_xor_i2_0_reg_23_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_22to23_bb2_xor_i2_0_reg_23_NO_SHIFT_REG;
 logic rnode_22to23_bb2_xor_i2_0_valid_out_0_reg_23_NO_SHIFT_REG;
 logic rnode_22to23_bb2_xor_i2_0_stall_in_0_reg_23_NO_SHIFT_REG;
 logic rnode_22to23_bb2_xor_i2_0_stall_out_reg_23_NO_SHIFT_REG;

acl_data_fifo rnode_22to23_bb2_xor_i2_0_reg_23_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_22to23_bb2_xor_i2_0_reg_23_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_22to23_bb2_xor_i2_0_stall_in_0_reg_23_NO_SHIFT_REG),
	.valid_out(rnode_22to23_bb2_xor_i2_0_valid_out_0_reg_23_NO_SHIFT_REG),
	.stall_out(rnode_22to23_bb2_xor_i2_0_stall_out_reg_23_NO_SHIFT_REG),
	.data_in(local_bb2_xor_i2),
	.data_out(rnode_22to23_bb2_xor_i2_0_reg_23_NO_SHIFT_REG)
);

defparam rnode_22to23_bb2_xor_i2_0_reg_23_fifo.DEPTH = 1;
defparam rnode_22to23_bb2_xor_i2_0_reg_23_fifo.DATA_WIDTH = 32;
defparam rnode_22to23_bb2_xor_i2_0_reg_23_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_22to23_bb2_xor_i2_0_reg_23_fifo.IMPL = "shift_reg";

assign rnode_22to23_bb2_xor_i2_0_reg_23_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_xor_i2_stall_in_2 = 1'b0;
assign rnode_22to23_bb2_xor_i2_0_stall_in_0_reg_23_NO_SHIFT_REG = 1'b0;
assign rnode_22to23_bb2_xor_i2_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_22to23_bb2_xor_i2_0_NO_SHIFT_REG = rnode_22to23_bb2_xor_i2_0_reg_23_NO_SHIFT_REG;
assign rnode_22to23_bb2_xor_i2_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_22to23_bb2_xor_i2_1_NO_SHIFT_REG = rnode_22to23_bb2_xor_i2_0_reg_23_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_22to23_bb2__21_i13_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_22to23_bb2__21_i13_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_22to23_bb2__21_i13_0_NO_SHIFT_REG;
 logic rnode_22to23_bb2__21_i13_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_22to23_bb2__21_i13_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_22to23_bb2__21_i13_1_NO_SHIFT_REG;
 logic rnode_22to23_bb2__21_i13_0_reg_23_inputs_ready_NO_SHIFT_REG;
 logic rnode_22to23_bb2__21_i13_0_reg_23_NO_SHIFT_REG;
 logic rnode_22to23_bb2__21_i13_0_valid_out_0_reg_23_NO_SHIFT_REG;
 logic rnode_22to23_bb2__21_i13_0_stall_in_0_reg_23_NO_SHIFT_REG;
 logic rnode_22to23_bb2__21_i13_0_stall_out_reg_23_NO_SHIFT_REG;

acl_data_fifo rnode_22to23_bb2__21_i13_0_reg_23_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_22to23_bb2__21_i13_0_reg_23_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_22to23_bb2__21_i13_0_stall_in_0_reg_23_NO_SHIFT_REG),
	.valid_out(rnode_22to23_bb2__21_i13_0_valid_out_0_reg_23_NO_SHIFT_REG),
	.stall_out(rnode_22to23_bb2__21_i13_0_stall_out_reg_23_NO_SHIFT_REG),
	.data_in(local_bb2__21_i13),
	.data_out(rnode_22to23_bb2__21_i13_0_reg_23_NO_SHIFT_REG)
);

defparam rnode_22to23_bb2__21_i13_0_reg_23_fifo.DEPTH = 1;
defparam rnode_22to23_bb2__21_i13_0_reg_23_fifo.DATA_WIDTH = 1;
defparam rnode_22to23_bb2__21_i13_0_reg_23_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_22to23_bb2__21_i13_0_reg_23_fifo.IMPL = "shift_reg";

assign rnode_22to23_bb2__21_i13_0_reg_23_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__21_i13_stall_in = 1'b0;
assign rnode_22to23_bb2__21_i13_0_stall_in_0_reg_23_NO_SHIFT_REG = 1'b0;
assign rnode_22to23_bb2__21_i13_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_22to23_bb2__21_i13_0_NO_SHIFT_REG = rnode_22to23_bb2__21_i13_0_reg_23_NO_SHIFT_REG;
assign rnode_22to23_bb2__21_i13_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_22to23_bb2__21_i13_1_NO_SHIFT_REG = rnode_22to23_bb2__21_i13_0_reg_23_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_c0_exi16_stall_local;
wire [95:0] local_bb2_c0_exi16;

assign local_bb2_c0_exi16[31:0] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
assign local_bb2_c0_exi16[63:32] = local_bb2_var__u39;
assign local_bb2_c0_exi16[95:64] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;

// This section implements an unregistered operation.
// 
wire local_bb2__22_i14_stall_local;
wire [31:0] local_bb2__22_i14;

assign local_bb2__22_i14 = (rnode_22to23_bb2__21_i13_0_NO_SHIFT_REG ? rnode_22to23_bb2_add320_i279_0_NO_SHIFT_REG : rnode_22to23_bb2_xor_i2_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2__23_i15_stall_local;
wire [31:0] local_bb2__23_i15;

assign local_bb2__23_i15 = (rnode_22to23_bb2__21_i13_1_NO_SHIFT_REG ? rnode_22to23_bb2_xor_i2_1_NO_SHIFT_REG : rnode_22to23_bb2_add320_i279_1_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_shr18_i18_stall_local;
wire [31:0] local_bb2_shr18_i18;

assign local_bb2_shr18_i18 = (local_bb2__22_i14 >> 32'h17);

// This section implements an unregistered operation.
// 
wire local_bb2_shr16_i16_stall_local;
wire [31:0] local_bb2_shr16_i16;

assign local_bb2_shr16_i16 = (local_bb2__23_i15 >> 32'h17);

// This section implements an unregistered operation.
// 
wire local_bb2_and19_i19_stall_local;
wire [31:0] local_bb2_and19_i19;

assign local_bb2_and19_i19 = (local_bb2_shr18_i18 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_sub_i44_stall_local;
wire [31:0] local_bb2_sub_i44;

assign local_bb2_sub_i44 = (local_bb2_shr16_i16 - local_bb2_shr18_i18);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot23_i23_stall_local;
wire local_bb2_lnot23_i23;

assign local_bb2_lnot23_i23 = (local_bb2_and19_i19 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp27_i25_stall_local;
wire local_bb2_cmp27_i25;

assign local_bb2_cmp27_i25 = (local_bb2_and19_i19 == 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and69_i_stall_local;
wire [31:0] local_bb2_and69_i;

assign local_bb2_and69_i = (local_bb2_sub_i44 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp70_i_stall_local;
wire local_bb2_cmp70_i;

assign local_bb2_cmp70_i = (local_bb2_and69_i > 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb2__22_i14_valid_out_1;
wire local_bb2__22_i14_stall_in_1;
 reg local_bb2__22_i14_consumed_1_NO_SHIFT_REG;
wire local_bb2__23_i15_valid_out_1;
wire local_bb2__23_i15_stall_in_1;
 reg local_bb2__23_i15_consumed_1_NO_SHIFT_REG;
wire local_bb2_shr16_i16_valid_out_1;
wire local_bb2_shr16_i16_stall_in_1;
 reg local_bb2_shr16_i16_consumed_1_NO_SHIFT_REG;
wire local_bb2_lnot23_i23_valid_out;
wire local_bb2_lnot23_i23_stall_in;
 reg local_bb2_lnot23_i23_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp27_i25_valid_out;
wire local_bb2_cmp27_i25_stall_in;
 reg local_bb2_cmp27_i25_consumed_0_NO_SHIFT_REG;
wire local_bb2_align_0_i45_valid_out;
wire local_bb2_align_0_i45_stall_in;
 reg local_bb2_align_0_i45_consumed_0_NO_SHIFT_REG;
wire local_bb2_align_0_i45_inputs_ready;
wire local_bb2_align_0_i45_stall_local;
wire [31:0] local_bb2_align_0_i45;

assign local_bb2_align_0_i45_inputs_ready = (rnode_22to23_bb2__21_i13_0_valid_out_0_NO_SHIFT_REG & rnode_22to23_bb2_xor_i2_0_valid_out_0_NO_SHIFT_REG & rnode_22to23_bb2_add320_i279_0_valid_out_0_NO_SHIFT_REG & rnode_22to23_bb2__21_i13_0_valid_out_1_NO_SHIFT_REG & rnode_22to23_bb2_xor_i2_0_valid_out_1_NO_SHIFT_REG & rnode_22to23_bb2_add320_i279_0_valid_out_1_NO_SHIFT_REG);
assign local_bb2_align_0_i45 = (local_bb2_cmp70_i ? 32'h1F : local_bb2_and69_i);
assign local_bb2__22_i14_valid_out_1 = 1'b1;
assign local_bb2__23_i15_valid_out_1 = 1'b1;
assign local_bb2_shr16_i16_valid_out_1 = 1'b1;
assign local_bb2_lnot23_i23_valid_out = 1'b1;
assign local_bb2_cmp27_i25_valid_out = 1'b1;
assign local_bb2_align_0_i45_valid_out = 1'b1;
assign rnode_22to23_bb2__21_i13_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_22to23_bb2_xor_i2_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_22to23_bb2_add320_i279_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_22to23_bb2__21_i13_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_22to23_bb2_xor_i2_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_22to23_bb2_add320_i279_0_stall_in_1_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2__22_i14_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb2__23_i15_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb2_shr16_i16_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb2_lnot23_i23_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp27_i25_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_align_0_i45_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2__22_i14_consumed_1_NO_SHIFT_REG <= (local_bb2_align_0_i45_inputs_ready & (local_bb2__22_i14_consumed_1_NO_SHIFT_REG | ~(local_bb2__22_i14_stall_in_1)) & local_bb2_align_0_i45_stall_local);
		local_bb2__23_i15_consumed_1_NO_SHIFT_REG <= (local_bb2_align_0_i45_inputs_ready & (local_bb2__23_i15_consumed_1_NO_SHIFT_REG | ~(local_bb2__23_i15_stall_in_1)) & local_bb2_align_0_i45_stall_local);
		local_bb2_shr16_i16_consumed_1_NO_SHIFT_REG <= (local_bb2_align_0_i45_inputs_ready & (local_bb2_shr16_i16_consumed_1_NO_SHIFT_REG | ~(local_bb2_shr16_i16_stall_in_1)) & local_bb2_align_0_i45_stall_local);
		local_bb2_lnot23_i23_consumed_0_NO_SHIFT_REG <= (local_bb2_align_0_i45_inputs_ready & (local_bb2_lnot23_i23_consumed_0_NO_SHIFT_REG | ~(local_bb2_lnot23_i23_stall_in)) & local_bb2_align_0_i45_stall_local);
		local_bb2_cmp27_i25_consumed_0_NO_SHIFT_REG <= (local_bb2_align_0_i45_inputs_ready & (local_bb2_cmp27_i25_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp27_i25_stall_in)) & local_bb2_align_0_i45_stall_local);
		local_bb2_align_0_i45_consumed_0_NO_SHIFT_REG <= (local_bb2_align_0_i45_inputs_ready & (local_bb2_align_0_i45_consumed_0_NO_SHIFT_REG | ~(local_bb2_align_0_i45_stall_in)) & local_bb2_align_0_i45_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_23to24_bb2__22_i14_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_23to24_bb2__22_i14_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2__22_i14_0_NO_SHIFT_REG;
 logic rnode_23to24_bb2__22_i14_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_23to24_bb2__22_i14_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2__22_i14_1_NO_SHIFT_REG;
 logic rnode_23to24_bb2__22_i14_0_reg_24_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2__22_i14_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2__22_i14_0_valid_out_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2__22_i14_0_stall_in_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2__22_i14_0_stall_out_reg_24_NO_SHIFT_REG;

acl_data_fifo rnode_23to24_bb2__22_i14_0_reg_24_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_23to24_bb2__22_i14_0_reg_24_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_23to24_bb2__22_i14_0_stall_in_0_reg_24_NO_SHIFT_REG),
	.valid_out(rnode_23to24_bb2__22_i14_0_valid_out_0_reg_24_NO_SHIFT_REG),
	.stall_out(rnode_23to24_bb2__22_i14_0_stall_out_reg_24_NO_SHIFT_REG),
	.data_in(local_bb2__22_i14),
	.data_out(rnode_23to24_bb2__22_i14_0_reg_24_NO_SHIFT_REG)
);

defparam rnode_23to24_bb2__22_i14_0_reg_24_fifo.DEPTH = 1;
defparam rnode_23to24_bb2__22_i14_0_reg_24_fifo.DATA_WIDTH = 32;
defparam rnode_23to24_bb2__22_i14_0_reg_24_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_23to24_bb2__22_i14_0_reg_24_fifo.IMPL = "shift_reg";

assign rnode_23to24_bb2__22_i14_0_reg_24_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__22_i14_stall_in_1 = 1'b0;
assign rnode_23to24_bb2__22_i14_0_stall_in_0_reg_24_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2__22_i14_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2__22_i14_0_NO_SHIFT_REG = rnode_23to24_bb2__22_i14_0_reg_24_NO_SHIFT_REG;
assign rnode_23to24_bb2__22_i14_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2__22_i14_1_NO_SHIFT_REG = rnode_23to24_bb2__22_i14_0_reg_24_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_23to24_bb2__23_i15_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_23to24_bb2__23_i15_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2__23_i15_0_NO_SHIFT_REG;
 logic rnode_23to24_bb2__23_i15_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_23to24_bb2__23_i15_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2__23_i15_1_NO_SHIFT_REG;
 logic rnode_23to24_bb2__23_i15_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_23to24_bb2__23_i15_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2__23_i15_2_NO_SHIFT_REG;
 logic rnode_23to24_bb2__23_i15_0_reg_24_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2__23_i15_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2__23_i15_0_valid_out_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2__23_i15_0_stall_in_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2__23_i15_0_stall_out_reg_24_NO_SHIFT_REG;

acl_data_fifo rnode_23to24_bb2__23_i15_0_reg_24_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_23to24_bb2__23_i15_0_reg_24_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_23to24_bb2__23_i15_0_stall_in_0_reg_24_NO_SHIFT_REG),
	.valid_out(rnode_23to24_bb2__23_i15_0_valid_out_0_reg_24_NO_SHIFT_REG),
	.stall_out(rnode_23to24_bb2__23_i15_0_stall_out_reg_24_NO_SHIFT_REG),
	.data_in(local_bb2__23_i15),
	.data_out(rnode_23to24_bb2__23_i15_0_reg_24_NO_SHIFT_REG)
);

defparam rnode_23to24_bb2__23_i15_0_reg_24_fifo.DEPTH = 1;
defparam rnode_23to24_bb2__23_i15_0_reg_24_fifo.DATA_WIDTH = 32;
defparam rnode_23to24_bb2__23_i15_0_reg_24_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_23to24_bb2__23_i15_0_reg_24_fifo.IMPL = "shift_reg";

assign rnode_23to24_bb2__23_i15_0_reg_24_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__23_i15_stall_in_1 = 1'b0;
assign rnode_23to24_bb2__23_i15_0_stall_in_0_reg_24_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2__23_i15_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2__23_i15_0_NO_SHIFT_REG = rnode_23to24_bb2__23_i15_0_reg_24_NO_SHIFT_REG;
assign rnode_23to24_bb2__23_i15_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2__23_i15_1_NO_SHIFT_REG = rnode_23to24_bb2__23_i15_0_reg_24_NO_SHIFT_REG;
assign rnode_23to24_bb2__23_i15_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2__23_i15_2_NO_SHIFT_REG = rnode_23to24_bb2__23_i15_0_reg_24_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_23to24_bb2_shr16_i16_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_23to24_bb2_shr16_i16_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2_shr16_i16_0_NO_SHIFT_REG;
 logic rnode_23to24_bb2_shr16_i16_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_23to24_bb2_shr16_i16_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2_shr16_i16_1_NO_SHIFT_REG;
 logic rnode_23to24_bb2_shr16_i16_0_reg_24_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2_shr16_i16_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2_shr16_i16_0_valid_out_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2_shr16_i16_0_stall_in_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2_shr16_i16_0_stall_out_reg_24_NO_SHIFT_REG;

acl_data_fifo rnode_23to24_bb2_shr16_i16_0_reg_24_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_23to24_bb2_shr16_i16_0_reg_24_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_23to24_bb2_shr16_i16_0_stall_in_0_reg_24_NO_SHIFT_REG),
	.valid_out(rnode_23to24_bb2_shr16_i16_0_valid_out_0_reg_24_NO_SHIFT_REG),
	.stall_out(rnode_23to24_bb2_shr16_i16_0_stall_out_reg_24_NO_SHIFT_REG),
	.data_in(local_bb2_shr16_i16),
	.data_out(rnode_23to24_bb2_shr16_i16_0_reg_24_NO_SHIFT_REG)
);

defparam rnode_23to24_bb2_shr16_i16_0_reg_24_fifo.DEPTH = 1;
defparam rnode_23to24_bb2_shr16_i16_0_reg_24_fifo.DATA_WIDTH = 32;
defparam rnode_23to24_bb2_shr16_i16_0_reg_24_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_23to24_bb2_shr16_i16_0_reg_24_fifo.IMPL = "shift_reg";

assign rnode_23to24_bb2_shr16_i16_0_reg_24_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_shr16_i16_stall_in_1 = 1'b0;
assign rnode_23to24_bb2_shr16_i16_0_stall_in_0_reg_24_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2_shr16_i16_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2_shr16_i16_0_NO_SHIFT_REG = rnode_23to24_bb2_shr16_i16_0_reg_24_NO_SHIFT_REG;
assign rnode_23to24_bb2_shr16_i16_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2_shr16_i16_1_NO_SHIFT_REG = rnode_23to24_bb2_shr16_i16_0_reg_24_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_23to24_bb2_lnot23_i23_0_valid_out_NO_SHIFT_REG;
 logic rnode_23to24_bb2_lnot23_i23_0_stall_in_NO_SHIFT_REG;
 logic rnode_23to24_bb2_lnot23_i23_0_NO_SHIFT_REG;
 logic rnode_23to24_bb2_lnot23_i23_0_reg_24_inputs_ready_NO_SHIFT_REG;
 logic rnode_23to24_bb2_lnot23_i23_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2_lnot23_i23_0_valid_out_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2_lnot23_i23_0_stall_in_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2_lnot23_i23_0_stall_out_reg_24_NO_SHIFT_REG;

acl_data_fifo rnode_23to24_bb2_lnot23_i23_0_reg_24_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_23to24_bb2_lnot23_i23_0_reg_24_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_23to24_bb2_lnot23_i23_0_stall_in_reg_24_NO_SHIFT_REG),
	.valid_out(rnode_23to24_bb2_lnot23_i23_0_valid_out_reg_24_NO_SHIFT_REG),
	.stall_out(rnode_23to24_bb2_lnot23_i23_0_stall_out_reg_24_NO_SHIFT_REG),
	.data_in(local_bb2_lnot23_i23),
	.data_out(rnode_23to24_bb2_lnot23_i23_0_reg_24_NO_SHIFT_REG)
);

defparam rnode_23to24_bb2_lnot23_i23_0_reg_24_fifo.DEPTH = 1;
defparam rnode_23to24_bb2_lnot23_i23_0_reg_24_fifo.DATA_WIDTH = 1;
defparam rnode_23to24_bb2_lnot23_i23_0_reg_24_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_23to24_bb2_lnot23_i23_0_reg_24_fifo.IMPL = "shift_reg";

assign rnode_23to24_bb2_lnot23_i23_0_reg_24_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_lnot23_i23_stall_in = 1'b0;
assign rnode_23to24_bb2_lnot23_i23_0_NO_SHIFT_REG = rnode_23to24_bb2_lnot23_i23_0_reg_24_NO_SHIFT_REG;
assign rnode_23to24_bb2_lnot23_i23_0_stall_in_reg_24_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2_lnot23_i23_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_23to24_bb2_cmp27_i25_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_23to24_bb2_cmp27_i25_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_23to24_bb2_cmp27_i25_0_NO_SHIFT_REG;
 logic rnode_23to24_bb2_cmp27_i25_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_23to24_bb2_cmp27_i25_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_23to24_bb2_cmp27_i25_1_NO_SHIFT_REG;
 logic rnode_23to24_bb2_cmp27_i25_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_23to24_bb2_cmp27_i25_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_23to24_bb2_cmp27_i25_2_NO_SHIFT_REG;
 logic rnode_23to24_bb2_cmp27_i25_0_reg_24_inputs_ready_NO_SHIFT_REG;
 logic rnode_23to24_bb2_cmp27_i25_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2_cmp27_i25_0_valid_out_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2_cmp27_i25_0_stall_in_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2_cmp27_i25_0_stall_out_reg_24_NO_SHIFT_REG;

acl_data_fifo rnode_23to24_bb2_cmp27_i25_0_reg_24_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_23to24_bb2_cmp27_i25_0_reg_24_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_23to24_bb2_cmp27_i25_0_stall_in_0_reg_24_NO_SHIFT_REG),
	.valid_out(rnode_23to24_bb2_cmp27_i25_0_valid_out_0_reg_24_NO_SHIFT_REG),
	.stall_out(rnode_23to24_bb2_cmp27_i25_0_stall_out_reg_24_NO_SHIFT_REG),
	.data_in(local_bb2_cmp27_i25),
	.data_out(rnode_23to24_bb2_cmp27_i25_0_reg_24_NO_SHIFT_REG)
);

defparam rnode_23to24_bb2_cmp27_i25_0_reg_24_fifo.DEPTH = 1;
defparam rnode_23to24_bb2_cmp27_i25_0_reg_24_fifo.DATA_WIDTH = 1;
defparam rnode_23to24_bb2_cmp27_i25_0_reg_24_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_23to24_bb2_cmp27_i25_0_reg_24_fifo.IMPL = "shift_reg";

assign rnode_23to24_bb2_cmp27_i25_0_reg_24_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp27_i25_stall_in = 1'b0;
assign rnode_23to24_bb2_cmp27_i25_0_stall_in_0_reg_24_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2_cmp27_i25_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2_cmp27_i25_0_NO_SHIFT_REG = rnode_23to24_bb2_cmp27_i25_0_reg_24_NO_SHIFT_REG;
assign rnode_23to24_bb2_cmp27_i25_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2_cmp27_i25_1_NO_SHIFT_REG = rnode_23to24_bb2_cmp27_i25_0_reg_24_NO_SHIFT_REG;
assign rnode_23to24_bb2_cmp27_i25_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2_cmp27_i25_2_NO_SHIFT_REG = rnode_23to24_bb2_cmp27_i25_0_reg_24_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_23to24_bb2_align_0_i45_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_23to24_bb2_align_0_i45_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2_align_0_i45_0_NO_SHIFT_REG;
 logic rnode_23to24_bb2_align_0_i45_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_23to24_bb2_align_0_i45_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2_align_0_i45_1_NO_SHIFT_REG;
 logic rnode_23to24_bb2_align_0_i45_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_23to24_bb2_align_0_i45_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2_align_0_i45_2_NO_SHIFT_REG;
 logic rnode_23to24_bb2_align_0_i45_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_23to24_bb2_align_0_i45_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2_align_0_i45_3_NO_SHIFT_REG;
 logic rnode_23to24_bb2_align_0_i45_0_valid_out_4_NO_SHIFT_REG;
 logic rnode_23to24_bb2_align_0_i45_0_stall_in_4_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2_align_0_i45_4_NO_SHIFT_REG;
 logic rnode_23to24_bb2_align_0_i45_0_reg_24_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_23to24_bb2_align_0_i45_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2_align_0_i45_0_valid_out_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2_align_0_i45_0_stall_in_0_reg_24_NO_SHIFT_REG;
 logic rnode_23to24_bb2_align_0_i45_0_stall_out_reg_24_NO_SHIFT_REG;

acl_data_fifo rnode_23to24_bb2_align_0_i45_0_reg_24_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_23to24_bb2_align_0_i45_0_reg_24_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_23to24_bb2_align_0_i45_0_stall_in_0_reg_24_NO_SHIFT_REG),
	.valid_out(rnode_23to24_bb2_align_0_i45_0_valid_out_0_reg_24_NO_SHIFT_REG),
	.stall_out(rnode_23to24_bb2_align_0_i45_0_stall_out_reg_24_NO_SHIFT_REG),
	.data_in(local_bb2_align_0_i45),
	.data_out(rnode_23to24_bb2_align_0_i45_0_reg_24_NO_SHIFT_REG)
);

defparam rnode_23to24_bb2_align_0_i45_0_reg_24_fifo.DEPTH = 1;
defparam rnode_23to24_bb2_align_0_i45_0_reg_24_fifo.DATA_WIDTH = 32;
defparam rnode_23to24_bb2_align_0_i45_0_reg_24_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_23to24_bb2_align_0_i45_0_reg_24_fifo.IMPL = "shift_reg";

assign rnode_23to24_bb2_align_0_i45_0_reg_24_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_align_0_i45_stall_in = 1'b0;
assign rnode_23to24_bb2_align_0_i45_0_stall_in_0_reg_24_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2_align_0_i45_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2_align_0_i45_0_NO_SHIFT_REG = rnode_23to24_bb2_align_0_i45_0_reg_24_NO_SHIFT_REG;
assign rnode_23to24_bb2_align_0_i45_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2_align_0_i45_1_NO_SHIFT_REG = rnode_23to24_bb2_align_0_i45_0_reg_24_NO_SHIFT_REG;
assign rnode_23to24_bb2_align_0_i45_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2_align_0_i45_2_NO_SHIFT_REG = rnode_23to24_bb2_align_0_i45_0_reg_24_NO_SHIFT_REG;
assign rnode_23to24_bb2_align_0_i45_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2_align_0_i45_3_NO_SHIFT_REG = rnode_23to24_bb2_align_0_i45_0_reg_24_NO_SHIFT_REG;
assign rnode_23to24_bb2_align_0_i45_0_valid_out_4_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2_align_0_i45_4_NO_SHIFT_REG = rnode_23to24_bb2_align_0_i45_0_reg_24_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_and21_i21_stall_local;
wire [31:0] local_bb2_and21_i21;

assign local_bb2_and21_i21 = (rnode_23to24_bb2__22_i14_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and20_i20_stall_local;
wire [31:0] local_bb2_and20_i20;

assign local_bb2_and20_i20 = (rnode_23to24_bb2__23_i15_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and35_i26_valid_out;
wire local_bb2_and35_i26_stall_in;
wire local_bb2_and35_i26_inputs_ready;
wire local_bb2_and35_i26_stall_local;
wire [31:0] local_bb2_and35_i26;

assign local_bb2_and35_i26_inputs_ready = rnode_23to24_bb2__23_i15_0_valid_out_1_NO_SHIFT_REG;
assign local_bb2_and35_i26 = (rnode_23to24_bb2__23_i15_1_NO_SHIFT_REG & 32'h80000000);
assign local_bb2_and35_i26_valid_out = 1'b1;
assign rnode_23to24_bb2__23_i15_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_xor36_i_stall_local;
wire [31:0] local_bb2_xor36_i;

assign local_bb2_xor36_i = (rnode_23to24_bb2__23_i15_2_NO_SHIFT_REG ^ rnode_23to24_bb2__22_i14_1_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_and17_i17_stall_local;
wire [31:0] local_bb2_and17_i17;

assign local_bb2_and17_i17 = (rnode_23to24_bb2_shr16_i16_0_NO_SHIFT_REG & 32'hFF);

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_24to26_bb2_shr16_i16_0_valid_out_NO_SHIFT_REG;
 logic rnode_24to26_bb2_shr16_i16_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_24to26_bb2_shr16_i16_0_NO_SHIFT_REG;
 logic rnode_24to26_bb2_shr16_i16_0_reg_26_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_24to26_bb2_shr16_i16_0_reg_26_NO_SHIFT_REG;
 logic rnode_24to26_bb2_shr16_i16_0_valid_out_reg_26_NO_SHIFT_REG;
 logic rnode_24to26_bb2_shr16_i16_0_stall_in_reg_26_NO_SHIFT_REG;
 logic rnode_24to26_bb2_shr16_i16_0_stall_out_reg_26_NO_SHIFT_REG;

acl_data_fifo rnode_24to26_bb2_shr16_i16_0_reg_26_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_24to26_bb2_shr16_i16_0_reg_26_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_24to26_bb2_shr16_i16_0_stall_in_reg_26_NO_SHIFT_REG),
	.valid_out(rnode_24to26_bb2_shr16_i16_0_valid_out_reg_26_NO_SHIFT_REG),
	.stall_out(rnode_24to26_bb2_shr16_i16_0_stall_out_reg_26_NO_SHIFT_REG),
	.data_in(rnode_23to24_bb2_shr16_i16_1_NO_SHIFT_REG),
	.data_out(rnode_24to26_bb2_shr16_i16_0_reg_26_NO_SHIFT_REG)
);

defparam rnode_24to26_bb2_shr16_i16_0_reg_26_fifo.DEPTH = 2;
defparam rnode_24to26_bb2_shr16_i16_0_reg_26_fifo.DATA_WIDTH = 32;
defparam rnode_24to26_bb2_shr16_i16_0_reg_26_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_24to26_bb2_shr16_i16_0_reg_26_fifo.IMPL = "shift_reg";

assign rnode_24to26_bb2_shr16_i16_0_reg_26_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_23to24_bb2_shr16_i16_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_24to26_bb2_shr16_i16_0_NO_SHIFT_REG = rnode_24to26_bb2_shr16_i16_0_reg_26_NO_SHIFT_REG;
assign rnode_24to26_bb2_shr16_i16_0_stall_in_reg_26_NO_SHIFT_REG = 1'b0;
assign rnode_24to26_bb2_shr16_i16_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_and94_i_stall_local;
wire [31:0] local_bb2_and94_i;

assign local_bb2_and94_i = (rnode_23to24_bb2_align_0_i45_0_NO_SHIFT_REG & 32'h1C);

// This section implements an unregistered operation.
// 
wire local_bb2_and96_i_stall_local;
wire [31:0] local_bb2_and96_i;

assign local_bb2_and96_i = (rnode_23to24_bb2_align_0_i45_1_NO_SHIFT_REG & 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb2_and116_i_stall_local;
wire [31:0] local_bb2_and116_i;

assign local_bb2_and116_i = (rnode_23to24_bb2_align_0_i45_2_NO_SHIFT_REG & 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb2_and131_i_stall_local;
wire [31:0] local_bb2_and131_i;

assign local_bb2_and131_i = (rnode_23to24_bb2_align_0_i45_3_NO_SHIFT_REG & 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb2_and150_i_stall_local;
wire [31:0] local_bb2_and150_i;

assign local_bb2_and150_i = (rnode_23to24_bb2_align_0_i45_4_NO_SHIFT_REG & 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot33_not_i30_stall_local;
wire local_bb2_lnot33_not_i30;

assign local_bb2_lnot33_not_i30 = (local_bb2_and21_i21 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or65_i_stall_local;
wire [31:0] local_bb2_or65_i;

assign local_bb2_or65_i = (local_bb2_and21_i21 << 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot30_i28_stall_local;
wire local_bb2_lnot30_i28;

assign local_bb2_lnot30_i28 = (local_bb2_and20_i20 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or_i40_stall_local;
wire [31:0] local_bb2_or_i40;

assign local_bb2_or_i40 = (local_bb2_and20_i20 << 32'h3);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_24to25_bb2_and35_i26_0_valid_out_NO_SHIFT_REG;
 logic rnode_24to25_bb2_and35_i26_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_24to25_bb2_and35_i26_0_NO_SHIFT_REG;
 logic rnode_24to25_bb2_and35_i26_0_reg_25_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_24to25_bb2_and35_i26_0_reg_25_NO_SHIFT_REG;
 logic rnode_24to25_bb2_and35_i26_0_valid_out_reg_25_NO_SHIFT_REG;
 logic rnode_24to25_bb2_and35_i26_0_stall_in_reg_25_NO_SHIFT_REG;
 logic rnode_24to25_bb2_and35_i26_0_stall_out_reg_25_NO_SHIFT_REG;

acl_data_fifo rnode_24to25_bb2_and35_i26_0_reg_25_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_24to25_bb2_and35_i26_0_reg_25_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_24to25_bb2_and35_i26_0_stall_in_reg_25_NO_SHIFT_REG),
	.valid_out(rnode_24to25_bb2_and35_i26_0_valid_out_reg_25_NO_SHIFT_REG),
	.stall_out(rnode_24to25_bb2_and35_i26_0_stall_out_reg_25_NO_SHIFT_REG),
	.data_in(local_bb2_and35_i26),
	.data_out(rnode_24to25_bb2_and35_i26_0_reg_25_NO_SHIFT_REG)
);

defparam rnode_24to25_bb2_and35_i26_0_reg_25_fifo.DEPTH = 1;
defparam rnode_24to25_bb2_and35_i26_0_reg_25_fifo.DATA_WIDTH = 32;
defparam rnode_24to25_bb2_and35_i26_0_reg_25_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_24to25_bb2_and35_i26_0_reg_25_fifo.IMPL = "shift_reg";

assign rnode_24to25_bb2_and35_i26_0_reg_25_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and35_i26_stall_in = 1'b0;
assign rnode_24to25_bb2_and35_i26_0_NO_SHIFT_REG = rnode_24to25_bb2_and35_i26_0_reg_25_NO_SHIFT_REG;
assign rnode_24to25_bb2_and35_i26_0_stall_in_reg_25_NO_SHIFT_REG = 1'b0;
assign rnode_24to25_bb2_and35_i26_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_cmp38_i_stall_local;
wire local_bb2_cmp38_i;

assign local_bb2_cmp38_i = ($signed(local_bb2_xor36_i) < $signed(32'h0));

// This section implements an unregistered operation.
// 
wire local_bb2_xor36_lobit_i_stall_local;
wire [31:0] local_bb2_xor36_lobit_i;

assign local_bb2_xor36_lobit_i = ($signed(local_bb2_xor36_i) >>> 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb2_and37_lobit_i_stall_local;
wire [31:0] local_bb2_and37_lobit_i;

assign local_bb2_and37_lobit_i = (local_bb2_xor36_i >> 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_i22_stall_local;
wire local_bb2_lnot_i22;

assign local_bb2_lnot_i22 = (local_bb2_and17_i17 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp25_i24_stall_local;
wire local_bb2_cmp25_i24;

assign local_bb2_cmp25_i24 = (local_bb2_and17_i17 == 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp97_i_stall_local;
wire local_bb2_cmp97_i;

assign local_bb2_cmp97_i = (local_bb2_and96_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp117_i_stall_local;
wire local_bb2_cmp117_i;

assign local_bb2_cmp117_i = (local_bb2_and116_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp132_not_i_stall_local;
wire local_bb2_cmp132_not_i;

assign local_bb2_cmp132_not_i = (local_bb2_and131_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_Pivot20_i54_stall_local;
wire local_bb2_Pivot20_i54;

assign local_bb2_Pivot20_i54 = (local_bb2_and150_i < 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb2_SwitchLeaf_i55_stall_local;
wire local_bb2_SwitchLeaf_i55;

assign local_bb2_SwitchLeaf_i55 = (local_bb2_and150_i == 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge_not_i31_stall_local;
wire local_bb2_brmerge_not_i31;

assign local_bb2_brmerge_not_i31 = (rnode_23to24_bb2_cmp27_i25_0_NO_SHIFT_REG & local_bb2_lnot33_not_i30);

// This section implements an unregistered operation.
// 
wire local_bb2_shl66_i_stall_local;
wire [31:0] local_bb2_shl66_i;

assign local_bb2_shl66_i = (local_bb2_or65_i | 32'h4000000);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot30_not_i32_stall_local;
wire local_bb2_lnot30_not_i32;

assign local_bb2_lnot30_not_i32 = (local_bb2_lnot30_i28 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_shl_i41_stall_local;
wire [31:0] local_bb2_shl_i41;

assign local_bb2_shl_i41 = (local_bb2_or_i40 | 32'h4000000);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_25to26_bb2_and35_i26_0_valid_out_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and35_i26_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_25to26_bb2_and35_i26_0_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and35_i26_0_reg_26_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_25to26_bb2_and35_i26_0_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and35_i26_0_valid_out_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and35_i26_0_stall_in_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and35_i26_0_stall_out_reg_26_NO_SHIFT_REG;

acl_data_fifo rnode_25to26_bb2_and35_i26_0_reg_26_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_25to26_bb2_and35_i26_0_reg_26_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_25to26_bb2_and35_i26_0_stall_in_reg_26_NO_SHIFT_REG),
	.valid_out(rnode_25to26_bb2_and35_i26_0_valid_out_reg_26_NO_SHIFT_REG),
	.stall_out(rnode_25to26_bb2_and35_i26_0_stall_out_reg_26_NO_SHIFT_REG),
	.data_in(rnode_24to25_bb2_and35_i26_0_NO_SHIFT_REG),
	.data_out(rnode_25to26_bb2_and35_i26_0_reg_26_NO_SHIFT_REG)
);

defparam rnode_25to26_bb2_and35_i26_0_reg_26_fifo.DEPTH = 1;
defparam rnode_25to26_bb2_and35_i26_0_reg_26_fifo.DATA_WIDTH = 32;
defparam rnode_25to26_bb2_and35_i26_0_reg_26_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_25to26_bb2_and35_i26_0_reg_26_fifo.IMPL = "shift_reg";

assign rnode_25to26_bb2_and35_i26_0_reg_26_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_24to25_bb2_and35_i26_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2_and35_i26_0_NO_SHIFT_REG = rnode_25to26_bb2_and35_i26_0_reg_26_NO_SHIFT_REG;
assign rnode_25to26_bb2_and35_i26_0_stall_in_reg_26_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2_and35_i26_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_cmp25_not_i27_stall_local;
wire local_bb2_cmp25_not_i27;

assign local_bb2_cmp25_not_i27 = (local_bb2_cmp25_i24 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u40_stall_local;
wire local_bb2_var__u40;

assign local_bb2_var__u40 = (local_bb2_cmp25_i24 | rnode_23to24_bb2_cmp27_i25_2_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge_not_not_i35_stall_local;
wire local_bb2_brmerge_not_not_i35;

assign local_bb2_brmerge_not_not_i35 = (local_bb2_brmerge_not_i31 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2__28_i43_stall_local;
wire [31:0] local_bb2__28_i43;

assign local_bb2__28_i43 = (rnode_23to24_bb2_lnot23_i23_0_NO_SHIFT_REG ? 32'h0 : local_bb2_shl66_i);

// This section implements an unregistered operation.
// 
wire local_bb2_or_cond_not_i33_stall_local;
wire local_bb2_or_cond_not_i33;

assign local_bb2_or_cond_not_i33 = (local_bb2_cmp25_i24 & local_bb2_lnot30_not_i32);

// This section implements an unregistered operation.
// 
wire local_bb2__27_i42_stall_local;
wire [31:0] local_bb2__27_i42;

assign local_bb2__27_i42 = (local_bb2_lnot_i22 ? 32'h0 : local_bb2_shl_i41);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_26to27_bb2_and35_i26_0_valid_out_NO_SHIFT_REG;
 logic rnode_26to27_bb2_and35_i26_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_26to27_bb2_and35_i26_0_NO_SHIFT_REG;
 logic rnode_26to27_bb2_and35_i26_0_reg_27_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_26to27_bb2_and35_i26_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_and35_i26_0_valid_out_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_and35_i26_0_stall_in_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_and35_i26_0_stall_out_reg_27_NO_SHIFT_REG;

acl_data_fifo rnode_26to27_bb2_and35_i26_0_reg_27_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_26to27_bb2_and35_i26_0_reg_27_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_26to27_bb2_and35_i26_0_stall_in_reg_27_NO_SHIFT_REG),
	.valid_out(rnode_26to27_bb2_and35_i26_0_valid_out_reg_27_NO_SHIFT_REG),
	.stall_out(rnode_26to27_bb2_and35_i26_0_stall_out_reg_27_NO_SHIFT_REG),
	.data_in(rnode_25to26_bb2_and35_i26_0_NO_SHIFT_REG),
	.data_out(rnode_26to27_bb2_and35_i26_0_reg_27_NO_SHIFT_REG)
);

defparam rnode_26to27_bb2_and35_i26_0_reg_27_fifo.DEPTH = 1;
defparam rnode_26to27_bb2_and35_i26_0_reg_27_fifo.DATA_WIDTH = 32;
defparam rnode_26to27_bb2_and35_i26_0_reg_27_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_26to27_bb2_and35_i26_0_reg_27_fifo.IMPL = "shift_reg";

assign rnode_26to27_bb2_and35_i26_0_reg_27_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_25to26_bb2_and35_i26_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_and35_i26_0_NO_SHIFT_REG = rnode_26to27_bb2_and35_i26_0_reg_27_NO_SHIFT_REG;
assign rnode_26to27_bb2_and35_i26_0_stall_in_reg_27_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_and35_i26_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_or_cond_i29_stall_local;
wire local_bb2_or_cond_i29;

assign local_bb2_or_cond_i29 = (local_bb2_lnot30_i28 | local_bb2_cmp25_not_i27);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_7_i36_stall_local;
wire local_bb2_reduction_7_i36;

assign local_bb2_reduction_7_i36 = (local_bb2_cmp25_i24 & local_bb2_brmerge_not_not_i35);

// This section implements an unregistered operation.
// 
wire local_bb2_and73_i_stall_local;
wire [31:0] local_bb2_and73_i;

assign local_bb2_and73_i = (local_bb2__28_i43 >> 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb2_and76_i_stall_local;
wire [31:0] local_bb2_and76_i;

assign local_bb2_and76_i = (local_bb2__28_i43 & 32'hF0);

// This section implements an unregistered operation.
// 
wire local_bb2_and79_i_stall_local;
wire [31:0] local_bb2_and79_i;

assign local_bb2_and79_i = (local_bb2__28_i43 & 32'hF00);

// This section implements an unregistered operation.
// 
wire local_bb2_shr95_i_stall_local;
wire [31:0] local_bb2_shr95_i;

assign local_bb2_shr95_i = (local_bb2__28_i43 >> local_bb2_and94_i);

// This section implements an unregistered operation.
// 
wire local_bb2_and91_i_stall_local;
wire [31:0] local_bb2_and91_i;

assign local_bb2_and91_i = (local_bb2__28_i43 & 32'h7000000);

// This section implements an unregistered operation.
// 
wire local_bb2_and88_i_stall_local;
wire [31:0] local_bb2_and88_i;

assign local_bb2_and88_i = (local_bb2__28_i43 & 32'hF00000);

// This section implements an unregistered operation.
// 
wire local_bb2_and85_i_stall_local;
wire [31:0] local_bb2_and85_i;

assign local_bb2_and85_i = (local_bb2__28_i43 & 32'hF0000);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u41_stall_local;
wire [31:0] local_bb2_var__u41;

assign local_bb2_var__u41 = (local_bb2__28_i43 & 32'hFFF8);

// This section implements an unregistered operation.
// 
wire local_bb2__24_i34_stall_local;
wire local_bb2__24_i34;

assign local_bb2__24_i34 = (local_bb2_or_cond_not_i33 | local_bb2_brmerge_not_i31);

// This section implements an unregistered operation.
// 
wire local_bb2_add_i62_stall_local;
wire [31:0] local_bb2_add_i62;

assign local_bb2_add_i62 = (local_bb2__27_i42 | local_bb2_and37_lobit_i);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_8_i37_stall_local;
wire local_bb2_reduction_8_i37;

assign local_bb2_reduction_8_i37 = (rnode_23to24_bb2_cmp27_i25_1_NO_SHIFT_REG & local_bb2_or_cond_i29);

// This section implements an unregistered operation.
// 
wire local_bb2_and73_tr_i_stall_local;
wire [7:0] local_bb2_and73_tr_i;

assign local_bb2_and73_tr_i = local_bb2_and73_i[7:0];

// This section implements an unregistered operation.
// 
wire local_bb2_cmp77_i_stall_local;
wire local_bb2_cmp77_i;

assign local_bb2_cmp77_i = (local_bb2_and76_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp80_i_stall_local;
wire local_bb2_cmp80_i;

assign local_bb2_cmp80_i = (local_bb2_and79_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_and143_i_stall_local;
wire [31:0] local_bb2_and143_i;

assign local_bb2_and143_i = (local_bb2_shr95_i >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_shr151_i_stall_local;
wire [31:0] local_bb2_shr151_i;

assign local_bb2_shr151_i = (local_bb2_shr95_i >> local_bb2_and150_i);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u42_stall_local;
wire [31:0] local_bb2_var__u42;

assign local_bb2_var__u42 = (local_bb2_shr95_i & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_and147_i_stall_local;
wire [31:0] local_bb2_and147_i;

assign local_bb2_and147_i = (local_bb2_shr95_i >> 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp92_i_stall_local;
wire local_bb2_cmp92_i;

assign local_bb2_cmp92_i = (local_bb2_and91_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp89_i_stall_local;
wire local_bb2_cmp89_i;

assign local_bb2_cmp89_i = (local_bb2_and88_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp86_i_stall_local;
wire local_bb2_cmp86_i;

assign local_bb2_cmp86_i = (local_bb2_and85_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u43_stall_local;
wire local_bb2_var__u43;

assign local_bb2_var__u43 = (local_bb2_var__u41 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_9_i38_stall_local;
wire local_bb2_reduction_9_i38;

assign local_bb2_reduction_9_i38 = (local_bb2_reduction_7_i36 & local_bb2_reduction_8_i37);

// This section implements an unregistered operation.
// 
wire local_bb2_frombool75_i_stall_local;
wire [7:0] local_bb2_frombool75_i;

assign local_bb2_frombool75_i = (local_bb2_and73_tr_i & 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u44_stall_local;
wire [31:0] local_bb2_var__u44;

assign local_bb2_var__u44 = (local_bb2_and147_i | local_bb2_shr95_i);

// This section implements an unregistered operation.
// 
wire local_bb2__31_v_i49_stall_local;
wire local_bb2__31_v_i49;

assign local_bb2__31_v_i49 = (local_bb2_cmp97_i ? local_bb2_cmp80_i : local_bb2_cmp92_i);

// This section implements an unregistered operation.
// 
wire local_bb2__30_v_i47_stall_local;
wire local_bb2__30_v_i47;

assign local_bb2__30_v_i47 = (local_bb2_cmp97_i ? local_bb2_cmp77_i : local_bb2_cmp89_i);

// This section implements an unregistered operation.
// 
wire local_bb2_frombool110_i_stall_local;
wire [7:0] local_bb2_frombool110_i;

assign local_bb2_frombool110_i[7:1] = 7'h0;
assign local_bb2_frombool110_i[0] = local_bb2_cmp86_i;

// This section implements an unregistered operation.
// 
wire local_bb2_or108_i_stall_local;
wire [31:0] local_bb2_or108_i;

assign local_bb2_or108_i[31:1] = 31'h0;
assign local_bb2_or108_i[0] = local_bb2_var__u43;

// This section implements an unregistered operation.
// 
wire local_bb2__26_i39_stall_local;
wire local_bb2__26_i39;

assign local_bb2__26_i39 = (local_bb2_reduction_9_i38 ? local_bb2_cmp38_i : local_bb2__24_i34);

// This section implements an unregistered operation.
// 
wire local_bb2_or1606_i_stall_local;
wire [31:0] local_bb2_or1606_i;

assign local_bb2_or1606_i = (local_bb2_var__u44 | local_bb2_and143_i);

// This section implements an unregistered operation.
// 
wire local_bb2__31_i50_stall_local;
wire [7:0] local_bb2__31_i50;

assign local_bb2__31_i50[7:1] = 7'h0;
assign local_bb2__31_i50[0] = local_bb2__31_v_i49;

// This section implements an unregistered operation.
// 
wire local_bb2__30_i48_stall_local;
wire [7:0] local_bb2__30_i48;

assign local_bb2__30_i48[7:1] = 7'h0;
assign local_bb2__30_i48[0] = local_bb2__30_v_i47;

// This section implements an unregistered operation.
// 
wire local_bb2__29_i46_stall_local;
wire [7:0] local_bb2__29_i46;

assign local_bb2__29_i46 = (local_bb2_cmp97_i ? local_bb2_frombool75_i : local_bb2_frombool110_i);

// This section implements an unregistered operation.
// 
wire local_bb2__32_i51_stall_local;
wire [31:0] local_bb2__32_i51;

assign local_bb2__32_i51 = (local_bb2_cmp97_i ? 32'h0 : local_bb2_or108_i);

// This section implements an unregistered operation.
// 
wire local_bb2_or163_i_stall_local;
wire [31:0] local_bb2_or163_i;

assign local_bb2_or163_i = (local_bb2_or1606_i & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_or1247_i_stall_local;
wire [7:0] local_bb2_or1247_i;

assign local_bb2_or1247_i = (local_bb2__30_i48 | local_bb2__29_i46);

// This section implements an unregistered operation.
// 
wire local_bb2__33_i53_stall_local;
wire [7:0] local_bb2__33_i53;

assign local_bb2__33_i53 = (local_bb2_cmp117_i ? local_bb2__29_i46 : local_bb2__31_i50);

// This section implements an unregistered operation.
// 
wire local_bb2__37_v_i56_stall_local;
wire [31:0] local_bb2__37_v_i56;

assign local_bb2__37_v_i56 = (local_bb2_Pivot20_i54 ? 32'h0 : local_bb2_or163_i);

// This section implements an unregistered operation.
// 
wire local_bb2_or124_i52_stall_local;
wire [31:0] local_bb2_or124_i52;

assign local_bb2_or124_i52[31:8] = 24'h0;
assign local_bb2_or124_i52[7:0] = local_bb2_or1247_i;

// This section implements an unregistered operation.
// 
wire local_bb2_var__u45_stall_local;
wire [7:0] local_bb2_var__u45;

assign local_bb2_var__u45 = (local_bb2__33_i53 & 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb2__39_v_i57_stall_local;
wire [31:0] local_bb2__39_v_i57;

assign local_bb2__39_v_i57 = (local_bb2_SwitchLeaf_i55 ? local_bb2_var__u42 : local_bb2__37_v_i56);

// This section implements an unregistered operation.
// 
wire local_bb2_or125_i_stall_local;
wire [31:0] local_bb2_or125_i;

assign local_bb2_or125_i = (local_bb2_cmp117_i ? 32'h0 : local_bb2_or124_i52);

// This section implements an unregistered operation.
// 
wire local_bb2_conv136_i_stall_local;
wire [31:0] local_bb2_conv136_i;

assign local_bb2_conv136_i[31:8] = 24'h0;
assign local_bb2_conv136_i[7:0] = local_bb2_var__u45;

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_3_i58_stall_local;
wire [31:0] local_bb2_reduction_3_i58;

assign local_bb2_reduction_3_i58 = (local_bb2__32_i51 | local_bb2_or125_i);

// This section implements an unregistered operation.
// 
wire local_bb2_or137_i_stall_local;
wire [31:0] local_bb2_or137_i;

assign local_bb2_or137_i = (local_bb2_cmp132_not_i ? local_bb2_conv136_i : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_5_i60_stall_local;
wire [31:0] local_bb2_reduction_5_i60;

assign local_bb2_reduction_5_i60 = (local_bb2_shr151_i | local_bb2_reduction_3_i58);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_4_i59_stall_local;
wire [31:0] local_bb2_reduction_4_i59;

assign local_bb2_reduction_4_i59 = (local_bb2_or137_i | local_bb2__39_v_i57);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_6_i61_stall_local;
wire [31:0] local_bb2_reduction_6_i61;

assign local_bb2_reduction_6_i61 = (local_bb2_reduction_4_i59 | local_bb2_reduction_5_i60);

// This section implements an unregistered operation.
// 
wire local_bb2_xor189_i_stall_local;
wire [31:0] local_bb2_xor189_i;

assign local_bb2_xor189_i = (local_bb2_reduction_6_i61 ^ local_bb2_xor36_lobit_i);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp38_i_valid_out_1;
wire local_bb2_cmp38_i_stall_in_1;
 reg local_bb2_cmp38_i_consumed_1_NO_SHIFT_REG;
wire local_bb2__26_i39_valid_out;
wire local_bb2__26_i39_stall_in;
 reg local_bb2__26_i39_consumed_0_NO_SHIFT_REG;
wire local_bb2_add193_i_valid_out;
wire local_bb2_add193_i_stall_in;
 reg local_bb2_add193_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_and17_i17_valid_out_2;
wire local_bb2_and17_i17_stall_in_2;
 reg local_bb2_and17_i17_consumed_2_NO_SHIFT_REG;
wire local_bb2_var__u40_valid_out;
wire local_bb2_var__u40_stall_in;
 reg local_bb2_var__u40_consumed_0_NO_SHIFT_REG;
wire local_bb2_add193_i_inputs_ready;
wire local_bb2_add193_i_stall_local;
wire [31:0] local_bb2_add193_i;

assign local_bb2_add193_i_inputs_ready = (rnode_23to24_bb2__22_i14_0_valid_out_0_NO_SHIFT_REG & rnode_23to24_bb2_cmp27_i25_0_valid_out_0_NO_SHIFT_REG & rnode_23to24_bb2_lnot23_i23_0_valid_out_NO_SHIFT_REG & rnode_23to24_bb2__23_i15_0_valid_out_2_NO_SHIFT_REG & rnode_23to24_bb2__22_i14_0_valid_out_1_NO_SHIFT_REG & rnode_23to24_bb2__23_i15_0_valid_out_0_NO_SHIFT_REG & rnode_23to24_bb2_cmp27_i25_0_valid_out_1_NO_SHIFT_REG & rnode_23to24_bb2_shr16_i16_0_valid_out_0_NO_SHIFT_REG & rnode_23to24_bb2_cmp27_i25_0_valid_out_2_NO_SHIFT_REG & rnode_23to24_bb2_align_0_i45_0_valid_out_0_NO_SHIFT_REG & rnode_23to24_bb2_align_0_i45_0_valid_out_4_NO_SHIFT_REG & rnode_23to24_bb2_align_0_i45_0_valid_out_1_NO_SHIFT_REG & rnode_23to24_bb2_align_0_i45_0_valid_out_2_NO_SHIFT_REG & rnode_23to24_bb2_align_0_i45_0_valid_out_3_NO_SHIFT_REG);
assign local_bb2_add193_i = (local_bb2_add_i62 + local_bb2_xor189_i);
assign local_bb2_cmp38_i_valid_out_1 = 1'b1;
assign local_bb2__26_i39_valid_out = 1'b1;
assign local_bb2_add193_i_valid_out = 1'b1;
assign local_bb2_and17_i17_valid_out_2 = 1'b1;
assign local_bb2_var__u40_valid_out = 1'b1;
assign rnode_23to24_bb2__22_i14_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2_cmp27_i25_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2_lnot23_i23_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2__23_i15_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2__22_i14_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2__23_i15_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2_cmp27_i25_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2_shr16_i16_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2_cmp27_i25_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2_align_0_i45_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2_align_0_i45_0_stall_in_4_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2_align_0_i45_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2_align_0_i45_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_23to24_bb2_align_0_i45_0_stall_in_3_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_cmp38_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb2__26_i39_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_add193_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_and17_i17_consumed_2_NO_SHIFT_REG <= 1'b0;
		local_bb2_var__u40_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_cmp38_i_consumed_1_NO_SHIFT_REG <= (local_bb2_add193_i_inputs_ready & (local_bb2_cmp38_i_consumed_1_NO_SHIFT_REG | ~(local_bb2_cmp38_i_stall_in_1)) & local_bb2_add193_i_stall_local);
		local_bb2__26_i39_consumed_0_NO_SHIFT_REG <= (local_bb2_add193_i_inputs_ready & (local_bb2__26_i39_consumed_0_NO_SHIFT_REG | ~(local_bb2__26_i39_stall_in)) & local_bb2_add193_i_stall_local);
		local_bb2_add193_i_consumed_0_NO_SHIFT_REG <= (local_bb2_add193_i_inputs_ready & (local_bb2_add193_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_add193_i_stall_in)) & local_bb2_add193_i_stall_local);
		local_bb2_and17_i17_consumed_2_NO_SHIFT_REG <= (local_bb2_add193_i_inputs_ready & (local_bb2_and17_i17_consumed_2_NO_SHIFT_REG | ~(local_bb2_and17_i17_stall_in_2)) & local_bb2_add193_i_stall_local);
		local_bb2_var__u40_consumed_0_NO_SHIFT_REG <= (local_bb2_add193_i_inputs_ready & (local_bb2_var__u40_consumed_0_NO_SHIFT_REG | ~(local_bb2_var__u40_stall_in)) & local_bb2_add193_i_stall_local);
	end
end


// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_24to26_bb2_cmp38_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_24to26_bb2_cmp38_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_24to26_bb2_cmp38_i_0_NO_SHIFT_REG;
 logic rnode_24to26_bb2_cmp38_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_24to26_bb2_cmp38_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_24to26_bb2_cmp38_i_1_NO_SHIFT_REG;
 logic rnode_24to26_bb2_cmp38_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_24to26_bb2_cmp38_i_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_24to26_bb2_cmp38_i_2_NO_SHIFT_REG;
 logic rnode_24to26_bb2_cmp38_i_0_reg_26_inputs_ready_NO_SHIFT_REG;
 logic rnode_24to26_bb2_cmp38_i_0_reg_26_NO_SHIFT_REG;
 logic rnode_24to26_bb2_cmp38_i_0_valid_out_0_reg_26_NO_SHIFT_REG;
 logic rnode_24to26_bb2_cmp38_i_0_stall_in_0_reg_26_NO_SHIFT_REG;
 logic rnode_24to26_bb2_cmp38_i_0_stall_out_reg_26_NO_SHIFT_REG;

acl_data_fifo rnode_24to26_bb2_cmp38_i_0_reg_26_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_24to26_bb2_cmp38_i_0_reg_26_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_24to26_bb2_cmp38_i_0_stall_in_0_reg_26_NO_SHIFT_REG),
	.valid_out(rnode_24to26_bb2_cmp38_i_0_valid_out_0_reg_26_NO_SHIFT_REG),
	.stall_out(rnode_24to26_bb2_cmp38_i_0_stall_out_reg_26_NO_SHIFT_REG),
	.data_in(local_bb2_cmp38_i),
	.data_out(rnode_24to26_bb2_cmp38_i_0_reg_26_NO_SHIFT_REG)
);

defparam rnode_24to26_bb2_cmp38_i_0_reg_26_fifo.DEPTH = 2;
defparam rnode_24to26_bb2_cmp38_i_0_reg_26_fifo.DATA_WIDTH = 1;
defparam rnode_24to26_bb2_cmp38_i_0_reg_26_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_24to26_bb2_cmp38_i_0_reg_26_fifo.IMPL = "shift_reg";

assign rnode_24to26_bb2_cmp38_i_0_reg_26_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp38_i_stall_in_1 = 1'b0;
assign rnode_24to26_bb2_cmp38_i_0_stall_in_0_reg_26_NO_SHIFT_REG = 1'b0;
assign rnode_24to26_bb2_cmp38_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_24to26_bb2_cmp38_i_0_NO_SHIFT_REG = rnode_24to26_bb2_cmp38_i_0_reg_26_NO_SHIFT_REG;
assign rnode_24to26_bb2_cmp38_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_24to26_bb2_cmp38_i_1_NO_SHIFT_REG = rnode_24to26_bb2_cmp38_i_0_reg_26_NO_SHIFT_REG;
assign rnode_24to26_bb2_cmp38_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_24to26_bb2_cmp38_i_2_NO_SHIFT_REG = rnode_24to26_bb2_cmp38_i_0_reg_26_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_24to25_bb2__26_i39_0_valid_out_NO_SHIFT_REG;
 logic rnode_24to25_bb2__26_i39_0_stall_in_NO_SHIFT_REG;
 logic rnode_24to25_bb2__26_i39_0_NO_SHIFT_REG;
 logic rnode_24to25_bb2__26_i39_0_reg_25_inputs_ready_NO_SHIFT_REG;
 logic rnode_24to25_bb2__26_i39_0_reg_25_NO_SHIFT_REG;
 logic rnode_24to25_bb2__26_i39_0_valid_out_reg_25_NO_SHIFT_REG;
 logic rnode_24to25_bb2__26_i39_0_stall_in_reg_25_NO_SHIFT_REG;
 logic rnode_24to25_bb2__26_i39_0_stall_out_reg_25_NO_SHIFT_REG;

acl_data_fifo rnode_24to25_bb2__26_i39_0_reg_25_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_24to25_bb2__26_i39_0_reg_25_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_24to25_bb2__26_i39_0_stall_in_reg_25_NO_SHIFT_REG),
	.valid_out(rnode_24to25_bb2__26_i39_0_valid_out_reg_25_NO_SHIFT_REG),
	.stall_out(rnode_24to25_bb2__26_i39_0_stall_out_reg_25_NO_SHIFT_REG),
	.data_in(local_bb2__26_i39),
	.data_out(rnode_24to25_bb2__26_i39_0_reg_25_NO_SHIFT_REG)
);

defparam rnode_24to25_bb2__26_i39_0_reg_25_fifo.DEPTH = 1;
defparam rnode_24to25_bb2__26_i39_0_reg_25_fifo.DATA_WIDTH = 1;
defparam rnode_24to25_bb2__26_i39_0_reg_25_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_24to25_bb2__26_i39_0_reg_25_fifo.IMPL = "shift_reg";

assign rnode_24to25_bb2__26_i39_0_reg_25_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__26_i39_stall_in = 1'b0;
assign rnode_24to25_bb2__26_i39_0_NO_SHIFT_REG = rnode_24to25_bb2__26_i39_0_reg_25_NO_SHIFT_REG;
assign rnode_24to25_bb2__26_i39_0_stall_in_reg_25_NO_SHIFT_REG = 1'b0;
assign rnode_24to25_bb2__26_i39_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_24to25_bb2_add193_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_24to25_bb2_add193_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_24to25_bb2_add193_i_0_NO_SHIFT_REG;
 logic rnode_24to25_bb2_add193_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_24to25_bb2_add193_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_24to25_bb2_add193_i_1_NO_SHIFT_REG;
 logic rnode_24to25_bb2_add193_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_24to25_bb2_add193_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_24to25_bb2_add193_i_2_NO_SHIFT_REG;
 logic rnode_24to25_bb2_add193_i_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_24to25_bb2_add193_i_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_24to25_bb2_add193_i_3_NO_SHIFT_REG;
 logic rnode_24to25_bb2_add193_i_0_reg_25_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_24to25_bb2_add193_i_0_reg_25_NO_SHIFT_REG;
 logic rnode_24to25_bb2_add193_i_0_valid_out_0_reg_25_NO_SHIFT_REG;
 logic rnode_24to25_bb2_add193_i_0_stall_in_0_reg_25_NO_SHIFT_REG;
 logic rnode_24to25_bb2_add193_i_0_stall_out_reg_25_NO_SHIFT_REG;

acl_data_fifo rnode_24to25_bb2_add193_i_0_reg_25_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_24to25_bb2_add193_i_0_reg_25_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_24to25_bb2_add193_i_0_stall_in_0_reg_25_NO_SHIFT_REG),
	.valid_out(rnode_24to25_bb2_add193_i_0_valid_out_0_reg_25_NO_SHIFT_REG),
	.stall_out(rnode_24to25_bb2_add193_i_0_stall_out_reg_25_NO_SHIFT_REG),
	.data_in(local_bb2_add193_i),
	.data_out(rnode_24to25_bb2_add193_i_0_reg_25_NO_SHIFT_REG)
);

defparam rnode_24to25_bb2_add193_i_0_reg_25_fifo.DEPTH = 1;
defparam rnode_24to25_bb2_add193_i_0_reg_25_fifo.DATA_WIDTH = 32;
defparam rnode_24to25_bb2_add193_i_0_reg_25_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_24to25_bb2_add193_i_0_reg_25_fifo.IMPL = "shift_reg";

assign rnode_24to25_bb2_add193_i_0_reg_25_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_add193_i_stall_in = 1'b0;
assign rnode_24to25_bb2_add193_i_0_stall_in_0_reg_25_NO_SHIFT_REG = 1'b0;
assign rnode_24to25_bb2_add193_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_24to25_bb2_add193_i_0_NO_SHIFT_REG = rnode_24to25_bb2_add193_i_0_reg_25_NO_SHIFT_REG;
assign rnode_24to25_bb2_add193_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_24to25_bb2_add193_i_1_NO_SHIFT_REG = rnode_24to25_bb2_add193_i_0_reg_25_NO_SHIFT_REG;
assign rnode_24to25_bb2_add193_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_24to25_bb2_add193_i_2_NO_SHIFT_REG = rnode_24to25_bb2_add193_i_0_reg_25_NO_SHIFT_REG;
assign rnode_24to25_bb2_add193_i_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_24to25_bb2_add193_i_3_NO_SHIFT_REG = rnode_24to25_bb2_add193_i_0_reg_25_NO_SHIFT_REG;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_24to26_bb2_and17_i17_0_valid_out_NO_SHIFT_REG;
 logic rnode_24to26_bb2_and17_i17_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_24to26_bb2_and17_i17_0_NO_SHIFT_REG;
 logic rnode_24to26_bb2_and17_i17_0_reg_26_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_24to26_bb2_and17_i17_0_reg_26_NO_SHIFT_REG;
 logic rnode_24to26_bb2_and17_i17_0_valid_out_reg_26_NO_SHIFT_REG;
 logic rnode_24to26_bb2_and17_i17_0_stall_in_reg_26_NO_SHIFT_REG;
 logic rnode_24to26_bb2_and17_i17_0_stall_out_reg_26_NO_SHIFT_REG;

acl_data_fifo rnode_24to26_bb2_and17_i17_0_reg_26_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_24to26_bb2_and17_i17_0_reg_26_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_24to26_bb2_and17_i17_0_stall_in_reg_26_NO_SHIFT_REG),
	.valid_out(rnode_24to26_bb2_and17_i17_0_valid_out_reg_26_NO_SHIFT_REG),
	.stall_out(rnode_24to26_bb2_and17_i17_0_stall_out_reg_26_NO_SHIFT_REG),
	.data_in(local_bb2_and17_i17),
	.data_out(rnode_24to26_bb2_and17_i17_0_reg_26_NO_SHIFT_REG)
);

defparam rnode_24to26_bb2_and17_i17_0_reg_26_fifo.DEPTH = 2;
defparam rnode_24to26_bb2_and17_i17_0_reg_26_fifo.DATA_WIDTH = 32;
defparam rnode_24to26_bb2_and17_i17_0_reg_26_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_24to26_bb2_and17_i17_0_reg_26_fifo.IMPL = "shift_reg";

assign rnode_24to26_bb2_and17_i17_0_reg_26_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and17_i17_stall_in_2 = 1'b0;
assign rnode_24to26_bb2_and17_i17_0_NO_SHIFT_REG = rnode_24to26_bb2_and17_i17_0_reg_26_NO_SHIFT_REG;
assign rnode_24to26_bb2_and17_i17_0_stall_in_reg_26_NO_SHIFT_REG = 1'b0;
assign rnode_24to26_bb2_and17_i17_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_24to25_bb2_var__u40_0_valid_out_NO_SHIFT_REG;
 logic rnode_24to25_bb2_var__u40_0_stall_in_NO_SHIFT_REG;
 logic rnode_24to25_bb2_var__u40_0_NO_SHIFT_REG;
 logic rnode_24to25_bb2_var__u40_0_reg_25_inputs_ready_NO_SHIFT_REG;
 logic rnode_24to25_bb2_var__u40_0_reg_25_NO_SHIFT_REG;
 logic rnode_24to25_bb2_var__u40_0_valid_out_reg_25_NO_SHIFT_REG;
 logic rnode_24to25_bb2_var__u40_0_stall_in_reg_25_NO_SHIFT_REG;
 logic rnode_24to25_bb2_var__u40_0_stall_out_reg_25_NO_SHIFT_REG;

acl_data_fifo rnode_24to25_bb2_var__u40_0_reg_25_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_24to25_bb2_var__u40_0_reg_25_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_24to25_bb2_var__u40_0_stall_in_reg_25_NO_SHIFT_REG),
	.valid_out(rnode_24to25_bb2_var__u40_0_valid_out_reg_25_NO_SHIFT_REG),
	.stall_out(rnode_24to25_bb2_var__u40_0_stall_out_reg_25_NO_SHIFT_REG),
	.data_in(local_bb2_var__u40),
	.data_out(rnode_24to25_bb2_var__u40_0_reg_25_NO_SHIFT_REG)
);

defparam rnode_24to25_bb2_var__u40_0_reg_25_fifo.DEPTH = 1;
defparam rnode_24to25_bb2_var__u40_0_reg_25_fifo.DATA_WIDTH = 1;
defparam rnode_24to25_bb2_var__u40_0_reg_25_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_24to25_bb2_var__u40_0_reg_25_fifo.IMPL = "shift_reg";

assign rnode_24to25_bb2_var__u40_0_reg_25_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_var__u40_stall_in = 1'b0;
assign rnode_24to25_bb2_var__u40_0_NO_SHIFT_REG = rnode_24to25_bb2_var__u40_0_reg_25_NO_SHIFT_REG;
assign rnode_24to25_bb2_var__u40_0_stall_in_reg_25_NO_SHIFT_REG = 1'b0;
assign rnode_24to25_bb2_var__u40_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_not_cmp38_i_stall_local;
wire local_bb2_not_cmp38_i;

assign local_bb2_not_cmp38_i = (rnode_24to26_bb2_cmp38_i_1_NO_SHIFT_REG ^ 1'b1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_25to26_bb2__26_i39_0_valid_out_NO_SHIFT_REG;
 logic rnode_25to26_bb2__26_i39_0_stall_in_NO_SHIFT_REG;
 logic rnode_25to26_bb2__26_i39_0_NO_SHIFT_REG;
 logic rnode_25to26_bb2__26_i39_0_reg_26_inputs_ready_NO_SHIFT_REG;
 logic rnode_25to26_bb2__26_i39_0_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2__26_i39_0_valid_out_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2__26_i39_0_stall_in_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2__26_i39_0_stall_out_reg_26_NO_SHIFT_REG;

acl_data_fifo rnode_25to26_bb2__26_i39_0_reg_26_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_25to26_bb2__26_i39_0_reg_26_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_25to26_bb2__26_i39_0_stall_in_reg_26_NO_SHIFT_REG),
	.valid_out(rnode_25to26_bb2__26_i39_0_valid_out_reg_26_NO_SHIFT_REG),
	.stall_out(rnode_25to26_bb2__26_i39_0_stall_out_reg_26_NO_SHIFT_REG),
	.data_in(rnode_24to25_bb2__26_i39_0_NO_SHIFT_REG),
	.data_out(rnode_25to26_bb2__26_i39_0_reg_26_NO_SHIFT_REG)
);

defparam rnode_25to26_bb2__26_i39_0_reg_26_fifo.DEPTH = 1;
defparam rnode_25to26_bb2__26_i39_0_reg_26_fifo.DATA_WIDTH = 1;
defparam rnode_25to26_bb2__26_i39_0_reg_26_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_25to26_bb2__26_i39_0_reg_26_fifo.IMPL = "shift_reg";

assign rnode_25to26_bb2__26_i39_0_reg_26_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_24to25_bb2__26_i39_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2__26_i39_0_NO_SHIFT_REG = rnode_25to26_bb2__26_i39_0_reg_26_NO_SHIFT_REG;
assign rnode_25to26_bb2__26_i39_0_stall_in_reg_26_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2__26_i39_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_and194_i_valid_out;
wire local_bb2_and194_i_stall_in;
wire local_bb2_and194_i_inputs_ready;
wire local_bb2_and194_i_stall_local;
wire [31:0] local_bb2_and194_i;

assign local_bb2_and194_i_inputs_ready = rnode_24to25_bb2_add193_i_0_valid_out_0_NO_SHIFT_REG;
assign local_bb2_and194_i = (rnode_24to25_bb2_add193_i_0_NO_SHIFT_REG & 32'hFFFFFFF);
assign local_bb2_and194_i_valid_out = 1'b1;
assign rnode_24to25_bb2_add193_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_and196_i_valid_out;
wire local_bb2_and196_i_stall_in;
wire local_bb2_and196_i_inputs_ready;
wire local_bb2_and196_i_stall_local;
wire [31:0] local_bb2_and196_i;

assign local_bb2_and196_i_inputs_ready = rnode_24to25_bb2_add193_i_0_valid_out_1_NO_SHIFT_REG;
assign local_bb2_and196_i = (rnode_24to25_bb2_add193_i_1_NO_SHIFT_REG >> 32'h1B);
assign local_bb2_and196_i_valid_out = 1'b1;
assign rnode_24to25_bb2_add193_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_and199_i_valid_out;
wire local_bb2_and199_i_stall_in;
wire local_bb2_and199_i_inputs_ready;
wire local_bb2_and199_i_stall_local;
wire [31:0] local_bb2_and199_i;

assign local_bb2_and199_i_inputs_ready = rnode_24to25_bb2_add193_i_0_valid_out_2_NO_SHIFT_REG;
assign local_bb2_and199_i = (rnode_24to25_bb2_add193_i_2_NO_SHIFT_REG & 32'h1);
assign local_bb2_and199_i_valid_out = 1'b1;
assign rnode_24to25_bb2_add193_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_and202_i_stall_local;
wire [31:0] local_bb2_and202_i;

assign local_bb2_and202_i = (rnode_24to25_bb2_add193_i_3_NO_SHIFT_REG & 32'h7FFFFFF);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_25to26_bb2_var__u40_0_valid_out_NO_SHIFT_REG;
 logic rnode_25to26_bb2_var__u40_0_stall_in_NO_SHIFT_REG;
 logic rnode_25to26_bb2_var__u40_0_NO_SHIFT_REG;
 logic rnode_25to26_bb2_var__u40_0_reg_26_inputs_ready_NO_SHIFT_REG;
 logic rnode_25to26_bb2_var__u40_0_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2_var__u40_0_valid_out_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2_var__u40_0_stall_in_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2_var__u40_0_stall_out_reg_26_NO_SHIFT_REG;

acl_data_fifo rnode_25to26_bb2_var__u40_0_reg_26_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_25to26_bb2_var__u40_0_reg_26_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_25to26_bb2_var__u40_0_stall_in_reg_26_NO_SHIFT_REG),
	.valid_out(rnode_25to26_bb2_var__u40_0_valid_out_reg_26_NO_SHIFT_REG),
	.stall_out(rnode_25to26_bb2_var__u40_0_stall_out_reg_26_NO_SHIFT_REG),
	.data_in(rnode_24to25_bb2_var__u40_0_NO_SHIFT_REG),
	.data_out(rnode_25to26_bb2_var__u40_0_reg_26_NO_SHIFT_REG)
);

defparam rnode_25to26_bb2_var__u40_0_reg_26_fifo.DEPTH = 1;
defparam rnode_25to26_bb2_var__u40_0_reg_26_fifo.DATA_WIDTH = 1;
defparam rnode_25to26_bb2_var__u40_0_reg_26_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_25to26_bb2_var__u40_0_reg_26_fifo.IMPL = "shift_reg";

assign rnode_25to26_bb2_var__u40_0_reg_26_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_24to25_bb2_var__u40_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2_var__u40_0_NO_SHIFT_REG = rnode_25to26_bb2_var__u40_0_reg_26_NO_SHIFT_REG;
assign rnode_25to26_bb2_var__u40_0_stall_in_reg_26_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2_var__u40_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_26to27_bb2__26_i39_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_26to27_bb2__26_i39_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_26to27_bb2__26_i39_0_NO_SHIFT_REG;
 logic rnode_26to27_bb2__26_i39_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_26to27_bb2__26_i39_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_26to27_bb2__26_i39_1_NO_SHIFT_REG;
 logic rnode_26to27_bb2__26_i39_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_26to27_bb2__26_i39_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_26to27_bb2__26_i39_2_NO_SHIFT_REG;
 logic rnode_26to27_bb2__26_i39_0_reg_27_inputs_ready_NO_SHIFT_REG;
 logic rnode_26to27_bb2__26_i39_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2__26_i39_0_valid_out_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2__26_i39_0_stall_in_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2__26_i39_0_stall_out_reg_27_NO_SHIFT_REG;

acl_data_fifo rnode_26to27_bb2__26_i39_0_reg_27_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_26to27_bb2__26_i39_0_reg_27_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_26to27_bb2__26_i39_0_stall_in_0_reg_27_NO_SHIFT_REG),
	.valid_out(rnode_26to27_bb2__26_i39_0_valid_out_0_reg_27_NO_SHIFT_REG),
	.stall_out(rnode_26to27_bb2__26_i39_0_stall_out_reg_27_NO_SHIFT_REG),
	.data_in(rnode_25to26_bb2__26_i39_0_NO_SHIFT_REG),
	.data_out(rnode_26to27_bb2__26_i39_0_reg_27_NO_SHIFT_REG)
);

defparam rnode_26to27_bb2__26_i39_0_reg_27_fifo.DEPTH = 1;
defparam rnode_26to27_bb2__26_i39_0_reg_27_fifo.DATA_WIDTH = 1;
defparam rnode_26to27_bb2__26_i39_0_reg_27_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_26to27_bb2__26_i39_0_reg_27_fifo.IMPL = "shift_reg";

assign rnode_26to27_bb2__26_i39_0_reg_27_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_25to26_bb2__26_i39_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2__26_i39_0_stall_in_0_reg_27_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2__26_i39_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_26to27_bb2__26_i39_0_NO_SHIFT_REG = rnode_26to27_bb2__26_i39_0_reg_27_NO_SHIFT_REG;
assign rnode_26to27_bb2__26_i39_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_26to27_bb2__26_i39_1_NO_SHIFT_REG = rnode_26to27_bb2__26_i39_0_reg_27_NO_SHIFT_REG;
assign rnode_26to27_bb2__26_i39_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_26to27_bb2__26_i39_2_NO_SHIFT_REG = rnode_26to27_bb2__26_i39_0_reg_27_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_25to26_bb2_and194_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and194_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_25to26_bb2_and194_i_0_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and194_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and194_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_25to26_bb2_and194_i_1_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and194_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and194_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_25to26_bb2_and194_i_2_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and194_i_0_reg_26_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_25to26_bb2_and194_i_0_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and194_i_0_valid_out_0_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and194_i_0_stall_in_0_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and194_i_0_stall_out_reg_26_NO_SHIFT_REG;

acl_data_fifo rnode_25to26_bb2_and194_i_0_reg_26_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_25to26_bb2_and194_i_0_reg_26_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_25to26_bb2_and194_i_0_stall_in_0_reg_26_NO_SHIFT_REG),
	.valid_out(rnode_25to26_bb2_and194_i_0_valid_out_0_reg_26_NO_SHIFT_REG),
	.stall_out(rnode_25to26_bb2_and194_i_0_stall_out_reg_26_NO_SHIFT_REG),
	.data_in(local_bb2_and194_i),
	.data_out(rnode_25to26_bb2_and194_i_0_reg_26_NO_SHIFT_REG)
);

defparam rnode_25to26_bb2_and194_i_0_reg_26_fifo.DEPTH = 1;
defparam rnode_25to26_bb2_and194_i_0_reg_26_fifo.DATA_WIDTH = 32;
defparam rnode_25to26_bb2_and194_i_0_reg_26_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_25to26_bb2_and194_i_0_reg_26_fifo.IMPL = "shift_reg";

assign rnode_25to26_bb2_and194_i_0_reg_26_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and194_i_stall_in = 1'b0;
assign rnode_25to26_bb2_and194_i_0_stall_in_0_reg_26_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2_and194_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_25to26_bb2_and194_i_0_NO_SHIFT_REG = rnode_25to26_bb2_and194_i_0_reg_26_NO_SHIFT_REG;
assign rnode_25to26_bb2_and194_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_25to26_bb2_and194_i_1_NO_SHIFT_REG = rnode_25to26_bb2_and194_i_0_reg_26_NO_SHIFT_REG;
assign rnode_25to26_bb2_and194_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_25to26_bb2_and194_i_2_NO_SHIFT_REG = rnode_25to26_bb2_and194_i_0_reg_26_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_25to26_bb2_and196_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and196_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_25to26_bb2_and196_i_0_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and196_i_0_reg_26_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_25to26_bb2_and196_i_0_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and196_i_0_valid_out_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and196_i_0_stall_in_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and196_i_0_stall_out_reg_26_NO_SHIFT_REG;

acl_data_fifo rnode_25to26_bb2_and196_i_0_reg_26_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_25to26_bb2_and196_i_0_reg_26_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_25to26_bb2_and196_i_0_stall_in_reg_26_NO_SHIFT_REG),
	.valid_out(rnode_25to26_bb2_and196_i_0_valid_out_reg_26_NO_SHIFT_REG),
	.stall_out(rnode_25to26_bb2_and196_i_0_stall_out_reg_26_NO_SHIFT_REG),
	.data_in(local_bb2_and196_i),
	.data_out(rnode_25to26_bb2_and196_i_0_reg_26_NO_SHIFT_REG)
);

defparam rnode_25to26_bb2_and196_i_0_reg_26_fifo.DEPTH = 1;
defparam rnode_25to26_bb2_and196_i_0_reg_26_fifo.DATA_WIDTH = 32;
defparam rnode_25to26_bb2_and196_i_0_reg_26_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_25to26_bb2_and196_i_0_reg_26_fifo.IMPL = "shift_reg";

assign rnode_25to26_bb2_and196_i_0_reg_26_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and196_i_stall_in = 1'b0;
assign rnode_25to26_bb2_and196_i_0_NO_SHIFT_REG = rnode_25to26_bb2_and196_i_0_reg_26_NO_SHIFT_REG;
assign rnode_25to26_bb2_and196_i_0_stall_in_reg_26_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2_and196_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_25to26_bb2_and199_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and199_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_25to26_bb2_and199_i_0_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and199_i_0_reg_26_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_25to26_bb2_and199_i_0_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and199_i_0_valid_out_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and199_i_0_stall_in_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2_and199_i_0_stall_out_reg_26_NO_SHIFT_REG;

acl_data_fifo rnode_25to26_bb2_and199_i_0_reg_26_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_25to26_bb2_and199_i_0_reg_26_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_25to26_bb2_and199_i_0_stall_in_reg_26_NO_SHIFT_REG),
	.valid_out(rnode_25to26_bb2_and199_i_0_valid_out_reg_26_NO_SHIFT_REG),
	.stall_out(rnode_25to26_bb2_and199_i_0_stall_out_reg_26_NO_SHIFT_REG),
	.data_in(local_bb2_and199_i),
	.data_out(rnode_25to26_bb2_and199_i_0_reg_26_NO_SHIFT_REG)
);

defparam rnode_25to26_bb2_and199_i_0_reg_26_fifo.DEPTH = 1;
defparam rnode_25to26_bb2_and199_i_0_reg_26_fifo.DATA_WIDTH = 32;
defparam rnode_25to26_bb2_and199_i_0_reg_26_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_25to26_bb2_and199_i_0_reg_26_fifo.IMPL = "shift_reg";

assign rnode_25to26_bb2_and199_i_0_reg_26_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and199_i_stall_in = 1'b0;
assign rnode_25to26_bb2_and199_i_0_NO_SHIFT_REG = rnode_25to26_bb2_and199_i_0_reg_26_NO_SHIFT_REG;
assign rnode_25to26_bb2_and199_i_0_stall_in_reg_26_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2_and199_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_shr_i_i63_stall_local;
wire [31:0] local_bb2_shr_i_i63;

assign local_bb2_shr_i_i63 = (local_bb2_and202_i >> 32'h1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_26to27_bb2_var__u40_0_valid_out_NO_SHIFT_REG;
 logic rnode_26to27_bb2_var__u40_0_stall_in_NO_SHIFT_REG;
 logic rnode_26to27_bb2_var__u40_0_NO_SHIFT_REG;
 logic rnode_26to27_bb2_var__u40_0_reg_27_inputs_ready_NO_SHIFT_REG;
 logic rnode_26to27_bb2_var__u40_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_var__u40_0_valid_out_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_var__u40_0_stall_in_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_var__u40_0_stall_out_reg_27_NO_SHIFT_REG;

acl_data_fifo rnode_26to27_bb2_var__u40_0_reg_27_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_26to27_bb2_var__u40_0_reg_27_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_26to27_bb2_var__u40_0_stall_in_reg_27_NO_SHIFT_REG),
	.valid_out(rnode_26to27_bb2_var__u40_0_valid_out_reg_27_NO_SHIFT_REG),
	.stall_out(rnode_26to27_bb2_var__u40_0_stall_out_reg_27_NO_SHIFT_REG),
	.data_in(rnode_25to26_bb2_var__u40_0_NO_SHIFT_REG),
	.data_out(rnode_26to27_bb2_var__u40_0_reg_27_NO_SHIFT_REG)
);

defparam rnode_26to27_bb2_var__u40_0_reg_27_fifo.DEPTH = 1;
defparam rnode_26to27_bb2_var__u40_0_reg_27_fifo.DATA_WIDTH = 1;
defparam rnode_26to27_bb2_var__u40_0_reg_27_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_26to27_bb2_var__u40_0_reg_27_fifo.IMPL = "shift_reg";

assign rnode_26to27_bb2_var__u40_0_reg_27_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_25to26_bb2_var__u40_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_var__u40_0_NO_SHIFT_REG = rnode_26to27_bb2_var__u40_0_reg_27_NO_SHIFT_REG;
assign rnode_26to27_bb2_var__u40_0_stall_in_reg_27_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_var__u40_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_cond293_i_stall_local;
wire [31:0] local_bb2_cond293_i;

assign local_bb2_cond293_i = (rnode_26to27_bb2__26_i39_1_NO_SHIFT_REG ? 32'h400000 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u46_stall_local;
wire [31:0] local_bb2_var__u46;

assign local_bb2_var__u46[31:1] = 31'h0;
assign local_bb2_var__u46[0] = rnode_26to27_bb2__26_i39_2_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_shr217_i_stall_local;
wire [31:0] local_bb2_shr217_i;

assign local_bb2_shr217_i = (rnode_25to26_bb2_and194_i_1_NO_SHIFT_REG >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2__pre_i77_stall_local;
wire [31:0] local_bb2__pre_i77;

assign local_bb2__pre_i77 = (rnode_25to26_bb2_and196_i_0_NO_SHIFT_REG & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_or_i_i64_stall_local;
wire [31:0] local_bb2_or_i_i64;

assign local_bb2_or_i_i64 = (local_bb2_shr_i_i63 | local_bb2_and202_i);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_ext_i94_stall_local;
wire [31:0] local_bb2_lnot_ext_i94;

assign local_bb2_lnot_ext_i94 = (local_bb2_var__u46 ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_or220_i_stall_local;
wire [31:0] local_bb2_or220_i;

assign local_bb2_or220_i = (local_bb2_shr217_i | rnode_25to26_bb2_and199_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_tobool214_i_stall_local;
wire local_bb2_tobool214_i;

assign local_bb2_tobool214_i = (local_bb2__pre_i77 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_shr1_i_i65_stall_local;
wire [31:0] local_bb2_shr1_i_i65;

assign local_bb2_shr1_i_i65 = (local_bb2_or_i_i64 >> 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb2__40_demorgan_i78_stall_local;
wire local_bb2__40_demorgan_i78;

assign local_bb2__40_demorgan_i78 = (rnode_24to26_bb2_cmp38_i_0_NO_SHIFT_REG | local_bb2_tobool214_i);

// This section implements an unregistered operation.
// 
wire local_bb2__42_i79_stall_local;
wire local_bb2__42_i79;

assign local_bb2__42_i79 = (local_bb2_tobool214_i & local_bb2_not_cmp38_i);

// This section implements an unregistered operation.
// 
wire local_bb2_or2_i_i66_stall_local;
wire [31:0] local_bb2_or2_i_i66;

assign local_bb2_or2_i_i66 = (local_bb2_shr1_i_i65 | local_bb2_or_i_i64);

// This section implements an unregistered operation.
// 
wire local_bb2__43_i80_stall_local;
wire [31:0] local_bb2__43_i80;

assign local_bb2__43_i80 = (local_bb2__42_i79 ? 32'h0 : local_bb2__pre_i77);

// This section implements an unregistered operation.
// 
wire local_bb2_shr3_i_i67_stall_local;
wire [31:0] local_bb2_shr3_i_i67;

assign local_bb2_shr3_i_i67 = (local_bb2_or2_i_i66 >> 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb2_or4_i_i68_stall_local;
wire [31:0] local_bb2_or4_i_i68;

assign local_bb2_or4_i_i68 = (local_bb2_shr3_i_i67 | local_bb2_or2_i_i66);

// This section implements an unregistered operation.
// 
wire local_bb2_shr5_i_i69_stall_local;
wire [31:0] local_bb2_shr5_i_i69;

assign local_bb2_shr5_i_i69 = (local_bb2_or4_i_i68 >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb2_or6_i_i70_stall_local;
wire [31:0] local_bb2_or6_i_i70;

assign local_bb2_or6_i_i70 = (local_bb2_shr5_i_i69 | local_bb2_or4_i_i68);

// This section implements an unregistered operation.
// 
wire local_bb2_shr7_i_i71_stall_local;
wire [31:0] local_bb2_shr7_i_i71;

assign local_bb2_shr7_i_i71 = (local_bb2_or6_i_i70 >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb2_or6_masked_i_i72_stall_local;
wire [31:0] local_bb2_or6_masked_i_i72;

assign local_bb2_or6_masked_i_i72 = (local_bb2_or6_i_i70 & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_neg_i_i73_stall_local;
wire [31:0] local_bb2_neg_i_i73;

assign local_bb2_neg_i_i73 = (local_bb2_or6_masked_i_i72 | local_bb2_shr7_i_i71);

// This section implements an unregistered operation.
// 
wire local_bb2_and_i_i74_stall_local;
wire [31:0] local_bb2_and_i_i74;

assign local_bb2_and_i_i74 = (local_bb2_neg_i_i73 ^ 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2__and_i_i74_valid_out;
wire local_bb2__and_i_i74_stall_in;
wire local_bb2__and_i_i74_inputs_ready;
wire local_bb2__and_i_i74_stall_local;
wire [31:0] local_bb2__and_i_i74;

thirtysix_six_comp local_bb2__and_i_i74_popcnt_instance (
	.data(local_bb2_and_i_i74),
	.sum(local_bb2__and_i_i74)
);


assign local_bb2__and_i_i74_inputs_ready = rnode_24to25_bb2_add193_i_0_valid_out_3_NO_SHIFT_REG;
assign local_bb2__and_i_i74_valid_out = 1'b1;
assign rnode_24to25_bb2_add193_i_0_stall_in_3_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_25to26_bb2__and_i_i74_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_25to26_bb2__and_i_i74_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_25to26_bb2__and_i_i74_0_NO_SHIFT_REG;
 logic rnode_25to26_bb2__and_i_i74_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_25to26_bb2__and_i_i74_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_25to26_bb2__and_i_i74_1_NO_SHIFT_REG;
 logic rnode_25to26_bb2__and_i_i74_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_25to26_bb2__and_i_i74_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_25to26_bb2__and_i_i74_2_NO_SHIFT_REG;
 logic rnode_25to26_bb2__and_i_i74_0_reg_26_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_25to26_bb2__and_i_i74_0_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2__and_i_i74_0_valid_out_0_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2__and_i_i74_0_stall_in_0_reg_26_NO_SHIFT_REG;
 logic rnode_25to26_bb2__and_i_i74_0_stall_out_reg_26_NO_SHIFT_REG;

acl_data_fifo rnode_25to26_bb2__and_i_i74_0_reg_26_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_25to26_bb2__and_i_i74_0_reg_26_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_25to26_bb2__and_i_i74_0_stall_in_0_reg_26_NO_SHIFT_REG),
	.valid_out(rnode_25to26_bb2__and_i_i74_0_valid_out_0_reg_26_NO_SHIFT_REG),
	.stall_out(rnode_25to26_bb2__and_i_i74_0_stall_out_reg_26_NO_SHIFT_REG),
	.data_in(local_bb2__and_i_i74),
	.data_out(rnode_25to26_bb2__and_i_i74_0_reg_26_NO_SHIFT_REG)
);

defparam rnode_25to26_bb2__and_i_i74_0_reg_26_fifo.DEPTH = 1;
defparam rnode_25to26_bb2__and_i_i74_0_reg_26_fifo.DATA_WIDTH = 32;
defparam rnode_25to26_bb2__and_i_i74_0_reg_26_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_25to26_bb2__and_i_i74_0_reg_26_fifo.IMPL = "shift_reg";

assign rnode_25to26_bb2__and_i_i74_0_reg_26_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__and_i_i74_stall_in = 1'b0;
assign rnode_25to26_bb2__and_i_i74_0_stall_in_0_reg_26_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2__and_i_i74_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_25to26_bb2__and_i_i74_0_NO_SHIFT_REG = rnode_25to26_bb2__and_i_i74_0_reg_26_NO_SHIFT_REG;
assign rnode_25to26_bb2__and_i_i74_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_25to26_bb2__and_i_i74_1_NO_SHIFT_REG = rnode_25to26_bb2__and_i_i74_0_reg_26_NO_SHIFT_REG;
assign rnode_25to26_bb2__and_i_i74_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_25to26_bb2__and_i_i74_2_NO_SHIFT_REG = rnode_25to26_bb2__and_i_i74_0_reg_26_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_and9_i_i75_stall_local;
wire [31:0] local_bb2_and9_i_i75;

assign local_bb2_and9_i_i75 = (rnode_25to26_bb2__and_i_i74_0_NO_SHIFT_REG & 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb2_and204_i_stall_local;
wire [31:0] local_bb2_and204_i;

assign local_bb2_and204_i = (rnode_25to26_bb2__and_i_i74_1_NO_SHIFT_REG & 32'h18);

// This section implements an unregistered operation.
// 
wire local_bb2_and207_i_stall_local;
wire [31:0] local_bb2_and207_i;

assign local_bb2_and207_i = (rnode_25to26_bb2__and_i_i74_2_NO_SHIFT_REG & 32'h7);

// This section implements an unregistered operation.
// 
wire local_bb2_sub240_i_stall_local;
wire [31:0] local_bb2_sub240_i;

assign local_bb2_sub240_i = (32'h0 - local_bb2_and9_i_i75);

// This section implements an unregistered operation.
// 
wire local_bb2_shl205_i_stall_local;
wire [31:0] local_bb2_shl205_i;

assign local_bb2_shl205_i = (rnode_25to26_bb2_and194_i_0_NO_SHIFT_REG << local_bb2_and204_i);

// This section implements an unregistered operation.
// 
wire local_bb2_cond245_i_stall_local;
wire [31:0] local_bb2_cond245_i;

assign local_bb2_cond245_i = (rnode_24to26_bb2_cmp38_i_2_NO_SHIFT_REG ? local_bb2_sub240_i : local_bb2__43_i80);

// This section implements an unregistered operation.
// 
wire local_bb2_and206_i76_stall_local;
wire [31:0] local_bb2_and206_i76;

assign local_bb2_and206_i76 = (local_bb2_shl205_i & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_add246_i_stall_local;
wire [31:0] local_bb2_add246_i;

assign local_bb2_add246_i = (local_bb2_cond245_i + rnode_24to26_bb2_and17_i17_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_fold_i85_stall_local;
wire [31:0] local_bb2_fold_i85;

assign local_bb2_fold_i85 = (local_bb2_cond245_i + rnode_24to26_bb2_shr16_i16_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_shl208_i_stall_local;
wire [31:0] local_bb2_shl208_i;

assign local_bb2_shl208_i = (local_bb2_and206_i76 << local_bb2_and207_i);

// This section implements an unregistered operation.
// 
wire local_bb2_and251_i_stall_local;
wire [31:0] local_bb2_and251_i;

assign local_bb2_and251_i = (local_bb2_fold_i85 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and270_i90_stall_local;
wire [31:0] local_bb2_and270_i90;

assign local_bb2_and270_i90 = (local_bb2_fold_i85 << 32'h17);

// This section implements an unregistered operation.
// 
wire local_bb2_and209_i_stall_local;
wire [31:0] local_bb2_and209_i;

assign local_bb2_and209_i = (local_bb2_shl208_i & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_notrhs_i87_stall_local;
wire local_bb2_notrhs_i87;

assign local_bb2_notrhs_i87 = (local_bb2_and251_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2__44_i81_stall_local;
wire [31:0] local_bb2__44_i81;

assign local_bb2__44_i81 = (local_bb2__40_demorgan_i78 ? local_bb2_and209_i : local_bb2_or220_i);

// This section implements an unregistered operation.
// 
wire local_bb2__45_i82_stall_local;
wire [31:0] local_bb2__45_i82;

assign local_bb2__45_i82 = (local_bb2__42_i79 ? rnode_25to26_bb2_and194_i_2_NO_SHIFT_REG : local_bb2__44_i81);

// This section implements an unregistered operation.
// 
wire local_bb2_and226_i_stall_local;
wire [31:0] local_bb2_and226_i;

assign local_bb2_and226_i = (local_bb2__45_i82 & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and271_i_stall_local;
wire [31:0] local_bb2_and271_i;

assign local_bb2_and271_i = (local_bb2__45_i82 & 32'h7);

// This section implements an unregistered operation.
// 
wire local_bb2_shr272_i_stall_local;
wire [31:0] local_bb2_shr272_i;

assign local_bb2_shr272_i = (local_bb2__45_i82 >> 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp227_i_stall_local;
wire local_bb2_cmp227_i;

assign local_bb2_cmp227_i = (local_bb2_and226_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp297_i_stall_local;
wire local_bb2_cmp297_i;

assign local_bb2_cmp297_i = (local_bb2_and271_i > 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb2_and270_i90_valid_out;
wire local_bb2_and270_i90_stall_in;
 reg local_bb2_and270_i90_consumed_0_NO_SHIFT_REG;
wire local_bb2_add246_i_valid_out;
wire local_bb2_add246_i_stall_in;
 reg local_bb2_add246_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_notrhs_i87_valid_out;
wire local_bb2_notrhs_i87_stall_in;
 reg local_bb2_notrhs_i87_consumed_0_NO_SHIFT_REG;
wire local_bb2_not_cmp38_i_valid_out_1;
wire local_bb2_not_cmp38_i_stall_in_1;
 reg local_bb2_not_cmp38_i_consumed_1_NO_SHIFT_REG;
wire local_bb2_shr272_i_valid_out;
wire local_bb2_shr272_i_stall_in;
 reg local_bb2_shr272_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp227_i_valid_out;
wire local_bb2_cmp227_i_stall_in;
 reg local_bb2_cmp227_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp297_i_valid_out;
wire local_bb2_cmp297_i_stall_in;
 reg local_bb2_cmp297_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp300_i_valid_out;
wire local_bb2_cmp300_i_stall_in;
 reg local_bb2_cmp300_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp300_i_inputs_ready;
wire local_bb2_cmp300_i_stall_local;
wire local_bb2_cmp300_i;

assign local_bb2_cmp300_i_inputs_ready = (rnode_24to26_bb2_shr16_i16_0_valid_out_NO_SHIFT_REG & rnode_24to26_bb2_cmp38_i_0_valid_out_2_NO_SHIFT_REG & rnode_24to26_bb2_and17_i17_0_valid_out_NO_SHIFT_REG & rnode_24to26_bb2_cmp38_i_0_valid_out_0_NO_SHIFT_REG & rnode_25to26_bb2_and194_i_0_valid_out_2_NO_SHIFT_REG & rnode_24to26_bb2_cmp38_i_0_valid_out_1_NO_SHIFT_REG & rnode_25to26_bb2_and196_i_0_valid_out_NO_SHIFT_REG & rnode_25to26_bb2_and194_i_0_valid_out_1_NO_SHIFT_REG & rnode_25to26_bb2_and199_i_0_valid_out_NO_SHIFT_REG & rnode_25to26_bb2_and194_i_0_valid_out_0_NO_SHIFT_REG & rnode_25to26_bb2__and_i_i74_0_valid_out_1_NO_SHIFT_REG & rnode_25to26_bb2__and_i_i74_0_valid_out_2_NO_SHIFT_REG & rnode_25to26_bb2__and_i_i74_0_valid_out_0_NO_SHIFT_REG);
assign local_bb2_cmp300_i = (local_bb2_and271_i == 32'h4);
assign local_bb2_and270_i90_valid_out = 1'b1;
assign local_bb2_add246_i_valid_out = 1'b1;
assign local_bb2_notrhs_i87_valid_out = 1'b1;
assign local_bb2_not_cmp38_i_valid_out_1 = 1'b1;
assign local_bb2_shr272_i_valid_out = 1'b1;
assign local_bb2_cmp227_i_valid_out = 1'b1;
assign local_bb2_cmp297_i_valid_out = 1'b1;
assign local_bb2_cmp300_i_valid_out = 1'b1;
assign rnode_24to26_bb2_shr16_i16_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_24to26_bb2_cmp38_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_24to26_bb2_and17_i17_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_24to26_bb2_cmp38_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2_and194_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_24to26_bb2_cmp38_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2_and196_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2_and194_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2_and199_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2_and194_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2__and_i_i74_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2__and_i_i74_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_25to26_bb2__and_i_i74_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_and270_i90_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_add246_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_notrhs_i87_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_not_cmp38_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb2_shr272_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp227_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp297_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp300_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_and270_i90_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp300_i_inputs_ready & (local_bb2_and270_i90_consumed_0_NO_SHIFT_REG | ~(local_bb2_and270_i90_stall_in)) & local_bb2_cmp300_i_stall_local);
		local_bb2_add246_i_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp300_i_inputs_ready & (local_bb2_add246_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_add246_i_stall_in)) & local_bb2_cmp300_i_stall_local);
		local_bb2_notrhs_i87_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp300_i_inputs_ready & (local_bb2_notrhs_i87_consumed_0_NO_SHIFT_REG | ~(local_bb2_notrhs_i87_stall_in)) & local_bb2_cmp300_i_stall_local);
		local_bb2_not_cmp38_i_consumed_1_NO_SHIFT_REG <= (local_bb2_cmp300_i_inputs_ready & (local_bb2_not_cmp38_i_consumed_1_NO_SHIFT_REG | ~(local_bb2_not_cmp38_i_stall_in_1)) & local_bb2_cmp300_i_stall_local);
		local_bb2_shr272_i_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp300_i_inputs_ready & (local_bb2_shr272_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_shr272_i_stall_in)) & local_bb2_cmp300_i_stall_local);
		local_bb2_cmp227_i_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp300_i_inputs_ready & (local_bb2_cmp227_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp227_i_stall_in)) & local_bb2_cmp300_i_stall_local);
		local_bb2_cmp297_i_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp300_i_inputs_ready & (local_bb2_cmp297_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp297_i_stall_in)) & local_bb2_cmp300_i_stall_local);
		local_bb2_cmp300_i_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp300_i_inputs_ready & (local_bb2_cmp300_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp300_i_stall_in)) & local_bb2_cmp300_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_26to27_bb2_and270_i90_0_valid_out_NO_SHIFT_REG;
 logic rnode_26to27_bb2_and270_i90_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_26to27_bb2_and270_i90_0_NO_SHIFT_REG;
 logic rnode_26to27_bb2_and270_i90_0_reg_27_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_26to27_bb2_and270_i90_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_and270_i90_0_valid_out_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_and270_i90_0_stall_in_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_and270_i90_0_stall_out_reg_27_NO_SHIFT_REG;

acl_data_fifo rnode_26to27_bb2_and270_i90_0_reg_27_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_26to27_bb2_and270_i90_0_reg_27_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_26to27_bb2_and270_i90_0_stall_in_reg_27_NO_SHIFT_REG),
	.valid_out(rnode_26to27_bb2_and270_i90_0_valid_out_reg_27_NO_SHIFT_REG),
	.stall_out(rnode_26to27_bb2_and270_i90_0_stall_out_reg_27_NO_SHIFT_REG),
	.data_in(local_bb2_and270_i90),
	.data_out(rnode_26to27_bb2_and270_i90_0_reg_27_NO_SHIFT_REG)
);

defparam rnode_26to27_bb2_and270_i90_0_reg_27_fifo.DEPTH = 1;
defparam rnode_26to27_bb2_and270_i90_0_reg_27_fifo.DATA_WIDTH = 32;
defparam rnode_26to27_bb2_and270_i90_0_reg_27_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_26to27_bb2_and270_i90_0_reg_27_fifo.IMPL = "shift_reg";

assign rnode_26to27_bb2_and270_i90_0_reg_27_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and270_i90_stall_in = 1'b0;
assign rnode_26to27_bb2_and270_i90_0_NO_SHIFT_REG = rnode_26to27_bb2_and270_i90_0_reg_27_NO_SHIFT_REG;
assign rnode_26to27_bb2_and270_i90_0_stall_in_reg_27_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_and270_i90_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_26to27_bb2_add246_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_26to27_bb2_add246_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_26to27_bb2_add246_i_0_NO_SHIFT_REG;
 logic rnode_26to27_bb2_add246_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_26to27_bb2_add246_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_26to27_bb2_add246_i_1_NO_SHIFT_REG;
 logic rnode_26to27_bb2_add246_i_0_reg_27_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_26to27_bb2_add246_i_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_add246_i_0_valid_out_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_add246_i_0_stall_in_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_add246_i_0_stall_out_reg_27_NO_SHIFT_REG;

acl_data_fifo rnode_26to27_bb2_add246_i_0_reg_27_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_26to27_bb2_add246_i_0_reg_27_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_26to27_bb2_add246_i_0_stall_in_0_reg_27_NO_SHIFT_REG),
	.valid_out(rnode_26to27_bb2_add246_i_0_valid_out_0_reg_27_NO_SHIFT_REG),
	.stall_out(rnode_26to27_bb2_add246_i_0_stall_out_reg_27_NO_SHIFT_REG),
	.data_in(local_bb2_add246_i),
	.data_out(rnode_26to27_bb2_add246_i_0_reg_27_NO_SHIFT_REG)
);

defparam rnode_26to27_bb2_add246_i_0_reg_27_fifo.DEPTH = 1;
defparam rnode_26to27_bb2_add246_i_0_reg_27_fifo.DATA_WIDTH = 32;
defparam rnode_26to27_bb2_add246_i_0_reg_27_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_26to27_bb2_add246_i_0_reg_27_fifo.IMPL = "shift_reg";

assign rnode_26to27_bb2_add246_i_0_reg_27_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_add246_i_stall_in = 1'b0;
assign rnode_26to27_bb2_add246_i_0_stall_in_0_reg_27_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_add246_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_26to27_bb2_add246_i_0_NO_SHIFT_REG = rnode_26to27_bb2_add246_i_0_reg_27_NO_SHIFT_REG;
assign rnode_26to27_bb2_add246_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_26to27_bb2_add246_i_1_NO_SHIFT_REG = rnode_26to27_bb2_add246_i_0_reg_27_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_26to27_bb2_notrhs_i87_0_valid_out_NO_SHIFT_REG;
 logic rnode_26to27_bb2_notrhs_i87_0_stall_in_NO_SHIFT_REG;
 logic rnode_26to27_bb2_notrhs_i87_0_NO_SHIFT_REG;
 logic rnode_26to27_bb2_notrhs_i87_0_reg_27_inputs_ready_NO_SHIFT_REG;
 logic rnode_26to27_bb2_notrhs_i87_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_notrhs_i87_0_valid_out_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_notrhs_i87_0_stall_in_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_notrhs_i87_0_stall_out_reg_27_NO_SHIFT_REG;

acl_data_fifo rnode_26to27_bb2_notrhs_i87_0_reg_27_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_26to27_bb2_notrhs_i87_0_reg_27_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_26to27_bb2_notrhs_i87_0_stall_in_reg_27_NO_SHIFT_REG),
	.valid_out(rnode_26to27_bb2_notrhs_i87_0_valid_out_reg_27_NO_SHIFT_REG),
	.stall_out(rnode_26to27_bb2_notrhs_i87_0_stall_out_reg_27_NO_SHIFT_REG),
	.data_in(local_bb2_notrhs_i87),
	.data_out(rnode_26to27_bb2_notrhs_i87_0_reg_27_NO_SHIFT_REG)
);

defparam rnode_26to27_bb2_notrhs_i87_0_reg_27_fifo.DEPTH = 1;
defparam rnode_26to27_bb2_notrhs_i87_0_reg_27_fifo.DATA_WIDTH = 1;
defparam rnode_26to27_bb2_notrhs_i87_0_reg_27_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_26to27_bb2_notrhs_i87_0_reg_27_fifo.IMPL = "shift_reg";

assign rnode_26to27_bb2_notrhs_i87_0_reg_27_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_notrhs_i87_stall_in = 1'b0;
assign rnode_26to27_bb2_notrhs_i87_0_NO_SHIFT_REG = rnode_26to27_bb2_notrhs_i87_0_reg_27_NO_SHIFT_REG;
assign rnode_26to27_bb2_notrhs_i87_0_stall_in_reg_27_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_notrhs_i87_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_26to27_bb2_not_cmp38_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_26to27_bb2_not_cmp38_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_26to27_bb2_not_cmp38_i_0_NO_SHIFT_REG;
 logic rnode_26to27_bb2_not_cmp38_i_0_reg_27_inputs_ready_NO_SHIFT_REG;
 logic rnode_26to27_bb2_not_cmp38_i_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_not_cmp38_i_0_valid_out_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_not_cmp38_i_0_stall_in_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_not_cmp38_i_0_stall_out_reg_27_NO_SHIFT_REG;

acl_data_fifo rnode_26to27_bb2_not_cmp38_i_0_reg_27_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_26to27_bb2_not_cmp38_i_0_reg_27_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_26to27_bb2_not_cmp38_i_0_stall_in_reg_27_NO_SHIFT_REG),
	.valid_out(rnode_26to27_bb2_not_cmp38_i_0_valid_out_reg_27_NO_SHIFT_REG),
	.stall_out(rnode_26to27_bb2_not_cmp38_i_0_stall_out_reg_27_NO_SHIFT_REG),
	.data_in(local_bb2_not_cmp38_i),
	.data_out(rnode_26to27_bb2_not_cmp38_i_0_reg_27_NO_SHIFT_REG)
);

defparam rnode_26to27_bb2_not_cmp38_i_0_reg_27_fifo.DEPTH = 1;
defparam rnode_26to27_bb2_not_cmp38_i_0_reg_27_fifo.DATA_WIDTH = 1;
defparam rnode_26to27_bb2_not_cmp38_i_0_reg_27_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_26to27_bb2_not_cmp38_i_0_reg_27_fifo.IMPL = "shift_reg";

assign rnode_26to27_bb2_not_cmp38_i_0_reg_27_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_not_cmp38_i_stall_in_1 = 1'b0;
assign rnode_26to27_bb2_not_cmp38_i_0_NO_SHIFT_REG = rnode_26to27_bb2_not_cmp38_i_0_reg_27_NO_SHIFT_REG;
assign rnode_26to27_bb2_not_cmp38_i_0_stall_in_reg_27_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_not_cmp38_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_26to27_bb2_shr272_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_26to27_bb2_shr272_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_26to27_bb2_shr272_i_0_NO_SHIFT_REG;
 logic rnode_26to27_bb2_shr272_i_0_reg_27_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_26to27_bb2_shr272_i_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_shr272_i_0_valid_out_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_shr272_i_0_stall_in_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_shr272_i_0_stall_out_reg_27_NO_SHIFT_REG;

acl_data_fifo rnode_26to27_bb2_shr272_i_0_reg_27_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_26to27_bb2_shr272_i_0_reg_27_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_26to27_bb2_shr272_i_0_stall_in_reg_27_NO_SHIFT_REG),
	.valid_out(rnode_26to27_bb2_shr272_i_0_valid_out_reg_27_NO_SHIFT_REG),
	.stall_out(rnode_26to27_bb2_shr272_i_0_stall_out_reg_27_NO_SHIFT_REG),
	.data_in(local_bb2_shr272_i),
	.data_out(rnode_26to27_bb2_shr272_i_0_reg_27_NO_SHIFT_REG)
);

defparam rnode_26to27_bb2_shr272_i_0_reg_27_fifo.DEPTH = 1;
defparam rnode_26to27_bb2_shr272_i_0_reg_27_fifo.DATA_WIDTH = 32;
defparam rnode_26to27_bb2_shr272_i_0_reg_27_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_26to27_bb2_shr272_i_0_reg_27_fifo.IMPL = "shift_reg";

assign rnode_26to27_bb2_shr272_i_0_reg_27_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_shr272_i_stall_in = 1'b0;
assign rnode_26to27_bb2_shr272_i_0_NO_SHIFT_REG = rnode_26to27_bb2_shr272_i_0_reg_27_NO_SHIFT_REG;
assign rnode_26to27_bb2_shr272_i_0_stall_in_reg_27_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_shr272_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_26to27_bb2_cmp227_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp227_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp227_i_0_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp227_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp227_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp227_i_1_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp227_i_0_reg_27_inputs_ready_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp227_i_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp227_i_0_valid_out_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp227_i_0_stall_in_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp227_i_0_stall_out_reg_27_NO_SHIFT_REG;

acl_data_fifo rnode_26to27_bb2_cmp227_i_0_reg_27_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_26to27_bb2_cmp227_i_0_reg_27_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_26to27_bb2_cmp227_i_0_stall_in_0_reg_27_NO_SHIFT_REG),
	.valid_out(rnode_26to27_bb2_cmp227_i_0_valid_out_0_reg_27_NO_SHIFT_REG),
	.stall_out(rnode_26to27_bb2_cmp227_i_0_stall_out_reg_27_NO_SHIFT_REG),
	.data_in(local_bb2_cmp227_i),
	.data_out(rnode_26to27_bb2_cmp227_i_0_reg_27_NO_SHIFT_REG)
);

defparam rnode_26to27_bb2_cmp227_i_0_reg_27_fifo.DEPTH = 1;
defparam rnode_26to27_bb2_cmp227_i_0_reg_27_fifo.DATA_WIDTH = 1;
defparam rnode_26to27_bb2_cmp227_i_0_reg_27_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_26to27_bb2_cmp227_i_0_reg_27_fifo.IMPL = "shift_reg";

assign rnode_26to27_bb2_cmp227_i_0_reg_27_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp227_i_stall_in = 1'b0;
assign rnode_26to27_bb2_cmp227_i_0_stall_in_0_reg_27_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_cmp227_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_26to27_bb2_cmp227_i_0_NO_SHIFT_REG = rnode_26to27_bb2_cmp227_i_0_reg_27_NO_SHIFT_REG;
assign rnode_26to27_bb2_cmp227_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_26to27_bb2_cmp227_i_1_NO_SHIFT_REG = rnode_26to27_bb2_cmp227_i_0_reg_27_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_26to27_bb2_cmp297_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp297_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp297_i_0_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp297_i_0_reg_27_inputs_ready_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp297_i_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp297_i_0_valid_out_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp297_i_0_stall_in_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp297_i_0_stall_out_reg_27_NO_SHIFT_REG;

acl_data_fifo rnode_26to27_bb2_cmp297_i_0_reg_27_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_26to27_bb2_cmp297_i_0_reg_27_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_26to27_bb2_cmp297_i_0_stall_in_reg_27_NO_SHIFT_REG),
	.valid_out(rnode_26to27_bb2_cmp297_i_0_valid_out_reg_27_NO_SHIFT_REG),
	.stall_out(rnode_26to27_bb2_cmp297_i_0_stall_out_reg_27_NO_SHIFT_REG),
	.data_in(local_bb2_cmp297_i),
	.data_out(rnode_26to27_bb2_cmp297_i_0_reg_27_NO_SHIFT_REG)
);

defparam rnode_26to27_bb2_cmp297_i_0_reg_27_fifo.DEPTH = 1;
defparam rnode_26to27_bb2_cmp297_i_0_reg_27_fifo.DATA_WIDTH = 1;
defparam rnode_26to27_bb2_cmp297_i_0_reg_27_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_26to27_bb2_cmp297_i_0_reg_27_fifo.IMPL = "shift_reg";

assign rnode_26to27_bb2_cmp297_i_0_reg_27_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp297_i_stall_in = 1'b0;
assign rnode_26to27_bb2_cmp297_i_0_NO_SHIFT_REG = rnode_26to27_bb2_cmp297_i_0_reg_27_NO_SHIFT_REG;
assign rnode_26to27_bb2_cmp297_i_0_stall_in_reg_27_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_cmp297_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_26to27_bb2_cmp300_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp300_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp300_i_0_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp300_i_0_reg_27_inputs_ready_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp300_i_0_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp300_i_0_valid_out_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp300_i_0_stall_in_reg_27_NO_SHIFT_REG;
 logic rnode_26to27_bb2_cmp300_i_0_stall_out_reg_27_NO_SHIFT_REG;

acl_data_fifo rnode_26to27_bb2_cmp300_i_0_reg_27_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_26to27_bb2_cmp300_i_0_reg_27_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_26to27_bb2_cmp300_i_0_stall_in_reg_27_NO_SHIFT_REG),
	.valid_out(rnode_26to27_bb2_cmp300_i_0_valid_out_reg_27_NO_SHIFT_REG),
	.stall_out(rnode_26to27_bb2_cmp300_i_0_stall_out_reg_27_NO_SHIFT_REG),
	.data_in(local_bb2_cmp300_i),
	.data_out(rnode_26to27_bb2_cmp300_i_0_reg_27_NO_SHIFT_REG)
);

defparam rnode_26to27_bb2_cmp300_i_0_reg_27_fifo.DEPTH = 1;
defparam rnode_26to27_bb2_cmp300_i_0_reg_27_fifo.DATA_WIDTH = 1;
defparam rnode_26to27_bb2_cmp300_i_0_reg_27_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_26to27_bb2_cmp300_i_0_reg_27_fifo.IMPL = "shift_reg";

assign rnode_26to27_bb2_cmp300_i_0_reg_27_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp300_i_stall_in = 1'b0;
assign rnode_26to27_bb2_cmp300_i_0_NO_SHIFT_REG = rnode_26to27_bb2_cmp300_i_0_reg_27_NO_SHIFT_REG;
assign rnode_26to27_bb2_cmp300_i_0_stall_in_reg_27_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_cmp300_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_shl274_i_stall_local;
wire [31:0] local_bb2_shl274_i;

assign local_bb2_shl274_i = (rnode_26to27_bb2_and270_i90_0_NO_SHIFT_REG & 32'h7F800000);

// This section implements an unregistered operation.
// 
wire local_bb2_and248_i_stall_local;
wire [31:0] local_bb2_and248_i;

assign local_bb2_and248_i = (rnode_26to27_bb2_add246_i_0_NO_SHIFT_REG & 32'h100);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp259_i_stall_local;
wire local_bb2_cmp259_i;

assign local_bb2_cmp259_i = ($signed(rnode_26to27_bb2_add246_i_1_NO_SHIFT_REG) > $signed(32'hFE));

// This section implements an unregistered operation.
// 
wire local_bb2_and273_i_stall_local;
wire [31:0] local_bb2_and273_i;

assign local_bb2_and273_i = (rnode_26to27_bb2_shr272_i_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp227_not_i_stall_local;
wire local_bb2_cmp227_not_i;

assign local_bb2_cmp227_not_i = (rnode_26to27_bb2_cmp227_i_0_NO_SHIFT_REG ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp29749_i_stall_local;
wire [31:0] local_bb2_cmp29749_i;

assign local_bb2_cmp29749_i[31:1] = 31'h0;
assign local_bb2_cmp29749_i[0] = rnode_26to27_bb2_cmp297_i_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_conv301_i_stall_local;
wire [31:0] local_bb2_conv301_i;

assign local_bb2_conv301_i[31:1] = 31'h0;
assign local_bb2_conv301_i[0] = rnode_26to27_bb2_cmp300_i_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_notlhs_i86_stall_local;
wire local_bb2_notlhs_i86;

assign local_bb2_notlhs_i86 = (local_bb2_and248_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or275_i91_stall_local;
wire [31:0] local_bb2_or275_i91;

assign local_bb2_or275_i91 = (local_bb2_and273_i | local_bb2_shl274_i);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge12_i83_stall_local;
wire local_bb2_brmerge12_i83;

assign local_bb2_brmerge12_i83 = (local_bb2_cmp227_not_i | rnode_26to27_bb2_not_cmp38_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot263__i_stall_local;
wire local_bb2_lnot263__i;

assign local_bb2_lnot263__i = (local_bb2_cmp259_i & local_bb2_cmp227_not_i);

// This section implements an unregistered operation.
// 
wire local_bb2_not__46_i88_stall_local;
wire local_bb2_not__46_i88;

assign local_bb2_not__46_i88 = (rnode_26to27_bb2_notrhs_i87_0_NO_SHIFT_REG | local_bb2_notlhs_i86);

// This section implements an unregistered operation.
// 
wire local_bb2_resultSign_0_i84_stall_local;
wire [31:0] local_bb2_resultSign_0_i84;

assign local_bb2_resultSign_0_i84 = (local_bb2_brmerge12_i83 ? rnode_26to27_bb2_and35_i26_0_NO_SHIFT_REG : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or2672_i_stall_local;
wire local_bb2_or2672_i;

assign local_bb2_or2672_i = (rnode_26to27_bb2_var__u40_0_NO_SHIFT_REG | local_bb2_lnot263__i);

// This section implements an unregistered operation.
// 
wire local_bb2__47_i89_stall_local;
wire local_bb2__47_i89;

assign local_bb2__47_i89 = (rnode_26to27_bb2_cmp227_i_1_NO_SHIFT_REG | local_bb2_not__46_i88);

// This section implements an unregistered operation.
// 
wire local_bb2_or276_i_stall_local;
wire [31:0] local_bb2_or276_i;

assign local_bb2_or276_i = (local_bb2_or275_i91 | local_bb2_resultSign_0_i84);

// This section implements an unregistered operation.
// 
wire local_bb2_or2885_i_stall_local;
wire local_bb2_or2885_i;

assign local_bb2_or2885_i = (local_bb2_or2672_i | rnode_26to27_bb2__26_i39_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u47_stall_local;
wire [31:0] local_bb2_var__u47;

assign local_bb2_var__u47[31:1] = 31'h0;
assign local_bb2_var__u47[0] = local_bb2_or2672_i;

// This section implements an unregistered operation.
// 
wire local_bb2_or2814_i_stall_local;
wire local_bb2_or2814_i;

assign local_bb2_or2814_i = (local_bb2__47_i89 | local_bb2_or2672_i);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u48_stall_local;
wire [31:0] local_bb2_var__u48;

assign local_bb2_var__u48[31:1] = 31'h0;
assign local_bb2_var__u48[0] = local_bb2__47_i89;

// This section implements an unregistered operation.
// 
wire local_bb2_cond290_i_stall_local;
wire [31:0] local_bb2_cond290_i;

assign local_bb2_cond290_i = (local_bb2_or2885_i ? 32'h7F800000 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_ext311_i_stall_local;
wire [31:0] local_bb2_lnot_ext311_i;

assign local_bb2_lnot_ext311_i = (local_bb2_var__u47 ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_cond283_i_stall_local;
wire [31:0] local_bb2_cond283_i;

assign local_bb2_cond283_i = (local_bb2_or2814_i ? 32'h80000000 : 32'hFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_or295_i92_stall_local;
wire [31:0] local_bb2_or295_i92;

assign local_bb2_or295_i92 = (local_bb2_cond290_i | local_bb2_cond293_i);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_0_i95_stall_local;
wire [31:0] local_bb2_reduction_0_i95;

assign local_bb2_reduction_0_i95 = (local_bb2_lnot_ext311_i & local_bb2_lnot_ext_i94);

// This section implements an unregistered operation.
// 
wire local_bb2_and294_i_stall_local;
wire [31:0] local_bb2_and294_i;

assign local_bb2_and294_i = (local_bb2_cond283_i & local_bb2_or276_i);

// This section implements an unregistered operation.
// 
wire local_bb2_or296_i_stall_local;
wire [31:0] local_bb2_or296_i;

assign local_bb2_or296_i = (local_bb2_or295_i92 | local_bb2_and294_i);

// This section implements an unregistered operation.
// 
wire local_bb2_and303_i_stall_local;
wire [31:0] local_bb2_and303_i;

assign local_bb2_and303_i = (local_bb2_conv301_i & local_bb2_and294_i);

// This section implements an unregistered operation.
// 
wire local_bb2_or296_i_valid_out;
wire local_bb2_or296_i_stall_in;
 reg local_bb2_or296_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_var__u48_valid_out;
wire local_bb2_var__u48_stall_in;
 reg local_bb2_var__u48_consumed_0_NO_SHIFT_REG;
wire local_bb2_lor_ext_i93_valid_out;
wire local_bb2_lor_ext_i93_stall_in;
 reg local_bb2_lor_ext_i93_consumed_0_NO_SHIFT_REG;
wire local_bb2_reduction_0_i95_valid_out;
wire local_bb2_reduction_0_i95_stall_in;
 reg local_bb2_reduction_0_i95_consumed_0_NO_SHIFT_REG;
wire local_bb2_lor_ext_i93_inputs_ready;
wire local_bb2_lor_ext_i93_stall_local;
wire [31:0] local_bb2_lor_ext_i93;

assign local_bb2_lor_ext_i93_inputs_ready = (rnode_26to27_bb2_and35_i26_0_valid_out_NO_SHIFT_REG & rnode_26to27_bb2_not_cmp38_i_0_valid_out_NO_SHIFT_REG & rnode_26to27_bb2_and270_i90_0_valid_out_NO_SHIFT_REG & rnode_26to27_bb2_add246_i_0_valid_out_1_NO_SHIFT_REG & rnode_26to27_bb2_var__u40_0_valid_out_NO_SHIFT_REG & rnode_26to27_bb2__26_i39_0_valid_out_0_NO_SHIFT_REG & rnode_26to27_bb2__26_i39_0_valid_out_1_NO_SHIFT_REG & rnode_26to27_bb2_add246_i_0_valid_out_0_NO_SHIFT_REG & rnode_26to27_bb2_notrhs_i87_0_valid_out_NO_SHIFT_REG & rnode_26to27_bb2_cmp227_i_0_valid_out_1_NO_SHIFT_REG & rnode_26to27_bb2_shr272_i_0_valid_out_NO_SHIFT_REG & rnode_26to27_bb2__26_i39_0_valid_out_2_NO_SHIFT_REG & rnode_26to27_bb2_cmp227_i_0_valid_out_0_NO_SHIFT_REG & rnode_26to27_bb2_cmp297_i_0_valid_out_NO_SHIFT_REG & rnode_26to27_bb2_cmp300_i_0_valid_out_NO_SHIFT_REG);
assign local_bb2_lor_ext_i93 = (local_bb2_cmp29749_i | local_bb2_and303_i);
assign local_bb2_or296_i_valid_out = 1'b1;
assign local_bb2_var__u48_valid_out = 1'b1;
assign local_bb2_lor_ext_i93_valid_out = 1'b1;
assign local_bb2_reduction_0_i95_valid_out = 1'b1;
assign rnode_26to27_bb2_and35_i26_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_not_cmp38_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_and270_i90_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_add246_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_var__u40_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2__26_i39_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2__26_i39_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_add246_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_notrhs_i87_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_cmp227_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_shr272_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2__26_i39_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_cmp227_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_cmp297_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_26to27_bb2_cmp300_i_0_stall_in_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_or296_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_var__u48_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_lor_ext_i93_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_reduction_0_i95_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_or296_i_consumed_0_NO_SHIFT_REG <= (local_bb2_lor_ext_i93_inputs_ready & (local_bb2_or296_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_or296_i_stall_in)) & local_bb2_lor_ext_i93_stall_local);
		local_bb2_var__u48_consumed_0_NO_SHIFT_REG <= (local_bb2_lor_ext_i93_inputs_ready & (local_bb2_var__u48_consumed_0_NO_SHIFT_REG | ~(local_bb2_var__u48_stall_in)) & local_bb2_lor_ext_i93_stall_local);
		local_bb2_lor_ext_i93_consumed_0_NO_SHIFT_REG <= (local_bb2_lor_ext_i93_inputs_ready & (local_bb2_lor_ext_i93_consumed_0_NO_SHIFT_REG | ~(local_bb2_lor_ext_i93_stall_in)) & local_bb2_lor_ext_i93_stall_local);
		local_bb2_reduction_0_i95_consumed_0_NO_SHIFT_REG <= (local_bb2_lor_ext_i93_inputs_ready & (local_bb2_reduction_0_i95_consumed_0_NO_SHIFT_REG | ~(local_bb2_reduction_0_i95_stall_in)) & local_bb2_lor_ext_i93_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_27to28_bb2_or296_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_27to28_bb2_or296_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_27to28_bb2_or296_i_0_NO_SHIFT_REG;
 logic rnode_27to28_bb2_or296_i_0_reg_28_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_27to28_bb2_or296_i_0_reg_28_NO_SHIFT_REG;
 logic rnode_27to28_bb2_or296_i_0_valid_out_reg_28_NO_SHIFT_REG;
 logic rnode_27to28_bb2_or296_i_0_stall_in_reg_28_NO_SHIFT_REG;
 logic rnode_27to28_bb2_or296_i_0_stall_out_reg_28_NO_SHIFT_REG;

acl_data_fifo rnode_27to28_bb2_or296_i_0_reg_28_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_27to28_bb2_or296_i_0_reg_28_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_27to28_bb2_or296_i_0_stall_in_reg_28_NO_SHIFT_REG),
	.valid_out(rnode_27to28_bb2_or296_i_0_valid_out_reg_28_NO_SHIFT_REG),
	.stall_out(rnode_27to28_bb2_or296_i_0_stall_out_reg_28_NO_SHIFT_REG),
	.data_in(local_bb2_or296_i),
	.data_out(rnode_27to28_bb2_or296_i_0_reg_28_NO_SHIFT_REG)
);

defparam rnode_27to28_bb2_or296_i_0_reg_28_fifo.DEPTH = 1;
defparam rnode_27to28_bb2_or296_i_0_reg_28_fifo.DATA_WIDTH = 32;
defparam rnode_27to28_bb2_or296_i_0_reg_28_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_27to28_bb2_or296_i_0_reg_28_fifo.IMPL = "shift_reg";

assign rnode_27to28_bb2_or296_i_0_reg_28_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_or296_i_stall_in = 1'b0;
assign rnode_27to28_bb2_or296_i_0_NO_SHIFT_REG = rnode_27to28_bb2_or296_i_0_reg_28_NO_SHIFT_REG;
assign rnode_27to28_bb2_or296_i_0_stall_in_reg_28_NO_SHIFT_REG = 1'b0;
assign rnode_27to28_bb2_or296_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_27to28_bb2_var__u48_0_valid_out_NO_SHIFT_REG;
 logic rnode_27to28_bb2_var__u48_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_27to28_bb2_var__u48_0_NO_SHIFT_REG;
 logic rnode_27to28_bb2_var__u48_0_reg_28_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_27to28_bb2_var__u48_0_reg_28_NO_SHIFT_REG;
 logic rnode_27to28_bb2_var__u48_0_valid_out_reg_28_NO_SHIFT_REG;
 logic rnode_27to28_bb2_var__u48_0_stall_in_reg_28_NO_SHIFT_REG;
 logic rnode_27to28_bb2_var__u48_0_stall_out_reg_28_NO_SHIFT_REG;

acl_data_fifo rnode_27to28_bb2_var__u48_0_reg_28_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_27to28_bb2_var__u48_0_reg_28_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_27to28_bb2_var__u48_0_stall_in_reg_28_NO_SHIFT_REG),
	.valid_out(rnode_27to28_bb2_var__u48_0_valid_out_reg_28_NO_SHIFT_REG),
	.stall_out(rnode_27to28_bb2_var__u48_0_stall_out_reg_28_NO_SHIFT_REG),
	.data_in(local_bb2_var__u48),
	.data_out(rnode_27to28_bb2_var__u48_0_reg_28_NO_SHIFT_REG)
);

defparam rnode_27to28_bb2_var__u48_0_reg_28_fifo.DEPTH = 1;
defparam rnode_27to28_bb2_var__u48_0_reg_28_fifo.DATA_WIDTH = 32;
defparam rnode_27to28_bb2_var__u48_0_reg_28_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_27to28_bb2_var__u48_0_reg_28_fifo.IMPL = "shift_reg";

assign rnode_27to28_bb2_var__u48_0_reg_28_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_var__u48_stall_in = 1'b0;
assign rnode_27to28_bb2_var__u48_0_NO_SHIFT_REG = rnode_27to28_bb2_var__u48_0_reg_28_NO_SHIFT_REG;
assign rnode_27to28_bb2_var__u48_0_stall_in_reg_28_NO_SHIFT_REG = 1'b0;
assign rnode_27to28_bb2_var__u48_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_27to28_bb2_lor_ext_i93_0_valid_out_NO_SHIFT_REG;
 logic rnode_27to28_bb2_lor_ext_i93_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_27to28_bb2_lor_ext_i93_0_NO_SHIFT_REG;
 logic rnode_27to28_bb2_lor_ext_i93_0_reg_28_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_27to28_bb2_lor_ext_i93_0_reg_28_NO_SHIFT_REG;
 logic rnode_27to28_bb2_lor_ext_i93_0_valid_out_reg_28_NO_SHIFT_REG;
 logic rnode_27to28_bb2_lor_ext_i93_0_stall_in_reg_28_NO_SHIFT_REG;
 logic rnode_27to28_bb2_lor_ext_i93_0_stall_out_reg_28_NO_SHIFT_REG;

acl_data_fifo rnode_27to28_bb2_lor_ext_i93_0_reg_28_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_27to28_bb2_lor_ext_i93_0_reg_28_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_27to28_bb2_lor_ext_i93_0_stall_in_reg_28_NO_SHIFT_REG),
	.valid_out(rnode_27to28_bb2_lor_ext_i93_0_valid_out_reg_28_NO_SHIFT_REG),
	.stall_out(rnode_27to28_bb2_lor_ext_i93_0_stall_out_reg_28_NO_SHIFT_REG),
	.data_in(local_bb2_lor_ext_i93),
	.data_out(rnode_27to28_bb2_lor_ext_i93_0_reg_28_NO_SHIFT_REG)
);

defparam rnode_27to28_bb2_lor_ext_i93_0_reg_28_fifo.DEPTH = 1;
defparam rnode_27to28_bb2_lor_ext_i93_0_reg_28_fifo.DATA_WIDTH = 32;
defparam rnode_27to28_bb2_lor_ext_i93_0_reg_28_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_27to28_bb2_lor_ext_i93_0_reg_28_fifo.IMPL = "shift_reg";

assign rnode_27to28_bb2_lor_ext_i93_0_reg_28_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_lor_ext_i93_stall_in = 1'b0;
assign rnode_27to28_bb2_lor_ext_i93_0_NO_SHIFT_REG = rnode_27to28_bb2_lor_ext_i93_0_reg_28_NO_SHIFT_REG;
assign rnode_27to28_bb2_lor_ext_i93_0_stall_in_reg_28_NO_SHIFT_REG = 1'b0;
assign rnode_27to28_bb2_lor_ext_i93_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_27to28_bb2_reduction_0_i95_0_valid_out_NO_SHIFT_REG;
 logic rnode_27to28_bb2_reduction_0_i95_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_27to28_bb2_reduction_0_i95_0_NO_SHIFT_REG;
 logic rnode_27to28_bb2_reduction_0_i95_0_reg_28_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_27to28_bb2_reduction_0_i95_0_reg_28_NO_SHIFT_REG;
 logic rnode_27to28_bb2_reduction_0_i95_0_valid_out_reg_28_NO_SHIFT_REG;
 logic rnode_27to28_bb2_reduction_0_i95_0_stall_in_reg_28_NO_SHIFT_REG;
 logic rnode_27to28_bb2_reduction_0_i95_0_stall_out_reg_28_NO_SHIFT_REG;

acl_data_fifo rnode_27to28_bb2_reduction_0_i95_0_reg_28_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_27to28_bb2_reduction_0_i95_0_reg_28_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_27to28_bb2_reduction_0_i95_0_stall_in_reg_28_NO_SHIFT_REG),
	.valid_out(rnode_27to28_bb2_reduction_0_i95_0_valid_out_reg_28_NO_SHIFT_REG),
	.stall_out(rnode_27to28_bb2_reduction_0_i95_0_stall_out_reg_28_NO_SHIFT_REG),
	.data_in(local_bb2_reduction_0_i95),
	.data_out(rnode_27to28_bb2_reduction_0_i95_0_reg_28_NO_SHIFT_REG)
);

defparam rnode_27to28_bb2_reduction_0_i95_0_reg_28_fifo.DEPTH = 1;
defparam rnode_27to28_bb2_reduction_0_i95_0_reg_28_fifo.DATA_WIDTH = 32;
defparam rnode_27to28_bb2_reduction_0_i95_0_reg_28_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_27to28_bb2_reduction_0_i95_0_reg_28_fifo.IMPL = "shift_reg";

assign rnode_27to28_bb2_reduction_0_i95_0_reg_28_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_reduction_0_i95_stall_in = 1'b0;
assign rnode_27to28_bb2_reduction_0_i95_0_NO_SHIFT_REG = rnode_27to28_bb2_reduction_0_i95_0_reg_28_NO_SHIFT_REG;
assign rnode_27to28_bb2_reduction_0_i95_0_stall_in_reg_28_NO_SHIFT_REG = 1'b0;
assign rnode_27to28_bb2_reduction_0_i95_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_ext315_i_stall_local;
wire [31:0] local_bb2_lnot_ext315_i;

assign local_bb2_lnot_ext315_i = (rnode_27to28_bb2_var__u48_0_NO_SHIFT_REG ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_1_i96_stall_local;
wire [31:0] local_bb2_reduction_1_i96;

assign local_bb2_reduction_1_i96 = (local_bb2_lnot_ext315_i & rnode_27to28_bb2_lor_ext_i93_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_2_i97_stall_local;
wire [31:0] local_bb2_reduction_2_i97;

assign local_bb2_reduction_2_i97 = (rnode_27to28_bb2_reduction_0_i95_0_NO_SHIFT_REG & local_bb2_reduction_1_i96);

// This section implements an unregistered operation.
// 
wire local_bb2_add321_i_stall_local;
wire [31:0] local_bb2_add321_i;

assign local_bb2_add321_i = (local_bb2_reduction_2_i97 + rnode_27to28_bb2_or296_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_and_i_i_stall_local;
wire [31:0] local_bb2_and_i_i;

assign local_bb2_and_i_i = (local_bb2_add321_i & 32'h7FFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_astype1_i_i_stall_local;
wire [31:0] local_bb2_astype1_i_i;

assign local_bb2_astype1_i_i = local_bb2_and_i_i;

// This section implements an unregistered operation.
// 
wire local_bb2_c0_exi2_valid_out;
wire local_bb2_c0_exi2_stall_in;
wire local_bb2_c0_exi2_inputs_ready;
wire local_bb2_c0_exi2_stall_local;
wire [95:0] local_bb2_c0_exi2;

assign local_bb2_c0_exi2_inputs_ready = (rnode_27to28_bb2_or296_i_0_valid_out_NO_SHIFT_REG & rnode_27to28_bb2_reduction_0_i95_0_valid_out_NO_SHIFT_REG & rnode_27to28_bb2_var__u48_0_valid_out_NO_SHIFT_REG & rnode_27to28_bb2_lor_ext_i93_0_valid_out_NO_SHIFT_REG & rnode_27to28_bb2_add320_i279_0_valid_out_NO_SHIFT_REG);
assign local_bb2_c0_exi2[63:0] = local_bb2_c0_exi16[63:0];
assign local_bb2_c0_exi2[95:64] = local_bb2_astype1_i_i;
assign local_bb2_c0_exi2_valid_out = 1'b1;
assign rnode_27to28_bb2_or296_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_27to28_bb2_reduction_0_i95_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_27to28_bb2_var__u48_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_27to28_bb2_lor_ext_i93_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_27to28_bb2_add320_i279_0_stall_in_NO_SHIFT_REG = 1'b0;

// This section implements a registered operation.
// 
wire local_bb2_c0_exit7_c0_exi2_inputs_ready;
 reg local_bb2_c0_exit7_c0_exi2_valid_out_0_NO_SHIFT_REG;
wire local_bb2_c0_exit7_c0_exi2_stall_in_0;
 reg local_bb2_c0_exit7_c0_exi2_valid_out_1_NO_SHIFT_REG;
wire local_bb2_c0_exit7_c0_exi2_stall_in_1;
 reg [95:0] local_bb2_c0_exit7_c0_exi2_NO_SHIFT_REG;
wire [95:0] local_bb2_c0_exit7_c0_exi2_in;
wire local_bb2_c0_exit7_c0_exi2_valid;
wire local_bb2_c0_exit7_c0_exi2_causedstall;

acl_stall_free_sink local_bb2_c0_exit7_c0_exi2_instance (
	.clock(clock),
	.resetn(resetn),
	.data_in(local_bb2_c0_exi2),
	.data_out(local_bb2_c0_exit7_c0_exi2_in),
	.input_accepted(local_bb2_c0_enter3_c0_eni22_input_accepted),
	.valid_out(local_bb2_c0_exit7_c0_exi2_valid),
	.stall_in(~(local_bb2_c0_exit7_c0_exi2_output_regs_ready)),
	.stall_entry(local_bb2_c0_exit7_c0_exi2_entry_stall),
	.valids(local_bb2_c0_exit7_c0_exi2_valid_bits),
	.IIphases(local_bb2_c0_exit7_c0_exi2_phases),
	.inc_pipelined_thread(local_bb2_c0_enter3_c0_eni22_inc_pipelined_thread),
	.dec_pipelined_thread(local_bb2_c0_enter3_c0_eni22_dec_pipelined_thread)
);

defparam local_bb2_c0_exit7_c0_exi2_instance.DATA_WIDTH = 96;
defparam local_bb2_c0_exit7_c0_exi2_instance.PIPELINE_DEPTH = 30;
defparam local_bb2_c0_exit7_c0_exi2_instance.SHARINGII = 1;
defparam local_bb2_c0_exit7_c0_exi2_instance.SCHEDULEII = 1;

assign local_bb2_c0_exit7_c0_exi2_inputs_ready = 1'b1;
assign local_bb2_c0_exit7_c0_exi2_output_regs_ready = ((~(local_bb2_c0_exit7_c0_exi2_valid_out_0_NO_SHIFT_REG) | ~(local_bb2_c0_exit7_c0_exi2_stall_in_0)) & (~(local_bb2_c0_exit7_c0_exi2_valid_out_1_NO_SHIFT_REG) | ~(local_bb2_c0_exit7_c0_exi2_stall_in_1)));
assign local_bb2_c0_exi2_stall_in = 1'b0;
assign local_bb2_c0_exit7_c0_exi2_causedstall = (1'b1 && (1'b0 && !(~(local_bb2_c0_exit7_c0_exi2_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_c0_exit7_c0_exi2_NO_SHIFT_REG <= 'x;
		local_bb2_c0_exit7_c0_exi2_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_c0_exit7_c0_exi2_valid_out_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb2_c0_exit7_c0_exi2_output_regs_ready)
		begin
			local_bb2_c0_exit7_c0_exi2_NO_SHIFT_REG <= local_bb2_c0_exit7_c0_exi2_in;
			local_bb2_c0_exit7_c0_exi2_valid_out_0_NO_SHIFT_REG <= local_bb2_c0_exit7_c0_exi2_valid;
			local_bb2_c0_exit7_c0_exi2_valid_out_1_NO_SHIFT_REG <= local_bb2_c0_exit7_c0_exi2_valid;
		end
		else
		begin
			if (~(local_bb2_c0_exit7_c0_exi2_stall_in_0))
			begin
				local_bb2_c0_exit7_c0_exi2_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb2_c0_exit7_c0_exi2_stall_in_1))
			begin
				local_bb2_c0_exit7_c0_exi2_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb2_c0_exe18_valid_out;
wire local_bb2_c0_exe18_stall_in;
wire local_bb2_c0_exe18_inputs_ready;
wire local_bb2_c0_exe18_stall_local;
wire [31:0] local_bb2_c0_exe18;

assign local_bb2_c0_exe18_inputs_ready = local_bb2_c0_exit7_c0_exi2_valid_out_0_NO_SHIFT_REG;
assign local_bb2_c0_exe18 = local_bb2_c0_exit7_c0_exi2_NO_SHIFT_REG[63:32];
assign local_bb2_c0_exe18_valid_out = local_bb2_c0_exe18_inputs_ready;
assign local_bb2_c0_exe18_stall_local = local_bb2_c0_exe18_stall_in;
assign local_bb2_c0_exit7_c0_exi2_stall_in_0 = (|local_bb2_c0_exe18_stall_local);

// This section implements an unregistered operation.
// 
wire local_bb2_c0_exe2_valid_out;
wire local_bb2_c0_exe2_stall_in;
wire local_bb2_c0_exe2_inputs_ready;
wire local_bb2_c0_exe2_stall_local;
wire [31:0] local_bb2_c0_exe2;

assign local_bb2_c0_exe2_inputs_ready = local_bb2_c0_exit7_c0_exi2_valid_out_1_NO_SHIFT_REG;
assign local_bb2_c0_exe2 = local_bb2_c0_exit7_c0_exi2_NO_SHIFT_REG[95:64];
assign local_bb2_c0_exe2_valid_out = local_bb2_c0_exe2_inputs_ready;
assign local_bb2_c0_exe2_stall_local = local_bb2_c0_exe2_stall_in;
assign local_bb2_c0_exit7_c0_exi2_stall_in_1 = (|local_bb2_c0_exe2_stall_local);

// Register node:
//  * latency = 159
//  * capacity = 159
 logic rnode_33to192_bb2_c0_exe18_0_valid_out_NO_SHIFT_REG;
 logic rnode_33to192_bb2_c0_exe18_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_33to192_bb2_c0_exe18_0_NO_SHIFT_REG;
 logic rnode_33to192_bb2_c0_exe18_0_reg_192_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_33to192_bb2_c0_exe18_0_reg_192_NO_SHIFT_REG;
 logic rnode_33to192_bb2_c0_exe18_0_valid_out_reg_192_NO_SHIFT_REG;
 logic rnode_33to192_bb2_c0_exe18_0_stall_in_reg_192_NO_SHIFT_REG;
 logic rnode_33to192_bb2_c0_exe18_0_stall_out_reg_192_NO_SHIFT_REG;

acl_data_fifo rnode_33to192_bb2_c0_exe18_0_reg_192_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_33to192_bb2_c0_exe18_0_reg_192_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_33to192_bb2_c0_exe18_0_stall_in_reg_192_NO_SHIFT_REG),
	.valid_out(rnode_33to192_bb2_c0_exe18_0_valid_out_reg_192_NO_SHIFT_REG),
	.stall_out(rnode_33to192_bb2_c0_exe18_0_stall_out_reg_192_NO_SHIFT_REG),
	.data_in(local_bb2_c0_exe18),
	.data_out(rnode_33to192_bb2_c0_exe18_0_reg_192_NO_SHIFT_REG)
);

defparam rnode_33to192_bb2_c0_exe18_0_reg_192_fifo.DEPTH = 160;
defparam rnode_33to192_bb2_c0_exe18_0_reg_192_fifo.DATA_WIDTH = 32;
defparam rnode_33to192_bb2_c0_exe18_0_reg_192_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_33to192_bb2_c0_exe18_0_reg_192_fifo.IMPL = "ram";

assign rnode_33to192_bb2_c0_exe18_0_reg_192_inputs_ready_NO_SHIFT_REG = local_bb2_c0_exe18_valid_out;
assign local_bb2_c0_exe18_stall_in = rnode_33to192_bb2_c0_exe18_0_stall_out_reg_192_NO_SHIFT_REG;
assign rnode_33to192_bb2_c0_exe18_0_NO_SHIFT_REG = rnode_33to192_bb2_c0_exe18_0_reg_192_NO_SHIFT_REG;
assign rnode_33to192_bb2_c0_exe18_0_stall_in_reg_192_NO_SHIFT_REG = rnode_33to192_bb2_c0_exe18_0_stall_in_NO_SHIFT_REG;
assign rnode_33to192_bb2_c0_exe18_0_valid_out_NO_SHIFT_REG = rnode_33to192_bb2_c0_exe18_0_valid_out_reg_192_NO_SHIFT_REG;

// This section implements a registered operation.
// 
wire local_bb2_st_c0_exe2_inputs_ready;
 reg local_bb2_st_c0_exe2_valid_out_NO_SHIFT_REG;
wire local_bb2_st_c0_exe2_stall_in;
wire local_bb2_st_c0_exe2_output_regs_ready;
wire local_bb2_st_c0_exe2_fu_stall_out;
wire local_bb2_st_c0_exe2_fu_valid_out;
wire [31:0] local_bb2_st_c0_exe2_lsu_wackout;
 reg local_bb2_st_c0_exe2_NO_SHIFT_REG;
wire local_bb2_st_c0_exe2_causedstall;

lsu_top lsu_local_bb2_st_c0_exe2 (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(),
	.stream_size(),
	.stream_reset(),
	.o_stall(local_bb2_st_c0_exe2_fu_stall_out),
	.i_valid(local_bb2_st_c0_exe2_inputs_ready),
	.i_address(local_bb2_arrayidx14),
	.i_writedata(local_bb2_c0_exe2),
	.i_cmpdata(),
	.i_predicate(1'b0),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb2_st_c0_exe2_output_regs_ready)),
	.o_valid(local_bb2_st_c0_exe2_fu_valid_out),
	.o_readdata(),
	.o_input_fifo_depth(),
	.o_writeack(local_bb2_st_c0_exe2_lsu_wackout),
	.i_atomic_op(3'h0),
	.o_active(local_bb2_st_c0_exe2_active),
	.avm_address(avm_local_bb2_st_c0_exe2_address),
	.avm_read(avm_local_bb2_st_c0_exe2_read),
	.avm_readdata(avm_local_bb2_st_c0_exe2_readdata),
	.avm_write(avm_local_bb2_st_c0_exe2_write),
	.avm_writeack(avm_local_bb2_st_c0_exe2_writeack),
	.avm_burstcount(avm_local_bb2_st_c0_exe2_burstcount),
	.avm_writedata(avm_local_bb2_st_c0_exe2_writedata),
	.avm_byteenable(avm_local_bb2_st_c0_exe2_byteenable),
	.avm_waitrequest(avm_local_bb2_st_c0_exe2_waitrequest),
	.avm_readdatavalid(avm_local_bb2_st_c0_exe2_readdatavalid),
	.profile_bw(),
	.profile_bw_incr(),
	.profile_total_ivalid(),
	.profile_total_req(),
	.profile_i_stall_count(),
	.profile_o_stall_count(),
	.profile_avm_readwrite_count(),
	.profile_avm_burstcount_total(),
	.profile_avm_burstcount_total_incr(),
	.profile_req_cache_hit_count(),
	.profile_extra_unaligned_reqs(),
	.profile_avm_stall()
);

defparam lsu_local_bb2_st_c0_exe2.AWIDTH = 30;
defparam lsu_local_bb2_st_c0_exe2.WIDTH_BYTES = 4;
defparam lsu_local_bb2_st_c0_exe2.MWIDTH_BYTES = 32;
defparam lsu_local_bb2_st_c0_exe2.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb2_st_c0_exe2.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb2_st_c0_exe2.READ = 0;
defparam lsu_local_bb2_st_c0_exe2.ATOMIC = 0;
defparam lsu_local_bb2_st_c0_exe2.WIDTH = 32;
defparam lsu_local_bb2_st_c0_exe2.MWIDTH = 256;
defparam lsu_local_bb2_st_c0_exe2.ATOMIC_WIDTH = 3;
defparam lsu_local_bb2_st_c0_exe2.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb2_st_c0_exe2.KERNEL_SIDE_MEM_LATENCY = 160;
defparam lsu_local_bb2_st_c0_exe2.MEMORY_SIDE_MEM_LATENCY = 14;
defparam lsu_local_bb2_st_c0_exe2.USE_WRITE_ACK = 1;
defparam lsu_local_bb2_st_c0_exe2.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb2_st_c0_exe2.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb2_st_c0_exe2.NUMBER_BANKS = 1;
defparam lsu_local_bb2_st_c0_exe2.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb2_st_c0_exe2.USEINPUTFIFO = 0;
defparam lsu_local_bb2_st_c0_exe2.USECACHING = 0;
defparam lsu_local_bb2_st_c0_exe2.USEOUTPUTFIFO = 1;
defparam lsu_local_bb2_st_c0_exe2.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb2_st_c0_exe2.HIGH_FMAX = 1;
defparam lsu_local_bb2_st_c0_exe2.ADDRSPACE = 1;
defparam lsu_local_bb2_st_c0_exe2.STYLE = "BURST-COALESCED";
defparam lsu_local_bb2_st_c0_exe2.USE_BYTE_EN = 0;

assign local_bb2_st_c0_exe2_inputs_ready = (local_bb2_c0_exe2_valid_out & local_bb2_arrayidx14_valid_out);
assign local_bb2_st_c0_exe2_output_regs_ready = (&(~(local_bb2_st_c0_exe2_valid_out_NO_SHIFT_REG) | ~(local_bb2_st_c0_exe2_stall_in)));
assign local_bb2_c0_exe2_stall_in = (local_bb2_st_c0_exe2_fu_stall_out | ~(local_bb2_st_c0_exe2_inputs_ready));
assign local_bb2_arrayidx14_stall_in = (local_bb2_st_c0_exe2_fu_stall_out | ~(local_bb2_st_c0_exe2_inputs_ready));
assign local_bb2_st_c0_exe2_causedstall = (local_bb2_st_c0_exe2_inputs_ready && (local_bb2_st_c0_exe2_fu_stall_out && !(~(local_bb2_st_c0_exe2_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_st_c0_exe2_NO_SHIFT_REG <= 'x;
		local_bb2_st_c0_exe2_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb2_st_c0_exe2_output_regs_ready)
		begin
			local_bb2_st_c0_exe2_NO_SHIFT_REG <= local_bb2_st_c0_exe2_lsu_wackout;
			local_bb2_st_c0_exe2_valid_out_NO_SHIFT_REG <= local_bb2_st_c0_exe2_fu_valid_out;
		end
		else
		begin
			if (~(local_bb2_st_c0_exe2_stall_in))
			begin
				local_bb2_st_c0_exe2_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_192to193_bb2_c0_exe18_0_valid_out_NO_SHIFT_REG;
 logic rnode_192to193_bb2_c0_exe18_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_192to193_bb2_c0_exe18_0_NO_SHIFT_REG;
 logic rnode_192to193_bb2_c0_exe18_0_reg_193_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_192to193_bb2_c0_exe18_0_reg_193_NO_SHIFT_REG;
 logic rnode_192to193_bb2_c0_exe18_0_valid_out_reg_193_NO_SHIFT_REG;
 logic rnode_192to193_bb2_c0_exe18_0_stall_in_reg_193_NO_SHIFT_REG;
 logic rnode_192to193_bb2_c0_exe18_0_stall_out_reg_193_NO_SHIFT_REG;

acl_data_fifo rnode_192to193_bb2_c0_exe18_0_reg_193_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_192to193_bb2_c0_exe18_0_reg_193_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_192to193_bb2_c0_exe18_0_stall_in_reg_193_NO_SHIFT_REG),
	.valid_out(rnode_192to193_bb2_c0_exe18_0_valid_out_reg_193_NO_SHIFT_REG),
	.stall_out(rnode_192to193_bb2_c0_exe18_0_stall_out_reg_193_NO_SHIFT_REG),
	.data_in(rnode_33to192_bb2_c0_exe18_0_NO_SHIFT_REG),
	.data_out(rnode_192to193_bb2_c0_exe18_0_reg_193_NO_SHIFT_REG)
);

defparam rnode_192to193_bb2_c0_exe18_0_reg_193_fifo.DEPTH = 2;
defparam rnode_192to193_bb2_c0_exe18_0_reg_193_fifo.DATA_WIDTH = 32;
defparam rnode_192to193_bb2_c0_exe18_0_reg_193_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_192to193_bb2_c0_exe18_0_reg_193_fifo.IMPL = "ll_reg";

assign rnode_192to193_bb2_c0_exe18_0_reg_193_inputs_ready_NO_SHIFT_REG = rnode_33to192_bb2_c0_exe18_0_valid_out_NO_SHIFT_REG;
assign rnode_33to192_bb2_c0_exe18_0_stall_in_NO_SHIFT_REG = rnode_192to193_bb2_c0_exe18_0_stall_out_reg_193_NO_SHIFT_REG;
assign rnode_192to193_bb2_c0_exe18_0_NO_SHIFT_REG = rnode_192to193_bb2_c0_exe18_0_reg_193_NO_SHIFT_REG;
assign rnode_192to193_bb2_c0_exe18_0_stall_in_reg_193_NO_SHIFT_REG = rnode_192to193_bb2_c0_exe18_0_stall_in_NO_SHIFT_REG;
assign rnode_192to193_bb2_c0_exe18_0_valid_out_NO_SHIFT_REG = rnode_192to193_bb2_c0_exe18_0_valid_out_reg_193_NO_SHIFT_REG;

// This section implements a staging register.
// 
wire rstag_193to193_bb2_st_c0_exe2_valid_out;
wire rstag_193to193_bb2_st_c0_exe2_stall_in;
wire rstag_193to193_bb2_st_c0_exe2_inputs_ready;
wire rstag_193to193_bb2_st_c0_exe2_stall_local;
 reg rstag_193to193_bb2_st_c0_exe2_staging_valid_NO_SHIFT_REG;
wire rstag_193to193_bb2_st_c0_exe2_combined_valid;
 reg rstag_193to193_bb2_st_c0_exe2_staging_reg_NO_SHIFT_REG;
wire rstag_193to193_bb2_st_c0_exe2;

assign rstag_193to193_bb2_st_c0_exe2_inputs_ready = local_bb2_st_c0_exe2_valid_out_NO_SHIFT_REG;
assign rstag_193to193_bb2_st_c0_exe2 = (rstag_193to193_bb2_st_c0_exe2_staging_valid_NO_SHIFT_REG ? rstag_193to193_bb2_st_c0_exe2_staging_reg_NO_SHIFT_REG : local_bb2_st_c0_exe2_NO_SHIFT_REG);
assign rstag_193to193_bb2_st_c0_exe2_combined_valid = (rstag_193to193_bb2_st_c0_exe2_staging_valid_NO_SHIFT_REG | rstag_193to193_bb2_st_c0_exe2_inputs_ready);
assign rstag_193to193_bb2_st_c0_exe2_valid_out = rstag_193to193_bb2_st_c0_exe2_combined_valid;
assign rstag_193to193_bb2_st_c0_exe2_stall_local = rstag_193to193_bb2_st_c0_exe2_stall_in;
assign local_bb2_st_c0_exe2_stall_in = (|rstag_193to193_bb2_st_c0_exe2_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_193to193_bb2_st_c0_exe2_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_193to193_bb2_st_c0_exe2_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_193to193_bb2_st_c0_exe2_stall_local)
		begin
			if (~(rstag_193to193_bb2_st_c0_exe2_staging_valid_NO_SHIFT_REG))
			begin
				rstag_193to193_bb2_st_c0_exe2_staging_valid_NO_SHIFT_REG <= rstag_193to193_bb2_st_c0_exe2_inputs_ready;
			end
		end
		else
		begin
			rstag_193to193_bb2_st_c0_exe2_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_193to193_bb2_st_c0_exe2_staging_valid_NO_SHIFT_REG))
		begin
			rstag_193to193_bb2_st_c0_exe2_staging_reg_NO_SHIFT_REG <= local_bb2_st_c0_exe2_NO_SHIFT_REG;
		end
	end
end


// This section implements a registered operation.
// 
wire local_bb2_st_c0_exe18_inputs_ready;
 reg local_bb2_st_c0_exe18_valid_out_NO_SHIFT_REG;
wire local_bb2_st_c0_exe18_stall_in;
wire local_bb2_st_c0_exe18_output_regs_ready;
wire local_bb2_st_c0_exe18_fu_stall_out;
wire local_bb2_st_c0_exe18_fu_valid_out;
wire local_bb2_st_c0_exe18_causedstall;

lsu_top lsu_local_bb2_st_c0_exe18 (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(rnode_192to193_bb2_arrayidx10_0_NO_SHIFT_REG),
	.stream_size(input_global_size_0),
	.stream_reset(valid_in),
	.o_stall(local_bb2_st_c0_exe18_fu_stall_out),
	.i_valid(local_bb2_st_c0_exe18_inputs_ready),
	.i_address(rnode_192to193_bb2_arrayidx10_0_NO_SHIFT_REG),
	.i_writedata(rnode_192to193_bb2_c0_exe18_0_NO_SHIFT_REG),
	.i_cmpdata(),
	.i_predicate(1'b0),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb2_st_c0_exe18_output_regs_ready)),
	.o_valid(local_bb2_st_c0_exe18_fu_valid_out),
	.o_readdata(),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb2_st_c0_exe18_active),
	.avm_address(avm_local_bb2_st_c0_exe18_address),
	.avm_read(avm_local_bb2_st_c0_exe18_read),
	.avm_readdata(avm_local_bb2_st_c0_exe18_readdata),
	.avm_write(avm_local_bb2_st_c0_exe18_write),
	.avm_writeack(avm_local_bb2_st_c0_exe18_writeack),
	.avm_burstcount(avm_local_bb2_st_c0_exe18_burstcount),
	.avm_writedata(avm_local_bb2_st_c0_exe18_writedata),
	.avm_byteenable(avm_local_bb2_st_c0_exe18_byteenable),
	.avm_waitrequest(avm_local_bb2_st_c0_exe18_waitrequest),
	.avm_readdatavalid(avm_local_bb2_st_c0_exe18_readdatavalid),
	.profile_bw(),
	.profile_bw_incr(),
	.profile_total_ivalid(),
	.profile_total_req(),
	.profile_i_stall_count(),
	.profile_o_stall_count(),
	.profile_avm_readwrite_count(),
	.profile_avm_burstcount_total(),
	.profile_avm_burstcount_total_incr(),
	.profile_req_cache_hit_count(),
	.profile_extra_unaligned_reqs(),
	.profile_avm_stall()
);

defparam lsu_local_bb2_st_c0_exe18.AWIDTH = 30;
defparam lsu_local_bb2_st_c0_exe18.WIDTH_BYTES = 4;
defparam lsu_local_bb2_st_c0_exe18.MWIDTH_BYTES = 32;
defparam lsu_local_bb2_st_c0_exe18.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb2_st_c0_exe18.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb2_st_c0_exe18.READ = 0;
defparam lsu_local_bb2_st_c0_exe18.ATOMIC = 0;
defparam lsu_local_bb2_st_c0_exe18.WIDTH = 32;
defparam lsu_local_bb2_st_c0_exe18.MWIDTH = 256;
defparam lsu_local_bb2_st_c0_exe18.ATOMIC_WIDTH = 3;
defparam lsu_local_bb2_st_c0_exe18.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb2_st_c0_exe18.KERNEL_SIDE_MEM_LATENCY = 2;
defparam lsu_local_bb2_st_c0_exe18.MEMORY_SIDE_MEM_LATENCY = 64;
defparam lsu_local_bb2_st_c0_exe18.USE_WRITE_ACK = 0;
defparam lsu_local_bb2_st_c0_exe18.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb2_st_c0_exe18.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb2_st_c0_exe18.NUMBER_BANKS = 1;
defparam lsu_local_bb2_st_c0_exe18.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb2_st_c0_exe18.USEINPUTFIFO = 0;
defparam lsu_local_bb2_st_c0_exe18.USECACHING = 0;
defparam lsu_local_bb2_st_c0_exe18.USEOUTPUTFIFO = 1;
defparam lsu_local_bb2_st_c0_exe18.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb2_st_c0_exe18.HIGH_FMAX = 1;
defparam lsu_local_bb2_st_c0_exe18.ADDRSPACE = 1;
defparam lsu_local_bb2_st_c0_exe18.STYLE = "STREAMING";
defparam lsu_local_bb2_st_c0_exe18.USE_BYTE_EN = 0;

assign local_bb2_st_c0_exe18_inputs_ready = (rnode_192to193_bb2_arrayidx10_0_valid_out_NO_SHIFT_REG & rnode_192to193_bb2_c0_exe18_0_valid_out_NO_SHIFT_REG & rstag_193to193_bb2_st_c0_exe2_valid_out);
assign local_bb2_st_c0_exe18_output_regs_ready = (&(~(local_bb2_st_c0_exe18_valid_out_NO_SHIFT_REG) | ~(local_bb2_st_c0_exe18_stall_in)));
assign rnode_192to193_bb2_arrayidx10_0_stall_in_NO_SHIFT_REG = (local_bb2_st_c0_exe18_fu_stall_out | ~(local_bb2_st_c0_exe18_inputs_ready));
assign rnode_192to193_bb2_c0_exe18_0_stall_in_NO_SHIFT_REG = (local_bb2_st_c0_exe18_fu_stall_out | ~(local_bb2_st_c0_exe18_inputs_ready));
assign rstag_193to193_bb2_st_c0_exe2_stall_in = (local_bb2_st_c0_exe18_fu_stall_out | ~(local_bb2_st_c0_exe18_inputs_ready));
assign local_bb2_st_c0_exe18_causedstall = (local_bb2_st_c0_exe18_inputs_ready && (local_bb2_st_c0_exe18_fu_stall_out && !(~(local_bb2_st_c0_exe18_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_st_c0_exe18_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb2_st_c0_exe18_output_regs_ready)
		begin
			local_bb2_st_c0_exe18_valid_out_NO_SHIFT_REG <= local_bb2_st_c0_exe18_fu_valid_out;
		end
		else
		begin
			if (~(local_bb2_st_c0_exe18_stall_in))
			begin
				local_bb2_st_c0_exe18_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements a staging register.
// 
wire rstag_195to195_bb2_st_c0_exe18_valid_out;
wire rstag_195to195_bb2_st_c0_exe18_stall_in;
wire rstag_195to195_bb2_st_c0_exe18_inputs_ready;
wire rstag_195to195_bb2_st_c0_exe18_stall_local;
 reg rstag_195to195_bb2_st_c0_exe18_staging_valid_NO_SHIFT_REG;
wire rstag_195to195_bb2_st_c0_exe18_combined_valid;

assign rstag_195to195_bb2_st_c0_exe18_inputs_ready = local_bb2_st_c0_exe18_valid_out_NO_SHIFT_REG;
assign rstag_195to195_bb2_st_c0_exe18_combined_valid = (rstag_195to195_bb2_st_c0_exe18_staging_valid_NO_SHIFT_REG | rstag_195to195_bb2_st_c0_exe18_inputs_ready);
assign rstag_195to195_bb2_st_c0_exe18_valid_out = rstag_195to195_bb2_st_c0_exe18_combined_valid;
assign rstag_195to195_bb2_st_c0_exe18_stall_local = rstag_195to195_bb2_st_c0_exe18_stall_in;
assign local_bb2_st_c0_exe18_stall_in = (|rstag_195to195_bb2_st_c0_exe18_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_195to195_bb2_st_c0_exe18_staging_valid_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (rstag_195to195_bb2_st_c0_exe18_stall_local)
		begin
			if (~(rstag_195to195_bb2_st_c0_exe18_staging_valid_NO_SHIFT_REG))
			begin
				rstag_195to195_bb2_st_c0_exe18_staging_valid_NO_SHIFT_REG <= rstag_195to195_bb2_st_c0_exe18_inputs_ready;
			end
		end
		else
		begin
			rstag_195to195_bb2_st_c0_exe18_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
	end
end


// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
wire branch_var__output_regs_ready;

assign branch_var__inputs_ready = rstag_195to195_bb2_st_c0_exe18_valid_out;
assign branch_var__output_regs_ready = ~(stall_in);
assign rstag_195to195_bb2_st_c0_exe18_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign valid_out = branch_var__inputs_ready;

endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module gather_function
	(
		input 		clock,
		input 		resetn,
		input [31:0] 		input_global_id_0,
		output 		stall_out,
		input 		valid_in,
		output 		valid_out,
		input 		stall_in,
		input [31:0] 		workgroup_size,
		input [255:0] 		avm_local_bb1_ld__readdata,
		input 		avm_local_bb1_ld__readdatavalid,
		input 		avm_local_bb1_ld__waitrequest,
		output [29:0] 		avm_local_bb1_ld__address,
		output 		avm_local_bb1_ld__read,
		output 		avm_local_bb1_ld__write,
		input 		avm_local_bb1_ld__writeack,
		output [255:0] 		avm_local_bb1_ld__writedata,
		output [31:0] 		avm_local_bb1_ld__byteenable,
		output [4:0] 		avm_local_bb1_ld__burstcount,
		input [255:0] 		avm_local_bb1_ld__u0_readdata,
		input 		avm_local_bb1_ld__u0_readdatavalid,
		input 		avm_local_bb1_ld__u0_waitrequest,
		output [29:0] 		avm_local_bb1_ld__u0_address,
		output 		avm_local_bb1_ld__u0_read,
		output 		avm_local_bb1_ld__u0_write,
		input 		avm_local_bb1_ld__u0_writeack,
		output [255:0] 		avm_local_bb1_ld__u0_writedata,
		output [31:0] 		avm_local_bb1_ld__u0_byteenable,
		output [4:0] 		avm_local_bb1_ld__u0_burstcount,
		input [255:0] 		avm_local_bb2_ld__readdata,
		input 		avm_local_bb2_ld__readdatavalid,
		input 		avm_local_bb2_ld__waitrequest,
		output [29:0] 		avm_local_bb2_ld__address,
		output 		avm_local_bb2_ld__read,
		output 		avm_local_bb2_ld__write,
		input 		avm_local_bb2_ld__writeack,
		output [255:0] 		avm_local_bb2_ld__writedata,
		output [31:0] 		avm_local_bb2_ld__byteenable,
		output [4:0] 		avm_local_bb2_ld__burstcount,
		input [255:0] 		avm_local_bb2_st_c0_exe2_readdata,
		input 		avm_local_bb2_st_c0_exe2_readdatavalid,
		input 		avm_local_bb2_st_c0_exe2_waitrequest,
		output [29:0] 		avm_local_bb2_st_c0_exe2_address,
		output 		avm_local_bb2_st_c0_exe2_read,
		output 		avm_local_bb2_st_c0_exe2_write,
		input 		avm_local_bb2_st_c0_exe2_writeack,
		output [255:0] 		avm_local_bb2_st_c0_exe2_writedata,
		output [31:0] 		avm_local_bb2_st_c0_exe2_byteenable,
		output [4:0] 		avm_local_bb2_st_c0_exe2_burstcount,
		input [255:0] 		avm_local_bb2_st_c0_exe18_readdata,
		input 		avm_local_bb2_st_c0_exe18_readdatavalid,
		input 		avm_local_bb2_st_c0_exe18_waitrequest,
		output [29:0] 		avm_local_bb2_st_c0_exe18_address,
		output 		avm_local_bb2_st_c0_exe18_read,
		output 		avm_local_bb2_st_c0_exe18_write,
		input 		avm_local_bb2_st_c0_exe18_writeack,
		output [255:0] 		avm_local_bb2_st_c0_exe18_writedata,
		output [31:0] 		avm_local_bb2_st_c0_exe18_byteenable,
		output [4:0] 		avm_local_bb2_st_c0_exe18_burstcount,
		input 		start,
		input [31:0] 		input_num_edges,
		input [31:0] 		input_num_nodes,
		input 		clock2x,
		input [63:0] 		input_msg_arr,
		input [63:0] 		input_rank,
		input [63:0] 		input_err_arr,
		input [31:0] 		input_global_size_0,
		input [31:0] 		input_sink_val,
		output reg 		has_a_write_pending,
		output reg 		has_a_lsu_active
	);


wire [31:0] cur_cycle;
wire bb_0_stall_out;
wire bb_0_valid_out;
wire bb_0_lvb_bb0_cmp1;
wire [31:0] bb_0_lvb_bb0_div;
wire [31:0] bb_0_lvb_input_global_id_0;
wire bb_1_stall_out_0;
wire bb_1_stall_out_1;
wire bb_1_valid_out_0;
wire [63:0] bb_1_lvb_bb1_indvars_iv_next_0;
wire [31:0] bb_1_lvb_bb1_c0_exe1_0;
wire [31:0] bb_1_lvb_input_global_id_0_0;
wire bb_1_valid_out_1;
wire [63:0] bb_1_lvb_bb1_indvars_iv_next_1;
wire [31:0] bb_1_lvb_bb1_c0_exe1_1;
wire [31:0] bb_1_lvb_input_global_id_0_1;
wire bb_1_local_bb1_ld__active;
wire bb_1_local_bb1_ld__u0_active;
wire bb_2_stall_out;
wire bb_2_valid_out;
wire bb_2_local_bb2_ld__active;
wire bb_2_local_bb2_st_c0_exe2_active;
wire bb_2_local_bb2_st_c0_exe18_active;
wire loop_limiter_0_stall_out;
wire loop_limiter_0_valid_out;
wire [1:0] writes_pending;
wire [4:0] lsus_active;

gather_basic_block_0 gather_basic_block_0 (
	.clock(clock),
	.resetn(resetn),
	.start(start),
	.input_num_edges(input_num_edges),
	.input_num_nodes(input_num_nodes),
	.valid_in(valid_in),
	.stall_out(bb_0_stall_out),
	.input_global_id_0(input_global_id_0),
	.valid_out(bb_0_valid_out),
	.stall_in(loop_limiter_0_stall_out),
	.lvb_bb0_cmp1(bb_0_lvb_bb0_cmp1),
	.lvb_bb0_div(bb_0_lvb_bb0_div),
	.lvb_input_global_id_0(bb_0_lvb_input_global_id_0),
	.workgroup_size(workgroup_size)
);


gather_basic_block_1 gather_basic_block_1 (
	.clock(clock),
	.resetn(resetn),
	.input_msg_arr(input_msg_arr),
	.input_num_edges(input_num_edges),
	.input_wii_cmp1(bb_0_lvb_bb0_cmp1),
	.input_wii_div(bb_0_lvb_bb0_div),
	.valid_in_0(bb_1_valid_out_1),
	.stall_out_0(bb_1_stall_out_0),
	.input_indvars_iv_0(bb_1_lvb_bb1_indvars_iv_next_1),
	.input_rank_new_02_0(bb_1_lvb_bb1_c0_exe1_1),
	.input_global_id_0_0(bb_1_lvb_input_global_id_0_1),
	.valid_in_1(loop_limiter_0_valid_out),
	.stall_out_1(bb_1_stall_out_1),
	.input_indvars_iv_1(64'h0),
	.input_rank_new_02_1(32'h0),
	.input_global_id_0_1(bb_0_lvb_input_global_id_0),
	.valid_out_0(bb_1_valid_out_0),
	.stall_in_0(bb_2_stall_out),
	.lvb_bb1_indvars_iv_next_0(bb_1_lvb_bb1_indvars_iv_next_0),
	.lvb_bb1_c0_exe1_0(bb_1_lvb_bb1_c0_exe1_0),
	.lvb_input_global_id_0_0(bb_1_lvb_input_global_id_0_0),
	.valid_out_1(bb_1_valid_out_1),
	.stall_in_1(bb_1_stall_out_0),
	.lvb_bb1_indvars_iv_next_1(bb_1_lvb_bb1_indvars_iv_next_1),
	.lvb_bb1_c0_exe1_1(bb_1_lvb_bb1_c0_exe1_1),
	.lvb_input_global_id_0_1(bb_1_lvb_input_global_id_0_1),
	.workgroup_size(workgroup_size),
	.start(start),
	.avm_local_bb1_ld__readdata(avm_local_bb1_ld__readdata),
	.avm_local_bb1_ld__readdatavalid(avm_local_bb1_ld__readdatavalid),
	.avm_local_bb1_ld__waitrequest(avm_local_bb1_ld__waitrequest),
	.avm_local_bb1_ld__address(avm_local_bb1_ld__address),
	.avm_local_bb1_ld__read(avm_local_bb1_ld__read),
	.avm_local_bb1_ld__write(avm_local_bb1_ld__write),
	.avm_local_bb1_ld__writeack(avm_local_bb1_ld__writeack),
	.avm_local_bb1_ld__writedata(avm_local_bb1_ld__writedata),
	.avm_local_bb1_ld__byteenable(avm_local_bb1_ld__byteenable),
	.avm_local_bb1_ld__burstcount(avm_local_bb1_ld__burstcount),
	.local_bb1_ld__active(bb_1_local_bb1_ld__active),
	.clock2x(clock2x),
	.avm_local_bb1_ld__u0_readdata(avm_local_bb1_ld__u0_readdata),
	.avm_local_bb1_ld__u0_readdatavalid(avm_local_bb1_ld__u0_readdatavalid),
	.avm_local_bb1_ld__u0_waitrequest(avm_local_bb1_ld__u0_waitrequest),
	.avm_local_bb1_ld__u0_address(avm_local_bb1_ld__u0_address),
	.avm_local_bb1_ld__u0_read(avm_local_bb1_ld__u0_read),
	.avm_local_bb1_ld__u0_write(avm_local_bb1_ld__u0_write),
	.avm_local_bb1_ld__u0_writeack(avm_local_bb1_ld__u0_writeack),
	.avm_local_bb1_ld__u0_writedata(avm_local_bb1_ld__u0_writedata),
	.avm_local_bb1_ld__u0_byteenable(avm_local_bb1_ld__u0_byteenable),
	.avm_local_bb1_ld__u0_burstcount(avm_local_bb1_ld__u0_burstcount),
	.local_bb1_ld__u0_active(bb_1_local_bb1_ld__u0_active)
);


gather_basic_block_2 gather_basic_block_2 (
	.clock(clock),
	.resetn(resetn),
	.input_rank(input_rank),
	.input_err_arr(input_err_arr),
	.input_global_size_0(input_global_size_0),
	.input_sink_val(input_sink_val),
	.input_wii_cmp1(bb_0_lvb_bb0_cmp1),
	.input_wii_div(bb_0_lvb_bb0_div),
	.valid_in(bb_1_valid_out_0),
	.stall_out(bb_2_stall_out),
	.input_c0_exe1(bb_1_lvb_bb1_c0_exe1_0),
	.input_global_id_0(bb_1_lvb_input_global_id_0_0),
	.valid_out(bb_2_valid_out),
	.stall_in(stall_in),
	.workgroup_size(workgroup_size),
	.start(start),
	.avm_local_bb2_ld__readdata(avm_local_bb2_ld__readdata),
	.avm_local_bb2_ld__readdatavalid(avm_local_bb2_ld__readdatavalid),
	.avm_local_bb2_ld__waitrequest(avm_local_bb2_ld__waitrequest),
	.avm_local_bb2_ld__address(avm_local_bb2_ld__address),
	.avm_local_bb2_ld__read(avm_local_bb2_ld__read),
	.avm_local_bb2_ld__write(avm_local_bb2_ld__write),
	.avm_local_bb2_ld__writeack(avm_local_bb2_ld__writeack),
	.avm_local_bb2_ld__writedata(avm_local_bb2_ld__writedata),
	.avm_local_bb2_ld__byteenable(avm_local_bb2_ld__byteenable),
	.avm_local_bb2_ld__burstcount(avm_local_bb2_ld__burstcount),
	.local_bb2_ld__active(bb_2_local_bb2_ld__active),
	.clock2x(clock2x),
	.avm_local_bb2_st_c0_exe2_readdata(avm_local_bb2_st_c0_exe2_readdata),
	.avm_local_bb2_st_c0_exe2_readdatavalid(avm_local_bb2_st_c0_exe2_readdatavalid),
	.avm_local_bb2_st_c0_exe2_waitrequest(avm_local_bb2_st_c0_exe2_waitrequest),
	.avm_local_bb2_st_c0_exe2_address(avm_local_bb2_st_c0_exe2_address),
	.avm_local_bb2_st_c0_exe2_read(avm_local_bb2_st_c0_exe2_read),
	.avm_local_bb2_st_c0_exe2_write(avm_local_bb2_st_c0_exe2_write),
	.avm_local_bb2_st_c0_exe2_writeack(avm_local_bb2_st_c0_exe2_writeack),
	.avm_local_bb2_st_c0_exe2_writedata(avm_local_bb2_st_c0_exe2_writedata),
	.avm_local_bb2_st_c0_exe2_byteenable(avm_local_bb2_st_c0_exe2_byteenable),
	.avm_local_bb2_st_c0_exe2_burstcount(avm_local_bb2_st_c0_exe2_burstcount),
	.local_bb2_st_c0_exe2_active(bb_2_local_bb2_st_c0_exe2_active),
	.avm_local_bb2_st_c0_exe18_readdata(avm_local_bb2_st_c0_exe18_readdata),
	.avm_local_bb2_st_c0_exe18_readdatavalid(avm_local_bb2_st_c0_exe18_readdatavalid),
	.avm_local_bb2_st_c0_exe18_waitrequest(avm_local_bb2_st_c0_exe18_waitrequest),
	.avm_local_bb2_st_c0_exe18_address(avm_local_bb2_st_c0_exe18_address),
	.avm_local_bb2_st_c0_exe18_read(avm_local_bb2_st_c0_exe18_read),
	.avm_local_bb2_st_c0_exe18_write(avm_local_bb2_st_c0_exe18_write),
	.avm_local_bb2_st_c0_exe18_writeack(avm_local_bb2_st_c0_exe18_writeack),
	.avm_local_bb2_st_c0_exe18_writedata(avm_local_bb2_st_c0_exe18_writedata),
	.avm_local_bb2_st_c0_exe18_byteenable(avm_local_bb2_st_c0_exe18_byteenable),
	.avm_local_bb2_st_c0_exe18_burstcount(avm_local_bb2_st_c0_exe18_burstcount),
	.local_bb2_st_c0_exe18_active(bb_2_local_bb2_st_c0_exe18_active)
);


acl_loop_limiter loop_limiter_0 (
	.clock(clock),
	.resetn(resetn),
	.i_valid(bb_0_valid_out),
	.i_stall(bb_1_stall_out_1),
	.i_valid_exit(bb_1_valid_out_0),
	.i_stall_exit(bb_2_stall_out),
	.o_valid(loop_limiter_0_valid_out),
	.o_stall(loop_limiter_0_stall_out)
);

defparam loop_limiter_0.ENTRY_WIDTH = 1;
defparam loop_limiter_0.EXIT_WIDTH = 1;
defparam loop_limiter_0.THRESHOLD = 334;

gather_sys_cycle_time system_cycle_time_module (
	.clock(clock),
	.resetn(resetn),
	.cur_cycle(cur_cycle)
);


assign valid_out = bb_2_valid_out;
assign stall_out = bb_0_stall_out;
assign writes_pending[0] = bb_2_local_bb2_st_c0_exe2_active;
assign writes_pending[1] = bb_2_local_bb2_st_c0_exe18_active;
assign lsus_active[0] = bb_1_local_bb1_ld__active;
assign lsus_active[1] = bb_1_local_bb1_ld__u0_active;
assign lsus_active[2] = bb_2_local_bb2_ld__active;
assign lsus_active[3] = bb_2_local_bb2_st_c0_exe2_active;
assign lsus_active[4] = bb_2_local_bb2_st_c0_exe18_active;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		has_a_write_pending <= 1'b0;
		has_a_lsu_active <= 1'b0;
	end
	else
	begin
		has_a_write_pending <= (|writes_pending);
		has_a_lsu_active <= (|lsus_active);
	end
end

endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module gather_function_wrapper
	(
		input 		clock,
		input 		resetn,
		input 		clock2x,
		input 		local_router_hang,
		input 		avs_cra_read,
		input 		avs_cra_write,
		input [4:0] 		avs_cra_address,
		input [63:0] 		avs_cra_writedata,
		input [7:0] 		avs_cra_byteenable,
		output 		avs_cra_waitrequest,
		output reg [63:0] 		avs_cra_readdata,
		output reg 		avs_cra_readdatavalid,
		output 		cra_irq,
		input [255:0] 		avm_local_bb1_ld__inst0_readdata,
		input 		avm_local_bb1_ld__inst0_readdatavalid,
		input 		avm_local_bb1_ld__inst0_waitrequest,
		output [29:0] 		avm_local_bb1_ld__inst0_address,
		output 		avm_local_bb1_ld__inst0_read,
		output 		avm_local_bb1_ld__inst0_write,
		input 		avm_local_bb1_ld__inst0_writeack,
		output [255:0] 		avm_local_bb1_ld__inst0_writedata,
		output [31:0] 		avm_local_bb1_ld__inst0_byteenable,
		output [4:0] 		avm_local_bb1_ld__inst0_burstcount,
		input [255:0] 		avm_local_bb1_ld__u0_inst0_readdata,
		input 		avm_local_bb1_ld__u0_inst0_readdatavalid,
		input 		avm_local_bb1_ld__u0_inst0_waitrequest,
		output [29:0] 		avm_local_bb1_ld__u0_inst0_address,
		output 		avm_local_bb1_ld__u0_inst0_read,
		output 		avm_local_bb1_ld__u0_inst0_write,
		input 		avm_local_bb1_ld__u0_inst0_writeack,
		output [255:0] 		avm_local_bb1_ld__u0_inst0_writedata,
		output [31:0] 		avm_local_bb1_ld__u0_inst0_byteenable,
		output [4:0] 		avm_local_bb1_ld__u0_inst0_burstcount,
		input [255:0] 		avm_local_bb2_ld__inst0_readdata,
		input 		avm_local_bb2_ld__inst0_readdatavalid,
		input 		avm_local_bb2_ld__inst0_waitrequest,
		output [29:0] 		avm_local_bb2_ld__inst0_address,
		output 		avm_local_bb2_ld__inst0_read,
		output 		avm_local_bb2_ld__inst0_write,
		input 		avm_local_bb2_ld__inst0_writeack,
		output [255:0] 		avm_local_bb2_ld__inst0_writedata,
		output [31:0] 		avm_local_bb2_ld__inst0_byteenable,
		output [4:0] 		avm_local_bb2_ld__inst0_burstcount,
		input [255:0] 		avm_local_bb2_st_c0_exe2_inst0_readdata,
		input 		avm_local_bb2_st_c0_exe2_inst0_readdatavalid,
		input 		avm_local_bb2_st_c0_exe2_inst0_waitrequest,
		output [29:0] 		avm_local_bb2_st_c0_exe2_inst0_address,
		output 		avm_local_bb2_st_c0_exe2_inst0_read,
		output 		avm_local_bb2_st_c0_exe2_inst0_write,
		input 		avm_local_bb2_st_c0_exe2_inst0_writeack,
		output [255:0] 		avm_local_bb2_st_c0_exe2_inst0_writedata,
		output [31:0] 		avm_local_bb2_st_c0_exe2_inst0_byteenable,
		output [4:0] 		avm_local_bb2_st_c0_exe2_inst0_burstcount,
		input [255:0] 		avm_local_bb2_st_c0_exe18_inst0_readdata,
		input 		avm_local_bb2_st_c0_exe18_inst0_readdatavalid,
		input 		avm_local_bb2_st_c0_exe18_inst0_waitrequest,
		output [29:0] 		avm_local_bb2_st_c0_exe18_inst0_address,
		output 		avm_local_bb2_st_c0_exe18_inst0_read,
		output 		avm_local_bb2_st_c0_exe18_inst0_write,
		input 		avm_local_bb2_st_c0_exe18_inst0_writeack,
		output [255:0] 		avm_local_bb2_st_c0_exe18_inst0_writedata,
		output [31:0] 		avm_local_bb2_st_c0_exe18_inst0_byteenable,
		output [4:0] 		avm_local_bb2_st_c0_exe18_inst0_burstcount
	);

// Responsible for interfacing a kernel with the outside world. It comprises a
// slave interface to specify the kernel arguments and retain kernel status. 

// This section of the wrapper implements the slave interface.
// twoXclock_consumer uses clock2x, even if nobody inside the kernel does. Keeps interface to acl_iface consistent for all kernels.
 reg start_NO_SHIFT_REG;
 reg started_NO_SHIFT_REG;
wire finish;
 reg [31:0] status_NO_SHIFT_REG;
wire has_a_write_pending;
wire has_a_lsu_active;
 reg [287:0] kernel_arguments_NO_SHIFT_REG;
 reg twoXclock_consumer_NO_SHIFT_REG /* synthesis  preserve  noprune  */;
 reg [31:0] workgroup_size_NO_SHIFT_REG;
 reg [31:0] global_size_NO_SHIFT_REG[2:0];
 reg [31:0] num_groups_NO_SHIFT_REG[2:0];
 reg [31:0] local_size_NO_SHIFT_REG[2:0];
 reg [31:0] work_dim_NO_SHIFT_REG;
 reg [31:0] global_offset_NO_SHIFT_REG[2:0];
 reg [63:0] profile_data_NO_SHIFT_REG;
 reg [31:0] profile_ctrl_NO_SHIFT_REG;
 reg [63:0] profile_start_cycle_NO_SHIFT_REG;
 reg [63:0] profile_stop_cycle_NO_SHIFT_REG;
wire dispatched_all_groups;
wire [31:0] group_id_tmp[2:0];
wire [31:0] global_id_base_out[2:0];
wire start_out;
wire [31:0] local_id[0:0][2:0];
wire [31:0] global_id[0:0][2:0];
wire [31:0] group_id[0:0][2:0];
wire iter_valid_in;
wire iter_stall_out;
wire stall_in;
wire stall_out;
wire valid_in;
wire valid_out;

always @(posedge clock2x or negedge resetn)
begin
	if (~(resetn))
	begin
		twoXclock_consumer_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		twoXclock_consumer_NO_SHIFT_REG <= 1'b1;
	end
end



// Work group dispatcher is responsible for issuing work-groups to id iterator(s)
acl_work_group_dispatcher group_dispatcher (
	.clock(clock),
	.resetn(resetn),
	.start(start_NO_SHIFT_REG),
	.num_groups(num_groups_NO_SHIFT_REG),
	.local_size(local_size_NO_SHIFT_REG),
	.stall_in(iter_stall_out),
	.valid_out(iter_valid_in),
	.group_id_out(group_id_tmp),
	.global_id_base_out(global_id_base_out),
	.start_out(start_out),
	.dispatched_all_groups(dispatched_all_groups)
);

defparam group_dispatcher.NUM_COPIES = 1;
defparam group_dispatcher.RUN_FOREVER = 0;


// This section of the wrapper implements an Avalon Slave Interface used to configure a kernel invocation.
// The few words words contain the status and the workgroup size registers.
// The remaining addressable space is reserved for kernel arguments.
wire [63:0] bitenable;

assign bitenable[7:0] = (avs_cra_byteenable[0] ? 8'hFF : 8'h0);
assign bitenable[15:8] = (avs_cra_byteenable[1] ? 8'hFF : 8'h0);
assign bitenable[23:16] = (avs_cra_byteenable[2] ? 8'hFF : 8'h0);
assign bitenable[31:24] = (avs_cra_byteenable[3] ? 8'hFF : 8'h0);
assign bitenable[39:32] = (avs_cra_byteenable[4] ? 8'hFF : 8'h0);
assign bitenable[47:40] = (avs_cra_byteenable[5] ? 8'hFF : 8'h0);
assign bitenable[55:48] = (avs_cra_byteenable[6] ? 8'hFF : 8'h0);
assign bitenable[63:56] = (avs_cra_byteenable[7] ? 8'hFF : 8'h0);
assign avs_cra_waitrequest = 1'b0;
assign cra_irq = (status_NO_SHIFT_REG[1] | status_NO_SHIFT_REG[3]);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		start_NO_SHIFT_REG <= 1'b0;
		started_NO_SHIFT_REG <= 1'b0;
		kernel_arguments_NO_SHIFT_REG <= 288'h0;
		status_NO_SHIFT_REG <= 32'h30000;
		profile_ctrl_NO_SHIFT_REG <= 32'h4;
		profile_start_cycle_NO_SHIFT_REG <= 64'h0;
		profile_stop_cycle_NO_SHIFT_REG <= 64'hFFFFFFFFFFFFFFFF;
		work_dim_NO_SHIFT_REG <= 32'h0;
		workgroup_size_NO_SHIFT_REG <= 32'h0;
		global_size_NO_SHIFT_REG[0] <= 32'h0;
		global_size_NO_SHIFT_REG[1] <= 32'h0;
		global_size_NO_SHIFT_REG[2] <= 32'h0;
		num_groups_NO_SHIFT_REG[0] <= 32'h0;
		num_groups_NO_SHIFT_REG[1] <= 32'h0;
		num_groups_NO_SHIFT_REG[2] <= 32'h0;
		local_size_NO_SHIFT_REG[0] <= 32'h0;
		local_size_NO_SHIFT_REG[1] <= 32'h0;
		local_size_NO_SHIFT_REG[2] <= 32'h0;
		global_offset_NO_SHIFT_REG[0] <= 32'h0;
		global_offset_NO_SHIFT_REG[1] <= 32'h0;
		global_offset_NO_SHIFT_REG[2] <= 32'h0;
	end
	else
	begin
		if (avs_cra_write)
		begin
			case (avs_cra_address)
				5'h0:
				begin
					status_NO_SHIFT_REG[31:16] <= 16'h3;
					status_NO_SHIFT_REG[15:0] <= ((status_NO_SHIFT_REG[15:0] & ~(bitenable[15:0])) | (avs_cra_writedata[15:0] & bitenable[15:0]));
				end

				5'h1:
				begin
					profile_ctrl_NO_SHIFT_REG <= ((profile_ctrl_NO_SHIFT_REG & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'h3:
				begin
					profile_start_cycle_NO_SHIFT_REG[31:0] <= ((profile_start_cycle_NO_SHIFT_REG[31:0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					profile_start_cycle_NO_SHIFT_REG[63:32] <= ((profile_start_cycle_NO_SHIFT_REG[63:32] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'h4:
				begin
					profile_stop_cycle_NO_SHIFT_REG[31:0] <= ((profile_stop_cycle_NO_SHIFT_REG[31:0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					profile_stop_cycle_NO_SHIFT_REG[63:32] <= ((profile_stop_cycle_NO_SHIFT_REG[63:32] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'h5:
				begin
					work_dim_NO_SHIFT_REG <= ((work_dim_NO_SHIFT_REG & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					workgroup_size_NO_SHIFT_REG <= ((workgroup_size_NO_SHIFT_REG & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'h6:
				begin
					global_size_NO_SHIFT_REG[0] <= ((global_size_NO_SHIFT_REG[0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					global_size_NO_SHIFT_REG[1] <= ((global_size_NO_SHIFT_REG[1] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'h7:
				begin
					global_size_NO_SHIFT_REG[2] <= ((global_size_NO_SHIFT_REG[2] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					num_groups_NO_SHIFT_REG[0] <= ((num_groups_NO_SHIFT_REG[0] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'h8:
				begin
					num_groups_NO_SHIFT_REG[1] <= ((num_groups_NO_SHIFT_REG[1] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					num_groups_NO_SHIFT_REG[2] <= ((num_groups_NO_SHIFT_REG[2] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'h9:
				begin
					local_size_NO_SHIFT_REG[0] <= ((local_size_NO_SHIFT_REG[0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					local_size_NO_SHIFT_REG[1] <= ((local_size_NO_SHIFT_REG[1] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'hA:
				begin
					local_size_NO_SHIFT_REG[2] <= ((local_size_NO_SHIFT_REG[2] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					global_offset_NO_SHIFT_REG[0] <= ((global_offset_NO_SHIFT_REG[0] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'hB:
				begin
					global_offset_NO_SHIFT_REG[1] <= ((global_offset_NO_SHIFT_REG[1] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					global_offset_NO_SHIFT_REG[2] <= ((global_offset_NO_SHIFT_REG[2] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'hC:
				begin
					kernel_arguments_NO_SHIFT_REG[31:0] <= ((kernel_arguments_NO_SHIFT_REG[31:0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					kernel_arguments_NO_SHIFT_REG[63:32] <= ((kernel_arguments_NO_SHIFT_REG[63:32] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'hD:
				begin
					kernel_arguments_NO_SHIFT_REG[95:64] <= ((kernel_arguments_NO_SHIFT_REG[95:64] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					kernel_arguments_NO_SHIFT_REG[127:96] <= ((kernel_arguments_NO_SHIFT_REG[127:96] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'hE:
				begin
					kernel_arguments_NO_SHIFT_REG[159:128] <= ((kernel_arguments_NO_SHIFT_REG[159:128] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					kernel_arguments_NO_SHIFT_REG[191:160] <= ((kernel_arguments_NO_SHIFT_REG[191:160] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'hF:
				begin
					kernel_arguments_NO_SHIFT_REG[223:192] <= ((kernel_arguments_NO_SHIFT_REG[223:192] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					kernel_arguments_NO_SHIFT_REG[255:224] <= ((kernel_arguments_NO_SHIFT_REG[255:224] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				5'h10:
				begin
					kernel_arguments_NO_SHIFT_REG[287:256] <= ((kernel_arguments_NO_SHIFT_REG[287:256] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
				end

				default:
				begin
				end

			endcase
		end
		else
		begin
			if (status_NO_SHIFT_REG[0])
			begin
				start_NO_SHIFT_REG <= 1'b1;
			end
			if (start_NO_SHIFT_REG)
			begin
				status_NO_SHIFT_REG[0] <= 1'b0;
				started_NO_SHIFT_REG <= 1'b1;
			end
			if (started_NO_SHIFT_REG)
			begin
				start_NO_SHIFT_REG <= 1'b0;
			end
			if (finish)
			begin
				status_NO_SHIFT_REG[1] <= 1'b1;
				started_NO_SHIFT_REG <= 1'b0;
			end
		end
		status_NO_SHIFT_REG[11] <= local_router_hang;
		status_NO_SHIFT_REG[12] <= (|has_a_lsu_active);
		status_NO_SHIFT_REG[13] <= (|has_a_write_pending);
		status_NO_SHIFT_REG[14] <= (|valid_in);
		status_NO_SHIFT_REG[15] <= started_NO_SHIFT_REG;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		avs_cra_readdata <= 64'h0;
	end
	else
	begin
		case (avs_cra_address)
			5'h0:
			begin
				avs_cra_readdata[31:0] <= status_NO_SHIFT_REG;
				avs_cra_readdata[63:32] <= 32'h0;
			end

			5'h1:
			begin
				avs_cra_readdata[31:0] <= 'x;
				avs_cra_readdata[63:32] <= 32'h0;
			end

			5'h2:
			begin
				avs_cra_readdata[63:0] <= 64'h0;
			end

			5'h3:
			begin
				avs_cra_readdata[63:0] <= 64'h0;
			end

			5'h4:
			begin
				avs_cra_readdata[63:0] <= 64'h0;
			end

			5'h5:
			begin
				avs_cra_readdata[31:0] <= work_dim_NO_SHIFT_REG;
				avs_cra_readdata[63:32] <= workgroup_size_NO_SHIFT_REG;
			end

			5'h6:
			begin
				avs_cra_readdata[31:0] <= global_size_NO_SHIFT_REG[0];
				avs_cra_readdata[63:32] <= global_size_NO_SHIFT_REG[1];
			end

			5'h7:
			begin
				avs_cra_readdata[31:0] <= global_size_NO_SHIFT_REG[2];
				avs_cra_readdata[63:32] <= num_groups_NO_SHIFT_REG[0];
			end

			5'h8:
			begin
				avs_cra_readdata[31:0] <= num_groups_NO_SHIFT_REG[1];
				avs_cra_readdata[63:32] <= num_groups_NO_SHIFT_REG[2];
			end

			5'h9:
			begin
				avs_cra_readdata[31:0] <= local_size_NO_SHIFT_REG[0];
				avs_cra_readdata[63:32] <= local_size_NO_SHIFT_REG[1];
			end

			5'hA:
			begin
				avs_cra_readdata[31:0] <= local_size_NO_SHIFT_REG[2];
				avs_cra_readdata[63:32] <= global_offset_NO_SHIFT_REG[0];
			end

			5'hB:
			begin
				avs_cra_readdata[31:0] <= global_offset_NO_SHIFT_REG[1];
				avs_cra_readdata[63:32] <= global_offset_NO_SHIFT_REG[2];
			end

			5'hC:
			begin
				avs_cra_readdata[31:0] <= kernel_arguments_NO_SHIFT_REG[31:0];
				avs_cra_readdata[63:32] <= kernel_arguments_NO_SHIFT_REG[63:32];
			end

			5'hD:
			begin
				avs_cra_readdata[31:0] <= kernel_arguments_NO_SHIFT_REG[95:64];
				avs_cra_readdata[63:32] <= kernel_arguments_NO_SHIFT_REG[127:96];
			end

			5'hE:
			begin
				avs_cra_readdata[31:0] <= kernel_arguments_NO_SHIFT_REG[159:128];
				avs_cra_readdata[63:32] <= kernel_arguments_NO_SHIFT_REG[191:160];
			end

			5'hF:
			begin
				avs_cra_readdata[31:0] <= kernel_arguments_NO_SHIFT_REG[223:192];
				avs_cra_readdata[63:32] <= kernel_arguments_NO_SHIFT_REG[255:224];
			end

			5'h10:
			begin
				avs_cra_readdata[31:0] <= kernel_arguments_NO_SHIFT_REG[287:256];
				avs_cra_readdata[63:32] <= 32'h0;
			end

			default:
			begin
				avs_cra_readdata <= status_NO_SHIFT_REG;
			end

		endcase
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		avs_cra_readdatavalid <= 1'b0;
	end
	else
	begin
		avs_cra_readdatavalid <= (avs_cra_read & ~(avs_cra_waitrequest));
	end
end


// Handshaking signals used to control data through the pipeline

// Determine when the kernel is finished.
acl_kernel_finish_detector kernel_finish_detector (
	.clock(clock),
	.resetn(resetn),
	.start(start_NO_SHIFT_REG),
	.wg_size(workgroup_size_NO_SHIFT_REG),
	.wg_dispatch_valid_out(iter_valid_in),
	.wg_dispatch_stall_in(iter_stall_out),
	.dispatched_all_groups(dispatched_all_groups),
	.kernel_copy_valid_out(valid_out),
	.kernel_copy_stall_in(stall_in),
	.pending_writes(has_a_write_pending),
	.finish(finish)
);

defparam kernel_finish_detector.NUM_COPIES = 1;
defparam kernel_finish_detector.WG_SIZE_W = 32;

assign stall_in = 1'b0;

// Creating ID iterator and kernel instance for every requested kernel copy

// ID iterator is responsible for iterating over all local ids for given work-groups
acl_id_iterator id_iter_inst0 (
	.clock(clock),
	.resetn(resetn),
	.start(start_out),
	.valid_in(iter_valid_in),
	.stall_out(iter_stall_out),
	.stall_in(stall_out),
	.valid_out(valid_in),
	.group_id_in(group_id_tmp),
	.global_id_base_in(global_id_base_out),
	.local_size(local_size_NO_SHIFT_REG),
	.global_size(global_size_NO_SHIFT_REG),
	.local_id(local_id[0]),
	.global_id(global_id[0]),
	.group_id(group_id[0])
);



// This section instantiates a kernel function block
gather_function gather_function_inst0 (
	.clock(clock),
	.resetn(resetn),
	.input_global_id_0(global_id[0][0]),
	.stall_out(stall_out),
	.valid_in(valid_in),
	.valid_out(valid_out),
	.stall_in(stall_in),
	.workgroup_size(workgroup_size_NO_SHIFT_REG),
	.avm_local_bb1_ld__readdata(avm_local_bb1_ld__inst0_readdata),
	.avm_local_bb1_ld__readdatavalid(avm_local_bb1_ld__inst0_readdatavalid),
	.avm_local_bb1_ld__waitrequest(avm_local_bb1_ld__inst0_waitrequest),
	.avm_local_bb1_ld__address(avm_local_bb1_ld__inst0_address),
	.avm_local_bb1_ld__read(avm_local_bb1_ld__inst0_read),
	.avm_local_bb1_ld__write(avm_local_bb1_ld__inst0_write),
	.avm_local_bb1_ld__writeack(avm_local_bb1_ld__inst0_writeack),
	.avm_local_bb1_ld__writedata(avm_local_bb1_ld__inst0_writedata),
	.avm_local_bb1_ld__byteenable(avm_local_bb1_ld__inst0_byteenable),
	.avm_local_bb1_ld__burstcount(avm_local_bb1_ld__inst0_burstcount),
	.avm_local_bb1_ld__u0_readdata(avm_local_bb1_ld__u0_inst0_readdata),
	.avm_local_bb1_ld__u0_readdatavalid(avm_local_bb1_ld__u0_inst0_readdatavalid),
	.avm_local_bb1_ld__u0_waitrequest(avm_local_bb1_ld__u0_inst0_waitrequest),
	.avm_local_bb1_ld__u0_address(avm_local_bb1_ld__u0_inst0_address),
	.avm_local_bb1_ld__u0_read(avm_local_bb1_ld__u0_inst0_read),
	.avm_local_bb1_ld__u0_write(avm_local_bb1_ld__u0_inst0_write),
	.avm_local_bb1_ld__u0_writeack(avm_local_bb1_ld__u0_inst0_writeack),
	.avm_local_bb1_ld__u0_writedata(avm_local_bb1_ld__u0_inst0_writedata),
	.avm_local_bb1_ld__u0_byteenable(avm_local_bb1_ld__u0_inst0_byteenable),
	.avm_local_bb1_ld__u0_burstcount(avm_local_bb1_ld__u0_inst0_burstcount),
	.avm_local_bb2_ld__readdata(avm_local_bb2_ld__inst0_readdata),
	.avm_local_bb2_ld__readdatavalid(avm_local_bb2_ld__inst0_readdatavalid),
	.avm_local_bb2_ld__waitrequest(avm_local_bb2_ld__inst0_waitrequest),
	.avm_local_bb2_ld__address(avm_local_bb2_ld__inst0_address),
	.avm_local_bb2_ld__read(avm_local_bb2_ld__inst0_read),
	.avm_local_bb2_ld__write(avm_local_bb2_ld__inst0_write),
	.avm_local_bb2_ld__writeack(avm_local_bb2_ld__inst0_writeack),
	.avm_local_bb2_ld__writedata(avm_local_bb2_ld__inst0_writedata),
	.avm_local_bb2_ld__byteenable(avm_local_bb2_ld__inst0_byteenable),
	.avm_local_bb2_ld__burstcount(avm_local_bb2_ld__inst0_burstcount),
	.avm_local_bb2_st_c0_exe2_readdata(avm_local_bb2_st_c0_exe2_inst0_readdata),
	.avm_local_bb2_st_c0_exe2_readdatavalid(avm_local_bb2_st_c0_exe2_inst0_readdatavalid),
	.avm_local_bb2_st_c0_exe2_waitrequest(avm_local_bb2_st_c0_exe2_inst0_waitrequest),
	.avm_local_bb2_st_c0_exe2_address(avm_local_bb2_st_c0_exe2_inst0_address),
	.avm_local_bb2_st_c0_exe2_read(avm_local_bb2_st_c0_exe2_inst0_read),
	.avm_local_bb2_st_c0_exe2_write(avm_local_bb2_st_c0_exe2_inst0_write),
	.avm_local_bb2_st_c0_exe2_writeack(avm_local_bb2_st_c0_exe2_inst0_writeack),
	.avm_local_bb2_st_c0_exe2_writedata(avm_local_bb2_st_c0_exe2_inst0_writedata),
	.avm_local_bb2_st_c0_exe2_byteenable(avm_local_bb2_st_c0_exe2_inst0_byteenable),
	.avm_local_bb2_st_c0_exe2_burstcount(avm_local_bb2_st_c0_exe2_inst0_burstcount),
	.avm_local_bb2_st_c0_exe18_readdata(avm_local_bb2_st_c0_exe18_inst0_readdata),
	.avm_local_bb2_st_c0_exe18_readdatavalid(avm_local_bb2_st_c0_exe18_inst0_readdatavalid),
	.avm_local_bb2_st_c0_exe18_waitrequest(avm_local_bb2_st_c0_exe18_inst0_waitrequest),
	.avm_local_bb2_st_c0_exe18_address(avm_local_bb2_st_c0_exe18_inst0_address),
	.avm_local_bb2_st_c0_exe18_read(avm_local_bb2_st_c0_exe18_inst0_read),
	.avm_local_bb2_st_c0_exe18_write(avm_local_bb2_st_c0_exe18_inst0_write),
	.avm_local_bb2_st_c0_exe18_writeack(avm_local_bb2_st_c0_exe18_inst0_writeack),
	.avm_local_bb2_st_c0_exe18_writedata(avm_local_bb2_st_c0_exe18_inst0_writedata),
	.avm_local_bb2_st_c0_exe18_byteenable(avm_local_bb2_st_c0_exe18_inst0_byteenable),
	.avm_local_bb2_st_c0_exe18_burstcount(avm_local_bb2_st_c0_exe18_inst0_burstcount),
	.start(start_out),
	.input_num_edges(kernel_arguments_NO_SHIFT_REG[223:192]),
	.input_num_nodes(kernel_arguments_NO_SHIFT_REG[255:224]),
	.clock2x(clock2x),
	.input_msg_arr(kernel_arguments_NO_SHIFT_REG[63:0]),
	.input_rank(kernel_arguments_NO_SHIFT_REG[127:64]),
	.input_err_arr(kernel_arguments_NO_SHIFT_REG[191:128]),
	.input_global_size_0(global_size_NO_SHIFT_REG[0]),
	.input_sink_val(kernel_arguments_NO_SHIFT_REG[287:256]),
	.has_a_write_pending(has_a_write_pending),
	.has_a_lsu_active(has_a_lsu_active)
);



endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module gather_sys_cycle_time
	(
		input 		clock,
		input 		resetn,
		output [31:0] 		cur_cycle
	);


 reg [31:0] cur_count_NO_SHIFT_REG;

assign cur_cycle = cur_count_NO_SHIFT_REG;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		cur_count_NO_SHIFT_REG <= 32'h0;
	end
	else
	begin
		cur_count_NO_SHIFT_REG <= (cur_count_NO_SHIFT_REG + 32'h1);
	end
end

endmodule

