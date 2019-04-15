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

module fpgasort_basic_block_0
	(
		input 		clock,
		input 		resetn,
		input 		start,
		input [31:0] 		input_N,
		input 		valid_in,
		output 		stall_out,
		input [31:0] 		input_global_id_0,
		input [31:0] 		input_acl_hw_wg_id,
		output 		valid_out,
		input 		stall_in,
		output 		lvb_bb0_cmp1,
		output 		lvb_bb0_cmp1_NEG,
		output [31:0] 		lvb_input_global_id_0,
		output [31:0] 		lvb_input_acl_hw_wg_id,
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
wire merge_stalled_by_successors;
 reg merge_block_selector_NO_SHIFT_REG;
 reg merge_node_valid_in_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_global_id_0_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_acl_hw_wg_id_staging_reg_NO_SHIFT_REG;
 reg [31:0] local_lvm_input_global_id_0_NO_SHIFT_REG;
 reg [31:0] local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG;
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
		input_global_id_0_staging_reg_NO_SHIFT_REG <= 'x;
		input_acl_hw_wg_id_staging_reg_NO_SHIFT_REG <= 'x;
		merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (((merge_block_selector_NO_SHIFT_REG != 1'b0) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_staging_reg_NO_SHIFT_REG))
			begin
				input_global_id_0_staging_reg_NO_SHIFT_REG <= input_global_id_0;
				input_acl_hw_wg_id_staging_reg_NO_SHIFT_REG <= input_acl_hw_wg_id;
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
					local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG <= input_acl_hw_wg_id_staging_reg_NO_SHIFT_REG;
				end
				else
				begin
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0;
					local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG <= input_acl_hw_wg_id;
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


// This section implements a registered operation.
// 
wire local_bb0_cmp1_inputs_ready;
 reg local_bb0_cmp1_wii_reg_NO_SHIFT_REG;
 reg local_bb0_cmp1_valid_out_0_NO_SHIFT_REG;
wire local_bb0_cmp1_stall_in_0;
 reg local_bb0_cmp1_valid_out_1_NO_SHIFT_REG;
wire local_bb0_cmp1_stall_in_1;
wire local_bb0_cmp1_output_regs_ready;
 reg local_bb0_cmp1_NO_SHIFT_REG;
wire local_bb0_cmp1_causedstall;

assign local_bb0_cmp1_inputs_ready = merge_node_valid_out_0_NO_SHIFT_REG;
assign local_bb0_cmp1_output_regs_ready = (~(local_bb0_cmp1_wii_reg_NO_SHIFT_REG) & ((~(local_bb0_cmp1_valid_out_0_NO_SHIFT_REG) | ~(local_bb0_cmp1_stall_in_0)) & (~(local_bb0_cmp1_valid_out_1_NO_SHIFT_REG) | ~(local_bb0_cmp1_stall_in_1))));
assign merge_node_stall_in_0 = (~(local_bb0_cmp1_wii_reg_NO_SHIFT_REG) & (~(local_bb0_cmp1_output_regs_ready) | ~(local_bb0_cmp1_inputs_ready)));
assign local_bb0_cmp1_causedstall = (local_bb0_cmp1_inputs_ready && (~(local_bb0_cmp1_output_regs_ready) && !(~(local_bb0_cmp1_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_cmp1_NO_SHIFT_REG <= 'x;
		local_bb0_cmp1_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb0_cmp1_valid_out_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_cmp1_NO_SHIFT_REG <= 'x;
			local_bb0_cmp1_valid_out_0_NO_SHIFT_REG <= 1'b0;
			local_bb0_cmp1_valid_out_1_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_cmp1_output_regs_ready)
			begin
				local_bb0_cmp1_NO_SHIFT_REG <= ($signed(input_N) > $signed(32'h0));
				local_bb0_cmp1_valid_out_0_NO_SHIFT_REG <= local_bb0_cmp1_inputs_ready;
				local_bb0_cmp1_valid_out_1_NO_SHIFT_REG <= local_bb0_cmp1_inputs_ready;
			end
			else
			begin
				if (~(local_bb0_cmp1_stall_in_0))
				begin
					local_bb0_cmp1_valid_out_0_NO_SHIFT_REG <= local_bb0_cmp1_wii_reg_NO_SHIFT_REG;
				end
				if (~(local_bb0_cmp1_stall_in_1))
				begin
					local_bb0_cmp1_valid_out_1_NO_SHIFT_REG <= local_bb0_cmp1_wii_reg_NO_SHIFT_REG;
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
wire local_bb0_cmp1_NEG_inputs_ready;
 reg local_bb0_cmp1_NEG_wii_reg_NO_SHIFT_REG;
 reg local_bb0_cmp1_NEG_valid_out_NO_SHIFT_REG;
wire local_bb0_cmp1_NEG_stall_in;
wire local_bb0_cmp1_NEG_output_regs_ready;
 reg local_bb0_cmp1_NEG_NO_SHIFT_REG;
wire local_bb0_cmp1_NEG_causedstall;

assign local_bb0_cmp1_NEG_inputs_ready = local_bb0_cmp1_valid_out_0_NO_SHIFT_REG;
assign local_bb0_cmp1_NEG_output_regs_ready = (~(local_bb0_cmp1_NEG_wii_reg_NO_SHIFT_REG) & (&(~(local_bb0_cmp1_NEG_valid_out_NO_SHIFT_REG) | ~(local_bb0_cmp1_NEG_stall_in))));
assign local_bb0_cmp1_stall_in_0 = (~(local_bb0_cmp1_NEG_wii_reg_NO_SHIFT_REG) & (~(local_bb0_cmp1_NEG_output_regs_ready) | ~(local_bb0_cmp1_NEG_inputs_ready)));
assign local_bb0_cmp1_NEG_causedstall = (local_bb0_cmp1_NEG_inputs_ready && (~(local_bb0_cmp1_NEG_output_regs_ready) && !(~(local_bb0_cmp1_NEG_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_cmp1_NEG_NO_SHIFT_REG <= 'x;
		local_bb0_cmp1_NEG_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_cmp1_NEG_NO_SHIFT_REG <= 'x;
			local_bb0_cmp1_NEG_valid_out_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_cmp1_NEG_output_regs_ready)
			begin
				local_bb0_cmp1_NEG_NO_SHIFT_REG <= (local_bb0_cmp1_NO_SHIFT_REG ^ 1'b1);
				local_bb0_cmp1_NEG_valid_out_NO_SHIFT_REG <= local_bb0_cmp1_NEG_inputs_ready;
			end
			else
			begin
				if (~(local_bb0_cmp1_NEG_stall_in))
				begin
					local_bb0_cmp1_NEG_valid_out_NO_SHIFT_REG <= local_bb0_cmp1_NEG_wii_reg_NO_SHIFT_REG;
				end
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb0_cmp1_NEG_wii_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (start)
		begin
			local_bb0_cmp1_NEG_wii_reg_NO_SHIFT_REG <= 1'b0;
		end
		else
		begin
			if (local_bb0_cmp1_NEG_inputs_ready)
			begin
				local_bb0_cmp1_NEG_wii_reg_NO_SHIFT_REG <= 1'b1;
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
 reg lvb_bb0_cmp1_NEG_reg_NO_SHIFT_REG;
 reg [31:0] lvb_input_global_id_0_reg_NO_SHIFT_REG;
 reg [31:0] lvb_input_acl_hw_wg_id_reg_NO_SHIFT_REG;

assign branch_var__inputs_ready = (local_bb0_cmp1_NEG_valid_out_NO_SHIFT_REG & merge_node_valid_out_1_NO_SHIFT_REG & local_bb0_cmp1_valid_out_1_NO_SHIFT_REG);
assign branch_var__output_regs_ready = (~(stall_in) | ~(branch_node_valid_out_NO_SHIFT_REG));
assign local_bb0_cmp1_NEG_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign merge_node_stall_in_1 = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign local_bb0_cmp1_stall_in_1 = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign lvb_bb0_cmp1 = lvb_bb0_cmp1_reg_NO_SHIFT_REG;
assign lvb_bb0_cmp1_NEG = lvb_bb0_cmp1_NEG_reg_NO_SHIFT_REG;
assign lvb_input_global_id_0 = lvb_input_global_id_0_reg_NO_SHIFT_REG;
assign lvb_input_acl_hw_wg_id = lvb_input_acl_hw_wg_id_reg_NO_SHIFT_REG;
assign valid_out = branch_node_valid_out_NO_SHIFT_REG;
assign combined_branch_stall_in_signal = stall_in;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		branch_node_valid_out_NO_SHIFT_REG <= 1'b0;
		lvb_bb0_cmp1_reg_NO_SHIFT_REG <= 'x;
		lvb_bb0_cmp1_NEG_reg_NO_SHIFT_REG <= 'x;
		lvb_input_global_id_0_reg_NO_SHIFT_REG <= 'x;
		lvb_input_acl_hw_wg_id_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (branch_var__output_regs_ready)
		begin
			branch_node_valid_out_NO_SHIFT_REG <= branch_var__inputs_ready;
			lvb_bb0_cmp1_reg_NO_SHIFT_REG <= local_bb0_cmp1_NO_SHIFT_REG;
			lvb_bb0_cmp1_NEG_reg_NO_SHIFT_REG <= local_bb0_cmp1_NEG_NO_SHIFT_REG;
			lvb_input_global_id_0_reg_NO_SHIFT_REG <= local_lvm_input_global_id_0_NO_SHIFT_REG;
			lvb_input_acl_hw_wg_id_reg_NO_SHIFT_REG <= local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG;
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

module fpgasort_basic_block_1
	(
		input 		clock,
		input 		resetn,
		input [31:0] 		input_N,
		input 		input_wii_cmp1,
		input 		input_wii_cmp1_NEG,
		input 		valid_in,
		output 		stall_out,
		input [31:0] 		input_global_id_0,
		input [31:0] 		input_acl_hw_wg_id,
		output 		valid_out,
		input 		stall_in,
		output [31:0] 		lvb_bb1_var_,
		output [63:0] 		lvb_bb1_var__u0,
		output [31:0] 		lvb_bb1_add,
		output [31:0] 		lvb_input_global_id_0,
		output [31:0] 		lvb_input_acl_hw_wg_id,
		input [31:0] 		workgroup_size,
		input 		start
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
 reg [31:0] input_acl_hw_wg_id_staging_reg_NO_SHIFT_REG;
 reg [31:0] local_lvm_input_global_id_0_NO_SHIFT_REG;
 reg [31:0] local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG;
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
		input_acl_hw_wg_id_staging_reg_NO_SHIFT_REG <= 'x;
		merge_node_valid_in_staging_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (((merge_block_selector_NO_SHIFT_REG != 1'b0) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_staging_reg_NO_SHIFT_REG))
			begin
				input_global_id_0_staging_reg_NO_SHIFT_REG <= input_global_id_0;
				input_acl_hw_wg_id_staging_reg_NO_SHIFT_REG <= input_acl_hw_wg_id;
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
					local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG <= input_acl_hw_wg_id_staging_reg_NO_SHIFT_REG;
				end
				else
				begin
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0;
					local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG <= input_acl_hw_wg_id;
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
wire local_bb1_var__inputs_ready;
 reg local_bb1_var__valid_out_0_NO_SHIFT_REG;
wire local_bb1_var__stall_in_0;
 reg local_bb1_var__valid_out_1_NO_SHIFT_REG;
wire local_bb1_var__stall_in_1;
 reg local_bb1_var__valid_out_2_NO_SHIFT_REG;
wire local_bb1_var__stall_in_2;
wire local_bb1_var__output_regs_ready;
wire [31:0] local_bb1_var_;
 reg local_bb1_var__valid_pipe_0_NO_SHIFT_REG;
 reg local_bb1_var__valid_pipe_1_NO_SHIFT_REG;
wire local_bb1_var__causedstall;

acl_int_mult32s_s5 int_module_local_bb1_var_ (
	.clock(clock),
	.dataa(local_lvm_input_global_id_0_NO_SHIFT_REG),
	.datab(input_N),
	.enable(local_bb1_var__output_regs_ready),
	.result(local_bb1_var_)
);

defparam int_module_local_bb1_var_.INPUT1_WIDTH = 32;
defparam int_module_local_bb1_var_.INPUT2_WIDTH = 32;

assign local_bb1_var__inputs_ready = merge_node_valid_out_0_NO_SHIFT_REG;
assign local_bb1_var__output_regs_ready = ((~(local_bb1_var__valid_out_0_NO_SHIFT_REG) | ~(local_bb1_var__stall_in_0)) & (~(local_bb1_var__valid_out_1_NO_SHIFT_REG) | ~(local_bb1_var__stall_in_1)) & (~(local_bb1_var__valid_out_2_NO_SHIFT_REG) | ~(local_bb1_var__stall_in_2)));
assign merge_node_stall_in_0 = (~(local_bb1_var__output_regs_ready) | ~(local_bb1_var__inputs_ready));
assign local_bb1_var__causedstall = (local_bb1_var__inputs_ready && (~(local_bb1_var__output_regs_ready) && !(~(local_bb1_var__output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_var__valid_pipe_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_var__valid_pipe_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_var__output_regs_ready)
		begin
			local_bb1_var__valid_pipe_0_NO_SHIFT_REG <= local_bb1_var__inputs_ready;
			local_bb1_var__valid_pipe_1_NO_SHIFT_REG <= local_bb1_var__valid_pipe_0_NO_SHIFT_REG;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_var__valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_var__valid_out_1_NO_SHIFT_REG <= 1'b0;
		local_bb1_var__valid_out_2_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb1_var__output_regs_ready)
		begin
			local_bb1_var__valid_out_0_NO_SHIFT_REG <= local_bb1_var__valid_pipe_1_NO_SHIFT_REG;
			local_bb1_var__valid_out_1_NO_SHIFT_REG <= local_bb1_var__valid_pipe_1_NO_SHIFT_REG;
			local_bb1_var__valid_out_2_NO_SHIFT_REG <= local_bb1_var__valid_pipe_1_NO_SHIFT_REG;
		end
		else
		begin
			if (~(local_bb1_var__stall_in_0))
			begin
				local_bb1_var__valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_var__stall_in_1))
			begin
				local_bb1_var__valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb1_var__stall_in_2))
			begin
				local_bb1_var__valid_out_2_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// Register node:
//  * latency = 3
//  * capacity = 3
 logic rnode_1to4_input_global_id_0_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to4_input_global_id_0_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_1to4_input_global_id_0_0_NO_SHIFT_REG;
 logic rnode_1to4_input_global_id_0_0_reg_4_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_1to4_input_global_id_0_0_reg_4_NO_SHIFT_REG;
 logic rnode_1to4_input_global_id_0_0_valid_out_reg_4_NO_SHIFT_REG;
 logic rnode_1to4_input_global_id_0_0_stall_in_reg_4_NO_SHIFT_REG;
 logic rnode_1to4_input_global_id_0_0_stall_out_reg_4_NO_SHIFT_REG;

acl_data_fifo rnode_1to4_input_global_id_0_0_reg_4_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to4_input_global_id_0_0_reg_4_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to4_input_global_id_0_0_stall_in_reg_4_NO_SHIFT_REG),
	.valid_out(rnode_1to4_input_global_id_0_0_valid_out_reg_4_NO_SHIFT_REG),
	.stall_out(rnode_1to4_input_global_id_0_0_stall_out_reg_4_NO_SHIFT_REG),
	.data_in(local_lvm_input_global_id_0_NO_SHIFT_REG),
	.data_out(rnode_1to4_input_global_id_0_0_reg_4_NO_SHIFT_REG)
);

defparam rnode_1to4_input_global_id_0_0_reg_4_fifo.DEPTH = 4;
defparam rnode_1to4_input_global_id_0_0_reg_4_fifo.DATA_WIDTH = 32;
defparam rnode_1to4_input_global_id_0_0_reg_4_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to4_input_global_id_0_0_reg_4_fifo.IMPL = "ll_reg";

assign rnode_1to4_input_global_id_0_0_reg_4_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_1_NO_SHIFT_REG;
assign merge_node_stall_in_1 = rnode_1to4_input_global_id_0_0_stall_out_reg_4_NO_SHIFT_REG;
assign rnode_1to4_input_global_id_0_0_NO_SHIFT_REG = rnode_1to4_input_global_id_0_0_reg_4_NO_SHIFT_REG;
assign rnode_1to4_input_global_id_0_0_stall_in_reg_4_NO_SHIFT_REG = rnode_1to4_input_global_id_0_0_stall_in_NO_SHIFT_REG;
assign rnode_1to4_input_global_id_0_0_valid_out_NO_SHIFT_REG = rnode_1to4_input_global_id_0_0_valid_out_reg_4_NO_SHIFT_REG;

// Register node:
//  * latency = 3
//  * capacity = 3
 logic rnode_1to4_input_acl_hw_wg_id_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to4_input_acl_hw_wg_id_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_1to4_input_acl_hw_wg_id_0_NO_SHIFT_REG;
 logic rnode_1to4_input_acl_hw_wg_id_0_reg_4_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_1to4_input_acl_hw_wg_id_0_reg_4_NO_SHIFT_REG;
 logic rnode_1to4_input_acl_hw_wg_id_0_valid_out_reg_4_NO_SHIFT_REG;
 logic rnode_1to4_input_acl_hw_wg_id_0_stall_in_reg_4_NO_SHIFT_REG;
 logic rnode_1to4_input_acl_hw_wg_id_0_stall_out_reg_4_NO_SHIFT_REG;

acl_data_fifo rnode_1to4_input_acl_hw_wg_id_0_reg_4_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to4_input_acl_hw_wg_id_0_reg_4_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to4_input_acl_hw_wg_id_0_stall_in_reg_4_NO_SHIFT_REG),
	.valid_out(rnode_1to4_input_acl_hw_wg_id_0_valid_out_reg_4_NO_SHIFT_REG),
	.stall_out(rnode_1to4_input_acl_hw_wg_id_0_stall_out_reg_4_NO_SHIFT_REG),
	.data_in(local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG),
	.data_out(rnode_1to4_input_acl_hw_wg_id_0_reg_4_NO_SHIFT_REG)
);

defparam rnode_1to4_input_acl_hw_wg_id_0_reg_4_fifo.DEPTH = 4;
defparam rnode_1to4_input_acl_hw_wg_id_0_reg_4_fifo.DATA_WIDTH = 32;
defparam rnode_1to4_input_acl_hw_wg_id_0_reg_4_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to4_input_acl_hw_wg_id_0_reg_4_fifo.IMPL = "ll_reg";

assign rnode_1to4_input_acl_hw_wg_id_0_reg_4_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_2_NO_SHIFT_REG;
assign merge_node_stall_in_2 = rnode_1to4_input_acl_hw_wg_id_0_stall_out_reg_4_NO_SHIFT_REG;
assign rnode_1to4_input_acl_hw_wg_id_0_NO_SHIFT_REG = rnode_1to4_input_acl_hw_wg_id_0_reg_4_NO_SHIFT_REG;
assign rnode_1to4_input_acl_hw_wg_id_0_stall_in_reg_4_NO_SHIFT_REG = rnode_1to4_input_acl_hw_wg_id_0_stall_in_NO_SHIFT_REG;
assign rnode_1to4_input_acl_hw_wg_id_0_valid_out_NO_SHIFT_REG = rnode_1to4_input_acl_hw_wg_id_0_valid_out_reg_4_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb1_var__u0_stall_local;
wire [63:0] local_bb1_var__u0;

assign local_bb1_var__u0[32] = local_bb1_var_[31];
assign local_bb1_var__u0[33] = local_bb1_var_[31];
assign local_bb1_var__u0[34] = local_bb1_var_[31];
assign local_bb1_var__u0[35] = local_bb1_var_[31];
assign local_bb1_var__u0[36] = local_bb1_var_[31];
assign local_bb1_var__u0[37] = local_bb1_var_[31];
assign local_bb1_var__u0[38] = local_bb1_var_[31];
assign local_bb1_var__u0[39] = local_bb1_var_[31];
assign local_bb1_var__u0[40] = local_bb1_var_[31];
assign local_bb1_var__u0[41] = local_bb1_var_[31];
assign local_bb1_var__u0[42] = local_bb1_var_[31];
assign local_bb1_var__u0[43] = local_bb1_var_[31];
assign local_bb1_var__u0[44] = local_bb1_var_[31];
assign local_bb1_var__u0[45] = local_bb1_var_[31];
assign local_bb1_var__u0[46] = local_bb1_var_[31];
assign local_bb1_var__u0[47] = local_bb1_var_[31];
assign local_bb1_var__u0[48] = local_bb1_var_[31];
assign local_bb1_var__u0[49] = local_bb1_var_[31];
assign local_bb1_var__u0[50] = local_bb1_var_[31];
assign local_bb1_var__u0[51] = local_bb1_var_[31];
assign local_bb1_var__u0[52] = local_bb1_var_[31];
assign local_bb1_var__u0[53] = local_bb1_var_[31];
assign local_bb1_var__u0[54] = local_bb1_var_[31];
assign local_bb1_var__u0[55] = local_bb1_var_[31];
assign local_bb1_var__u0[56] = local_bb1_var_[31];
assign local_bb1_var__u0[57] = local_bb1_var_[31];
assign local_bb1_var__u0[58] = local_bb1_var_[31];
assign local_bb1_var__u0[59] = local_bb1_var_[31];
assign local_bb1_var__u0[60] = local_bb1_var_[31];
assign local_bb1_var__u0[61] = local_bb1_var_[31];
assign local_bb1_var__u0[62] = local_bb1_var_[31];
assign local_bb1_var__u0[63] = local_bb1_var_[31];
assign local_bb1_var__u0[31:0] = local_bb1_var_;

// This section implements an unregistered operation.
// 
wire local_bb1_add_valid_out;
wire local_bb1_add_stall_in;
 reg local_bb1_add_consumed_0_NO_SHIFT_REG;
wire local_bb1_var__u0_valid_out;
wire local_bb1_var__u0_stall_in;
 reg local_bb1_var__u0_consumed_0_NO_SHIFT_REG;
wire local_bb1_add_inputs_ready;
wire local_bb1_add_stall_local;
wire [31:0] local_bb1_add;

assign local_bb1_add_inputs_ready = (local_bb1_var__valid_out_1_NO_SHIFT_REG & local_bb1_var__valid_out_0_NO_SHIFT_REG);
assign local_bb1_add = (local_bb1_var_ + input_N);
assign local_bb1_add_stall_local = ((local_bb1_add_stall_in & ~(local_bb1_add_consumed_0_NO_SHIFT_REG)) | (local_bb1_var__u0_stall_in & ~(local_bb1_var__u0_consumed_0_NO_SHIFT_REG)));
assign local_bb1_add_valid_out = (local_bb1_add_inputs_ready & ~(local_bb1_add_consumed_0_NO_SHIFT_REG));
assign local_bb1_var__u0_valid_out = (local_bb1_add_inputs_ready & ~(local_bb1_var__u0_consumed_0_NO_SHIFT_REG));
assign local_bb1_var__stall_in_1 = (local_bb1_add_stall_local | ~(local_bb1_add_inputs_ready));
assign local_bb1_var__stall_in_0 = (local_bb1_add_stall_local | ~(local_bb1_add_inputs_ready));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_add_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb1_var__u0_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb1_add_consumed_0_NO_SHIFT_REG <= (local_bb1_add_inputs_ready & (local_bb1_add_consumed_0_NO_SHIFT_REG | ~(local_bb1_add_stall_in)) & local_bb1_add_stall_local);
		local_bb1_var__u0_consumed_0_NO_SHIFT_REG <= (local_bb1_add_inputs_ready & (local_bb1_var__u0_consumed_0_NO_SHIFT_REG | ~(local_bb1_var__u0_stall_in)) & local_bb1_add_stall_local);
	end
end


// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
 reg branch_node_valid_out_NO_SHIFT_REG;
wire branch_var__output_regs_ready;
wire combined_branch_stall_in_signal;
 reg [31:0] lvb_bb1_var__reg_NO_SHIFT_REG;
 reg [63:0] lvb_bb1_var__u0_reg_NO_SHIFT_REG;
 reg [31:0] lvb_bb1_add_reg_NO_SHIFT_REG;
 reg [31:0] lvb_input_global_id_0_reg_NO_SHIFT_REG;
 reg [31:0] lvb_input_acl_hw_wg_id_reg_NO_SHIFT_REG;

assign branch_var__inputs_ready = (local_bb1_add_valid_out & local_bb1_var__u0_valid_out & local_bb1_var__valid_out_2_NO_SHIFT_REG & rnode_1to4_input_global_id_0_0_valid_out_NO_SHIFT_REG & rnode_1to4_input_acl_hw_wg_id_0_valid_out_NO_SHIFT_REG);
assign branch_var__output_regs_ready = (~(stall_in) | ~(branch_node_valid_out_NO_SHIFT_REG));
assign local_bb1_add_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign local_bb1_var__u0_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign local_bb1_var__stall_in_2 = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign rnode_1to4_input_global_id_0_0_stall_in_NO_SHIFT_REG = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign rnode_1to4_input_acl_hw_wg_id_0_stall_in_NO_SHIFT_REG = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign lvb_bb1_var_ = lvb_bb1_var__reg_NO_SHIFT_REG;
assign lvb_bb1_var__u0 = lvb_bb1_var__u0_reg_NO_SHIFT_REG;
assign lvb_bb1_add = lvb_bb1_add_reg_NO_SHIFT_REG;
assign lvb_input_global_id_0 = lvb_input_global_id_0_reg_NO_SHIFT_REG;
assign lvb_input_acl_hw_wg_id = lvb_input_acl_hw_wg_id_reg_NO_SHIFT_REG;
assign valid_out = branch_node_valid_out_NO_SHIFT_REG;
assign combined_branch_stall_in_signal = stall_in;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		branch_node_valid_out_NO_SHIFT_REG <= 1'b0;
		lvb_bb1_var__reg_NO_SHIFT_REG <= 'x;
		lvb_bb1_var__u0_reg_NO_SHIFT_REG <= 'x;
		lvb_bb1_add_reg_NO_SHIFT_REG <= 'x;
		lvb_input_global_id_0_reg_NO_SHIFT_REG <= 'x;
		lvb_input_acl_hw_wg_id_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (branch_var__output_regs_ready)
		begin
			branch_node_valid_out_NO_SHIFT_REG <= branch_var__inputs_ready;
			lvb_bb1_var__reg_NO_SHIFT_REG <= local_bb1_var_;
			lvb_bb1_var__u0_reg_NO_SHIFT_REG <= local_bb1_var__u0;
			lvb_bb1_add_reg_NO_SHIFT_REG <= local_bb1_add;
			lvb_input_global_id_0_reg_NO_SHIFT_REG <= rnode_1to4_input_global_id_0_0_NO_SHIFT_REG;
			lvb_input_acl_hw_wg_id_reg_NO_SHIFT_REG <= rnode_1to4_input_acl_hw_wg_id_0_NO_SHIFT_REG;
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

module fpgasort_basic_block_2
	(
		input 		clock,
		input 		resetn,
		input [63:0] 		input_a,
		input [63:0] 		input_p,
		input 		input_wii_cmp1,
		input 		input_wii_cmp1_NEG,
		input 		valid_in_0,
		output 		stall_out_0,
		input [31:0] 		input_var__0,
		input [31:0] 		input_add_0,
		input [63:0] 		input_indvars_iv_0,
		input [31:0] 		input_score_02_0,
		input [31:0] 		input_global_id_0_0,
		input [31:0] 		input_acl_hw_wg_id_0,
		input 		valid_in_1,
		output 		stall_out_1,
		input [31:0] 		input_var__1,
		input [31:0] 		input_add_1,
		input [63:0] 		input_indvars_iv_1,
		input [31:0] 		input_score_02_1,
		input [31:0] 		input_global_id_0_1,
		input [31:0] 		input_acl_hw_wg_id_1,
		output 		valid_out_0,
		input 		stall_in_0,
		output [31:0] 		lvb_var__0,
		output [31:0] 		lvb_add_0,
		output [63:0] 		lvb_bb2_indvars_iv_next_0,
		output [31:0] 		lvb_bb2_c0_exe1_0,
		output [31:0] 		lvb_input_global_id_0_0,
		output [31:0] 		lvb_input_acl_hw_wg_id_0,
		output 		valid_out_1,
		input 		stall_in_1,
		output [31:0] 		lvb_var__1,
		output [31:0] 		lvb_add_1,
		output [63:0] 		lvb_bb2_indvars_iv_next_1,
		output [31:0] 		lvb_bb2_c0_exe1_1,
		output [31:0] 		lvb_input_global_id_0_1,
		output [31:0] 		lvb_input_acl_hw_wg_id_1,
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
		input [255:0] 		avm_local_bb2_ld__u1_readdata,
		input 		avm_local_bb2_ld__u1_readdatavalid,
		input 		avm_local_bb2_ld__u1_waitrequest,
		output [29:0] 		avm_local_bb2_ld__u1_address,
		output 		avm_local_bb2_ld__u1_read,
		output 		avm_local_bb2_ld__u1_write,
		input 		avm_local_bb2_ld__u1_writeack,
		output [255:0] 		avm_local_bb2_ld__u1_writedata,
		output [31:0] 		avm_local_bb2_ld__u1_byteenable,
		output [4:0] 		avm_local_bb2_ld__u1_burstcount,
		output 		local_bb2_ld__u1_active
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
wire merge_node_stall_in_6;
 reg merge_node_valid_out_6_NO_SHIFT_REG;
wire merge_node_stall_in_7;
 reg merge_node_valid_out_7_NO_SHIFT_REG;
wire merge_node_stall_in_8;
 reg merge_node_valid_out_8_NO_SHIFT_REG;
wire merge_node_stall_in_9;
 reg merge_node_valid_out_9_NO_SHIFT_REG;
wire merge_stalled_by_successors;
 reg merge_block_selector_NO_SHIFT_REG;
 reg merge_node_valid_in_0_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_var__0_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_add_0_staging_reg_NO_SHIFT_REG;
 reg [63:0] input_indvars_iv_0_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_score_02_0_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_global_id_0_0_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_acl_hw_wg_id_0_staging_reg_NO_SHIFT_REG;
 reg [31:0] local_lvm_var__NO_SHIFT_REG;
 reg [31:0] local_lvm_add_NO_SHIFT_REG;
 reg [63:0] local_lvm_indvars_iv_NO_SHIFT_REG;
 reg [31:0] local_lvm_score_02_NO_SHIFT_REG;
 reg [31:0] local_lvm_input_global_id_0_NO_SHIFT_REG;
 reg [31:0] local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG;
 reg merge_node_valid_in_1_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_var__1_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_add_1_staging_reg_NO_SHIFT_REG;
 reg [63:0] input_indvars_iv_1_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_score_02_1_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_global_id_0_1_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_acl_hw_wg_id_1_staging_reg_NO_SHIFT_REG;
 reg is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
 reg invariant_valid_NO_SHIFT_REG;

assign merge_stalled_by_successors = ((merge_node_stall_in_0 & merge_node_valid_out_0_NO_SHIFT_REG) | (merge_node_stall_in_1 & merge_node_valid_out_1_NO_SHIFT_REG) | (merge_node_stall_in_2 & merge_node_valid_out_2_NO_SHIFT_REG) | (merge_node_stall_in_3 & merge_node_valid_out_3_NO_SHIFT_REG) | (merge_node_stall_in_4 & merge_node_valid_out_4_NO_SHIFT_REG) | (merge_node_stall_in_5 & merge_node_valid_out_5_NO_SHIFT_REG) | (merge_node_stall_in_6 & merge_node_valid_out_6_NO_SHIFT_REG) | (merge_node_stall_in_7 & merge_node_valid_out_7_NO_SHIFT_REG) | (merge_node_stall_in_8 & merge_node_valid_out_8_NO_SHIFT_REG) | (merge_node_stall_in_9 & merge_node_valid_out_9_NO_SHIFT_REG));
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
		input_var__0_staging_reg_NO_SHIFT_REG <= 'x;
		input_add_0_staging_reg_NO_SHIFT_REG <= 'x;
		input_indvars_iv_0_staging_reg_NO_SHIFT_REG <= 'x;
		input_score_02_0_staging_reg_NO_SHIFT_REG <= 'x;
		input_global_id_0_0_staging_reg_NO_SHIFT_REG <= 'x;
		input_acl_hw_wg_id_0_staging_reg_NO_SHIFT_REG <= 'x;
		merge_node_valid_in_0_staging_reg_NO_SHIFT_REG <= 1'b0;
		input_var__1_staging_reg_NO_SHIFT_REG <= 'x;
		input_add_1_staging_reg_NO_SHIFT_REG <= 'x;
		input_indvars_iv_1_staging_reg_NO_SHIFT_REG <= 'x;
		input_score_02_1_staging_reg_NO_SHIFT_REG <= 'x;
		input_global_id_0_1_staging_reg_NO_SHIFT_REG <= 'x;
		input_acl_hw_wg_id_1_staging_reg_NO_SHIFT_REG <= 'x;
		merge_node_valid_in_1_staging_reg_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (((merge_block_selector_NO_SHIFT_REG != 1'b0) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_0_staging_reg_NO_SHIFT_REG))
			begin
				input_var__0_staging_reg_NO_SHIFT_REG <= input_var__0;
				input_add_0_staging_reg_NO_SHIFT_REG <= input_add_0;
				input_indvars_iv_0_staging_reg_NO_SHIFT_REG <= input_indvars_iv_0;
				input_score_02_0_staging_reg_NO_SHIFT_REG <= input_score_02_0;
				input_global_id_0_0_staging_reg_NO_SHIFT_REG <= input_global_id_0_0;
				input_acl_hw_wg_id_0_staging_reg_NO_SHIFT_REG <= input_acl_hw_wg_id_0;
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
				input_var__1_staging_reg_NO_SHIFT_REG <= input_var__1;
				input_add_1_staging_reg_NO_SHIFT_REG <= input_add_1;
				input_indvars_iv_1_staging_reg_NO_SHIFT_REG <= input_indvars_iv_1;
				input_score_02_1_staging_reg_NO_SHIFT_REG <= input_score_02_1;
				input_global_id_0_1_staging_reg_NO_SHIFT_REG <= input_global_id_0_1;
				input_acl_hw_wg_id_1_staging_reg_NO_SHIFT_REG <= input_acl_hw_wg_id_1;
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
					local_lvm_var__NO_SHIFT_REG <= input_var__0_staging_reg_NO_SHIFT_REG;
					local_lvm_add_NO_SHIFT_REG <= input_add_0_staging_reg_NO_SHIFT_REG;
					local_lvm_indvars_iv_NO_SHIFT_REG <= input_indvars_iv_0_staging_reg_NO_SHIFT_REG;
					local_lvm_score_02_NO_SHIFT_REG <= input_score_02_0_staging_reg_NO_SHIFT_REG;
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0_0_staging_reg_NO_SHIFT_REG;
					local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG <= input_acl_hw_wg_id_0_staging_reg_NO_SHIFT_REG;
				end
				else
				begin
					local_lvm_var__NO_SHIFT_REG <= input_var__0;
					local_lvm_add_NO_SHIFT_REG <= input_add_0;
					local_lvm_indvars_iv_NO_SHIFT_REG <= input_indvars_iv_0;
					local_lvm_score_02_NO_SHIFT_REG <= input_score_02_0;
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0_0;
					local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG <= input_acl_hw_wg_id_0;
				end
			end

			1'b1:
			begin
				if (merge_node_valid_in_1_staging_reg_NO_SHIFT_REG)
				begin
					local_lvm_var__NO_SHIFT_REG <= input_var__1_staging_reg_NO_SHIFT_REG;
					local_lvm_add_NO_SHIFT_REG <= input_add_1_staging_reg_NO_SHIFT_REG;
					local_lvm_indvars_iv_NO_SHIFT_REG <= input_indvars_iv_1_staging_reg_NO_SHIFT_REG;
					local_lvm_score_02_NO_SHIFT_REG <= input_score_02_1_staging_reg_NO_SHIFT_REG;
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0_1_staging_reg_NO_SHIFT_REG;
					local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG <= input_acl_hw_wg_id_1_staging_reg_NO_SHIFT_REG;
				end
				else
				begin
					local_lvm_var__NO_SHIFT_REG <= input_var__1;
					local_lvm_add_NO_SHIFT_REG <= input_add_1;
					local_lvm_indvars_iv_NO_SHIFT_REG <= input_indvars_iv_1;
					local_lvm_score_02_NO_SHIFT_REG <= input_score_02_1;
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0_1;
					local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG <= input_acl_hw_wg_id_1;
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
		merge_node_valid_out_6_NO_SHIFT_REG <= 1'b0;
		merge_node_valid_out_7_NO_SHIFT_REG <= 1'b0;
		merge_node_valid_out_8_NO_SHIFT_REG <= 1'b0;
		merge_node_valid_out_9_NO_SHIFT_REG <= 1'b0;
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
			merge_node_valid_out_6_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
			merge_node_valid_out_7_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
			merge_node_valid_out_8_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
			merge_node_valid_out_9_NO_SHIFT_REG <= is_merge_data_to_local_regs_valid_NO_SHIFT_REG;
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
			if (~(merge_node_stall_in_6))
			begin
				merge_node_valid_out_6_NO_SHIFT_REG <= 1'b0;
			end
			if (~(merge_node_stall_in_7))
			begin
				merge_node_valid_out_7_NO_SHIFT_REG <= 1'b0;
			end
			if (~(merge_node_stall_in_8))
			begin
				merge_node_valid_out_8_NO_SHIFT_REG <= 1'b0;
			end
			if (~(merge_node_stall_in_9))
			begin
				merge_node_valid_out_9_NO_SHIFT_REG <= 1'b0;
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
wire local_bb2_var__stall_local;
wire [31:0] local_bb2_var_;

assign local_bb2_var_ = local_lvm_indvars_iv_NO_SHIFT_REG[31:0];

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_1to2_input_a_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to2_input_a_0_stall_in_NO_SHIFT_REG;
 logic rnode_1to2_input_a_0_reg_2_inputs_ready_NO_SHIFT_REG;
 logic rnode_1to2_input_a_0_valid_out_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_input_a_0_stall_in_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_input_a_0_stall_out_reg_2_NO_SHIFT_REG;

acl_data_fifo rnode_1to2_input_a_0_reg_2_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to2_input_a_0_reg_2_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to2_input_a_0_stall_in_reg_2_NO_SHIFT_REG),
	.valid_out(rnode_1to2_input_a_0_valid_out_reg_2_NO_SHIFT_REG),
	.stall_out(rnode_1to2_input_a_0_stall_out_reg_2_NO_SHIFT_REG),
	.data_in(),
	.data_out()
);

defparam rnode_1to2_input_a_0_reg_2_fifo.DEPTH = 2;
defparam rnode_1to2_input_a_0_reg_2_fifo.DATA_WIDTH = 0;
defparam rnode_1to2_input_a_0_reg_2_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to2_input_a_0_reg_2_fifo.IMPL = "ll_reg";

assign rnode_1to2_input_a_0_reg_2_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_2_NO_SHIFT_REG;
assign merge_node_stall_in_2 = rnode_1to2_input_a_0_stall_out_reg_2_NO_SHIFT_REG;
assign rnode_1to2_input_a_0_stall_in_reg_2_NO_SHIFT_REG = rnode_1to2_input_a_0_stall_in_NO_SHIFT_REG;
assign rnode_1to2_input_a_0_valid_out_NO_SHIFT_REG = rnode_1to2_input_a_0_valid_out_reg_2_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_1to2_cmp1_NEG_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_1to2_cmp1_NEG_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_1to2_cmp1_NEG_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_1to2_cmp1_NEG_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_1to2_cmp1_NEG_0_reg_2_inputs_ready_NO_SHIFT_REG;
 logic rnode_1to2_cmp1_NEG_0_valid_out_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_cmp1_NEG_0_stall_in_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_cmp1_NEG_0_stall_out_reg_2_NO_SHIFT_REG;

acl_multi_fanout_adaptor rnode_1to2_cmp1_NEG_0_reg_2_fanout_adaptor (
	.clock(clock),
	.resetn(resetn),
	.data_in(),
	.valid_in(rnode_1to2_cmp1_NEG_0_valid_out_0_reg_2_NO_SHIFT_REG),
	.stall_out(rnode_1to2_cmp1_NEG_0_stall_in_0_reg_2_NO_SHIFT_REG),
	.data_out(),
	.valid_out({rnode_1to2_cmp1_NEG_0_valid_out_0_NO_SHIFT_REG, rnode_1to2_cmp1_NEG_0_valid_out_1_NO_SHIFT_REG}),
	.stall_in({rnode_1to2_cmp1_NEG_0_stall_in_0_NO_SHIFT_REG, rnode_1to2_cmp1_NEG_0_stall_in_1_NO_SHIFT_REG})
);

defparam rnode_1to2_cmp1_NEG_0_reg_2_fanout_adaptor.DATA_WIDTH = 0;
defparam rnode_1to2_cmp1_NEG_0_reg_2_fanout_adaptor.NUM_FANOUTS = 2;

acl_data_fifo rnode_1to2_cmp1_NEG_0_reg_2_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to2_cmp1_NEG_0_reg_2_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to2_cmp1_NEG_0_stall_in_0_reg_2_NO_SHIFT_REG),
	.valid_out(rnode_1to2_cmp1_NEG_0_valid_out_0_reg_2_NO_SHIFT_REG),
	.stall_out(rnode_1to2_cmp1_NEG_0_stall_out_reg_2_NO_SHIFT_REG),
	.data_in(),
	.data_out()
);

defparam rnode_1to2_cmp1_NEG_0_reg_2_fifo.DEPTH = 2;
defparam rnode_1to2_cmp1_NEG_0_reg_2_fifo.DATA_WIDTH = 0;
defparam rnode_1to2_cmp1_NEG_0_reg_2_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to2_cmp1_NEG_0_reg_2_fifo.IMPL = "ll_reg";

assign rnode_1to2_cmp1_NEG_0_reg_2_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_3_NO_SHIFT_REG;
assign merge_node_stall_in_3 = rnode_1to2_cmp1_NEG_0_stall_out_reg_2_NO_SHIFT_REG;

// Register node:
//  * latency = 160
//  * capacity = 160
 logic rnode_1to161_score_02_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to161_score_02_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_1to161_score_02_0_NO_SHIFT_REG;
 logic rnode_1to161_score_02_0_reg_161_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_1to161_score_02_0_reg_161_NO_SHIFT_REG;
 logic rnode_1to161_score_02_0_valid_out_reg_161_NO_SHIFT_REG;
 logic rnode_1to161_score_02_0_stall_in_reg_161_NO_SHIFT_REG;
 logic rnode_1to161_score_02_0_stall_out_reg_161_NO_SHIFT_REG;

acl_data_fifo rnode_1to161_score_02_0_reg_161_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to161_score_02_0_reg_161_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to161_score_02_0_stall_in_reg_161_NO_SHIFT_REG),
	.valid_out(rnode_1to161_score_02_0_valid_out_reg_161_NO_SHIFT_REG),
	.stall_out(rnode_1to161_score_02_0_stall_out_reg_161_NO_SHIFT_REG),
	.data_in(local_lvm_score_02_NO_SHIFT_REG),
	.data_out(rnode_1to161_score_02_0_reg_161_NO_SHIFT_REG)
);

defparam rnode_1to161_score_02_0_reg_161_fifo.DEPTH = 161;
defparam rnode_1to161_score_02_0_reg_161_fifo.DATA_WIDTH = 32;
defparam rnode_1to161_score_02_0_reg_161_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to161_score_02_0_reg_161_fifo.IMPL = "ram";

assign rnode_1to161_score_02_0_reg_161_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_4_NO_SHIFT_REG;
assign merge_node_stall_in_4 = rnode_1to161_score_02_0_stall_out_reg_161_NO_SHIFT_REG;
assign rnode_1to161_score_02_0_NO_SHIFT_REG = rnode_1to161_score_02_0_reg_161_NO_SHIFT_REG;
assign rnode_1to161_score_02_0_stall_in_reg_161_NO_SHIFT_REG = rnode_1to161_score_02_0_stall_in_NO_SHIFT_REG;
assign rnode_1to161_score_02_0_valid_out_NO_SHIFT_REG = rnode_1to161_score_02_0_valid_out_reg_161_NO_SHIFT_REG;

// Register node:
//  * latency = 177
//  * capacity = 177
 logic rnode_1to178_var__0_valid_out_NO_SHIFT_REG;
 logic rnode_1to178_var__0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_1to178_var__0_NO_SHIFT_REG;
 logic rnode_1to178_var__0_reg_178_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_1to178_var__0_reg_178_NO_SHIFT_REG;
 logic rnode_1to178_var__0_valid_out_reg_178_NO_SHIFT_REG;
 logic rnode_1to178_var__0_stall_in_reg_178_NO_SHIFT_REG;
 logic rnode_1to178_var__0_stall_out_reg_178_NO_SHIFT_REG;

acl_data_fifo rnode_1to178_var__0_reg_178_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to178_var__0_reg_178_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to178_var__0_stall_in_reg_178_NO_SHIFT_REG),
	.valid_out(rnode_1to178_var__0_valid_out_reg_178_NO_SHIFT_REG),
	.stall_out(rnode_1to178_var__0_stall_out_reg_178_NO_SHIFT_REG),
	.data_in(local_lvm_var__NO_SHIFT_REG),
	.data_out(rnode_1to178_var__0_reg_178_NO_SHIFT_REG)
);

defparam rnode_1to178_var__0_reg_178_fifo.DEPTH = 178;
defparam rnode_1to178_var__0_reg_178_fifo.DATA_WIDTH = 32;
defparam rnode_1to178_var__0_reg_178_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to178_var__0_reg_178_fifo.IMPL = "ram";

assign rnode_1to178_var__0_reg_178_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_5_NO_SHIFT_REG;
assign merge_node_stall_in_5 = rnode_1to178_var__0_stall_out_reg_178_NO_SHIFT_REG;
assign rnode_1to178_var__0_NO_SHIFT_REG = rnode_1to178_var__0_reg_178_NO_SHIFT_REG;
assign rnode_1to178_var__0_stall_in_reg_178_NO_SHIFT_REG = rnode_1to178_var__0_stall_in_NO_SHIFT_REG;
assign rnode_1to178_var__0_valid_out_NO_SHIFT_REG = rnode_1to178_var__0_valid_out_reg_178_NO_SHIFT_REG;

// Register node:
//  * latency = 177
//  * capacity = 177
 logic rnode_1to178_input_global_id_0_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to178_input_global_id_0_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_1to178_input_global_id_0_0_NO_SHIFT_REG;
 logic rnode_1to178_input_global_id_0_0_reg_178_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_1to178_input_global_id_0_0_reg_178_NO_SHIFT_REG;
 logic rnode_1to178_input_global_id_0_0_valid_out_reg_178_NO_SHIFT_REG;
 logic rnode_1to178_input_global_id_0_0_stall_in_reg_178_NO_SHIFT_REG;
 logic rnode_1to178_input_global_id_0_0_stall_out_reg_178_NO_SHIFT_REG;

acl_data_fifo rnode_1to178_input_global_id_0_0_reg_178_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to178_input_global_id_0_0_reg_178_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to178_input_global_id_0_0_stall_in_reg_178_NO_SHIFT_REG),
	.valid_out(rnode_1to178_input_global_id_0_0_valid_out_reg_178_NO_SHIFT_REG),
	.stall_out(rnode_1to178_input_global_id_0_0_stall_out_reg_178_NO_SHIFT_REG),
	.data_in(local_lvm_input_global_id_0_NO_SHIFT_REG),
	.data_out(rnode_1to178_input_global_id_0_0_reg_178_NO_SHIFT_REG)
);

defparam rnode_1to178_input_global_id_0_0_reg_178_fifo.DEPTH = 178;
defparam rnode_1to178_input_global_id_0_0_reg_178_fifo.DATA_WIDTH = 32;
defparam rnode_1to178_input_global_id_0_0_reg_178_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to178_input_global_id_0_0_reg_178_fifo.IMPL = "ram";

assign rnode_1to178_input_global_id_0_0_reg_178_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_6_NO_SHIFT_REG;
assign merge_node_stall_in_6 = rnode_1to178_input_global_id_0_0_stall_out_reg_178_NO_SHIFT_REG;
assign rnode_1to178_input_global_id_0_0_NO_SHIFT_REG = rnode_1to178_input_global_id_0_0_reg_178_NO_SHIFT_REG;
assign rnode_1to178_input_global_id_0_0_stall_in_reg_178_NO_SHIFT_REG = rnode_1to178_input_global_id_0_0_stall_in_NO_SHIFT_REG;
assign rnode_1to178_input_global_id_0_0_valid_out_NO_SHIFT_REG = rnode_1to178_input_global_id_0_0_valid_out_reg_178_NO_SHIFT_REG;

// Register node:
//  * latency = 177
//  * capacity = 177
 logic rnode_1to178_input_acl_hw_wg_id_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to178_input_acl_hw_wg_id_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_1to178_input_acl_hw_wg_id_0_NO_SHIFT_REG;
 logic rnode_1to178_input_acl_hw_wg_id_0_reg_178_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_1to178_input_acl_hw_wg_id_0_reg_178_NO_SHIFT_REG;
 logic rnode_1to178_input_acl_hw_wg_id_0_valid_out_reg_178_NO_SHIFT_REG;
 logic rnode_1to178_input_acl_hw_wg_id_0_stall_in_reg_178_NO_SHIFT_REG;
 logic rnode_1to178_input_acl_hw_wg_id_0_stall_out_reg_178_NO_SHIFT_REG;

acl_data_fifo rnode_1to178_input_acl_hw_wg_id_0_reg_178_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to178_input_acl_hw_wg_id_0_reg_178_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to178_input_acl_hw_wg_id_0_stall_in_reg_178_NO_SHIFT_REG),
	.valid_out(rnode_1to178_input_acl_hw_wg_id_0_valid_out_reg_178_NO_SHIFT_REG),
	.stall_out(rnode_1to178_input_acl_hw_wg_id_0_stall_out_reg_178_NO_SHIFT_REG),
	.data_in(local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG),
	.data_out(rnode_1to178_input_acl_hw_wg_id_0_reg_178_NO_SHIFT_REG)
);

defparam rnode_1to178_input_acl_hw_wg_id_0_reg_178_fifo.DEPTH = 178;
defparam rnode_1to178_input_acl_hw_wg_id_0_reg_178_fifo.DATA_WIDTH = 32;
defparam rnode_1to178_input_acl_hw_wg_id_0_reg_178_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to178_input_acl_hw_wg_id_0_reg_178_fifo.IMPL = "ram";

assign rnode_1to178_input_acl_hw_wg_id_0_reg_178_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_7_NO_SHIFT_REG;
assign merge_node_stall_in_7 = rnode_1to178_input_acl_hw_wg_id_0_stall_out_reg_178_NO_SHIFT_REG;
assign rnode_1to178_input_acl_hw_wg_id_0_NO_SHIFT_REG = rnode_1to178_input_acl_hw_wg_id_0_reg_178_NO_SHIFT_REG;
assign rnode_1to178_input_acl_hw_wg_id_0_stall_in_reg_178_NO_SHIFT_REG = rnode_1to178_input_acl_hw_wg_id_0_stall_in_NO_SHIFT_REG;
assign rnode_1to178_input_acl_hw_wg_id_0_valid_out_NO_SHIFT_REG = rnode_1to178_input_acl_hw_wg_id_0_valid_out_reg_178_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_1to2_indvars_iv_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_1to2_indvars_iv_0_stall_in_0_NO_SHIFT_REG;
 logic [63:0] rnode_1to2_indvars_iv_0_NO_SHIFT_REG;
 logic rnode_1to2_indvars_iv_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_1to2_indvars_iv_0_stall_in_1_NO_SHIFT_REG;
 logic [63:0] rnode_1to2_indvars_iv_1_NO_SHIFT_REG;
 logic rnode_1to2_indvars_iv_0_reg_2_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_1to2_indvars_iv_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_indvars_iv_0_valid_out_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_indvars_iv_0_stall_in_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_indvars_iv_0_stall_out_reg_2_NO_SHIFT_REG;
 logic [63:0] rnode_1to2_indvars_iv_0_reg_2_NO_SHIFT_REG_fa;

acl_multi_fanout_adaptor rnode_1to2_indvars_iv_0_reg_2_fanout_adaptor (
	.clock(clock),
	.resetn(resetn),
	.data_in(rnode_1to2_indvars_iv_0_reg_2_NO_SHIFT_REG),
	.valid_in(rnode_1to2_indvars_iv_0_valid_out_0_reg_2_NO_SHIFT_REG),
	.stall_out(rnode_1to2_indvars_iv_0_stall_in_0_reg_2_NO_SHIFT_REG),
	.data_out(rnode_1to2_indvars_iv_0_reg_2_NO_SHIFT_REG_fa),
	.valid_out({rnode_1to2_indvars_iv_0_valid_out_0_NO_SHIFT_REG, rnode_1to2_indvars_iv_0_valid_out_1_NO_SHIFT_REG}),
	.stall_in({rnode_1to2_indvars_iv_0_stall_in_0_NO_SHIFT_REG, rnode_1to2_indvars_iv_0_stall_in_1_NO_SHIFT_REG})
);

defparam rnode_1to2_indvars_iv_0_reg_2_fanout_adaptor.DATA_WIDTH = 64;
defparam rnode_1to2_indvars_iv_0_reg_2_fanout_adaptor.NUM_FANOUTS = 2;

acl_data_fifo rnode_1to2_indvars_iv_0_reg_2_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to2_indvars_iv_0_reg_2_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to2_indvars_iv_0_stall_in_0_reg_2_NO_SHIFT_REG),
	.valid_out(rnode_1to2_indvars_iv_0_valid_out_0_reg_2_NO_SHIFT_REG),
	.stall_out(rnode_1to2_indvars_iv_0_stall_out_reg_2_NO_SHIFT_REG),
	.data_in(local_lvm_indvars_iv_NO_SHIFT_REG),
	.data_out(rnode_1to2_indvars_iv_0_reg_2_NO_SHIFT_REG)
);

defparam rnode_1to2_indvars_iv_0_reg_2_fifo.DEPTH = 2;
defparam rnode_1to2_indvars_iv_0_reg_2_fifo.DATA_WIDTH = 64;
defparam rnode_1to2_indvars_iv_0_reg_2_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to2_indvars_iv_0_reg_2_fifo.IMPL = "ll_reg";

assign rnode_1to2_indvars_iv_0_reg_2_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_8_NO_SHIFT_REG;
assign merge_node_stall_in_8 = rnode_1to2_indvars_iv_0_stall_out_reg_2_NO_SHIFT_REG;
assign rnode_1to2_indvars_iv_0_NO_SHIFT_REG = rnode_1to2_indvars_iv_0_reg_2_NO_SHIFT_REG_fa;
assign rnode_1to2_indvars_iv_1_NO_SHIFT_REG = rnode_1to2_indvars_iv_0_reg_2_NO_SHIFT_REG_fa;

// Register node:
//  * latency = 176
//  * capacity = 176
 logic rnode_1to177_add_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to177_add_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_1to177_add_0_NO_SHIFT_REG;
 logic rnode_1to177_add_0_reg_177_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_1to177_add_0_reg_177_NO_SHIFT_REG;
 logic rnode_1to177_add_0_valid_out_reg_177_NO_SHIFT_REG;
 logic rnode_1to177_add_0_stall_in_reg_177_NO_SHIFT_REG;
 logic rnode_1to177_add_0_stall_out_reg_177_NO_SHIFT_REG;

acl_data_fifo rnode_1to177_add_0_reg_177_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to177_add_0_reg_177_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to177_add_0_stall_in_reg_177_NO_SHIFT_REG),
	.valid_out(rnode_1to177_add_0_valid_out_reg_177_NO_SHIFT_REG),
	.stall_out(rnode_1to177_add_0_stall_out_reg_177_NO_SHIFT_REG),
	.data_in(local_lvm_add_NO_SHIFT_REG),
	.data_out(rnode_1to177_add_0_reg_177_NO_SHIFT_REG)
);

defparam rnode_1to177_add_0_reg_177_fifo.DEPTH = 177;
defparam rnode_1to177_add_0_reg_177_fifo.DATA_WIDTH = 32;
defparam rnode_1to177_add_0_reg_177_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to177_add_0_reg_177_fifo.IMPL = "ram";

assign rnode_1to177_add_0_reg_177_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_9_NO_SHIFT_REG;
assign merge_node_stall_in_9 = rnode_1to177_add_0_stall_out_reg_177_NO_SHIFT_REG;
assign rnode_1to177_add_0_NO_SHIFT_REG = rnode_1to177_add_0_reg_177_NO_SHIFT_REG;
assign rnode_1to177_add_0_stall_in_reg_177_NO_SHIFT_REG = rnode_1to177_add_0_stall_in_NO_SHIFT_REG;
assign rnode_1to177_add_0_valid_out_NO_SHIFT_REG = rnode_1to177_add_0_valid_out_reg_177_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_sub_valid_out;
wire local_bb2_sub_stall_in;
wire local_bb2_sub_inputs_ready;
wire local_bb2_sub_stall_local;
wire [31:0] local_bb2_sub;

assign local_bb2_sub_inputs_ready = (merge_node_valid_out_0_NO_SHIFT_REG & merge_node_valid_out_1_NO_SHIFT_REG);
assign local_bb2_sub = (local_bb2_var_ - local_lvm_var__NO_SHIFT_REG);
assign local_bb2_sub_valid_out = local_bb2_sub_inputs_ready;
assign local_bb2_sub_stall_local = local_bb2_sub_stall_in;
assign merge_node_stall_in_0 = (local_bb2_sub_stall_local | ~(local_bb2_sub_inputs_ready));
assign merge_node_stall_in_1 = (local_bb2_sub_stall_local | ~(local_bb2_sub_inputs_ready));

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_161to162_score_02_0_valid_out_NO_SHIFT_REG;
 logic rnode_161to162_score_02_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_161to162_score_02_0_NO_SHIFT_REG;
 logic rnode_161to162_score_02_0_reg_162_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_161to162_score_02_0_reg_162_NO_SHIFT_REG;
 logic rnode_161to162_score_02_0_valid_out_reg_162_NO_SHIFT_REG;
 logic rnode_161to162_score_02_0_stall_in_reg_162_NO_SHIFT_REG;
 logic rnode_161to162_score_02_0_stall_out_reg_162_NO_SHIFT_REG;

acl_data_fifo rnode_161to162_score_02_0_reg_162_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_161to162_score_02_0_reg_162_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_161to162_score_02_0_stall_in_reg_162_NO_SHIFT_REG),
	.valid_out(rnode_161to162_score_02_0_valid_out_reg_162_NO_SHIFT_REG),
	.stall_out(rnode_161to162_score_02_0_stall_out_reg_162_NO_SHIFT_REG),
	.data_in(rnode_1to161_score_02_0_NO_SHIFT_REG),
	.data_out(rnode_161to162_score_02_0_reg_162_NO_SHIFT_REG)
);

defparam rnode_161to162_score_02_0_reg_162_fifo.DEPTH = 2;
defparam rnode_161to162_score_02_0_reg_162_fifo.DATA_WIDTH = 32;
defparam rnode_161to162_score_02_0_reg_162_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_161to162_score_02_0_reg_162_fifo.IMPL = "ll_reg";

assign rnode_161to162_score_02_0_reg_162_inputs_ready_NO_SHIFT_REG = rnode_1to161_score_02_0_valid_out_NO_SHIFT_REG;
assign rnode_1to161_score_02_0_stall_in_NO_SHIFT_REG = rnode_161to162_score_02_0_stall_out_reg_162_NO_SHIFT_REG;
assign rnode_161to162_score_02_0_NO_SHIFT_REG = rnode_161to162_score_02_0_reg_162_NO_SHIFT_REG;
assign rnode_161to162_score_02_0_stall_in_reg_162_NO_SHIFT_REG = rnode_161to162_score_02_0_stall_in_NO_SHIFT_REG;
assign rnode_161to162_score_02_0_valid_out_NO_SHIFT_REG = rnode_161to162_score_02_0_valid_out_reg_162_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_178to179_var__0_valid_out_NO_SHIFT_REG;
 logic rnode_178to179_var__0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_178to179_var__0_NO_SHIFT_REG;
 logic rnode_178to179_var__0_reg_179_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_178to179_var__0_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_var__0_valid_out_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_var__0_stall_in_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_var__0_stall_out_reg_179_NO_SHIFT_REG;

acl_data_fifo rnode_178to179_var__0_reg_179_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_178to179_var__0_reg_179_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_178to179_var__0_stall_in_reg_179_NO_SHIFT_REG),
	.valid_out(rnode_178to179_var__0_valid_out_reg_179_NO_SHIFT_REG),
	.stall_out(rnode_178to179_var__0_stall_out_reg_179_NO_SHIFT_REG),
	.data_in(rnode_1to178_var__0_NO_SHIFT_REG),
	.data_out(rnode_178to179_var__0_reg_179_NO_SHIFT_REG)
);

defparam rnode_178to179_var__0_reg_179_fifo.DEPTH = 2;
defparam rnode_178to179_var__0_reg_179_fifo.DATA_WIDTH = 32;
defparam rnode_178to179_var__0_reg_179_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_178to179_var__0_reg_179_fifo.IMPL = "ll_reg";

assign rnode_178to179_var__0_reg_179_inputs_ready_NO_SHIFT_REG = rnode_1to178_var__0_valid_out_NO_SHIFT_REG;
assign rnode_1to178_var__0_stall_in_NO_SHIFT_REG = rnode_178to179_var__0_stall_out_reg_179_NO_SHIFT_REG;
assign rnode_178to179_var__0_NO_SHIFT_REG = rnode_178to179_var__0_reg_179_NO_SHIFT_REG;
assign rnode_178to179_var__0_stall_in_reg_179_NO_SHIFT_REG = rnode_178to179_var__0_stall_in_NO_SHIFT_REG;
assign rnode_178to179_var__0_valid_out_NO_SHIFT_REG = rnode_178to179_var__0_valid_out_reg_179_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_178to179_input_global_id_0_0_valid_out_NO_SHIFT_REG;
 logic rnode_178to179_input_global_id_0_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_178to179_input_global_id_0_0_NO_SHIFT_REG;
 logic rnode_178to179_input_global_id_0_0_reg_179_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_178to179_input_global_id_0_0_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_input_global_id_0_0_valid_out_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_input_global_id_0_0_stall_in_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_input_global_id_0_0_stall_out_reg_179_NO_SHIFT_REG;

acl_data_fifo rnode_178to179_input_global_id_0_0_reg_179_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_178to179_input_global_id_0_0_reg_179_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_178to179_input_global_id_0_0_stall_in_reg_179_NO_SHIFT_REG),
	.valid_out(rnode_178to179_input_global_id_0_0_valid_out_reg_179_NO_SHIFT_REG),
	.stall_out(rnode_178to179_input_global_id_0_0_stall_out_reg_179_NO_SHIFT_REG),
	.data_in(rnode_1to178_input_global_id_0_0_NO_SHIFT_REG),
	.data_out(rnode_178to179_input_global_id_0_0_reg_179_NO_SHIFT_REG)
);

defparam rnode_178to179_input_global_id_0_0_reg_179_fifo.DEPTH = 2;
defparam rnode_178to179_input_global_id_0_0_reg_179_fifo.DATA_WIDTH = 32;
defparam rnode_178to179_input_global_id_0_0_reg_179_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_178to179_input_global_id_0_0_reg_179_fifo.IMPL = "ll_reg";

assign rnode_178to179_input_global_id_0_0_reg_179_inputs_ready_NO_SHIFT_REG = rnode_1to178_input_global_id_0_0_valid_out_NO_SHIFT_REG;
assign rnode_1to178_input_global_id_0_0_stall_in_NO_SHIFT_REG = rnode_178to179_input_global_id_0_0_stall_out_reg_179_NO_SHIFT_REG;
assign rnode_178to179_input_global_id_0_0_NO_SHIFT_REG = rnode_178to179_input_global_id_0_0_reg_179_NO_SHIFT_REG;
assign rnode_178to179_input_global_id_0_0_stall_in_reg_179_NO_SHIFT_REG = rnode_178to179_input_global_id_0_0_stall_in_NO_SHIFT_REG;
assign rnode_178to179_input_global_id_0_0_valid_out_NO_SHIFT_REG = rnode_178to179_input_global_id_0_0_valid_out_reg_179_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_178to179_input_acl_hw_wg_id_0_valid_out_NO_SHIFT_REG;
 logic rnode_178to179_input_acl_hw_wg_id_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_178to179_input_acl_hw_wg_id_0_NO_SHIFT_REG;
 logic rnode_178to179_input_acl_hw_wg_id_0_reg_179_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_178to179_input_acl_hw_wg_id_0_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_input_acl_hw_wg_id_0_valid_out_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_input_acl_hw_wg_id_0_stall_in_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_input_acl_hw_wg_id_0_stall_out_reg_179_NO_SHIFT_REG;

acl_data_fifo rnode_178to179_input_acl_hw_wg_id_0_reg_179_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_178to179_input_acl_hw_wg_id_0_reg_179_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_178to179_input_acl_hw_wg_id_0_stall_in_reg_179_NO_SHIFT_REG),
	.valid_out(rnode_178to179_input_acl_hw_wg_id_0_valid_out_reg_179_NO_SHIFT_REG),
	.stall_out(rnode_178to179_input_acl_hw_wg_id_0_stall_out_reg_179_NO_SHIFT_REG),
	.data_in(rnode_1to178_input_acl_hw_wg_id_0_NO_SHIFT_REG),
	.data_out(rnode_178to179_input_acl_hw_wg_id_0_reg_179_NO_SHIFT_REG)
);

defparam rnode_178to179_input_acl_hw_wg_id_0_reg_179_fifo.DEPTH = 2;
defparam rnode_178to179_input_acl_hw_wg_id_0_reg_179_fifo.DATA_WIDTH = 32;
defparam rnode_178to179_input_acl_hw_wg_id_0_reg_179_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_178to179_input_acl_hw_wg_id_0_reg_179_fifo.IMPL = "ll_reg";

assign rnode_178to179_input_acl_hw_wg_id_0_reg_179_inputs_ready_NO_SHIFT_REG = rnode_1to178_input_acl_hw_wg_id_0_valid_out_NO_SHIFT_REG;
assign rnode_1to178_input_acl_hw_wg_id_0_stall_in_NO_SHIFT_REG = rnode_178to179_input_acl_hw_wg_id_0_stall_out_reg_179_NO_SHIFT_REG;
assign rnode_178to179_input_acl_hw_wg_id_0_NO_SHIFT_REG = rnode_178to179_input_acl_hw_wg_id_0_reg_179_NO_SHIFT_REG;
assign rnode_178to179_input_acl_hw_wg_id_0_stall_in_reg_179_NO_SHIFT_REG = rnode_178to179_input_acl_hw_wg_id_0_stall_in_NO_SHIFT_REG;
assign rnode_178to179_input_acl_hw_wg_id_0_valid_out_NO_SHIFT_REG = rnode_178to179_input_acl_hw_wg_id_0_valid_out_reg_179_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_arrayidx_valid_out;
wire local_bb2_arrayidx_stall_in;
wire local_bb2_arrayidx_inputs_ready;
wire local_bb2_arrayidx_stall_local;
wire [63:0] local_bb2_arrayidx;

assign local_bb2_arrayidx_inputs_ready = (rnode_1to2_input_a_0_valid_out_NO_SHIFT_REG & rnode_1to2_indvars_iv_0_valid_out_0_NO_SHIFT_REG);
assign local_bb2_arrayidx = (input_a + (rnode_1to2_indvars_iv_0_NO_SHIFT_REG << 6'h2));
assign local_bb2_arrayidx_valid_out = local_bb2_arrayidx_inputs_ready;
assign local_bb2_arrayidx_stall_local = local_bb2_arrayidx_stall_in;
assign rnode_1to2_input_a_0_stall_in_NO_SHIFT_REG = (local_bb2_arrayidx_stall_local | ~(local_bb2_arrayidx_inputs_ready));
assign rnode_1to2_indvars_iv_0_stall_in_0_NO_SHIFT_REG = (local_bb2_arrayidx_stall_local | ~(local_bb2_arrayidx_inputs_ready));

// Register node:
//  * latency = 174
//  * capacity = 174
 logic rnode_2to176_indvars_iv_0_valid_out_NO_SHIFT_REG;
 logic rnode_2to176_indvars_iv_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_2to176_indvars_iv_0_NO_SHIFT_REG;
 logic rnode_2to176_indvars_iv_0_reg_176_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_2to176_indvars_iv_0_reg_176_NO_SHIFT_REG;
 logic rnode_2to176_indvars_iv_0_valid_out_reg_176_NO_SHIFT_REG;
 logic rnode_2to176_indvars_iv_0_stall_in_reg_176_NO_SHIFT_REG;
 logic rnode_2to176_indvars_iv_0_stall_out_reg_176_NO_SHIFT_REG;

acl_data_fifo rnode_2to176_indvars_iv_0_reg_176_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_2to176_indvars_iv_0_reg_176_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_2to176_indvars_iv_0_stall_in_reg_176_NO_SHIFT_REG),
	.valid_out(rnode_2to176_indvars_iv_0_valid_out_reg_176_NO_SHIFT_REG),
	.stall_out(rnode_2to176_indvars_iv_0_stall_out_reg_176_NO_SHIFT_REG),
	.data_in(rnode_1to2_indvars_iv_1_NO_SHIFT_REG),
	.data_out(rnode_2to176_indvars_iv_0_reg_176_NO_SHIFT_REG)
);

defparam rnode_2to176_indvars_iv_0_reg_176_fifo.DEPTH = 175;
defparam rnode_2to176_indvars_iv_0_reg_176_fifo.DATA_WIDTH = 64;
defparam rnode_2to176_indvars_iv_0_reg_176_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_2to176_indvars_iv_0_reg_176_fifo.IMPL = "ram";

assign rnode_2to176_indvars_iv_0_reg_176_inputs_ready_NO_SHIFT_REG = rnode_1to2_indvars_iv_0_valid_out_1_NO_SHIFT_REG;
assign rnode_1to2_indvars_iv_0_stall_in_1_NO_SHIFT_REG = rnode_2to176_indvars_iv_0_stall_out_reg_176_NO_SHIFT_REG;
assign rnode_2to176_indvars_iv_0_NO_SHIFT_REG = rnode_2to176_indvars_iv_0_reg_176_NO_SHIFT_REG;
assign rnode_2to176_indvars_iv_0_stall_in_reg_176_NO_SHIFT_REG = rnode_2to176_indvars_iv_0_stall_in_NO_SHIFT_REG;
assign rnode_2to176_indvars_iv_0_valid_out_NO_SHIFT_REG = rnode_2to176_indvars_iv_0_valid_out_reg_176_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_177to178_add_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_177to178_add_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_177to178_add_0_NO_SHIFT_REG;
 logic rnode_177to178_add_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_177to178_add_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_177to178_add_1_NO_SHIFT_REG;
 logic rnode_177to178_add_0_reg_178_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_177to178_add_0_reg_178_NO_SHIFT_REG;
 logic rnode_177to178_add_0_valid_out_0_reg_178_NO_SHIFT_REG;
 logic rnode_177to178_add_0_stall_in_0_reg_178_NO_SHIFT_REG;
 logic rnode_177to178_add_0_stall_out_reg_178_NO_SHIFT_REG;
 logic [31:0] rnode_177to178_add_0_reg_178_NO_SHIFT_REG_fa;

acl_multi_fanout_adaptor rnode_177to178_add_0_reg_178_fanout_adaptor (
	.clock(clock),
	.resetn(resetn),
	.data_in(rnode_177to178_add_0_reg_178_NO_SHIFT_REG),
	.valid_in(rnode_177to178_add_0_valid_out_0_reg_178_NO_SHIFT_REG),
	.stall_out(rnode_177to178_add_0_stall_in_0_reg_178_NO_SHIFT_REG),
	.data_out(rnode_177to178_add_0_reg_178_NO_SHIFT_REG_fa),
	.valid_out({rnode_177to178_add_0_valid_out_0_NO_SHIFT_REG, rnode_177to178_add_0_valid_out_1_NO_SHIFT_REG}),
	.stall_in({rnode_177to178_add_0_stall_in_0_NO_SHIFT_REG, rnode_177to178_add_0_stall_in_1_NO_SHIFT_REG})
);

defparam rnode_177to178_add_0_reg_178_fanout_adaptor.DATA_WIDTH = 32;
defparam rnode_177to178_add_0_reg_178_fanout_adaptor.NUM_FANOUTS = 2;

acl_data_fifo rnode_177to178_add_0_reg_178_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_177to178_add_0_reg_178_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_177to178_add_0_stall_in_0_reg_178_NO_SHIFT_REG),
	.valid_out(rnode_177to178_add_0_valid_out_0_reg_178_NO_SHIFT_REG),
	.stall_out(rnode_177to178_add_0_stall_out_reg_178_NO_SHIFT_REG),
	.data_in(rnode_1to177_add_0_NO_SHIFT_REG),
	.data_out(rnode_177to178_add_0_reg_178_NO_SHIFT_REG)
);

defparam rnode_177to178_add_0_reg_178_fifo.DEPTH = 2;
defparam rnode_177to178_add_0_reg_178_fifo.DATA_WIDTH = 32;
defparam rnode_177to178_add_0_reg_178_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_177to178_add_0_reg_178_fifo.IMPL = "ll_reg";

assign rnode_177to178_add_0_reg_178_inputs_ready_NO_SHIFT_REG = rnode_1to177_add_0_valid_out_NO_SHIFT_REG;
assign rnode_1to177_add_0_stall_in_NO_SHIFT_REG = rnode_177to178_add_0_stall_out_reg_178_NO_SHIFT_REG;
assign rnode_177to178_add_0_NO_SHIFT_REG = rnode_177to178_add_0_reg_178_NO_SHIFT_REG_fa;
assign rnode_177to178_add_1_NO_SHIFT_REG = rnode_177to178_add_0_reg_178_NO_SHIFT_REG_fa;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_1to2_bb2_sub_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to2_bb2_sub_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_1to2_bb2_sub_0_NO_SHIFT_REG;
 logic rnode_1to2_bb2_sub_0_reg_2_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_1to2_bb2_sub_0_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_bb2_sub_0_valid_out_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_bb2_sub_0_stall_in_reg_2_NO_SHIFT_REG;
 logic rnode_1to2_bb2_sub_0_stall_out_reg_2_NO_SHIFT_REG;

acl_data_fifo rnode_1to2_bb2_sub_0_reg_2_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to2_bb2_sub_0_reg_2_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to2_bb2_sub_0_stall_in_reg_2_NO_SHIFT_REG),
	.valid_out(rnode_1to2_bb2_sub_0_valid_out_reg_2_NO_SHIFT_REG),
	.stall_out(rnode_1to2_bb2_sub_0_stall_out_reg_2_NO_SHIFT_REG),
	.data_in(local_bb2_sub),
	.data_out(rnode_1to2_bb2_sub_0_reg_2_NO_SHIFT_REG)
);

defparam rnode_1to2_bb2_sub_0_reg_2_fifo.DEPTH = 2;
defparam rnode_1to2_bb2_sub_0_reg_2_fifo.DATA_WIDTH = 32;
defparam rnode_1to2_bb2_sub_0_reg_2_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to2_bb2_sub_0_reg_2_fifo.IMPL = "ll_reg";

assign rnode_1to2_bb2_sub_0_reg_2_inputs_ready_NO_SHIFT_REG = local_bb2_sub_valid_out;
assign local_bb2_sub_stall_in = rnode_1to2_bb2_sub_0_stall_out_reg_2_NO_SHIFT_REG;
assign rnode_1to2_bb2_sub_0_NO_SHIFT_REG = rnode_1to2_bb2_sub_0_reg_2_NO_SHIFT_REG;
assign rnode_1to2_bb2_sub_0_stall_in_reg_2_NO_SHIFT_REG = rnode_1to2_bb2_sub_0_stall_in_NO_SHIFT_REG;
assign rnode_1to2_bb2_sub_0_valid_out_NO_SHIFT_REG = rnode_1to2_bb2_sub_0_valid_out_reg_2_NO_SHIFT_REG;

// This section implements a staging register.
// 
wire rstag_2to2_bb2_arrayidx_valid_out;
wire rstag_2to2_bb2_arrayidx_stall_in;
wire rstag_2to2_bb2_arrayidx_inputs_ready;
wire rstag_2to2_bb2_arrayidx_stall_local;
 reg rstag_2to2_bb2_arrayidx_staging_valid_NO_SHIFT_REG;
wire rstag_2to2_bb2_arrayidx_combined_valid;
 reg [63:0] rstag_2to2_bb2_arrayidx_staging_reg_NO_SHIFT_REG;
wire [63:0] rstag_2to2_bb2_arrayidx;

assign rstag_2to2_bb2_arrayidx_inputs_ready = local_bb2_arrayidx_valid_out;
assign rstag_2to2_bb2_arrayidx = (rstag_2to2_bb2_arrayidx_staging_valid_NO_SHIFT_REG ? rstag_2to2_bb2_arrayidx_staging_reg_NO_SHIFT_REG : local_bb2_arrayidx);
assign rstag_2to2_bb2_arrayidx_combined_valid = (rstag_2to2_bb2_arrayidx_staging_valid_NO_SHIFT_REG | rstag_2to2_bb2_arrayidx_inputs_ready);
assign rstag_2to2_bb2_arrayidx_valid_out = rstag_2to2_bb2_arrayidx_combined_valid;
assign rstag_2to2_bb2_arrayidx_stall_local = rstag_2to2_bb2_arrayidx_stall_in;
assign local_bb2_arrayidx_stall_in = (|rstag_2to2_bb2_arrayidx_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_2to2_bb2_arrayidx_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_2to2_bb2_arrayidx_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_2to2_bb2_arrayidx_stall_local)
		begin
			if (~(rstag_2to2_bb2_arrayidx_staging_valid_NO_SHIFT_REG))
			begin
				rstag_2to2_bb2_arrayidx_staging_valid_NO_SHIFT_REG <= rstag_2to2_bb2_arrayidx_inputs_ready;
			end
		end
		else
		begin
			rstag_2to2_bb2_arrayidx_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_2to2_bb2_arrayidx_staging_valid_NO_SHIFT_REG))
		begin
			rstag_2to2_bb2_arrayidx_staging_reg_NO_SHIFT_REG <= local_bb2_arrayidx;
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_176to177_indvars_iv_0_valid_out_NO_SHIFT_REG;
 logic rnode_176to177_indvars_iv_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_176to177_indvars_iv_0_NO_SHIFT_REG;
 logic rnode_176to177_indvars_iv_0_reg_177_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_176to177_indvars_iv_0_reg_177_NO_SHIFT_REG;
 logic rnode_176to177_indvars_iv_0_valid_out_reg_177_NO_SHIFT_REG;
 logic rnode_176to177_indvars_iv_0_stall_in_reg_177_NO_SHIFT_REG;
 logic rnode_176to177_indvars_iv_0_stall_out_reg_177_NO_SHIFT_REG;

acl_data_fifo rnode_176to177_indvars_iv_0_reg_177_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_176to177_indvars_iv_0_reg_177_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_176to177_indvars_iv_0_stall_in_reg_177_NO_SHIFT_REG),
	.valid_out(rnode_176to177_indvars_iv_0_valid_out_reg_177_NO_SHIFT_REG),
	.stall_out(rnode_176to177_indvars_iv_0_stall_out_reg_177_NO_SHIFT_REG),
	.data_in(rnode_2to176_indvars_iv_0_NO_SHIFT_REG),
	.data_out(rnode_176to177_indvars_iv_0_reg_177_NO_SHIFT_REG)
);

defparam rnode_176to177_indvars_iv_0_reg_177_fifo.DEPTH = 2;
defparam rnode_176to177_indvars_iv_0_reg_177_fifo.DATA_WIDTH = 64;
defparam rnode_176to177_indvars_iv_0_reg_177_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_176to177_indvars_iv_0_reg_177_fifo.IMPL = "ll_reg";

assign rnode_176to177_indvars_iv_0_reg_177_inputs_ready_NO_SHIFT_REG = rnode_2to176_indvars_iv_0_valid_out_NO_SHIFT_REG;
assign rnode_2to176_indvars_iv_0_stall_in_NO_SHIFT_REG = rnode_176to177_indvars_iv_0_stall_out_reg_177_NO_SHIFT_REG;
assign rnode_176to177_indvars_iv_0_NO_SHIFT_REG = rnode_176to177_indvars_iv_0_reg_177_NO_SHIFT_REG;
assign rnode_176to177_indvars_iv_0_stall_in_reg_177_NO_SHIFT_REG = rnode_176to177_indvars_iv_0_stall_in_NO_SHIFT_REG;
assign rnode_176to177_indvars_iv_0_valid_out_NO_SHIFT_REG = rnode_176to177_indvars_iv_0_valid_out_reg_177_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_178to179_add_0_valid_out_NO_SHIFT_REG;
 logic rnode_178to179_add_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_178to179_add_0_NO_SHIFT_REG;
 logic rnode_178to179_add_0_reg_179_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_178to179_add_0_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_add_0_valid_out_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_add_0_stall_in_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_add_0_stall_out_reg_179_NO_SHIFT_REG;

acl_data_fifo rnode_178to179_add_0_reg_179_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_178to179_add_0_reg_179_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_178to179_add_0_stall_in_reg_179_NO_SHIFT_REG),
	.valid_out(rnode_178to179_add_0_valid_out_reg_179_NO_SHIFT_REG),
	.stall_out(rnode_178to179_add_0_stall_out_reg_179_NO_SHIFT_REG),
	.data_in(rnode_177to178_add_1_NO_SHIFT_REG),
	.data_out(rnode_178to179_add_0_reg_179_NO_SHIFT_REG)
);

defparam rnode_178to179_add_0_reg_179_fifo.DEPTH = 2;
defparam rnode_178to179_add_0_reg_179_fifo.DATA_WIDTH = 32;
defparam rnode_178to179_add_0_reg_179_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_178to179_add_0_reg_179_fifo.IMPL = "ll_reg";

assign rnode_178to179_add_0_reg_179_inputs_ready_NO_SHIFT_REG = rnode_177to178_add_0_valid_out_1_NO_SHIFT_REG;
assign rnode_177to178_add_0_stall_in_1_NO_SHIFT_REG = rnode_178to179_add_0_stall_out_reg_179_NO_SHIFT_REG;
assign rnode_178to179_add_0_NO_SHIFT_REG = rnode_178to179_add_0_reg_179_NO_SHIFT_REG;
assign rnode_178to179_add_0_stall_in_reg_179_NO_SHIFT_REG = rnode_178to179_add_0_stall_in_NO_SHIFT_REG;
assign rnode_178to179_add_0_valid_out_NO_SHIFT_REG = rnode_178to179_add_0_valid_out_reg_179_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_idxprom2_stall_local;
wire [63:0] local_bb2_idxprom2;

assign local_bb2_idxprom2[32] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[33] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[34] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[35] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[36] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[37] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[38] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[39] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[40] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[41] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[42] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[43] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[44] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[45] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[46] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[47] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[48] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[49] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[50] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[51] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[52] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[53] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[54] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[55] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[56] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[57] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[58] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[59] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[60] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[61] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[62] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[63] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG[31];
assign local_bb2_idxprom2[31:0] = rnode_1to2_bb2_sub_0_NO_SHIFT_REG;

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
	.stream_base_addr(),
	.stream_size(),
	.stream_reset(),
	.o_stall(local_bb2_ld__fu_stall_out),
	.i_valid(local_bb2_ld__inputs_ready),
	.i_address(rstag_2to2_bb2_arrayidx),
	.i_writedata(),
	.i_cmpdata(),
	.i_predicate(input_wii_cmp1_NEG),
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
defparam lsu_local_bb2_ld_.KERNEL_SIDE_MEM_LATENCY = 160;
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
defparam lsu_local_bb2_ld_.STYLE = "BURST-COALESCED";

assign local_bb2_ld__inputs_ready = (rnode_1to2_cmp1_NEG_0_valid_out_0_NO_SHIFT_REG & rstag_2to2_bb2_arrayidx_valid_out);
assign local_bb2_ld__output_regs_ready = (&(~(local_bb2_ld__valid_out_NO_SHIFT_REG) | ~(local_bb2_ld__stall_in)));
assign rnode_1to2_cmp1_NEG_0_stall_in_0_NO_SHIFT_REG = (local_bb2_ld__fu_stall_out | ~(local_bb2_ld__inputs_ready));
assign rstag_2to2_bb2_arrayidx_stall_in = (local_bb2_ld__fu_stall_out | ~(local_bb2_ld__inputs_ready));
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
wire local_bb2_indvars_iv_next_valid_out;
wire local_bb2_indvars_iv_next_stall_in;
wire local_bb2_indvars_iv_next_inputs_ready;
wire local_bb2_indvars_iv_next_stall_local;
wire [63:0] local_bb2_indvars_iv_next;

assign local_bb2_indvars_iv_next_inputs_ready = rnode_176to177_indvars_iv_0_valid_out_NO_SHIFT_REG;
assign local_bb2_indvars_iv_next = (rnode_176to177_indvars_iv_0_NO_SHIFT_REG + 64'h1);
assign local_bb2_indvars_iv_next_valid_out = local_bb2_indvars_iv_next_inputs_ready;
assign local_bb2_indvars_iv_next_stall_local = local_bb2_indvars_iv_next_stall_in;
assign rnode_176to177_indvars_iv_0_stall_in_NO_SHIFT_REG = (|local_bb2_indvars_iv_next_stall_local);

// This section implements an unregistered operation.
// 
wire local_bb2_arrayidx3_valid_out;
wire local_bb2_arrayidx3_stall_in;
wire local_bb2_arrayidx3_inputs_ready;
wire local_bb2_arrayidx3_stall_local;
wire [63:0] local_bb2_arrayidx3;

assign local_bb2_arrayidx3_inputs_ready = rnode_1to2_bb2_sub_0_valid_out_NO_SHIFT_REG;
assign local_bb2_arrayidx3 = (input_p + (local_bb2_idxprom2 << 6'h2));
assign local_bb2_arrayidx3_valid_out = local_bb2_arrayidx3_inputs_ready;
assign local_bb2_arrayidx3_stall_local = local_bb2_arrayidx3_stall_in;
assign rnode_1to2_bb2_sub_0_stall_in_NO_SHIFT_REG = (|local_bb2_arrayidx3_stall_local);

// This section implements a staging register.
// 
wire rstag_162to162_bb2_ld__valid_out;
wire rstag_162to162_bb2_ld__stall_in;
wire rstag_162to162_bb2_ld__inputs_ready;
wire rstag_162to162_bb2_ld__stall_local;
 reg rstag_162to162_bb2_ld__staging_valid_NO_SHIFT_REG;
wire rstag_162to162_bb2_ld__combined_valid;
 reg [31:0] rstag_162to162_bb2_ld__staging_reg_NO_SHIFT_REG;
wire [31:0] rstag_162to162_bb2_ld_;

assign rstag_162to162_bb2_ld__inputs_ready = local_bb2_ld__valid_out_NO_SHIFT_REG;
assign rstag_162to162_bb2_ld_ = (rstag_162to162_bb2_ld__staging_valid_NO_SHIFT_REG ? rstag_162to162_bb2_ld__staging_reg_NO_SHIFT_REG : local_bb2_ld__NO_SHIFT_REG);
assign rstag_162to162_bb2_ld__combined_valid = (rstag_162to162_bb2_ld__staging_valid_NO_SHIFT_REG | rstag_162to162_bb2_ld__inputs_ready);
assign rstag_162to162_bb2_ld__valid_out = rstag_162to162_bb2_ld__combined_valid;
assign rstag_162to162_bb2_ld__stall_local = rstag_162to162_bb2_ld__stall_in;
assign local_bb2_ld__stall_in = (|rstag_162to162_bb2_ld__staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_162to162_bb2_ld__staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_162to162_bb2_ld__staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_162to162_bb2_ld__stall_local)
		begin
			if (~(rstag_162to162_bb2_ld__staging_valid_NO_SHIFT_REG))
			begin
				rstag_162to162_bb2_ld__staging_valid_NO_SHIFT_REG <= rstag_162to162_bb2_ld__inputs_ready;
			end
		end
		else
		begin
			rstag_162to162_bb2_ld__staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_162to162_bb2_ld__staging_valid_NO_SHIFT_REG))
		begin
			rstag_162to162_bb2_ld__staging_reg_NO_SHIFT_REG <= local_bb2_ld__NO_SHIFT_REG;
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_177to178_bb2_indvars_iv_next_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_177to178_bb2_indvars_iv_next_0_stall_in_0_NO_SHIFT_REG;
 logic [63:0] rnode_177to178_bb2_indvars_iv_next_0_NO_SHIFT_REG;
 logic rnode_177to178_bb2_indvars_iv_next_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_177to178_bb2_indvars_iv_next_0_stall_in_1_NO_SHIFT_REG;
 logic [63:0] rnode_177to178_bb2_indvars_iv_next_1_NO_SHIFT_REG;
 logic rnode_177to178_bb2_indvars_iv_next_0_reg_178_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_177to178_bb2_indvars_iv_next_0_reg_178_NO_SHIFT_REG;
 logic rnode_177to178_bb2_indvars_iv_next_0_valid_out_0_reg_178_NO_SHIFT_REG;
 logic rnode_177to178_bb2_indvars_iv_next_0_stall_in_0_reg_178_NO_SHIFT_REG;
 logic rnode_177to178_bb2_indvars_iv_next_0_stall_out_reg_178_NO_SHIFT_REG;
 logic [63:0] rnode_177to178_bb2_indvars_iv_next_0_reg_178_NO_SHIFT_REG_fa;

acl_multi_fanout_adaptor rnode_177to178_bb2_indvars_iv_next_0_reg_178_fanout_adaptor (
	.clock(clock),
	.resetn(resetn),
	.data_in(rnode_177to178_bb2_indvars_iv_next_0_reg_178_NO_SHIFT_REG),
	.valid_in(rnode_177to178_bb2_indvars_iv_next_0_valid_out_0_reg_178_NO_SHIFT_REG),
	.stall_out(rnode_177to178_bb2_indvars_iv_next_0_stall_in_0_reg_178_NO_SHIFT_REG),
	.data_out(rnode_177to178_bb2_indvars_iv_next_0_reg_178_NO_SHIFT_REG_fa),
	.valid_out({rnode_177to178_bb2_indvars_iv_next_0_valid_out_0_NO_SHIFT_REG, rnode_177to178_bb2_indvars_iv_next_0_valid_out_1_NO_SHIFT_REG}),
	.stall_in({rnode_177to178_bb2_indvars_iv_next_0_stall_in_0_NO_SHIFT_REG, rnode_177to178_bb2_indvars_iv_next_0_stall_in_1_NO_SHIFT_REG})
);

defparam rnode_177to178_bb2_indvars_iv_next_0_reg_178_fanout_adaptor.DATA_WIDTH = 64;
defparam rnode_177to178_bb2_indvars_iv_next_0_reg_178_fanout_adaptor.NUM_FANOUTS = 2;

acl_data_fifo rnode_177to178_bb2_indvars_iv_next_0_reg_178_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_177to178_bb2_indvars_iv_next_0_reg_178_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_177to178_bb2_indvars_iv_next_0_stall_in_0_reg_178_NO_SHIFT_REG),
	.valid_out(rnode_177to178_bb2_indvars_iv_next_0_valid_out_0_reg_178_NO_SHIFT_REG),
	.stall_out(rnode_177to178_bb2_indvars_iv_next_0_stall_out_reg_178_NO_SHIFT_REG),
	.data_in(local_bb2_indvars_iv_next),
	.data_out(rnode_177to178_bb2_indvars_iv_next_0_reg_178_NO_SHIFT_REG)
);

defparam rnode_177to178_bb2_indvars_iv_next_0_reg_178_fifo.DEPTH = 2;
defparam rnode_177to178_bb2_indvars_iv_next_0_reg_178_fifo.DATA_WIDTH = 64;
defparam rnode_177to178_bb2_indvars_iv_next_0_reg_178_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_177to178_bb2_indvars_iv_next_0_reg_178_fifo.IMPL = "ll_reg";

assign rnode_177to178_bb2_indvars_iv_next_0_reg_178_inputs_ready_NO_SHIFT_REG = local_bb2_indvars_iv_next_valid_out;
assign local_bb2_indvars_iv_next_stall_in = rnode_177to178_bb2_indvars_iv_next_0_stall_out_reg_178_NO_SHIFT_REG;
assign rnode_177to178_bb2_indvars_iv_next_0_NO_SHIFT_REG = rnode_177to178_bb2_indvars_iv_next_0_reg_178_NO_SHIFT_REG_fa;
assign rnode_177to178_bb2_indvars_iv_next_1_NO_SHIFT_REG = rnode_177to178_bb2_indvars_iv_next_0_reg_178_NO_SHIFT_REG_fa;

// This section implements a registered operation.
// 
wire local_bb2_ld__u1_inputs_ready;
 reg local_bb2_ld__u1_valid_out_NO_SHIFT_REG;
wire local_bb2_ld__u1_stall_in;
wire local_bb2_ld__u1_output_regs_ready;
wire local_bb2_ld__u1_fu_stall_out;
wire local_bb2_ld__u1_fu_valid_out;
wire [31:0] local_bb2_ld__u1_lsu_dataout;
 reg [31:0] local_bb2_ld__u1_NO_SHIFT_REG;
wire local_bb2_ld__u1_causedstall;

lsu_top lsu_local_bb2_ld__u1 (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(),
	.stream_size(),
	.stream_reset(),
	.o_stall(local_bb2_ld__u1_fu_stall_out),
	.i_valid(local_bb2_ld__u1_inputs_ready),
	.i_address(local_bb2_arrayidx3),
	.i_writedata(),
	.i_cmpdata(),
	.i_predicate(input_wii_cmp1_NEG),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb2_ld__u1_output_regs_ready)),
	.o_valid(local_bb2_ld__u1_fu_valid_out),
	.o_readdata(local_bb2_ld__u1_lsu_dataout),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb2_ld__u1_active),
	.avm_address(avm_local_bb2_ld__u1_address),
	.avm_read(avm_local_bb2_ld__u1_read),
	.avm_readdata(avm_local_bb2_ld__u1_readdata),
	.avm_write(avm_local_bb2_ld__u1_write),
	.avm_writeack(avm_local_bb2_ld__u1_writeack),
	.avm_burstcount(avm_local_bb2_ld__u1_burstcount),
	.avm_writedata(avm_local_bb2_ld__u1_writedata),
	.avm_byteenable(avm_local_bb2_ld__u1_byteenable),
	.avm_waitrequest(avm_local_bb2_ld__u1_waitrequest),
	.avm_readdatavalid(avm_local_bb2_ld__u1_readdatavalid),
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

defparam lsu_local_bb2_ld__u1.AWIDTH = 30;
defparam lsu_local_bb2_ld__u1.WIDTH_BYTES = 4;
defparam lsu_local_bb2_ld__u1.MWIDTH_BYTES = 32;
defparam lsu_local_bb2_ld__u1.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb2_ld__u1.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb2_ld__u1.READ = 1;
defparam lsu_local_bb2_ld__u1.ATOMIC = 0;
defparam lsu_local_bb2_ld__u1.WIDTH = 32;
defparam lsu_local_bb2_ld__u1.MWIDTH = 256;
defparam lsu_local_bb2_ld__u1.ATOMIC_WIDTH = 3;
defparam lsu_local_bb2_ld__u1.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb2_ld__u1.KERNEL_SIDE_MEM_LATENCY = 160;
defparam lsu_local_bb2_ld__u1.MEMORY_SIDE_MEM_LATENCY = 122;
defparam lsu_local_bb2_ld__u1.USE_WRITE_ACK = 0;
defparam lsu_local_bb2_ld__u1.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb2_ld__u1.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb2_ld__u1.NUMBER_BANKS = 1;
defparam lsu_local_bb2_ld__u1.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb2_ld__u1.USEINPUTFIFO = 0;
defparam lsu_local_bb2_ld__u1.USECACHING = 0;
defparam lsu_local_bb2_ld__u1.USEOUTPUTFIFO = 1;
defparam lsu_local_bb2_ld__u1.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb2_ld__u1.HIGH_FMAX = 1;
defparam lsu_local_bb2_ld__u1.ADDRSPACE = 1;
defparam lsu_local_bb2_ld__u1.STYLE = "BURST-COALESCED";

assign local_bb2_ld__u1_inputs_ready = (local_bb2_arrayidx3_valid_out & rnode_1to2_cmp1_NEG_0_valid_out_1_NO_SHIFT_REG);
assign local_bb2_ld__u1_output_regs_ready = (&(~(local_bb2_ld__u1_valid_out_NO_SHIFT_REG) | ~(local_bb2_ld__u1_stall_in)));
assign local_bb2_arrayidx3_stall_in = (local_bb2_ld__u1_fu_stall_out | ~(local_bb2_ld__u1_inputs_ready));
assign rnode_1to2_cmp1_NEG_0_stall_in_1_NO_SHIFT_REG = (local_bb2_ld__u1_fu_stall_out | ~(local_bb2_ld__u1_inputs_ready));
assign local_bb2_ld__u1_causedstall = (local_bb2_ld__u1_inputs_ready && (local_bb2_ld__u1_fu_stall_out && !(~(local_bb2_ld__u1_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_ld__u1_NO_SHIFT_REG <= 'x;
		local_bb2_ld__u1_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb2_ld__u1_output_regs_ready)
		begin
			local_bb2_ld__u1_NO_SHIFT_REG <= local_bb2_ld__u1_lsu_dataout;
			local_bb2_ld__u1_valid_out_NO_SHIFT_REG <= local_bb2_ld__u1_fu_valid_out;
		end
		else
		begin
			if (~(local_bb2_ld__u1_stall_in))
			begin
				local_bb2_ld__u1_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb2_c0_eni1_stall_local;
wire [127:0] local_bb2_c0_eni1;

assign local_bb2_c0_eni1[31:0] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
assign local_bb2_c0_eni1[63:32] = rstag_162to162_bb2_ld_;
assign local_bb2_c0_eni1[127:64] = 64'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;

// This section implements an unregistered operation.
// 
wire local_bb2_var__u2_stall_local;
wire [31:0] local_bb2_var__u2;

assign local_bb2_var__u2 = rnode_177to178_bb2_indvars_iv_next_0_NO_SHIFT_REG[31:0];

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_178to179_bb2_indvars_iv_next_0_valid_out_NO_SHIFT_REG;
 logic rnode_178to179_bb2_indvars_iv_next_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_178to179_bb2_indvars_iv_next_0_NO_SHIFT_REG;
 logic rnode_178to179_bb2_indvars_iv_next_0_reg_179_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_178to179_bb2_indvars_iv_next_0_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_bb2_indvars_iv_next_0_valid_out_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_bb2_indvars_iv_next_0_stall_in_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_bb2_indvars_iv_next_0_stall_out_reg_179_NO_SHIFT_REG;

acl_data_fifo rnode_178to179_bb2_indvars_iv_next_0_reg_179_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_178to179_bb2_indvars_iv_next_0_reg_179_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_178to179_bb2_indvars_iv_next_0_stall_in_reg_179_NO_SHIFT_REG),
	.valid_out(rnode_178to179_bb2_indvars_iv_next_0_valid_out_reg_179_NO_SHIFT_REG),
	.stall_out(rnode_178to179_bb2_indvars_iv_next_0_stall_out_reg_179_NO_SHIFT_REG),
	.data_in(rnode_177to178_bb2_indvars_iv_next_1_NO_SHIFT_REG),
	.data_out(rnode_178to179_bb2_indvars_iv_next_0_reg_179_NO_SHIFT_REG)
);

defparam rnode_178to179_bb2_indvars_iv_next_0_reg_179_fifo.DEPTH = 2;
defparam rnode_178to179_bb2_indvars_iv_next_0_reg_179_fifo.DATA_WIDTH = 64;
defparam rnode_178to179_bb2_indvars_iv_next_0_reg_179_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_178to179_bb2_indvars_iv_next_0_reg_179_fifo.IMPL = "ll_reg";

assign rnode_178to179_bb2_indvars_iv_next_0_reg_179_inputs_ready_NO_SHIFT_REG = rnode_177to178_bb2_indvars_iv_next_0_valid_out_1_NO_SHIFT_REG;
assign rnode_177to178_bb2_indvars_iv_next_0_stall_in_1_NO_SHIFT_REG = rnode_178to179_bb2_indvars_iv_next_0_stall_out_reg_179_NO_SHIFT_REG;
assign rnode_178to179_bb2_indvars_iv_next_0_NO_SHIFT_REG = rnode_178to179_bb2_indvars_iv_next_0_reg_179_NO_SHIFT_REG;
assign rnode_178to179_bb2_indvars_iv_next_0_stall_in_reg_179_NO_SHIFT_REG = rnode_178to179_bb2_indvars_iv_next_0_stall_in_NO_SHIFT_REG;
assign rnode_178to179_bb2_indvars_iv_next_0_valid_out_NO_SHIFT_REG = rnode_178to179_bb2_indvars_iv_next_0_valid_out_reg_179_NO_SHIFT_REG;

// This section implements a staging register.
// 
wire rstag_162to162_bb2_ld__u1_valid_out;
wire rstag_162to162_bb2_ld__u1_stall_in;
wire rstag_162to162_bb2_ld__u1_inputs_ready;
wire rstag_162to162_bb2_ld__u1_stall_local;
 reg rstag_162to162_bb2_ld__u1_staging_valid_NO_SHIFT_REG;
wire rstag_162to162_bb2_ld__u1_combined_valid;
 reg [31:0] rstag_162to162_bb2_ld__u1_staging_reg_NO_SHIFT_REG;
wire [31:0] rstag_162to162_bb2_ld__u1;

assign rstag_162to162_bb2_ld__u1_inputs_ready = local_bb2_ld__u1_valid_out_NO_SHIFT_REG;
assign rstag_162to162_bb2_ld__u1 = (rstag_162to162_bb2_ld__u1_staging_valid_NO_SHIFT_REG ? rstag_162to162_bb2_ld__u1_staging_reg_NO_SHIFT_REG : local_bb2_ld__u1_NO_SHIFT_REG);
assign rstag_162to162_bb2_ld__u1_combined_valid = (rstag_162to162_bb2_ld__u1_staging_valid_NO_SHIFT_REG | rstag_162to162_bb2_ld__u1_inputs_ready);
assign rstag_162to162_bb2_ld__u1_valid_out = rstag_162to162_bb2_ld__u1_combined_valid;
assign rstag_162to162_bb2_ld__u1_stall_local = rstag_162to162_bb2_ld__u1_stall_in;
assign local_bb2_ld__u1_stall_in = (|rstag_162to162_bb2_ld__u1_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_162to162_bb2_ld__u1_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_162to162_bb2_ld__u1_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_162to162_bb2_ld__u1_stall_local)
		begin
			if (~(rstag_162to162_bb2_ld__u1_staging_valid_NO_SHIFT_REG))
			begin
				rstag_162to162_bb2_ld__u1_staging_valid_NO_SHIFT_REG <= rstag_162to162_bb2_ld__u1_inputs_ready;
			end
		end
		else
		begin
			rstag_162to162_bb2_ld__u1_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_162to162_bb2_ld__u1_staging_valid_NO_SHIFT_REG))
		begin
			rstag_162to162_bb2_ld__u1_staging_reg_NO_SHIFT_REG <= local_bb2_ld__u1_NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb2_cmp15_valid_out;
wire local_bb2_cmp15_stall_in;
wire local_bb2_cmp15_inputs_ready;
wire local_bb2_cmp15_stall_local;
wire local_bb2_cmp15;

assign local_bb2_cmp15_inputs_ready = (rnode_177to178_add_0_valid_out_0_NO_SHIFT_REG & rnode_177to178_bb2_indvars_iv_next_0_valid_out_0_NO_SHIFT_REG);
assign local_bb2_cmp15 = ($signed(local_bb2_var__u2) >= $signed(rnode_177to178_add_0_NO_SHIFT_REG));
assign local_bb2_cmp15_valid_out = local_bb2_cmp15_inputs_ready;
assign local_bb2_cmp15_stall_local = local_bb2_cmp15_stall_in;
assign rnode_177to178_add_0_stall_in_0_NO_SHIFT_REG = (local_bb2_cmp15_stall_local | ~(local_bb2_cmp15_inputs_ready));
assign rnode_177to178_bb2_indvars_iv_next_0_stall_in_0_NO_SHIFT_REG = (local_bb2_cmp15_stall_local | ~(local_bb2_cmp15_inputs_ready));

// This section implements an unregistered operation.
// 
wire local_bb2_c0_eni2_stall_local;
wire [127:0] local_bb2_c0_eni2;

assign local_bb2_c0_eni2[63:0] = local_bb2_c0_eni1[63:0];
assign local_bb2_c0_eni2[95:64] = rstag_162to162_bb2_ld__u1;
assign local_bb2_c0_eni2[127:96] = local_bb2_c0_eni1[127:96];

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_178to179_bb2_cmp15_0_valid_out_NO_SHIFT_REG;
 logic rnode_178to179_bb2_cmp15_0_stall_in_NO_SHIFT_REG;
 logic rnode_178to179_bb2_cmp15_0_NO_SHIFT_REG;
 logic rnode_178to179_bb2_cmp15_0_reg_179_inputs_ready_NO_SHIFT_REG;
 logic rnode_178to179_bb2_cmp15_0_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_bb2_cmp15_0_valid_out_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_bb2_cmp15_0_stall_in_reg_179_NO_SHIFT_REG;
 logic rnode_178to179_bb2_cmp15_0_stall_out_reg_179_NO_SHIFT_REG;

acl_data_fifo rnode_178to179_bb2_cmp15_0_reg_179_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_178to179_bb2_cmp15_0_reg_179_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_178to179_bb2_cmp15_0_stall_in_reg_179_NO_SHIFT_REG),
	.valid_out(rnode_178to179_bb2_cmp15_0_valid_out_reg_179_NO_SHIFT_REG),
	.stall_out(rnode_178to179_bb2_cmp15_0_stall_out_reg_179_NO_SHIFT_REG),
	.data_in(local_bb2_cmp15),
	.data_out(rnode_178to179_bb2_cmp15_0_reg_179_NO_SHIFT_REG)
);

defparam rnode_178to179_bb2_cmp15_0_reg_179_fifo.DEPTH = 2;
defparam rnode_178to179_bb2_cmp15_0_reg_179_fifo.DATA_WIDTH = 1;
defparam rnode_178to179_bb2_cmp15_0_reg_179_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_178to179_bb2_cmp15_0_reg_179_fifo.IMPL = "ll_reg";

assign rnode_178to179_bb2_cmp15_0_reg_179_inputs_ready_NO_SHIFT_REG = local_bb2_cmp15_valid_out;
assign local_bb2_cmp15_stall_in = rnode_178to179_bb2_cmp15_0_stall_out_reg_179_NO_SHIFT_REG;
assign rnode_178to179_bb2_cmp15_0_NO_SHIFT_REG = rnode_178to179_bb2_cmp15_0_reg_179_NO_SHIFT_REG;
assign rnode_178to179_bb2_cmp15_0_stall_in_reg_179_NO_SHIFT_REG = rnode_178to179_bb2_cmp15_0_stall_in_NO_SHIFT_REG;
assign rnode_178to179_bb2_cmp15_0_valid_out_NO_SHIFT_REG = rnode_178to179_bb2_cmp15_0_valid_out_reg_179_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_c0_eni3_valid_out;
wire local_bb2_c0_eni3_stall_in;
wire local_bb2_c0_eni3_inputs_ready;
wire local_bb2_c0_eni3_stall_local;
wire [127:0] local_bb2_c0_eni3;

assign local_bb2_c0_eni3_inputs_ready = (rnode_161to162_score_02_0_valid_out_NO_SHIFT_REG & rstag_162to162_bb2_ld__valid_out & rstag_162to162_bb2_ld__u1_valid_out);
assign local_bb2_c0_eni3[95:0] = local_bb2_c0_eni2[95:0];
assign local_bb2_c0_eni3[127:96] = rnode_161to162_score_02_0_NO_SHIFT_REG;
assign local_bb2_c0_eni3_valid_out = local_bb2_c0_eni3_inputs_ready;
assign local_bb2_c0_eni3_stall_local = local_bb2_c0_eni3_stall_in;
assign rnode_161to162_score_02_0_stall_in_NO_SHIFT_REG = (local_bb2_c0_eni3_stall_local | ~(local_bb2_c0_eni3_inputs_ready));
assign rstag_162to162_bb2_ld__stall_in = (local_bb2_c0_eni3_stall_local | ~(local_bb2_c0_eni3_inputs_ready));
assign rstag_162to162_bb2_ld__u1_stall_in = (local_bb2_c0_eni3_stall_local | ~(local_bb2_c0_eni3_inputs_ready));

// This section implements an unregistered operation.
// 
wire local_bb2_cmp15_GUARD_valid_out;
wire local_bb2_cmp15_GUARD_stall_in;
wire local_bb2_cmp15_GUARD_inputs_ready;
wire local_bb2_cmp15_GUARD_stall_local;
wire local_bb2_cmp15_GUARD;

assign local_bb2_cmp15_GUARD_inputs_ready = rnode_178to179_bb2_cmp15_0_valid_out_NO_SHIFT_REG;
assign local_bb2_cmp15_GUARD = (rnode_178to179_bb2_cmp15_0_NO_SHIFT_REG | input_wii_cmp1_NEG);
assign local_bb2_cmp15_GUARD_valid_out = local_bb2_cmp15_GUARD_inputs_ready;
assign local_bb2_cmp15_GUARD_stall_local = local_bb2_cmp15_GUARD_stall_in;
assign rnode_178to179_bb2_cmp15_0_stall_in_NO_SHIFT_REG = (|local_bb2_cmp15_GUARD_stall_local);

// This section implements a registered operation.
// 
wire local_bb2_c0_enter_c0_eni3_inputs_ready;
 reg local_bb2_c0_enter_c0_eni3_valid_out_0_NO_SHIFT_REG;
wire local_bb2_c0_enter_c0_eni3_stall_in_0;
 reg local_bb2_c0_enter_c0_eni3_valid_out_1_NO_SHIFT_REG;
wire local_bb2_c0_enter_c0_eni3_stall_in_1;
 reg local_bb2_c0_enter_c0_eni3_valid_out_2_NO_SHIFT_REG;
wire local_bb2_c0_enter_c0_eni3_stall_in_2;
wire local_bb2_c0_enter_c0_eni3_output_regs_ready;
 reg [127:0] local_bb2_c0_enter_c0_eni3_NO_SHIFT_REG;
wire local_bb2_c0_enter_c0_eni3_input_accepted;
wire local_bb2_c0_exit_c0_exi1_entry_stall;
wire local_bb2_c0_exit_c0_exi1_output_regs_ready;
wire [12:0] local_bb2_c0_exit_c0_exi1_valid_bits;
wire local_bb2_c0_exit_c0_exi1_phases;
wire local_bb2_c0_enter_c0_eni3_inc_pipelined_thread;
wire local_bb2_c0_enter_c0_eni3_dec_pipelined_thread;
wire local_bb2_c0_enter_c0_eni3_causedstall;

assign local_bb2_c0_enter_c0_eni3_inputs_ready = local_bb2_c0_eni3_valid_out;
assign local_bb2_c0_enter_c0_eni3_output_regs_ready = 1'b1;
assign local_bb2_c0_enter_c0_eni3_input_accepted = (local_bb2_c0_enter_c0_eni3_inputs_ready && !(local_bb2_c0_exit_c0_exi1_entry_stall));
assign local_bb2_c0_enter_c0_eni3_inc_pipelined_thread = 1'b1;
assign local_bb2_c0_enter_c0_eni3_dec_pipelined_thread = ~(1'b0);
assign local_bb2_c0_eni3_stall_in = ((~(local_bb2_c0_enter_c0_eni3_inputs_ready) | local_bb2_c0_exit_c0_exi1_entry_stall) | ~(1'b1));
assign local_bb2_c0_enter_c0_eni3_causedstall = (1'b1 && ((~(local_bb2_c0_enter_c0_eni3_inputs_ready) | local_bb2_c0_exit_c0_exi1_entry_stall) && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_c0_enter_c0_eni3_NO_SHIFT_REG <= 'x;
		local_bb2_c0_enter_c0_eni3_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_c0_enter_c0_eni3_valid_out_1_NO_SHIFT_REG <= 1'b0;
		local_bb2_c0_enter_c0_eni3_valid_out_2_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb2_c0_enter_c0_eni3_output_regs_ready)
		begin
			local_bb2_c0_enter_c0_eni3_NO_SHIFT_REG <= local_bb2_c0_eni3;
			local_bb2_c0_enter_c0_eni3_valid_out_0_NO_SHIFT_REG <= 1'b1;
			local_bb2_c0_enter_c0_eni3_valid_out_1_NO_SHIFT_REG <= 1'b1;
			local_bb2_c0_enter_c0_eni3_valid_out_2_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb2_c0_enter_c0_eni3_stall_in_0))
			begin
				local_bb2_c0_enter_c0_eni3_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb2_c0_enter_c0_eni3_stall_in_1))
			begin
				local_bb2_c0_enter_c0_eni3_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb2_c0_enter_c0_eni3_stall_in_2))
			begin
				local_bb2_c0_enter_c0_eni3_valid_out_2_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb2_c0_ene1_stall_local;
wire [31:0] local_bb2_c0_ene1;

assign local_bb2_c0_ene1 = local_bb2_c0_enter_c0_eni3_NO_SHIFT_REG[63:32];

// This section implements an unregistered operation.
// 
wire local_bb2_c0_ene2_stall_local;
wire [31:0] local_bb2_c0_ene2;

assign local_bb2_c0_ene2 = local_bb2_c0_enter_c0_eni3_NO_SHIFT_REG[95:64];

// This section implements an unregistered operation.
// 
wire local_bb2_c0_ene3_valid_out;
wire local_bb2_c0_ene3_stall_in;
wire local_bb2_c0_ene3_inputs_ready;
wire local_bb2_c0_ene3_stall_local;
wire [31:0] local_bb2_c0_ene3;

assign local_bb2_c0_ene3_inputs_ready = local_bb2_c0_enter_c0_eni3_valid_out_2_NO_SHIFT_REG;
assign local_bb2_c0_ene3 = local_bb2_c0_enter_c0_eni3_NO_SHIFT_REG[127:96];
assign local_bb2_c0_ene3_valid_out = 1'b1;
assign local_bb2_c0_enter_c0_eni3_stall_in_2 = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_var__u3_stall_local;
wire [31:0] local_bb2_var__u3;

assign local_bb2_var__u3 = local_bb2_c0_ene1;

// This section implements an unregistered operation.
// 
wire local_bb2_var__u4_stall_local;
wire [31:0] local_bb2_var__u4;

assign local_bb2_var__u4 = local_bb2_c0_ene2;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_163to164_bb2_c0_ene3_0_valid_out_NO_SHIFT_REG;
 logic rnode_163to164_bb2_c0_ene3_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_163to164_bb2_c0_ene3_0_NO_SHIFT_REG;
 logic rnode_163to164_bb2_c0_ene3_0_reg_164_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_163to164_bb2_c0_ene3_0_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2_c0_ene3_0_valid_out_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2_c0_ene3_0_stall_in_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2_c0_ene3_0_stall_out_reg_164_NO_SHIFT_REG;

acl_data_fifo rnode_163to164_bb2_c0_ene3_0_reg_164_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_163to164_bb2_c0_ene3_0_reg_164_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_163to164_bb2_c0_ene3_0_stall_in_reg_164_NO_SHIFT_REG),
	.valid_out(rnode_163to164_bb2_c0_ene3_0_valid_out_reg_164_NO_SHIFT_REG),
	.stall_out(rnode_163to164_bb2_c0_ene3_0_stall_out_reg_164_NO_SHIFT_REG),
	.data_in(local_bb2_c0_ene3),
	.data_out(rnode_163to164_bb2_c0_ene3_0_reg_164_NO_SHIFT_REG)
);

defparam rnode_163to164_bb2_c0_ene3_0_reg_164_fifo.DEPTH = 1;
defparam rnode_163to164_bb2_c0_ene3_0_reg_164_fifo.DATA_WIDTH = 32;
defparam rnode_163to164_bb2_c0_ene3_0_reg_164_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_163to164_bb2_c0_ene3_0_reg_164_fifo.IMPL = "shift_reg";

assign rnode_163to164_bb2_c0_ene3_0_reg_164_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_c0_ene3_stall_in = 1'b0;
assign rnode_163to164_bb2_c0_ene3_0_NO_SHIFT_REG = rnode_163to164_bb2_c0_ene3_0_reg_164_NO_SHIFT_REG;
assign rnode_163to164_bb2_c0_ene3_0_stall_in_reg_164_NO_SHIFT_REG = 1'b0;
assign rnode_163to164_bb2_c0_ene3_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_shr_i_stall_local;
wire [31:0] local_bb2_shr_i;

assign local_bb2_shr_i = (local_bb2_var__u3 >> 32'h17);

// This section implements an unregistered operation.
// 
wire local_bb2_and5_i_stall_local;
wire [31:0] local_bb2_and5_i;

assign local_bb2_and5_i = (local_bb2_var__u3 & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_shr2_i_stall_local;
wire [31:0] local_bb2_shr2_i;

assign local_bb2_shr2_i = (local_bb2_var__u4 >> 32'h17);

// This section implements an unregistered operation.
// 
wire local_bb2_xor_i_stall_local;
wire [31:0] local_bb2_xor_i;

assign local_bb2_xor_i = (local_bb2_var__u4 ^ local_bb2_var__u3);

// This section implements an unregistered operation.
// 
wire local_bb2_and6_i_stall_local;
wire [31:0] local_bb2_and6_i;

assign local_bb2_and6_i = (local_bb2_var__u4 & 32'h7FFFFF);

// Register node:
//  * latency = 3
//  * capacity = 3
 logic rnode_164to167_bb2_c0_ene3_0_valid_out_NO_SHIFT_REG;
 logic rnode_164to167_bb2_c0_ene3_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_164to167_bb2_c0_ene3_0_NO_SHIFT_REG;
 logic rnode_164to167_bb2_c0_ene3_0_reg_167_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_164to167_bb2_c0_ene3_0_reg_167_NO_SHIFT_REG;
 logic rnode_164to167_bb2_c0_ene3_0_valid_out_reg_167_NO_SHIFT_REG;
 logic rnode_164to167_bb2_c0_ene3_0_stall_in_reg_167_NO_SHIFT_REG;
 logic rnode_164to167_bb2_c0_ene3_0_stall_out_reg_167_NO_SHIFT_REG;

acl_data_fifo rnode_164to167_bb2_c0_ene3_0_reg_167_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_164to167_bb2_c0_ene3_0_reg_167_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_164to167_bb2_c0_ene3_0_stall_in_reg_167_NO_SHIFT_REG),
	.valid_out(rnode_164to167_bb2_c0_ene3_0_valid_out_reg_167_NO_SHIFT_REG),
	.stall_out(rnode_164to167_bb2_c0_ene3_0_stall_out_reg_167_NO_SHIFT_REG),
	.data_in(rnode_163to164_bb2_c0_ene3_0_NO_SHIFT_REG),
	.data_out(rnode_164to167_bb2_c0_ene3_0_reg_167_NO_SHIFT_REG)
);

defparam rnode_164to167_bb2_c0_ene3_0_reg_167_fifo.DEPTH = 3;
defparam rnode_164to167_bb2_c0_ene3_0_reg_167_fifo.DATA_WIDTH = 32;
defparam rnode_164to167_bb2_c0_ene3_0_reg_167_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_164to167_bb2_c0_ene3_0_reg_167_fifo.IMPL = "shift_reg";

assign rnode_164to167_bb2_c0_ene3_0_reg_167_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_163to164_bb2_c0_ene3_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_164to167_bb2_c0_ene3_0_NO_SHIFT_REG = rnode_164to167_bb2_c0_ene3_0_reg_167_NO_SHIFT_REG;
assign rnode_164to167_bb2_c0_ene3_0_stall_in_reg_167_NO_SHIFT_REG = 1'b0;
assign rnode_164to167_bb2_c0_ene3_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_and_i_stall_local;
wire [31:0] local_bb2_and_i;

assign local_bb2_and_i = (local_bb2_shr_i & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot14_i_stall_local;
wire local_bb2_lnot14_i;

assign local_bb2_lnot14_i = (local_bb2_and5_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or_i_stall_local;
wire [31:0] local_bb2_or_i;

assign local_bb2_or_i = (local_bb2_and5_i | 32'h800000);

// This section implements an unregistered operation.
// 
wire local_bb2_and3_i_stall_local;
wire [31:0] local_bb2_and3_i;

assign local_bb2_and3_i = (local_bb2_shr2_i & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot17_i_stall_local;
wire local_bb2_lnot17_i;

assign local_bb2_lnot17_i = (local_bb2_and6_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or47_i_stall_local;
wire [31:0] local_bb2_or47_i;

assign local_bb2_or47_i = (local_bb2_and6_i | 32'h800000);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_167to168_bb2_c0_ene3_0_valid_out_NO_SHIFT_REG;
 logic rnode_167to168_bb2_c0_ene3_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_167to168_bb2_c0_ene3_0_NO_SHIFT_REG;
 logic rnode_167to168_bb2_c0_ene3_0_reg_168_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_167to168_bb2_c0_ene3_0_reg_168_NO_SHIFT_REG;
 logic rnode_167to168_bb2_c0_ene3_0_valid_out_reg_168_NO_SHIFT_REG;
 logic rnode_167to168_bb2_c0_ene3_0_stall_in_reg_168_NO_SHIFT_REG;
 logic rnode_167to168_bb2_c0_ene3_0_stall_out_reg_168_NO_SHIFT_REG;

acl_data_fifo rnode_167to168_bb2_c0_ene3_0_reg_168_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_167to168_bb2_c0_ene3_0_reg_168_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_167to168_bb2_c0_ene3_0_stall_in_reg_168_NO_SHIFT_REG),
	.valid_out(rnode_167to168_bb2_c0_ene3_0_valid_out_reg_168_NO_SHIFT_REG),
	.stall_out(rnode_167to168_bb2_c0_ene3_0_stall_out_reg_168_NO_SHIFT_REG),
	.data_in(rnode_164to167_bb2_c0_ene3_0_NO_SHIFT_REG),
	.data_out(rnode_167to168_bb2_c0_ene3_0_reg_168_NO_SHIFT_REG)
);

defparam rnode_167to168_bb2_c0_ene3_0_reg_168_fifo.DEPTH = 1;
defparam rnode_167to168_bb2_c0_ene3_0_reg_168_fifo.DATA_WIDTH = 32;
defparam rnode_167to168_bb2_c0_ene3_0_reg_168_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_167to168_bb2_c0_ene3_0_reg_168_fifo.IMPL = "shift_reg";

assign rnode_167to168_bb2_c0_ene3_0_reg_168_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_164to167_bb2_c0_ene3_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_167to168_bb2_c0_ene3_0_NO_SHIFT_REG = rnode_167to168_bb2_c0_ene3_0_reg_168_NO_SHIFT_REG;
assign rnode_167to168_bb2_c0_ene3_0_stall_in_reg_168_NO_SHIFT_REG = 1'b0;
assign rnode_167to168_bb2_c0_ene3_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_i_stall_local;
wire local_bb2_lnot_i;

assign local_bb2_lnot_i = (local_bb2_and_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp_i_stall_local;
wire local_bb2_cmp_i;

assign local_bb2_cmp_i = (local_bb2_and_i == 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u5_stall_local;
wire [31:0] local_bb2_var__u5;

assign local_bb2_var__u5 = (local_bb2_and6_i | local_bb2_and_i);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot14_not_i_stall_local;
wire local_bb2_lnot14_not_i;

assign local_bb2_lnot14_not_i = (local_bb2_lnot14_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_conv_i_i_stall_local;
wire [63:0] local_bb2_conv_i_i;

assign local_bb2_conv_i_i[63:32] = 32'h0;
assign local_bb2_conv_i_i[31:0] = local_bb2_or_i;

// This section implements an unregistered operation.
// 
wire local_bb2_lnot8_i_stall_local;
wire local_bb2_lnot8_i;

assign local_bb2_lnot8_i = (local_bb2_and3_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp11_i_stall_local;
wire local_bb2_cmp11_i;

assign local_bb2_cmp11_i = (local_bb2_and3_i == 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u6_stall_local;
wire [31:0] local_bb2_var__u6;

assign local_bb2_var__u6 = (local_bb2_and3_i | local_bb2_and6_i);

// This section implements an unregistered operation.
// 
wire local_bb2_add_i_stall_local;
wire [31:0] local_bb2_add_i;

assign local_bb2_add_i = (local_bb2_and3_i + local_bb2_and_i);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot17_not_i_stall_local;
wire local_bb2_lnot17_not_i;

assign local_bb2_lnot17_not_i = (local_bb2_lnot17_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_conv1_i_i_stall_local;
wire [63:0] local_bb2_conv1_i_i;

assign local_bb2_conv1_i_i[63:32] = 32'h0;
assign local_bb2_conv1_i_i[31:0] = local_bb2_or47_i;

// This section implements an unregistered operation.
// 
wire local_bb2_var__u7_stall_local;
wire [31:0] local_bb2_var__u7;

assign local_bb2_var__u7 = rnode_167to168_bb2_c0_ene3_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_var__u8_stall_local;
wire local_bb2_var__u8;

assign local_bb2_var__u8 = (local_bb2_var__u5 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2__28_i_stall_local;
wire local_bb2__28_i;

assign local_bb2__28_i = (local_bb2_cmp_i & local_bb2_lnot14_not_i);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_0_i_stall_local;
wire local_bb2_reduction_0_i;

assign local_bb2_reduction_0_i = (local_bb2_lnot_i | local_bb2_lnot8_i);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge8_demorgan_i_stall_local;
wire local_bb2_brmerge8_demorgan_i;

assign local_bb2_brmerge8_demorgan_i = (local_bb2_cmp11_i & local_bb2_lnot17_i);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp11_not_i_stall_local;
wire local_bb2_cmp11_not_i;

assign local_bb2_cmp11_not_i = (local_bb2_cmp11_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u9_stall_local;
wire local_bb2_var__u9;

assign local_bb2_var__u9 = (local_bb2_cmp_i | local_bb2_cmp11_i);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u10_stall_local;
wire local_bb2_var__u10;

assign local_bb2_var__u10 = (local_bb2_var__u6 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_and2_i44_stall_local;
wire [31:0] local_bb2_and2_i44;

assign local_bb2_and2_i44 = (local_bb2_var__u7 >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb2_and12_i49_stall_local;
wire [31:0] local_bb2_and12_i49;

assign local_bb2_and12_i49 = (local_bb2_var__u7 & 32'hFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge10_demorgan_i_stall_local;
wire local_bb2_brmerge10_demorgan_i;

assign local_bb2_brmerge10_demorgan_i = (local_bb2_brmerge8_demorgan_i & local_bb2_lnot_i);

// This section implements an unregistered operation.
// 
wire local_bb2__mux9_mux_i_stall_local;
wire local_bb2__mux9_mux_i;

assign local_bb2__mux9_mux_i = (local_bb2_brmerge8_demorgan_i ^ local_bb2_cmp11_i);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge3_i_stall_local;
wire local_bb2_brmerge3_i;

assign local_bb2_brmerge3_i = (local_bb2_var__u10 | local_bb2_cmp11_not_i);

// This section implements an unregistered operation.
// 
wire local_bb2__mux_mux_i_stall_local;
wire local_bb2__mux_mux_i;

assign local_bb2__mux_mux_i = (local_bb2_var__u10 | local_bb2_cmp11_i);

// This section implements an unregistered operation.
// 
wire local_bb2__not_i_stall_local;
wire local_bb2__not_i;

assign local_bb2__not_i = (local_bb2_var__u10 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_shr3_i45_stall_local;
wire [31:0] local_bb2_shr3_i45;

assign local_bb2_shr3_i45 = (local_bb2_and2_i44 & 32'h7FFF);

// This section implements an unregistered operation.
// 
wire local_bb2__26_demorgan_i_stall_local;
wire local_bb2__26_demorgan_i;

assign local_bb2__26_demorgan_i = (local_bb2_cmp_i | local_bb2_brmerge10_demorgan_i);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge5_i_stall_local;
wire local_bb2_brmerge5_i;

assign local_bb2_brmerge5_i = (local_bb2_brmerge3_i | local_bb2_lnot17_not_i);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_3_i_stall_local;
wire local_bb2_reduction_3_i;

assign local_bb2_reduction_3_i = (local_bb2_cmp11_i & local_bb2__not_i);

// This section implements an unregistered operation.
// 
wire local_bb2__mux_mux_mux_i_stall_local;
wire local_bb2__mux_mux_mux_i;

assign local_bb2__mux_mux_mux_i = (local_bb2_brmerge5_i & local_bb2__mux_mux_i);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_5_i_stall_local;
wire local_bb2_reduction_5_i;

assign local_bb2_reduction_5_i = (local_bb2_lnot14_i & local_bb2_reduction_3_i);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_6_i_stall_local;
wire local_bb2_reduction_6_i;

assign local_bb2_reduction_6_i = (local_bb2_var__u8 & local_bb2_reduction_5_i);

// This section implements an unregistered operation.
// 
wire local_bb2__24_i_stall_local;
wire local_bb2__24_i;

assign local_bb2__24_i = (local_bb2_cmp_i ? local_bb2_reduction_6_i : local_bb2_brmerge10_demorgan_i);

// This section implements an unregistered operation.
// 
wire local_bb2__25_i_stall_local;
wire local_bb2__25_i;

assign local_bb2__25_i = (local_bb2__24_i ? local_bb2_lnot14_i : local_bb2__mux_mux_mux_i);

// This section implements an unregistered operation.
// 
wire local_bb2__27_i_stall_local;
wire local_bb2__27_i;

assign local_bb2__27_i = (local_bb2__26_demorgan_i ? local_bb2__25_i : local_bb2__mux9_mux_i);

// This section implements an unregistered operation.
// 
wire local_bb2_xor_i_valid_out;
wire local_bb2_xor_i_stall_in;
 reg local_bb2_xor_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_add_i_valid_out;
wire local_bb2_add_i_stall_in;
 reg local_bb2_add_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_conv_i_i_valid_out;
wire local_bb2_conv_i_i_stall_in;
 reg local_bb2_conv_i_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_conv1_i_i_valid_out;
wire local_bb2_conv1_i_i_stall_in;
 reg local_bb2_conv1_i_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_reduction_0_i_valid_out;
wire local_bb2_reduction_0_i_stall_in;
 reg local_bb2_reduction_0_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_var__u9_valid_out;
wire local_bb2_var__u9_stall_in;
 reg local_bb2_var__u9_consumed_0_NO_SHIFT_REG;
wire local_bb2__29_i_valid_out;
wire local_bb2__29_i_stall_in;
 reg local_bb2__29_i_consumed_0_NO_SHIFT_REG;
wire local_bb2__29_i_inputs_ready;
wire local_bb2__29_i_stall_local;
wire local_bb2__29_i;

assign local_bb2__29_i_inputs_ready = (local_bb2_c0_enter_c0_eni3_valid_out_0_NO_SHIFT_REG & local_bb2_c0_enter_c0_eni3_valid_out_1_NO_SHIFT_REG);
assign local_bb2__29_i = (local_bb2__28_i | local_bb2__27_i);
assign local_bb2_xor_i_valid_out = 1'b1;
assign local_bb2_add_i_valid_out = 1'b1;
assign local_bb2_conv_i_i_valid_out = 1'b1;
assign local_bb2_conv1_i_i_valid_out = 1'b1;
assign local_bb2_reduction_0_i_valid_out = 1'b1;
assign local_bb2_var__u9_valid_out = 1'b1;
assign local_bb2__29_i_valid_out = 1'b1;
assign local_bb2_c0_enter_c0_eni3_stall_in_0 = 1'b0;
assign local_bb2_c0_enter_c0_eni3_stall_in_1 = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_xor_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_add_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_conv_i_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_conv1_i_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_reduction_0_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_var__u9_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2__29_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_xor_i_consumed_0_NO_SHIFT_REG <= (local_bb2__29_i_inputs_ready & (local_bb2_xor_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_xor_i_stall_in)) & local_bb2__29_i_stall_local);
		local_bb2_add_i_consumed_0_NO_SHIFT_REG <= (local_bb2__29_i_inputs_ready & (local_bb2_add_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_add_i_stall_in)) & local_bb2__29_i_stall_local);
		local_bb2_conv_i_i_consumed_0_NO_SHIFT_REG <= (local_bb2__29_i_inputs_ready & (local_bb2_conv_i_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_conv_i_i_stall_in)) & local_bb2__29_i_stall_local);
		local_bb2_conv1_i_i_consumed_0_NO_SHIFT_REG <= (local_bb2__29_i_inputs_ready & (local_bb2_conv1_i_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_conv1_i_i_stall_in)) & local_bb2__29_i_stall_local);
		local_bb2_reduction_0_i_consumed_0_NO_SHIFT_REG <= (local_bb2__29_i_inputs_ready & (local_bb2_reduction_0_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_reduction_0_i_stall_in)) & local_bb2__29_i_stall_local);
		local_bb2_var__u9_consumed_0_NO_SHIFT_REG <= (local_bb2__29_i_inputs_ready & (local_bb2_var__u9_consumed_0_NO_SHIFT_REG | ~(local_bb2_var__u9_stall_in)) & local_bb2__29_i_stall_local);
		local_bb2__29_i_consumed_0_NO_SHIFT_REG <= (local_bb2__29_i_inputs_ready & (local_bb2__29_i_consumed_0_NO_SHIFT_REG | ~(local_bb2__29_i_stall_in)) & local_bb2__29_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_163to164_bb2_xor_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_163to164_bb2_xor_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_163to164_bb2_xor_i_0_NO_SHIFT_REG;
 logic rnode_163to164_bb2_xor_i_0_reg_164_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_163to164_bb2_xor_i_0_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2_xor_i_0_valid_out_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2_xor_i_0_stall_in_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2_xor_i_0_stall_out_reg_164_NO_SHIFT_REG;

acl_data_fifo rnode_163to164_bb2_xor_i_0_reg_164_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_163to164_bb2_xor_i_0_reg_164_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_163to164_bb2_xor_i_0_stall_in_reg_164_NO_SHIFT_REG),
	.valid_out(rnode_163to164_bb2_xor_i_0_valid_out_reg_164_NO_SHIFT_REG),
	.stall_out(rnode_163to164_bb2_xor_i_0_stall_out_reg_164_NO_SHIFT_REG),
	.data_in(local_bb2_xor_i),
	.data_out(rnode_163to164_bb2_xor_i_0_reg_164_NO_SHIFT_REG)
);

defparam rnode_163to164_bb2_xor_i_0_reg_164_fifo.DEPTH = 1;
defparam rnode_163to164_bb2_xor_i_0_reg_164_fifo.DATA_WIDTH = 32;
defparam rnode_163to164_bb2_xor_i_0_reg_164_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_163to164_bb2_xor_i_0_reg_164_fifo.IMPL = "shift_reg";

assign rnode_163to164_bb2_xor_i_0_reg_164_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_xor_i_stall_in = 1'b0;
assign rnode_163to164_bb2_xor_i_0_NO_SHIFT_REG = rnode_163to164_bb2_xor_i_0_reg_164_NO_SHIFT_REG;
assign rnode_163to164_bb2_xor_i_0_stall_in_reg_164_NO_SHIFT_REG = 1'b0;
assign rnode_163to164_bb2_xor_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_163to164_bb2_add_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_163to164_bb2_add_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_163to164_bb2_add_i_0_NO_SHIFT_REG;
 logic rnode_163to164_bb2_add_i_0_reg_164_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_163to164_bb2_add_i_0_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2_add_i_0_valid_out_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2_add_i_0_stall_in_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2_add_i_0_stall_out_reg_164_NO_SHIFT_REG;

acl_data_fifo rnode_163to164_bb2_add_i_0_reg_164_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_163to164_bb2_add_i_0_reg_164_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_163to164_bb2_add_i_0_stall_in_reg_164_NO_SHIFT_REG),
	.valid_out(rnode_163to164_bb2_add_i_0_valid_out_reg_164_NO_SHIFT_REG),
	.stall_out(rnode_163to164_bb2_add_i_0_stall_out_reg_164_NO_SHIFT_REG),
	.data_in(local_bb2_add_i),
	.data_out(rnode_163to164_bb2_add_i_0_reg_164_NO_SHIFT_REG)
);

defparam rnode_163to164_bb2_add_i_0_reg_164_fifo.DEPTH = 1;
defparam rnode_163to164_bb2_add_i_0_reg_164_fifo.DATA_WIDTH = 32;
defparam rnode_163to164_bb2_add_i_0_reg_164_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_163to164_bb2_add_i_0_reg_164_fifo.IMPL = "shift_reg";

assign rnode_163to164_bb2_add_i_0_reg_164_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_add_i_stall_in = 1'b0;
assign rnode_163to164_bb2_add_i_0_NO_SHIFT_REG = rnode_163to164_bb2_add_i_0_reg_164_NO_SHIFT_REG;
assign rnode_163to164_bb2_add_i_0_stall_in_reg_164_NO_SHIFT_REG = 1'b0;
assign rnode_163to164_bb2_add_i_0_valid_out_NO_SHIFT_REG = 1'b1;

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
	.dataa(local_bb2_conv1_i_i),
	.datab(local_bb2_conv_i_i),
	.enable(local_bb2_mul_i_i_output_regs_ready),
	.result(local_bb2_mul_i_i)
);

defparam int_module_local_bb2_mul_i_i.INPUT1_WIDTH = 24;
defparam int_module_local_bb2_mul_i_i.INPUT2_WIDTH = 24;

assign local_bb2_mul_i_i_inputs_ready = 1'b1;
assign local_bb2_mul_i_i_output_regs_ready = 1'b1;
assign local_bb2_conv1_i_i_stall_in = 1'b0;
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


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_163to164_bb2_reduction_0_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_163to164_bb2_reduction_0_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_163to164_bb2_reduction_0_i_0_NO_SHIFT_REG;
 logic rnode_163to164_bb2_reduction_0_i_0_reg_164_inputs_ready_NO_SHIFT_REG;
 logic rnode_163to164_bb2_reduction_0_i_0_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2_reduction_0_i_0_valid_out_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2_reduction_0_i_0_stall_in_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2_reduction_0_i_0_stall_out_reg_164_NO_SHIFT_REG;

acl_data_fifo rnode_163to164_bb2_reduction_0_i_0_reg_164_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_163to164_bb2_reduction_0_i_0_reg_164_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_163to164_bb2_reduction_0_i_0_stall_in_reg_164_NO_SHIFT_REG),
	.valid_out(rnode_163to164_bb2_reduction_0_i_0_valid_out_reg_164_NO_SHIFT_REG),
	.stall_out(rnode_163to164_bb2_reduction_0_i_0_stall_out_reg_164_NO_SHIFT_REG),
	.data_in(local_bb2_reduction_0_i),
	.data_out(rnode_163to164_bb2_reduction_0_i_0_reg_164_NO_SHIFT_REG)
);

defparam rnode_163to164_bb2_reduction_0_i_0_reg_164_fifo.DEPTH = 1;
defparam rnode_163to164_bb2_reduction_0_i_0_reg_164_fifo.DATA_WIDTH = 1;
defparam rnode_163to164_bb2_reduction_0_i_0_reg_164_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_163to164_bb2_reduction_0_i_0_reg_164_fifo.IMPL = "shift_reg";

assign rnode_163to164_bb2_reduction_0_i_0_reg_164_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_reduction_0_i_stall_in = 1'b0;
assign rnode_163to164_bb2_reduction_0_i_0_NO_SHIFT_REG = rnode_163to164_bb2_reduction_0_i_0_reg_164_NO_SHIFT_REG;
assign rnode_163to164_bb2_reduction_0_i_0_stall_in_reg_164_NO_SHIFT_REG = 1'b0;
assign rnode_163to164_bb2_reduction_0_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_163to164_bb2_var__u9_0_valid_out_NO_SHIFT_REG;
 logic rnode_163to164_bb2_var__u9_0_stall_in_NO_SHIFT_REG;
 logic rnode_163to164_bb2_var__u9_0_NO_SHIFT_REG;
 logic rnode_163to164_bb2_var__u9_0_reg_164_inputs_ready_NO_SHIFT_REG;
 logic rnode_163to164_bb2_var__u9_0_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2_var__u9_0_valid_out_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2_var__u9_0_stall_in_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2_var__u9_0_stall_out_reg_164_NO_SHIFT_REG;

acl_data_fifo rnode_163to164_bb2_var__u9_0_reg_164_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_163to164_bb2_var__u9_0_reg_164_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_163to164_bb2_var__u9_0_stall_in_reg_164_NO_SHIFT_REG),
	.valid_out(rnode_163to164_bb2_var__u9_0_valid_out_reg_164_NO_SHIFT_REG),
	.stall_out(rnode_163to164_bb2_var__u9_0_stall_out_reg_164_NO_SHIFT_REG),
	.data_in(local_bb2_var__u9),
	.data_out(rnode_163to164_bb2_var__u9_0_reg_164_NO_SHIFT_REG)
);

defparam rnode_163to164_bb2_var__u9_0_reg_164_fifo.DEPTH = 1;
defparam rnode_163to164_bb2_var__u9_0_reg_164_fifo.DATA_WIDTH = 1;
defparam rnode_163to164_bb2_var__u9_0_reg_164_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_163to164_bb2_var__u9_0_reg_164_fifo.IMPL = "shift_reg";

assign rnode_163to164_bb2_var__u9_0_reg_164_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_var__u9_stall_in = 1'b0;
assign rnode_163to164_bb2_var__u9_0_NO_SHIFT_REG = rnode_163to164_bb2_var__u9_0_reg_164_NO_SHIFT_REG;
assign rnode_163to164_bb2_var__u9_0_stall_in_reg_164_NO_SHIFT_REG = 1'b0;
assign rnode_163to164_bb2_var__u9_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_163to164_bb2__29_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_163to164_bb2__29_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_163to164_bb2__29_i_0_NO_SHIFT_REG;
 logic rnode_163to164_bb2__29_i_0_reg_164_inputs_ready_NO_SHIFT_REG;
 logic rnode_163to164_bb2__29_i_0_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2__29_i_0_valid_out_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2__29_i_0_stall_in_reg_164_NO_SHIFT_REG;
 logic rnode_163to164_bb2__29_i_0_stall_out_reg_164_NO_SHIFT_REG;

acl_data_fifo rnode_163to164_bb2__29_i_0_reg_164_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_163to164_bb2__29_i_0_reg_164_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_163to164_bb2__29_i_0_stall_in_reg_164_NO_SHIFT_REG),
	.valid_out(rnode_163to164_bb2__29_i_0_valid_out_reg_164_NO_SHIFT_REG),
	.stall_out(rnode_163to164_bb2__29_i_0_stall_out_reg_164_NO_SHIFT_REG),
	.data_in(local_bb2__29_i),
	.data_out(rnode_163to164_bb2__29_i_0_reg_164_NO_SHIFT_REG)
);

defparam rnode_163to164_bb2__29_i_0_reg_164_fifo.DEPTH = 1;
defparam rnode_163to164_bb2__29_i_0_reg_164_fifo.DATA_WIDTH = 1;
defparam rnode_163to164_bb2__29_i_0_reg_164_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_163to164_bb2__29_i_0_reg_164_fifo.IMPL = "shift_reg";

assign rnode_163to164_bb2__29_i_0_reg_164_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__29_i_stall_in = 1'b0;
assign rnode_163to164_bb2__29_i_0_NO_SHIFT_REG = rnode_163to164_bb2__29_i_0_reg_164_NO_SHIFT_REG;
assign rnode_163to164_bb2__29_i_0_stall_in_reg_164_NO_SHIFT_REG = 1'b0;
assign rnode_163to164_bb2__29_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_164to166_bb2_xor_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_164to166_bb2_xor_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_164to166_bb2_xor_i_0_NO_SHIFT_REG;
 logic rnode_164to166_bb2_xor_i_0_reg_166_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_164to166_bb2_xor_i_0_reg_166_NO_SHIFT_REG;
 logic rnode_164to166_bb2_xor_i_0_valid_out_reg_166_NO_SHIFT_REG;
 logic rnode_164to166_bb2_xor_i_0_stall_in_reg_166_NO_SHIFT_REG;
 logic rnode_164to166_bb2_xor_i_0_stall_out_reg_166_NO_SHIFT_REG;

acl_data_fifo rnode_164to166_bb2_xor_i_0_reg_166_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_164to166_bb2_xor_i_0_reg_166_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_164to166_bb2_xor_i_0_stall_in_reg_166_NO_SHIFT_REG),
	.valid_out(rnode_164to166_bb2_xor_i_0_valid_out_reg_166_NO_SHIFT_REG),
	.stall_out(rnode_164to166_bb2_xor_i_0_stall_out_reg_166_NO_SHIFT_REG),
	.data_in(rnode_163to164_bb2_xor_i_0_NO_SHIFT_REG),
	.data_out(rnode_164to166_bb2_xor_i_0_reg_166_NO_SHIFT_REG)
);

defparam rnode_164to166_bb2_xor_i_0_reg_166_fifo.DEPTH = 2;
defparam rnode_164to166_bb2_xor_i_0_reg_166_fifo.DATA_WIDTH = 32;
defparam rnode_164to166_bb2_xor_i_0_reg_166_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_164to166_bb2_xor_i_0_reg_166_fifo.IMPL = "shift_reg";

assign rnode_164to166_bb2_xor_i_0_reg_166_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_163to164_bb2_xor_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_164to166_bb2_xor_i_0_NO_SHIFT_REG = rnode_164to166_bb2_xor_i_0_reg_166_NO_SHIFT_REG;
assign rnode_164to166_bb2_xor_i_0_stall_in_reg_166_NO_SHIFT_REG = 1'b0;
assign rnode_164to166_bb2_xor_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_164to165_bb2_add_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_164to165_bb2_add_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_164to165_bb2_add_i_0_NO_SHIFT_REG;
 logic rnode_164to165_bb2_add_i_0_reg_165_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_164to165_bb2_add_i_0_reg_165_NO_SHIFT_REG;
 logic rnode_164to165_bb2_add_i_0_valid_out_reg_165_NO_SHIFT_REG;
 logic rnode_164to165_bb2_add_i_0_stall_in_reg_165_NO_SHIFT_REG;
 logic rnode_164to165_bb2_add_i_0_stall_out_reg_165_NO_SHIFT_REG;

acl_data_fifo rnode_164to165_bb2_add_i_0_reg_165_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_164to165_bb2_add_i_0_reg_165_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_164to165_bb2_add_i_0_stall_in_reg_165_NO_SHIFT_REG),
	.valid_out(rnode_164to165_bb2_add_i_0_valid_out_reg_165_NO_SHIFT_REG),
	.stall_out(rnode_164to165_bb2_add_i_0_stall_out_reg_165_NO_SHIFT_REG),
	.data_in(rnode_163to164_bb2_add_i_0_NO_SHIFT_REG),
	.data_out(rnode_164to165_bb2_add_i_0_reg_165_NO_SHIFT_REG)
);

defparam rnode_164to165_bb2_add_i_0_reg_165_fifo.DEPTH = 1;
defparam rnode_164to165_bb2_add_i_0_reg_165_fifo.DATA_WIDTH = 32;
defparam rnode_164to165_bb2_add_i_0_reg_165_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_164to165_bb2_add_i_0_reg_165_fifo.IMPL = "shift_reg";

assign rnode_164to165_bb2_add_i_0_reg_165_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_163to164_bb2_add_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_164to165_bb2_add_i_0_NO_SHIFT_REG = rnode_164to165_bb2_add_i_0_reg_165_NO_SHIFT_REG;
assign rnode_164to165_bb2_add_i_0_stall_in_reg_165_NO_SHIFT_REG = 1'b0;
assign rnode_164to165_bb2_add_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_conv3_i_i_stall_local;
wire [31:0] local_bb2_conv3_i_i;

assign local_bb2_conv3_i_i = local_bb2_mul_i_i[31:0];

// This section implements an unregistered operation.
// 
wire local_bb2_var__u11_stall_local;
wire [63:0] local_bb2_var__u11;

assign local_bb2_var__u11 = (local_bb2_mul_i_i >> 64'h18);

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_164to166_bb2_reduction_0_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_164to166_bb2_reduction_0_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_164to166_bb2_reduction_0_i_0_NO_SHIFT_REG;
 logic rnode_164to166_bb2_reduction_0_i_0_reg_166_inputs_ready_NO_SHIFT_REG;
 logic rnode_164to166_bb2_reduction_0_i_0_reg_166_NO_SHIFT_REG;
 logic rnode_164to166_bb2_reduction_0_i_0_valid_out_reg_166_NO_SHIFT_REG;
 logic rnode_164to166_bb2_reduction_0_i_0_stall_in_reg_166_NO_SHIFT_REG;
 logic rnode_164to166_bb2_reduction_0_i_0_stall_out_reg_166_NO_SHIFT_REG;

acl_data_fifo rnode_164to166_bb2_reduction_0_i_0_reg_166_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_164to166_bb2_reduction_0_i_0_reg_166_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_164to166_bb2_reduction_0_i_0_stall_in_reg_166_NO_SHIFT_REG),
	.valid_out(rnode_164to166_bb2_reduction_0_i_0_valid_out_reg_166_NO_SHIFT_REG),
	.stall_out(rnode_164to166_bb2_reduction_0_i_0_stall_out_reg_166_NO_SHIFT_REG),
	.data_in(rnode_163to164_bb2_reduction_0_i_0_NO_SHIFT_REG),
	.data_out(rnode_164to166_bb2_reduction_0_i_0_reg_166_NO_SHIFT_REG)
);

defparam rnode_164to166_bb2_reduction_0_i_0_reg_166_fifo.DEPTH = 2;
defparam rnode_164to166_bb2_reduction_0_i_0_reg_166_fifo.DATA_WIDTH = 1;
defparam rnode_164to166_bb2_reduction_0_i_0_reg_166_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_164to166_bb2_reduction_0_i_0_reg_166_fifo.IMPL = "shift_reg";

assign rnode_164to166_bb2_reduction_0_i_0_reg_166_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_163to164_bb2_reduction_0_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_164to166_bb2_reduction_0_i_0_NO_SHIFT_REG = rnode_164to166_bb2_reduction_0_i_0_reg_166_NO_SHIFT_REG;
assign rnode_164to166_bb2_reduction_0_i_0_stall_in_reg_166_NO_SHIFT_REG = 1'b0;
assign rnode_164to166_bb2_reduction_0_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_164to166_bb2_var__u9_0_valid_out_NO_SHIFT_REG;
 logic rnode_164to166_bb2_var__u9_0_stall_in_NO_SHIFT_REG;
 logic rnode_164to166_bb2_var__u9_0_NO_SHIFT_REG;
 logic rnode_164to166_bb2_var__u9_0_reg_166_inputs_ready_NO_SHIFT_REG;
 logic rnode_164to166_bb2_var__u9_0_reg_166_NO_SHIFT_REG;
 logic rnode_164to166_bb2_var__u9_0_valid_out_reg_166_NO_SHIFT_REG;
 logic rnode_164to166_bb2_var__u9_0_stall_in_reg_166_NO_SHIFT_REG;
 logic rnode_164to166_bb2_var__u9_0_stall_out_reg_166_NO_SHIFT_REG;

acl_data_fifo rnode_164to166_bb2_var__u9_0_reg_166_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_164to166_bb2_var__u9_0_reg_166_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_164to166_bb2_var__u9_0_stall_in_reg_166_NO_SHIFT_REG),
	.valid_out(rnode_164to166_bb2_var__u9_0_valid_out_reg_166_NO_SHIFT_REG),
	.stall_out(rnode_164to166_bb2_var__u9_0_stall_out_reg_166_NO_SHIFT_REG),
	.data_in(rnode_163to164_bb2_var__u9_0_NO_SHIFT_REG),
	.data_out(rnode_164to166_bb2_var__u9_0_reg_166_NO_SHIFT_REG)
);

defparam rnode_164to166_bb2_var__u9_0_reg_166_fifo.DEPTH = 2;
defparam rnode_164to166_bb2_var__u9_0_reg_166_fifo.DATA_WIDTH = 1;
defparam rnode_164to166_bb2_var__u9_0_reg_166_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_164to166_bb2_var__u9_0_reg_166_fifo.IMPL = "shift_reg";

assign rnode_164to166_bb2_var__u9_0_reg_166_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_163to164_bb2_var__u9_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_164to166_bb2_var__u9_0_NO_SHIFT_REG = rnode_164to166_bb2_var__u9_0_reg_166_NO_SHIFT_REG;
assign rnode_164to166_bb2_var__u9_0_stall_in_reg_166_NO_SHIFT_REG = 1'b0;
assign rnode_164to166_bb2_var__u9_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_164to166_bb2__29_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_164to166_bb2__29_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_164to166_bb2__29_i_0_NO_SHIFT_REG;
 logic rnode_164to166_bb2__29_i_0_reg_166_inputs_ready_NO_SHIFT_REG;
 logic rnode_164to166_bb2__29_i_0_reg_166_NO_SHIFT_REG;
 logic rnode_164to166_bb2__29_i_0_valid_out_reg_166_NO_SHIFT_REG;
 logic rnode_164to166_bb2__29_i_0_stall_in_reg_166_NO_SHIFT_REG;
 logic rnode_164to166_bb2__29_i_0_stall_out_reg_166_NO_SHIFT_REG;

acl_data_fifo rnode_164to166_bb2__29_i_0_reg_166_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_164to166_bb2__29_i_0_reg_166_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_164to166_bb2__29_i_0_stall_in_reg_166_NO_SHIFT_REG),
	.valid_out(rnode_164to166_bb2__29_i_0_valid_out_reg_166_NO_SHIFT_REG),
	.stall_out(rnode_164to166_bb2__29_i_0_stall_out_reg_166_NO_SHIFT_REG),
	.data_in(rnode_163to164_bb2__29_i_0_NO_SHIFT_REG),
	.data_out(rnode_164to166_bb2__29_i_0_reg_166_NO_SHIFT_REG)
);

defparam rnode_164to166_bb2__29_i_0_reg_166_fifo.DEPTH = 2;
defparam rnode_164to166_bb2__29_i_0_reg_166_fifo.DATA_WIDTH = 1;
defparam rnode_164to166_bb2__29_i_0_reg_166_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_164to166_bb2__29_i_0_reg_166_fifo.IMPL = "shift_reg";

assign rnode_164to166_bb2__29_i_0_reg_166_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_163to164_bb2__29_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_164to166_bb2__29_i_0_NO_SHIFT_REG = rnode_164to166_bb2__29_i_0_reg_166_NO_SHIFT_REG;
assign rnode_164to166_bb2__29_i_0_stall_in_reg_166_NO_SHIFT_REG = 1'b0;
assign rnode_164to166_bb2__29_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_166to167_bb2_xor_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_166to167_bb2_xor_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_166to167_bb2_xor_i_0_NO_SHIFT_REG;
 logic rnode_166to167_bb2_xor_i_0_reg_167_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_166to167_bb2_xor_i_0_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2_xor_i_0_valid_out_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2_xor_i_0_stall_in_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2_xor_i_0_stall_out_reg_167_NO_SHIFT_REG;

acl_data_fifo rnode_166to167_bb2_xor_i_0_reg_167_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_166to167_bb2_xor_i_0_reg_167_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_166to167_bb2_xor_i_0_stall_in_reg_167_NO_SHIFT_REG),
	.valid_out(rnode_166to167_bb2_xor_i_0_valid_out_reg_167_NO_SHIFT_REG),
	.stall_out(rnode_166to167_bb2_xor_i_0_stall_out_reg_167_NO_SHIFT_REG),
	.data_in(rnode_164to166_bb2_xor_i_0_NO_SHIFT_REG),
	.data_out(rnode_166to167_bb2_xor_i_0_reg_167_NO_SHIFT_REG)
);

defparam rnode_166to167_bb2_xor_i_0_reg_167_fifo.DEPTH = 1;
defparam rnode_166to167_bb2_xor_i_0_reg_167_fifo.DATA_WIDTH = 32;
defparam rnode_166to167_bb2_xor_i_0_reg_167_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_166to167_bb2_xor_i_0_reg_167_fifo.IMPL = "shift_reg";

assign rnode_166to167_bb2_xor_i_0_reg_167_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_164to166_bb2_xor_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2_xor_i_0_NO_SHIFT_REG = rnode_166to167_bb2_xor_i_0_reg_167_NO_SHIFT_REG;
assign rnode_166to167_bb2_xor_i_0_stall_in_reg_167_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2_xor_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_165to166_bb2_add_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_165to166_bb2_add_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_165to166_bb2_add_i_0_NO_SHIFT_REG;
 logic rnode_165to166_bb2_add_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_165to166_bb2_add_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_165to166_bb2_add_i_1_NO_SHIFT_REG;
 logic rnode_165to166_bb2_add_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_165to166_bb2_add_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_165to166_bb2_add_i_2_NO_SHIFT_REG;
 logic rnode_165to166_bb2_add_i_0_reg_166_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_165to166_bb2_add_i_0_reg_166_NO_SHIFT_REG;
 logic rnode_165to166_bb2_add_i_0_valid_out_0_reg_166_NO_SHIFT_REG;
 logic rnode_165to166_bb2_add_i_0_stall_in_0_reg_166_NO_SHIFT_REG;
 logic rnode_165to166_bb2_add_i_0_stall_out_reg_166_NO_SHIFT_REG;

acl_data_fifo rnode_165to166_bb2_add_i_0_reg_166_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_165to166_bb2_add_i_0_reg_166_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_165to166_bb2_add_i_0_stall_in_0_reg_166_NO_SHIFT_REG),
	.valid_out(rnode_165to166_bb2_add_i_0_valid_out_0_reg_166_NO_SHIFT_REG),
	.stall_out(rnode_165to166_bb2_add_i_0_stall_out_reg_166_NO_SHIFT_REG),
	.data_in(rnode_164to165_bb2_add_i_0_NO_SHIFT_REG),
	.data_out(rnode_165to166_bb2_add_i_0_reg_166_NO_SHIFT_REG)
);

defparam rnode_165to166_bb2_add_i_0_reg_166_fifo.DEPTH = 1;
defparam rnode_165to166_bb2_add_i_0_reg_166_fifo.DATA_WIDTH = 32;
defparam rnode_165to166_bb2_add_i_0_reg_166_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_165to166_bb2_add_i_0_reg_166_fifo.IMPL = "shift_reg";

assign rnode_165to166_bb2_add_i_0_reg_166_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_164to165_bb2_add_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_165to166_bb2_add_i_0_stall_in_0_reg_166_NO_SHIFT_REG = 1'b0;
assign rnode_165to166_bb2_add_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_165to166_bb2_add_i_0_NO_SHIFT_REG = rnode_165to166_bb2_add_i_0_reg_166_NO_SHIFT_REG;
assign rnode_165to166_bb2_add_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_165to166_bb2_add_i_1_NO_SHIFT_REG = rnode_165to166_bb2_add_i_0_reg_166_NO_SHIFT_REG;
assign rnode_165to166_bb2_add_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_165to166_bb2_add_i_2_NO_SHIFT_REG = rnode_165to166_bb2_add_i_0_reg_166_NO_SHIFT_REG;

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
wire local_bb2_var__u12_stall_local;
wire [31:0] local_bb2_var__u12;

assign local_bb2_var__u12 = (local_bb2_conv3_i_i >> 32'h17);

// This section implements an unregistered operation.
// 
wire local_bb2_shl1_i_i_stall_local;
wire [31:0] local_bb2_shl1_i_i;

assign local_bb2_shl1_i_i = (local_bb2_conv3_i_i << 32'h9);

// This section implements an unregistered operation.
// 
wire local_bb2__tr_i_stall_local;
wire [31:0] local_bb2__tr_i;

assign local_bb2__tr_i = local_bb2_var__u11[31:0];

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_166to167_bb2_reduction_0_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_166to167_bb2_reduction_0_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_166to167_bb2_reduction_0_i_0_NO_SHIFT_REG;
 logic rnode_166to167_bb2_reduction_0_i_0_reg_167_inputs_ready_NO_SHIFT_REG;
 logic rnode_166to167_bb2_reduction_0_i_0_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2_reduction_0_i_0_valid_out_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2_reduction_0_i_0_stall_in_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2_reduction_0_i_0_stall_out_reg_167_NO_SHIFT_REG;

acl_data_fifo rnode_166to167_bb2_reduction_0_i_0_reg_167_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_166to167_bb2_reduction_0_i_0_reg_167_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_166to167_bb2_reduction_0_i_0_stall_in_reg_167_NO_SHIFT_REG),
	.valid_out(rnode_166to167_bb2_reduction_0_i_0_valid_out_reg_167_NO_SHIFT_REG),
	.stall_out(rnode_166to167_bb2_reduction_0_i_0_stall_out_reg_167_NO_SHIFT_REG),
	.data_in(rnode_164to166_bb2_reduction_0_i_0_NO_SHIFT_REG),
	.data_out(rnode_166to167_bb2_reduction_0_i_0_reg_167_NO_SHIFT_REG)
);

defparam rnode_166to167_bb2_reduction_0_i_0_reg_167_fifo.DEPTH = 1;
defparam rnode_166to167_bb2_reduction_0_i_0_reg_167_fifo.DATA_WIDTH = 1;
defparam rnode_166to167_bb2_reduction_0_i_0_reg_167_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_166to167_bb2_reduction_0_i_0_reg_167_fifo.IMPL = "shift_reg";

assign rnode_166to167_bb2_reduction_0_i_0_reg_167_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_164to166_bb2_reduction_0_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2_reduction_0_i_0_NO_SHIFT_REG = rnode_166to167_bb2_reduction_0_i_0_reg_167_NO_SHIFT_REG;
assign rnode_166to167_bb2_reduction_0_i_0_stall_in_reg_167_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2_reduction_0_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_166to167_bb2_var__u9_0_valid_out_NO_SHIFT_REG;
 logic rnode_166to167_bb2_var__u9_0_stall_in_NO_SHIFT_REG;
 logic rnode_166to167_bb2_var__u9_0_NO_SHIFT_REG;
 logic rnode_166to167_bb2_var__u9_0_reg_167_inputs_ready_NO_SHIFT_REG;
 logic rnode_166to167_bb2_var__u9_0_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2_var__u9_0_valid_out_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2_var__u9_0_stall_in_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2_var__u9_0_stall_out_reg_167_NO_SHIFT_REG;

acl_data_fifo rnode_166to167_bb2_var__u9_0_reg_167_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_166to167_bb2_var__u9_0_reg_167_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_166to167_bb2_var__u9_0_stall_in_reg_167_NO_SHIFT_REG),
	.valid_out(rnode_166to167_bb2_var__u9_0_valid_out_reg_167_NO_SHIFT_REG),
	.stall_out(rnode_166to167_bb2_var__u9_0_stall_out_reg_167_NO_SHIFT_REG),
	.data_in(rnode_164to166_bb2_var__u9_0_NO_SHIFT_REG),
	.data_out(rnode_166to167_bb2_var__u9_0_reg_167_NO_SHIFT_REG)
);

defparam rnode_166to167_bb2_var__u9_0_reg_167_fifo.DEPTH = 1;
defparam rnode_166to167_bb2_var__u9_0_reg_167_fifo.DATA_WIDTH = 1;
defparam rnode_166to167_bb2_var__u9_0_reg_167_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_166to167_bb2_var__u9_0_reg_167_fifo.IMPL = "shift_reg";

assign rnode_166to167_bb2_var__u9_0_reg_167_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_164to166_bb2_var__u9_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2_var__u9_0_NO_SHIFT_REG = rnode_166to167_bb2_var__u9_0_reg_167_NO_SHIFT_REG;
assign rnode_166to167_bb2_var__u9_0_stall_in_reg_167_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2_var__u9_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_166to167_bb2__29_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_166to167_bb2__29_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_166to167_bb2__29_i_0_NO_SHIFT_REG;
 logic rnode_166to167_bb2__29_i_0_reg_167_inputs_ready_NO_SHIFT_REG;
 logic rnode_166to167_bb2__29_i_0_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2__29_i_0_valid_out_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2__29_i_0_stall_in_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2__29_i_0_stall_out_reg_167_NO_SHIFT_REG;

acl_data_fifo rnode_166to167_bb2__29_i_0_reg_167_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_166to167_bb2__29_i_0_reg_167_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_166to167_bb2__29_i_0_stall_in_reg_167_NO_SHIFT_REG),
	.valid_out(rnode_166to167_bb2__29_i_0_valid_out_reg_167_NO_SHIFT_REG),
	.stall_out(rnode_166to167_bb2__29_i_0_stall_out_reg_167_NO_SHIFT_REG),
	.data_in(rnode_164to166_bb2__29_i_0_NO_SHIFT_REG),
	.data_out(rnode_166to167_bb2__29_i_0_reg_167_NO_SHIFT_REG)
);

defparam rnode_166to167_bb2__29_i_0_reg_167_fifo.DEPTH = 1;
defparam rnode_166to167_bb2__29_i_0_reg_167_fifo.DATA_WIDTH = 1;
defparam rnode_166to167_bb2__29_i_0_reg_167_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_166to167_bb2__29_i_0_reg_167_fifo.IMPL = "shift_reg";

assign rnode_166to167_bb2__29_i_0_reg_167_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_164to166_bb2__29_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2__29_i_0_NO_SHIFT_REG = rnode_166to167_bb2__29_i_0_reg_167_NO_SHIFT_REG;
assign rnode_166to167_bb2__29_i_0_stall_in_reg_167_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2__29_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_and4_i_stall_local;
wire [31:0] local_bb2_and4_i;

assign local_bb2_and4_i = (rnode_166to167_bb2_xor_i_0_NO_SHIFT_REG & 32'h80000000);

// This section implements an unregistered operation.
// 
wire local_bb2_inc_i_stall_local;
wire [31:0] local_bb2_inc_i;

assign local_bb2_inc_i = (rnode_165to166_bb2_add_i_0_NO_SHIFT_REG + 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp50_not_i_stall_local;
wire local_bb2_cmp50_not_i;

assign local_bb2_cmp50_not_i = (rnode_165to166_bb2_add_i_1_NO_SHIFT_REG != 32'h7F);

// This section implements an unregistered operation.
// 
wire local_bb2_shr_i_i_stall_local;
wire [31:0] local_bb2_shr_i_i;

assign local_bb2_shr_i_i = (local_bb2_var__u12 & 32'h1);

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
wire local_bb2_or_i17_i_stall_local;
wire [31:0] local_bb2_or_i17_i;

assign local_bb2_or_i17_i = (local_bb2_shl_i15_i | local_bb2_shr_i16_i);

// This section implements an unregistered operation.
// 
wire local_bb2_tobool49_i_stall_local;
wire local_bb2_tobool49_i;

assign local_bb2_tobool49_i = (local_bb2_and48_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_shl_i_i_stall_local;
wire [31:0] local_bb2_shl_i_i;

assign local_bb2_shl_i_i = (local_bb2_or_i17_i << 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2__31_i_stall_local;
wire local_bb2__31_i;

assign local_bb2__31_i = (local_bb2_tobool49_i & local_bb2_cmp50_not_i);

// This section implements an unregistered operation.
// 
wire local_bb2_or_i_i_stall_local;
wire [31:0] local_bb2_or_i_i;

assign local_bb2_or_i_i = (local_bb2_shl_i_i | local_bb2_shr_i_i);

// This section implements an unregistered operation.
// 
wire local_bb2__32_i_stall_local;
wire [31:0] local_bb2__32_i;

assign local_bb2__32_i = (local_bb2__31_i ? local_bb2_shl1_i_i : local_bb2_shl1_i18_i);

// This section implements an unregistered operation.
// 
wire local_bb2__36_i_stall_local;
wire [31:0] local_bb2__36_i;

assign local_bb2__36_i = (local_bb2__31_i ? rnode_165to166_bb2_add_i_2_NO_SHIFT_REG : 32'h7F);

// This section implements an unregistered operation.
// 
wire local_bb2__34_i_stall_local;
wire [31:0] local_bb2__34_i;

assign local_bb2__34_i = (local_bb2__31_i ? local_bb2_or_i_i : local_bb2_or_i17_i);

// This section implements an unregistered operation.
// 
wire local_bb2__33_i_stall_local;
wire [31:0] local_bb2__33_i;

assign local_bb2__33_i = (local_bb2_tobool49_i ? local_bb2__32_i : local_bb2_shl1_i18_i);

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
wire local_bb2_cmp77_i_stall_local;
wire local_bb2_cmp77_i;

assign local_bb2_cmp77_i = (local_bb2__33_i > 32'h80000000);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u13_stall_local;
wire local_bb2_var__u13;

assign local_bb2_var__u13 = ($signed(local_bb2__33_i) < $signed(32'h0));

// This section implements an unregistered operation.
// 
wire local_bb2_and75_i_stall_local;
wire [31:0] local_bb2_and75_i;

assign local_bb2_and75_i = (local_bb2__35_i & 32'h7FFFFF);

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
wire local_bb2_cmp77_i_valid_out;
wire local_bb2_cmp77_i_stall_in;
 reg local_bb2_cmp77_i_consumed_0_NO_SHIFT_REG;
wire local_bb2__37_i_valid_out;
wire local_bb2__37_i_stall_in;
 reg local_bb2__37_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_and75_i_valid_out;
wire local_bb2_and75_i_stall_in;
 reg local_bb2_and75_i_consumed_0_NO_SHIFT_REG;
wire local_bb2__39_i_valid_out;
wire local_bb2__39_i_stall_in;
 reg local_bb2__39_i_consumed_0_NO_SHIFT_REG;
wire local_bb2__39_i_inputs_ready;
wire local_bb2__39_i_stall_local;
wire local_bb2__39_i;

assign local_bb2__39_i_inputs_ready = (local_bb2_mul_i_i_valid_out_0_NO_SHIFT_REG & local_bb2_mul_i_i_valid_out_1_NO_SHIFT_REG & rnode_165to166_bb2_add_i_0_valid_out_1_NO_SHIFT_REG & rnode_165to166_bb2_add_i_0_valid_out_0_NO_SHIFT_REG & rnode_165to166_bb2_add_i_0_valid_out_2_NO_SHIFT_REG);
assign local_bb2__39_i = (local_bb2_tobool84_i & local_bb2_var__u13);
assign local_bb2_cmp77_i_valid_out = 1'b1;
assign local_bb2__37_i_valid_out = 1'b1;
assign local_bb2_and75_i_valid_out = 1'b1;
assign local_bb2__39_i_valid_out = 1'b1;
assign local_bb2_mul_i_i_stall_in_0 = 1'b0;
assign local_bb2_mul_i_i_stall_in_1 = 1'b0;
assign rnode_165to166_bb2_add_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_165to166_bb2_add_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_165to166_bb2_add_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_cmp77_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2__37_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_and75_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2__39_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_cmp77_i_consumed_0_NO_SHIFT_REG <= (local_bb2__39_i_inputs_ready & (local_bb2_cmp77_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp77_i_stall_in)) & local_bb2__39_i_stall_local);
		local_bb2__37_i_consumed_0_NO_SHIFT_REG <= (local_bb2__39_i_inputs_ready & (local_bb2__37_i_consumed_0_NO_SHIFT_REG | ~(local_bb2__37_i_stall_in)) & local_bb2__39_i_stall_local);
		local_bb2_and75_i_consumed_0_NO_SHIFT_REG <= (local_bb2__39_i_inputs_ready & (local_bb2_and75_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_and75_i_stall_in)) & local_bb2__39_i_stall_local);
		local_bb2__39_i_consumed_0_NO_SHIFT_REG <= (local_bb2__39_i_inputs_ready & (local_bb2__39_i_consumed_0_NO_SHIFT_REG | ~(local_bb2__39_i_stall_in)) & local_bb2__39_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_166to167_bb2_cmp77_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_166to167_bb2_cmp77_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_166to167_bb2_cmp77_i_0_NO_SHIFT_REG;
 logic rnode_166to167_bb2_cmp77_i_0_reg_167_inputs_ready_NO_SHIFT_REG;
 logic rnode_166to167_bb2_cmp77_i_0_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2_cmp77_i_0_valid_out_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2_cmp77_i_0_stall_in_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2_cmp77_i_0_stall_out_reg_167_NO_SHIFT_REG;

acl_data_fifo rnode_166to167_bb2_cmp77_i_0_reg_167_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_166to167_bb2_cmp77_i_0_reg_167_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_166to167_bb2_cmp77_i_0_stall_in_reg_167_NO_SHIFT_REG),
	.valid_out(rnode_166to167_bb2_cmp77_i_0_valid_out_reg_167_NO_SHIFT_REG),
	.stall_out(rnode_166to167_bb2_cmp77_i_0_stall_out_reg_167_NO_SHIFT_REG),
	.data_in(local_bb2_cmp77_i),
	.data_out(rnode_166to167_bb2_cmp77_i_0_reg_167_NO_SHIFT_REG)
);

defparam rnode_166to167_bb2_cmp77_i_0_reg_167_fifo.DEPTH = 1;
defparam rnode_166to167_bb2_cmp77_i_0_reg_167_fifo.DATA_WIDTH = 1;
defparam rnode_166to167_bb2_cmp77_i_0_reg_167_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_166to167_bb2_cmp77_i_0_reg_167_fifo.IMPL = "shift_reg";

assign rnode_166to167_bb2_cmp77_i_0_reg_167_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp77_i_stall_in = 1'b0;
assign rnode_166to167_bb2_cmp77_i_0_NO_SHIFT_REG = rnode_166to167_bb2_cmp77_i_0_reg_167_NO_SHIFT_REG;
assign rnode_166to167_bb2_cmp77_i_0_stall_in_reg_167_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2_cmp77_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_166to167_bb2__37_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_166to167_bb2__37_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_166to167_bb2__37_i_0_NO_SHIFT_REG;
 logic rnode_166to167_bb2__37_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_166to167_bb2__37_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_166to167_bb2__37_i_1_NO_SHIFT_REG;
 logic rnode_166to167_bb2__37_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_166to167_bb2__37_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_166to167_bb2__37_i_2_NO_SHIFT_REG;
 logic rnode_166to167_bb2__37_i_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_166to167_bb2__37_i_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_166to167_bb2__37_i_3_NO_SHIFT_REG;
 logic rnode_166to167_bb2__37_i_0_reg_167_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_166to167_bb2__37_i_0_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2__37_i_0_valid_out_0_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2__37_i_0_stall_in_0_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2__37_i_0_stall_out_reg_167_NO_SHIFT_REG;

acl_data_fifo rnode_166to167_bb2__37_i_0_reg_167_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_166to167_bb2__37_i_0_reg_167_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_166to167_bb2__37_i_0_stall_in_0_reg_167_NO_SHIFT_REG),
	.valid_out(rnode_166to167_bb2__37_i_0_valid_out_0_reg_167_NO_SHIFT_REG),
	.stall_out(rnode_166to167_bb2__37_i_0_stall_out_reg_167_NO_SHIFT_REG),
	.data_in(local_bb2__37_i),
	.data_out(rnode_166to167_bb2__37_i_0_reg_167_NO_SHIFT_REG)
);

defparam rnode_166to167_bb2__37_i_0_reg_167_fifo.DEPTH = 1;
defparam rnode_166to167_bb2__37_i_0_reg_167_fifo.DATA_WIDTH = 32;
defparam rnode_166to167_bb2__37_i_0_reg_167_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_166to167_bb2__37_i_0_reg_167_fifo.IMPL = "shift_reg";

assign rnode_166to167_bb2__37_i_0_reg_167_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__37_i_stall_in = 1'b0;
assign rnode_166to167_bb2__37_i_0_stall_in_0_reg_167_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2__37_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_166to167_bb2__37_i_0_NO_SHIFT_REG = rnode_166to167_bb2__37_i_0_reg_167_NO_SHIFT_REG;
assign rnode_166to167_bb2__37_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_166to167_bb2__37_i_1_NO_SHIFT_REG = rnode_166to167_bb2__37_i_0_reg_167_NO_SHIFT_REG;
assign rnode_166to167_bb2__37_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_166to167_bb2__37_i_2_NO_SHIFT_REG = rnode_166to167_bb2__37_i_0_reg_167_NO_SHIFT_REG;
assign rnode_166to167_bb2__37_i_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_166to167_bb2__37_i_3_NO_SHIFT_REG = rnode_166to167_bb2__37_i_0_reg_167_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_166to167_bb2_and75_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_166to167_bb2_and75_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_166to167_bb2_and75_i_0_NO_SHIFT_REG;
 logic rnode_166to167_bb2_and75_i_0_reg_167_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_166to167_bb2_and75_i_0_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2_and75_i_0_valid_out_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2_and75_i_0_stall_in_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2_and75_i_0_stall_out_reg_167_NO_SHIFT_REG;

acl_data_fifo rnode_166to167_bb2_and75_i_0_reg_167_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_166to167_bb2_and75_i_0_reg_167_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_166to167_bb2_and75_i_0_stall_in_reg_167_NO_SHIFT_REG),
	.valid_out(rnode_166to167_bb2_and75_i_0_valid_out_reg_167_NO_SHIFT_REG),
	.stall_out(rnode_166to167_bb2_and75_i_0_stall_out_reg_167_NO_SHIFT_REG),
	.data_in(local_bb2_and75_i),
	.data_out(rnode_166to167_bb2_and75_i_0_reg_167_NO_SHIFT_REG)
);

defparam rnode_166to167_bb2_and75_i_0_reg_167_fifo.DEPTH = 1;
defparam rnode_166to167_bb2_and75_i_0_reg_167_fifo.DATA_WIDTH = 32;
defparam rnode_166to167_bb2_and75_i_0_reg_167_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_166to167_bb2_and75_i_0_reg_167_fifo.IMPL = "shift_reg";

assign rnode_166to167_bb2_and75_i_0_reg_167_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and75_i_stall_in = 1'b0;
assign rnode_166to167_bb2_and75_i_0_NO_SHIFT_REG = rnode_166to167_bb2_and75_i_0_reg_167_NO_SHIFT_REG;
assign rnode_166to167_bb2_and75_i_0_stall_in_reg_167_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2_and75_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_166to167_bb2__39_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_166to167_bb2__39_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_166to167_bb2__39_i_0_NO_SHIFT_REG;
 logic rnode_166to167_bb2__39_i_0_reg_167_inputs_ready_NO_SHIFT_REG;
 logic rnode_166to167_bb2__39_i_0_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2__39_i_0_valid_out_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2__39_i_0_stall_in_reg_167_NO_SHIFT_REG;
 logic rnode_166to167_bb2__39_i_0_stall_out_reg_167_NO_SHIFT_REG;

acl_data_fifo rnode_166to167_bb2__39_i_0_reg_167_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_166to167_bb2__39_i_0_reg_167_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_166to167_bb2__39_i_0_stall_in_reg_167_NO_SHIFT_REG),
	.valid_out(rnode_166to167_bb2__39_i_0_valid_out_reg_167_NO_SHIFT_REG),
	.stall_out(rnode_166to167_bb2__39_i_0_stall_out_reg_167_NO_SHIFT_REG),
	.data_in(local_bb2__39_i),
	.data_out(rnode_166to167_bb2__39_i_0_reg_167_NO_SHIFT_REG)
);

defparam rnode_166to167_bb2__39_i_0_reg_167_fifo.DEPTH = 1;
defparam rnode_166to167_bb2__39_i_0_reg_167_fifo.DATA_WIDTH = 1;
defparam rnode_166to167_bb2__39_i_0_reg_167_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_166to167_bb2__39_i_0_reg_167_fifo.IMPL = "shift_reg";

assign rnode_166to167_bb2__39_i_0_reg_167_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__39_i_stall_in = 1'b0;
assign rnode_166to167_bb2__39_i_0_NO_SHIFT_REG = rnode_166to167_bb2__39_i_0_reg_167_NO_SHIFT_REG;
assign rnode_166to167_bb2__39_i_0_stall_in_reg_167_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2__39_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_cmp53_i_stall_local;
wire local_bb2_cmp53_i;

assign local_bb2_cmp53_i = (rnode_166to167_bb2__37_i_0_NO_SHIFT_REG > 32'h17D);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp68_i_stall_local;
wire local_bb2_cmp68_i;

assign local_bb2_cmp68_i = (rnode_166to167_bb2__37_i_1_NO_SHIFT_REG < 32'h80);

// This section implements an unregistered operation.
// 
wire local_bb2_sub_i_stall_local;
wire [31:0] local_bb2_sub_i;

assign local_bb2_sub_i = (rnode_166to167_bb2__37_i_2_NO_SHIFT_REG << 32'h17);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp71_not_i_stall_local;
wire local_bb2_cmp71_not_i;

assign local_bb2_cmp71_not_i = (rnode_166to167_bb2__37_i_3_NO_SHIFT_REG != 32'h7F);

// This section implements an unregistered operation.
// 
wire local_bb2__40_i_stall_local;
wire local_bb2__40_i;

assign local_bb2__40_i = (rnode_166to167_bb2_cmp77_i_0_NO_SHIFT_REG | rnode_166to167_bb2__39_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_or581_i_stall_local;
wire local_bb2_or581_i;

assign local_bb2_or581_i = (rnode_166to167_bb2_var__u9_0_NO_SHIFT_REG | local_bb2_cmp53_i);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u14_stall_local;
wire [31:0] local_bb2_var__u14;

assign local_bb2_var__u14[31:1] = 31'h0;
assign local_bb2_var__u14[0] = local_bb2_cmp68_i;

// This section implements an unregistered operation.
// 
wire local_bb2_and74_i_stall_local;
wire [31:0] local_bb2_and74_i;

assign local_bb2_and74_i = (local_bb2_sub_i + 32'h40800000);

// This section implements an unregistered operation.
// 
wire local_bb2_cond_i_stall_local;
wire [31:0] local_bb2_cond_i;

assign local_bb2_cond_i[31:1] = 31'h0;
assign local_bb2_cond_i[0] = local_bb2__40_i;

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_2_i_stall_local;
wire local_bb2_reduction_2_i;

assign local_bb2_reduction_2_i = (rnode_166to167_bb2_reduction_0_i_0_NO_SHIFT_REG | local_bb2_or581_i);

// This section implements an unregistered operation.
// 
wire local_bb2_cond111_i_stall_local;
wire [31:0] local_bb2_cond111_i;

assign local_bb2_cond111_i = (local_bb2_or581_i ? 32'h7F800000 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_shl_i_stall_local;
wire [31:0] local_bb2_shl_i;

assign local_bb2_shl_i = (local_bb2_and74_i & 32'h7F800000);

// This section implements an unregistered operation.
// 
wire local_bb2_conv101_i_stall_local;
wire [31:0] local_bb2_conv101_i;

assign local_bb2_conv101_i[31:1] = 31'h0;
assign local_bb2_conv101_i[0] = local_bb2_reduction_2_i;

// This section implements an unregistered operation.
// 
wire local_bb2_or76_i_stall_local;
wire [31:0] local_bb2_or76_i;

assign local_bb2_or76_i = (local_bb2_shl_i | rnode_166to167_bb2_and75_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_add87_i_stall_local;
wire [31:0] local_bb2_add87_i;

assign local_bb2_add87_i = (local_bb2_cond_i + local_bb2_or76_i);

// This section implements an unregistered operation.
// 
wire local_bb2_and88_i_stall_local;
wire [31:0] local_bb2_and88_i;

assign local_bb2_and88_i = (local_bb2_add87_i & 32'h7FFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and90_i_stall_local;
wire [31:0] local_bb2_and90_i;

assign local_bb2_and90_i = (local_bb2_add87_i & 32'h800000);

// This section implements an unregistered operation.
// 
wire local_bb2_or89_i_stall_local;
wire [31:0] local_bb2_or89_i;

assign local_bb2_or89_i = (local_bb2_and88_i | local_bb2_and4_i);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp91_i_stall_local;
wire local_bb2_cmp91_i;

assign local_bb2_cmp91_i = (local_bb2_and90_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge14_i_stall_local;
wire local_bb2_brmerge14_i;

assign local_bb2_brmerge14_i = (local_bb2_cmp91_i | local_bb2_cmp71_not_i);

// This section implements an unregistered operation.
// 
wire local_bb2_conv99_i_stall_local;
wire [31:0] local_bb2_conv99_i;

assign local_bb2_conv99_i = (local_bb2_brmerge14_i ? local_bb2_var__u14 : 32'h0);

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

assign local_bb2_cond107_i = (local_bb2_tobool103_i ? local_bb2_and4_i : 32'hFFFFFFFF);

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
wire local_bb2_var__u15_valid_out;
wire local_bb2_var__u15_stall_in;
wire local_bb2_var__u15_inputs_ready;
wire local_bb2_var__u15_stall_local;
wire [31:0] local_bb2_var__u15;

assign local_bb2_var__u15_inputs_ready = (rnode_166to167_bb2_xor_i_0_valid_out_NO_SHIFT_REG & rnode_166to167_bb2__29_i_0_valid_out_NO_SHIFT_REG & rnode_166to167_bb2_reduction_0_i_0_valid_out_NO_SHIFT_REG & rnode_166to167_bb2_var__u9_0_valid_out_NO_SHIFT_REG & rnode_166to167_bb2__37_i_0_valid_out_0_NO_SHIFT_REG & rnode_166to167_bb2__37_i_0_valid_out_1_NO_SHIFT_REG & rnode_166to167_bb2__37_i_0_valid_out_3_NO_SHIFT_REG & rnode_166to167_bb2__37_i_0_valid_out_2_NO_SHIFT_REG & rnode_166to167_bb2_cmp77_i_0_valid_out_NO_SHIFT_REG & rnode_166to167_bb2__39_i_0_valid_out_NO_SHIFT_REG & rnode_166to167_bb2_and75_i_0_valid_out_NO_SHIFT_REG);
assign local_bb2_var__u15 = (rnode_166to167_bb2__29_i_0_NO_SHIFT_REG ? 32'h7FC00000 : local_bb2_or112_i);
assign local_bb2_var__u15_valid_out = 1'b1;
assign rnode_166to167_bb2_xor_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2__29_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2_reduction_0_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2_var__u9_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2__37_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2__37_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2__37_i_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2__37_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2_cmp77_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2__39_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_166to167_bb2_and75_i_0_stall_in_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_167to168_bb2_var__u15_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_167to168_bb2_var__u15_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_167to168_bb2_var__u15_0_NO_SHIFT_REG;
 logic rnode_167to168_bb2_var__u15_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_167to168_bb2_var__u15_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_167to168_bb2_var__u15_1_NO_SHIFT_REG;
 logic rnode_167to168_bb2_var__u15_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_167to168_bb2_var__u15_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_167to168_bb2_var__u15_2_NO_SHIFT_REG;
 logic rnode_167to168_bb2_var__u15_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_167to168_bb2_var__u15_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_167to168_bb2_var__u15_3_NO_SHIFT_REG;
 logic rnode_167to168_bb2_var__u15_0_reg_168_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_167to168_bb2_var__u15_0_reg_168_NO_SHIFT_REG;
 logic rnode_167to168_bb2_var__u15_0_valid_out_0_reg_168_NO_SHIFT_REG;
 logic rnode_167to168_bb2_var__u15_0_stall_in_0_reg_168_NO_SHIFT_REG;
 logic rnode_167to168_bb2_var__u15_0_stall_out_reg_168_NO_SHIFT_REG;

acl_data_fifo rnode_167to168_bb2_var__u15_0_reg_168_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_167to168_bb2_var__u15_0_reg_168_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_167to168_bb2_var__u15_0_stall_in_0_reg_168_NO_SHIFT_REG),
	.valid_out(rnode_167to168_bb2_var__u15_0_valid_out_0_reg_168_NO_SHIFT_REG),
	.stall_out(rnode_167to168_bb2_var__u15_0_stall_out_reg_168_NO_SHIFT_REG),
	.data_in(local_bb2_var__u15),
	.data_out(rnode_167to168_bb2_var__u15_0_reg_168_NO_SHIFT_REG)
);

defparam rnode_167to168_bb2_var__u15_0_reg_168_fifo.DEPTH = 1;
defparam rnode_167to168_bb2_var__u15_0_reg_168_fifo.DATA_WIDTH = 32;
defparam rnode_167to168_bb2_var__u15_0_reg_168_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_167to168_bb2_var__u15_0_reg_168_fifo.IMPL = "shift_reg";

assign rnode_167to168_bb2_var__u15_0_reg_168_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_var__u15_stall_in = 1'b0;
assign rnode_167to168_bb2_var__u15_0_stall_in_0_reg_168_NO_SHIFT_REG = 1'b0;
assign rnode_167to168_bb2_var__u15_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_167to168_bb2_var__u15_0_NO_SHIFT_REG = rnode_167to168_bb2_var__u15_0_reg_168_NO_SHIFT_REG;
assign rnode_167to168_bb2_var__u15_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_167to168_bb2_var__u15_1_NO_SHIFT_REG = rnode_167to168_bb2_var__u15_0_reg_168_NO_SHIFT_REG;
assign rnode_167to168_bb2_var__u15_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_167to168_bb2_var__u15_2_NO_SHIFT_REG = rnode_167to168_bb2_var__u15_0_reg_168_NO_SHIFT_REG;
assign rnode_167to168_bb2_var__u15_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_167to168_bb2_var__u15_3_NO_SHIFT_REG = rnode_167to168_bb2_var__u15_0_reg_168_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_and_i42_stall_local;
wire [31:0] local_bb2_and_i42;

assign local_bb2_and_i42 = (rnode_167to168_bb2_var__u15_0_NO_SHIFT_REG >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb2_and10_i48_stall_local;
wire [31:0] local_bb2_and10_i48;

assign local_bb2_and10_i48 = (rnode_167to168_bb2_var__u15_1_NO_SHIFT_REG & 32'hFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_shr_i43_stall_local;
wire [31:0] local_bb2_shr_i43;

assign local_bb2_shr_i43 = (local_bb2_and_i42 & 32'h7FFF);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp13_i50_stall_local;
wire local_bb2_cmp13_i50;

assign local_bb2_cmp13_i50 = (local_bb2_and10_i48 > local_bb2_and12_i49);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp_i46_stall_local;
wire local_bb2_cmp_i46;

assign local_bb2_cmp_i46 = (local_bb2_shr_i43 > local_bb2_shr3_i45);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp8_i47_stall_local;
wire local_bb2_cmp8_i47;

assign local_bb2_cmp8_i47 = (local_bb2_shr_i43 == local_bb2_shr3_i45);

// This section implements an unregistered operation.
// 
wire local_bb2___i51_stall_local;
wire local_bb2___i51;

assign local_bb2___i51 = (local_bb2_cmp8_i47 & local_bb2_cmp13_i50);

// This section implements an unregistered operation.
// 
wire local_bb2__21_i52_stall_local;
wire local_bb2__21_i52;

assign local_bb2__21_i52 = (local_bb2_cmp_i46 | local_bb2___i51);

// This section implements an unregistered operation.
// 
wire local_bb2__22_i53_stall_local;
wire [31:0] local_bb2__22_i53;

assign local_bb2__22_i53 = (local_bb2__21_i52 ? local_bb2_var__u7 : rnode_167to168_bb2_var__u15_2_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2__22_i53_valid_out;
wire local_bb2__22_i53_stall_in;
 reg local_bb2__22_i53_consumed_0_NO_SHIFT_REG;
wire local_bb2__23_i54_valid_out;
wire local_bb2__23_i54_stall_in;
 reg local_bb2__23_i54_consumed_0_NO_SHIFT_REG;
wire local_bb2__23_i54_inputs_ready;
wire local_bb2__23_i54_stall_local;
wire [31:0] local_bb2__23_i54;

assign local_bb2__23_i54_inputs_ready = (rnode_167to168_bb2_c0_ene3_0_valid_out_NO_SHIFT_REG & rnode_167to168_bb2_var__u15_0_valid_out_2_NO_SHIFT_REG & rnode_167to168_bb2_var__u15_0_valid_out_3_NO_SHIFT_REG & rnode_167to168_bb2_var__u15_0_valid_out_1_NO_SHIFT_REG & rnode_167to168_bb2_var__u15_0_valid_out_0_NO_SHIFT_REG);
assign local_bb2__23_i54 = (local_bb2__21_i52 ? rnode_167to168_bb2_var__u15_3_NO_SHIFT_REG : local_bb2_var__u7);
assign local_bb2__22_i53_valid_out = 1'b1;
assign local_bb2__23_i54_valid_out = 1'b1;
assign rnode_167to168_bb2_c0_ene3_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_167to168_bb2_var__u15_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_167to168_bb2_var__u15_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_167to168_bb2_var__u15_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_167to168_bb2_var__u15_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2__22_i53_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2__23_i54_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2__22_i53_consumed_0_NO_SHIFT_REG <= (local_bb2__23_i54_inputs_ready & (local_bb2__22_i53_consumed_0_NO_SHIFT_REG | ~(local_bb2__22_i53_stall_in)) & local_bb2__23_i54_stall_local);
		local_bb2__23_i54_consumed_0_NO_SHIFT_REG <= (local_bb2__23_i54_inputs_ready & (local_bb2__23_i54_consumed_0_NO_SHIFT_REG | ~(local_bb2__23_i54_stall_in)) & local_bb2__23_i54_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_168to169_bb2__22_i53_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_168to169_bb2__22_i53_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_168to169_bb2__22_i53_0_NO_SHIFT_REG;
 logic rnode_168to169_bb2__22_i53_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_168to169_bb2__22_i53_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_168to169_bb2__22_i53_1_NO_SHIFT_REG;
 logic rnode_168to169_bb2__22_i53_0_reg_169_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_168to169_bb2__22_i53_0_reg_169_NO_SHIFT_REG;
 logic rnode_168to169_bb2__22_i53_0_valid_out_0_reg_169_NO_SHIFT_REG;
 logic rnode_168to169_bb2__22_i53_0_stall_in_0_reg_169_NO_SHIFT_REG;
 logic rnode_168to169_bb2__22_i53_0_stall_out_reg_169_NO_SHIFT_REG;

acl_data_fifo rnode_168to169_bb2__22_i53_0_reg_169_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_168to169_bb2__22_i53_0_reg_169_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_168to169_bb2__22_i53_0_stall_in_0_reg_169_NO_SHIFT_REG),
	.valid_out(rnode_168to169_bb2__22_i53_0_valid_out_0_reg_169_NO_SHIFT_REG),
	.stall_out(rnode_168to169_bb2__22_i53_0_stall_out_reg_169_NO_SHIFT_REG),
	.data_in(local_bb2__22_i53),
	.data_out(rnode_168to169_bb2__22_i53_0_reg_169_NO_SHIFT_REG)
);

defparam rnode_168to169_bb2__22_i53_0_reg_169_fifo.DEPTH = 1;
defparam rnode_168to169_bb2__22_i53_0_reg_169_fifo.DATA_WIDTH = 32;
defparam rnode_168to169_bb2__22_i53_0_reg_169_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_168to169_bb2__22_i53_0_reg_169_fifo.IMPL = "shift_reg";

assign rnode_168to169_bb2__22_i53_0_reg_169_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__22_i53_stall_in = 1'b0;
assign rnode_168to169_bb2__22_i53_0_stall_in_0_reg_169_NO_SHIFT_REG = 1'b0;
assign rnode_168to169_bb2__22_i53_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_168to169_bb2__22_i53_0_NO_SHIFT_REG = rnode_168to169_bb2__22_i53_0_reg_169_NO_SHIFT_REG;
assign rnode_168to169_bb2__22_i53_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_168to169_bb2__22_i53_1_NO_SHIFT_REG = rnode_168to169_bb2__22_i53_0_reg_169_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_168to169_bb2__23_i54_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_168to169_bb2__23_i54_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_168to169_bb2__23_i54_0_NO_SHIFT_REG;
 logic rnode_168to169_bb2__23_i54_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_168to169_bb2__23_i54_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_168to169_bb2__23_i54_1_NO_SHIFT_REG;
 logic rnode_168to169_bb2__23_i54_0_reg_169_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_168to169_bb2__23_i54_0_reg_169_NO_SHIFT_REG;
 logic rnode_168to169_bb2__23_i54_0_valid_out_0_reg_169_NO_SHIFT_REG;
 logic rnode_168to169_bb2__23_i54_0_stall_in_0_reg_169_NO_SHIFT_REG;
 logic rnode_168to169_bb2__23_i54_0_stall_out_reg_169_NO_SHIFT_REG;

acl_data_fifo rnode_168to169_bb2__23_i54_0_reg_169_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_168to169_bb2__23_i54_0_reg_169_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_168to169_bb2__23_i54_0_stall_in_0_reg_169_NO_SHIFT_REG),
	.valid_out(rnode_168to169_bb2__23_i54_0_valid_out_0_reg_169_NO_SHIFT_REG),
	.stall_out(rnode_168to169_bb2__23_i54_0_stall_out_reg_169_NO_SHIFT_REG),
	.data_in(local_bb2__23_i54),
	.data_out(rnode_168to169_bb2__23_i54_0_reg_169_NO_SHIFT_REG)
);

defparam rnode_168to169_bb2__23_i54_0_reg_169_fifo.DEPTH = 1;
defparam rnode_168to169_bb2__23_i54_0_reg_169_fifo.DATA_WIDTH = 32;
defparam rnode_168to169_bb2__23_i54_0_reg_169_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_168to169_bb2__23_i54_0_reg_169_fifo.IMPL = "shift_reg";

assign rnode_168to169_bb2__23_i54_0_reg_169_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__23_i54_stall_in = 1'b0;
assign rnode_168to169_bb2__23_i54_0_stall_in_0_reg_169_NO_SHIFT_REG = 1'b0;
assign rnode_168to169_bb2__23_i54_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_168to169_bb2__23_i54_0_NO_SHIFT_REG = rnode_168to169_bb2__23_i54_0_reg_169_NO_SHIFT_REG;
assign rnode_168to169_bb2__23_i54_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_168to169_bb2__23_i54_1_NO_SHIFT_REG = rnode_168to169_bb2__23_i54_0_reg_169_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_shr18_i57_stall_local;
wire [31:0] local_bb2_shr18_i57;

assign local_bb2_shr18_i57 = (rnode_168to169_bb2__22_i53_0_NO_SHIFT_REG >> 32'h17);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_169to170_bb2__22_i53_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_169to170_bb2__22_i53_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_169to170_bb2__22_i53_0_NO_SHIFT_REG;
 logic rnode_169to170_bb2__22_i53_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_169to170_bb2__22_i53_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_169to170_bb2__22_i53_1_NO_SHIFT_REG;
 logic rnode_169to170_bb2__22_i53_0_reg_170_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_169to170_bb2__22_i53_0_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2__22_i53_0_valid_out_0_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2__22_i53_0_stall_in_0_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2__22_i53_0_stall_out_reg_170_NO_SHIFT_REG;

acl_data_fifo rnode_169to170_bb2__22_i53_0_reg_170_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_169to170_bb2__22_i53_0_reg_170_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_169to170_bb2__22_i53_0_stall_in_0_reg_170_NO_SHIFT_REG),
	.valid_out(rnode_169to170_bb2__22_i53_0_valid_out_0_reg_170_NO_SHIFT_REG),
	.stall_out(rnode_169to170_bb2__22_i53_0_stall_out_reg_170_NO_SHIFT_REG),
	.data_in(rnode_168to169_bb2__22_i53_1_NO_SHIFT_REG),
	.data_out(rnode_169to170_bb2__22_i53_0_reg_170_NO_SHIFT_REG)
);

defparam rnode_169to170_bb2__22_i53_0_reg_170_fifo.DEPTH = 1;
defparam rnode_169to170_bb2__22_i53_0_reg_170_fifo.DATA_WIDTH = 32;
defparam rnode_169to170_bb2__22_i53_0_reg_170_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_169to170_bb2__22_i53_0_reg_170_fifo.IMPL = "shift_reg";

assign rnode_169to170_bb2__22_i53_0_reg_170_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_168to169_bb2__22_i53_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2__22_i53_0_stall_in_0_reg_170_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2__22_i53_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_169to170_bb2__22_i53_0_NO_SHIFT_REG = rnode_169to170_bb2__22_i53_0_reg_170_NO_SHIFT_REG;
assign rnode_169to170_bb2__22_i53_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_169to170_bb2__22_i53_1_NO_SHIFT_REG = rnode_169to170_bb2__22_i53_0_reg_170_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_shr16_i55_stall_local;
wire [31:0] local_bb2_shr16_i55;

assign local_bb2_shr16_i55 = (rnode_168to169_bb2__23_i54_0_NO_SHIFT_REG >> 32'h17);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_169to170_bb2__23_i54_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_169to170_bb2__23_i54_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_169to170_bb2__23_i54_0_NO_SHIFT_REG;
 logic rnode_169to170_bb2__23_i54_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_169to170_bb2__23_i54_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_169to170_bb2__23_i54_1_NO_SHIFT_REG;
 logic rnode_169to170_bb2__23_i54_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_169to170_bb2__23_i54_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_169to170_bb2__23_i54_2_NO_SHIFT_REG;
 logic rnode_169to170_bb2__23_i54_0_reg_170_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_169to170_bb2__23_i54_0_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2__23_i54_0_valid_out_0_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2__23_i54_0_stall_in_0_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2__23_i54_0_stall_out_reg_170_NO_SHIFT_REG;

acl_data_fifo rnode_169to170_bb2__23_i54_0_reg_170_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_169to170_bb2__23_i54_0_reg_170_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_169to170_bb2__23_i54_0_stall_in_0_reg_170_NO_SHIFT_REG),
	.valid_out(rnode_169to170_bb2__23_i54_0_valid_out_0_reg_170_NO_SHIFT_REG),
	.stall_out(rnode_169to170_bb2__23_i54_0_stall_out_reg_170_NO_SHIFT_REG),
	.data_in(rnode_168to169_bb2__23_i54_1_NO_SHIFT_REG),
	.data_out(rnode_169to170_bb2__23_i54_0_reg_170_NO_SHIFT_REG)
);

defparam rnode_169to170_bb2__23_i54_0_reg_170_fifo.DEPTH = 1;
defparam rnode_169to170_bb2__23_i54_0_reg_170_fifo.DATA_WIDTH = 32;
defparam rnode_169to170_bb2__23_i54_0_reg_170_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_169to170_bb2__23_i54_0_reg_170_fifo.IMPL = "shift_reg";

assign rnode_169to170_bb2__23_i54_0_reg_170_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_168to169_bb2__23_i54_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2__23_i54_0_stall_in_0_reg_170_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2__23_i54_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_169to170_bb2__23_i54_0_NO_SHIFT_REG = rnode_169to170_bb2__23_i54_0_reg_170_NO_SHIFT_REG;
assign rnode_169to170_bb2__23_i54_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_169to170_bb2__23_i54_1_NO_SHIFT_REG = rnode_169to170_bb2__23_i54_0_reg_170_NO_SHIFT_REG;
assign rnode_169to170_bb2__23_i54_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_169to170_bb2__23_i54_2_NO_SHIFT_REG = rnode_169to170_bb2__23_i54_0_reg_170_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_and19_i58_stall_local;
wire [31:0] local_bb2_and19_i58;

assign local_bb2_and19_i58 = (local_bb2_shr18_i57 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and21_i60_stall_local;
wire [31:0] local_bb2_and21_i60;

assign local_bb2_and21_i60 = (rnode_169to170_bb2__22_i53_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_sub_i84_stall_local;
wire [31:0] local_bb2_sub_i84;

assign local_bb2_sub_i84 = (local_bb2_shr16_i55 - local_bb2_shr18_i57);

// This section implements an unregistered operation.
// 
wire local_bb2_and20_i59_stall_local;
wire [31:0] local_bb2_and20_i59;

assign local_bb2_and20_i59 = (rnode_169to170_bb2__23_i54_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and35_i65_valid_out;
wire local_bb2_and35_i65_stall_in;
wire local_bb2_and35_i65_inputs_ready;
wire local_bb2_and35_i65_stall_local;
wire [31:0] local_bb2_and35_i65;

assign local_bb2_and35_i65_inputs_ready = rnode_169to170_bb2__23_i54_0_valid_out_1_NO_SHIFT_REG;
assign local_bb2_and35_i65 = (rnode_169to170_bb2__23_i54_1_NO_SHIFT_REG & 32'h80000000);
assign local_bb2_and35_i65_valid_out = 1'b1;
assign rnode_169to170_bb2__23_i54_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_xor_i66_stall_local;
wire [31:0] local_bb2_xor_i66;

assign local_bb2_xor_i66 = (rnode_169to170_bb2__23_i54_2_NO_SHIFT_REG ^ rnode_169to170_bb2__22_i53_1_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot23_i62_stall_local;
wire local_bb2_lnot23_i62;

assign local_bb2_lnot23_i62 = (local_bb2_and19_i58 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp27_i64_stall_local;
wire local_bb2_cmp27_i64;

assign local_bb2_cmp27_i64 = (local_bb2_and19_i58 == 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot33_not_i70_stall_local;
wire local_bb2_lnot33_not_i70;

assign local_bb2_lnot33_not_i70 = (local_bb2_and21_i60 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or64_i_stall_local;
wire [31:0] local_bb2_or64_i;

assign local_bb2_or64_i = (local_bb2_and21_i60 << 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb2_and68_i_stall_local;
wire [31:0] local_bb2_and68_i;

assign local_bb2_and68_i = (local_bb2_sub_i84 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot30_i68_stall_local;
wire local_bb2_lnot30_i68;

assign local_bb2_lnot30_i68 = (local_bb2_and20_i59 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or_i80_stall_local;
wire [31:0] local_bb2_or_i80;

assign local_bb2_or_i80 = (local_bb2_and20_i59 << 32'h3);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_170to171_bb2_and35_i65_0_valid_out_NO_SHIFT_REG;
 logic rnode_170to171_bb2_and35_i65_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_170to171_bb2_and35_i65_0_NO_SHIFT_REG;
 logic rnode_170to171_bb2_and35_i65_0_reg_171_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_170to171_bb2_and35_i65_0_reg_171_NO_SHIFT_REG;
 logic rnode_170to171_bb2_and35_i65_0_valid_out_reg_171_NO_SHIFT_REG;
 logic rnode_170to171_bb2_and35_i65_0_stall_in_reg_171_NO_SHIFT_REG;
 logic rnode_170to171_bb2_and35_i65_0_stall_out_reg_171_NO_SHIFT_REG;

acl_data_fifo rnode_170to171_bb2_and35_i65_0_reg_171_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_170to171_bb2_and35_i65_0_reg_171_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_170to171_bb2_and35_i65_0_stall_in_reg_171_NO_SHIFT_REG),
	.valid_out(rnode_170to171_bb2_and35_i65_0_valid_out_reg_171_NO_SHIFT_REG),
	.stall_out(rnode_170to171_bb2_and35_i65_0_stall_out_reg_171_NO_SHIFT_REG),
	.data_in(local_bb2_and35_i65),
	.data_out(rnode_170to171_bb2_and35_i65_0_reg_171_NO_SHIFT_REG)
);

defparam rnode_170to171_bb2_and35_i65_0_reg_171_fifo.DEPTH = 1;
defparam rnode_170to171_bb2_and35_i65_0_reg_171_fifo.DATA_WIDTH = 32;
defparam rnode_170to171_bb2_and35_i65_0_reg_171_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_170to171_bb2_and35_i65_0_reg_171_fifo.IMPL = "shift_reg";

assign rnode_170to171_bb2_and35_i65_0_reg_171_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and35_i65_stall_in = 1'b0;
assign rnode_170to171_bb2_and35_i65_0_NO_SHIFT_REG = rnode_170to171_bb2_and35_i65_0_reg_171_NO_SHIFT_REG;
assign rnode_170to171_bb2_and35_i65_0_stall_in_reg_171_NO_SHIFT_REG = 1'b0;
assign rnode_170to171_bb2_and35_i65_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_cmp37_i_stall_local;
wire local_bb2_cmp37_i;

assign local_bb2_cmp37_i = ($signed(local_bb2_xor_i66) < $signed(32'h0));

// This section implements an unregistered operation.
// 
wire local_bb2_xor_lobit_i_stall_local;
wire [31:0] local_bb2_xor_lobit_i;

assign local_bb2_xor_lobit_i = ($signed(local_bb2_xor_i66) >>> 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb2_and36_lobit_i_stall_local;
wire [31:0] local_bb2_and36_lobit_i;

assign local_bb2_and36_lobit_i = (local_bb2_xor_i66 >> 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb2_shl65_i_stall_local;
wire [31:0] local_bb2_shl65_i;

assign local_bb2_shl65_i = (local_bb2_or64_i | 32'h4000000);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp69_i_stall_local;
wire local_bb2_cmp69_i;

assign local_bb2_cmp69_i = (local_bb2_and68_i > 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot30_not_i72_stall_local;
wire local_bb2_lnot30_not_i72;

assign local_bb2_lnot30_not_i72 = (local_bb2_lnot30_i68 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_shl_i81_stall_local;
wire [31:0] local_bb2_shl_i81;

assign local_bb2_shl_i81 = (local_bb2_or_i80 | 32'h4000000);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_171to172_bb2_and35_i65_0_valid_out_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and35_i65_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_171to172_bb2_and35_i65_0_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and35_i65_0_reg_172_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_171to172_bb2_and35_i65_0_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and35_i65_0_valid_out_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and35_i65_0_stall_in_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and35_i65_0_stall_out_reg_172_NO_SHIFT_REG;

acl_data_fifo rnode_171to172_bb2_and35_i65_0_reg_172_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_171to172_bb2_and35_i65_0_reg_172_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_171to172_bb2_and35_i65_0_stall_in_reg_172_NO_SHIFT_REG),
	.valid_out(rnode_171to172_bb2_and35_i65_0_valid_out_reg_172_NO_SHIFT_REG),
	.stall_out(rnode_171to172_bb2_and35_i65_0_stall_out_reg_172_NO_SHIFT_REG),
	.data_in(rnode_170to171_bb2_and35_i65_0_NO_SHIFT_REG),
	.data_out(rnode_171to172_bb2_and35_i65_0_reg_172_NO_SHIFT_REG)
);

defparam rnode_171to172_bb2_and35_i65_0_reg_172_fifo.DEPTH = 1;
defparam rnode_171to172_bb2_and35_i65_0_reg_172_fifo.DATA_WIDTH = 32;
defparam rnode_171to172_bb2_and35_i65_0_reg_172_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_171to172_bb2_and35_i65_0_reg_172_fifo.IMPL = "shift_reg";

assign rnode_171to172_bb2_and35_i65_0_reg_172_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_170to171_bb2_and35_i65_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2_and35_i65_0_NO_SHIFT_REG = rnode_171to172_bb2_and35_i65_0_reg_172_NO_SHIFT_REG;
assign rnode_171to172_bb2_and35_i65_0_stall_in_reg_172_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2_and35_i65_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_shr16_i55_valid_out_1;
wire local_bb2_shr16_i55_stall_in_1;
 reg local_bb2_shr16_i55_consumed_1_NO_SHIFT_REG;
wire local_bb2_lnot23_i62_valid_out;
wire local_bb2_lnot23_i62_stall_in;
 reg local_bb2_lnot23_i62_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp27_i64_valid_out;
wire local_bb2_cmp27_i64_stall_in;
 reg local_bb2_cmp27_i64_consumed_0_NO_SHIFT_REG;
wire local_bb2_align_0_i85_valid_out;
wire local_bb2_align_0_i85_stall_in;
 reg local_bb2_align_0_i85_consumed_0_NO_SHIFT_REG;
wire local_bb2_align_0_i85_inputs_ready;
wire local_bb2_align_0_i85_stall_local;
wire [31:0] local_bb2_align_0_i85;

assign local_bb2_align_0_i85_inputs_ready = (rnode_168to169_bb2__22_i53_0_valid_out_0_NO_SHIFT_REG & rnode_168to169_bb2__23_i54_0_valid_out_0_NO_SHIFT_REG);
assign local_bb2_align_0_i85 = (local_bb2_cmp69_i ? 32'h1F : local_bb2_and68_i);
assign local_bb2_shr16_i55_valid_out_1 = 1'b1;
assign local_bb2_lnot23_i62_valid_out = 1'b1;
assign local_bb2_cmp27_i64_valid_out = 1'b1;
assign local_bb2_align_0_i85_valid_out = 1'b1;
assign rnode_168to169_bb2__22_i53_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_168to169_bb2__23_i54_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_shr16_i55_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb2_lnot23_i62_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp27_i64_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_align_0_i85_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_shr16_i55_consumed_1_NO_SHIFT_REG <= (local_bb2_align_0_i85_inputs_ready & (local_bb2_shr16_i55_consumed_1_NO_SHIFT_REG | ~(local_bb2_shr16_i55_stall_in_1)) & local_bb2_align_0_i85_stall_local);
		local_bb2_lnot23_i62_consumed_0_NO_SHIFT_REG <= (local_bb2_align_0_i85_inputs_ready & (local_bb2_lnot23_i62_consumed_0_NO_SHIFT_REG | ~(local_bb2_lnot23_i62_stall_in)) & local_bb2_align_0_i85_stall_local);
		local_bb2_cmp27_i64_consumed_0_NO_SHIFT_REG <= (local_bb2_align_0_i85_inputs_ready & (local_bb2_cmp27_i64_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp27_i64_stall_in)) & local_bb2_align_0_i85_stall_local);
		local_bb2_align_0_i85_consumed_0_NO_SHIFT_REG <= (local_bb2_align_0_i85_inputs_ready & (local_bb2_align_0_i85_consumed_0_NO_SHIFT_REG | ~(local_bb2_align_0_i85_stall_in)) & local_bb2_align_0_i85_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_172to173_bb2_and35_i65_0_valid_out_NO_SHIFT_REG;
 logic rnode_172to173_bb2_and35_i65_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_172to173_bb2_and35_i65_0_NO_SHIFT_REG;
 logic rnode_172to173_bb2_and35_i65_0_reg_173_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_172to173_bb2_and35_i65_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_and35_i65_0_valid_out_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_and35_i65_0_stall_in_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_and35_i65_0_stall_out_reg_173_NO_SHIFT_REG;

acl_data_fifo rnode_172to173_bb2_and35_i65_0_reg_173_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_172to173_bb2_and35_i65_0_reg_173_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_172to173_bb2_and35_i65_0_stall_in_reg_173_NO_SHIFT_REG),
	.valid_out(rnode_172to173_bb2_and35_i65_0_valid_out_reg_173_NO_SHIFT_REG),
	.stall_out(rnode_172to173_bb2_and35_i65_0_stall_out_reg_173_NO_SHIFT_REG),
	.data_in(rnode_171to172_bb2_and35_i65_0_NO_SHIFT_REG),
	.data_out(rnode_172to173_bb2_and35_i65_0_reg_173_NO_SHIFT_REG)
);

defparam rnode_172to173_bb2_and35_i65_0_reg_173_fifo.DEPTH = 1;
defparam rnode_172to173_bb2_and35_i65_0_reg_173_fifo.DATA_WIDTH = 32;
defparam rnode_172to173_bb2_and35_i65_0_reg_173_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_172to173_bb2_and35_i65_0_reg_173_fifo.IMPL = "shift_reg";

assign rnode_172to173_bb2_and35_i65_0_reg_173_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_171to172_bb2_and35_i65_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_and35_i65_0_NO_SHIFT_REG = rnode_172to173_bb2_and35_i65_0_reg_173_NO_SHIFT_REG;
assign rnode_172to173_bb2_and35_i65_0_stall_in_reg_173_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_and35_i65_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_169to170_bb2_shr16_i55_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_169to170_bb2_shr16_i55_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_169to170_bb2_shr16_i55_0_NO_SHIFT_REG;
 logic rnode_169to170_bb2_shr16_i55_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_169to170_bb2_shr16_i55_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_169to170_bb2_shr16_i55_1_NO_SHIFT_REG;
 logic rnode_169to170_bb2_shr16_i55_0_reg_170_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_169to170_bb2_shr16_i55_0_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2_shr16_i55_0_valid_out_0_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2_shr16_i55_0_stall_in_0_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2_shr16_i55_0_stall_out_reg_170_NO_SHIFT_REG;

acl_data_fifo rnode_169to170_bb2_shr16_i55_0_reg_170_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_169to170_bb2_shr16_i55_0_reg_170_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_169to170_bb2_shr16_i55_0_stall_in_0_reg_170_NO_SHIFT_REG),
	.valid_out(rnode_169to170_bb2_shr16_i55_0_valid_out_0_reg_170_NO_SHIFT_REG),
	.stall_out(rnode_169to170_bb2_shr16_i55_0_stall_out_reg_170_NO_SHIFT_REG),
	.data_in(local_bb2_shr16_i55),
	.data_out(rnode_169to170_bb2_shr16_i55_0_reg_170_NO_SHIFT_REG)
);

defparam rnode_169to170_bb2_shr16_i55_0_reg_170_fifo.DEPTH = 1;
defparam rnode_169to170_bb2_shr16_i55_0_reg_170_fifo.DATA_WIDTH = 32;
defparam rnode_169to170_bb2_shr16_i55_0_reg_170_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_169to170_bb2_shr16_i55_0_reg_170_fifo.IMPL = "shift_reg";

assign rnode_169to170_bb2_shr16_i55_0_reg_170_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_shr16_i55_stall_in_1 = 1'b0;
assign rnode_169to170_bb2_shr16_i55_0_stall_in_0_reg_170_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2_shr16_i55_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_169to170_bb2_shr16_i55_0_NO_SHIFT_REG = rnode_169to170_bb2_shr16_i55_0_reg_170_NO_SHIFT_REG;
assign rnode_169to170_bb2_shr16_i55_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_169to170_bb2_shr16_i55_1_NO_SHIFT_REG = rnode_169to170_bb2_shr16_i55_0_reg_170_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_169to170_bb2_lnot23_i62_0_valid_out_NO_SHIFT_REG;
 logic rnode_169to170_bb2_lnot23_i62_0_stall_in_NO_SHIFT_REG;
 logic rnode_169to170_bb2_lnot23_i62_0_NO_SHIFT_REG;
 logic rnode_169to170_bb2_lnot23_i62_0_reg_170_inputs_ready_NO_SHIFT_REG;
 logic rnode_169to170_bb2_lnot23_i62_0_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2_lnot23_i62_0_valid_out_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2_lnot23_i62_0_stall_in_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2_lnot23_i62_0_stall_out_reg_170_NO_SHIFT_REG;

acl_data_fifo rnode_169to170_bb2_lnot23_i62_0_reg_170_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_169to170_bb2_lnot23_i62_0_reg_170_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_169to170_bb2_lnot23_i62_0_stall_in_reg_170_NO_SHIFT_REG),
	.valid_out(rnode_169to170_bb2_lnot23_i62_0_valid_out_reg_170_NO_SHIFT_REG),
	.stall_out(rnode_169to170_bb2_lnot23_i62_0_stall_out_reg_170_NO_SHIFT_REG),
	.data_in(local_bb2_lnot23_i62),
	.data_out(rnode_169to170_bb2_lnot23_i62_0_reg_170_NO_SHIFT_REG)
);

defparam rnode_169to170_bb2_lnot23_i62_0_reg_170_fifo.DEPTH = 1;
defparam rnode_169to170_bb2_lnot23_i62_0_reg_170_fifo.DATA_WIDTH = 1;
defparam rnode_169to170_bb2_lnot23_i62_0_reg_170_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_169to170_bb2_lnot23_i62_0_reg_170_fifo.IMPL = "shift_reg";

assign rnode_169to170_bb2_lnot23_i62_0_reg_170_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_lnot23_i62_stall_in = 1'b0;
assign rnode_169to170_bb2_lnot23_i62_0_NO_SHIFT_REG = rnode_169to170_bb2_lnot23_i62_0_reg_170_NO_SHIFT_REG;
assign rnode_169to170_bb2_lnot23_i62_0_stall_in_reg_170_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2_lnot23_i62_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_169to170_bb2_cmp27_i64_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_169to170_bb2_cmp27_i64_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_169to170_bb2_cmp27_i64_0_NO_SHIFT_REG;
 logic rnode_169to170_bb2_cmp27_i64_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_169to170_bb2_cmp27_i64_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_169to170_bb2_cmp27_i64_1_NO_SHIFT_REG;
 logic rnode_169to170_bb2_cmp27_i64_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_169to170_bb2_cmp27_i64_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_169to170_bb2_cmp27_i64_2_NO_SHIFT_REG;
 logic rnode_169to170_bb2_cmp27_i64_0_reg_170_inputs_ready_NO_SHIFT_REG;
 logic rnode_169to170_bb2_cmp27_i64_0_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2_cmp27_i64_0_valid_out_0_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2_cmp27_i64_0_stall_in_0_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2_cmp27_i64_0_stall_out_reg_170_NO_SHIFT_REG;

acl_data_fifo rnode_169to170_bb2_cmp27_i64_0_reg_170_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_169to170_bb2_cmp27_i64_0_reg_170_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_169to170_bb2_cmp27_i64_0_stall_in_0_reg_170_NO_SHIFT_REG),
	.valid_out(rnode_169to170_bb2_cmp27_i64_0_valid_out_0_reg_170_NO_SHIFT_REG),
	.stall_out(rnode_169to170_bb2_cmp27_i64_0_stall_out_reg_170_NO_SHIFT_REG),
	.data_in(local_bb2_cmp27_i64),
	.data_out(rnode_169to170_bb2_cmp27_i64_0_reg_170_NO_SHIFT_REG)
);

defparam rnode_169to170_bb2_cmp27_i64_0_reg_170_fifo.DEPTH = 1;
defparam rnode_169to170_bb2_cmp27_i64_0_reg_170_fifo.DATA_WIDTH = 1;
defparam rnode_169to170_bb2_cmp27_i64_0_reg_170_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_169to170_bb2_cmp27_i64_0_reg_170_fifo.IMPL = "shift_reg";

assign rnode_169to170_bb2_cmp27_i64_0_reg_170_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp27_i64_stall_in = 1'b0;
assign rnode_169to170_bb2_cmp27_i64_0_stall_in_0_reg_170_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2_cmp27_i64_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_169to170_bb2_cmp27_i64_0_NO_SHIFT_REG = rnode_169to170_bb2_cmp27_i64_0_reg_170_NO_SHIFT_REG;
assign rnode_169to170_bb2_cmp27_i64_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_169to170_bb2_cmp27_i64_1_NO_SHIFT_REG = rnode_169to170_bb2_cmp27_i64_0_reg_170_NO_SHIFT_REG;
assign rnode_169to170_bb2_cmp27_i64_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_169to170_bb2_cmp27_i64_2_NO_SHIFT_REG = rnode_169to170_bb2_cmp27_i64_0_reg_170_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_169to170_bb2_align_0_i85_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_169to170_bb2_align_0_i85_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_169to170_bb2_align_0_i85_0_NO_SHIFT_REG;
 logic rnode_169to170_bb2_align_0_i85_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_169to170_bb2_align_0_i85_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_169to170_bb2_align_0_i85_1_NO_SHIFT_REG;
 logic rnode_169to170_bb2_align_0_i85_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_169to170_bb2_align_0_i85_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_169to170_bb2_align_0_i85_2_NO_SHIFT_REG;
 logic rnode_169to170_bb2_align_0_i85_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_169to170_bb2_align_0_i85_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_169to170_bb2_align_0_i85_3_NO_SHIFT_REG;
 logic rnode_169to170_bb2_align_0_i85_0_valid_out_4_NO_SHIFT_REG;
 logic rnode_169to170_bb2_align_0_i85_0_stall_in_4_NO_SHIFT_REG;
 logic [31:0] rnode_169to170_bb2_align_0_i85_4_NO_SHIFT_REG;
 logic rnode_169to170_bb2_align_0_i85_0_reg_170_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_169to170_bb2_align_0_i85_0_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2_align_0_i85_0_valid_out_0_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2_align_0_i85_0_stall_in_0_reg_170_NO_SHIFT_REG;
 logic rnode_169to170_bb2_align_0_i85_0_stall_out_reg_170_NO_SHIFT_REG;

acl_data_fifo rnode_169to170_bb2_align_0_i85_0_reg_170_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_169to170_bb2_align_0_i85_0_reg_170_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_169to170_bb2_align_0_i85_0_stall_in_0_reg_170_NO_SHIFT_REG),
	.valid_out(rnode_169to170_bb2_align_0_i85_0_valid_out_0_reg_170_NO_SHIFT_REG),
	.stall_out(rnode_169to170_bb2_align_0_i85_0_stall_out_reg_170_NO_SHIFT_REG),
	.data_in(local_bb2_align_0_i85),
	.data_out(rnode_169to170_bb2_align_0_i85_0_reg_170_NO_SHIFT_REG)
);

defparam rnode_169to170_bb2_align_0_i85_0_reg_170_fifo.DEPTH = 1;
defparam rnode_169to170_bb2_align_0_i85_0_reg_170_fifo.DATA_WIDTH = 32;
defparam rnode_169to170_bb2_align_0_i85_0_reg_170_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_169to170_bb2_align_0_i85_0_reg_170_fifo.IMPL = "shift_reg";

assign rnode_169to170_bb2_align_0_i85_0_reg_170_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_align_0_i85_stall_in = 1'b0;
assign rnode_169to170_bb2_align_0_i85_0_stall_in_0_reg_170_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2_align_0_i85_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_169to170_bb2_align_0_i85_0_NO_SHIFT_REG = rnode_169to170_bb2_align_0_i85_0_reg_170_NO_SHIFT_REG;
assign rnode_169to170_bb2_align_0_i85_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_169to170_bb2_align_0_i85_1_NO_SHIFT_REG = rnode_169to170_bb2_align_0_i85_0_reg_170_NO_SHIFT_REG;
assign rnode_169to170_bb2_align_0_i85_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_169to170_bb2_align_0_i85_2_NO_SHIFT_REG = rnode_169to170_bb2_align_0_i85_0_reg_170_NO_SHIFT_REG;
assign rnode_169to170_bb2_align_0_i85_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_169to170_bb2_align_0_i85_3_NO_SHIFT_REG = rnode_169to170_bb2_align_0_i85_0_reg_170_NO_SHIFT_REG;
assign rnode_169to170_bb2_align_0_i85_0_valid_out_4_NO_SHIFT_REG = 1'b1;
assign rnode_169to170_bb2_align_0_i85_4_NO_SHIFT_REG = rnode_169to170_bb2_align_0_i85_0_reg_170_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_and17_i56_stall_local;
wire [31:0] local_bb2_and17_i56;

assign local_bb2_and17_i56 = (rnode_169to170_bb2_shr16_i55_0_NO_SHIFT_REG & 32'hFF);

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_170to172_bb2_shr16_i55_0_valid_out_NO_SHIFT_REG;
 logic rnode_170to172_bb2_shr16_i55_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_170to172_bb2_shr16_i55_0_NO_SHIFT_REG;
 logic rnode_170to172_bb2_shr16_i55_0_reg_172_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_170to172_bb2_shr16_i55_0_reg_172_NO_SHIFT_REG;
 logic rnode_170to172_bb2_shr16_i55_0_valid_out_reg_172_NO_SHIFT_REG;
 logic rnode_170to172_bb2_shr16_i55_0_stall_in_reg_172_NO_SHIFT_REG;
 logic rnode_170to172_bb2_shr16_i55_0_stall_out_reg_172_NO_SHIFT_REG;

acl_data_fifo rnode_170to172_bb2_shr16_i55_0_reg_172_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_170to172_bb2_shr16_i55_0_reg_172_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_170to172_bb2_shr16_i55_0_stall_in_reg_172_NO_SHIFT_REG),
	.valid_out(rnode_170to172_bb2_shr16_i55_0_valid_out_reg_172_NO_SHIFT_REG),
	.stall_out(rnode_170to172_bb2_shr16_i55_0_stall_out_reg_172_NO_SHIFT_REG),
	.data_in(rnode_169to170_bb2_shr16_i55_1_NO_SHIFT_REG),
	.data_out(rnode_170to172_bb2_shr16_i55_0_reg_172_NO_SHIFT_REG)
);

defparam rnode_170to172_bb2_shr16_i55_0_reg_172_fifo.DEPTH = 2;
defparam rnode_170to172_bb2_shr16_i55_0_reg_172_fifo.DATA_WIDTH = 32;
defparam rnode_170to172_bb2_shr16_i55_0_reg_172_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_170to172_bb2_shr16_i55_0_reg_172_fifo.IMPL = "shift_reg";

assign rnode_170to172_bb2_shr16_i55_0_reg_172_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_169to170_bb2_shr16_i55_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_170to172_bb2_shr16_i55_0_NO_SHIFT_REG = rnode_170to172_bb2_shr16_i55_0_reg_172_NO_SHIFT_REG;
assign rnode_170to172_bb2_shr16_i55_0_stall_in_reg_172_NO_SHIFT_REG = 1'b0;
assign rnode_170to172_bb2_shr16_i55_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2__28_i83_stall_local;
wire [31:0] local_bb2__28_i83;

assign local_bb2__28_i83 = (rnode_169to170_bb2_lnot23_i62_0_NO_SHIFT_REG ? 32'h0 : local_bb2_shl65_i);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge_not_i71_stall_local;
wire local_bb2_brmerge_not_i71;

assign local_bb2_brmerge_not_i71 = (rnode_169to170_bb2_cmp27_i64_0_NO_SHIFT_REG & local_bb2_lnot33_not_i70);

// This section implements an unregistered operation.
// 
wire local_bb2_and93_i_stall_local;
wire [31:0] local_bb2_and93_i;

assign local_bb2_and93_i = (rnode_169to170_bb2_align_0_i85_0_NO_SHIFT_REG & 32'h1C);

// This section implements an unregistered operation.
// 
wire local_bb2_and95_i_stall_local;
wire [31:0] local_bb2_and95_i;

assign local_bb2_and95_i = (rnode_169to170_bb2_align_0_i85_1_NO_SHIFT_REG & 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb2_and115_i_stall_local;
wire [31:0] local_bb2_and115_i;

assign local_bb2_and115_i = (rnode_169to170_bb2_align_0_i85_2_NO_SHIFT_REG & 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb2_and130_i_stall_local;
wire [31:0] local_bb2_and130_i;

assign local_bb2_and130_i = (rnode_169to170_bb2_align_0_i85_3_NO_SHIFT_REG & 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb2_and149_i_stall_local;
wire [31:0] local_bb2_and149_i;

assign local_bb2_and149_i = (rnode_169to170_bb2_align_0_i85_4_NO_SHIFT_REG & 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_i61_stall_local;
wire local_bb2_lnot_i61;

assign local_bb2_lnot_i61 = (local_bb2_and17_i56 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp25_i63_stall_local;
wire local_bb2_cmp25_i63;

assign local_bb2_cmp25_i63 = (local_bb2_and17_i56 == 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and72_i_stall_local;
wire [31:0] local_bb2_and72_i;

assign local_bb2_and72_i = (local_bb2__28_i83 >> 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb2_and75_i86_stall_local;
wire [31:0] local_bb2_and75_i86;

assign local_bb2_and75_i86 = (local_bb2__28_i83 & 32'hF0);

// This section implements an unregistered operation.
// 
wire local_bb2_and78_i_stall_local;
wire [31:0] local_bb2_and78_i;

assign local_bb2_and78_i = (local_bb2__28_i83 & 32'hF00);

// This section implements an unregistered operation.
// 
wire local_bb2_and90_i87_stall_local;
wire [31:0] local_bb2_and90_i87;

assign local_bb2_and90_i87 = (local_bb2__28_i83 & 32'h7000000);

// This section implements an unregistered operation.
// 
wire local_bb2_and87_i_stall_local;
wire [31:0] local_bb2_and87_i;

assign local_bb2_and87_i = (local_bb2__28_i83 & 32'hF00000);

// This section implements an unregistered operation.
// 
wire local_bb2_and84_i_stall_local;
wire [31:0] local_bb2_and84_i;

assign local_bb2_and84_i = (local_bb2__28_i83 & 32'hF0000);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u16_stall_local;
wire [31:0] local_bb2_var__u16;

assign local_bb2_var__u16 = (local_bb2__28_i83 & 32'hFFF8);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge_not_not_i75_stall_local;
wire local_bb2_brmerge_not_not_i75;

assign local_bb2_brmerge_not_not_i75 = (local_bb2_brmerge_not_i71 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_shr94_i_stall_local;
wire [31:0] local_bb2_shr94_i;

assign local_bb2_shr94_i = (local_bb2__28_i83 >> local_bb2_and93_i);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp96_i_stall_local;
wire local_bb2_cmp96_i;

assign local_bb2_cmp96_i = (local_bb2_and95_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp116_i_stall_local;
wire local_bb2_cmp116_i;

assign local_bb2_cmp116_i = (local_bb2_and115_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp131_not_i_stall_local;
wire local_bb2_cmp131_not_i;

assign local_bb2_cmp131_not_i = (local_bb2_and130_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_Pivot20_i97_stall_local;
wire local_bb2_Pivot20_i97;

assign local_bb2_Pivot20_i97 = (local_bb2_and149_i < 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb2_SwitchLeaf_i98_stall_local;
wire local_bb2_SwitchLeaf_i98;

assign local_bb2_SwitchLeaf_i98 = (local_bb2_and149_i == 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2__27_i82_stall_local;
wire [31:0] local_bb2__27_i82;

assign local_bb2__27_i82 = (local_bb2_lnot_i61 ? 32'h0 : local_bb2_shl_i81);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp25_not_i67_stall_local;
wire local_bb2_cmp25_not_i67;

assign local_bb2_cmp25_not_i67 = (local_bb2_cmp25_i63 ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_or_cond_not_i73_stall_local;
wire local_bb2_or_cond_not_i73;

assign local_bb2_or_cond_not_i73 = (local_bb2_cmp25_i63 & local_bb2_lnot30_not_i72);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u17_stall_local;
wire local_bb2_var__u17;

assign local_bb2_var__u17 = (local_bb2_cmp25_i63 | rnode_169to170_bb2_cmp27_i64_2_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_and72_tr_i_stall_local;
wire [7:0] local_bb2_and72_tr_i;

assign local_bb2_and72_tr_i = local_bb2_and72_i[7:0];

// This section implements an unregistered operation.
// 
wire local_bb2_cmp76_i_stall_local;
wire local_bb2_cmp76_i;

assign local_bb2_cmp76_i = (local_bb2_and75_i86 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp79_i_stall_local;
wire local_bb2_cmp79_i;

assign local_bb2_cmp79_i = (local_bb2_and78_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp91_i88_stall_local;
wire local_bb2_cmp91_i88;

assign local_bb2_cmp91_i88 = (local_bb2_and90_i87 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp88_i_stall_local;
wire local_bb2_cmp88_i;

assign local_bb2_cmp88_i = (local_bb2_and87_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp85_i_stall_local;
wire local_bb2_cmp85_i;

assign local_bb2_cmp85_i = (local_bb2_and84_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u18_stall_local;
wire local_bb2_var__u18;

assign local_bb2_var__u18 = (local_bb2_var__u16 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_7_i76_stall_local;
wire local_bb2_reduction_7_i76;

assign local_bb2_reduction_7_i76 = (local_bb2_cmp25_i63 & local_bb2_brmerge_not_not_i75);

// This section implements an unregistered operation.
// 
wire local_bb2_and142_i_stall_local;
wire [31:0] local_bb2_and142_i;

assign local_bb2_and142_i = (local_bb2_shr94_i >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_shr150_i_stall_local;
wire [31:0] local_bb2_shr150_i;

assign local_bb2_shr150_i = (local_bb2_shr94_i >> local_bb2_and149_i);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u19_stall_local;
wire [31:0] local_bb2_var__u19;

assign local_bb2_var__u19 = (local_bb2_shr94_i & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_and146_i_stall_local;
wire [31:0] local_bb2_and146_i;

assign local_bb2_and146_i = (local_bb2_shr94_i >> 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb2_add_i105_stall_local;
wire [31:0] local_bb2_add_i105;

assign local_bb2_add_i105 = (local_bb2__27_i82 | local_bb2_and36_lobit_i);

// This section implements an unregistered operation.
// 
wire local_bb2_or_cond_i69_stall_local;
wire local_bb2_or_cond_i69;

assign local_bb2_or_cond_i69 = (local_bb2_lnot30_i68 | local_bb2_cmp25_not_i67);

// This section implements an unregistered operation.
// 
wire local_bb2__24_i74_stall_local;
wire local_bb2__24_i74;

assign local_bb2__24_i74 = (local_bb2_or_cond_not_i73 | local_bb2_brmerge_not_i71);

// This section implements an unregistered operation.
// 
wire local_bb2_frombool74_i_stall_local;
wire [7:0] local_bb2_frombool74_i;

assign local_bb2_frombool74_i = (local_bb2_and72_tr_i & 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb2__31_v_i92_stall_local;
wire local_bb2__31_v_i92;

assign local_bb2__31_v_i92 = (local_bb2_cmp96_i ? local_bb2_cmp79_i : local_bb2_cmp91_i88);

// This section implements an unregistered operation.
// 
wire local_bb2__30_v_i90_stall_local;
wire local_bb2__30_v_i90;

assign local_bb2__30_v_i90 = (local_bb2_cmp96_i ? local_bb2_cmp76_i : local_bb2_cmp88_i);

// This section implements an unregistered operation.
// 
wire local_bb2_frombool109_i_stall_local;
wire [7:0] local_bb2_frombool109_i;

assign local_bb2_frombool109_i[7:1] = 7'h0;
assign local_bb2_frombool109_i[0] = local_bb2_cmp85_i;

// This section implements an unregistered operation.
// 
wire local_bb2_or107_i_stall_local;
wire [31:0] local_bb2_or107_i;

assign local_bb2_or107_i[31:1] = 31'h0;
assign local_bb2_or107_i[0] = local_bb2_var__u18;

// This section implements an unregistered operation.
// 
wire local_bb2_var__u20_stall_local;
wire [31:0] local_bb2_var__u20;

assign local_bb2_var__u20 = (local_bb2_and146_i | local_bb2_shr94_i);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_8_i77_stall_local;
wire local_bb2_reduction_8_i77;

assign local_bb2_reduction_8_i77 = (rnode_169to170_bb2_cmp27_i64_1_NO_SHIFT_REG & local_bb2_or_cond_i69);

// This section implements an unregistered operation.
// 
wire local_bb2__31_i93_stall_local;
wire [7:0] local_bb2__31_i93;

assign local_bb2__31_i93[7:1] = 7'h0;
assign local_bb2__31_i93[0] = local_bb2__31_v_i92;

// This section implements an unregistered operation.
// 
wire local_bb2__30_i91_stall_local;
wire [7:0] local_bb2__30_i91;

assign local_bb2__30_i91[7:1] = 7'h0;
assign local_bb2__30_i91[0] = local_bb2__30_v_i90;

// This section implements an unregistered operation.
// 
wire local_bb2__29_i89_stall_local;
wire [7:0] local_bb2__29_i89;

assign local_bb2__29_i89 = (local_bb2_cmp96_i ? local_bb2_frombool74_i : local_bb2_frombool109_i);

// This section implements an unregistered operation.
// 
wire local_bb2__32_i94_stall_local;
wire [31:0] local_bb2__32_i94;

assign local_bb2__32_i94 = (local_bb2_cmp96_i ? 32'h0 : local_bb2_or107_i);

// This section implements an unregistered operation.
// 
wire local_bb2_or1596_i_stall_local;
wire [31:0] local_bb2_or1596_i;

assign local_bb2_or1596_i = (local_bb2_var__u20 | local_bb2_and142_i);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_9_i78_stall_local;
wire local_bb2_reduction_9_i78;

assign local_bb2_reduction_9_i78 = (local_bb2_reduction_7_i76 & local_bb2_reduction_8_i77);

// This section implements an unregistered operation.
// 
wire local_bb2_or1237_i_stall_local;
wire [7:0] local_bb2_or1237_i;

assign local_bb2_or1237_i = (local_bb2__30_i91 | local_bb2__29_i89);

// This section implements an unregistered operation.
// 
wire local_bb2__33_i95_stall_local;
wire [7:0] local_bb2__33_i95;

assign local_bb2__33_i95 = (local_bb2_cmp116_i ? local_bb2__29_i89 : local_bb2__31_i93);

// This section implements an unregistered operation.
// 
wire local_bb2_or162_i_stall_local;
wire [31:0] local_bb2_or162_i;

assign local_bb2_or162_i = (local_bb2_or1596_i & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2__26_i79_stall_local;
wire local_bb2__26_i79;

assign local_bb2__26_i79 = (local_bb2_reduction_9_i78 ? local_bb2_cmp37_i : local_bb2__24_i74);

// This section implements an unregistered operation.
// 
wire local_bb2_or123_i_stall_local;
wire [31:0] local_bb2_or123_i;

assign local_bb2_or123_i[31:8] = 24'h0;
assign local_bb2_or123_i[7:0] = local_bb2_or1237_i;

// This section implements an unregistered operation.
// 
wire local_bb2_var__u21_stall_local;
wire [7:0] local_bb2_var__u21;

assign local_bb2_var__u21 = (local_bb2__33_i95 & 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb2__37_v_i99_stall_local;
wire [31:0] local_bb2__37_v_i99;

assign local_bb2__37_v_i99 = (local_bb2_Pivot20_i97 ? 32'h0 : local_bb2_or162_i);

// This section implements an unregistered operation.
// 
wire local_bb2_or124_i96_stall_local;
wire [31:0] local_bb2_or124_i96;

assign local_bb2_or124_i96 = (local_bb2_cmp116_i ? 32'h0 : local_bb2_or123_i);

// This section implements an unregistered operation.
// 
wire local_bb2_conv135_i_stall_local;
wire [31:0] local_bb2_conv135_i;

assign local_bb2_conv135_i[31:8] = 24'h0;
assign local_bb2_conv135_i[7:0] = local_bb2_var__u21;

// This section implements an unregistered operation.
// 
wire local_bb2__39_v_i100_stall_local;
wire [31:0] local_bb2__39_v_i100;

assign local_bb2__39_v_i100 = (local_bb2_SwitchLeaf_i98 ? local_bb2_var__u19 : local_bb2__37_v_i99);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_3_i101_stall_local;
wire [31:0] local_bb2_reduction_3_i101;

assign local_bb2_reduction_3_i101 = (local_bb2__32_i94 | local_bb2_or124_i96);

// This section implements an unregistered operation.
// 
wire local_bb2_or136_i_stall_local;
wire [31:0] local_bb2_or136_i;

assign local_bb2_or136_i = (local_bb2_cmp131_not_i ? local_bb2_conv135_i : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_5_i103_stall_local;
wire [31:0] local_bb2_reduction_5_i103;

assign local_bb2_reduction_5_i103 = (local_bb2_shr150_i | local_bb2_reduction_3_i101);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_4_i102_stall_local;
wire [31:0] local_bb2_reduction_4_i102;

assign local_bb2_reduction_4_i102 = (local_bb2_or136_i | local_bb2__39_v_i100);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_6_i104_stall_local;
wire [31:0] local_bb2_reduction_6_i104;

assign local_bb2_reduction_6_i104 = (local_bb2_reduction_4_i102 | local_bb2_reduction_5_i103);

// This section implements an unregistered operation.
// 
wire local_bb2_xor188_i_stall_local;
wire [31:0] local_bb2_xor188_i;

assign local_bb2_xor188_i = (local_bb2_reduction_6_i104 ^ local_bb2_xor_lobit_i);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp37_i_valid_out_1;
wire local_bb2_cmp37_i_stall_in_1;
 reg local_bb2_cmp37_i_consumed_1_NO_SHIFT_REG;
wire local_bb2__26_i79_valid_out;
wire local_bb2__26_i79_stall_in;
 reg local_bb2__26_i79_consumed_0_NO_SHIFT_REG;
wire local_bb2_add192_i_valid_out;
wire local_bb2_add192_i_stall_in;
 reg local_bb2_add192_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_and17_i56_valid_out_2;
wire local_bb2_and17_i56_stall_in_2;
 reg local_bb2_and17_i56_consumed_2_NO_SHIFT_REG;
wire local_bb2_var__u17_valid_out;
wire local_bb2_var__u17_stall_in;
 reg local_bb2_var__u17_consumed_0_NO_SHIFT_REG;
wire local_bb2_add192_i_inputs_ready;
wire local_bb2_add192_i_stall_local;
wire [31:0] local_bb2_add192_i;

assign local_bb2_add192_i_inputs_ready = (rnode_169to170_bb2__22_i53_0_valid_out_0_NO_SHIFT_REG & rnode_169to170_bb2_cmp27_i64_0_valid_out_0_NO_SHIFT_REG & rnode_169to170_bb2_lnot23_i62_0_valid_out_NO_SHIFT_REG & rnode_169to170_bb2__22_i53_0_valid_out_1_NO_SHIFT_REG & rnode_169to170_bb2__23_i54_0_valid_out_2_NO_SHIFT_REG & rnode_169to170_bb2__23_i54_0_valid_out_0_NO_SHIFT_REG & rnode_169to170_bb2_cmp27_i64_0_valid_out_1_NO_SHIFT_REG & rnode_169to170_bb2_shr16_i55_0_valid_out_0_NO_SHIFT_REG & rnode_169to170_bb2_cmp27_i64_0_valid_out_2_NO_SHIFT_REG & rnode_169to170_bb2_align_0_i85_0_valid_out_0_NO_SHIFT_REG & rnode_169to170_bb2_align_0_i85_0_valid_out_4_NO_SHIFT_REG & rnode_169to170_bb2_align_0_i85_0_valid_out_1_NO_SHIFT_REG & rnode_169to170_bb2_align_0_i85_0_valid_out_2_NO_SHIFT_REG & rnode_169to170_bb2_align_0_i85_0_valid_out_3_NO_SHIFT_REG);
assign local_bb2_add192_i = (local_bb2_add_i105 + local_bb2_xor188_i);
assign local_bb2_cmp37_i_valid_out_1 = 1'b1;
assign local_bb2__26_i79_valid_out = 1'b1;
assign local_bb2_add192_i_valid_out = 1'b1;
assign local_bb2_and17_i56_valid_out_2 = 1'b1;
assign local_bb2_var__u17_valid_out = 1'b1;
assign rnode_169to170_bb2__22_i53_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2_cmp27_i64_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2_lnot23_i62_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2__22_i53_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2__23_i54_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2__23_i54_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2_cmp27_i64_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2_shr16_i55_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2_cmp27_i64_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2_align_0_i85_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2_align_0_i85_0_stall_in_4_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2_align_0_i85_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2_align_0_i85_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_169to170_bb2_align_0_i85_0_stall_in_3_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_cmp37_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb2__26_i79_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_add192_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_and17_i56_consumed_2_NO_SHIFT_REG <= 1'b0;
		local_bb2_var__u17_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_cmp37_i_consumed_1_NO_SHIFT_REG <= (local_bb2_add192_i_inputs_ready & (local_bb2_cmp37_i_consumed_1_NO_SHIFT_REG | ~(local_bb2_cmp37_i_stall_in_1)) & local_bb2_add192_i_stall_local);
		local_bb2__26_i79_consumed_0_NO_SHIFT_REG <= (local_bb2_add192_i_inputs_ready & (local_bb2__26_i79_consumed_0_NO_SHIFT_REG | ~(local_bb2__26_i79_stall_in)) & local_bb2_add192_i_stall_local);
		local_bb2_add192_i_consumed_0_NO_SHIFT_REG <= (local_bb2_add192_i_inputs_ready & (local_bb2_add192_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_add192_i_stall_in)) & local_bb2_add192_i_stall_local);
		local_bb2_and17_i56_consumed_2_NO_SHIFT_REG <= (local_bb2_add192_i_inputs_ready & (local_bb2_and17_i56_consumed_2_NO_SHIFT_REG | ~(local_bb2_and17_i56_stall_in_2)) & local_bb2_add192_i_stall_local);
		local_bb2_var__u17_consumed_0_NO_SHIFT_REG <= (local_bb2_add192_i_inputs_ready & (local_bb2_var__u17_consumed_0_NO_SHIFT_REG | ~(local_bb2_var__u17_stall_in)) & local_bb2_add192_i_stall_local);
	end
end


// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_170to172_bb2_cmp37_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_170to172_bb2_cmp37_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_170to172_bb2_cmp37_i_0_NO_SHIFT_REG;
 logic rnode_170to172_bb2_cmp37_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_170to172_bb2_cmp37_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_170to172_bb2_cmp37_i_1_NO_SHIFT_REG;
 logic rnode_170to172_bb2_cmp37_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_170to172_bb2_cmp37_i_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_170to172_bb2_cmp37_i_2_NO_SHIFT_REG;
 logic rnode_170to172_bb2_cmp37_i_0_reg_172_inputs_ready_NO_SHIFT_REG;
 logic rnode_170to172_bb2_cmp37_i_0_reg_172_NO_SHIFT_REG;
 logic rnode_170to172_bb2_cmp37_i_0_valid_out_0_reg_172_NO_SHIFT_REG;
 logic rnode_170to172_bb2_cmp37_i_0_stall_in_0_reg_172_NO_SHIFT_REG;
 logic rnode_170to172_bb2_cmp37_i_0_stall_out_reg_172_NO_SHIFT_REG;

acl_data_fifo rnode_170to172_bb2_cmp37_i_0_reg_172_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_170to172_bb2_cmp37_i_0_reg_172_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_170to172_bb2_cmp37_i_0_stall_in_0_reg_172_NO_SHIFT_REG),
	.valid_out(rnode_170to172_bb2_cmp37_i_0_valid_out_0_reg_172_NO_SHIFT_REG),
	.stall_out(rnode_170to172_bb2_cmp37_i_0_stall_out_reg_172_NO_SHIFT_REG),
	.data_in(local_bb2_cmp37_i),
	.data_out(rnode_170to172_bb2_cmp37_i_0_reg_172_NO_SHIFT_REG)
);

defparam rnode_170to172_bb2_cmp37_i_0_reg_172_fifo.DEPTH = 2;
defparam rnode_170to172_bb2_cmp37_i_0_reg_172_fifo.DATA_WIDTH = 1;
defparam rnode_170to172_bb2_cmp37_i_0_reg_172_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_170to172_bb2_cmp37_i_0_reg_172_fifo.IMPL = "shift_reg";

assign rnode_170to172_bb2_cmp37_i_0_reg_172_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp37_i_stall_in_1 = 1'b0;
assign rnode_170to172_bb2_cmp37_i_0_stall_in_0_reg_172_NO_SHIFT_REG = 1'b0;
assign rnode_170to172_bb2_cmp37_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_170to172_bb2_cmp37_i_0_NO_SHIFT_REG = rnode_170to172_bb2_cmp37_i_0_reg_172_NO_SHIFT_REG;
assign rnode_170to172_bb2_cmp37_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_170to172_bb2_cmp37_i_1_NO_SHIFT_REG = rnode_170to172_bb2_cmp37_i_0_reg_172_NO_SHIFT_REG;
assign rnode_170to172_bb2_cmp37_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_170to172_bb2_cmp37_i_2_NO_SHIFT_REG = rnode_170to172_bb2_cmp37_i_0_reg_172_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_170to171_bb2__26_i79_0_valid_out_NO_SHIFT_REG;
 logic rnode_170to171_bb2__26_i79_0_stall_in_NO_SHIFT_REG;
 logic rnode_170to171_bb2__26_i79_0_NO_SHIFT_REG;
 logic rnode_170to171_bb2__26_i79_0_reg_171_inputs_ready_NO_SHIFT_REG;
 logic rnode_170to171_bb2__26_i79_0_reg_171_NO_SHIFT_REG;
 logic rnode_170to171_bb2__26_i79_0_valid_out_reg_171_NO_SHIFT_REG;
 logic rnode_170to171_bb2__26_i79_0_stall_in_reg_171_NO_SHIFT_REG;
 logic rnode_170to171_bb2__26_i79_0_stall_out_reg_171_NO_SHIFT_REG;

acl_data_fifo rnode_170to171_bb2__26_i79_0_reg_171_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_170to171_bb2__26_i79_0_reg_171_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_170to171_bb2__26_i79_0_stall_in_reg_171_NO_SHIFT_REG),
	.valid_out(rnode_170to171_bb2__26_i79_0_valid_out_reg_171_NO_SHIFT_REG),
	.stall_out(rnode_170to171_bb2__26_i79_0_stall_out_reg_171_NO_SHIFT_REG),
	.data_in(local_bb2__26_i79),
	.data_out(rnode_170to171_bb2__26_i79_0_reg_171_NO_SHIFT_REG)
);

defparam rnode_170to171_bb2__26_i79_0_reg_171_fifo.DEPTH = 1;
defparam rnode_170to171_bb2__26_i79_0_reg_171_fifo.DATA_WIDTH = 1;
defparam rnode_170to171_bb2__26_i79_0_reg_171_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_170to171_bb2__26_i79_0_reg_171_fifo.IMPL = "shift_reg";

assign rnode_170to171_bb2__26_i79_0_reg_171_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__26_i79_stall_in = 1'b0;
assign rnode_170to171_bb2__26_i79_0_NO_SHIFT_REG = rnode_170to171_bb2__26_i79_0_reg_171_NO_SHIFT_REG;
assign rnode_170to171_bb2__26_i79_0_stall_in_reg_171_NO_SHIFT_REG = 1'b0;
assign rnode_170to171_bb2__26_i79_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_170to171_bb2_add192_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_170to171_bb2_add192_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_170to171_bb2_add192_i_0_NO_SHIFT_REG;
 logic rnode_170to171_bb2_add192_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_170to171_bb2_add192_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_170to171_bb2_add192_i_1_NO_SHIFT_REG;
 logic rnode_170to171_bb2_add192_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_170to171_bb2_add192_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_170to171_bb2_add192_i_2_NO_SHIFT_REG;
 logic rnode_170to171_bb2_add192_i_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_170to171_bb2_add192_i_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_170to171_bb2_add192_i_3_NO_SHIFT_REG;
 logic rnode_170to171_bb2_add192_i_0_reg_171_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_170to171_bb2_add192_i_0_reg_171_NO_SHIFT_REG;
 logic rnode_170to171_bb2_add192_i_0_valid_out_0_reg_171_NO_SHIFT_REG;
 logic rnode_170to171_bb2_add192_i_0_stall_in_0_reg_171_NO_SHIFT_REG;
 logic rnode_170to171_bb2_add192_i_0_stall_out_reg_171_NO_SHIFT_REG;

acl_data_fifo rnode_170to171_bb2_add192_i_0_reg_171_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_170to171_bb2_add192_i_0_reg_171_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_170to171_bb2_add192_i_0_stall_in_0_reg_171_NO_SHIFT_REG),
	.valid_out(rnode_170to171_bb2_add192_i_0_valid_out_0_reg_171_NO_SHIFT_REG),
	.stall_out(rnode_170to171_bb2_add192_i_0_stall_out_reg_171_NO_SHIFT_REG),
	.data_in(local_bb2_add192_i),
	.data_out(rnode_170to171_bb2_add192_i_0_reg_171_NO_SHIFT_REG)
);

defparam rnode_170to171_bb2_add192_i_0_reg_171_fifo.DEPTH = 1;
defparam rnode_170to171_bb2_add192_i_0_reg_171_fifo.DATA_WIDTH = 32;
defparam rnode_170to171_bb2_add192_i_0_reg_171_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_170to171_bb2_add192_i_0_reg_171_fifo.IMPL = "shift_reg";

assign rnode_170to171_bb2_add192_i_0_reg_171_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_add192_i_stall_in = 1'b0;
assign rnode_170to171_bb2_add192_i_0_stall_in_0_reg_171_NO_SHIFT_REG = 1'b0;
assign rnode_170to171_bb2_add192_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_170to171_bb2_add192_i_0_NO_SHIFT_REG = rnode_170to171_bb2_add192_i_0_reg_171_NO_SHIFT_REG;
assign rnode_170to171_bb2_add192_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_170to171_bb2_add192_i_1_NO_SHIFT_REG = rnode_170to171_bb2_add192_i_0_reg_171_NO_SHIFT_REG;
assign rnode_170to171_bb2_add192_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_170to171_bb2_add192_i_2_NO_SHIFT_REG = rnode_170to171_bb2_add192_i_0_reg_171_NO_SHIFT_REG;
assign rnode_170to171_bb2_add192_i_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_170to171_bb2_add192_i_3_NO_SHIFT_REG = rnode_170to171_bb2_add192_i_0_reg_171_NO_SHIFT_REG;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_170to172_bb2_and17_i56_0_valid_out_NO_SHIFT_REG;
 logic rnode_170to172_bb2_and17_i56_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_170to172_bb2_and17_i56_0_NO_SHIFT_REG;
 logic rnode_170to172_bb2_and17_i56_0_reg_172_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_170to172_bb2_and17_i56_0_reg_172_NO_SHIFT_REG;
 logic rnode_170to172_bb2_and17_i56_0_valid_out_reg_172_NO_SHIFT_REG;
 logic rnode_170to172_bb2_and17_i56_0_stall_in_reg_172_NO_SHIFT_REG;
 logic rnode_170to172_bb2_and17_i56_0_stall_out_reg_172_NO_SHIFT_REG;

acl_data_fifo rnode_170to172_bb2_and17_i56_0_reg_172_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_170to172_bb2_and17_i56_0_reg_172_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_170to172_bb2_and17_i56_0_stall_in_reg_172_NO_SHIFT_REG),
	.valid_out(rnode_170to172_bb2_and17_i56_0_valid_out_reg_172_NO_SHIFT_REG),
	.stall_out(rnode_170to172_bb2_and17_i56_0_stall_out_reg_172_NO_SHIFT_REG),
	.data_in(local_bb2_and17_i56),
	.data_out(rnode_170to172_bb2_and17_i56_0_reg_172_NO_SHIFT_REG)
);

defparam rnode_170to172_bb2_and17_i56_0_reg_172_fifo.DEPTH = 2;
defparam rnode_170to172_bb2_and17_i56_0_reg_172_fifo.DATA_WIDTH = 32;
defparam rnode_170to172_bb2_and17_i56_0_reg_172_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_170to172_bb2_and17_i56_0_reg_172_fifo.IMPL = "shift_reg";

assign rnode_170to172_bb2_and17_i56_0_reg_172_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and17_i56_stall_in_2 = 1'b0;
assign rnode_170to172_bb2_and17_i56_0_NO_SHIFT_REG = rnode_170to172_bb2_and17_i56_0_reg_172_NO_SHIFT_REG;
assign rnode_170to172_bb2_and17_i56_0_stall_in_reg_172_NO_SHIFT_REG = 1'b0;
assign rnode_170to172_bb2_and17_i56_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_170to171_bb2_var__u17_0_valid_out_NO_SHIFT_REG;
 logic rnode_170to171_bb2_var__u17_0_stall_in_NO_SHIFT_REG;
 logic rnode_170to171_bb2_var__u17_0_NO_SHIFT_REG;
 logic rnode_170to171_bb2_var__u17_0_reg_171_inputs_ready_NO_SHIFT_REG;
 logic rnode_170to171_bb2_var__u17_0_reg_171_NO_SHIFT_REG;
 logic rnode_170to171_bb2_var__u17_0_valid_out_reg_171_NO_SHIFT_REG;
 logic rnode_170to171_bb2_var__u17_0_stall_in_reg_171_NO_SHIFT_REG;
 logic rnode_170to171_bb2_var__u17_0_stall_out_reg_171_NO_SHIFT_REG;

acl_data_fifo rnode_170to171_bb2_var__u17_0_reg_171_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_170to171_bb2_var__u17_0_reg_171_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_170to171_bb2_var__u17_0_stall_in_reg_171_NO_SHIFT_REG),
	.valid_out(rnode_170to171_bb2_var__u17_0_valid_out_reg_171_NO_SHIFT_REG),
	.stall_out(rnode_170to171_bb2_var__u17_0_stall_out_reg_171_NO_SHIFT_REG),
	.data_in(local_bb2_var__u17),
	.data_out(rnode_170to171_bb2_var__u17_0_reg_171_NO_SHIFT_REG)
);

defparam rnode_170to171_bb2_var__u17_0_reg_171_fifo.DEPTH = 1;
defparam rnode_170to171_bb2_var__u17_0_reg_171_fifo.DATA_WIDTH = 1;
defparam rnode_170to171_bb2_var__u17_0_reg_171_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_170to171_bb2_var__u17_0_reg_171_fifo.IMPL = "shift_reg";

assign rnode_170to171_bb2_var__u17_0_reg_171_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_var__u17_stall_in = 1'b0;
assign rnode_170to171_bb2_var__u17_0_NO_SHIFT_REG = rnode_170to171_bb2_var__u17_0_reg_171_NO_SHIFT_REG;
assign rnode_170to171_bb2_var__u17_0_stall_in_reg_171_NO_SHIFT_REG = 1'b0;
assign rnode_170to171_bb2_var__u17_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_not_cmp37_i_stall_local;
wire local_bb2_not_cmp37_i;

assign local_bb2_not_cmp37_i = (rnode_170to172_bb2_cmp37_i_1_NO_SHIFT_REG ^ 1'b1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_171to172_bb2__26_i79_0_valid_out_NO_SHIFT_REG;
 logic rnode_171to172_bb2__26_i79_0_stall_in_NO_SHIFT_REG;
 logic rnode_171to172_bb2__26_i79_0_NO_SHIFT_REG;
 logic rnode_171to172_bb2__26_i79_0_reg_172_inputs_ready_NO_SHIFT_REG;
 logic rnode_171to172_bb2__26_i79_0_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2__26_i79_0_valid_out_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2__26_i79_0_stall_in_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2__26_i79_0_stall_out_reg_172_NO_SHIFT_REG;

acl_data_fifo rnode_171to172_bb2__26_i79_0_reg_172_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_171to172_bb2__26_i79_0_reg_172_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_171to172_bb2__26_i79_0_stall_in_reg_172_NO_SHIFT_REG),
	.valid_out(rnode_171to172_bb2__26_i79_0_valid_out_reg_172_NO_SHIFT_REG),
	.stall_out(rnode_171to172_bb2__26_i79_0_stall_out_reg_172_NO_SHIFT_REG),
	.data_in(rnode_170to171_bb2__26_i79_0_NO_SHIFT_REG),
	.data_out(rnode_171to172_bb2__26_i79_0_reg_172_NO_SHIFT_REG)
);

defparam rnode_171to172_bb2__26_i79_0_reg_172_fifo.DEPTH = 1;
defparam rnode_171to172_bb2__26_i79_0_reg_172_fifo.DATA_WIDTH = 1;
defparam rnode_171to172_bb2__26_i79_0_reg_172_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_171to172_bb2__26_i79_0_reg_172_fifo.IMPL = "shift_reg";

assign rnode_171to172_bb2__26_i79_0_reg_172_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_170to171_bb2__26_i79_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2__26_i79_0_NO_SHIFT_REG = rnode_171to172_bb2__26_i79_0_reg_172_NO_SHIFT_REG;
assign rnode_171to172_bb2__26_i79_0_stall_in_reg_172_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2__26_i79_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_and193_i_valid_out;
wire local_bb2_and193_i_stall_in;
wire local_bb2_and193_i_inputs_ready;
wire local_bb2_and193_i_stall_local;
wire [31:0] local_bb2_and193_i;

assign local_bb2_and193_i_inputs_ready = rnode_170to171_bb2_add192_i_0_valid_out_0_NO_SHIFT_REG;
assign local_bb2_and193_i = (rnode_170to171_bb2_add192_i_0_NO_SHIFT_REG & 32'hFFFFFFF);
assign local_bb2_and193_i_valid_out = 1'b1;
assign rnode_170to171_bb2_add192_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_and195_i_valid_out;
wire local_bb2_and195_i_stall_in;
wire local_bb2_and195_i_inputs_ready;
wire local_bb2_and195_i_stall_local;
wire [31:0] local_bb2_and195_i;

assign local_bb2_and195_i_inputs_ready = rnode_170to171_bb2_add192_i_0_valid_out_1_NO_SHIFT_REG;
assign local_bb2_and195_i = (rnode_170to171_bb2_add192_i_1_NO_SHIFT_REG >> 32'h1B);
assign local_bb2_and195_i_valid_out = 1'b1;
assign rnode_170to171_bb2_add192_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_and198_i_valid_out;
wire local_bb2_and198_i_stall_in;
wire local_bb2_and198_i_inputs_ready;
wire local_bb2_and198_i_stall_local;
wire [31:0] local_bb2_and198_i;

assign local_bb2_and198_i_inputs_ready = rnode_170to171_bb2_add192_i_0_valid_out_2_NO_SHIFT_REG;
assign local_bb2_and198_i = (rnode_170to171_bb2_add192_i_2_NO_SHIFT_REG & 32'h1);
assign local_bb2_and198_i_valid_out = 1'b1;
assign rnode_170to171_bb2_add192_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb2_and201_i_stall_local;
wire [31:0] local_bb2_and201_i;

assign local_bb2_and201_i = (rnode_170to171_bb2_add192_i_3_NO_SHIFT_REG & 32'h7FFFFFF);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_171to172_bb2_var__u17_0_valid_out_NO_SHIFT_REG;
 logic rnode_171to172_bb2_var__u17_0_stall_in_NO_SHIFT_REG;
 logic rnode_171to172_bb2_var__u17_0_NO_SHIFT_REG;
 logic rnode_171to172_bb2_var__u17_0_reg_172_inputs_ready_NO_SHIFT_REG;
 logic rnode_171to172_bb2_var__u17_0_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2_var__u17_0_valid_out_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2_var__u17_0_stall_in_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2_var__u17_0_stall_out_reg_172_NO_SHIFT_REG;

acl_data_fifo rnode_171to172_bb2_var__u17_0_reg_172_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_171to172_bb2_var__u17_0_reg_172_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_171to172_bb2_var__u17_0_stall_in_reg_172_NO_SHIFT_REG),
	.valid_out(rnode_171to172_bb2_var__u17_0_valid_out_reg_172_NO_SHIFT_REG),
	.stall_out(rnode_171to172_bb2_var__u17_0_stall_out_reg_172_NO_SHIFT_REG),
	.data_in(rnode_170to171_bb2_var__u17_0_NO_SHIFT_REG),
	.data_out(rnode_171to172_bb2_var__u17_0_reg_172_NO_SHIFT_REG)
);

defparam rnode_171to172_bb2_var__u17_0_reg_172_fifo.DEPTH = 1;
defparam rnode_171to172_bb2_var__u17_0_reg_172_fifo.DATA_WIDTH = 1;
defparam rnode_171to172_bb2_var__u17_0_reg_172_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_171to172_bb2_var__u17_0_reg_172_fifo.IMPL = "shift_reg";

assign rnode_171to172_bb2_var__u17_0_reg_172_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_170to171_bb2_var__u17_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2_var__u17_0_NO_SHIFT_REG = rnode_171to172_bb2_var__u17_0_reg_172_NO_SHIFT_REG;
assign rnode_171to172_bb2_var__u17_0_stall_in_reg_172_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2_var__u17_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_172to173_bb2__26_i79_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_172to173_bb2__26_i79_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_172to173_bb2__26_i79_0_NO_SHIFT_REG;
 logic rnode_172to173_bb2__26_i79_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_172to173_bb2__26_i79_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_172to173_bb2__26_i79_1_NO_SHIFT_REG;
 logic rnode_172to173_bb2__26_i79_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_172to173_bb2__26_i79_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_172to173_bb2__26_i79_2_NO_SHIFT_REG;
 logic rnode_172to173_bb2__26_i79_0_reg_173_inputs_ready_NO_SHIFT_REG;
 logic rnode_172to173_bb2__26_i79_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2__26_i79_0_valid_out_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2__26_i79_0_stall_in_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2__26_i79_0_stall_out_reg_173_NO_SHIFT_REG;

acl_data_fifo rnode_172to173_bb2__26_i79_0_reg_173_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_172to173_bb2__26_i79_0_reg_173_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_172to173_bb2__26_i79_0_stall_in_0_reg_173_NO_SHIFT_REG),
	.valid_out(rnode_172to173_bb2__26_i79_0_valid_out_0_reg_173_NO_SHIFT_REG),
	.stall_out(rnode_172to173_bb2__26_i79_0_stall_out_reg_173_NO_SHIFT_REG),
	.data_in(rnode_171to172_bb2__26_i79_0_NO_SHIFT_REG),
	.data_out(rnode_172to173_bb2__26_i79_0_reg_173_NO_SHIFT_REG)
);

defparam rnode_172to173_bb2__26_i79_0_reg_173_fifo.DEPTH = 1;
defparam rnode_172to173_bb2__26_i79_0_reg_173_fifo.DATA_WIDTH = 1;
defparam rnode_172to173_bb2__26_i79_0_reg_173_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_172to173_bb2__26_i79_0_reg_173_fifo.IMPL = "shift_reg";

assign rnode_172to173_bb2__26_i79_0_reg_173_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_171to172_bb2__26_i79_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2__26_i79_0_stall_in_0_reg_173_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2__26_i79_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_172to173_bb2__26_i79_0_NO_SHIFT_REG = rnode_172to173_bb2__26_i79_0_reg_173_NO_SHIFT_REG;
assign rnode_172to173_bb2__26_i79_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_172to173_bb2__26_i79_1_NO_SHIFT_REG = rnode_172to173_bb2__26_i79_0_reg_173_NO_SHIFT_REG;
assign rnode_172to173_bb2__26_i79_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_172to173_bb2__26_i79_2_NO_SHIFT_REG = rnode_172to173_bb2__26_i79_0_reg_173_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_171to172_bb2_and193_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and193_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_171to172_bb2_and193_i_0_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and193_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and193_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_171to172_bb2_and193_i_1_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and193_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and193_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_171to172_bb2_and193_i_2_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and193_i_0_reg_172_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_171to172_bb2_and193_i_0_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and193_i_0_valid_out_0_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and193_i_0_stall_in_0_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and193_i_0_stall_out_reg_172_NO_SHIFT_REG;

acl_data_fifo rnode_171to172_bb2_and193_i_0_reg_172_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_171to172_bb2_and193_i_0_reg_172_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_171to172_bb2_and193_i_0_stall_in_0_reg_172_NO_SHIFT_REG),
	.valid_out(rnode_171to172_bb2_and193_i_0_valid_out_0_reg_172_NO_SHIFT_REG),
	.stall_out(rnode_171to172_bb2_and193_i_0_stall_out_reg_172_NO_SHIFT_REG),
	.data_in(local_bb2_and193_i),
	.data_out(rnode_171to172_bb2_and193_i_0_reg_172_NO_SHIFT_REG)
);

defparam rnode_171to172_bb2_and193_i_0_reg_172_fifo.DEPTH = 1;
defparam rnode_171to172_bb2_and193_i_0_reg_172_fifo.DATA_WIDTH = 32;
defparam rnode_171to172_bb2_and193_i_0_reg_172_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_171to172_bb2_and193_i_0_reg_172_fifo.IMPL = "shift_reg";

assign rnode_171to172_bb2_and193_i_0_reg_172_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and193_i_stall_in = 1'b0;
assign rnode_171to172_bb2_and193_i_0_stall_in_0_reg_172_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2_and193_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_171to172_bb2_and193_i_0_NO_SHIFT_REG = rnode_171to172_bb2_and193_i_0_reg_172_NO_SHIFT_REG;
assign rnode_171to172_bb2_and193_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_171to172_bb2_and193_i_1_NO_SHIFT_REG = rnode_171to172_bb2_and193_i_0_reg_172_NO_SHIFT_REG;
assign rnode_171to172_bb2_and193_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_171to172_bb2_and193_i_2_NO_SHIFT_REG = rnode_171to172_bb2_and193_i_0_reg_172_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_171to172_bb2_and195_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and195_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_171to172_bb2_and195_i_0_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and195_i_0_reg_172_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_171to172_bb2_and195_i_0_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and195_i_0_valid_out_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and195_i_0_stall_in_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and195_i_0_stall_out_reg_172_NO_SHIFT_REG;

acl_data_fifo rnode_171to172_bb2_and195_i_0_reg_172_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_171to172_bb2_and195_i_0_reg_172_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_171to172_bb2_and195_i_0_stall_in_reg_172_NO_SHIFT_REG),
	.valid_out(rnode_171to172_bb2_and195_i_0_valid_out_reg_172_NO_SHIFT_REG),
	.stall_out(rnode_171to172_bb2_and195_i_0_stall_out_reg_172_NO_SHIFT_REG),
	.data_in(local_bb2_and195_i),
	.data_out(rnode_171to172_bb2_and195_i_0_reg_172_NO_SHIFT_REG)
);

defparam rnode_171to172_bb2_and195_i_0_reg_172_fifo.DEPTH = 1;
defparam rnode_171to172_bb2_and195_i_0_reg_172_fifo.DATA_WIDTH = 32;
defparam rnode_171to172_bb2_and195_i_0_reg_172_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_171to172_bb2_and195_i_0_reg_172_fifo.IMPL = "shift_reg";

assign rnode_171to172_bb2_and195_i_0_reg_172_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and195_i_stall_in = 1'b0;
assign rnode_171to172_bb2_and195_i_0_NO_SHIFT_REG = rnode_171to172_bb2_and195_i_0_reg_172_NO_SHIFT_REG;
assign rnode_171to172_bb2_and195_i_0_stall_in_reg_172_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2_and195_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_171to172_bb2_and198_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and198_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_171to172_bb2_and198_i_0_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and198_i_0_reg_172_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_171to172_bb2_and198_i_0_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and198_i_0_valid_out_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and198_i_0_stall_in_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2_and198_i_0_stall_out_reg_172_NO_SHIFT_REG;

acl_data_fifo rnode_171to172_bb2_and198_i_0_reg_172_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_171to172_bb2_and198_i_0_reg_172_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_171to172_bb2_and198_i_0_stall_in_reg_172_NO_SHIFT_REG),
	.valid_out(rnode_171to172_bb2_and198_i_0_valid_out_reg_172_NO_SHIFT_REG),
	.stall_out(rnode_171to172_bb2_and198_i_0_stall_out_reg_172_NO_SHIFT_REG),
	.data_in(local_bb2_and198_i),
	.data_out(rnode_171to172_bb2_and198_i_0_reg_172_NO_SHIFT_REG)
);

defparam rnode_171to172_bb2_and198_i_0_reg_172_fifo.DEPTH = 1;
defparam rnode_171to172_bb2_and198_i_0_reg_172_fifo.DATA_WIDTH = 32;
defparam rnode_171to172_bb2_and198_i_0_reg_172_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_171to172_bb2_and198_i_0_reg_172_fifo.IMPL = "shift_reg";

assign rnode_171to172_bb2_and198_i_0_reg_172_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and198_i_stall_in = 1'b0;
assign rnode_171to172_bb2_and198_i_0_NO_SHIFT_REG = rnode_171to172_bb2_and198_i_0_reg_172_NO_SHIFT_REG;
assign rnode_171to172_bb2_and198_i_0_stall_in_reg_172_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2_and198_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_shr_i_i106_stall_local;
wire [31:0] local_bb2_shr_i_i106;

assign local_bb2_shr_i_i106 = (local_bb2_and201_i >> 32'h1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_172to173_bb2_var__u17_0_valid_out_NO_SHIFT_REG;
 logic rnode_172to173_bb2_var__u17_0_stall_in_NO_SHIFT_REG;
 logic rnode_172to173_bb2_var__u17_0_NO_SHIFT_REG;
 logic rnode_172to173_bb2_var__u17_0_reg_173_inputs_ready_NO_SHIFT_REG;
 logic rnode_172to173_bb2_var__u17_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_var__u17_0_valid_out_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_var__u17_0_stall_in_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_var__u17_0_stall_out_reg_173_NO_SHIFT_REG;

acl_data_fifo rnode_172to173_bb2_var__u17_0_reg_173_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_172to173_bb2_var__u17_0_reg_173_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_172to173_bb2_var__u17_0_stall_in_reg_173_NO_SHIFT_REG),
	.valid_out(rnode_172to173_bb2_var__u17_0_valid_out_reg_173_NO_SHIFT_REG),
	.stall_out(rnode_172to173_bb2_var__u17_0_stall_out_reg_173_NO_SHIFT_REG),
	.data_in(rnode_171to172_bb2_var__u17_0_NO_SHIFT_REG),
	.data_out(rnode_172to173_bb2_var__u17_0_reg_173_NO_SHIFT_REG)
);

defparam rnode_172to173_bb2_var__u17_0_reg_173_fifo.DEPTH = 1;
defparam rnode_172to173_bb2_var__u17_0_reg_173_fifo.DATA_WIDTH = 1;
defparam rnode_172to173_bb2_var__u17_0_reg_173_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_172to173_bb2_var__u17_0_reg_173_fifo.IMPL = "shift_reg";

assign rnode_172to173_bb2_var__u17_0_reg_173_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_171to172_bb2_var__u17_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_var__u17_0_NO_SHIFT_REG = rnode_172to173_bb2_var__u17_0_reg_173_NO_SHIFT_REG;
assign rnode_172to173_bb2_var__u17_0_stall_in_reg_173_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_var__u17_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_cond292_i_stall_local;
wire [31:0] local_bb2_cond292_i;

assign local_bb2_cond292_i = (rnode_172to173_bb2__26_i79_1_NO_SHIFT_REG ? 32'h400000 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u22_stall_local;
wire [31:0] local_bb2_var__u22;

assign local_bb2_var__u22[31:1] = 31'h0;
assign local_bb2_var__u22[0] = rnode_172to173_bb2__26_i79_2_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_shr216_i_stall_local;
wire [31:0] local_bb2_shr216_i;

assign local_bb2_shr216_i = (rnode_171to172_bb2_and193_i_1_NO_SHIFT_REG >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2__pre_i120_stall_local;
wire [31:0] local_bb2__pre_i120;

assign local_bb2__pre_i120 = (rnode_171to172_bb2_and195_i_0_NO_SHIFT_REG & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_or_i_i107_stall_local;
wire [31:0] local_bb2_or_i_i107;

assign local_bb2_or_i_i107 = (local_bb2_shr_i_i106 | local_bb2_and201_i);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_ext_i137_stall_local;
wire [31:0] local_bb2_lnot_ext_i137;

assign local_bb2_lnot_ext_i137 = (local_bb2_var__u22 ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_or219_i_stall_local;
wire [31:0] local_bb2_or219_i;

assign local_bb2_or219_i = (local_bb2_shr216_i | rnode_171to172_bb2_and198_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_tobool213_i_stall_local;
wire local_bb2_tobool213_i;

assign local_bb2_tobool213_i = (local_bb2__pre_i120 == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_shr1_i_i108_stall_local;
wire [31:0] local_bb2_shr1_i_i108;

assign local_bb2_shr1_i_i108 = (local_bb2_or_i_i107 >> 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb2__40_demorgan_i121_stall_local;
wire local_bb2__40_demorgan_i121;

assign local_bb2__40_demorgan_i121 = (rnode_170to172_bb2_cmp37_i_0_NO_SHIFT_REG | local_bb2_tobool213_i);

// This section implements an unregistered operation.
// 
wire local_bb2__42_i122_stall_local;
wire local_bb2__42_i122;

assign local_bb2__42_i122 = (local_bb2_tobool213_i & local_bb2_not_cmp37_i);

// This section implements an unregistered operation.
// 
wire local_bb2_or2_i_i109_stall_local;
wire [31:0] local_bb2_or2_i_i109;

assign local_bb2_or2_i_i109 = (local_bb2_shr1_i_i108 | local_bb2_or_i_i107);

// This section implements an unregistered operation.
// 
wire local_bb2__43_i123_stall_local;
wire [31:0] local_bb2__43_i123;

assign local_bb2__43_i123 = (local_bb2__42_i122 ? 32'h0 : local_bb2__pre_i120);

// This section implements an unregistered operation.
// 
wire local_bb2_shr3_i_i110_stall_local;
wire [31:0] local_bb2_shr3_i_i110;

assign local_bb2_shr3_i_i110 = (local_bb2_or2_i_i109 >> 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb2_or4_i_i111_stall_local;
wire [31:0] local_bb2_or4_i_i111;

assign local_bb2_or4_i_i111 = (local_bb2_shr3_i_i110 | local_bb2_or2_i_i109);

// This section implements an unregistered operation.
// 
wire local_bb2_shr5_i_i112_stall_local;
wire [31:0] local_bb2_shr5_i_i112;

assign local_bb2_shr5_i_i112 = (local_bb2_or4_i_i111 >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb2_or6_i_i113_stall_local;
wire [31:0] local_bb2_or6_i_i113;

assign local_bb2_or6_i_i113 = (local_bb2_shr5_i_i112 | local_bb2_or4_i_i111);

// This section implements an unregistered operation.
// 
wire local_bb2_shr7_i_i114_stall_local;
wire [31:0] local_bb2_shr7_i_i114;

assign local_bb2_shr7_i_i114 = (local_bb2_or6_i_i113 >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb2_or6_masked_i_i115_stall_local;
wire [31:0] local_bb2_or6_masked_i_i115;

assign local_bb2_or6_masked_i_i115 = (local_bb2_or6_i_i113 & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_neg_i_i116_stall_local;
wire [31:0] local_bb2_neg_i_i116;

assign local_bb2_neg_i_i116 = (local_bb2_or6_masked_i_i115 | local_bb2_shr7_i_i114);

// This section implements an unregistered operation.
// 
wire local_bb2_and_i_i117_stall_local;
wire [31:0] local_bb2_and_i_i117;

assign local_bb2_and_i_i117 = (local_bb2_neg_i_i116 ^ 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2__and_i_i117_valid_out;
wire local_bb2__and_i_i117_stall_in;
wire local_bb2__and_i_i117_inputs_ready;
wire local_bb2__and_i_i117_stall_local;
wire [31:0] local_bb2__and_i_i117;

thirtysix_six_comp local_bb2__and_i_i117_popcnt_instance (
	.data(local_bb2_and_i_i117),
	.sum(local_bb2__and_i_i117)
);


assign local_bb2__and_i_i117_inputs_ready = rnode_170to171_bb2_add192_i_0_valid_out_3_NO_SHIFT_REG;
assign local_bb2__and_i_i117_valid_out = 1'b1;
assign rnode_170to171_bb2_add192_i_0_stall_in_3_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_171to172_bb2__and_i_i117_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_171to172_bb2__and_i_i117_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_171to172_bb2__and_i_i117_0_NO_SHIFT_REG;
 logic rnode_171to172_bb2__and_i_i117_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_171to172_bb2__and_i_i117_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_171to172_bb2__and_i_i117_1_NO_SHIFT_REG;
 logic rnode_171to172_bb2__and_i_i117_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_171to172_bb2__and_i_i117_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_171to172_bb2__and_i_i117_2_NO_SHIFT_REG;
 logic rnode_171to172_bb2__and_i_i117_0_reg_172_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_171to172_bb2__and_i_i117_0_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2__and_i_i117_0_valid_out_0_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2__and_i_i117_0_stall_in_0_reg_172_NO_SHIFT_REG;
 logic rnode_171to172_bb2__and_i_i117_0_stall_out_reg_172_NO_SHIFT_REG;

acl_data_fifo rnode_171to172_bb2__and_i_i117_0_reg_172_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_171to172_bb2__and_i_i117_0_reg_172_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_171to172_bb2__and_i_i117_0_stall_in_0_reg_172_NO_SHIFT_REG),
	.valid_out(rnode_171to172_bb2__and_i_i117_0_valid_out_0_reg_172_NO_SHIFT_REG),
	.stall_out(rnode_171to172_bb2__and_i_i117_0_stall_out_reg_172_NO_SHIFT_REG),
	.data_in(local_bb2__and_i_i117),
	.data_out(rnode_171to172_bb2__and_i_i117_0_reg_172_NO_SHIFT_REG)
);

defparam rnode_171to172_bb2__and_i_i117_0_reg_172_fifo.DEPTH = 1;
defparam rnode_171to172_bb2__and_i_i117_0_reg_172_fifo.DATA_WIDTH = 32;
defparam rnode_171to172_bb2__and_i_i117_0_reg_172_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_171to172_bb2__and_i_i117_0_reg_172_fifo.IMPL = "shift_reg";

assign rnode_171to172_bb2__and_i_i117_0_reg_172_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2__and_i_i117_stall_in = 1'b0;
assign rnode_171to172_bb2__and_i_i117_0_stall_in_0_reg_172_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2__and_i_i117_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_171to172_bb2__and_i_i117_0_NO_SHIFT_REG = rnode_171to172_bb2__and_i_i117_0_reg_172_NO_SHIFT_REG;
assign rnode_171to172_bb2__and_i_i117_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_171to172_bb2__and_i_i117_1_NO_SHIFT_REG = rnode_171to172_bb2__and_i_i117_0_reg_172_NO_SHIFT_REG;
assign rnode_171to172_bb2__and_i_i117_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_171to172_bb2__and_i_i117_2_NO_SHIFT_REG = rnode_171to172_bb2__and_i_i117_0_reg_172_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_and9_i_i118_stall_local;
wire [31:0] local_bb2_and9_i_i118;

assign local_bb2_and9_i_i118 = (rnode_171to172_bb2__and_i_i117_0_NO_SHIFT_REG & 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb2_and203_i_stall_local;
wire [31:0] local_bb2_and203_i;

assign local_bb2_and203_i = (rnode_171to172_bb2__and_i_i117_1_NO_SHIFT_REG & 32'h18);

// This section implements an unregistered operation.
// 
wire local_bb2_and206_i119_stall_local;
wire [31:0] local_bb2_and206_i119;

assign local_bb2_and206_i119 = (rnode_171to172_bb2__and_i_i117_2_NO_SHIFT_REG & 32'h7);

// This section implements an unregistered operation.
// 
wire local_bb2_sub239_i_stall_local;
wire [31:0] local_bb2_sub239_i;

assign local_bb2_sub239_i = (32'h0 - local_bb2_and9_i_i118);

// This section implements an unregistered operation.
// 
wire local_bb2_shl204_i_stall_local;
wire [31:0] local_bb2_shl204_i;

assign local_bb2_shl204_i = (rnode_171to172_bb2_and193_i_0_NO_SHIFT_REG << local_bb2_and203_i);

// This section implements an unregistered operation.
// 
wire local_bb2_cond244_i_stall_local;
wire [31:0] local_bb2_cond244_i;

assign local_bb2_cond244_i = (rnode_170to172_bb2_cmp37_i_2_NO_SHIFT_REG ? local_bb2_sub239_i : local_bb2__43_i123);

// This section implements an unregistered operation.
// 
wire local_bb2_and205_i_stall_local;
wire [31:0] local_bb2_and205_i;

assign local_bb2_and205_i = (local_bb2_shl204_i & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_add245_i_stall_local;
wire [31:0] local_bb2_add245_i;

assign local_bb2_add245_i = (local_bb2_cond244_i + rnode_170to172_bb2_and17_i56_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_fold_i128_stall_local;
wire [31:0] local_bb2_fold_i128;

assign local_bb2_fold_i128 = (local_bb2_cond244_i + rnode_170to172_bb2_shr16_i55_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_shl207_i_stall_local;
wire [31:0] local_bb2_shl207_i;

assign local_bb2_shl207_i = (local_bb2_and205_i << local_bb2_and206_i119);

// This section implements an unregistered operation.
// 
wire local_bb2_and250_i_stall_local;
wire [31:0] local_bb2_and250_i;

assign local_bb2_and250_i = (local_bb2_fold_i128 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and269_i_stall_local;
wire [31:0] local_bb2_and269_i;

assign local_bb2_and269_i = (local_bb2_fold_i128 << 32'h17);

// This section implements an unregistered operation.
// 
wire local_bb2_and208_i_stall_local;
wire [31:0] local_bb2_and208_i;

assign local_bb2_and208_i = (local_bb2_shl207_i & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_notrhs_i130_stall_local;
wire local_bb2_notrhs_i130;

assign local_bb2_notrhs_i130 = (local_bb2_and250_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2__44_i124_stall_local;
wire [31:0] local_bb2__44_i124;

assign local_bb2__44_i124 = (local_bb2__40_demorgan_i121 ? local_bb2_and208_i : local_bb2_or219_i);

// This section implements an unregistered operation.
// 
wire local_bb2__45_i125_stall_local;
wire [31:0] local_bb2__45_i125;

assign local_bb2__45_i125 = (local_bb2__42_i122 ? rnode_171to172_bb2_and193_i_2_NO_SHIFT_REG : local_bb2__44_i124);

// This section implements an unregistered operation.
// 
wire local_bb2_and225_i_stall_local;
wire [31:0] local_bb2_and225_i;

assign local_bb2_and225_i = (local_bb2__45_i125 & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_and270_i133_stall_local;
wire [31:0] local_bb2_and270_i133;

assign local_bb2_and270_i133 = (local_bb2__45_i125 & 32'h7);

// This section implements an unregistered operation.
// 
wire local_bb2_shr271_i_stall_local;
wire [31:0] local_bb2_shr271_i;

assign local_bb2_shr271_i = (local_bb2__45_i125 >> 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp226_i_stall_local;
wire local_bb2_cmp226_i;

assign local_bb2_cmp226_i = (local_bb2_and225_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp296_i_stall_local;
wire local_bb2_cmp296_i;

assign local_bb2_cmp296_i = (local_bb2_and270_i133 > 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb2_and269_i_valid_out;
wire local_bb2_and269_i_stall_in;
 reg local_bb2_and269_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_add245_i_valid_out;
wire local_bb2_add245_i_stall_in;
 reg local_bb2_add245_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_notrhs_i130_valid_out;
wire local_bb2_notrhs_i130_stall_in;
 reg local_bb2_notrhs_i130_consumed_0_NO_SHIFT_REG;
wire local_bb2_not_cmp37_i_valid_out_1;
wire local_bb2_not_cmp37_i_stall_in_1;
 reg local_bb2_not_cmp37_i_consumed_1_NO_SHIFT_REG;
wire local_bb2_shr271_i_valid_out;
wire local_bb2_shr271_i_stall_in;
 reg local_bb2_shr271_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp226_i_valid_out;
wire local_bb2_cmp226_i_stall_in;
 reg local_bb2_cmp226_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp296_i_valid_out;
wire local_bb2_cmp296_i_stall_in;
 reg local_bb2_cmp296_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp299_i_valid_out;
wire local_bb2_cmp299_i_stall_in;
 reg local_bb2_cmp299_i_consumed_0_NO_SHIFT_REG;
wire local_bb2_cmp299_i_inputs_ready;
wire local_bb2_cmp299_i_stall_local;
wire local_bb2_cmp299_i;

assign local_bb2_cmp299_i_inputs_ready = (rnode_170to172_bb2_shr16_i55_0_valid_out_NO_SHIFT_REG & rnode_170to172_bb2_cmp37_i_0_valid_out_2_NO_SHIFT_REG & rnode_170to172_bb2_and17_i56_0_valid_out_NO_SHIFT_REG & rnode_170to172_bb2_cmp37_i_0_valid_out_0_NO_SHIFT_REG & rnode_171to172_bb2_and193_i_0_valid_out_2_NO_SHIFT_REG & rnode_170to172_bb2_cmp37_i_0_valid_out_1_NO_SHIFT_REG & rnode_171to172_bb2_and195_i_0_valid_out_NO_SHIFT_REG & rnode_171to172_bb2_and193_i_0_valid_out_1_NO_SHIFT_REG & rnode_171to172_bb2_and198_i_0_valid_out_NO_SHIFT_REG & rnode_171to172_bb2_and193_i_0_valid_out_0_NO_SHIFT_REG & rnode_171to172_bb2__and_i_i117_0_valid_out_1_NO_SHIFT_REG & rnode_171to172_bb2__and_i_i117_0_valid_out_2_NO_SHIFT_REG & rnode_171to172_bb2__and_i_i117_0_valid_out_0_NO_SHIFT_REG);
assign local_bb2_cmp299_i = (local_bb2_and270_i133 == 32'h4);
assign local_bb2_and269_i_valid_out = 1'b1;
assign local_bb2_add245_i_valid_out = 1'b1;
assign local_bb2_notrhs_i130_valid_out = 1'b1;
assign local_bb2_not_cmp37_i_valid_out_1 = 1'b1;
assign local_bb2_shr271_i_valid_out = 1'b1;
assign local_bb2_cmp226_i_valid_out = 1'b1;
assign local_bb2_cmp296_i_valid_out = 1'b1;
assign local_bb2_cmp299_i_valid_out = 1'b1;
assign rnode_170to172_bb2_shr16_i55_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_170to172_bb2_cmp37_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_170to172_bb2_and17_i56_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_170to172_bb2_cmp37_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2_and193_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_170to172_bb2_cmp37_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2_and195_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2_and193_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2_and198_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2_and193_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2__and_i_i117_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2__and_i_i117_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_171to172_bb2__and_i_i117_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_and269_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_add245_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_notrhs_i130_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_not_cmp37_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb2_shr271_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp226_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp296_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_cmp299_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_and269_i_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i_inputs_ready & (local_bb2_and269_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_and269_i_stall_in)) & local_bb2_cmp299_i_stall_local);
		local_bb2_add245_i_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i_inputs_ready & (local_bb2_add245_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_add245_i_stall_in)) & local_bb2_cmp299_i_stall_local);
		local_bb2_notrhs_i130_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i_inputs_ready & (local_bb2_notrhs_i130_consumed_0_NO_SHIFT_REG | ~(local_bb2_notrhs_i130_stall_in)) & local_bb2_cmp299_i_stall_local);
		local_bb2_not_cmp37_i_consumed_1_NO_SHIFT_REG <= (local_bb2_cmp299_i_inputs_ready & (local_bb2_not_cmp37_i_consumed_1_NO_SHIFT_REG | ~(local_bb2_not_cmp37_i_stall_in_1)) & local_bb2_cmp299_i_stall_local);
		local_bb2_shr271_i_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i_inputs_ready & (local_bb2_shr271_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_shr271_i_stall_in)) & local_bb2_cmp299_i_stall_local);
		local_bb2_cmp226_i_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i_inputs_ready & (local_bb2_cmp226_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp226_i_stall_in)) & local_bb2_cmp299_i_stall_local);
		local_bb2_cmp296_i_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i_inputs_ready & (local_bb2_cmp296_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp296_i_stall_in)) & local_bb2_cmp299_i_stall_local);
		local_bb2_cmp299_i_consumed_0_NO_SHIFT_REG <= (local_bb2_cmp299_i_inputs_ready & (local_bb2_cmp299_i_consumed_0_NO_SHIFT_REG | ~(local_bb2_cmp299_i_stall_in)) & local_bb2_cmp299_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_172to173_bb2_and269_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_172to173_bb2_and269_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_172to173_bb2_and269_i_0_NO_SHIFT_REG;
 logic rnode_172to173_bb2_and269_i_0_reg_173_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_172to173_bb2_and269_i_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_and269_i_0_valid_out_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_and269_i_0_stall_in_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_and269_i_0_stall_out_reg_173_NO_SHIFT_REG;

acl_data_fifo rnode_172to173_bb2_and269_i_0_reg_173_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_172to173_bb2_and269_i_0_reg_173_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_172to173_bb2_and269_i_0_stall_in_reg_173_NO_SHIFT_REG),
	.valid_out(rnode_172to173_bb2_and269_i_0_valid_out_reg_173_NO_SHIFT_REG),
	.stall_out(rnode_172to173_bb2_and269_i_0_stall_out_reg_173_NO_SHIFT_REG),
	.data_in(local_bb2_and269_i),
	.data_out(rnode_172to173_bb2_and269_i_0_reg_173_NO_SHIFT_REG)
);

defparam rnode_172to173_bb2_and269_i_0_reg_173_fifo.DEPTH = 1;
defparam rnode_172to173_bb2_and269_i_0_reg_173_fifo.DATA_WIDTH = 32;
defparam rnode_172to173_bb2_and269_i_0_reg_173_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_172to173_bb2_and269_i_0_reg_173_fifo.IMPL = "shift_reg";

assign rnode_172to173_bb2_and269_i_0_reg_173_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_and269_i_stall_in = 1'b0;
assign rnode_172to173_bb2_and269_i_0_NO_SHIFT_REG = rnode_172to173_bb2_and269_i_0_reg_173_NO_SHIFT_REG;
assign rnode_172to173_bb2_and269_i_0_stall_in_reg_173_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_and269_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_172to173_bb2_add245_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_172to173_bb2_add245_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_172to173_bb2_add245_i_0_NO_SHIFT_REG;
 logic rnode_172to173_bb2_add245_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_172to173_bb2_add245_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_172to173_bb2_add245_i_1_NO_SHIFT_REG;
 logic rnode_172to173_bb2_add245_i_0_reg_173_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_172to173_bb2_add245_i_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_add245_i_0_valid_out_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_add245_i_0_stall_in_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_add245_i_0_stall_out_reg_173_NO_SHIFT_REG;

acl_data_fifo rnode_172to173_bb2_add245_i_0_reg_173_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_172to173_bb2_add245_i_0_reg_173_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_172to173_bb2_add245_i_0_stall_in_0_reg_173_NO_SHIFT_REG),
	.valid_out(rnode_172to173_bb2_add245_i_0_valid_out_0_reg_173_NO_SHIFT_REG),
	.stall_out(rnode_172to173_bb2_add245_i_0_stall_out_reg_173_NO_SHIFT_REG),
	.data_in(local_bb2_add245_i),
	.data_out(rnode_172to173_bb2_add245_i_0_reg_173_NO_SHIFT_REG)
);

defparam rnode_172to173_bb2_add245_i_0_reg_173_fifo.DEPTH = 1;
defparam rnode_172to173_bb2_add245_i_0_reg_173_fifo.DATA_WIDTH = 32;
defparam rnode_172to173_bb2_add245_i_0_reg_173_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_172to173_bb2_add245_i_0_reg_173_fifo.IMPL = "shift_reg";

assign rnode_172to173_bb2_add245_i_0_reg_173_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_add245_i_stall_in = 1'b0;
assign rnode_172to173_bb2_add245_i_0_stall_in_0_reg_173_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_add245_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_172to173_bb2_add245_i_0_NO_SHIFT_REG = rnode_172to173_bb2_add245_i_0_reg_173_NO_SHIFT_REG;
assign rnode_172to173_bb2_add245_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_172to173_bb2_add245_i_1_NO_SHIFT_REG = rnode_172to173_bb2_add245_i_0_reg_173_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_172to173_bb2_notrhs_i130_0_valid_out_NO_SHIFT_REG;
 logic rnode_172to173_bb2_notrhs_i130_0_stall_in_NO_SHIFT_REG;
 logic rnode_172to173_bb2_notrhs_i130_0_NO_SHIFT_REG;
 logic rnode_172to173_bb2_notrhs_i130_0_reg_173_inputs_ready_NO_SHIFT_REG;
 logic rnode_172to173_bb2_notrhs_i130_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_notrhs_i130_0_valid_out_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_notrhs_i130_0_stall_in_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_notrhs_i130_0_stall_out_reg_173_NO_SHIFT_REG;

acl_data_fifo rnode_172to173_bb2_notrhs_i130_0_reg_173_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_172to173_bb2_notrhs_i130_0_reg_173_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_172to173_bb2_notrhs_i130_0_stall_in_reg_173_NO_SHIFT_REG),
	.valid_out(rnode_172to173_bb2_notrhs_i130_0_valid_out_reg_173_NO_SHIFT_REG),
	.stall_out(rnode_172to173_bb2_notrhs_i130_0_stall_out_reg_173_NO_SHIFT_REG),
	.data_in(local_bb2_notrhs_i130),
	.data_out(rnode_172to173_bb2_notrhs_i130_0_reg_173_NO_SHIFT_REG)
);

defparam rnode_172to173_bb2_notrhs_i130_0_reg_173_fifo.DEPTH = 1;
defparam rnode_172to173_bb2_notrhs_i130_0_reg_173_fifo.DATA_WIDTH = 1;
defparam rnode_172to173_bb2_notrhs_i130_0_reg_173_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_172to173_bb2_notrhs_i130_0_reg_173_fifo.IMPL = "shift_reg";

assign rnode_172to173_bb2_notrhs_i130_0_reg_173_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_notrhs_i130_stall_in = 1'b0;
assign rnode_172to173_bb2_notrhs_i130_0_NO_SHIFT_REG = rnode_172to173_bb2_notrhs_i130_0_reg_173_NO_SHIFT_REG;
assign rnode_172to173_bb2_notrhs_i130_0_stall_in_reg_173_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_notrhs_i130_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_172to173_bb2_not_cmp37_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_172to173_bb2_not_cmp37_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_172to173_bb2_not_cmp37_i_0_NO_SHIFT_REG;
 logic rnode_172to173_bb2_not_cmp37_i_0_reg_173_inputs_ready_NO_SHIFT_REG;
 logic rnode_172to173_bb2_not_cmp37_i_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_not_cmp37_i_0_valid_out_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_not_cmp37_i_0_stall_in_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_not_cmp37_i_0_stall_out_reg_173_NO_SHIFT_REG;

acl_data_fifo rnode_172to173_bb2_not_cmp37_i_0_reg_173_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_172to173_bb2_not_cmp37_i_0_reg_173_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_172to173_bb2_not_cmp37_i_0_stall_in_reg_173_NO_SHIFT_REG),
	.valid_out(rnode_172to173_bb2_not_cmp37_i_0_valid_out_reg_173_NO_SHIFT_REG),
	.stall_out(rnode_172to173_bb2_not_cmp37_i_0_stall_out_reg_173_NO_SHIFT_REG),
	.data_in(local_bb2_not_cmp37_i),
	.data_out(rnode_172to173_bb2_not_cmp37_i_0_reg_173_NO_SHIFT_REG)
);

defparam rnode_172to173_bb2_not_cmp37_i_0_reg_173_fifo.DEPTH = 1;
defparam rnode_172to173_bb2_not_cmp37_i_0_reg_173_fifo.DATA_WIDTH = 1;
defparam rnode_172to173_bb2_not_cmp37_i_0_reg_173_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_172to173_bb2_not_cmp37_i_0_reg_173_fifo.IMPL = "shift_reg";

assign rnode_172to173_bb2_not_cmp37_i_0_reg_173_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_not_cmp37_i_stall_in_1 = 1'b0;
assign rnode_172to173_bb2_not_cmp37_i_0_NO_SHIFT_REG = rnode_172to173_bb2_not_cmp37_i_0_reg_173_NO_SHIFT_REG;
assign rnode_172to173_bb2_not_cmp37_i_0_stall_in_reg_173_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_not_cmp37_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_172to173_bb2_shr271_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_172to173_bb2_shr271_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_172to173_bb2_shr271_i_0_NO_SHIFT_REG;
 logic rnode_172to173_bb2_shr271_i_0_reg_173_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_172to173_bb2_shr271_i_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_shr271_i_0_valid_out_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_shr271_i_0_stall_in_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_shr271_i_0_stall_out_reg_173_NO_SHIFT_REG;

acl_data_fifo rnode_172to173_bb2_shr271_i_0_reg_173_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_172to173_bb2_shr271_i_0_reg_173_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_172to173_bb2_shr271_i_0_stall_in_reg_173_NO_SHIFT_REG),
	.valid_out(rnode_172to173_bb2_shr271_i_0_valid_out_reg_173_NO_SHIFT_REG),
	.stall_out(rnode_172to173_bb2_shr271_i_0_stall_out_reg_173_NO_SHIFT_REG),
	.data_in(local_bb2_shr271_i),
	.data_out(rnode_172to173_bb2_shr271_i_0_reg_173_NO_SHIFT_REG)
);

defparam rnode_172to173_bb2_shr271_i_0_reg_173_fifo.DEPTH = 1;
defparam rnode_172to173_bb2_shr271_i_0_reg_173_fifo.DATA_WIDTH = 32;
defparam rnode_172to173_bb2_shr271_i_0_reg_173_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_172to173_bb2_shr271_i_0_reg_173_fifo.IMPL = "shift_reg";

assign rnode_172to173_bb2_shr271_i_0_reg_173_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_shr271_i_stall_in = 1'b0;
assign rnode_172to173_bb2_shr271_i_0_NO_SHIFT_REG = rnode_172to173_bb2_shr271_i_0_reg_173_NO_SHIFT_REG;
assign rnode_172to173_bb2_shr271_i_0_stall_in_reg_173_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_shr271_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_172to173_bb2_cmp226_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp226_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp226_i_0_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp226_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp226_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp226_i_1_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp226_i_0_reg_173_inputs_ready_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp226_i_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp226_i_0_valid_out_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp226_i_0_stall_in_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp226_i_0_stall_out_reg_173_NO_SHIFT_REG;

acl_data_fifo rnode_172to173_bb2_cmp226_i_0_reg_173_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_172to173_bb2_cmp226_i_0_reg_173_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_172to173_bb2_cmp226_i_0_stall_in_0_reg_173_NO_SHIFT_REG),
	.valid_out(rnode_172to173_bb2_cmp226_i_0_valid_out_0_reg_173_NO_SHIFT_REG),
	.stall_out(rnode_172to173_bb2_cmp226_i_0_stall_out_reg_173_NO_SHIFT_REG),
	.data_in(local_bb2_cmp226_i),
	.data_out(rnode_172to173_bb2_cmp226_i_0_reg_173_NO_SHIFT_REG)
);

defparam rnode_172to173_bb2_cmp226_i_0_reg_173_fifo.DEPTH = 1;
defparam rnode_172to173_bb2_cmp226_i_0_reg_173_fifo.DATA_WIDTH = 1;
defparam rnode_172to173_bb2_cmp226_i_0_reg_173_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_172to173_bb2_cmp226_i_0_reg_173_fifo.IMPL = "shift_reg";

assign rnode_172to173_bb2_cmp226_i_0_reg_173_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp226_i_stall_in = 1'b0;
assign rnode_172to173_bb2_cmp226_i_0_stall_in_0_reg_173_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_cmp226_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_172to173_bb2_cmp226_i_0_NO_SHIFT_REG = rnode_172to173_bb2_cmp226_i_0_reg_173_NO_SHIFT_REG;
assign rnode_172to173_bb2_cmp226_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_172to173_bb2_cmp226_i_1_NO_SHIFT_REG = rnode_172to173_bb2_cmp226_i_0_reg_173_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_172to173_bb2_cmp296_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp296_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp296_i_0_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp296_i_0_reg_173_inputs_ready_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp296_i_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp296_i_0_valid_out_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp296_i_0_stall_in_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp296_i_0_stall_out_reg_173_NO_SHIFT_REG;

acl_data_fifo rnode_172to173_bb2_cmp296_i_0_reg_173_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_172to173_bb2_cmp296_i_0_reg_173_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_172to173_bb2_cmp296_i_0_stall_in_reg_173_NO_SHIFT_REG),
	.valid_out(rnode_172to173_bb2_cmp296_i_0_valid_out_reg_173_NO_SHIFT_REG),
	.stall_out(rnode_172to173_bb2_cmp296_i_0_stall_out_reg_173_NO_SHIFT_REG),
	.data_in(local_bb2_cmp296_i),
	.data_out(rnode_172to173_bb2_cmp296_i_0_reg_173_NO_SHIFT_REG)
);

defparam rnode_172to173_bb2_cmp296_i_0_reg_173_fifo.DEPTH = 1;
defparam rnode_172to173_bb2_cmp296_i_0_reg_173_fifo.DATA_WIDTH = 1;
defparam rnode_172to173_bb2_cmp296_i_0_reg_173_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_172to173_bb2_cmp296_i_0_reg_173_fifo.IMPL = "shift_reg";

assign rnode_172to173_bb2_cmp296_i_0_reg_173_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp296_i_stall_in = 1'b0;
assign rnode_172to173_bb2_cmp296_i_0_NO_SHIFT_REG = rnode_172to173_bb2_cmp296_i_0_reg_173_NO_SHIFT_REG;
assign rnode_172to173_bb2_cmp296_i_0_stall_in_reg_173_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_cmp296_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_172to173_bb2_cmp299_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp299_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp299_i_0_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp299_i_0_reg_173_inputs_ready_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp299_i_0_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp299_i_0_valid_out_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp299_i_0_stall_in_reg_173_NO_SHIFT_REG;
 logic rnode_172to173_bb2_cmp299_i_0_stall_out_reg_173_NO_SHIFT_REG;

acl_data_fifo rnode_172to173_bb2_cmp299_i_0_reg_173_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_172to173_bb2_cmp299_i_0_reg_173_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_172to173_bb2_cmp299_i_0_stall_in_reg_173_NO_SHIFT_REG),
	.valid_out(rnode_172to173_bb2_cmp299_i_0_valid_out_reg_173_NO_SHIFT_REG),
	.stall_out(rnode_172to173_bb2_cmp299_i_0_stall_out_reg_173_NO_SHIFT_REG),
	.data_in(local_bb2_cmp299_i),
	.data_out(rnode_172to173_bb2_cmp299_i_0_reg_173_NO_SHIFT_REG)
);

defparam rnode_172to173_bb2_cmp299_i_0_reg_173_fifo.DEPTH = 1;
defparam rnode_172to173_bb2_cmp299_i_0_reg_173_fifo.DATA_WIDTH = 1;
defparam rnode_172to173_bb2_cmp299_i_0_reg_173_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_172to173_bb2_cmp299_i_0_reg_173_fifo.IMPL = "shift_reg";

assign rnode_172to173_bb2_cmp299_i_0_reg_173_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_cmp299_i_stall_in = 1'b0;
assign rnode_172to173_bb2_cmp299_i_0_NO_SHIFT_REG = rnode_172to173_bb2_cmp299_i_0_reg_173_NO_SHIFT_REG;
assign rnode_172to173_bb2_cmp299_i_0_stall_in_reg_173_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_cmp299_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_shl273_i_stall_local;
wire [31:0] local_bb2_shl273_i;

assign local_bb2_shl273_i = (rnode_172to173_bb2_and269_i_0_NO_SHIFT_REG & 32'h7F800000);

// This section implements an unregistered operation.
// 
wire local_bb2_and247_i_stall_local;
wire [31:0] local_bb2_and247_i;

assign local_bb2_and247_i = (rnode_172to173_bb2_add245_i_0_NO_SHIFT_REG & 32'h100);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp258_i_stall_local;
wire local_bb2_cmp258_i;

assign local_bb2_cmp258_i = ($signed(rnode_172to173_bb2_add245_i_1_NO_SHIFT_REG) > $signed(32'hFE));

// This section implements an unregistered operation.
// 
wire local_bb2_and272_i_stall_local;
wire [31:0] local_bb2_and272_i;

assign local_bb2_and272_i = (rnode_172to173_bb2_shr271_i_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp226_not_i_stall_local;
wire local_bb2_cmp226_not_i;

assign local_bb2_cmp226_not_i = (rnode_172to173_bb2_cmp226_i_0_NO_SHIFT_REG ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb2_cmp29649_i_stall_local;
wire [31:0] local_bb2_cmp29649_i;

assign local_bb2_cmp29649_i[31:1] = 31'h0;
assign local_bb2_cmp29649_i[0] = rnode_172to173_bb2_cmp296_i_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_conv300_i_stall_local;
wire [31:0] local_bb2_conv300_i;

assign local_bb2_conv300_i[31:1] = 31'h0;
assign local_bb2_conv300_i[0] = rnode_172to173_bb2_cmp299_i_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb2_notlhs_i129_stall_local;
wire local_bb2_notlhs_i129;

assign local_bb2_notlhs_i129 = (local_bb2_and247_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or274_i_stall_local;
wire [31:0] local_bb2_or274_i;

assign local_bb2_or274_i = (local_bb2_and272_i | local_bb2_shl273_i);

// This section implements an unregistered operation.
// 
wire local_bb2_brmerge12_i126_stall_local;
wire local_bb2_brmerge12_i126;

assign local_bb2_brmerge12_i126 = (local_bb2_cmp226_not_i | rnode_172to173_bb2_not_cmp37_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot262__i_stall_local;
wire local_bb2_lnot262__i;

assign local_bb2_lnot262__i = (local_bb2_cmp258_i & local_bb2_cmp226_not_i);

// This section implements an unregistered operation.
// 
wire local_bb2_not__46_i131_stall_local;
wire local_bb2_not__46_i131;

assign local_bb2_not__46_i131 = (rnode_172to173_bb2_notrhs_i130_0_NO_SHIFT_REG | local_bb2_notlhs_i129);

// This section implements an unregistered operation.
// 
wire local_bb2_resultSign_0_i127_stall_local;
wire [31:0] local_bb2_resultSign_0_i127;

assign local_bb2_resultSign_0_i127 = (local_bb2_brmerge12_i126 ? rnode_172to173_bb2_and35_i65_0_NO_SHIFT_REG : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_or2662_i_stall_local;
wire local_bb2_or2662_i;

assign local_bb2_or2662_i = (rnode_172to173_bb2_var__u17_0_NO_SHIFT_REG | local_bb2_lnot262__i);

// This section implements an unregistered operation.
// 
wire local_bb2__47_i132_stall_local;
wire local_bb2__47_i132;

assign local_bb2__47_i132 = (rnode_172to173_bb2_cmp226_i_1_NO_SHIFT_REG | local_bb2_not__46_i131);

// This section implements an unregistered operation.
// 
wire local_bb2_or275_i134_stall_local;
wire [31:0] local_bb2_or275_i134;

assign local_bb2_or275_i134 = (local_bb2_or274_i | local_bb2_resultSign_0_i127);

// This section implements an unregistered operation.
// 
wire local_bb2_or2875_i_stall_local;
wire local_bb2_or2875_i;

assign local_bb2_or2875_i = (local_bb2_or2662_i | rnode_172to173_bb2__26_i79_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u23_stall_local;
wire [31:0] local_bb2_var__u23;

assign local_bb2_var__u23[31:1] = 31'h0;
assign local_bb2_var__u23[0] = local_bb2_or2662_i;

// This section implements an unregistered operation.
// 
wire local_bb2_or2804_i_stall_local;
wire local_bb2_or2804_i;

assign local_bb2_or2804_i = (local_bb2__47_i132 | local_bb2_or2662_i);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u24_stall_local;
wire [31:0] local_bb2_var__u24;

assign local_bb2_var__u24[31:1] = 31'h0;
assign local_bb2_var__u24[0] = local_bb2__47_i132;

// This section implements an unregistered operation.
// 
wire local_bb2_cond289_i_stall_local;
wire [31:0] local_bb2_cond289_i;

assign local_bb2_cond289_i = (local_bb2_or2875_i ? 32'h7F800000 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_ext310_i_stall_local;
wire [31:0] local_bb2_lnot_ext310_i;

assign local_bb2_lnot_ext310_i = (local_bb2_var__u23 ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_cond282_i_stall_local;
wire [31:0] local_bb2_cond282_i;

assign local_bb2_cond282_i = (local_bb2_or2804_i ? 32'h80000000 : 32'hFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb2_or294_i_stall_local;
wire [31:0] local_bb2_or294_i;

assign local_bb2_or294_i = (local_bb2_cond289_i | local_bb2_cond292_i);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_0_i138_stall_local;
wire [31:0] local_bb2_reduction_0_i138;

assign local_bb2_reduction_0_i138 = (local_bb2_lnot_ext310_i & local_bb2_lnot_ext_i137);

// This section implements an unregistered operation.
// 
wire local_bb2_and293_i_stall_local;
wire [31:0] local_bb2_and293_i;

assign local_bb2_and293_i = (local_bb2_cond282_i & local_bb2_or275_i134);

// This section implements an unregistered operation.
// 
wire local_bb2_or295_i135_stall_local;
wire [31:0] local_bb2_or295_i135;

assign local_bb2_or295_i135 = (local_bb2_or294_i | local_bb2_and293_i);

// This section implements an unregistered operation.
// 
wire local_bb2_and302_i_stall_local;
wire [31:0] local_bb2_and302_i;

assign local_bb2_and302_i = (local_bb2_conv300_i & local_bb2_and293_i);

// This section implements an unregistered operation.
// 
wire local_bb2_or295_i135_valid_out;
wire local_bb2_or295_i135_stall_in;
 reg local_bb2_or295_i135_consumed_0_NO_SHIFT_REG;
wire local_bb2_var__u24_valid_out;
wire local_bb2_var__u24_stall_in;
 reg local_bb2_var__u24_consumed_0_NO_SHIFT_REG;
wire local_bb2_lor_ext_i136_valid_out;
wire local_bb2_lor_ext_i136_stall_in;
 reg local_bb2_lor_ext_i136_consumed_0_NO_SHIFT_REG;
wire local_bb2_reduction_0_i138_valid_out;
wire local_bb2_reduction_0_i138_stall_in;
 reg local_bb2_reduction_0_i138_consumed_0_NO_SHIFT_REG;
wire local_bb2_lor_ext_i136_inputs_ready;
wire local_bb2_lor_ext_i136_stall_local;
wire [31:0] local_bb2_lor_ext_i136;

assign local_bb2_lor_ext_i136_inputs_ready = (rnode_172to173_bb2_and35_i65_0_valid_out_NO_SHIFT_REG & rnode_172to173_bb2_not_cmp37_i_0_valid_out_NO_SHIFT_REG & rnode_172to173_bb2_and269_i_0_valid_out_NO_SHIFT_REG & rnode_172to173_bb2_add245_i_0_valid_out_1_NO_SHIFT_REG & rnode_172to173_bb2_var__u17_0_valid_out_NO_SHIFT_REG & rnode_172to173_bb2__26_i79_0_valid_out_0_NO_SHIFT_REG & rnode_172to173_bb2__26_i79_0_valid_out_1_NO_SHIFT_REG & rnode_172to173_bb2_add245_i_0_valid_out_0_NO_SHIFT_REG & rnode_172to173_bb2_notrhs_i130_0_valid_out_NO_SHIFT_REG & rnode_172to173_bb2_cmp226_i_0_valid_out_1_NO_SHIFT_REG & rnode_172to173_bb2_shr271_i_0_valid_out_NO_SHIFT_REG & rnode_172to173_bb2__26_i79_0_valid_out_2_NO_SHIFT_REG & rnode_172to173_bb2_cmp226_i_0_valid_out_0_NO_SHIFT_REG & rnode_172to173_bb2_cmp296_i_0_valid_out_NO_SHIFT_REG & rnode_172to173_bb2_cmp299_i_0_valid_out_NO_SHIFT_REG);
assign local_bb2_lor_ext_i136 = (local_bb2_cmp29649_i | local_bb2_and302_i);
assign local_bb2_or295_i135_valid_out = 1'b1;
assign local_bb2_var__u24_valid_out = 1'b1;
assign local_bb2_lor_ext_i136_valid_out = 1'b1;
assign local_bb2_reduction_0_i138_valid_out = 1'b1;
assign rnode_172to173_bb2_and35_i65_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_not_cmp37_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_and269_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_add245_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_var__u17_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2__26_i79_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2__26_i79_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_add245_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_notrhs_i130_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_cmp226_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_shr271_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2__26_i79_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_cmp226_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_cmp296_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_172to173_bb2_cmp299_i_0_stall_in_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_or295_i135_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_var__u24_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_lor_ext_i136_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb2_reduction_0_i138_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb2_or295_i135_consumed_0_NO_SHIFT_REG <= (local_bb2_lor_ext_i136_inputs_ready & (local_bb2_or295_i135_consumed_0_NO_SHIFT_REG | ~(local_bb2_or295_i135_stall_in)) & local_bb2_lor_ext_i136_stall_local);
		local_bb2_var__u24_consumed_0_NO_SHIFT_REG <= (local_bb2_lor_ext_i136_inputs_ready & (local_bb2_var__u24_consumed_0_NO_SHIFT_REG | ~(local_bb2_var__u24_stall_in)) & local_bb2_lor_ext_i136_stall_local);
		local_bb2_lor_ext_i136_consumed_0_NO_SHIFT_REG <= (local_bb2_lor_ext_i136_inputs_ready & (local_bb2_lor_ext_i136_consumed_0_NO_SHIFT_REG | ~(local_bb2_lor_ext_i136_stall_in)) & local_bb2_lor_ext_i136_stall_local);
		local_bb2_reduction_0_i138_consumed_0_NO_SHIFT_REG <= (local_bb2_lor_ext_i136_inputs_ready & (local_bb2_reduction_0_i138_consumed_0_NO_SHIFT_REG | ~(local_bb2_reduction_0_i138_stall_in)) & local_bb2_lor_ext_i136_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_173to174_bb2_or295_i135_0_valid_out_NO_SHIFT_REG;
 logic rnode_173to174_bb2_or295_i135_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_173to174_bb2_or295_i135_0_NO_SHIFT_REG;
 logic rnode_173to174_bb2_or295_i135_0_reg_174_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_173to174_bb2_or295_i135_0_reg_174_NO_SHIFT_REG;
 logic rnode_173to174_bb2_or295_i135_0_valid_out_reg_174_NO_SHIFT_REG;
 logic rnode_173to174_bb2_or295_i135_0_stall_in_reg_174_NO_SHIFT_REG;
 logic rnode_173to174_bb2_or295_i135_0_stall_out_reg_174_NO_SHIFT_REG;

acl_data_fifo rnode_173to174_bb2_or295_i135_0_reg_174_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_173to174_bb2_or295_i135_0_reg_174_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_173to174_bb2_or295_i135_0_stall_in_reg_174_NO_SHIFT_REG),
	.valid_out(rnode_173to174_bb2_or295_i135_0_valid_out_reg_174_NO_SHIFT_REG),
	.stall_out(rnode_173to174_bb2_or295_i135_0_stall_out_reg_174_NO_SHIFT_REG),
	.data_in(local_bb2_or295_i135),
	.data_out(rnode_173to174_bb2_or295_i135_0_reg_174_NO_SHIFT_REG)
);

defparam rnode_173to174_bb2_or295_i135_0_reg_174_fifo.DEPTH = 1;
defparam rnode_173to174_bb2_or295_i135_0_reg_174_fifo.DATA_WIDTH = 32;
defparam rnode_173to174_bb2_or295_i135_0_reg_174_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_173to174_bb2_or295_i135_0_reg_174_fifo.IMPL = "shift_reg";

assign rnode_173to174_bb2_or295_i135_0_reg_174_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_or295_i135_stall_in = 1'b0;
assign rnode_173to174_bb2_or295_i135_0_NO_SHIFT_REG = rnode_173to174_bb2_or295_i135_0_reg_174_NO_SHIFT_REG;
assign rnode_173to174_bb2_or295_i135_0_stall_in_reg_174_NO_SHIFT_REG = 1'b0;
assign rnode_173to174_bb2_or295_i135_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_173to174_bb2_var__u24_0_valid_out_NO_SHIFT_REG;
 logic rnode_173to174_bb2_var__u24_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_173to174_bb2_var__u24_0_NO_SHIFT_REG;
 logic rnode_173to174_bb2_var__u24_0_reg_174_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_173to174_bb2_var__u24_0_reg_174_NO_SHIFT_REG;
 logic rnode_173to174_bb2_var__u24_0_valid_out_reg_174_NO_SHIFT_REG;
 logic rnode_173to174_bb2_var__u24_0_stall_in_reg_174_NO_SHIFT_REG;
 logic rnode_173to174_bb2_var__u24_0_stall_out_reg_174_NO_SHIFT_REG;

acl_data_fifo rnode_173to174_bb2_var__u24_0_reg_174_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_173to174_bb2_var__u24_0_reg_174_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_173to174_bb2_var__u24_0_stall_in_reg_174_NO_SHIFT_REG),
	.valid_out(rnode_173to174_bb2_var__u24_0_valid_out_reg_174_NO_SHIFT_REG),
	.stall_out(rnode_173to174_bb2_var__u24_0_stall_out_reg_174_NO_SHIFT_REG),
	.data_in(local_bb2_var__u24),
	.data_out(rnode_173to174_bb2_var__u24_0_reg_174_NO_SHIFT_REG)
);

defparam rnode_173to174_bb2_var__u24_0_reg_174_fifo.DEPTH = 1;
defparam rnode_173to174_bb2_var__u24_0_reg_174_fifo.DATA_WIDTH = 32;
defparam rnode_173to174_bb2_var__u24_0_reg_174_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_173to174_bb2_var__u24_0_reg_174_fifo.IMPL = "shift_reg";

assign rnode_173to174_bb2_var__u24_0_reg_174_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_var__u24_stall_in = 1'b0;
assign rnode_173to174_bb2_var__u24_0_NO_SHIFT_REG = rnode_173to174_bb2_var__u24_0_reg_174_NO_SHIFT_REG;
assign rnode_173to174_bb2_var__u24_0_stall_in_reg_174_NO_SHIFT_REG = 1'b0;
assign rnode_173to174_bb2_var__u24_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_173to174_bb2_lor_ext_i136_0_valid_out_NO_SHIFT_REG;
 logic rnode_173to174_bb2_lor_ext_i136_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_173to174_bb2_lor_ext_i136_0_NO_SHIFT_REG;
 logic rnode_173to174_bb2_lor_ext_i136_0_reg_174_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_173to174_bb2_lor_ext_i136_0_reg_174_NO_SHIFT_REG;
 logic rnode_173to174_bb2_lor_ext_i136_0_valid_out_reg_174_NO_SHIFT_REG;
 logic rnode_173to174_bb2_lor_ext_i136_0_stall_in_reg_174_NO_SHIFT_REG;
 logic rnode_173to174_bb2_lor_ext_i136_0_stall_out_reg_174_NO_SHIFT_REG;

acl_data_fifo rnode_173to174_bb2_lor_ext_i136_0_reg_174_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_173to174_bb2_lor_ext_i136_0_reg_174_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_173to174_bb2_lor_ext_i136_0_stall_in_reg_174_NO_SHIFT_REG),
	.valid_out(rnode_173to174_bb2_lor_ext_i136_0_valid_out_reg_174_NO_SHIFT_REG),
	.stall_out(rnode_173to174_bb2_lor_ext_i136_0_stall_out_reg_174_NO_SHIFT_REG),
	.data_in(local_bb2_lor_ext_i136),
	.data_out(rnode_173to174_bb2_lor_ext_i136_0_reg_174_NO_SHIFT_REG)
);

defparam rnode_173to174_bb2_lor_ext_i136_0_reg_174_fifo.DEPTH = 1;
defparam rnode_173to174_bb2_lor_ext_i136_0_reg_174_fifo.DATA_WIDTH = 32;
defparam rnode_173to174_bb2_lor_ext_i136_0_reg_174_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_173to174_bb2_lor_ext_i136_0_reg_174_fifo.IMPL = "shift_reg";

assign rnode_173to174_bb2_lor_ext_i136_0_reg_174_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_lor_ext_i136_stall_in = 1'b0;
assign rnode_173to174_bb2_lor_ext_i136_0_NO_SHIFT_REG = rnode_173to174_bb2_lor_ext_i136_0_reg_174_NO_SHIFT_REG;
assign rnode_173to174_bb2_lor_ext_i136_0_stall_in_reg_174_NO_SHIFT_REG = 1'b0;
assign rnode_173to174_bb2_lor_ext_i136_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_173to174_bb2_reduction_0_i138_0_valid_out_NO_SHIFT_REG;
 logic rnode_173to174_bb2_reduction_0_i138_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_173to174_bb2_reduction_0_i138_0_NO_SHIFT_REG;
 logic rnode_173to174_bb2_reduction_0_i138_0_reg_174_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_173to174_bb2_reduction_0_i138_0_reg_174_NO_SHIFT_REG;
 logic rnode_173to174_bb2_reduction_0_i138_0_valid_out_reg_174_NO_SHIFT_REG;
 logic rnode_173to174_bb2_reduction_0_i138_0_stall_in_reg_174_NO_SHIFT_REG;
 logic rnode_173to174_bb2_reduction_0_i138_0_stall_out_reg_174_NO_SHIFT_REG;

acl_data_fifo rnode_173to174_bb2_reduction_0_i138_0_reg_174_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_173to174_bb2_reduction_0_i138_0_reg_174_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_173to174_bb2_reduction_0_i138_0_stall_in_reg_174_NO_SHIFT_REG),
	.valid_out(rnode_173to174_bb2_reduction_0_i138_0_valid_out_reg_174_NO_SHIFT_REG),
	.stall_out(rnode_173to174_bb2_reduction_0_i138_0_stall_out_reg_174_NO_SHIFT_REG),
	.data_in(local_bb2_reduction_0_i138),
	.data_out(rnode_173to174_bb2_reduction_0_i138_0_reg_174_NO_SHIFT_REG)
);

defparam rnode_173to174_bb2_reduction_0_i138_0_reg_174_fifo.DEPTH = 1;
defparam rnode_173to174_bb2_reduction_0_i138_0_reg_174_fifo.DATA_WIDTH = 32;
defparam rnode_173to174_bb2_reduction_0_i138_0_reg_174_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_173to174_bb2_reduction_0_i138_0_reg_174_fifo.IMPL = "shift_reg";

assign rnode_173to174_bb2_reduction_0_i138_0_reg_174_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb2_reduction_0_i138_stall_in = 1'b0;
assign rnode_173to174_bb2_reduction_0_i138_0_NO_SHIFT_REG = rnode_173to174_bb2_reduction_0_i138_0_reg_174_NO_SHIFT_REG;
assign rnode_173to174_bb2_reduction_0_i138_0_stall_in_reg_174_NO_SHIFT_REG = 1'b0;
assign rnode_173to174_bb2_reduction_0_i138_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb2_lnot_ext314_i_stall_local;
wire [31:0] local_bb2_lnot_ext314_i;

assign local_bb2_lnot_ext314_i = (rnode_173to174_bb2_var__u24_0_NO_SHIFT_REG ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_1_i139_stall_local;
wire [31:0] local_bb2_reduction_1_i139;

assign local_bb2_reduction_1_i139 = (local_bb2_lnot_ext314_i & rnode_173to174_bb2_lor_ext_i136_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_reduction_2_i140_stall_local;
wire [31:0] local_bb2_reduction_2_i140;

assign local_bb2_reduction_2_i140 = (rnode_173to174_bb2_reduction_0_i138_0_NO_SHIFT_REG & local_bb2_reduction_1_i139);

// This section implements an unregistered operation.
// 
wire local_bb2_add320_i_stall_local;
wire [31:0] local_bb2_add320_i;

assign local_bb2_add320_i = (local_bb2_reduction_2_i140 + rnode_173to174_bb2_or295_i135_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb2_var__u25_stall_local;
wire [31:0] local_bb2_var__u25;

assign local_bb2_var__u25 = local_bb2_add320_i;

// This section implements an unregistered operation.
// 
wire local_bb2_c0_exi1_valid_out;
wire local_bb2_c0_exi1_stall_in;
wire local_bb2_c0_exi1_inputs_ready;
wire local_bb2_c0_exi1_stall_local;
wire [63:0] local_bb2_c0_exi1;

assign local_bb2_c0_exi1_inputs_ready = (rnode_173to174_bb2_or295_i135_0_valid_out_NO_SHIFT_REG & rnode_173to174_bb2_reduction_0_i138_0_valid_out_NO_SHIFT_REG & rnode_173to174_bb2_var__u24_0_valid_out_NO_SHIFT_REG & rnode_173to174_bb2_lor_ext_i136_0_valid_out_NO_SHIFT_REG);
assign local_bb2_c0_exi1[31:0] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
assign local_bb2_c0_exi1[63:32] = local_bb2_var__u25;
assign local_bb2_c0_exi1_valid_out = 1'b1;
assign rnode_173to174_bb2_or295_i135_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_173to174_bb2_reduction_0_i138_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_173to174_bb2_var__u24_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_173to174_bb2_lor_ext_i136_0_stall_in_NO_SHIFT_REG = 1'b0;

// This section implements a registered operation.
// 
wire local_bb2_c0_exit_c0_exi1_inputs_ready;
 reg local_bb2_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG;
wire local_bb2_c0_exit_c0_exi1_stall_in;
 reg [63:0] local_bb2_c0_exit_c0_exi1_NO_SHIFT_REG;
wire [63:0] local_bb2_c0_exit_c0_exi1_in;
wire local_bb2_c0_exit_c0_exi1_valid;
wire local_bb2_c0_exit_c0_exi1_causedstall;

acl_stall_free_sink local_bb2_c0_exit_c0_exi1_instance (
	.clock(clock),
	.resetn(resetn),
	.data_in(local_bb2_c0_exi1),
	.data_out(local_bb2_c0_exit_c0_exi1_in),
	.input_accepted(local_bb2_c0_enter_c0_eni3_input_accepted),
	.valid_out(local_bb2_c0_exit_c0_exi1_valid),
	.stall_in(~(local_bb2_c0_exit_c0_exi1_output_regs_ready)),
	.stall_entry(local_bb2_c0_exit_c0_exi1_entry_stall),
	.valids(local_bb2_c0_exit_c0_exi1_valid_bits),
	.IIphases(local_bb2_c0_exit_c0_exi1_phases),
	.inc_pipelined_thread(local_bb2_c0_enter_c0_eni3_inc_pipelined_thread),
	.dec_pipelined_thread(local_bb2_c0_enter_c0_eni3_dec_pipelined_thread)
);

defparam local_bb2_c0_exit_c0_exi1_instance.DATA_WIDTH = 64;
defparam local_bb2_c0_exit_c0_exi1_instance.PIPELINE_DEPTH = 17;
defparam local_bb2_c0_exit_c0_exi1_instance.SHARINGII = 1;
defparam local_bb2_c0_exit_c0_exi1_instance.SCHEDULEII = 1;

assign local_bb2_c0_exit_c0_exi1_inputs_ready = 1'b1;
assign local_bb2_c0_exit_c0_exi1_output_regs_ready = (&(~(local_bb2_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG) | ~(local_bb2_c0_exit_c0_exi1_stall_in)));
assign local_bb2_c0_exi1_stall_in = 1'b0;
assign local_bb2_c0_exit_c0_exi1_causedstall = (1'b1 && (1'b0 && !(~(local_bb2_c0_exit_c0_exi1_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb2_c0_exit_c0_exi1_NO_SHIFT_REG <= 'x;
		local_bb2_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb2_c0_exit_c0_exi1_output_regs_ready)
		begin
			local_bb2_c0_exit_c0_exi1_NO_SHIFT_REG <= local_bb2_c0_exit_c0_exi1_in;
			local_bb2_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG <= local_bb2_c0_exit_c0_exi1_valid;
		end
		else
		begin
			if (~(local_bb2_c0_exit_c0_exi1_stall_in))
			begin
				local_bb2_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb2_c0_exe1_valid_out;
wire local_bb2_c0_exe1_stall_in;
wire local_bb2_c0_exe1_inputs_ready;
wire local_bb2_c0_exe1_stall_local;
wire [31:0] local_bb2_c0_exe1;

assign local_bb2_c0_exe1_inputs_ready = local_bb2_c0_exit_c0_exi1_valid_out_NO_SHIFT_REG;
assign local_bb2_c0_exe1 = local_bb2_c0_exit_c0_exi1_NO_SHIFT_REG[63:32];
assign local_bb2_c0_exe1_valid_out = local_bb2_c0_exe1_inputs_ready;
assign local_bb2_c0_exe1_stall_local = local_bb2_c0_exe1_stall_in;
assign local_bb2_c0_exit_c0_exi1_stall_in = (|local_bb2_c0_exe1_stall_local);

// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
 reg branch_node_valid_out_0_NO_SHIFT_REG;
 reg branch_compare_result_NO_SHIFT_REG;
wire branch_var__output_regs_ready;
wire combined_branch_stall_in_signal;
 reg [31:0] lvb_var__0_reg_NO_SHIFT_REG;
 reg [31:0] lvb_add_0_reg_NO_SHIFT_REG;
 reg [63:0] lvb_bb2_indvars_iv_next_0_reg_NO_SHIFT_REG;
 reg [31:0] lvb_bb2_c0_exe1_0_reg_NO_SHIFT_REG;
 reg [31:0] lvb_input_global_id_0_0_reg_NO_SHIFT_REG;
 reg [31:0] lvb_input_acl_hw_wg_id_0_reg_NO_SHIFT_REG;

assign branch_var__inputs_ready = (local_bb2_c0_exe1_valid_out & local_bb2_cmp15_GUARD_valid_out & rnode_178to179_add_0_valid_out_NO_SHIFT_REG & rnode_178to179_bb2_indvars_iv_next_0_valid_out_NO_SHIFT_REG & rnode_178to179_var__0_valid_out_NO_SHIFT_REG & rnode_178to179_input_global_id_0_0_valid_out_NO_SHIFT_REG & rnode_178to179_input_acl_hw_wg_id_0_valid_out_NO_SHIFT_REG);
assign branch_var__output_regs_ready = (~(branch_node_valid_out_0_NO_SHIFT_REG) | (((branch_compare_result_NO_SHIFT_REG != 1'b1) & ~(stall_in_1)) | (~((branch_compare_result_NO_SHIFT_REG != 1'b1)) & ~(stall_in_0))));
assign local_bb2_c0_exe1_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign local_bb2_cmp15_GUARD_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign rnode_178to179_add_0_stall_in_NO_SHIFT_REG = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign rnode_178to179_bb2_indvars_iv_next_0_stall_in_NO_SHIFT_REG = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign rnode_178to179_var__0_stall_in_NO_SHIFT_REG = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign rnode_178to179_input_global_id_0_0_stall_in_NO_SHIFT_REG = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign rnode_178to179_input_acl_hw_wg_id_0_stall_in_NO_SHIFT_REG = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign lvb_var__0 = lvb_var__0_reg_NO_SHIFT_REG;
assign lvb_var__1 = lvb_var__0_reg_NO_SHIFT_REG;
assign lvb_add_0 = lvb_add_0_reg_NO_SHIFT_REG;
assign lvb_add_1 = lvb_add_0_reg_NO_SHIFT_REG;
assign lvb_bb2_indvars_iv_next_0 = lvb_bb2_indvars_iv_next_0_reg_NO_SHIFT_REG;
assign lvb_bb2_indvars_iv_next_1 = lvb_bb2_indvars_iv_next_0_reg_NO_SHIFT_REG;
assign lvb_bb2_c0_exe1_0 = lvb_bb2_c0_exe1_0_reg_NO_SHIFT_REG;
assign lvb_bb2_c0_exe1_1 = lvb_bb2_c0_exe1_0_reg_NO_SHIFT_REG;
assign lvb_input_global_id_0_0 = lvb_input_global_id_0_0_reg_NO_SHIFT_REG;
assign lvb_input_global_id_0_1 = lvb_input_global_id_0_0_reg_NO_SHIFT_REG;
assign lvb_input_acl_hw_wg_id_0 = lvb_input_acl_hw_wg_id_0_reg_NO_SHIFT_REG;
assign lvb_input_acl_hw_wg_id_1 = lvb_input_acl_hw_wg_id_0_reg_NO_SHIFT_REG;
assign valid_out_0 = (~((branch_compare_result_NO_SHIFT_REG != 1'b1)) & branch_node_valid_out_0_NO_SHIFT_REG);
assign valid_out_1 = ((branch_compare_result_NO_SHIFT_REG != 1'b1) & branch_node_valid_out_0_NO_SHIFT_REG);
assign combined_branch_stall_in_signal = ((((branch_compare_result_NO_SHIFT_REG != 1'b1) & branch_node_valid_out_0_NO_SHIFT_REG) & stall_in_1) | ((~((branch_compare_result_NO_SHIFT_REG != 1'b1)) & branch_node_valid_out_0_NO_SHIFT_REG) & stall_in_0));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		branch_node_valid_out_0_NO_SHIFT_REG <= 1'b0;
		lvb_var__0_reg_NO_SHIFT_REG <= 'x;
		lvb_add_0_reg_NO_SHIFT_REG <= 'x;
		lvb_bb2_indvars_iv_next_0_reg_NO_SHIFT_REG <= 'x;
		lvb_bb2_c0_exe1_0_reg_NO_SHIFT_REG <= 'x;
		lvb_input_global_id_0_0_reg_NO_SHIFT_REG <= 'x;
		lvb_input_acl_hw_wg_id_0_reg_NO_SHIFT_REG <= 'x;
		branch_compare_result_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (branch_var__output_regs_ready)
		begin
			branch_node_valid_out_0_NO_SHIFT_REG <= branch_var__inputs_ready;
			lvb_var__0_reg_NO_SHIFT_REG <= rnode_178to179_var__0_NO_SHIFT_REG;
			lvb_add_0_reg_NO_SHIFT_REG <= rnode_178to179_add_0_NO_SHIFT_REG;
			lvb_bb2_indvars_iv_next_0_reg_NO_SHIFT_REG <= rnode_178to179_bb2_indvars_iv_next_0_NO_SHIFT_REG;
			lvb_bb2_c0_exe1_0_reg_NO_SHIFT_REG <= local_bb2_c0_exe1;
			lvb_input_global_id_0_0_reg_NO_SHIFT_REG <= rnode_178to179_input_global_id_0_0_NO_SHIFT_REG;
			lvb_input_acl_hw_wg_id_0_reg_NO_SHIFT_REG <= rnode_178to179_input_acl_hw_wg_id_0_NO_SHIFT_REG;
			branch_compare_result_NO_SHIFT_REG <= local_bb2_cmp15_GUARD;
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

module fpgasort_basic_block_3
	(
		input 		clock,
		input 		resetn,
		input [31:0] 		input_N,
		input [63:0] 		input_output,
		input [63:0] 		input_p,
		input [63:0] 		input_error,
		input 		input_wii_cmp1,
		input 		valid_in,
		output 		stall_out,
		input [31:0] 		input_c0_exe1,
		input [31:0] 		input_global_id_0,
		input [31:0] 		input_acl_hw_wg_id,
		output 		valid_out,
		input 		stall_in,
		output [31:0] 		lvb_input_acl_hw_wg_id,
		input [31:0] 		workgroup_size,
		input 		start,
		input [255:0] 		avm_local_bb3_st_c0_exe16_readdata,
		input 		avm_local_bb3_st_c0_exe16_readdatavalid,
		input 		avm_local_bb3_st_c0_exe16_waitrequest,
		output [29:0] 		avm_local_bb3_st_c0_exe16_address,
		output 		avm_local_bb3_st_c0_exe16_read,
		output 		avm_local_bb3_st_c0_exe16_write,
		input 		avm_local_bb3_st_c0_exe16_writeack,
		output [255:0] 		avm_local_bb3_st_c0_exe16_writedata,
		output [31:0] 		avm_local_bb3_st_c0_exe16_byteenable,
		output [4:0] 		avm_local_bb3_st_c0_exe16_burstcount,
		output 		local_bb3_st_c0_exe16_active,
		input 		clock2x,
		input [255:0] 		avm_local_bb3_ld__readdata,
		input 		avm_local_bb3_ld__readdatavalid,
		input 		avm_local_bb3_ld__waitrequest,
		output [29:0] 		avm_local_bb3_ld__address,
		output 		avm_local_bb3_ld__read,
		output 		avm_local_bb3_ld__write,
		input 		avm_local_bb3_ld__writeack,
		output [255:0] 		avm_local_bb3_ld__writedata,
		output [31:0] 		avm_local_bb3_ld__byteenable,
		output [4:0] 		avm_local_bb3_ld__burstcount,
		output 		local_bb3_ld__active,
		input [255:0] 		avm_local_bb3_st_c1_exe1_readdata,
		input 		avm_local_bb3_st_c1_exe1_readdatavalid,
		input 		avm_local_bb3_st_c1_exe1_waitrequest,
		output [29:0] 		avm_local_bb3_st_c1_exe1_address,
		output 		avm_local_bb3_st_c1_exe1_read,
		output 		avm_local_bb3_st_c1_exe1_write,
		input 		avm_local_bb3_st_c1_exe1_writeack,
		output [255:0] 		avm_local_bb3_st_c1_exe1_writedata,
		output [31:0] 		avm_local_bb3_st_c1_exe1_byteenable,
		output [4:0] 		avm_local_bb3_st_c1_exe1_burstcount,
		output 		local_bb3_st_c1_exe1_active
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
 reg [31:0] input_c0_exe1_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_global_id_0_staging_reg_NO_SHIFT_REG;
 reg [31:0] input_acl_hw_wg_id_staging_reg_NO_SHIFT_REG;
 reg [31:0] local_lvm_c0_exe1_NO_SHIFT_REG;
 reg [31:0] local_lvm_input_global_id_0_NO_SHIFT_REG;
 reg [31:0] local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG;
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
		input_c0_exe1_staging_reg_NO_SHIFT_REG <= 'x;
		input_global_id_0_staging_reg_NO_SHIFT_REG <= 'x;
		input_acl_hw_wg_id_staging_reg_NO_SHIFT_REG <= 'x;
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
				input_acl_hw_wg_id_staging_reg_NO_SHIFT_REG <= input_acl_hw_wg_id;
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
					local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG <= input_acl_hw_wg_id_staging_reg_NO_SHIFT_REG;
				end
				else
				begin
					local_lvm_c0_exe1_NO_SHIFT_REG <= input_c0_exe1;
					local_lvm_input_global_id_0_NO_SHIFT_REG <= input_global_id_0;
					local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG <= input_acl_hw_wg_id;
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


// This section implements an unregistered operation.
// 
wire local_bb3_c0_eni11_valid_out;
wire local_bb3_c0_eni11_stall_in;
wire local_bb3_c0_eni11_inputs_ready;
wire local_bb3_c0_eni11_stall_local;
wire [63:0] local_bb3_c0_eni11;

assign local_bb3_c0_eni11_inputs_ready = merge_node_valid_out_0_NO_SHIFT_REG;
assign local_bb3_c0_eni11[31:0] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
assign local_bb3_c0_eni11[63:32] = local_lvm_c0_exe1_NO_SHIFT_REG;
assign local_bb3_c0_eni11_valid_out = local_bb3_c0_eni11_inputs_ready;
assign local_bb3_c0_eni11_stall_local = local_bb3_c0_eni11_stall_in;
assign merge_node_stall_in_0 = (|local_bb3_c0_eni11_stall_local);

// Register node:
//  * latency = 43
//  * capacity = 43
 logic rnode_1to44_input_global_id_0_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to44_input_global_id_0_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_1to44_input_global_id_0_0_NO_SHIFT_REG;
 logic rnode_1to44_input_global_id_0_0_reg_44_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_1to44_input_global_id_0_0_reg_44_NO_SHIFT_REG;
 logic rnode_1to44_input_global_id_0_0_valid_out_reg_44_NO_SHIFT_REG;
 logic rnode_1to44_input_global_id_0_0_stall_in_reg_44_NO_SHIFT_REG;
 logic rnode_1to44_input_global_id_0_0_stall_out_reg_44_NO_SHIFT_REG;

acl_data_fifo rnode_1to44_input_global_id_0_0_reg_44_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to44_input_global_id_0_0_reg_44_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to44_input_global_id_0_0_stall_in_reg_44_NO_SHIFT_REG),
	.valid_out(rnode_1to44_input_global_id_0_0_valid_out_reg_44_NO_SHIFT_REG),
	.stall_out(rnode_1to44_input_global_id_0_0_stall_out_reg_44_NO_SHIFT_REG),
	.data_in(local_lvm_input_global_id_0_NO_SHIFT_REG),
	.data_out(rnode_1to44_input_global_id_0_0_reg_44_NO_SHIFT_REG)
);

defparam rnode_1to44_input_global_id_0_0_reg_44_fifo.DEPTH = 44;
defparam rnode_1to44_input_global_id_0_0_reg_44_fifo.DATA_WIDTH = 32;
defparam rnode_1to44_input_global_id_0_0_reg_44_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to44_input_global_id_0_0_reg_44_fifo.IMPL = "ram";

assign rnode_1to44_input_global_id_0_0_reg_44_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_1_NO_SHIFT_REG;
assign merge_node_stall_in_1 = rnode_1to44_input_global_id_0_0_stall_out_reg_44_NO_SHIFT_REG;
assign rnode_1to44_input_global_id_0_0_NO_SHIFT_REG = rnode_1to44_input_global_id_0_0_reg_44_NO_SHIFT_REG;
assign rnode_1to44_input_global_id_0_0_stall_in_reg_44_NO_SHIFT_REG = rnode_1to44_input_global_id_0_0_stall_in_NO_SHIFT_REG;
assign rnode_1to44_input_global_id_0_0_valid_out_NO_SHIFT_REG = rnode_1to44_input_global_id_0_0_valid_out_reg_44_NO_SHIFT_REG;

// Register node:
//  * latency = 379
//  * capacity = 379
 logic rnode_1to380_input_acl_hw_wg_id_0_valid_out_NO_SHIFT_REG;
 logic rnode_1to380_input_acl_hw_wg_id_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_1to380_input_acl_hw_wg_id_0_NO_SHIFT_REG;
 logic rnode_1to380_input_acl_hw_wg_id_0_reg_380_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_1to380_input_acl_hw_wg_id_0_reg_380_NO_SHIFT_REG;
 logic rnode_1to380_input_acl_hw_wg_id_0_valid_out_reg_380_NO_SHIFT_REG;
 logic rnode_1to380_input_acl_hw_wg_id_0_stall_in_reg_380_NO_SHIFT_REG;
 logic rnode_1to380_input_acl_hw_wg_id_0_stall_out_reg_380_NO_SHIFT_REG;

acl_data_fifo rnode_1to380_input_acl_hw_wg_id_0_reg_380_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to380_input_acl_hw_wg_id_0_reg_380_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_1to380_input_acl_hw_wg_id_0_stall_in_reg_380_NO_SHIFT_REG),
	.valid_out(rnode_1to380_input_acl_hw_wg_id_0_valid_out_reg_380_NO_SHIFT_REG),
	.stall_out(rnode_1to380_input_acl_hw_wg_id_0_stall_out_reg_380_NO_SHIFT_REG),
	.data_in(local_lvm_input_acl_hw_wg_id_NO_SHIFT_REG),
	.data_out(rnode_1to380_input_acl_hw_wg_id_0_reg_380_NO_SHIFT_REG)
);

defparam rnode_1to380_input_acl_hw_wg_id_0_reg_380_fifo.DEPTH = 380;
defparam rnode_1to380_input_acl_hw_wg_id_0_reg_380_fifo.DATA_WIDTH = 32;
defparam rnode_1to380_input_acl_hw_wg_id_0_reg_380_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to380_input_acl_hw_wg_id_0_reg_380_fifo.IMPL = "ram";

assign rnode_1to380_input_acl_hw_wg_id_0_reg_380_inputs_ready_NO_SHIFT_REG = merge_node_valid_out_2_NO_SHIFT_REG;
assign merge_node_stall_in_2 = rnode_1to380_input_acl_hw_wg_id_0_stall_out_reg_380_NO_SHIFT_REG;
assign rnode_1to380_input_acl_hw_wg_id_0_NO_SHIFT_REG = rnode_1to380_input_acl_hw_wg_id_0_reg_380_NO_SHIFT_REG;
assign rnode_1to380_input_acl_hw_wg_id_0_stall_in_reg_380_NO_SHIFT_REG = rnode_1to380_input_acl_hw_wg_id_0_stall_in_NO_SHIFT_REG;
assign rnode_1to380_input_acl_hw_wg_id_0_valid_out_NO_SHIFT_REG = rnode_1to380_input_acl_hw_wg_id_0_valid_out_reg_380_NO_SHIFT_REG;

// This section implements a registered operation.
// 
wire local_bb3_c0_enter2_c0_eni11_inputs_ready;
 reg local_bb3_c0_enter2_c0_eni11_valid_out_NO_SHIFT_REG;
wire local_bb3_c0_enter2_c0_eni11_stall_in;
wire local_bb3_c0_enter2_c0_eni11_output_regs_ready;
 reg [63:0] local_bb3_c0_enter2_c0_eni11_NO_SHIFT_REG;
wire local_bb3_c0_enter2_c0_eni11_input_accepted;
wire local_bb3_c0_exit5_c0_exi14_entry_stall;
wire local_bb3_c0_exit5_c0_exi14_output_regs_ready;
wire [39:0] local_bb3_c0_exit5_c0_exi14_valid_bits;
wire local_bb3_c0_exit5_c0_exi14_phases;
wire local_bb3_c0_enter2_c0_eni11_inc_pipelined_thread;
wire local_bb3_c0_enter2_c0_eni11_dec_pipelined_thread;
wire local_bb3_c0_enter2_c0_eni11_causedstall;

assign local_bb3_c0_enter2_c0_eni11_inputs_ready = local_bb3_c0_eni11_valid_out;
assign local_bb3_c0_enter2_c0_eni11_output_regs_ready = 1'b1;
assign local_bb3_c0_enter2_c0_eni11_input_accepted = (local_bb3_c0_enter2_c0_eni11_inputs_ready && !(local_bb3_c0_exit5_c0_exi14_entry_stall));
assign local_bb3_c0_enter2_c0_eni11_inc_pipelined_thread = 1'b1;
assign local_bb3_c0_enter2_c0_eni11_dec_pipelined_thread = ~(1'b0);
assign local_bb3_c0_eni11_stall_in = ((~(local_bb3_c0_enter2_c0_eni11_inputs_ready) | local_bb3_c0_exit5_c0_exi14_entry_stall) | ~(1'b1));
assign local_bb3_c0_enter2_c0_eni11_causedstall = (1'b1 && ((~(local_bb3_c0_enter2_c0_eni11_inputs_ready) | local_bb3_c0_exit5_c0_exi14_entry_stall) && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_c0_enter2_c0_eni11_NO_SHIFT_REG <= 'x;
		local_bb3_c0_enter2_c0_eni11_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_c0_enter2_c0_eni11_output_regs_ready)
		begin
			local_bb3_c0_enter2_c0_eni11_NO_SHIFT_REG <= local_bb3_c0_eni11;
			local_bb3_c0_enter2_c0_eni11_valid_out_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb3_c0_enter2_c0_eni11_stall_in))
			begin
				local_bb3_c0_enter2_c0_eni11_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_44to45_input_global_id_0_0_valid_out_NO_SHIFT_REG;
 logic rnode_44to45_input_global_id_0_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_44to45_input_global_id_0_0_NO_SHIFT_REG;
 logic rnode_44to45_input_global_id_0_0_reg_45_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_44to45_input_global_id_0_0_reg_45_NO_SHIFT_REG;
 logic rnode_44to45_input_global_id_0_0_valid_out_reg_45_NO_SHIFT_REG;
 logic rnode_44to45_input_global_id_0_0_stall_in_reg_45_NO_SHIFT_REG;
 logic rnode_44to45_input_global_id_0_0_stall_out_reg_45_NO_SHIFT_REG;

acl_data_fifo rnode_44to45_input_global_id_0_0_reg_45_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_44to45_input_global_id_0_0_reg_45_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_44to45_input_global_id_0_0_stall_in_reg_45_NO_SHIFT_REG),
	.valid_out(rnode_44to45_input_global_id_0_0_valid_out_reg_45_NO_SHIFT_REG),
	.stall_out(rnode_44to45_input_global_id_0_0_stall_out_reg_45_NO_SHIFT_REG),
	.data_in(rnode_1to44_input_global_id_0_0_NO_SHIFT_REG),
	.data_out(rnode_44to45_input_global_id_0_0_reg_45_NO_SHIFT_REG)
);

defparam rnode_44to45_input_global_id_0_0_reg_45_fifo.DEPTH = 2;
defparam rnode_44to45_input_global_id_0_0_reg_45_fifo.DATA_WIDTH = 32;
defparam rnode_44to45_input_global_id_0_0_reg_45_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_44to45_input_global_id_0_0_reg_45_fifo.IMPL = "ll_reg";

assign rnode_44to45_input_global_id_0_0_reg_45_inputs_ready_NO_SHIFT_REG = rnode_1to44_input_global_id_0_0_valid_out_NO_SHIFT_REG;
assign rnode_1to44_input_global_id_0_0_stall_in_NO_SHIFT_REG = rnode_44to45_input_global_id_0_0_stall_out_reg_45_NO_SHIFT_REG;
assign rnode_44to45_input_global_id_0_0_NO_SHIFT_REG = rnode_44to45_input_global_id_0_0_reg_45_NO_SHIFT_REG;
assign rnode_44to45_input_global_id_0_0_stall_in_reg_45_NO_SHIFT_REG = rnode_44to45_input_global_id_0_0_stall_in_NO_SHIFT_REG;
assign rnode_44to45_input_global_id_0_0_valid_out_NO_SHIFT_REG = rnode_44to45_input_global_id_0_0_valid_out_reg_45_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_380to381_input_acl_hw_wg_id_0_valid_out_NO_SHIFT_REG;
 logic rnode_380to381_input_acl_hw_wg_id_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_380to381_input_acl_hw_wg_id_0_NO_SHIFT_REG;
 logic rnode_380to381_input_acl_hw_wg_id_0_reg_381_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_380to381_input_acl_hw_wg_id_0_reg_381_NO_SHIFT_REG;
 logic rnode_380to381_input_acl_hw_wg_id_0_valid_out_reg_381_NO_SHIFT_REG;
 logic rnode_380to381_input_acl_hw_wg_id_0_stall_in_reg_381_NO_SHIFT_REG;
 logic rnode_380to381_input_acl_hw_wg_id_0_stall_out_reg_381_NO_SHIFT_REG;

acl_data_fifo rnode_380to381_input_acl_hw_wg_id_0_reg_381_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_380to381_input_acl_hw_wg_id_0_reg_381_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_380to381_input_acl_hw_wg_id_0_stall_in_reg_381_NO_SHIFT_REG),
	.valid_out(rnode_380to381_input_acl_hw_wg_id_0_valid_out_reg_381_NO_SHIFT_REG),
	.stall_out(rnode_380to381_input_acl_hw_wg_id_0_stall_out_reg_381_NO_SHIFT_REG),
	.data_in(rnode_1to380_input_acl_hw_wg_id_0_NO_SHIFT_REG),
	.data_out(rnode_380to381_input_acl_hw_wg_id_0_reg_381_NO_SHIFT_REG)
);

defparam rnode_380to381_input_acl_hw_wg_id_0_reg_381_fifo.DEPTH = 2;
defparam rnode_380to381_input_acl_hw_wg_id_0_reg_381_fifo.DATA_WIDTH = 32;
defparam rnode_380to381_input_acl_hw_wg_id_0_reg_381_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_380to381_input_acl_hw_wg_id_0_reg_381_fifo.IMPL = "ll_reg";

assign rnode_380to381_input_acl_hw_wg_id_0_reg_381_inputs_ready_NO_SHIFT_REG = rnode_1to380_input_acl_hw_wg_id_0_valid_out_NO_SHIFT_REG;
assign rnode_1to380_input_acl_hw_wg_id_0_stall_in_NO_SHIFT_REG = rnode_380to381_input_acl_hw_wg_id_0_stall_out_reg_381_NO_SHIFT_REG;
assign rnode_380to381_input_acl_hw_wg_id_0_NO_SHIFT_REG = rnode_380to381_input_acl_hw_wg_id_0_reg_381_NO_SHIFT_REG;
assign rnode_380to381_input_acl_hw_wg_id_0_stall_in_reg_381_NO_SHIFT_REG = rnode_380to381_input_acl_hw_wg_id_0_stall_in_NO_SHIFT_REG;
assign rnode_380to381_input_acl_hw_wg_id_0_valid_out_NO_SHIFT_REG = rnode_380to381_input_acl_hw_wg_id_0_valid_out_reg_381_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_c0_ene13_stall_local;
wire [31:0] local_bb3_c0_ene13;

assign local_bb3_c0_ene13 = local_bb3_c0_enter2_c0_eni11_NO_SHIFT_REG[63:32];

// This section implements an unregistered operation.
// 
wire local_bb3_idxprom13_stall_local;
wire [63:0] local_bb3_idxprom13;

assign local_bb3_idxprom13[32] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[33] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[34] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[35] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[36] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[37] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[38] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[39] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[40] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[41] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[42] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[43] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[44] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[45] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[46] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[47] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[48] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[49] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[50] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[51] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[52] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[53] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[54] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[55] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[56] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[57] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[58] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[59] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[60] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[61] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[62] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[63] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG[31];
assign local_bb3_idxprom13[31:0] = rnode_44to45_input_global_id_0_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_tobool_i_stall_local;
wire local_bb3_tobool_i;

assign local_bb3_tobool_i = ($signed(input_N) < $signed(32'h0));

// This section implements an unregistered operation.
// 
wire local_bb3_sub_i141_stall_local;
wire [31:0] local_bb3_sub_i141;

assign local_bb3_sub_i141 = (32'h0 - input_N);

// This section implements an unregistered operation.
// 
wire local_bb3_idxprom13_valid_out_1;
wire local_bb3_idxprom13_stall_in_1;
 reg local_bb3_idxprom13_consumed_1_NO_SHIFT_REG;
wire local_bb3_arrayidx14_valid_out;
wire local_bb3_arrayidx14_stall_in;
 reg local_bb3_arrayidx14_consumed_0_NO_SHIFT_REG;
wire local_bb3_arrayidx14_inputs_ready;
wire local_bb3_arrayidx14_stall_local;
wire [63:0] local_bb3_arrayidx14;

assign local_bb3_arrayidx14_inputs_ready = rnode_44to45_input_global_id_0_0_valid_out_NO_SHIFT_REG;
assign local_bb3_arrayidx14 = (input_output + (local_bb3_idxprom13 << 6'h2));
assign local_bb3_arrayidx14_stall_local = ((local_bb3_idxprom13_stall_in_1 & ~(local_bb3_idxprom13_consumed_1_NO_SHIFT_REG)) | (local_bb3_arrayidx14_stall_in & ~(local_bb3_arrayidx14_consumed_0_NO_SHIFT_REG)));
assign local_bb3_idxprom13_valid_out_1 = (local_bb3_arrayidx14_inputs_ready & ~(local_bb3_idxprom13_consumed_1_NO_SHIFT_REG));
assign local_bb3_arrayidx14_valid_out = (local_bb3_arrayidx14_inputs_ready & ~(local_bb3_arrayidx14_consumed_0_NO_SHIFT_REG));
assign rnode_44to45_input_global_id_0_0_stall_in_NO_SHIFT_REG = (|local_bb3_arrayidx14_stall_local);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_idxprom13_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb3_arrayidx14_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3_idxprom13_consumed_1_NO_SHIFT_REG <= (local_bb3_arrayidx14_inputs_ready & (local_bb3_idxprom13_consumed_1_NO_SHIFT_REG | ~(local_bb3_idxprom13_stall_in_1)) & local_bb3_arrayidx14_stall_local);
		local_bb3_arrayidx14_consumed_0_NO_SHIFT_REG <= (local_bb3_arrayidx14_inputs_ready & (local_bb3_arrayidx14_consumed_0_NO_SHIFT_REG | ~(local_bb3_arrayidx14_stall_in)) & local_bb3_arrayidx14_stall_local);
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3_cond3_i_stall_local;
wire [31:0] local_bb3_cond3_i;

assign local_bb3_cond3_i = (local_bb3_tobool_i ? local_bb3_sub_i141 : input_N);

// Register node:
//  * latency = 159
//  * capacity = 159
 logic rnode_45to204_bb3_idxprom13_0_valid_out_NO_SHIFT_REG;
 logic rnode_45to204_bb3_idxprom13_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_45to204_bb3_idxprom13_0_NO_SHIFT_REG;
 logic rnode_45to204_bb3_idxprom13_0_reg_204_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_45to204_bb3_idxprom13_0_reg_204_NO_SHIFT_REG;
 logic rnode_45to204_bb3_idxprom13_0_valid_out_reg_204_NO_SHIFT_REG;
 logic rnode_45to204_bb3_idxprom13_0_stall_in_reg_204_NO_SHIFT_REG;
 logic rnode_45to204_bb3_idxprom13_0_stall_out_reg_204_NO_SHIFT_REG;

acl_data_fifo rnode_45to204_bb3_idxprom13_0_reg_204_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_45to204_bb3_idxprom13_0_reg_204_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_45to204_bb3_idxprom13_0_stall_in_reg_204_NO_SHIFT_REG),
	.valid_out(rnode_45to204_bb3_idxprom13_0_valid_out_reg_204_NO_SHIFT_REG),
	.stall_out(rnode_45to204_bb3_idxprom13_0_stall_out_reg_204_NO_SHIFT_REG),
	.data_in(local_bb3_idxprom13),
	.data_out(rnode_45to204_bb3_idxprom13_0_reg_204_NO_SHIFT_REG)
);

defparam rnode_45to204_bb3_idxprom13_0_reg_204_fifo.DEPTH = 160;
defparam rnode_45to204_bb3_idxprom13_0_reg_204_fifo.DATA_WIDTH = 64;
defparam rnode_45to204_bb3_idxprom13_0_reg_204_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_45to204_bb3_idxprom13_0_reg_204_fifo.IMPL = "ram";

assign rnode_45to204_bb3_idxprom13_0_reg_204_inputs_ready_NO_SHIFT_REG = local_bb3_idxprom13_valid_out_1;
assign local_bb3_idxprom13_stall_in_1 = rnode_45to204_bb3_idxprom13_0_stall_out_reg_204_NO_SHIFT_REG;
assign rnode_45to204_bb3_idxprom13_0_NO_SHIFT_REG = rnode_45to204_bb3_idxprom13_0_reg_204_NO_SHIFT_REG;
assign rnode_45to204_bb3_idxprom13_0_stall_in_reg_204_NO_SHIFT_REG = rnode_45to204_bb3_idxprom13_0_stall_in_NO_SHIFT_REG;
assign rnode_45to204_bb3_idxprom13_0_valid_out_NO_SHIFT_REG = rnode_45to204_bb3_idxprom13_0_valid_out_reg_204_NO_SHIFT_REG;

// This section implements a staging register.
// 
wire rstag_45to45_bb3_arrayidx14_valid_out;
wire rstag_45to45_bb3_arrayidx14_stall_in;
wire rstag_45to45_bb3_arrayidx14_inputs_ready;
wire rstag_45to45_bb3_arrayidx14_stall_local;
 reg rstag_45to45_bb3_arrayidx14_staging_valid_NO_SHIFT_REG;
wire rstag_45to45_bb3_arrayidx14_combined_valid;
 reg [63:0] rstag_45to45_bb3_arrayidx14_staging_reg_NO_SHIFT_REG;
wire [63:0] rstag_45to45_bb3_arrayidx14;

assign rstag_45to45_bb3_arrayidx14_inputs_ready = local_bb3_arrayidx14_valid_out;
assign rstag_45to45_bb3_arrayidx14 = (rstag_45to45_bb3_arrayidx14_staging_valid_NO_SHIFT_REG ? rstag_45to45_bb3_arrayidx14_staging_reg_NO_SHIFT_REG : local_bb3_arrayidx14);
assign rstag_45to45_bb3_arrayidx14_combined_valid = (rstag_45to45_bb3_arrayidx14_staging_valid_NO_SHIFT_REG | rstag_45to45_bb3_arrayidx14_inputs_ready);
assign rstag_45to45_bb3_arrayidx14_valid_out = rstag_45to45_bb3_arrayidx14_combined_valid;
assign rstag_45to45_bb3_arrayidx14_stall_local = rstag_45to45_bb3_arrayidx14_stall_in;
assign local_bb3_arrayidx14_stall_in = (|rstag_45to45_bb3_arrayidx14_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_45to45_bb3_arrayidx14_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_45to45_bb3_arrayidx14_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_45to45_bb3_arrayidx14_stall_local)
		begin
			if (~(rstag_45to45_bb3_arrayidx14_staging_valid_NO_SHIFT_REG))
			begin
				rstag_45to45_bb3_arrayidx14_staging_valid_NO_SHIFT_REG <= rstag_45to45_bb3_arrayidx14_inputs_ready;
			end
		end
		else
		begin
			rstag_45to45_bb3_arrayidx14_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_45to45_bb3_arrayidx14_staging_valid_NO_SHIFT_REG))
		begin
			rstag_45to45_bb3_arrayidx14_staging_reg_NO_SHIFT_REG <= local_bb3_arrayidx14;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3_shr_i_i142_stall_local;
wire [31:0] local_bb3_shr_i_i142;

assign local_bb3_shr_i_i142 = (local_bb3_cond3_i >> 32'h1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_204to205_bb3_idxprom13_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_204to205_bb3_idxprom13_0_stall_in_0_NO_SHIFT_REG;
 logic [63:0] rnode_204to205_bb3_idxprom13_0_NO_SHIFT_REG;
 logic rnode_204to205_bb3_idxprom13_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_204to205_bb3_idxprom13_0_stall_in_1_NO_SHIFT_REG;
 logic [63:0] rnode_204to205_bb3_idxprom13_1_NO_SHIFT_REG;
 logic rnode_204to205_bb3_idxprom13_0_reg_205_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_204to205_bb3_idxprom13_0_reg_205_NO_SHIFT_REG;
 logic rnode_204to205_bb3_idxprom13_0_valid_out_0_reg_205_NO_SHIFT_REG;
 logic rnode_204to205_bb3_idxprom13_0_stall_in_0_reg_205_NO_SHIFT_REG;
 logic rnode_204to205_bb3_idxprom13_0_stall_out_reg_205_NO_SHIFT_REG;
 logic [63:0] rnode_204to205_bb3_idxprom13_0_reg_205_NO_SHIFT_REG_fa;

acl_multi_fanout_adaptor rnode_204to205_bb3_idxprom13_0_reg_205_fanout_adaptor (
	.clock(clock),
	.resetn(resetn),
	.data_in(rnode_204to205_bb3_idxprom13_0_reg_205_NO_SHIFT_REG),
	.valid_in(rnode_204to205_bb3_idxprom13_0_valid_out_0_reg_205_NO_SHIFT_REG),
	.stall_out(rnode_204to205_bb3_idxprom13_0_stall_in_0_reg_205_NO_SHIFT_REG),
	.data_out(rnode_204to205_bb3_idxprom13_0_reg_205_NO_SHIFT_REG_fa),
	.valid_out({rnode_204to205_bb3_idxprom13_0_valid_out_0_NO_SHIFT_REG, rnode_204to205_bb3_idxprom13_0_valid_out_1_NO_SHIFT_REG}),
	.stall_in({rnode_204to205_bb3_idxprom13_0_stall_in_0_NO_SHIFT_REG, rnode_204to205_bb3_idxprom13_0_stall_in_1_NO_SHIFT_REG})
);

defparam rnode_204to205_bb3_idxprom13_0_reg_205_fanout_adaptor.DATA_WIDTH = 64;
defparam rnode_204to205_bb3_idxprom13_0_reg_205_fanout_adaptor.NUM_FANOUTS = 2;

acl_data_fifo rnode_204to205_bb3_idxprom13_0_reg_205_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_204to205_bb3_idxprom13_0_reg_205_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_204to205_bb3_idxprom13_0_stall_in_0_reg_205_NO_SHIFT_REG),
	.valid_out(rnode_204to205_bb3_idxprom13_0_valid_out_0_reg_205_NO_SHIFT_REG),
	.stall_out(rnode_204to205_bb3_idxprom13_0_stall_out_reg_205_NO_SHIFT_REG),
	.data_in(rnode_45to204_bb3_idxprom13_0_NO_SHIFT_REG),
	.data_out(rnode_204to205_bb3_idxprom13_0_reg_205_NO_SHIFT_REG)
);

defparam rnode_204to205_bb3_idxprom13_0_reg_205_fifo.DEPTH = 2;
defparam rnode_204to205_bb3_idxprom13_0_reg_205_fifo.DATA_WIDTH = 64;
defparam rnode_204to205_bb3_idxprom13_0_reg_205_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_204to205_bb3_idxprom13_0_reg_205_fifo.IMPL = "ll_reg";

assign rnode_204to205_bb3_idxprom13_0_reg_205_inputs_ready_NO_SHIFT_REG = rnode_45to204_bb3_idxprom13_0_valid_out_NO_SHIFT_REG;
assign rnode_45to204_bb3_idxprom13_0_stall_in_NO_SHIFT_REG = rnode_204to205_bb3_idxprom13_0_stall_out_reg_205_NO_SHIFT_REG;
assign rnode_204to205_bb3_idxprom13_0_NO_SHIFT_REG = rnode_204to205_bb3_idxprom13_0_reg_205_NO_SHIFT_REG_fa;
assign rnode_204to205_bb3_idxprom13_1_NO_SHIFT_REG = rnode_204to205_bb3_idxprom13_0_reg_205_NO_SHIFT_REG_fa;

// This section implements an unregistered operation.
// 
wire local_bb3_or_i_i143_stall_local;
wire [31:0] local_bb3_or_i_i143;

assign local_bb3_or_i_i143 = (local_bb3_shr_i_i142 | local_bb3_cond3_i);

// This section implements an unregistered operation.
// 
wire local_bb3_arrayidx16_valid_out;
wire local_bb3_arrayidx16_stall_in;
wire local_bb3_arrayidx16_inputs_ready;
wire local_bb3_arrayidx16_stall_local;
wire [63:0] local_bb3_arrayidx16;

assign local_bb3_arrayidx16_inputs_ready = rnode_204to205_bb3_idxprom13_0_valid_out_0_NO_SHIFT_REG;
assign local_bb3_arrayidx16 = (input_p + (rnode_204to205_bb3_idxprom13_0_NO_SHIFT_REG << 6'h2));
assign local_bb3_arrayidx16_valid_out = local_bb3_arrayidx16_inputs_ready;
assign local_bb3_arrayidx16_stall_local = local_bb3_arrayidx16_stall_in;
assign rnode_204to205_bb3_idxprom13_0_stall_in_0_NO_SHIFT_REG = (|local_bb3_arrayidx16_stall_local);

// This section implements an unregistered operation.
// 
wire local_bb3_arrayidx20_valid_out;
wire local_bb3_arrayidx20_stall_in;
wire local_bb3_arrayidx20_inputs_ready;
wire local_bb3_arrayidx20_stall_local;
wire [63:0] local_bb3_arrayidx20;

assign local_bb3_arrayidx20_inputs_ready = rnode_204to205_bb3_idxprom13_0_valid_out_1_NO_SHIFT_REG;
assign local_bb3_arrayidx20 = (input_error + (rnode_204to205_bb3_idxprom13_1_NO_SHIFT_REG << 6'h2));
assign local_bb3_arrayidx20_valid_out = local_bb3_arrayidx20_inputs_ready;
assign local_bb3_arrayidx20_stall_local = local_bb3_arrayidx20_stall_in;
assign rnode_204to205_bb3_idxprom13_0_stall_in_1_NO_SHIFT_REG = (|local_bb3_arrayidx20_stall_local);

// This section implements an unregistered operation.
// 
wire local_bb3_shr1_i_i144_stall_local;
wire [31:0] local_bb3_shr1_i_i144;

assign local_bb3_shr1_i_i144 = (local_bb3_or_i_i143 >> 32'h2);

// Register node:
//  * latency = 171
//  * capacity = 171
 logic rnode_205to376_bb3_arrayidx20_0_valid_out_NO_SHIFT_REG;
 logic rnode_205to376_bb3_arrayidx20_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_205to376_bb3_arrayidx20_0_NO_SHIFT_REG;
 logic rnode_205to376_bb3_arrayidx20_0_reg_376_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_205to376_bb3_arrayidx20_0_reg_376_NO_SHIFT_REG;
 logic rnode_205to376_bb3_arrayidx20_0_valid_out_reg_376_NO_SHIFT_REG;
 logic rnode_205to376_bb3_arrayidx20_0_stall_in_reg_376_NO_SHIFT_REG;
 logic rnode_205to376_bb3_arrayidx20_0_stall_out_reg_376_NO_SHIFT_REG;

acl_data_fifo rnode_205to376_bb3_arrayidx20_0_reg_376_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_205to376_bb3_arrayidx20_0_reg_376_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_205to376_bb3_arrayidx20_0_stall_in_reg_376_NO_SHIFT_REG),
	.valid_out(rnode_205to376_bb3_arrayidx20_0_valid_out_reg_376_NO_SHIFT_REG),
	.stall_out(rnode_205to376_bb3_arrayidx20_0_stall_out_reg_376_NO_SHIFT_REG),
	.data_in(local_bb3_arrayidx20),
	.data_out(rnode_205to376_bb3_arrayidx20_0_reg_376_NO_SHIFT_REG)
);

defparam rnode_205to376_bb3_arrayidx20_0_reg_376_fifo.DEPTH = 172;
defparam rnode_205to376_bb3_arrayidx20_0_reg_376_fifo.DATA_WIDTH = 64;
defparam rnode_205to376_bb3_arrayidx20_0_reg_376_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_205to376_bb3_arrayidx20_0_reg_376_fifo.IMPL = "ram";

assign rnode_205to376_bb3_arrayidx20_0_reg_376_inputs_ready_NO_SHIFT_REG = local_bb3_arrayidx20_valid_out;
assign local_bb3_arrayidx20_stall_in = rnode_205to376_bb3_arrayidx20_0_stall_out_reg_376_NO_SHIFT_REG;
assign rnode_205to376_bb3_arrayidx20_0_NO_SHIFT_REG = rnode_205to376_bb3_arrayidx20_0_reg_376_NO_SHIFT_REG;
assign rnode_205to376_bb3_arrayidx20_0_stall_in_reg_376_NO_SHIFT_REG = rnode_205to376_bb3_arrayidx20_0_stall_in_NO_SHIFT_REG;
assign rnode_205to376_bb3_arrayidx20_0_valid_out_NO_SHIFT_REG = rnode_205to376_bb3_arrayidx20_0_valid_out_reg_376_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_or2_i_i145_stall_local;
wire [31:0] local_bb3_or2_i_i145;

assign local_bb3_or2_i_i145 = (local_bb3_shr1_i_i144 | local_bb3_or_i_i143);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_376to377_bb3_arrayidx20_0_valid_out_NO_SHIFT_REG;
 logic rnode_376to377_bb3_arrayidx20_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_376to377_bb3_arrayidx20_0_NO_SHIFT_REG;
 logic rnode_376to377_bb3_arrayidx20_0_reg_377_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_376to377_bb3_arrayidx20_0_reg_377_NO_SHIFT_REG;
 logic rnode_376to377_bb3_arrayidx20_0_valid_out_reg_377_NO_SHIFT_REG;
 logic rnode_376to377_bb3_arrayidx20_0_stall_in_reg_377_NO_SHIFT_REG;
 logic rnode_376to377_bb3_arrayidx20_0_stall_out_reg_377_NO_SHIFT_REG;

acl_data_fifo rnode_376to377_bb3_arrayidx20_0_reg_377_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_376to377_bb3_arrayidx20_0_reg_377_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_376to377_bb3_arrayidx20_0_stall_in_reg_377_NO_SHIFT_REG),
	.valid_out(rnode_376to377_bb3_arrayidx20_0_valid_out_reg_377_NO_SHIFT_REG),
	.stall_out(rnode_376to377_bb3_arrayidx20_0_stall_out_reg_377_NO_SHIFT_REG),
	.data_in(rnode_205to376_bb3_arrayidx20_0_NO_SHIFT_REG),
	.data_out(rnode_376to377_bb3_arrayidx20_0_reg_377_NO_SHIFT_REG)
);

defparam rnode_376to377_bb3_arrayidx20_0_reg_377_fifo.DEPTH = 2;
defparam rnode_376to377_bb3_arrayidx20_0_reg_377_fifo.DATA_WIDTH = 64;
defparam rnode_376to377_bb3_arrayidx20_0_reg_377_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_376to377_bb3_arrayidx20_0_reg_377_fifo.IMPL = "ll_reg";

assign rnode_376to377_bb3_arrayidx20_0_reg_377_inputs_ready_NO_SHIFT_REG = rnode_205to376_bb3_arrayidx20_0_valid_out_NO_SHIFT_REG;
assign rnode_205to376_bb3_arrayidx20_0_stall_in_NO_SHIFT_REG = rnode_376to377_bb3_arrayidx20_0_stall_out_reg_377_NO_SHIFT_REG;
assign rnode_376to377_bb3_arrayidx20_0_NO_SHIFT_REG = rnode_376to377_bb3_arrayidx20_0_reg_377_NO_SHIFT_REG;
assign rnode_376to377_bb3_arrayidx20_0_stall_in_reg_377_NO_SHIFT_REG = rnode_376to377_bb3_arrayidx20_0_stall_in_NO_SHIFT_REG;
assign rnode_376to377_bb3_arrayidx20_0_valid_out_NO_SHIFT_REG = rnode_376to377_bb3_arrayidx20_0_valid_out_reg_377_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_shr3_i_i146_stall_local;
wire [31:0] local_bb3_shr3_i_i146;

assign local_bb3_shr3_i_i146 = (local_bb3_or2_i_i145 >> 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb3_or4_i_i147_stall_local;
wire [31:0] local_bb3_or4_i_i147;

assign local_bb3_or4_i_i147 = (local_bb3_shr3_i_i146 | local_bb3_or2_i_i145);

// This section implements an unregistered operation.
// 
wire local_bb3_shr5_i_i148_stall_local;
wire [31:0] local_bb3_shr5_i_i148;

assign local_bb3_shr5_i_i148 = (local_bb3_or4_i_i147 >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb3_c0_ene13_valid_out_2;
wire local_bb3_c0_ene13_stall_in_2;
 reg local_bb3_c0_ene13_consumed_2_NO_SHIFT_REG;
wire local_bb3_cond3_i_valid_out_2;
wire local_bb3_cond3_i_stall_in_2;
 reg local_bb3_cond3_i_consumed_2_NO_SHIFT_REG;
wire local_bb3_or6_i_i149_valid_out;
wire local_bb3_or6_i_i149_stall_in;
 reg local_bb3_or6_i_i149_consumed_0_NO_SHIFT_REG;
wire local_bb3_or6_i_i149_inputs_ready;
wire local_bb3_or6_i_i149_stall_local;
wire [31:0] local_bb3_or6_i_i149;

assign local_bb3_or6_i_i149_inputs_ready = local_bb3_c0_enter2_c0_eni11_valid_out_NO_SHIFT_REG;
assign local_bb3_or6_i_i149 = (local_bb3_shr5_i_i148 | local_bb3_or4_i_i147);
assign local_bb3_c0_ene13_valid_out_2 = 1'b1;
assign local_bb3_cond3_i_valid_out_2 = 1'b1;
assign local_bb3_or6_i_i149_valid_out = 1'b1;
assign local_bb3_c0_enter2_c0_eni11_stall_in = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_c0_ene13_consumed_2_NO_SHIFT_REG <= 1'b0;
		local_bb3_cond3_i_consumed_2_NO_SHIFT_REG <= 1'b0;
		local_bb3_or6_i_i149_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3_c0_ene13_consumed_2_NO_SHIFT_REG <= (local_bb3_or6_i_i149_inputs_ready & (local_bb3_c0_ene13_consumed_2_NO_SHIFT_REG | ~(local_bb3_c0_ene13_stall_in_2)) & local_bb3_or6_i_i149_stall_local);
		local_bb3_cond3_i_consumed_2_NO_SHIFT_REG <= (local_bb3_or6_i_i149_inputs_ready & (local_bb3_cond3_i_consumed_2_NO_SHIFT_REG | ~(local_bb3_cond3_i_stall_in_2)) & local_bb3_or6_i_i149_stall_local);
		local_bb3_or6_i_i149_consumed_0_NO_SHIFT_REG <= (local_bb3_or6_i_i149_inputs_ready & (local_bb3_or6_i_i149_consumed_0_NO_SHIFT_REG | ~(local_bb3_or6_i_i149_stall_in)) & local_bb3_or6_i_i149_stall_local);
	end
end


// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_2to4_bb3_c0_ene13_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_2to4_bb3_c0_ene13_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_2to4_bb3_c0_ene13_0_NO_SHIFT_REG;
 logic rnode_2to4_bb3_c0_ene13_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_2to4_bb3_c0_ene13_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_2to4_bb3_c0_ene13_1_NO_SHIFT_REG;
 logic rnode_2to4_bb3_c0_ene13_0_reg_4_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_2to4_bb3_c0_ene13_0_reg_4_NO_SHIFT_REG;
 logic rnode_2to4_bb3_c0_ene13_0_valid_out_0_reg_4_NO_SHIFT_REG;
 logic rnode_2to4_bb3_c0_ene13_0_stall_in_0_reg_4_NO_SHIFT_REG;
 logic rnode_2to4_bb3_c0_ene13_0_stall_out_reg_4_NO_SHIFT_REG;

acl_data_fifo rnode_2to4_bb3_c0_ene13_0_reg_4_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_2to4_bb3_c0_ene13_0_reg_4_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_2to4_bb3_c0_ene13_0_stall_in_0_reg_4_NO_SHIFT_REG),
	.valid_out(rnode_2to4_bb3_c0_ene13_0_valid_out_0_reg_4_NO_SHIFT_REG),
	.stall_out(rnode_2to4_bb3_c0_ene13_0_stall_out_reg_4_NO_SHIFT_REG),
	.data_in(local_bb3_c0_ene13),
	.data_out(rnode_2to4_bb3_c0_ene13_0_reg_4_NO_SHIFT_REG)
);

defparam rnode_2to4_bb3_c0_ene13_0_reg_4_fifo.DEPTH = 2;
defparam rnode_2to4_bb3_c0_ene13_0_reg_4_fifo.DATA_WIDTH = 32;
defparam rnode_2to4_bb3_c0_ene13_0_reg_4_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_2to4_bb3_c0_ene13_0_reg_4_fifo.IMPL = "shift_reg";

assign rnode_2to4_bb3_c0_ene13_0_reg_4_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_c0_ene13_stall_in_2 = 1'b0;
assign rnode_2to4_bb3_c0_ene13_0_stall_in_0_reg_4_NO_SHIFT_REG = 1'b0;
assign rnode_2to4_bb3_c0_ene13_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_2to4_bb3_c0_ene13_0_NO_SHIFT_REG = rnode_2to4_bb3_c0_ene13_0_reg_4_NO_SHIFT_REG;
assign rnode_2to4_bb3_c0_ene13_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_2to4_bb3_c0_ene13_1_NO_SHIFT_REG = rnode_2to4_bb3_c0_ene13_0_reg_4_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_2to3_bb3_cond3_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_2to3_bb3_cond3_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_2to3_bb3_cond3_i_0_NO_SHIFT_REG;
 logic rnode_2to3_bb3_cond3_i_0_reg_3_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_2to3_bb3_cond3_i_0_reg_3_NO_SHIFT_REG;
 logic rnode_2to3_bb3_cond3_i_0_valid_out_reg_3_NO_SHIFT_REG;
 logic rnode_2to3_bb3_cond3_i_0_stall_in_reg_3_NO_SHIFT_REG;
 logic rnode_2to3_bb3_cond3_i_0_stall_out_reg_3_NO_SHIFT_REG;

acl_data_fifo rnode_2to3_bb3_cond3_i_0_reg_3_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_2to3_bb3_cond3_i_0_reg_3_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_2to3_bb3_cond3_i_0_stall_in_reg_3_NO_SHIFT_REG),
	.valid_out(rnode_2to3_bb3_cond3_i_0_valid_out_reg_3_NO_SHIFT_REG),
	.stall_out(rnode_2to3_bb3_cond3_i_0_stall_out_reg_3_NO_SHIFT_REG),
	.data_in(local_bb3_cond3_i),
	.data_out(rnode_2to3_bb3_cond3_i_0_reg_3_NO_SHIFT_REG)
);

defparam rnode_2to3_bb3_cond3_i_0_reg_3_fifo.DEPTH = 1;
defparam rnode_2to3_bb3_cond3_i_0_reg_3_fifo.DATA_WIDTH = 32;
defparam rnode_2to3_bb3_cond3_i_0_reg_3_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_2to3_bb3_cond3_i_0_reg_3_fifo.IMPL = "shift_reg";

assign rnode_2to3_bb3_cond3_i_0_reg_3_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_cond3_i_stall_in_2 = 1'b0;
assign rnode_2to3_bb3_cond3_i_0_NO_SHIFT_REG = rnode_2to3_bb3_cond3_i_0_reg_3_NO_SHIFT_REG;
assign rnode_2to3_bb3_cond3_i_0_stall_in_reg_3_NO_SHIFT_REG = 1'b0;
assign rnode_2to3_bb3_cond3_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_2to3_bb3_or6_i_i149_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_2to3_bb3_or6_i_i149_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_2to3_bb3_or6_i_i149_0_NO_SHIFT_REG;
 logic rnode_2to3_bb3_or6_i_i149_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_2to3_bb3_or6_i_i149_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_2to3_bb3_or6_i_i149_1_NO_SHIFT_REG;
 logic rnode_2to3_bb3_or6_i_i149_0_reg_3_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_2to3_bb3_or6_i_i149_0_reg_3_NO_SHIFT_REG;
 logic rnode_2to3_bb3_or6_i_i149_0_valid_out_0_reg_3_NO_SHIFT_REG;
 logic rnode_2to3_bb3_or6_i_i149_0_stall_in_0_reg_3_NO_SHIFT_REG;
 logic rnode_2to3_bb3_or6_i_i149_0_stall_out_reg_3_NO_SHIFT_REG;

acl_data_fifo rnode_2to3_bb3_or6_i_i149_0_reg_3_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_2to3_bb3_or6_i_i149_0_reg_3_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_2to3_bb3_or6_i_i149_0_stall_in_0_reg_3_NO_SHIFT_REG),
	.valid_out(rnode_2to3_bb3_or6_i_i149_0_valid_out_0_reg_3_NO_SHIFT_REG),
	.stall_out(rnode_2to3_bb3_or6_i_i149_0_stall_out_reg_3_NO_SHIFT_REG),
	.data_in(local_bb3_or6_i_i149),
	.data_out(rnode_2to3_bb3_or6_i_i149_0_reg_3_NO_SHIFT_REG)
);

defparam rnode_2to3_bb3_or6_i_i149_0_reg_3_fifo.DEPTH = 1;
defparam rnode_2to3_bb3_or6_i_i149_0_reg_3_fifo.DATA_WIDTH = 32;
defparam rnode_2to3_bb3_or6_i_i149_0_reg_3_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_2to3_bb3_or6_i_i149_0_reg_3_fifo.IMPL = "shift_reg";

assign rnode_2to3_bb3_or6_i_i149_0_reg_3_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_or6_i_i149_stall_in = 1'b0;
assign rnode_2to3_bb3_or6_i_i149_0_stall_in_0_reg_3_NO_SHIFT_REG = 1'b0;
assign rnode_2to3_bb3_or6_i_i149_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_2to3_bb3_or6_i_i149_0_NO_SHIFT_REG = rnode_2to3_bb3_or6_i_i149_0_reg_3_NO_SHIFT_REG;
assign rnode_2to3_bb3_or6_i_i149_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_2to3_bb3_or6_i_i149_1_NO_SHIFT_REG = rnode_2to3_bb3_or6_i_i149_0_reg_3_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_x_lobit_i_stall_local;
wire [31:0] local_bb3_x_lobit_i;

assign local_bb3_x_lobit_i = (input_N >> 32'h1F);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_4to5_bb3_c0_ene13_0_valid_out_NO_SHIFT_REG;
 logic rnode_4to5_bb3_c0_ene13_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb3_c0_ene13_0_NO_SHIFT_REG;
 logic rnode_4to5_bb3_c0_ene13_0_reg_5_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_4to5_bb3_c0_ene13_0_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb3_c0_ene13_0_valid_out_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb3_c0_ene13_0_stall_in_reg_5_NO_SHIFT_REG;
 logic rnode_4to5_bb3_c0_ene13_0_stall_out_reg_5_NO_SHIFT_REG;

acl_data_fifo rnode_4to5_bb3_c0_ene13_0_reg_5_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_4to5_bb3_c0_ene13_0_reg_5_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_4to5_bb3_c0_ene13_0_stall_in_reg_5_NO_SHIFT_REG),
	.valid_out(rnode_4to5_bb3_c0_ene13_0_valid_out_reg_5_NO_SHIFT_REG),
	.stall_out(rnode_4to5_bb3_c0_ene13_0_stall_out_reg_5_NO_SHIFT_REG),
	.data_in(rnode_2to4_bb3_c0_ene13_1_NO_SHIFT_REG),
	.data_out(rnode_4to5_bb3_c0_ene13_0_reg_5_NO_SHIFT_REG)
);

defparam rnode_4to5_bb3_c0_ene13_0_reg_5_fifo.DEPTH = 1;
defparam rnode_4to5_bb3_c0_ene13_0_reg_5_fifo.DATA_WIDTH = 32;
defparam rnode_4to5_bb3_c0_ene13_0_reg_5_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_4to5_bb3_c0_ene13_0_reg_5_fifo.IMPL = "shift_reg";

assign rnode_4to5_bb3_c0_ene13_0_reg_5_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_2to4_bb3_c0_ene13_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_4to5_bb3_c0_ene13_0_NO_SHIFT_REG = rnode_4to5_bb3_c0_ene13_0_reg_5_NO_SHIFT_REG;
assign rnode_4to5_bb3_c0_ene13_0_stall_in_reg_5_NO_SHIFT_REG = 1'b0;
assign rnode_4to5_bb3_c0_ene13_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_conv11_i_stall_local;
wire [63:0] local_bb3_conv11_i;

assign local_bb3_conv11_i[63:32] = 32'h0;
assign local_bb3_conv11_i[31:0] = rnode_2to3_bb3_cond3_i_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_shr7_i_i150_stall_local;
wire [31:0] local_bb3_shr7_i_i150;

assign local_bb3_shr7_i_i150 = (rnode_2to3_bb3_or6_i_i149_0_NO_SHIFT_REG >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb3_conv1_i_stall_local;
wire [63:0] local_bb3_conv1_i;

assign local_bb3_conv1_i[63:32] = 32'h0;
assign local_bb3_conv1_i[31:0] = local_bb3_x_lobit_i;

// Register node:
//  * latency = 9
//  * capacity = 9
 logic rnode_5to14_bb3_c0_ene13_0_valid_out_NO_SHIFT_REG;
 logic rnode_5to14_bb3_c0_ene13_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_5to14_bb3_c0_ene13_0_NO_SHIFT_REG;
 logic rnode_5to14_bb3_c0_ene13_0_reg_14_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_5to14_bb3_c0_ene13_0_reg_14_NO_SHIFT_REG;
 logic rnode_5to14_bb3_c0_ene13_0_valid_out_reg_14_NO_SHIFT_REG;
 logic rnode_5to14_bb3_c0_ene13_0_stall_in_reg_14_NO_SHIFT_REG;
 logic rnode_5to14_bb3_c0_ene13_0_stall_out_reg_14_NO_SHIFT_REG;

acl_data_fifo rnode_5to14_bb3_c0_ene13_0_reg_14_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_5to14_bb3_c0_ene13_0_reg_14_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_5to14_bb3_c0_ene13_0_stall_in_reg_14_NO_SHIFT_REG),
	.valid_out(rnode_5to14_bb3_c0_ene13_0_valid_out_reg_14_NO_SHIFT_REG),
	.stall_out(rnode_5to14_bb3_c0_ene13_0_stall_out_reg_14_NO_SHIFT_REG),
	.data_in(rnode_4to5_bb3_c0_ene13_0_NO_SHIFT_REG),
	.data_out(rnode_5to14_bb3_c0_ene13_0_reg_14_NO_SHIFT_REG)
);

defparam rnode_5to14_bb3_c0_ene13_0_reg_14_fifo.DEPTH = 9;
defparam rnode_5to14_bb3_c0_ene13_0_reg_14_fifo.DATA_WIDTH = 32;
defparam rnode_5to14_bb3_c0_ene13_0_reg_14_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_5to14_bb3_c0_ene13_0_reg_14_fifo.IMPL = "shift_reg";

assign rnode_5to14_bb3_c0_ene13_0_reg_14_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_4to5_bb3_c0_ene13_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_5to14_bb3_c0_ene13_0_NO_SHIFT_REG = rnode_5to14_bb3_c0_ene13_0_reg_14_NO_SHIFT_REG;
assign rnode_5to14_bb3_c0_ene13_0_stall_in_reg_14_NO_SHIFT_REG = 1'b0;
assign rnode_5to14_bb3_c0_ene13_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_or8_i_i_stall_local;
wire [31:0] local_bb3_or8_i_i;

assign local_bb3_or8_i_i = (local_bb3_shr7_i_i150 | rnode_2to3_bb3_or6_i_i149_1_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_shl20_i_stall_local;
wire [63:0] local_bb3_shl20_i;

assign local_bb3_shl20_i = (local_bb3_conv1_i << 64'h3F);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_14to15_bb3_c0_ene13_0_valid_out_NO_SHIFT_REG;
 logic rnode_14to15_bb3_c0_ene13_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_14to15_bb3_c0_ene13_0_NO_SHIFT_REG;
 logic rnode_14to15_bb3_c0_ene13_0_reg_15_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_14to15_bb3_c0_ene13_0_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb3_c0_ene13_0_valid_out_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb3_c0_ene13_0_stall_in_reg_15_NO_SHIFT_REG;
 logic rnode_14to15_bb3_c0_ene13_0_stall_out_reg_15_NO_SHIFT_REG;

acl_data_fifo rnode_14to15_bb3_c0_ene13_0_reg_15_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_14to15_bb3_c0_ene13_0_reg_15_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_14to15_bb3_c0_ene13_0_stall_in_reg_15_NO_SHIFT_REG),
	.valid_out(rnode_14to15_bb3_c0_ene13_0_valid_out_reg_15_NO_SHIFT_REG),
	.stall_out(rnode_14to15_bb3_c0_ene13_0_stall_out_reg_15_NO_SHIFT_REG),
	.data_in(rnode_5to14_bb3_c0_ene13_0_NO_SHIFT_REG),
	.data_out(rnode_14to15_bb3_c0_ene13_0_reg_15_NO_SHIFT_REG)
);

defparam rnode_14to15_bb3_c0_ene13_0_reg_15_fifo.DEPTH = 1;
defparam rnode_14to15_bb3_c0_ene13_0_reg_15_fifo.DATA_WIDTH = 32;
defparam rnode_14to15_bb3_c0_ene13_0_reg_15_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_14to15_bb3_c0_ene13_0_reg_15_fifo.IMPL = "shift_reg";

assign rnode_14to15_bb3_c0_ene13_0_reg_15_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_5to14_bb3_c0_ene13_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_14to15_bb3_c0_ene13_0_NO_SHIFT_REG = rnode_14to15_bb3_c0_ene13_0_reg_15_NO_SHIFT_REG;
assign rnode_14to15_bb3_c0_ene13_0_stall_in_reg_15_NO_SHIFT_REG = 1'b0;
assign rnode_14to15_bb3_c0_ene13_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_neg_i_i151_stall_local;
wire [31:0] local_bb3_neg_i_i151;

assign local_bb3_neg_i_i151 = (local_bb3_or8_i_i ^ 32'hFFFFFFFF);

// This section implements a registered operation.
// 
wire local_bb3_phitmp_inputs_ready;
 reg local_bb3_phitmp_valid_out_NO_SHIFT_REG;
wire local_bb3_phitmp_stall_in;
wire local_bb3_phitmp_output_regs_ready;
wire [63:0] local_bb3_phitmp;
 reg local_bb3_phitmp_valid_pipe_0_NO_SHIFT_REG;
wire local_bb3_phitmp_causedstall;

acl_fp_fpext fp_module_local_bb3_phitmp (
	.clock(clock),
	.dataa(rnode_14to15_bb3_c0_ene13_0_NO_SHIFT_REG),
	.enable(local_bb3_phitmp_output_regs_ready),
	.result(local_bb3_phitmp)
);


assign local_bb3_phitmp_inputs_ready = 1'b1;
assign local_bb3_phitmp_output_regs_ready = 1'b1;
assign rnode_14to15_bb3_c0_ene13_0_stall_in_NO_SHIFT_REG = 1'b0;
assign local_bb3_phitmp_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_phitmp_valid_pipe_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_phitmp_output_regs_ready)
		begin
			local_bb3_phitmp_valid_pipe_0_NO_SHIFT_REG <= 1'b1;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_phitmp_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_phitmp_output_regs_ready)
		begin
			local_bb3_phitmp_valid_out_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb3_phitmp_stall_in))
			begin
				local_bb3_phitmp_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3__neg_i_i151_stall_local;
wire [31:0] local_bb3__neg_i_i151;

thirtysix_six_comp local_bb3__neg_i_i151_popcnt_instance (
	.data(local_bb3_neg_i_i151),
	.sum(local_bb3__neg_i_i151)
);



// This section implements a registered operation.
// 
wire local_bb3_phitmp4_inputs_ready;
 reg local_bb3_phitmp4_valid_out_NO_SHIFT_REG;
wire local_bb3_phitmp4_stall_in;
wire local_bb3_phitmp4_output_regs_ready;
wire [63:0] local_bb3_phitmp4;
 reg local_bb3_phitmp4_valid_pipe_0_NO_SHIFT_REG;
 reg local_bb3_phitmp4_valid_pipe_1_NO_SHIFT_REG;
 reg local_bb3_phitmp4_valid_pipe_2_NO_SHIFT_REG;
 reg local_bb3_phitmp4_valid_pipe_3_NO_SHIFT_REG;
 reg local_bb3_phitmp4_valid_pipe_4_NO_SHIFT_REG;
wire local_bb3_phitmp4_causedstall;

acl_fp_mul_ll_s5_double fp_module_local_bb3_phitmp4 (
	.clock(clock),
	.dataa(local_bb3_phitmp),
	.datab(64'h3FEB333333333333),
	.enable(local_bb3_phitmp4_output_regs_ready),
	.result(local_bb3_phitmp4)
);


assign local_bb3_phitmp4_inputs_ready = 1'b1;
assign local_bb3_phitmp4_output_regs_ready = 1'b1;
assign local_bb3_phitmp_stall_in = 1'b0;
assign local_bb3_phitmp4_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_phitmp4_valid_pipe_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_phitmp4_valid_pipe_1_NO_SHIFT_REG <= 1'b0;
		local_bb3_phitmp4_valid_pipe_2_NO_SHIFT_REG <= 1'b0;
		local_bb3_phitmp4_valid_pipe_3_NO_SHIFT_REG <= 1'b0;
		local_bb3_phitmp4_valid_pipe_4_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_phitmp4_output_regs_ready)
		begin
			local_bb3_phitmp4_valid_pipe_0_NO_SHIFT_REG <= 1'b1;
			local_bb3_phitmp4_valid_pipe_1_NO_SHIFT_REG <= local_bb3_phitmp4_valid_pipe_0_NO_SHIFT_REG;
			local_bb3_phitmp4_valid_pipe_2_NO_SHIFT_REG <= local_bb3_phitmp4_valid_pipe_1_NO_SHIFT_REG;
			local_bb3_phitmp4_valid_pipe_3_NO_SHIFT_REG <= local_bb3_phitmp4_valid_pipe_2_NO_SHIFT_REG;
			local_bb3_phitmp4_valid_pipe_4_NO_SHIFT_REG <= local_bb3_phitmp4_valid_pipe_3_NO_SHIFT_REG;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_phitmp4_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_phitmp4_output_regs_ready)
		begin
			local_bb3_phitmp4_valid_out_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb3_phitmp4_stall_in))
			begin
				local_bb3_phitmp4_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3_add_i154_stall_local;
wire [31:0] local_bb3_add_i154;

assign local_bb3_add_i154 = (local_bb3__neg_i_i151 + 32'h15);

// This section implements a registered operation.
// 
wire local_bb3_phitmp5_inputs_ready;
 reg local_bb3_phitmp5_valid_out_NO_SHIFT_REG;
wire local_bb3_phitmp5_stall_in;
wire local_bb3_phitmp5_output_regs_ready;
wire [31:0] local_bb3_phitmp5;
 reg local_bb3_phitmp5_valid_pipe_0_NO_SHIFT_REG;
 reg local_bb3_phitmp5_valid_pipe_1_NO_SHIFT_REG;
wire local_bb3_phitmp5_causedstall;

acl_fp_fptrunc fp_module_local_bb3_phitmp5 (
	.clock(clock),
	.dataa(local_bb3_phitmp4),
	.enable(local_bb3_phitmp5_output_regs_ready),
	.result(local_bb3_phitmp5)
);


assign local_bb3_phitmp5_inputs_ready = 1'b1;
assign local_bb3_phitmp5_output_regs_ready = 1'b1;
assign local_bb3_phitmp4_stall_in = 1'b0;
assign local_bb3_phitmp5_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_phitmp5_valid_pipe_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_phitmp5_valid_pipe_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_phitmp5_output_regs_ready)
		begin
			local_bb3_phitmp5_valid_pipe_0_NO_SHIFT_REG <= 1'b1;
			local_bb3_phitmp5_valid_pipe_1_NO_SHIFT_REG <= local_bb3_phitmp5_valid_pipe_0_NO_SHIFT_REG;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_phitmp5_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_phitmp5_output_regs_ready)
		begin
			local_bb3_phitmp5_valid_out_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb3_phitmp5_stall_in))
			begin
				local_bb3_phitmp5_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3_and13_i_stall_local;
wire [31:0] local_bb3_and13_i;

assign local_bb3_and13_i = (local_bb3_add_i154 & 32'h30);

// This section implements an unregistered operation.
// 
wire local_bb3_and14_i_stall_local;
wire [31:0] local_bb3_and14_i;

assign local_bb3_and14_i = (local_bb3_add_i154 & 32'hC);

// This section implements an unregistered operation.
// 
wire local_bb3_and17_i156_stall_local;
wire [31:0] local_bb3_and17_i156;

assign local_bb3_and17_i156 = (local_bb3_add_i154 & 32'h3);

// This section implements a registered operation.
// 
wire local_bb3_phitmp6_inputs_ready;
 reg local_bb3_phitmp6_valid_out_NO_SHIFT_REG;
wire local_bb3_phitmp6_stall_in;
wire local_bb3_phitmp6_output_regs_ready;
wire [63:0] local_bb3_phitmp6;
 reg local_bb3_phitmp6_valid_pipe_0_NO_SHIFT_REG;
wire local_bb3_phitmp6_causedstall;

acl_fp_fpext fp_module_local_bb3_phitmp6 (
	.clock(clock),
	.dataa(local_bb3_phitmp5),
	.enable(local_bb3_phitmp6_output_regs_ready),
	.result(local_bb3_phitmp6)
);


assign local_bb3_phitmp6_inputs_ready = 1'b1;
assign local_bb3_phitmp6_output_regs_ready = 1'b1;
assign local_bb3_phitmp5_stall_in = 1'b0;
assign local_bb3_phitmp6_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_phitmp6_valid_pipe_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_phitmp6_output_regs_ready)
		begin
			local_bb3_phitmp6_valid_pipe_0_NO_SHIFT_REG <= 1'b1;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_phitmp6_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_phitmp6_output_regs_ready)
		begin
			local_bb3_phitmp6_valid_out_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb3_phitmp6_stall_in))
			begin
				local_bb3_phitmp6_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3_sh_prom_i_stall_local;
wire [63:0] local_bb3_sh_prom_i;

assign local_bb3_sh_prom_i[63:32] = 32'h0;
assign local_bb3_sh_prom_i[31:0] = local_bb3_and13_i;

// This section implements an unregistered operation.
// 
wire local_bb3_var__stall_local;
wire [63:0] local_bb3_var_;

assign local_bb3_var_ = local_bb3_phitmp6;

// This section implements an unregistered operation.
// 
wire local_bb3_shl_i155_valid_out;
wire local_bb3_shl_i155_stall_in;
 reg local_bb3_shl_i155_consumed_0_NO_SHIFT_REG;
wire local_bb3__neg_i_i151_valid_out_1;
wire local_bb3__neg_i_i151_stall_in_1;
 reg local_bb3__neg_i_i151_consumed_1_NO_SHIFT_REG;
wire local_bb3_and14_i_valid_out;
wire local_bb3_and14_i_stall_in;
 reg local_bb3_and14_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_and17_i156_valid_out;
wire local_bb3_and17_i156_stall_in;
 reg local_bb3_and17_i156_consumed_0_NO_SHIFT_REG;
wire local_bb3_shl_i155_inputs_ready;
wire local_bb3_shl_i155_stall_local;
wire [63:0] local_bb3_shl_i155;

assign local_bb3_shl_i155_inputs_ready = (rnode_2to3_bb3_cond3_i_0_valid_out_NO_SHIFT_REG & rnode_2to3_bb3_or6_i_i149_0_valid_out_0_NO_SHIFT_REG & rnode_2to3_bb3_or6_i_i149_0_valid_out_1_NO_SHIFT_REG);
assign local_bb3_shl_i155 = (local_bb3_conv11_i << local_bb3_sh_prom_i);
assign local_bb3_shl_i155_valid_out = 1'b1;
assign local_bb3__neg_i_i151_valid_out_1 = 1'b1;
assign local_bb3_and14_i_valid_out = 1'b1;
assign local_bb3_and17_i156_valid_out = 1'b1;
assign rnode_2to3_bb3_cond3_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_2to3_bb3_or6_i_i149_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_2to3_bb3_or6_i_i149_0_stall_in_1_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_shl_i155_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3__neg_i_i151_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb3_and14_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_and17_i156_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3_shl_i155_consumed_0_NO_SHIFT_REG <= (local_bb3_shl_i155_inputs_ready & (local_bb3_shl_i155_consumed_0_NO_SHIFT_REG | ~(local_bb3_shl_i155_stall_in)) & local_bb3_shl_i155_stall_local);
		local_bb3__neg_i_i151_consumed_1_NO_SHIFT_REG <= (local_bb3_shl_i155_inputs_ready & (local_bb3__neg_i_i151_consumed_1_NO_SHIFT_REG | ~(local_bb3__neg_i_i151_stall_in_1)) & local_bb3_shl_i155_stall_local);
		local_bb3_and14_i_consumed_0_NO_SHIFT_REG <= (local_bb3_shl_i155_inputs_ready & (local_bb3_and14_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_and14_i_stall_in)) & local_bb3_shl_i155_stall_local);
		local_bb3_and17_i156_consumed_0_NO_SHIFT_REG <= (local_bb3_shl_i155_inputs_ready & (local_bb3_and17_i156_consumed_0_NO_SHIFT_REG | ~(local_bb3_and17_i156_stall_in)) & local_bb3_shl_i155_stall_local);
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3_astype_i_i27_stall_local;
wire [63:0] local_bb3_astype_i_i27;

assign local_bb3_astype_i_i27 = (input_wii_cmp1 ? local_bb3_var_ : 64'h0);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_3to4_bb3_shl_i155_0_valid_out_NO_SHIFT_REG;
 logic rnode_3to4_bb3_shl_i155_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_3to4_bb3_shl_i155_0_NO_SHIFT_REG;
 logic rnode_3to4_bb3_shl_i155_0_reg_4_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_3to4_bb3_shl_i155_0_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb3_shl_i155_0_valid_out_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb3_shl_i155_0_stall_in_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb3_shl_i155_0_stall_out_reg_4_NO_SHIFT_REG;

acl_data_fifo rnode_3to4_bb3_shl_i155_0_reg_4_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_3to4_bb3_shl_i155_0_reg_4_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_3to4_bb3_shl_i155_0_stall_in_reg_4_NO_SHIFT_REG),
	.valid_out(rnode_3to4_bb3_shl_i155_0_valid_out_reg_4_NO_SHIFT_REG),
	.stall_out(rnode_3to4_bb3_shl_i155_0_stall_out_reg_4_NO_SHIFT_REG),
	.data_in(local_bb3_shl_i155),
	.data_out(rnode_3to4_bb3_shl_i155_0_reg_4_NO_SHIFT_REG)
);

defparam rnode_3to4_bb3_shl_i155_0_reg_4_fifo.DEPTH = 1;
defparam rnode_3to4_bb3_shl_i155_0_reg_4_fifo.DATA_WIDTH = 64;
defparam rnode_3to4_bb3_shl_i155_0_reg_4_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_3to4_bb3_shl_i155_0_reg_4_fifo.IMPL = "shift_reg";

assign rnode_3to4_bb3_shl_i155_0_reg_4_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_shl_i155_stall_in = 1'b0;
assign rnode_3to4_bb3_shl_i155_0_NO_SHIFT_REG = rnode_3to4_bb3_shl_i155_0_reg_4_NO_SHIFT_REG;
assign rnode_3to4_bb3_shl_i155_0_stall_in_reg_4_NO_SHIFT_REG = 1'b0;
assign rnode_3to4_bb3_shl_i155_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_3to4_bb3__neg_i_i151_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_3to4_bb3__neg_i_i151_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_3to4_bb3__neg_i_i151_0_NO_SHIFT_REG;
 logic rnode_3to4_bb3__neg_i_i151_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_3to4_bb3__neg_i_i151_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_3to4_bb3__neg_i_i151_1_NO_SHIFT_REG;
 logic rnode_3to4_bb3__neg_i_i151_0_reg_4_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_3to4_bb3__neg_i_i151_0_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb3__neg_i_i151_0_valid_out_0_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb3__neg_i_i151_0_stall_in_0_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb3__neg_i_i151_0_stall_out_reg_4_NO_SHIFT_REG;

acl_data_fifo rnode_3to4_bb3__neg_i_i151_0_reg_4_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_3to4_bb3__neg_i_i151_0_reg_4_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_3to4_bb3__neg_i_i151_0_stall_in_0_reg_4_NO_SHIFT_REG),
	.valid_out(rnode_3to4_bb3__neg_i_i151_0_valid_out_0_reg_4_NO_SHIFT_REG),
	.stall_out(rnode_3to4_bb3__neg_i_i151_0_stall_out_reg_4_NO_SHIFT_REG),
	.data_in(local_bb3__neg_i_i151),
	.data_out(rnode_3to4_bb3__neg_i_i151_0_reg_4_NO_SHIFT_REG)
);

defparam rnode_3to4_bb3__neg_i_i151_0_reg_4_fifo.DEPTH = 1;
defparam rnode_3to4_bb3__neg_i_i151_0_reg_4_fifo.DATA_WIDTH = 32;
defparam rnode_3to4_bb3__neg_i_i151_0_reg_4_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_3to4_bb3__neg_i_i151_0_reg_4_fifo.IMPL = "shift_reg";

assign rnode_3to4_bb3__neg_i_i151_0_reg_4_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3__neg_i_i151_stall_in_1 = 1'b0;
assign rnode_3to4_bb3__neg_i_i151_0_stall_in_0_reg_4_NO_SHIFT_REG = 1'b0;
assign rnode_3to4_bb3__neg_i_i151_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_3to4_bb3__neg_i_i151_0_NO_SHIFT_REG = rnode_3to4_bb3__neg_i_i151_0_reg_4_NO_SHIFT_REG;
assign rnode_3to4_bb3__neg_i_i151_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_3to4_bb3__neg_i_i151_1_NO_SHIFT_REG = rnode_3to4_bb3__neg_i_i151_0_reg_4_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_3to4_bb3_and14_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_3to4_bb3_and14_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_3to4_bb3_and14_i_0_NO_SHIFT_REG;
 logic rnode_3to4_bb3_and14_i_0_reg_4_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_3to4_bb3_and14_i_0_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb3_and14_i_0_valid_out_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb3_and14_i_0_stall_in_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb3_and14_i_0_stall_out_reg_4_NO_SHIFT_REG;

acl_data_fifo rnode_3to4_bb3_and14_i_0_reg_4_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_3to4_bb3_and14_i_0_reg_4_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_3to4_bb3_and14_i_0_stall_in_reg_4_NO_SHIFT_REG),
	.valid_out(rnode_3to4_bb3_and14_i_0_valid_out_reg_4_NO_SHIFT_REG),
	.stall_out(rnode_3to4_bb3_and14_i_0_stall_out_reg_4_NO_SHIFT_REG),
	.data_in(local_bb3_and14_i),
	.data_out(rnode_3to4_bb3_and14_i_0_reg_4_NO_SHIFT_REG)
);

defparam rnode_3to4_bb3_and14_i_0_reg_4_fifo.DEPTH = 1;
defparam rnode_3to4_bb3_and14_i_0_reg_4_fifo.DATA_WIDTH = 32;
defparam rnode_3to4_bb3_and14_i_0_reg_4_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_3to4_bb3_and14_i_0_reg_4_fifo.IMPL = "shift_reg";

assign rnode_3to4_bb3_and14_i_0_reg_4_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and14_i_stall_in = 1'b0;
assign rnode_3to4_bb3_and14_i_0_NO_SHIFT_REG = rnode_3to4_bb3_and14_i_0_reg_4_NO_SHIFT_REG;
assign rnode_3to4_bb3_and14_i_0_stall_in_reg_4_NO_SHIFT_REG = 1'b0;
assign rnode_3to4_bb3_and14_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_3to4_bb3_and17_i156_0_valid_out_NO_SHIFT_REG;
 logic rnode_3to4_bb3_and17_i156_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_3to4_bb3_and17_i156_0_NO_SHIFT_REG;
 logic rnode_3to4_bb3_and17_i156_0_reg_4_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_3to4_bb3_and17_i156_0_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb3_and17_i156_0_valid_out_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb3_and17_i156_0_stall_in_reg_4_NO_SHIFT_REG;
 logic rnode_3to4_bb3_and17_i156_0_stall_out_reg_4_NO_SHIFT_REG;

acl_data_fifo rnode_3to4_bb3_and17_i156_0_reg_4_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_3to4_bb3_and17_i156_0_reg_4_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_3to4_bb3_and17_i156_0_stall_in_reg_4_NO_SHIFT_REG),
	.valid_out(rnode_3to4_bb3_and17_i156_0_valid_out_reg_4_NO_SHIFT_REG),
	.stall_out(rnode_3to4_bb3_and17_i156_0_stall_out_reg_4_NO_SHIFT_REG),
	.data_in(local_bb3_and17_i156),
	.data_out(rnode_3to4_bb3_and17_i156_0_reg_4_NO_SHIFT_REG)
);

defparam rnode_3to4_bb3_and17_i156_0_reg_4_fifo.DEPTH = 1;
defparam rnode_3to4_bb3_and17_i156_0_reg_4_fifo.DATA_WIDTH = 32;
defparam rnode_3to4_bb3_and17_i156_0_reg_4_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_3to4_bb3_and17_i156_0_reg_4_fifo.IMPL = "shift_reg";

assign rnode_3to4_bb3_and17_i156_0_reg_4_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and17_i156_stall_in = 1'b0;
assign rnode_3to4_bb3_and17_i156_0_NO_SHIFT_REG = rnode_3to4_bb3_and17_i156_0_reg_4_NO_SHIFT_REG;
assign rnode_3to4_bb3_and17_i156_0_stall_in_reg_4_NO_SHIFT_REG = 1'b0;
assign rnode_3to4_bb3_and17_i156_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_and2_i_i_stall_local;
wire [63:0] local_bb3_and2_i_i;

assign local_bb3_and2_i_i = (local_bb3_astype_i_i27 & 64'hFFFFFFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_and3_i_i_stall_local;
wire [63:0] local_bb3_and3_i_i;

assign local_bb3_and3_i_i = (local_bb3_astype_i_i27 >> 64'h34);

// This section implements an unregistered operation.
// 
wire local_bb3_and_i42_i_stall_local;
wire [63:0] local_bb3_and_i42_i;

assign local_bb3_and_i42_i = (local_bb3_astype_i_i27 >> 64'h3F);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp_i152_stall_local;
wire local_bb3_cmp_i152;

assign local_bb3_cmp_i152 = (rnode_3to4_bb3__neg_i_i151_0_NO_SHIFT_REG == 32'h20);

// This section implements an unregistered operation.
// 
wire local_bb3_sub7_i_stall_local;
wire [31:0] local_bb3_sub7_i;

assign local_bb3_sub7_i = (32'h41E - rnode_3to4_bb3__neg_i_i151_1_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_sh_prom15_i_stall_local;
wire [63:0] local_bb3_sh_prom15_i;

assign local_bb3_sh_prom15_i[63:32] = 32'h0;
assign local_bb3_sh_prom15_i[31:0] = rnode_3to4_bb3_and14_i_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_sh_prom18_i_stall_local;
wire [63:0] local_bb3_sh_prom18_i;

assign local_bb3_sh_prom18_i[63:32] = 32'h0;
assign local_bb3_sh_prom18_i[31:0] = rnode_3to4_bb3_and17_i156_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_or7_i_i_stall_local;
wire [63:0] local_bb3_or7_i_i;

assign local_bb3_or7_i_i = (local_bb3_and2_i_i | 64'h10000000000000);

// This section implements an unregistered operation.
// 
wire local_bb3_shr4_i_i_stall_local;
wire [63:0] local_bb3_shr4_i_i;

assign local_bb3_shr4_i_i = (local_bb3_and3_i_i & 64'h7FF);

// This section implements an unregistered operation.
// 
wire local_bb3_or_i_i28_stall_local;
wire [63:0] local_bb3_or_i_i28;

assign local_bb3_or_i_i28 = (local_bb3_and3_i_i | 64'h800);

// This section implements an unregistered operation.
// 
wire local_bb3_phitmp_i_stall_local;
wire [63:0] local_bb3_phitmp_i;

assign local_bb3_phitmp_i[63:32] = 32'h0;
assign local_bb3_phitmp_i[31:0] = local_bb3_sub7_i;

// This section implements an unregistered operation.
// 
wire local_bb3_shl16_i_stall_local;
wire [63:0] local_bb3_shl16_i;

assign local_bb3_shl16_i = (rnode_3to4_bb3_shl_i155_0_NO_SHIFT_REG << local_bb3_sh_prom15_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp_i_i_stall_local;
wire local_bb3_cmp_i_i;

assign local_bb3_cmp_i_i = (local_bb3_shr4_i_i == 64'h7FF);

// This section implements an unregistered operation.
// 
wire local_bb3_phitmp2_i_stall_local;
wire [63:0] local_bb3_phitmp2_i;

assign local_bb3_phitmp2_i = (local_bb3_phitmp_i << 64'h34);

// This section implements an unregistered operation.
// 
wire local_bb3_shl19_i_stall_local;
wire [63:0] local_bb3_shl19_i;

assign local_bb3_shl19_i = (local_bb3_shl16_i << local_bb3_sh_prom18_i);

// This section implements an unregistered operation.
// 
wire local_bb3_or_i_shr4_i_i_stall_local;
wire [63:0] local_bb3_or_i_shr4_i_i;

assign local_bb3_or_i_shr4_i_i = (local_bb3_cmp_i_i ? local_bb3_or_i_i28 : local_bb3_shr4_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3___i153_stall_local;
wire [63:0] local_bb3___i153;

assign local_bb3___i153 = (local_bb3_cmp_i152 ? 64'h0 : local_bb3_phitmp2_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and22_i_stall_local;
wire [63:0] local_bb3_and22_i;

assign local_bb3_and22_i = (local_bb3_shl19_i & 64'hFFFFFFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp5_i_i_stall_local;
wire local_bb3_cmp5_i_i;

assign local_bb3_cmp5_i_i = (local_bb3_or_i_shr4_i_i == 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_or_i157_stall_local;
wire [63:0] local_bb3_or_i157;

assign local_bb3_or_i157 = (local_bb3_and22_i | local_bb3_shl20_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and_i42_i_valid_out;
wire local_bb3_and_i42_i_stall_in;
 reg local_bb3_and_i42_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_and2_or7_i_i_valid_out;
wire local_bb3_and2_or7_i_i_stall_in;
 reg local_bb3_and2_or7_i_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_or_i_shr4_i_i_valid_out_1;
wire local_bb3_or_i_shr4_i_i_stall_in_1;
 reg local_bb3_or_i_shr4_i_i_consumed_1_NO_SHIFT_REG;
wire local_bb3_and2_or7_i_i_inputs_ready;
wire local_bb3_and2_or7_i_i_stall_local;
wire [63:0] local_bb3_and2_or7_i_i;

assign local_bb3_and2_or7_i_i_inputs_ready = local_bb3_phitmp6_valid_out_NO_SHIFT_REG;
assign local_bb3_and2_or7_i_i = (local_bb3_cmp5_i_i ? local_bb3_and2_i_i : local_bb3_or7_i_i);
assign local_bb3_and_i42_i_valid_out = 1'b1;
assign local_bb3_and2_or7_i_i_valid_out = 1'b1;
assign local_bb3_or_i_shr4_i_i_valid_out_1 = 1'b1;
assign local_bb3_phitmp6_stall_in = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_and_i42_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_and2_or7_i_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_or_i_shr4_i_i_consumed_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3_and_i42_i_consumed_0_NO_SHIFT_REG <= (local_bb3_and2_or7_i_i_inputs_ready & (local_bb3_and_i42_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_and_i42_i_stall_in)) & local_bb3_and2_or7_i_i_stall_local);
		local_bb3_and2_or7_i_i_consumed_0_NO_SHIFT_REG <= (local_bb3_and2_or7_i_i_inputs_ready & (local_bb3_and2_or7_i_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_and2_or7_i_i_stall_in)) & local_bb3_and2_or7_i_i_stall_local);
		local_bb3_or_i_shr4_i_i_consumed_1_NO_SHIFT_REG <= (local_bb3_and2_or7_i_i_inputs_ready & (local_bb3_or_i_shr4_i_i_consumed_1_NO_SHIFT_REG | ~(local_bb3_or_i_shr4_i_i_stall_in_1)) & local_bb3_and2_or7_i_i_stall_local);
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3_or23_i_stall_local;
wire [63:0] local_bb3_or23_i;

assign local_bb3_or23_i = (local_bb3_or_i157 | local_bb3___i153);

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_28to30_bb3_and_i42_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_28to30_bb3_and_i42_i_0_stall_in_0_NO_SHIFT_REG;
 logic [63:0] rnode_28to30_bb3_and_i42_i_0_NO_SHIFT_REG;
 logic rnode_28to30_bb3_and_i42_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_28to30_bb3_and_i42_i_0_stall_in_1_NO_SHIFT_REG;
 logic [63:0] rnode_28to30_bb3_and_i42_i_1_NO_SHIFT_REG;
 logic rnode_28to30_bb3_and_i42_i_0_reg_30_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_28to30_bb3_and_i42_i_0_reg_30_NO_SHIFT_REG;
 logic rnode_28to30_bb3_and_i42_i_0_valid_out_0_reg_30_NO_SHIFT_REG;
 logic rnode_28to30_bb3_and_i42_i_0_stall_in_0_reg_30_NO_SHIFT_REG;
 logic rnode_28to30_bb3_and_i42_i_0_stall_out_reg_30_NO_SHIFT_REG;

acl_data_fifo rnode_28to30_bb3_and_i42_i_0_reg_30_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_28to30_bb3_and_i42_i_0_reg_30_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_28to30_bb3_and_i42_i_0_stall_in_0_reg_30_NO_SHIFT_REG),
	.valid_out(rnode_28to30_bb3_and_i42_i_0_valid_out_0_reg_30_NO_SHIFT_REG),
	.stall_out(rnode_28to30_bb3_and_i42_i_0_stall_out_reg_30_NO_SHIFT_REG),
	.data_in(local_bb3_and_i42_i),
	.data_out(rnode_28to30_bb3_and_i42_i_0_reg_30_NO_SHIFT_REG)
);

defparam rnode_28to30_bb3_and_i42_i_0_reg_30_fifo.DEPTH = 2;
defparam rnode_28to30_bb3_and_i42_i_0_reg_30_fifo.DATA_WIDTH = 64;
defparam rnode_28to30_bb3_and_i42_i_0_reg_30_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_28to30_bb3_and_i42_i_0_reg_30_fifo.IMPL = "shift_reg";

assign rnode_28to30_bb3_and_i42_i_0_reg_30_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and_i42_i_stall_in = 1'b0;
assign rnode_28to30_bb3_and_i42_i_0_stall_in_0_reg_30_NO_SHIFT_REG = 1'b0;
assign rnode_28to30_bb3_and_i42_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_28to30_bb3_and_i42_i_0_NO_SHIFT_REG = rnode_28to30_bb3_and_i42_i_0_reg_30_NO_SHIFT_REG;
assign rnode_28to30_bb3_and_i42_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_28to30_bb3_and_i42_i_1_NO_SHIFT_REG = rnode_28to30_bb3_and_i42_i_0_reg_30_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_28to29_bb3_and2_or7_i_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and2_or7_i_i_0_stall_in_0_NO_SHIFT_REG;
 logic [63:0] rnode_28to29_bb3_and2_or7_i_i_0_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and2_or7_i_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and2_or7_i_i_0_stall_in_1_NO_SHIFT_REG;
 logic [63:0] rnode_28to29_bb3_and2_or7_i_i_1_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and2_or7_i_i_0_reg_29_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_28to29_bb3_and2_or7_i_i_0_reg_29_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and2_or7_i_i_0_valid_out_0_reg_29_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and2_or7_i_i_0_stall_in_0_reg_29_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and2_or7_i_i_0_stall_out_reg_29_NO_SHIFT_REG;

acl_data_fifo rnode_28to29_bb3_and2_or7_i_i_0_reg_29_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_28to29_bb3_and2_or7_i_i_0_reg_29_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_28to29_bb3_and2_or7_i_i_0_stall_in_0_reg_29_NO_SHIFT_REG),
	.valid_out(rnode_28to29_bb3_and2_or7_i_i_0_valid_out_0_reg_29_NO_SHIFT_REG),
	.stall_out(rnode_28to29_bb3_and2_or7_i_i_0_stall_out_reg_29_NO_SHIFT_REG),
	.data_in(local_bb3_and2_or7_i_i),
	.data_out(rnode_28to29_bb3_and2_or7_i_i_0_reg_29_NO_SHIFT_REG)
);

defparam rnode_28to29_bb3_and2_or7_i_i_0_reg_29_fifo.DEPTH = 1;
defparam rnode_28to29_bb3_and2_or7_i_i_0_reg_29_fifo.DATA_WIDTH = 64;
defparam rnode_28to29_bb3_and2_or7_i_i_0_reg_29_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_28to29_bb3_and2_or7_i_i_0_reg_29_fifo.IMPL = "shift_reg";

assign rnode_28to29_bb3_and2_or7_i_i_0_reg_29_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and2_or7_i_i_stall_in = 1'b0;
assign rnode_28to29_bb3_and2_or7_i_i_0_stall_in_0_reg_29_NO_SHIFT_REG = 1'b0;
assign rnode_28to29_bb3_and2_or7_i_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_28to29_bb3_and2_or7_i_i_0_NO_SHIFT_REG = rnode_28to29_bb3_and2_or7_i_i_0_reg_29_NO_SHIFT_REG;
assign rnode_28to29_bb3_and2_or7_i_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_28to29_bb3_and2_or7_i_i_1_NO_SHIFT_REG = rnode_28to29_bb3_and2_or7_i_i_0_reg_29_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_28to29_bb3_or_i_shr4_i_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_28to29_bb3_or_i_shr4_i_i_0_stall_in_0_NO_SHIFT_REG;
 logic [63:0] rnode_28to29_bb3_or_i_shr4_i_i_0_NO_SHIFT_REG;
 logic rnode_28to29_bb3_or_i_shr4_i_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_28to29_bb3_or_i_shr4_i_i_0_stall_in_1_NO_SHIFT_REG;
 logic [63:0] rnode_28to29_bb3_or_i_shr4_i_i_1_NO_SHIFT_REG;
 logic rnode_28to29_bb3_or_i_shr4_i_i_0_reg_29_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_28to29_bb3_or_i_shr4_i_i_0_reg_29_NO_SHIFT_REG;
 logic rnode_28to29_bb3_or_i_shr4_i_i_0_valid_out_0_reg_29_NO_SHIFT_REG;
 logic rnode_28to29_bb3_or_i_shr4_i_i_0_stall_in_0_reg_29_NO_SHIFT_REG;
 logic rnode_28to29_bb3_or_i_shr4_i_i_0_stall_out_reg_29_NO_SHIFT_REG;

acl_data_fifo rnode_28to29_bb3_or_i_shr4_i_i_0_reg_29_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_28to29_bb3_or_i_shr4_i_i_0_reg_29_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_28to29_bb3_or_i_shr4_i_i_0_stall_in_0_reg_29_NO_SHIFT_REG),
	.valid_out(rnode_28to29_bb3_or_i_shr4_i_i_0_valid_out_0_reg_29_NO_SHIFT_REG),
	.stall_out(rnode_28to29_bb3_or_i_shr4_i_i_0_stall_out_reg_29_NO_SHIFT_REG),
	.data_in(local_bb3_or_i_shr4_i_i),
	.data_out(rnode_28to29_bb3_or_i_shr4_i_i_0_reg_29_NO_SHIFT_REG)
);

defparam rnode_28to29_bb3_or_i_shr4_i_i_0_reg_29_fifo.DEPTH = 1;
defparam rnode_28to29_bb3_or_i_shr4_i_i_0_reg_29_fifo.DATA_WIDTH = 64;
defparam rnode_28to29_bb3_or_i_shr4_i_i_0_reg_29_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_28to29_bb3_or_i_shr4_i_i_0_reg_29_fifo.IMPL = "shift_reg";

assign rnode_28to29_bb3_or_i_shr4_i_i_0_reg_29_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_or_i_shr4_i_i_stall_in_1 = 1'b0;
assign rnode_28to29_bb3_or_i_shr4_i_i_0_stall_in_0_reg_29_NO_SHIFT_REG = 1'b0;
assign rnode_28to29_bb3_or_i_shr4_i_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_28to29_bb3_or_i_shr4_i_i_0_NO_SHIFT_REG = rnode_28to29_bb3_or_i_shr4_i_i_0_reg_29_NO_SHIFT_REG;
assign rnode_28to29_bb3_or_i_shr4_i_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_28to29_bb3_or_i_shr4_i_i_1_NO_SHIFT_REG = rnode_28to29_bb3_or_i_shr4_i_i_0_reg_29_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_var__u26_valid_out;
wire local_bb3_var__u26_stall_in;
wire local_bb3_var__u26_inputs_ready;
wire local_bb3_var__u26_stall_local;
wire [63:0] local_bb3_var__u26;

assign local_bb3_var__u26_inputs_ready = (rnode_2to4_bb3_c0_ene13_0_valid_out_0_NO_SHIFT_REG & rnode_3to4_bb3_shl_i155_0_valid_out_NO_SHIFT_REG & rnode_3to4_bb3__neg_i_i151_0_valid_out_0_NO_SHIFT_REG & rnode_3to4_bb3_and14_i_0_valid_out_NO_SHIFT_REG & rnode_3to4_bb3_and17_i156_0_valid_out_NO_SHIFT_REG & rnode_3to4_bb3__neg_i_i151_0_valid_out_1_NO_SHIFT_REG);
assign local_bb3_var__u26 = local_bb3_or23_i;
assign local_bb3_var__u26_valid_out = 1'b1;
assign rnode_2to4_bb3_c0_ene13_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_3to4_bb3_shl_i155_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_3to4_bb3__neg_i_i151_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_3to4_bb3_and14_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_3to4_bb3_and17_i156_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_3to4_bb3__neg_i_i151_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb3_and2_or7_op_i_i_stall_local;
wire [63:0] local_bb3_and2_or7_op_i_i;

assign local_bb3_and2_or7_op_i_i = (rnode_28to29_bb3_and2_or7_i_i_0_NO_SHIFT_REG << 64'h3);

// This section implements an unregistered operation.
// 
wire local_bb3_var__u27_stall_local;
wire [63:0] local_bb3_var__u27;

assign local_bb3_var__u27 = (rnode_28to29_bb3_and2_or7_i_i_1_NO_SHIFT_REG >> 64'h19);

// This section implements an unregistered operation.
// 
wire local_bb3__tr_i44_i_stall_local;
wire [31:0] local_bb3__tr_i44_i;

assign local_bb3__tr_i44_i = rnode_28to29_bb3_or_i_shr4_i_i_0_NO_SHIFT_REG[31:0];

// This section implements a registered operation.
// 
wire local_bb3_div_inputs_ready;
 reg local_bb3_div_valid_out_NO_SHIFT_REG;
wire local_bb3_div_stall_in;
wire local_bb3_div_output_regs_ready;
wire [63:0] local_bb3_div;
 reg local_bb3_div_valid_pipe_0_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_1_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_2_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_3_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_4_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_5_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_6_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_7_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_8_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_9_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_10_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_11_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_12_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_13_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_14_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_15_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_16_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_17_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_18_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_19_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_20_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_21_NO_SHIFT_REG;
 reg local_bb3_div_valid_pipe_22_NO_SHIFT_REG;
wire local_bb3_div_causedstall;

acl_fp_div_s5_double fp_module_local_bb3_div (
	.clock(clock),
	.dataa(64'h3FC3333333333334),
	.datab(local_bb3_var__u26),
	.enable(local_bb3_div_output_regs_ready),
	.result(local_bb3_div)
);


assign local_bb3_div_inputs_ready = 1'b1;
assign local_bb3_div_output_regs_ready = 1'b1;
assign local_bb3_var__u26_stall_in = 1'b0;
assign local_bb3_div_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_div_valid_pipe_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_1_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_2_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_3_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_4_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_5_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_6_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_7_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_8_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_9_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_10_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_11_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_12_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_13_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_14_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_15_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_16_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_17_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_18_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_19_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_20_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_21_NO_SHIFT_REG <= 1'b0;
		local_bb3_div_valid_pipe_22_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_div_output_regs_ready)
		begin
			local_bb3_div_valid_pipe_0_NO_SHIFT_REG <= 1'b1;
			local_bb3_div_valid_pipe_1_NO_SHIFT_REG <= local_bb3_div_valid_pipe_0_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_2_NO_SHIFT_REG <= local_bb3_div_valid_pipe_1_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_3_NO_SHIFT_REG <= local_bb3_div_valid_pipe_2_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_4_NO_SHIFT_REG <= local_bb3_div_valid_pipe_3_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_5_NO_SHIFT_REG <= local_bb3_div_valid_pipe_4_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_6_NO_SHIFT_REG <= local_bb3_div_valid_pipe_5_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_7_NO_SHIFT_REG <= local_bb3_div_valid_pipe_6_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_8_NO_SHIFT_REG <= local_bb3_div_valid_pipe_7_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_9_NO_SHIFT_REG <= local_bb3_div_valid_pipe_8_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_10_NO_SHIFT_REG <= local_bb3_div_valid_pipe_9_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_11_NO_SHIFT_REG <= local_bb3_div_valid_pipe_10_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_12_NO_SHIFT_REG <= local_bb3_div_valid_pipe_11_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_13_NO_SHIFT_REG <= local_bb3_div_valid_pipe_12_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_14_NO_SHIFT_REG <= local_bb3_div_valid_pipe_13_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_15_NO_SHIFT_REG <= local_bb3_div_valid_pipe_14_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_16_NO_SHIFT_REG <= local_bb3_div_valid_pipe_15_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_17_NO_SHIFT_REG <= local_bb3_div_valid_pipe_16_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_18_NO_SHIFT_REG <= local_bb3_div_valid_pipe_17_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_19_NO_SHIFT_REG <= local_bb3_div_valid_pipe_18_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_20_NO_SHIFT_REG <= local_bb3_div_valid_pipe_19_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_21_NO_SHIFT_REG <= local_bb3_div_valid_pipe_20_NO_SHIFT_REG;
			local_bb3_div_valid_pipe_22_NO_SHIFT_REG <= local_bb3_div_valid_pipe_21_NO_SHIFT_REG;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_div_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_div_output_regs_ready)
		begin
			local_bb3_div_valid_out_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb3_div_stall_in))
			begin
				local_bb3_div_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3__tr2_i_i_stall_local;
wire [31:0] local_bb3__tr2_i_i;

assign local_bb3__tr2_i_i = local_bb3_and2_or7_op_i_i[31:0];

// This section implements an unregistered operation.
// 
wire local_bb3__tr_i30_stall_local;
wire [31:0] local_bb3__tr_i30;

assign local_bb3__tr_i30 = local_bb3_var__u27[31:0];

// This section implements an unregistered operation.
// 
wire local_bb3_conv_i45_i_stall_local;
wire [31:0] local_bb3_conv_i45_i;

assign local_bb3_conv_i45_i = (local_bb3__tr_i44_i & 32'hFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_astype_i18_i_stall_local;
wire [63:0] local_bb3_astype_i18_i;

assign local_bb3_astype_i18_i = local_bb3_div;

// This section implements an unregistered operation.
// 
wire local_bb3_conv14_i_i_stall_local;
wire [31:0] local_bb3_conv14_i_i;

assign local_bb3_conv14_i_i = (local_bb3__tr2_i_i & 32'hFFFFFF8);

// This section implements an unregistered operation.
// 
wire local_bb3_conv19_i_i_stall_local;
wire [31:0] local_bb3_conv19_i_i;

assign local_bb3_conv19_i_i = (local_bb3__tr_i30 & 32'hFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_and2_i19_i_stall_local;
wire [63:0] local_bb3_and2_i19_i;

assign local_bb3_and2_i19_i = (local_bb3_astype_i18_i & 64'hFFFFFFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_and3_i20_i_stall_local;
wire [63:0] local_bb3_and3_i20_i;

assign local_bb3_and3_i20_i = (local_bb3_astype_i18_i >> 64'h34);

// This section implements an unregistered operation.
// 
wire local_bb3_and5_i43_i_stall_local;
wire [63:0] local_bb3_and5_i43_i;

assign local_bb3_and5_i43_i = (local_bb3_astype_i18_i >> 64'h3F);

// This section implements an unregistered operation.
// 
wire local_bb3_or7_i27_i_stall_local;
wire [63:0] local_bb3_or7_i27_i;

assign local_bb3_or7_i27_i = (local_bb3_and2_i19_i | 64'h10000000000000);

// This section implements an unregistered operation.
// 
wire local_bb3_shr4_i21_i_stall_local;
wire [63:0] local_bb3_shr4_i21_i;

assign local_bb3_shr4_i21_i = (local_bb3_and3_i20_i & 64'h7FF);

// This section implements an unregistered operation.
// 
wire local_bb3_or_i23_i_stall_local;
wire [63:0] local_bb3_or_i23_i;

assign local_bb3_or_i23_i = (local_bb3_and3_i20_i | 64'h800);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp_i22_i_stall_local;
wire local_bb3_cmp_i22_i;

assign local_bb3_cmp_i22_i = (local_bb3_shr4_i21_i == 64'h7FF);

// This section implements an unregistered operation.
// 
wire local_bb3_exponent_0_i26_i_stall_local;
wire [63:0] local_bb3_exponent_0_i26_i;

assign local_bb3_exponent_0_i26_i = (local_bb3_cmp_i22_i ? local_bb3_or_i23_i : local_bb3_shr4_i21_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp5_i28_i_stall_local;
wire local_bb3_cmp5_i28_i;

assign local_bb3_cmp5_i28_i = (local_bb3_exponent_0_i26_i == 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_and5_i43_i_valid_out;
wire local_bb3_and5_i43_i_stall_in;
 reg local_bb3_and5_i43_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_and2_or7_i29_i_valid_out;
wire local_bb3_and2_or7_i29_i_stall_in;
 reg local_bb3_and2_or7_i29_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_exponent_0_i26_i_valid_out_1;
wire local_bb3_exponent_0_i26_i_stall_in_1;
 reg local_bb3_exponent_0_i26_i_consumed_1_NO_SHIFT_REG;
wire local_bb3_and2_or7_i29_i_inputs_ready;
wire local_bb3_and2_or7_i29_i_stall_local;
wire [63:0] local_bb3_and2_or7_i29_i;

assign local_bb3_and2_or7_i29_i_inputs_ready = local_bb3_div_valid_out_NO_SHIFT_REG;
assign local_bb3_and2_or7_i29_i = (local_bb3_cmp5_i28_i ? local_bb3_and2_i19_i : local_bb3_or7_i27_i);
assign local_bb3_and5_i43_i_valid_out = 1'b1;
assign local_bb3_and2_or7_i29_i_valid_out = 1'b1;
assign local_bb3_exponent_0_i26_i_valid_out_1 = 1'b1;
assign local_bb3_div_stall_in = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_and5_i43_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_and2_or7_i29_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_exponent_0_i26_i_consumed_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3_and5_i43_i_consumed_0_NO_SHIFT_REG <= (local_bb3_and2_or7_i29_i_inputs_ready & (local_bb3_and5_i43_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_and5_i43_i_stall_in)) & local_bb3_and2_or7_i29_i_stall_local);
		local_bb3_and2_or7_i29_i_consumed_0_NO_SHIFT_REG <= (local_bb3_and2_or7_i29_i_inputs_ready & (local_bb3_and2_or7_i29_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_and2_or7_i29_i_stall_in)) & local_bb3_and2_or7_i29_i_stall_local);
		local_bb3_exponent_0_i26_i_consumed_1_NO_SHIFT_REG <= (local_bb3_and2_or7_i29_i_inputs_ready & (local_bb3_exponent_0_i26_i_consumed_1_NO_SHIFT_REG | ~(local_bb3_exponent_0_i26_i_stall_in_1)) & local_bb3_and2_or7_i29_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_28to29_bb3_and5_i43_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and5_i43_i_0_stall_in_0_NO_SHIFT_REG;
 logic [63:0] rnode_28to29_bb3_and5_i43_i_0_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and5_i43_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and5_i43_i_0_stall_in_1_NO_SHIFT_REG;
 logic [63:0] rnode_28to29_bb3_and5_i43_i_1_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and5_i43_i_0_reg_29_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_28to29_bb3_and5_i43_i_0_reg_29_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and5_i43_i_0_valid_out_0_reg_29_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and5_i43_i_0_stall_in_0_reg_29_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and5_i43_i_0_stall_out_reg_29_NO_SHIFT_REG;

acl_data_fifo rnode_28to29_bb3_and5_i43_i_0_reg_29_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_28to29_bb3_and5_i43_i_0_reg_29_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_28to29_bb3_and5_i43_i_0_stall_in_0_reg_29_NO_SHIFT_REG),
	.valid_out(rnode_28to29_bb3_and5_i43_i_0_valid_out_0_reg_29_NO_SHIFT_REG),
	.stall_out(rnode_28to29_bb3_and5_i43_i_0_stall_out_reg_29_NO_SHIFT_REG),
	.data_in(local_bb3_and5_i43_i),
	.data_out(rnode_28to29_bb3_and5_i43_i_0_reg_29_NO_SHIFT_REG)
);

defparam rnode_28to29_bb3_and5_i43_i_0_reg_29_fifo.DEPTH = 1;
defparam rnode_28to29_bb3_and5_i43_i_0_reg_29_fifo.DATA_WIDTH = 64;
defparam rnode_28to29_bb3_and5_i43_i_0_reg_29_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_28to29_bb3_and5_i43_i_0_reg_29_fifo.IMPL = "shift_reg";

assign rnode_28to29_bb3_and5_i43_i_0_reg_29_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and5_i43_i_stall_in = 1'b0;
assign rnode_28to29_bb3_and5_i43_i_0_stall_in_0_reg_29_NO_SHIFT_REG = 1'b0;
assign rnode_28to29_bb3_and5_i43_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_28to29_bb3_and5_i43_i_0_NO_SHIFT_REG = rnode_28to29_bb3_and5_i43_i_0_reg_29_NO_SHIFT_REG;
assign rnode_28to29_bb3_and5_i43_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_28to29_bb3_and5_i43_i_1_NO_SHIFT_REG = rnode_28to29_bb3_and5_i43_i_0_reg_29_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_28to29_bb3_and2_or7_i29_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and2_or7_i29_i_0_stall_in_0_NO_SHIFT_REG;
 logic [63:0] rnode_28to29_bb3_and2_or7_i29_i_0_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and2_or7_i29_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and2_or7_i29_i_0_stall_in_1_NO_SHIFT_REG;
 logic [63:0] rnode_28to29_bb3_and2_or7_i29_i_1_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and2_or7_i29_i_0_reg_29_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_28to29_bb3_and2_or7_i29_i_0_reg_29_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and2_or7_i29_i_0_valid_out_0_reg_29_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and2_or7_i29_i_0_stall_in_0_reg_29_NO_SHIFT_REG;
 logic rnode_28to29_bb3_and2_or7_i29_i_0_stall_out_reg_29_NO_SHIFT_REG;

acl_data_fifo rnode_28to29_bb3_and2_or7_i29_i_0_reg_29_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_28to29_bb3_and2_or7_i29_i_0_reg_29_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_28to29_bb3_and2_or7_i29_i_0_stall_in_0_reg_29_NO_SHIFT_REG),
	.valid_out(rnode_28to29_bb3_and2_or7_i29_i_0_valid_out_0_reg_29_NO_SHIFT_REG),
	.stall_out(rnode_28to29_bb3_and2_or7_i29_i_0_stall_out_reg_29_NO_SHIFT_REG),
	.data_in(local_bb3_and2_or7_i29_i),
	.data_out(rnode_28to29_bb3_and2_or7_i29_i_0_reg_29_NO_SHIFT_REG)
);

defparam rnode_28to29_bb3_and2_or7_i29_i_0_reg_29_fifo.DEPTH = 1;
defparam rnode_28to29_bb3_and2_or7_i29_i_0_reg_29_fifo.DATA_WIDTH = 64;
defparam rnode_28to29_bb3_and2_or7_i29_i_0_reg_29_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_28to29_bb3_and2_or7_i29_i_0_reg_29_fifo.IMPL = "shift_reg";

assign rnode_28to29_bb3_and2_or7_i29_i_0_reg_29_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and2_or7_i29_i_stall_in = 1'b0;
assign rnode_28to29_bb3_and2_or7_i29_i_0_stall_in_0_reg_29_NO_SHIFT_REG = 1'b0;
assign rnode_28to29_bb3_and2_or7_i29_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_28to29_bb3_and2_or7_i29_i_0_NO_SHIFT_REG = rnode_28to29_bb3_and2_or7_i29_i_0_reg_29_NO_SHIFT_REG;
assign rnode_28to29_bb3_and2_or7_i29_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_28to29_bb3_and2_or7_i29_i_1_NO_SHIFT_REG = rnode_28to29_bb3_and2_or7_i29_i_0_reg_29_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_28to29_bb3_exponent_0_i26_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_28to29_bb3_exponent_0_i26_i_0_stall_in_0_NO_SHIFT_REG;
 logic [63:0] rnode_28to29_bb3_exponent_0_i26_i_0_NO_SHIFT_REG;
 logic rnode_28to29_bb3_exponent_0_i26_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_28to29_bb3_exponent_0_i26_i_0_stall_in_1_NO_SHIFT_REG;
 logic [63:0] rnode_28to29_bb3_exponent_0_i26_i_1_NO_SHIFT_REG;
 logic rnode_28to29_bb3_exponent_0_i26_i_0_reg_29_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_28to29_bb3_exponent_0_i26_i_0_reg_29_NO_SHIFT_REG;
 logic rnode_28to29_bb3_exponent_0_i26_i_0_valid_out_0_reg_29_NO_SHIFT_REG;
 logic rnode_28to29_bb3_exponent_0_i26_i_0_stall_in_0_reg_29_NO_SHIFT_REG;
 logic rnode_28to29_bb3_exponent_0_i26_i_0_stall_out_reg_29_NO_SHIFT_REG;

acl_data_fifo rnode_28to29_bb3_exponent_0_i26_i_0_reg_29_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_28to29_bb3_exponent_0_i26_i_0_reg_29_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_28to29_bb3_exponent_0_i26_i_0_stall_in_0_reg_29_NO_SHIFT_REG),
	.valid_out(rnode_28to29_bb3_exponent_0_i26_i_0_valid_out_0_reg_29_NO_SHIFT_REG),
	.stall_out(rnode_28to29_bb3_exponent_0_i26_i_0_stall_out_reg_29_NO_SHIFT_REG),
	.data_in(local_bb3_exponent_0_i26_i),
	.data_out(rnode_28to29_bb3_exponent_0_i26_i_0_reg_29_NO_SHIFT_REG)
);

defparam rnode_28to29_bb3_exponent_0_i26_i_0_reg_29_fifo.DEPTH = 1;
defparam rnode_28to29_bb3_exponent_0_i26_i_0_reg_29_fifo.DATA_WIDTH = 64;
defparam rnode_28to29_bb3_exponent_0_i26_i_0_reg_29_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_28to29_bb3_exponent_0_i26_i_0_reg_29_fifo.IMPL = "shift_reg";

assign rnode_28to29_bb3_exponent_0_i26_i_0_reg_29_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_exponent_0_i26_i_stall_in_1 = 1'b0;
assign rnode_28to29_bb3_exponent_0_i26_i_0_stall_in_0_reg_29_NO_SHIFT_REG = 1'b0;
assign rnode_28to29_bb3_exponent_0_i26_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_28to29_bb3_exponent_0_i26_i_0_NO_SHIFT_REG = rnode_28to29_bb3_exponent_0_i26_i_0_reg_29_NO_SHIFT_REG;
assign rnode_28to29_bb3_exponent_0_i26_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_28to29_bb3_exponent_0_i26_i_1_NO_SHIFT_REG = rnode_28to29_bb3_exponent_0_i26_i_0_reg_29_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_lnot_i_i_stall_local;
wire local_bb3_lnot_i_i;

assign local_bb3_lnot_i_i = (rnode_28to29_bb3_and5_i43_i_0_NO_SHIFT_REG == 64'h0);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_29to30_bb3_and5_i43_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and5_i43_i_0_stall_in_0_NO_SHIFT_REG;
 logic [63:0] rnode_29to30_bb3_and5_i43_i_0_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and5_i43_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and5_i43_i_0_stall_in_1_NO_SHIFT_REG;
 logic [63:0] rnode_29to30_bb3_and5_i43_i_1_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and5_i43_i_0_reg_30_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_29to30_bb3_and5_i43_i_0_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and5_i43_i_0_valid_out_0_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and5_i43_i_0_stall_in_0_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and5_i43_i_0_stall_out_reg_30_NO_SHIFT_REG;

acl_data_fifo rnode_29to30_bb3_and5_i43_i_0_reg_30_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_29to30_bb3_and5_i43_i_0_reg_30_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_29to30_bb3_and5_i43_i_0_stall_in_0_reg_30_NO_SHIFT_REG),
	.valid_out(rnode_29to30_bb3_and5_i43_i_0_valid_out_0_reg_30_NO_SHIFT_REG),
	.stall_out(rnode_29to30_bb3_and5_i43_i_0_stall_out_reg_30_NO_SHIFT_REG),
	.data_in(rnode_28to29_bb3_and5_i43_i_1_NO_SHIFT_REG),
	.data_out(rnode_29to30_bb3_and5_i43_i_0_reg_30_NO_SHIFT_REG)
);

defparam rnode_29to30_bb3_and5_i43_i_0_reg_30_fifo.DEPTH = 1;
defparam rnode_29to30_bb3_and5_i43_i_0_reg_30_fifo.DATA_WIDTH = 64;
defparam rnode_29to30_bb3_and5_i43_i_0_reg_30_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_29to30_bb3_and5_i43_i_0_reg_30_fifo.IMPL = "shift_reg";

assign rnode_29to30_bb3_and5_i43_i_0_reg_30_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_28to29_bb3_and5_i43_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3_and5_i43_i_0_stall_in_0_reg_30_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3_and5_i43_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_29to30_bb3_and5_i43_i_0_NO_SHIFT_REG = rnode_29to30_bb3_and5_i43_i_0_reg_30_NO_SHIFT_REG;
assign rnode_29to30_bb3_and5_i43_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_29to30_bb3_and5_i43_i_1_NO_SHIFT_REG = rnode_29to30_bb3_and5_i43_i_0_reg_30_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_and2_or7_op_i31_i_stall_local;
wire [63:0] local_bb3_and2_or7_op_i31_i;

assign local_bb3_and2_or7_op_i31_i = (rnode_28to29_bb3_and2_or7_i29_i_0_NO_SHIFT_REG << 64'h3);

// This section implements an unregistered operation.
// 
wire local_bb3_var__u28_stall_local;
wire [63:0] local_bb3_var__u28;

assign local_bb3_var__u28 = (rnode_28to29_bb3_and2_or7_i29_i_1_NO_SHIFT_REG >> 64'h19);

// This section implements an unregistered operation.
// 
wire local_bb3__tr1_i46_i_stall_local;
wire [31:0] local_bb3__tr1_i46_i;

assign local_bb3__tr1_i46_i = rnode_28to29_bb3_exponent_0_i26_i_0_NO_SHIFT_REG[31:0];

// This section implements an unregistered operation.
// 
wire local_bb3_var__u29_stall_local;
wire [63:0] local_bb3_var__u29;

assign local_bb3_var__u29 = (rnode_28to29_bb3_exponent_0_i26_i_1_NO_SHIFT_REG ^ rnode_28to29_bb3_or_i_shr4_i_i_1_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3__tr3_i_i_stall_local;
wire [31:0] local_bb3__tr3_i_i;

assign local_bb3__tr3_i_i = local_bb3_and2_or7_op_i31_i[31:0];

// This section implements an unregistered operation.
// 
wire local_bb3__tr58_i_stall_local;
wire [31:0] local_bb3__tr58_i;

assign local_bb3__tr58_i = local_bb3_var__u28[31:0];

// This section implements an unregistered operation.
// 
wire local_bb3_conv12_i_i_stall_local;
wire [31:0] local_bb3_conv12_i_i;

assign local_bb3_conv12_i_i = (local_bb3__tr1_i46_i & 32'hFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_var__u30_stall_local;
wire [63:0] local_bb3_var__u30;

assign local_bb3_var__u30 = (local_bb3_var__u29 & 64'h7FF);

// This section implements an unregistered operation.
// 
wire local_bb3_conv16_i_i_stall_local;
wire [31:0] local_bb3_conv16_i_i;

assign local_bb3_conv16_i_i = (local_bb3__tr3_i_i & 32'hFFFFFF8);

// This section implements an unregistered operation.
// 
wire local_bb3_conv22_i_i_stall_local;
wire [31:0] local_bb3_conv22_i_i;

assign local_bb3_conv22_i_i = (local_bb3__tr58_i & 32'hFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_conv12_i_i_valid_out_1;
wire local_bb3_conv12_i_i_stall_in_1;
 reg local_bb3_conv12_i_i_consumed_1_NO_SHIFT_REG;
wire local_bb3_sub_i_i_valid_out;
wire local_bb3_sub_i_i_stall_in;
 reg local_bb3_sub_i_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_conv_i45_i_valid_out_1;
wire local_bb3_conv_i45_i_stall_in_1;
 reg local_bb3_conv_i45_i_consumed_1_NO_SHIFT_REG;
wire local_bb3_sub_i_i_inputs_ready;
wire local_bb3_sub_i_i_stall_local;
wire [31:0] local_bb3_sub_i_i;

assign local_bb3_sub_i_i_inputs_ready = (rnode_28to29_bb3_exponent_0_i26_i_0_valid_out_0_NO_SHIFT_REG & rnode_28to29_bb3_or_i_shr4_i_i_0_valid_out_0_NO_SHIFT_REG);
assign local_bb3_sub_i_i = (local_bb3_conv_i45_i - local_bb3_conv12_i_i);
assign local_bb3_conv12_i_i_valid_out_1 = 1'b1;
assign local_bb3_sub_i_i_valid_out = 1'b1;
assign local_bb3_conv_i45_i_valid_out_1 = 1'b1;
assign rnode_28to29_bb3_exponent_0_i26_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_28to29_bb3_or_i_shr4_i_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_conv12_i_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb3_sub_i_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_conv_i45_i_consumed_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3_conv12_i_i_consumed_1_NO_SHIFT_REG <= (local_bb3_sub_i_i_inputs_ready & (local_bb3_conv12_i_i_consumed_1_NO_SHIFT_REG | ~(local_bb3_conv12_i_i_stall_in_1)) & local_bb3_sub_i_i_stall_local);
		local_bb3_sub_i_i_consumed_0_NO_SHIFT_REG <= (local_bb3_sub_i_i_inputs_ready & (local_bb3_sub_i_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_sub_i_i_stall_in)) & local_bb3_sub_i_i_stall_local);
		local_bb3_conv_i45_i_consumed_1_NO_SHIFT_REG <= (local_bb3_sub_i_i_inputs_ready & (local_bb3_conv_i45_i_consumed_1_NO_SHIFT_REG | ~(local_bb3_conv_i45_i_stall_in_1)) & local_bb3_sub_i_i_stall_local);
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3_cmp_i47_i_stall_local;
wire local_bb3_cmp_i47_i;

assign local_bb3_cmp_i47_i = (local_bb3_var__u30 == 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp40_i_i_stall_local;
wire local_bb3_cmp40_i_i;

assign local_bb3_cmp40_i_i = (local_bb3_conv16_i_i > local_bb3_conv14_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp46_i51_i_stall_local;
wire local_bb3_cmp46_i51_i;

assign local_bb3_cmp46_i51_i = (local_bb3_conv16_i_i == local_bb3_conv14_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp36_i_i_stall_local;
wire local_bb3_cmp36_i_i;

assign local_bb3_cmp36_i_i = (local_bb3_conv22_i_i > local_bb3_conv19_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp38_i_i_stall_local;
wire local_bb3_cmp38_i_i;

assign local_bb3_cmp38_i_i = (local_bb3_conv22_i_i == local_bb3_conv19_i_i);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_29to30_bb3_conv12_i_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_29to30_bb3_conv12_i_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_29to30_bb3_conv12_i_i_0_NO_SHIFT_REG;
 logic rnode_29to30_bb3_conv12_i_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_29to30_bb3_conv12_i_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_29to30_bb3_conv12_i_i_1_NO_SHIFT_REG;
 logic rnode_29to30_bb3_conv12_i_i_0_reg_30_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_29to30_bb3_conv12_i_i_0_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_conv12_i_i_0_valid_out_0_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_conv12_i_i_0_stall_in_0_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_conv12_i_i_0_stall_out_reg_30_NO_SHIFT_REG;

acl_data_fifo rnode_29to30_bb3_conv12_i_i_0_reg_30_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_29to30_bb3_conv12_i_i_0_reg_30_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_29to30_bb3_conv12_i_i_0_stall_in_0_reg_30_NO_SHIFT_REG),
	.valid_out(rnode_29to30_bb3_conv12_i_i_0_valid_out_0_reg_30_NO_SHIFT_REG),
	.stall_out(rnode_29to30_bb3_conv12_i_i_0_stall_out_reg_30_NO_SHIFT_REG),
	.data_in(local_bb3_conv12_i_i),
	.data_out(rnode_29to30_bb3_conv12_i_i_0_reg_30_NO_SHIFT_REG)
);

defparam rnode_29to30_bb3_conv12_i_i_0_reg_30_fifo.DEPTH = 1;
defparam rnode_29to30_bb3_conv12_i_i_0_reg_30_fifo.DATA_WIDTH = 32;
defparam rnode_29to30_bb3_conv12_i_i_0_reg_30_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_29to30_bb3_conv12_i_i_0_reg_30_fifo.IMPL = "shift_reg";

assign rnode_29to30_bb3_conv12_i_i_0_reg_30_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_conv12_i_i_stall_in_1 = 1'b0;
assign rnode_29to30_bb3_conv12_i_i_0_stall_in_0_reg_30_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3_conv12_i_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_29to30_bb3_conv12_i_i_0_NO_SHIFT_REG = rnode_29to30_bb3_conv12_i_i_0_reg_30_NO_SHIFT_REG;
assign rnode_29to30_bb3_conv12_i_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_29to30_bb3_conv12_i_i_1_NO_SHIFT_REG = rnode_29to30_bb3_conv12_i_i_0_reg_30_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_29to30_bb3_sub_i_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_29to30_bb3_sub_i_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_29to30_bb3_sub_i_i_0_NO_SHIFT_REG;
 logic rnode_29to30_bb3_sub_i_i_0_reg_30_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_29to30_bb3_sub_i_i_0_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_sub_i_i_0_valid_out_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_sub_i_i_0_stall_in_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_sub_i_i_0_stall_out_reg_30_NO_SHIFT_REG;

acl_data_fifo rnode_29to30_bb3_sub_i_i_0_reg_30_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_29to30_bb3_sub_i_i_0_reg_30_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_29to30_bb3_sub_i_i_0_stall_in_reg_30_NO_SHIFT_REG),
	.valid_out(rnode_29to30_bb3_sub_i_i_0_valid_out_reg_30_NO_SHIFT_REG),
	.stall_out(rnode_29to30_bb3_sub_i_i_0_stall_out_reg_30_NO_SHIFT_REG),
	.data_in(local_bb3_sub_i_i),
	.data_out(rnode_29to30_bb3_sub_i_i_0_reg_30_NO_SHIFT_REG)
);

defparam rnode_29to30_bb3_sub_i_i_0_reg_30_fifo.DEPTH = 1;
defparam rnode_29to30_bb3_sub_i_i_0_reg_30_fifo.DATA_WIDTH = 32;
defparam rnode_29to30_bb3_sub_i_i_0_reg_30_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_29to30_bb3_sub_i_i_0_reg_30_fifo.IMPL = "shift_reg";

assign rnode_29to30_bb3_sub_i_i_0_reg_30_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_sub_i_i_stall_in = 1'b0;
assign rnode_29to30_bb3_sub_i_i_0_NO_SHIFT_REG = rnode_29to30_bb3_sub_i_i_0_reg_30_NO_SHIFT_REG;
assign rnode_29to30_bb3_sub_i_i_0_stall_in_reg_30_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3_sub_i_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_29to30_bb3_conv_i45_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_29to30_bb3_conv_i45_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_29to30_bb3_conv_i45_i_0_NO_SHIFT_REG;
 logic rnode_29to30_bb3_conv_i45_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_29to30_bb3_conv_i45_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_29to30_bb3_conv_i45_i_1_NO_SHIFT_REG;
 logic rnode_29to30_bb3_conv_i45_i_0_reg_30_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_29to30_bb3_conv_i45_i_0_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_conv_i45_i_0_valid_out_0_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_conv_i45_i_0_stall_in_0_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_conv_i45_i_0_stall_out_reg_30_NO_SHIFT_REG;

acl_data_fifo rnode_29to30_bb3_conv_i45_i_0_reg_30_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_29to30_bb3_conv_i45_i_0_reg_30_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_29to30_bb3_conv_i45_i_0_stall_in_0_reg_30_NO_SHIFT_REG),
	.valid_out(rnode_29to30_bb3_conv_i45_i_0_valid_out_0_reg_30_NO_SHIFT_REG),
	.stall_out(rnode_29to30_bb3_conv_i45_i_0_stall_out_reg_30_NO_SHIFT_REG),
	.data_in(local_bb3_conv_i45_i),
	.data_out(rnode_29to30_bb3_conv_i45_i_0_reg_30_NO_SHIFT_REG)
);

defparam rnode_29to30_bb3_conv_i45_i_0_reg_30_fifo.DEPTH = 1;
defparam rnode_29to30_bb3_conv_i45_i_0_reg_30_fifo.DATA_WIDTH = 32;
defparam rnode_29to30_bb3_conv_i45_i_0_reg_30_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_29to30_bb3_conv_i45_i_0_reg_30_fifo.IMPL = "shift_reg";

assign rnode_29to30_bb3_conv_i45_i_0_reg_30_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_conv_i45_i_stall_in_1 = 1'b0;
assign rnode_29to30_bb3_conv_i45_i_0_stall_in_0_reg_30_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3_conv_i45_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_29to30_bb3_conv_i45_i_0_NO_SHIFT_REG = rnode_29to30_bb3_conv_i45_i_0_reg_30_NO_SHIFT_REG;
assign rnode_29to30_bb3_conv_i45_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_29to30_bb3_conv_i45_i_1_NO_SHIFT_REG = rnode_29to30_bb3_conv_i45_i_0_reg_30_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_or_cond_i31_stall_local;
wire local_bb3_or_cond_i31;

assign local_bb3_or_cond_i31 = (local_bb3_cmp46_i51_i & local_bb3_lnot_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_or_cond_i49_i_stall_local;
wire local_bb3_or_cond_i49_i;

assign local_bb3_or_cond_i49_i = (local_bb3_cmp38_i_i & local_bb3_cmp40_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp38_not_i_i_stall_local;
wire local_bb3_cmp38_not_i_i;

assign local_bb3_cmp38_not_i_i = (local_bb3_cmp38_i_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb3_and29_i_i_stall_local;
wire [31:0] local_bb3_and29_i_i;

assign local_bb3_and29_i_i = (rnode_29to30_bb3_sub_i_i_0_NO_SHIFT_REG & 32'h1000);

// This section implements an unregistered operation.
// 
wire local_bb3_brmerge_i50_i_stall_local;
wire local_bb3_brmerge_i50_i;

assign local_bb3_brmerge_i50_i = (local_bb3_or_cond_i49_i | local_bb3_cmp38_not_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_not_tobool30_i_i_stall_local;
wire local_bb3_not_tobool30_i_i;

assign local_bb3_not_tobool30_i_i = (local_bb3_and29_i_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3___i32_stall_local;
wire local_bb3___i32;

assign local_bb3___i32 = (local_bb3_brmerge_i50_i ? local_bb3_or_cond_i49_i : local_bb3_or_cond_i31);

// This section implements an unregistered operation.
// 
wire local_bb3__60_i_stall_local;
wire local_bb3__60_i;

assign local_bb3__60_i = (local_bb3_cmp36_i_i | local_bb3___i32);

// This section implements an unregistered operation.
// 
wire local_bb3__61_i_valid_out;
wire local_bb3__61_i_stall_in;
 reg local_bb3__61_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_and2_or7_op_i31_i_valid_out_1;
wire local_bb3_and2_or7_op_i31_i_stall_in_1;
 reg local_bb3_and2_or7_op_i31_i_consumed_1_NO_SHIFT_REG;
wire local_bb3_and2_or7_op_i_i_valid_out_1;
wire local_bb3_and2_or7_op_i_i_stall_in_1;
 reg local_bb3_and2_or7_op_i_i_consumed_1_NO_SHIFT_REG;
wire local_bb3__61_i_inputs_ready;
wire local_bb3__61_i_stall_local;
wire local_bb3__61_i;

assign local_bb3__61_i_inputs_ready = (rnode_28to29_bb3_and5_i43_i_0_valid_out_0_NO_SHIFT_REG & rnode_28to29_bb3_and2_or7_i29_i_0_valid_out_0_NO_SHIFT_REG & rnode_28to29_bb3_and2_or7_i29_i_0_valid_out_1_NO_SHIFT_REG & rnode_28to29_bb3_exponent_0_i26_i_0_valid_out_1_NO_SHIFT_REG & rnode_28to29_bb3_or_i_shr4_i_i_0_valid_out_1_NO_SHIFT_REG & rnode_28to29_bb3_and2_or7_i_i_0_valid_out_0_NO_SHIFT_REG & rnode_28to29_bb3_and2_or7_i_i_0_valid_out_1_NO_SHIFT_REG);
assign local_bb3__61_i = (local_bb3_cmp_i47_i & local_bb3__60_i);
assign local_bb3__61_i_valid_out = 1'b1;
assign local_bb3_and2_or7_op_i31_i_valid_out_1 = 1'b1;
assign local_bb3_and2_or7_op_i_i_valid_out_1 = 1'b1;
assign rnode_28to29_bb3_and5_i43_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_28to29_bb3_and2_or7_i29_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_28to29_bb3_and2_or7_i29_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_28to29_bb3_exponent_0_i26_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_28to29_bb3_or_i_shr4_i_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_28to29_bb3_and2_or7_i_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_28to29_bb3_and2_or7_i_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3__61_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_and2_or7_op_i31_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb3_and2_or7_op_i_i_consumed_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3__61_i_consumed_0_NO_SHIFT_REG <= (local_bb3__61_i_inputs_ready & (local_bb3__61_i_consumed_0_NO_SHIFT_REG | ~(local_bb3__61_i_stall_in)) & local_bb3__61_i_stall_local);
		local_bb3_and2_or7_op_i31_i_consumed_1_NO_SHIFT_REG <= (local_bb3__61_i_inputs_ready & (local_bb3_and2_or7_op_i31_i_consumed_1_NO_SHIFT_REG | ~(local_bb3_and2_or7_op_i31_i_stall_in_1)) & local_bb3__61_i_stall_local);
		local_bb3_and2_or7_op_i_i_consumed_1_NO_SHIFT_REG <= (local_bb3__61_i_inputs_ready & (local_bb3_and2_or7_op_i_i_consumed_1_NO_SHIFT_REG | ~(local_bb3_and2_or7_op_i_i_stall_in_1)) & local_bb3__61_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_29to30_bb3__61_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_29to30_bb3__61_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_29to30_bb3__61_i_0_NO_SHIFT_REG;
 logic rnode_29to30_bb3__61_i_0_reg_30_inputs_ready_NO_SHIFT_REG;
 logic rnode_29to30_bb3__61_i_0_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3__61_i_0_valid_out_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3__61_i_0_stall_in_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3__61_i_0_stall_out_reg_30_NO_SHIFT_REG;

acl_data_fifo rnode_29to30_bb3__61_i_0_reg_30_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_29to30_bb3__61_i_0_reg_30_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_29to30_bb3__61_i_0_stall_in_reg_30_NO_SHIFT_REG),
	.valid_out(rnode_29to30_bb3__61_i_0_valid_out_reg_30_NO_SHIFT_REG),
	.stall_out(rnode_29to30_bb3__61_i_0_stall_out_reg_30_NO_SHIFT_REG),
	.data_in(local_bb3__61_i),
	.data_out(rnode_29to30_bb3__61_i_0_reg_30_NO_SHIFT_REG)
);

defparam rnode_29to30_bb3__61_i_0_reg_30_fifo.DEPTH = 1;
defparam rnode_29to30_bb3__61_i_0_reg_30_fifo.DATA_WIDTH = 1;
defparam rnode_29to30_bb3__61_i_0_reg_30_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_29to30_bb3__61_i_0_reg_30_fifo.IMPL = "shift_reg";

assign rnode_29to30_bb3__61_i_0_reg_30_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3__61_i_stall_in = 1'b0;
assign rnode_29to30_bb3__61_i_0_NO_SHIFT_REG = rnode_29to30_bb3__61_i_0_reg_30_NO_SHIFT_REG;
assign rnode_29to30_bb3__61_i_0_stall_in_reg_30_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3__61_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_29to30_bb3_and2_or7_op_i31_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and2_or7_op_i31_i_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_29to30_bb3_and2_or7_op_i31_i_0_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and2_or7_op_i31_i_0_reg_30_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_29to30_bb3_and2_or7_op_i31_i_0_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and2_or7_op_i31_i_0_valid_out_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and2_or7_op_i31_i_0_stall_in_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and2_or7_op_i31_i_0_stall_out_reg_30_NO_SHIFT_REG;

acl_data_fifo rnode_29to30_bb3_and2_or7_op_i31_i_0_reg_30_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_29to30_bb3_and2_or7_op_i31_i_0_reg_30_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_29to30_bb3_and2_or7_op_i31_i_0_stall_in_reg_30_NO_SHIFT_REG),
	.valid_out(rnode_29to30_bb3_and2_or7_op_i31_i_0_valid_out_reg_30_NO_SHIFT_REG),
	.stall_out(rnode_29to30_bb3_and2_or7_op_i31_i_0_stall_out_reg_30_NO_SHIFT_REG),
	.data_in(local_bb3_and2_or7_op_i31_i),
	.data_out(rnode_29to30_bb3_and2_or7_op_i31_i_0_reg_30_NO_SHIFT_REG)
);

defparam rnode_29to30_bb3_and2_or7_op_i31_i_0_reg_30_fifo.DEPTH = 1;
defparam rnode_29to30_bb3_and2_or7_op_i31_i_0_reg_30_fifo.DATA_WIDTH = 64;
defparam rnode_29to30_bb3_and2_or7_op_i31_i_0_reg_30_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_29to30_bb3_and2_or7_op_i31_i_0_reg_30_fifo.IMPL = "shift_reg";

assign rnode_29to30_bb3_and2_or7_op_i31_i_0_reg_30_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and2_or7_op_i31_i_stall_in_1 = 1'b0;
assign rnode_29to30_bb3_and2_or7_op_i31_i_0_NO_SHIFT_REG = rnode_29to30_bb3_and2_or7_op_i31_i_0_reg_30_NO_SHIFT_REG;
assign rnode_29to30_bb3_and2_or7_op_i31_i_0_stall_in_reg_30_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3_and2_or7_op_i31_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_29to30_bb3_and2_or7_op_i_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and2_or7_op_i_i_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_29to30_bb3_and2_or7_op_i_i_0_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and2_or7_op_i_i_0_reg_30_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_29to30_bb3_and2_or7_op_i_i_0_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and2_or7_op_i_i_0_valid_out_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and2_or7_op_i_i_0_stall_in_reg_30_NO_SHIFT_REG;
 logic rnode_29to30_bb3_and2_or7_op_i_i_0_stall_out_reg_30_NO_SHIFT_REG;

acl_data_fifo rnode_29to30_bb3_and2_or7_op_i_i_0_reg_30_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_29to30_bb3_and2_or7_op_i_i_0_reg_30_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_29to30_bb3_and2_or7_op_i_i_0_stall_in_reg_30_NO_SHIFT_REG),
	.valid_out(rnode_29to30_bb3_and2_or7_op_i_i_0_valid_out_reg_30_NO_SHIFT_REG),
	.stall_out(rnode_29to30_bb3_and2_or7_op_i_i_0_stall_out_reg_30_NO_SHIFT_REG),
	.data_in(local_bb3_and2_or7_op_i_i),
	.data_out(rnode_29to30_bb3_and2_or7_op_i_i_0_reg_30_NO_SHIFT_REG)
);

defparam rnode_29to30_bb3_and2_or7_op_i_i_0_reg_30_fifo.DEPTH = 1;
defparam rnode_29to30_bb3_and2_or7_op_i_i_0_reg_30_fifo.DATA_WIDTH = 64;
defparam rnode_29to30_bb3_and2_or7_op_i_i_0_reg_30_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_29to30_bb3_and2_or7_op_i_i_0_reg_30_fifo.IMPL = "shift_reg";

assign rnode_29to30_bb3_and2_or7_op_i_i_0_reg_30_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and2_or7_op_i_i_stall_in_1 = 1'b0;
assign rnode_29to30_bb3_and2_or7_op_i_i_0_NO_SHIFT_REG = rnode_29to30_bb3_and2_or7_op_i_i_0_reg_30_NO_SHIFT_REG;
assign rnode_29to30_bb3_and2_or7_op_i_i_0_stall_in_reg_30_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3_and2_or7_op_i_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3__62_i_stall_local;
wire local_bb3__62_i;

assign local_bb3__62_i = (rnode_29to30_bb3__61_i_0_NO_SHIFT_REG | local_bb3_not_tobool30_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and9_i_i29_stall_local;
wire [63:0] local_bb3_and9_i_i29;

assign local_bb3_and9_i_i29 = (rnode_29to30_bb3_and2_or7_op_i31_i_0_NO_SHIFT_REG & 64'hFFFFFFFFFFFFF8);

// This section implements an unregistered operation.
// 
wire local_bb3_and8_i_i_stall_local;
wire [63:0] local_bb3_and8_i_i;

assign local_bb3_and8_i_i = (rnode_29to30_bb3_and2_or7_op_i_i_0_NO_SHIFT_REG & 64'hFFFFFFFFFFFFF8);

// This section implements an unregistered operation.
// 
wire local_bb3__64_i_stall_local;
wire [63:0] local_bb3__64_i;

assign local_bb3__64_i = (local_bb3__62_i ? rnode_28to30_bb3_and_i42_i_0_NO_SHIFT_REG : rnode_29to30_bb3_and5_i43_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3__65_i_stall_local;
wire [63:0] local_bb3__65_i;

assign local_bb3__65_i = (local_bb3__62_i ? rnode_29to30_bb3_and5_i43_i_1_NO_SHIFT_REG : rnode_28to30_bb3_and_i42_i_1_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3__67_i_stall_local;
wire [31:0] local_bb3__67_i;

assign local_bb3__67_i = (local_bb3__62_i ? rnode_29to30_bb3_conv12_i_i_0_NO_SHIFT_REG : rnode_29to30_bb3_conv_i45_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3__68_i_stall_local;
wire [31:0] local_bb3__68_i;

assign local_bb3__68_i = (local_bb3__62_i ? rnode_29to30_bb3_conv_i45_i_1_NO_SHIFT_REG : rnode_29to30_bb3_conv12_i_i_1_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3__63_i_stall_local;
wire [63:0] local_bb3__63_i;

assign local_bb3__63_i = (local_bb3__62_i ? local_bb3_and9_i_i29 : local_bb3_and8_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3__66_i_stall_local;
wire [63:0] local_bb3__66_i;

assign local_bb3__66_i = (local_bb3__62_i ? local_bb3_and8_i_i : local_bb3_and9_i_i29);

// This section implements an unregistered operation.
// 
wire local_bb3_sign_y_0_in_i_i_stall_local;
wire [7:0] local_bb3_sign_y_0_in_i_i;

assign local_bb3_sign_y_0_in_i_i = local_bb3__64_i[7:0];

// This section implements an unregistered operation.
// 
wire local_bb3_sign_x_0_in_i_i_stall_local;
wire [7:0] local_bb3_sign_x_0_in_i_i;

assign local_bb3_sign_x_0_in_i_i = local_bb3__65_i[7:0];

// This section implements an unregistered operation.
// 
wire local_bb3_and64_i53_i_stall_local;
wire [31:0] local_bb3_and64_i53_i;

assign local_bb3_and64_i53_i = (local_bb3__67_i & 32'h800);

// This section implements an unregistered operation.
// 
wire local_bb3_and67_i_i_stall_local;
wire [31:0] local_bb3_and67_i_i;

assign local_bb3_and67_i_i = (local_bb3__68_i & 32'h800);

// This section implements an unregistered operation.
// 
wire local_bb3_sub99_i_i_stall_local;
wire [31:0] local_bb3_sub99_i_i;

assign local_bb3_sub99_i_i = (local_bb3__67_i - local_bb3__68_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp74_i_i_stall_local;
wire local_bb3_cmp74_i_i;

assign local_bb3_cmp74_i_i = (local_bb3_sign_x_0_in_i_i == local_bb3_sign_y_0_in_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_tobool65_i_i_stall_local;
wire local_bb3_tobool65_i_i;

assign local_bb3_tobool65_i_i = (local_bb3_and64_i53_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_tobool68_i_not_i_stall_local;
wire local_bb3_tobool68_i_not_i;

assign local_bb3_tobool68_i_not_i = (local_bb3_and67_i_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_mantissa_x_1_i_i_stall_local;
wire [63:0] local_bb3_mantissa_x_1_i_i;

assign local_bb3_mantissa_x_1_i_i = (local_bb3_cmp74_i_i ? local_bb3__63_i : 64'hC0000000000000);

// This section implements an unregistered operation.
// 
wire local_bb3_not_tobool65_i_i_stall_local;
wire local_bb3_not_tobool65_i_i;

assign local_bb3_not_tobool65_i_i = (local_bb3_tobool65_i_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb3__72_i_stall_local;
wire [63:0] local_bb3__72_i;

assign local_bb3__72_i = (local_bb3_tobool65_i_i ? local_bb3__66_i : 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3__69_i_stall_local;
wire local_bb3__69_i;

assign local_bb3__69_i = (local_bb3_tobool68_i_not_i & local_bb3_not_tobool65_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3__70_i_stall_local;
wire [63:0] local_bb3__70_i;

assign local_bb3__70_i = (local_bb3__69_i ? local_bb3_mantissa_x_1_i_i : local_bb3__63_i);

// This section implements an unregistered operation.
// 
wire local_bb3__71_i_stall_local;
wire [63:0] local_bb3__71_i;

assign local_bb3__71_i = (local_bb3_tobool65_i_i ? local_bb3__63_i : local_bb3__70_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and846_i_i_stall_local;
wire [63:0] local_bb3_and846_i_i;

assign local_bb3_and846_i_i = (local_bb3__72_i ^ local_bb3__71_i);

// This section implements an unregistered operation.
// 
wire local_bb3_xor_i54_i_stall_local;
wire [63:0] local_bb3_xor_i54_i;

assign local_bb3_xor_i54_i = (local_bb3_and846_i_i >> 64'h37);

// This section implements an unregistered operation.
// 
wire local_bb3_xor_tr_i_i_stall_local;
wire [31:0] local_bb3_xor_tr_i_i;

assign local_bb3_xor_tr_i_i = local_bb3_xor_i54_i[31:0];

// This section implements an unregistered operation.
// 
wire local_bb3_conv101_i_i_stall_local;
wire [31:0] local_bb3_conv101_i_i;

assign local_bb3_conv101_i_i = (local_bb3_xor_tr_i_i & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb3_sub102_i_i_stall_local;
wire [31:0] local_bb3_sub102_i_i;

assign local_bb3_sub102_i_i = (local_bb3_sub99_i_i - local_bb3_conv101_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and108_i_i_stall_local;
wire [31:0] local_bb3_and108_i_i;

assign local_bb3_and108_i_i = (local_bb3_sub102_i_i & 32'h7C0);

// This section implements an unregistered operation.
// 
wire local_bb3_diff_0_in_op_i_i_stall_local;
wire [31:0] local_bb3_diff_0_in_op_i_i;

assign local_bb3_diff_0_in_op_i_i = (local_bb3_sub102_i_i & 32'h3F);

// This section implements an unregistered operation.
// 
wire local_bb3_tobool109_i_i_stall_local;
wire local_bb3_tobool109_i_i;

assign local_bb3_tobool109_i_i = (local_bb3_and108_i_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3__64_i_valid_out_1;
wire local_bb3__64_i_stall_in_1;
 reg local_bb3__64_i_consumed_1_NO_SHIFT_REG;
wire local_bb3__65_i_valid_out_1;
wire local_bb3__65_i_stall_in_1;
 reg local_bb3__65_i_consumed_1_NO_SHIFT_REG;
wire local_bb3__71_i_valid_out_1;
wire local_bb3__71_i_stall_in_1;
 reg local_bb3__71_i_consumed_1_NO_SHIFT_REG;
wire local_bb3__72_i_valid_out_1;
wire local_bb3__72_i_stall_in_1;
 reg local_bb3__72_i_consumed_1_NO_SHIFT_REG;
wire local_bb3__67_i_valid_out_2;
wire local_bb3__67_i_stall_in_2;
 reg local_bb3__67_i_consumed_2_NO_SHIFT_REG;
wire local_bb3_and64_i53_i_valid_out_1;
wire local_bb3_and64_i53_i_stall_in_1;
 reg local_bb3_and64_i53_i_consumed_1_NO_SHIFT_REG;
wire local_bb3_and110_i_i_valid_out;
wire local_bb3_and110_i_i_stall_in;
 reg local_bb3_and110_i_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_and110_i_i_inputs_ready;
wire local_bb3_and110_i_i_stall_local;
wire [31:0] local_bb3_and110_i_i;

assign local_bb3_and110_i_i_inputs_ready = (rnode_28to30_bb3_and_i42_i_0_valid_out_0_NO_SHIFT_REG & rnode_29to30_bb3_and5_i43_i_0_valid_out_0_NO_SHIFT_REG & rnode_28to30_bb3_and_i42_i_0_valid_out_1_NO_SHIFT_REG & rnode_29to30_bb3_and5_i43_i_0_valid_out_1_NO_SHIFT_REG & rnode_29to30_bb3_and2_or7_op_i31_i_0_valid_out_NO_SHIFT_REG & rnode_29to30_bb3_and2_or7_op_i_i_0_valid_out_NO_SHIFT_REG & rnode_29to30_bb3__61_i_0_valid_out_NO_SHIFT_REG & rnode_29to30_bb3_conv12_i_i_0_valid_out_0_NO_SHIFT_REG & rnode_29to30_bb3_conv_i45_i_0_valid_out_0_NO_SHIFT_REG & rnode_29to30_bb3_conv_i45_i_0_valid_out_1_NO_SHIFT_REG & rnode_29to30_bb3_conv12_i_i_0_valid_out_1_NO_SHIFT_REG & rnode_29to30_bb3_sub_i_i_0_valid_out_NO_SHIFT_REG);
assign local_bb3_and110_i_i = (local_bb3_tobool109_i_i ? 32'h3F : local_bb3_diff_0_in_op_i_i);
assign local_bb3__64_i_valid_out_1 = 1'b1;
assign local_bb3__65_i_valid_out_1 = 1'b1;
assign local_bb3__71_i_valid_out_1 = 1'b1;
assign local_bb3__72_i_valid_out_1 = 1'b1;
assign local_bb3__67_i_valid_out_2 = 1'b1;
assign local_bb3_and64_i53_i_valid_out_1 = 1'b1;
assign local_bb3_and110_i_i_valid_out = 1'b1;
assign rnode_28to30_bb3_and_i42_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3_and5_i43_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_28to30_bb3_and_i42_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3_and5_i43_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3_and2_or7_op_i31_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3_and2_or7_op_i_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3__61_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3_conv12_i_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3_conv_i45_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3_conv_i45_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3_conv12_i_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_29to30_bb3_sub_i_i_0_stall_in_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3__64_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb3__65_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb3__71_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb3__72_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb3__67_i_consumed_2_NO_SHIFT_REG <= 1'b0;
		local_bb3_and64_i53_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb3_and110_i_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3__64_i_consumed_1_NO_SHIFT_REG <= (local_bb3_and110_i_i_inputs_ready & (local_bb3__64_i_consumed_1_NO_SHIFT_REG | ~(local_bb3__64_i_stall_in_1)) & local_bb3_and110_i_i_stall_local);
		local_bb3__65_i_consumed_1_NO_SHIFT_REG <= (local_bb3_and110_i_i_inputs_ready & (local_bb3__65_i_consumed_1_NO_SHIFT_REG | ~(local_bb3__65_i_stall_in_1)) & local_bb3_and110_i_i_stall_local);
		local_bb3__71_i_consumed_1_NO_SHIFT_REG <= (local_bb3_and110_i_i_inputs_ready & (local_bb3__71_i_consumed_1_NO_SHIFT_REG | ~(local_bb3__71_i_stall_in_1)) & local_bb3_and110_i_i_stall_local);
		local_bb3__72_i_consumed_1_NO_SHIFT_REG <= (local_bb3_and110_i_i_inputs_ready & (local_bb3__72_i_consumed_1_NO_SHIFT_REG | ~(local_bb3__72_i_stall_in_1)) & local_bb3_and110_i_i_stall_local);
		local_bb3__67_i_consumed_2_NO_SHIFT_REG <= (local_bb3_and110_i_i_inputs_ready & (local_bb3__67_i_consumed_2_NO_SHIFT_REG | ~(local_bb3__67_i_stall_in_2)) & local_bb3_and110_i_i_stall_local);
		local_bb3_and64_i53_i_consumed_1_NO_SHIFT_REG <= (local_bb3_and110_i_i_inputs_ready & (local_bb3_and64_i53_i_consumed_1_NO_SHIFT_REG | ~(local_bb3_and64_i53_i_stall_in_1)) & local_bb3_and110_i_i_stall_local);
		local_bb3_and110_i_i_consumed_0_NO_SHIFT_REG <= (local_bb3_and110_i_i_inputs_ready & (local_bb3_and110_i_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_and110_i_i_stall_in)) & local_bb3_and110_i_i_stall_local);
	end
end


// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_30to32_bb3__64_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_30to32_bb3__64_i_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_30to32_bb3__64_i_0_NO_SHIFT_REG;
 logic rnode_30to32_bb3__64_i_0_reg_32_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_30to32_bb3__64_i_0_reg_32_NO_SHIFT_REG;
 logic rnode_30to32_bb3__64_i_0_valid_out_reg_32_NO_SHIFT_REG;
 logic rnode_30to32_bb3__64_i_0_stall_in_reg_32_NO_SHIFT_REG;
 logic rnode_30to32_bb3__64_i_0_stall_out_reg_32_NO_SHIFT_REG;

acl_data_fifo rnode_30to32_bb3__64_i_0_reg_32_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_30to32_bb3__64_i_0_reg_32_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_30to32_bb3__64_i_0_stall_in_reg_32_NO_SHIFT_REG),
	.valid_out(rnode_30to32_bb3__64_i_0_valid_out_reg_32_NO_SHIFT_REG),
	.stall_out(rnode_30to32_bb3__64_i_0_stall_out_reg_32_NO_SHIFT_REG),
	.data_in(local_bb3__64_i),
	.data_out(rnode_30to32_bb3__64_i_0_reg_32_NO_SHIFT_REG)
);

defparam rnode_30to32_bb3__64_i_0_reg_32_fifo.DEPTH = 2;
defparam rnode_30to32_bb3__64_i_0_reg_32_fifo.DATA_WIDTH = 64;
defparam rnode_30to32_bb3__64_i_0_reg_32_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_30to32_bb3__64_i_0_reg_32_fifo.IMPL = "shift_reg";

assign rnode_30to32_bb3__64_i_0_reg_32_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3__64_i_stall_in_1 = 1'b0;
assign rnode_30to32_bb3__64_i_0_NO_SHIFT_REG = rnode_30to32_bb3__64_i_0_reg_32_NO_SHIFT_REG;
assign rnode_30to32_bb3__64_i_0_stall_in_reg_32_NO_SHIFT_REG = 1'b0;
assign rnode_30to32_bb3__64_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_30to32_bb3__65_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_30to32_bb3__65_i_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_30to32_bb3__65_i_0_NO_SHIFT_REG;
 logic rnode_30to32_bb3__65_i_0_reg_32_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_30to32_bb3__65_i_0_reg_32_NO_SHIFT_REG;
 logic rnode_30to32_bb3__65_i_0_valid_out_reg_32_NO_SHIFT_REG;
 logic rnode_30to32_bb3__65_i_0_stall_in_reg_32_NO_SHIFT_REG;
 logic rnode_30to32_bb3__65_i_0_stall_out_reg_32_NO_SHIFT_REG;

acl_data_fifo rnode_30to32_bb3__65_i_0_reg_32_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_30to32_bb3__65_i_0_reg_32_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_30to32_bb3__65_i_0_stall_in_reg_32_NO_SHIFT_REG),
	.valid_out(rnode_30to32_bb3__65_i_0_valid_out_reg_32_NO_SHIFT_REG),
	.stall_out(rnode_30to32_bb3__65_i_0_stall_out_reg_32_NO_SHIFT_REG),
	.data_in(local_bb3__65_i),
	.data_out(rnode_30to32_bb3__65_i_0_reg_32_NO_SHIFT_REG)
);

defparam rnode_30to32_bb3__65_i_0_reg_32_fifo.DEPTH = 2;
defparam rnode_30to32_bb3__65_i_0_reg_32_fifo.DATA_WIDTH = 64;
defparam rnode_30to32_bb3__65_i_0_reg_32_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_30to32_bb3__65_i_0_reg_32_fifo.IMPL = "shift_reg";

assign rnode_30to32_bb3__65_i_0_reg_32_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3__65_i_stall_in_1 = 1'b0;
assign rnode_30to32_bb3__65_i_0_NO_SHIFT_REG = rnode_30to32_bb3__65_i_0_reg_32_NO_SHIFT_REG;
assign rnode_30to32_bb3__65_i_0_stall_in_reg_32_NO_SHIFT_REG = 1'b0;
assign rnode_30to32_bb3__65_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_30to32_bb3__71_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_30to32_bb3__71_i_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_30to32_bb3__71_i_0_NO_SHIFT_REG;
 logic rnode_30to32_bb3__71_i_0_reg_32_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_30to32_bb3__71_i_0_reg_32_NO_SHIFT_REG;
 logic rnode_30to32_bb3__71_i_0_valid_out_reg_32_NO_SHIFT_REG;
 logic rnode_30to32_bb3__71_i_0_stall_in_reg_32_NO_SHIFT_REG;
 logic rnode_30to32_bb3__71_i_0_stall_out_reg_32_NO_SHIFT_REG;

acl_data_fifo rnode_30to32_bb3__71_i_0_reg_32_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_30to32_bb3__71_i_0_reg_32_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_30to32_bb3__71_i_0_stall_in_reg_32_NO_SHIFT_REG),
	.valid_out(rnode_30to32_bb3__71_i_0_valid_out_reg_32_NO_SHIFT_REG),
	.stall_out(rnode_30to32_bb3__71_i_0_stall_out_reg_32_NO_SHIFT_REG),
	.data_in(local_bb3__71_i),
	.data_out(rnode_30to32_bb3__71_i_0_reg_32_NO_SHIFT_REG)
);

defparam rnode_30to32_bb3__71_i_0_reg_32_fifo.DEPTH = 2;
defparam rnode_30to32_bb3__71_i_0_reg_32_fifo.DATA_WIDTH = 64;
defparam rnode_30to32_bb3__71_i_0_reg_32_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_30to32_bb3__71_i_0_reg_32_fifo.IMPL = "shift_reg";

assign rnode_30to32_bb3__71_i_0_reg_32_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3__71_i_stall_in_1 = 1'b0;
assign rnode_30to32_bb3__71_i_0_NO_SHIFT_REG = rnode_30to32_bb3__71_i_0_reg_32_NO_SHIFT_REG;
assign rnode_30to32_bb3__71_i_0_stall_in_reg_32_NO_SHIFT_REG = 1'b0;
assign rnode_30to32_bb3__71_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_30to31_bb3__72_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_30to31_bb3__72_i_0_stall_in_0_NO_SHIFT_REG;
 logic [63:0] rnode_30to31_bb3__72_i_0_NO_SHIFT_REG;
 logic rnode_30to31_bb3__72_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_30to31_bb3__72_i_0_stall_in_1_NO_SHIFT_REG;
 logic [63:0] rnode_30to31_bb3__72_i_1_NO_SHIFT_REG;
 logic rnode_30to31_bb3__72_i_0_reg_31_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_30to31_bb3__72_i_0_reg_31_NO_SHIFT_REG;
 logic rnode_30to31_bb3__72_i_0_valid_out_0_reg_31_NO_SHIFT_REG;
 logic rnode_30to31_bb3__72_i_0_stall_in_0_reg_31_NO_SHIFT_REG;
 logic rnode_30to31_bb3__72_i_0_stall_out_reg_31_NO_SHIFT_REG;

acl_data_fifo rnode_30to31_bb3__72_i_0_reg_31_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_30to31_bb3__72_i_0_reg_31_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_30to31_bb3__72_i_0_stall_in_0_reg_31_NO_SHIFT_REG),
	.valid_out(rnode_30to31_bb3__72_i_0_valid_out_0_reg_31_NO_SHIFT_REG),
	.stall_out(rnode_30to31_bb3__72_i_0_stall_out_reg_31_NO_SHIFT_REG),
	.data_in(local_bb3__72_i),
	.data_out(rnode_30to31_bb3__72_i_0_reg_31_NO_SHIFT_REG)
);

defparam rnode_30to31_bb3__72_i_0_reg_31_fifo.DEPTH = 1;
defparam rnode_30to31_bb3__72_i_0_reg_31_fifo.DATA_WIDTH = 64;
defparam rnode_30to31_bb3__72_i_0_reg_31_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_30to31_bb3__72_i_0_reg_31_fifo.IMPL = "shift_reg";

assign rnode_30to31_bb3__72_i_0_reg_31_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3__72_i_stall_in_1 = 1'b0;
assign rnode_30to31_bb3__72_i_0_stall_in_0_reg_31_NO_SHIFT_REG = 1'b0;
assign rnode_30to31_bb3__72_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_30to31_bb3__72_i_0_NO_SHIFT_REG = rnode_30to31_bb3__72_i_0_reg_31_NO_SHIFT_REG;
assign rnode_30to31_bb3__72_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_30to31_bb3__72_i_1_NO_SHIFT_REG = rnode_30to31_bb3__72_i_0_reg_31_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_30to31_bb3__67_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_30to31_bb3__67_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_30to31_bb3__67_i_0_NO_SHIFT_REG;
 logic rnode_30to31_bb3__67_i_0_reg_31_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_30to31_bb3__67_i_0_reg_31_NO_SHIFT_REG;
 logic rnode_30to31_bb3__67_i_0_valid_out_reg_31_NO_SHIFT_REG;
 logic rnode_30to31_bb3__67_i_0_stall_in_reg_31_NO_SHIFT_REG;
 logic rnode_30to31_bb3__67_i_0_stall_out_reg_31_NO_SHIFT_REG;

acl_data_fifo rnode_30to31_bb3__67_i_0_reg_31_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_30to31_bb3__67_i_0_reg_31_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_30to31_bb3__67_i_0_stall_in_reg_31_NO_SHIFT_REG),
	.valid_out(rnode_30to31_bb3__67_i_0_valid_out_reg_31_NO_SHIFT_REG),
	.stall_out(rnode_30to31_bb3__67_i_0_stall_out_reg_31_NO_SHIFT_REG),
	.data_in(local_bb3__67_i),
	.data_out(rnode_30to31_bb3__67_i_0_reg_31_NO_SHIFT_REG)
);

defparam rnode_30to31_bb3__67_i_0_reg_31_fifo.DEPTH = 1;
defparam rnode_30to31_bb3__67_i_0_reg_31_fifo.DATA_WIDTH = 32;
defparam rnode_30to31_bb3__67_i_0_reg_31_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_30to31_bb3__67_i_0_reg_31_fifo.IMPL = "shift_reg";

assign rnode_30to31_bb3__67_i_0_reg_31_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3__67_i_stall_in_2 = 1'b0;
assign rnode_30to31_bb3__67_i_0_NO_SHIFT_REG = rnode_30to31_bb3__67_i_0_reg_31_NO_SHIFT_REG;
assign rnode_30to31_bb3__67_i_0_stall_in_reg_31_NO_SHIFT_REG = 1'b0;
assign rnode_30to31_bb3__67_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_30to31_bb3_and64_i53_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and64_i53_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_30to31_bb3_and64_i53_i_0_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and64_i53_i_0_reg_31_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_30to31_bb3_and64_i53_i_0_reg_31_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and64_i53_i_0_valid_out_reg_31_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and64_i53_i_0_stall_in_reg_31_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and64_i53_i_0_stall_out_reg_31_NO_SHIFT_REG;

acl_data_fifo rnode_30to31_bb3_and64_i53_i_0_reg_31_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_30to31_bb3_and64_i53_i_0_reg_31_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_30to31_bb3_and64_i53_i_0_stall_in_reg_31_NO_SHIFT_REG),
	.valid_out(rnode_30to31_bb3_and64_i53_i_0_valid_out_reg_31_NO_SHIFT_REG),
	.stall_out(rnode_30to31_bb3_and64_i53_i_0_stall_out_reg_31_NO_SHIFT_REG),
	.data_in(local_bb3_and64_i53_i),
	.data_out(rnode_30to31_bb3_and64_i53_i_0_reg_31_NO_SHIFT_REG)
);

defparam rnode_30to31_bb3_and64_i53_i_0_reg_31_fifo.DEPTH = 1;
defparam rnode_30to31_bb3_and64_i53_i_0_reg_31_fifo.DATA_WIDTH = 32;
defparam rnode_30to31_bb3_and64_i53_i_0_reg_31_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_30to31_bb3_and64_i53_i_0_reg_31_fifo.IMPL = "shift_reg";

assign rnode_30to31_bb3_and64_i53_i_0_reg_31_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and64_i53_i_stall_in_1 = 1'b0;
assign rnode_30to31_bb3_and64_i53_i_0_NO_SHIFT_REG = rnode_30to31_bb3_and64_i53_i_0_reg_31_NO_SHIFT_REG;
assign rnode_30to31_bb3_and64_i53_i_0_stall_in_reg_31_NO_SHIFT_REG = 1'b0;
assign rnode_30to31_bb3_and64_i53_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_30to31_bb3_and110_i_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and110_i_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_30to31_bb3_and110_i_i_0_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and110_i_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and110_i_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_30to31_bb3_and110_i_i_1_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and110_i_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and110_i_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_30to31_bb3_and110_i_i_2_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and110_i_i_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and110_i_i_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_30to31_bb3_and110_i_i_3_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and110_i_i_0_valid_out_4_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and110_i_i_0_stall_in_4_NO_SHIFT_REG;
 logic [31:0] rnode_30to31_bb3_and110_i_i_4_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and110_i_i_0_valid_out_5_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and110_i_i_0_stall_in_5_NO_SHIFT_REG;
 logic [31:0] rnode_30to31_bb3_and110_i_i_5_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and110_i_i_0_reg_31_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_30to31_bb3_and110_i_i_0_reg_31_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and110_i_i_0_valid_out_0_reg_31_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and110_i_i_0_stall_in_0_reg_31_NO_SHIFT_REG;
 logic rnode_30to31_bb3_and110_i_i_0_stall_out_reg_31_NO_SHIFT_REG;

acl_data_fifo rnode_30to31_bb3_and110_i_i_0_reg_31_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_30to31_bb3_and110_i_i_0_reg_31_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_30to31_bb3_and110_i_i_0_stall_in_0_reg_31_NO_SHIFT_REG),
	.valid_out(rnode_30to31_bb3_and110_i_i_0_valid_out_0_reg_31_NO_SHIFT_REG),
	.stall_out(rnode_30to31_bb3_and110_i_i_0_stall_out_reg_31_NO_SHIFT_REG),
	.data_in(local_bb3_and110_i_i),
	.data_out(rnode_30to31_bb3_and110_i_i_0_reg_31_NO_SHIFT_REG)
);

defparam rnode_30to31_bb3_and110_i_i_0_reg_31_fifo.DEPTH = 1;
defparam rnode_30to31_bb3_and110_i_i_0_reg_31_fifo.DATA_WIDTH = 32;
defparam rnode_30to31_bb3_and110_i_i_0_reg_31_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_30to31_bb3_and110_i_i_0_reg_31_fifo.IMPL = "shift_reg";

assign rnode_30to31_bb3_and110_i_i_0_reg_31_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and110_i_i_stall_in = 1'b0;
assign rnode_30to31_bb3_and110_i_i_0_stall_in_0_reg_31_NO_SHIFT_REG = 1'b0;
assign rnode_30to31_bb3_and110_i_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_30to31_bb3_and110_i_i_0_NO_SHIFT_REG = rnode_30to31_bb3_and110_i_i_0_reg_31_NO_SHIFT_REG;
assign rnode_30to31_bb3_and110_i_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_30to31_bb3_and110_i_i_1_NO_SHIFT_REG = rnode_30to31_bb3_and110_i_i_0_reg_31_NO_SHIFT_REG;
assign rnode_30to31_bb3_and110_i_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_30to31_bb3_and110_i_i_2_NO_SHIFT_REG = rnode_30to31_bb3_and110_i_i_0_reg_31_NO_SHIFT_REG;
assign rnode_30to31_bb3_and110_i_i_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_30to31_bb3_and110_i_i_3_NO_SHIFT_REG = rnode_30to31_bb3_and110_i_i_0_reg_31_NO_SHIFT_REG;
assign rnode_30to31_bb3_and110_i_i_0_valid_out_4_NO_SHIFT_REG = 1'b1;
assign rnode_30to31_bb3_and110_i_i_4_NO_SHIFT_REG = rnode_30to31_bb3_and110_i_i_0_reg_31_NO_SHIFT_REG;
assign rnode_30to31_bb3_and110_i_i_0_valid_out_5_NO_SHIFT_REG = 1'b1;
assign rnode_30to31_bb3_and110_i_i_5_NO_SHIFT_REG = rnode_30to31_bb3_and110_i_i_0_reg_31_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_var__u31_stall_local;
wire [31:0] local_bb3_var__u31;

assign local_bb3_var__u31 = rnode_30to32_bb3__64_i_0_NO_SHIFT_REG[31:0];

// This section implements an unregistered operation.
// 
wire local_bb3_var__u32_stall_local;
wire [31:0] local_bb3_var__u32;

assign local_bb3_var__u32 = rnode_30to32_bb3__65_i_0_NO_SHIFT_REG[31:0];

// This section implements an unregistered operation.
// 
wire local_bb3_and_i37_i_stall_local;
wire [63:0] local_bb3_and_i37_i;

assign local_bb3_and_i37_i = (rnode_30to32_bb3__71_i_0_NO_SHIFT_REG & 64'hFFFFFFFFFFFFF8);

// This section implements an unregistered operation.
// 
wire local_bb3_and114_i_i_stall_local;
wire [63:0] local_bb3_and114_i_i;

assign local_bb3_and114_i_i = (rnode_30to31_bb3__72_i_0_NO_SHIFT_REG & 64'hFFFFFFF8);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_31to32_bb3__67_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_31to32_bb3__67_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_31to32_bb3__67_i_0_NO_SHIFT_REG;
 logic rnode_31to32_bb3__67_i_0_reg_32_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_31to32_bb3__67_i_0_reg_32_NO_SHIFT_REG;
 logic rnode_31to32_bb3__67_i_0_valid_out_reg_32_NO_SHIFT_REG;
 logic rnode_31to32_bb3__67_i_0_stall_in_reg_32_NO_SHIFT_REG;
 logic rnode_31to32_bb3__67_i_0_stall_out_reg_32_NO_SHIFT_REG;

acl_data_fifo rnode_31to32_bb3__67_i_0_reg_32_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_31to32_bb3__67_i_0_reg_32_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_31to32_bb3__67_i_0_stall_in_reg_32_NO_SHIFT_REG),
	.valid_out(rnode_31to32_bb3__67_i_0_valid_out_reg_32_NO_SHIFT_REG),
	.stall_out(rnode_31to32_bb3__67_i_0_stall_out_reg_32_NO_SHIFT_REG),
	.data_in(rnode_30to31_bb3__67_i_0_NO_SHIFT_REG),
	.data_out(rnode_31to32_bb3__67_i_0_reg_32_NO_SHIFT_REG)
);

defparam rnode_31to32_bb3__67_i_0_reg_32_fifo.DEPTH = 1;
defparam rnode_31to32_bb3__67_i_0_reg_32_fifo.DATA_WIDTH = 32;
defparam rnode_31to32_bb3__67_i_0_reg_32_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_31to32_bb3__67_i_0_reg_32_fifo.IMPL = "shift_reg";

assign rnode_31to32_bb3__67_i_0_reg_32_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_30to31_bb3__67_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_31to32_bb3__67_i_0_NO_SHIFT_REG = rnode_31to32_bb3__67_i_0_reg_32_NO_SHIFT_REG;
assign rnode_31to32_bb3__67_i_0_stall_in_reg_32_NO_SHIFT_REG = 1'b0;
assign rnode_31to32_bb3__67_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_31to32_bb3_and64_i53_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_31to32_bb3_and64_i53_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_31to32_bb3_and64_i53_i_0_NO_SHIFT_REG;
 logic rnode_31to32_bb3_and64_i53_i_0_reg_32_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_31to32_bb3_and64_i53_i_0_reg_32_NO_SHIFT_REG;
 logic rnode_31to32_bb3_and64_i53_i_0_valid_out_reg_32_NO_SHIFT_REG;
 logic rnode_31to32_bb3_and64_i53_i_0_stall_in_reg_32_NO_SHIFT_REG;
 logic rnode_31to32_bb3_and64_i53_i_0_stall_out_reg_32_NO_SHIFT_REG;

acl_data_fifo rnode_31to32_bb3_and64_i53_i_0_reg_32_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_31to32_bb3_and64_i53_i_0_reg_32_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_31to32_bb3_and64_i53_i_0_stall_in_reg_32_NO_SHIFT_REG),
	.valid_out(rnode_31to32_bb3_and64_i53_i_0_valid_out_reg_32_NO_SHIFT_REG),
	.stall_out(rnode_31to32_bb3_and64_i53_i_0_stall_out_reg_32_NO_SHIFT_REG),
	.data_in(rnode_30to31_bb3_and64_i53_i_0_NO_SHIFT_REG),
	.data_out(rnode_31to32_bb3_and64_i53_i_0_reg_32_NO_SHIFT_REG)
);

defparam rnode_31to32_bb3_and64_i53_i_0_reg_32_fifo.DEPTH = 1;
defparam rnode_31to32_bb3_and64_i53_i_0_reg_32_fifo.DATA_WIDTH = 32;
defparam rnode_31to32_bb3_and64_i53_i_0_reg_32_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_31to32_bb3_and64_i53_i_0_reg_32_fifo.IMPL = "shift_reg";

assign rnode_31to32_bb3_and64_i53_i_0_reg_32_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_30to31_bb3_and64_i53_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_31to32_bb3_and64_i53_i_0_NO_SHIFT_REG = rnode_31to32_bb3_and64_i53_i_0_reg_32_NO_SHIFT_REG;
assign rnode_31to32_bb3_and64_i53_i_0_stall_in_reg_32_NO_SHIFT_REG = 1'b0;
assign rnode_31to32_bb3_and64_i53_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_and111_i_i_stall_local;
wire [31:0] local_bb3_and111_i_i;

assign local_bb3_and111_i_i = (rnode_30to31_bb3_and110_i_i_0_NO_SHIFT_REG & 32'h20);

// This section implements an unregistered operation.
// 
wire local_bb3_and122_i_i_stall_local;
wire [31:0] local_bb3_and122_i_i;

assign local_bb3_and122_i_i = (rnode_30to31_bb3_and110_i_i_1_NO_SHIFT_REG & 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb3_and134_i_i_stall_local;
wire [31:0] local_bb3_and134_i_i;

assign local_bb3_and134_i_i = (rnode_30to31_bb3_and110_i_i_2_NO_SHIFT_REG & 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb3_and147_i_i_stall_local;
wire [31:0] local_bb3_and147_i_i;

assign local_bb3_and147_i_i = (rnode_30to31_bb3_and110_i_i_3_NO_SHIFT_REG & 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb3_and160_i_i_stall_local;
wire [31:0] local_bb3_and160_i_i;

assign local_bb3_and160_i_i = (rnode_30to31_bb3_and110_i_i_4_NO_SHIFT_REG & 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb3_and173_i_i_stall_local;
wire [31:0] local_bb3_and173_i_i;

assign local_bb3_and173_i_i = (rnode_30to31_bb3_and110_i_i_5_NO_SHIFT_REG & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb3_shl198_i_i_stall_local;
wire [31:0] local_bb3_shl198_i_i;

assign local_bb3_shl198_i_i = (local_bb3_var__u31 << 32'hC);

// This section implements an unregistered operation.
// 
wire local_bb3_shl_i57_i_stall_local;
wire [31:0] local_bb3_shl_i57_i;

assign local_bb3_shl_i57_i = (local_bb3_var__u32 << 32'hC);

// This section implements an unregistered operation.
// 
wire local_bb3_tobool115_i_i_stall_local;
wire local_bb3_tobool115_i_i;

assign local_bb3_tobool115_i_i = (local_bb3_and114_i_i != 64'h0);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_32to33_bb3__67_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_32to33_bb3__67_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_32to33_bb3__67_i_0_NO_SHIFT_REG;
 logic rnode_32to33_bb3__67_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_32to33_bb3__67_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_32to33_bb3__67_i_1_NO_SHIFT_REG;
 logic rnode_32to33_bb3__67_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_32to33_bb3__67_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_32to33_bb3__67_i_2_NO_SHIFT_REG;
 logic rnode_32to33_bb3__67_i_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_32to33_bb3__67_i_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_32to33_bb3__67_i_3_NO_SHIFT_REG;
 logic rnode_32to33_bb3__67_i_0_reg_33_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_32to33_bb3__67_i_0_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3__67_i_0_valid_out_0_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3__67_i_0_stall_in_0_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3__67_i_0_stall_out_reg_33_NO_SHIFT_REG;

acl_data_fifo rnode_32to33_bb3__67_i_0_reg_33_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_32to33_bb3__67_i_0_reg_33_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_32to33_bb3__67_i_0_stall_in_0_reg_33_NO_SHIFT_REG),
	.valid_out(rnode_32to33_bb3__67_i_0_valid_out_0_reg_33_NO_SHIFT_REG),
	.stall_out(rnode_32to33_bb3__67_i_0_stall_out_reg_33_NO_SHIFT_REG),
	.data_in(rnode_31to32_bb3__67_i_0_NO_SHIFT_REG),
	.data_out(rnode_32to33_bb3__67_i_0_reg_33_NO_SHIFT_REG)
);

defparam rnode_32to33_bb3__67_i_0_reg_33_fifo.DEPTH = 1;
defparam rnode_32to33_bb3__67_i_0_reg_33_fifo.DATA_WIDTH = 32;
defparam rnode_32to33_bb3__67_i_0_reg_33_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_32to33_bb3__67_i_0_reg_33_fifo.IMPL = "shift_reg";

assign rnode_32to33_bb3__67_i_0_reg_33_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_31to32_bb3__67_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3__67_i_0_stall_in_0_reg_33_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3__67_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3__67_i_0_NO_SHIFT_REG = rnode_32to33_bb3__67_i_0_reg_33_NO_SHIFT_REG;
assign rnode_32to33_bb3__67_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3__67_i_1_NO_SHIFT_REG = rnode_32to33_bb3__67_i_0_reg_33_NO_SHIFT_REG;
assign rnode_32to33_bb3__67_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3__67_i_2_NO_SHIFT_REG = rnode_32to33_bb3__67_i_0_reg_33_NO_SHIFT_REG;
assign rnode_32to33_bb3__67_i_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3__67_i_3_NO_SHIFT_REG = rnode_32to33_bb3__67_i_0_reg_33_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_32to33_bb3_and64_i53_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_32to33_bb3_and64_i53_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_32to33_bb3_and64_i53_i_0_NO_SHIFT_REG;
 logic rnode_32to33_bb3_and64_i53_i_0_reg_33_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_32to33_bb3_and64_i53_i_0_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3_and64_i53_i_0_valid_out_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3_and64_i53_i_0_stall_in_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3_and64_i53_i_0_stall_out_reg_33_NO_SHIFT_REG;

acl_data_fifo rnode_32to33_bb3_and64_i53_i_0_reg_33_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_32to33_bb3_and64_i53_i_0_reg_33_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_32to33_bb3_and64_i53_i_0_stall_in_reg_33_NO_SHIFT_REG),
	.valid_out(rnode_32to33_bb3_and64_i53_i_0_valid_out_reg_33_NO_SHIFT_REG),
	.stall_out(rnode_32to33_bb3_and64_i53_i_0_stall_out_reg_33_NO_SHIFT_REG),
	.data_in(rnode_31to32_bb3_and64_i53_i_0_NO_SHIFT_REG),
	.data_out(rnode_32to33_bb3_and64_i53_i_0_reg_33_NO_SHIFT_REG)
);

defparam rnode_32to33_bb3_and64_i53_i_0_reg_33_fifo.DEPTH = 1;
defparam rnode_32to33_bb3_and64_i53_i_0_reg_33_fifo.DATA_WIDTH = 32;
defparam rnode_32to33_bb3_and64_i53_i_0_reg_33_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_32to33_bb3_and64_i53_i_0_reg_33_fifo.IMPL = "shift_reg";

assign rnode_32to33_bb3_and64_i53_i_0_reg_33_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_31to32_bb3_and64_i53_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_and64_i53_i_0_NO_SHIFT_REG = rnode_32to33_bb3_and64_i53_i_0_reg_33_NO_SHIFT_REG;
assign rnode_32to33_bb3_and64_i53_i_0_stall_in_reg_33_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_and64_i53_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_tobool112_i_i_stall_local;
wire local_bb3_tobool112_i_i;

assign local_bb3_tobool112_i_i = (local_bb3_and111_i_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_sh_prom_i55_i_stall_local;
wire [63:0] local_bb3_sh_prom_i55_i;

assign local_bb3_sh_prom_i55_i[63:32] = 32'h0;
assign local_bb3_sh_prom_i55_i[31:0] = local_bb3_and111_i_i;

// This section implements an unregistered operation.
// 
wire local_bb3_tobool123_i_i_stall_local;
wire local_bb3_tobool123_i_i;

assign local_bb3_tobool123_i_i = (local_bb3_and122_i_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_sh_prom132_i_i_stall_local;
wire [63:0] local_bb3_sh_prom132_i_i;

assign local_bb3_sh_prom132_i_i[63:32] = 32'h0;
assign local_bb3_sh_prom132_i_i[31:0] = local_bb3_and122_i_i;

// This section implements an unregistered operation.
// 
wire local_bb3_tobool135_i_i_stall_local;
wire local_bb3_tobool135_i_i;

assign local_bb3_tobool135_i_i = (local_bb3_and134_i_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_sh_prom145_i_i_stall_local;
wire [63:0] local_bb3_sh_prom145_i_i;

assign local_bb3_sh_prom145_i_i[63:32] = 32'h0;
assign local_bb3_sh_prom145_i_i[31:0] = local_bb3_and134_i_i;

// This section implements an unregistered operation.
// 
wire local_bb3_tobool148_i_i_stall_local;
wire local_bb3_tobool148_i_i;

assign local_bb3_tobool148_i_i = (local_bb3_and147_i_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_sh_prom158_i_i_stall_local;
wire [63:0] local_bb3_sh_prom158_i_i;

assign local_bb3_sh_prom158_i_i[63:32] = 32'h0;
assign local_bb3_sh_prom158_i_i[31:0] = local_bb3_and147_i_i;

// This section implements an unregistered operation.
// 
wire local_bb3_tobool161_i_i_stall_local;
wire local_bb3_tobool161_i_i;

assign local_bb3_tobool161_i_i = (local_bb3_and160_i_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_sh_prom171_i_i_stall_local;
wire [63:0] local_bb3_sh_prom171_i_i;

assign local_bb3_sh_prom171_i_i[63:32] = 32'h0;
assign local_bb3_sh_prom171_i_i[31:0] = local_bb3_and160_i_i;

// This section implements an unregistered operation.
// 
wire local_bb3_sh_prom184_i_i_stall_local;
wire [63:0] local_bb3_sh_prom184_i_i;

assign local_bb3_sh_prom184_i_i[63:32] = 32'h0;
assign local_bb3_sh_prom184_i_i[31:0] = local_bb3_and173_i_i;

// This section implements an unregistered operation.
// 
wire local_bb3_tobool174_i_i_stall_local;
wire local_bb3_tobool174_i_i;

assign local_bb3_tobool174_i_i = (local_bb3_and173_i_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_and23_i59_i_stall_local;
wire [31:0] local_bb3_and23_i59_i;

assign local_bb3_and23_i59_i = (local_bb3_shl_i57_i ^ local_bb3_shl198_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_tobool10_i_i_stall_local;
wire local_bb3_tobool10_i_i;

assign local_bb3_tobool10_i_i = (local_bb3_shl198_i_i != local_bb3_shl_i57_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cond116_i_i_stall_local;
wire [63:0] local_bb3_cond116_i_i;

assign local_bb3_cond116_i_i[63:1] = 63'h0;
assign local_bb3_cond116_i_i[0] = local_bb3_tobool115_i_i;

// This section implements an unregistered operation.
// 
wire local_bb3_and20_i_i_stall_local;
wire [31:0] local_bb3_and20_i_i;

assign local_bb3_and20_i_i = (rnode_32to33_bb3__67_i_0_NO_SHIFT_REG & 32'h7FF);

// This section implements an unregistered operation.
// 
wire local_bb3_and7_i_i_stall_local;
wire [31:0] local_bb3_and7_i_i;

assign local_bb3_and7_i_i = (rnode_32to33_bb3__67_i_1_NO_SHIFT_REG & 32'h7C0);

// This section implements an unregistered operation.
// 
wire local_bb3_sub25_i_i_stall_local;
wire [31:0] local_bb3_sub25_i_i;

assign local_bb3_sub25_i_i = (rnode_32to33_bb3__67_i_2_NO_SHIFT_REG + 32'h3F);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_33to34_bb3__67_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_33to34_bb3__67_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_33to34_bb3__67_i_0_NO_SHIFT_REG;
 logic rnode_33to34_bb3__67_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_33to34_bb3__67_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_33to34_bb3__67_i_1_NO_SHIFT_REG;
 logic rnode_33to34_bb3__67_i_0_reg_34_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_33to34_bb3__67_i_0_reg_34_NO_SHIFT_REG;
 logic rnode_33to34_bb3__67_i_0_valid_out_0_reg_34_NO_SHIFT_REG;
 logic rnode_33to34_bb3__67_i_0_stall_in_0_reg_34_NO_SHIFT_REG;
 logic rnode_33to34_bb3__67_i_0_stall_out_reg_34_NO_SHIFT_REG;

acl_data_fifo rnode_33to34_bb3__67_i_0_reg_34_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_33to34_bb3__67_i_0_reg_34_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_33to34_bb3__67_i_0_stall_in_0_reg_34_NO_SHIFT_REG),
	.valid_out(rnode_33to34_bb3__67_i_0_valid_out_0_reg_34_NO_SHIFT_REG),
	.stall_out(rnode_33to34_bb3__67_i_0_stall_out_reg_34_NO_SHIFT_REG),
	.data_in(rnode_32to33_bb3__67_i_3_NO_SHIFT_REG),
	.data_out(rnode_33to34_bb3__67_i_0_reg_34_NO_SHIFT_REG)
);

defparam rnode_33to34_bb3__67_i_0_reg_34_fifo.DEPTH = 1;
defparam rnode_33to34_bb3__67_i_0_reg_34_fifo.DATA_WIDTH = 32;
defparam rnode_33to34_bb3__67_i_0_reg_34_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_33to34_bb3__67_i_0_reg_34_fifo.IMPL = "shift_reg";

assign rnode_33to34_bb3__67_i_0_reg_34_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3__67_i_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_33to34_bb3__67_i_0_stall_in_0_reg_34_NO_SHIFT_REG = 1'b0;
assign rnode_33to34_bb3__67_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_33to34_bb3__67_i_0_NO_SHIFT_REG = rnode_33to34_bb3__67_i_0_reg_34_NO_SHIFT_REG;
assign rnode_33to34_bb3__67_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_33to34_bb3__67_i_1_NO_SHIFT_REG = rnode_33to34_bb3__67_i_0_reg_34_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_tobool15_i_i_stall_local;
wire local_bb3_tobool15_i_i;

assign local_bb3_tobool15_i_i = (rnode_32to33_bb3_and64_i53_i_0_NO_SHIFT_REG != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_shr121_i_i_stall_local;
wire [63:0] local_bb3_shr121_i_i;

assign local_bb3_shr121_i_i = (rnode_30to31_bb3__72_i_1_NO_SHIFT_REG >> local_bb3_sh_prom_i55_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and23_i_i_stall_local;
wire [63:0] local_bb3_and23_i_i;

assign local_bb3_and23_i_i[63:32] = 32'h0;
assign local_bb3_and23_i_i[31:0] = local_bb3_and23_i59_i;

// This section implements an unregistered operation.
// 
wire local_bb3_cond_i39_i_stall_local;
wire [63:0] local_bb3_cond_i39_i;

assign local_bb3_cond_i39_i = (local_bb3_tobool10_i_i ? 64'h1FFFFFFFFFFFFFF : 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3__73_i_stall_local;
wire [63:0] local_bb3__73_i;

assign local_bb3__73_i = (local_bb3_tobool112_i_i ? 64'h0 : local_bb3_cond116_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp21_i_i_stall_local;
wire local_bb3_cmp21_i_i;

assign local_bb3_cmp21_i_i = (local_bb3_and20_i_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp46_i_i_stall_local;
wire local_bb3_cmp46_i_i;

assign local_bb3_cmp46_i_i = (local_bb3_and20_i_i == 32'h7FF);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp_i12_i_stall_local;
wire local_bb3_cmp_i12_i;

assign local_bb3_cmp_i12_i = (local_bb3_and7_i_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_and26_i_i_stall_local;
wire [31:0] local_bb3_and26_i_i;

assign local_bb3_and26_i_i = (local_bb3_sub25_i_i & 32'h3F);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp41_i_i_stall_local;
wire local_bb3_cmp41_i_i;

assign local_bb3_cmp41_i_i = (rnode_33to34_bb3__67_i_0_NO_SHIFT_REG == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_and125_i_i_stall_local;
wire [63:0] local_bb3_and125_i_i;

assign local_bb3_and125_i_i = (local_bb3_shr121_i_i & 64'hFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_shr133_i_i_stall_local;
wire [63:0] local_bb3_shr133_i_i;

assign local_bb3_shr133_i_i = (local_bb3_shr121_i_i >> local_bb3_sh_prom132_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_xor_lobit_i_i_stall_local;
wire [63:0] local_bb3_xor_lobit_i_i;

assign local_bb3_xor_lobit_i_i = (local_bb3_and23_i_i >> 64'hC);

// This section implements an unregistered operation.
// 
wire local_bb3_or_cond_i13_not_demorgan_i_stall_local;
wire local_bb3_or_cond_i13_not_demorgan_i;

assign local_bb3_or_cond_i13_not_demorgan_i = (local_bb3_tobool15_i_i | local_bb3_cmp21_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cond_i_i_stall_local;
wire [31:0] local_bb3_cond_i_i;

assign local_bb3_cond_i_i = (local_bb3_cmp_i12_i ? 32'h3F : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_var__u33_stall_local;
wire [31:0] local_bb3_var__u33;

assign local_bb3_var__u33 = (local_bb3_cmp41_i_i ? 32'h2 : 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb3_tobool126_i_i_stall_local;
wire local_bb3_tobool126_i_i;

assign local_bb3_tobool126_i_i = (local_bb3_and125_i_i != 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_and137_i_i_stall_local;
wire [63:0] local_bb3_and137_i_i;

assign local_bb3_and137_i_i = (local_bb3_shr133_i_i & 64'hFF);

// This section implements an unregistered operation.
// 
wire local_bb3_shr146_i_i_stall_local;
wire [63:0] local_bb3_shr146_i_i;

assign local_bb3_shr146_i_i = (local_bb3_shr133_i_i >> local_bb3_sh_prom145_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_add_i40_i_stall_local;
wire [63:0] local_bb3_add_i40_i;

assign local_bb3_add_i40_i = (local_bb3_and_i37_i | local_bb3_xor_lobit_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_or27_i_i_stall_local;
wire [31:0] local_bb3_or27_i_i;

assign local_bb3_or27_i_i = (local_bb3_cond_i_i | local_bb3_and26_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cond127_i_i_stall_local;
wire [63:0] local_bb3_cond127_i_i;

assign local_bb3_cond127_i_i[63:1] = 63'h0;
assign local_bb3_cond127_i_i[0] = local_bb3_tobool126_i_i;

// This section implements an unregistered operation.
// 
wire local_bb3_tobool138_i_i_stall_local;
wire local_bb3_tobool138_i_i;

assign local_bb3_tobool138_i_i = (local_bb3_and137_i_i != 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_and150_i_i_stall_local;
wire [63:0] local_bb3_and150_i_i;

assign local_bb3_and150_i_i = (local_bb3_shr146_i_i & 64'hF);

// This section implements an unregistered operation.
// 
wire local_bb3_shr159_i_i_stall_local;
wire [63:0] local_bb3_shr159_i_i;

assign local_bb3_shr159_i_i = (local_bb3_shr146_i_i >> local_bb3_sh_prom158_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3__78_i_stall_local;
wire [31:0] local_bb3__78_i;

assign local_bb3__78_i = (local_bb3_or_cond_i13_not_demorgan_i ? 32'h0 : local_bb3_or27_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3__74_i_stall_local;
wire [63:0] local_bb3__74_i;

assign local_bb3__74_i = (local_bb3_tobool123_i_i ? 64'h0 : local_bb3_cond127_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cond139_i_i_stall_local;
wire [63:0] local_bb3_cond139_i_i;

assign local_bb3_cond139_i_i[63:1] = 63'h0;
assign local_bb3_cond139_i_i[0] = local_bb3_tobool138_i_i;

// This section implements an unregistered operation.
// 
wire local_bb3_tobool151_i_i_stall_local;
wire local_bb3_tobool151_i_i;

assign local_bb3_tobool151_i_i = (local_bb3_and150_i_i != 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_and163_i_i_stall_local;
wire [63:0] local_bb3_and163_i_i;

assign local_bb3_and163_i_i = (local_bb3_shr159_i_i & 64'h3);

// This section implements an unregistered operation.
// 
wire local_bb3_shr172_i_i_stall_local;
wire [63:0] local_bb3_shr172_i_i;

assign local_bb3_shr172_i_i = (local_bb3_shr159_i_i >> local_bb3_sh_prom171_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_reduction_1_i34_stall_local;
wire [63:0] local_bb3_reduction_1_i34;

assign local_bb3_reduction_1_i34 = (local_bb3__73_i | local_bb3__74_i);

// This section implements an unregistered operation.
// 
wire local_bb3__75_i_stall_local;
wire [63:0] local_bb3__75_i;

assign local_bb3__75_i = (local_bb3_tobool135_i_i ? 64'h0 : local_bb3_cond139_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cond152_i_i_stall_local;
wire [63:0] local_bb3_cond152_i_i;

assign local_bb3_cond152_i_i[63:1] = 63'h0;
assign local_bb3_cond152_i_i[0] = local_bb3_tobool151_i_i;

// This section implements an unregistered operation.
// 
wire local_bb3_tobool164_i_i_stall_local;
wire local_bb3_tobool164_i_i;

assign local_bb3_tobool164_i_i = (local_bb3_and163_i_i != 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_shr185_i_i_stall_local;
wire [63:0] local_bb3_shr185_i_i;

assign local_bb3_shr185_i_i = (local_bb3_shr172_i_i >> local_bb3_sh_prom184_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and176_i_i_stall_local;
wire [63:0] local_bb3_and176_i_i;

assign local_bb3_and176_i_i = (local_bb3_shr172_i_i & 64'h1);

// This section implements an unregistered operation.
// 
wire local_bb3__76_i_stall_local;
wire [63:0] local_bb3__76_i;

assign local_bb3__76_i = (local_bb3_tobool148_i_i ? 64'h0 : local_bb3_cond152_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cond165_i_i_stall_local;
wire [63:0] local_bb3_cond165_i_i;

assign local_bb3_cond165_i_i[63:1] = 63'h0;
assign local_bb3_cond165_i_i[0] = local_bb3_tobool164_i_i;

// This section implements an unregistered operation.
// 
wire local_bb3_shr185_i_masked_i_stall_local;
wire [63:0] local_bb3_shr185_i_masked_i;

assign local_bb3_shr185_i_masked_i = (local_bb3_shr185_i_i & 64'hFFFFFFFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_cond179_i_i_stall_local;
wire [63:0] local_bb3_cond179_i_i;

assign local_bb3_cond179_i_i = (local_bb3_tobool174_i_i ? 64'h0 : local_bb3_and176_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_reduction_2_i35_stall_local;
wire [63:0] local_bb3_reduction_2_i35;

assign local_bb3_reduction_2_i35 = (local_bb3__75_i | local_bb3__76_i);

// This section implements an unregistered operation.
// 
wire local_bb3__77_i_stall_local;
wire [63:0] local_bb3__77_i;

assign local_bb3__77_i = (local_bb3_tobool161_i_i ? 64'h0 : local_bb3_cond165_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_reduction_0_i33_stall_local;
wire [63:0] local_bb3_reduction_0_i33;

assign local_bb3_reduction_0_i33 = (local_bb3_cond179_i_i | local_bb3_shr185_i_masked_i);

// This section implements an unregistered operation.
// 
wire local_bb3_reduction_4_i37_stall_local;
wire [63:0] local_bb3_reduction_4_i37;

assign local_bb3_reduction_4_i37 = (local_bb3_reduction_1_i34 | local_bb3_reduction_2_i35);

// This section implements an unregistered operation.
// 
wire local_bb3_reduction_3_i36_stall_local;
wire [63:0] local_bb3_reduction_3_i36;

assign local_bb3_reduction_3_i36 = (local_bb3__77_i | local_bb3_reduction_0_i33);

// This section implements an unregistered operation.
// 
wire local_bb3_reduction_5_i38_valid_out;
wire local_bb3_reduction_5_i38_stall_in;
wire local_bb3_reduction_5_i38_inputs_ready;
wire local_bb3_reduction_5_i38_stall_local;
wire [63:0] local_bb3_reduction_5_i38;

assign local_bb3_reduction_5_i38_inputs_ready = (rnode_30to31_bb3__72_i_0_valid_out_0_NO_SHIFT_REG & rnode_30to31_bb3__72_i_0_valid_out_1_NO_SHIFT_REG & rnode_30to31_bb3_and110_i_i_0_valid_out_0_NO_SHIFT_REG & rnode_30to31_bb3_and110_i_i_0_valid_out_1_NO_SHIFT_REG & rnode_30to31_bb3_and110_i_i_0_valid_out_2_NO_SHIFT_REG & rnode_30to31_bb3_and110_i_i_0_valid_out_3_NO_SHIFT_REG & rnode_30to31_bb3_and110_i_i_0_valid_out_4_NO_SHIFT_REG & rnode_30to31_bb3_and110_i_i_0_valid_out_5_NO_SHIFT_REG);
assign local_bb3_reduction_5_i38 = (local_bb3_reduction_3_i36 | local_bb3_reduction_4_i37);
assign local_bb3_reduction_5_i38_valid_out = 1'b1;
assign rnode_30to31_bb3__72_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_30to31_bb3__72_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_30to31_bb3_and110_i_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_30to31_bb3_and110_i_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_30to31_bb3_and110_i_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_30to31_bb3_and110_i_i_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_30to31_bb3_and110_i_i_0_stall_in_4_NO_SHIFT_REG = 1'b0;
assign rnode_30to31_bb3_and110_i_i_0_stall_in_5_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_31to32_bb3_reduction_5_i38_0_valid_out_NO_SHIFT_REG;
 logic rnode_31to32_bb3_reduction_5_i38_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_31to32_bb3_reduction_5_i38_0_NO_SHIFT_REG;
 logic rnode_31to32_bb3_reduction_5_i38_0_reg_32_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_31to32_bb3_reduction_5_i38_0_reg_32_NO_SHIFT_REG;
 logic rnode_31to32_bb3_reduction_5_i38_0_valid_out_reg_32_NO_SHIFT_REG;
 logic rnode_31to32_bb3_reduction_5_i38_0_stall_in_reg_32_NO_SHIFT_REG;
 logic rnode_31to32_bb3_reduction_5_i38_0_stall_out_reg_32_NO_SHIFT_REG;

acl_data_fifo rnode_31to32_bb3_reduction_5_i38_0_reg_32_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_31to32_bb3_reduction_5_i38_0_reg_32_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_31to32_bb3_reduction_5_i38_0_stall_in_reg_32_NO_SHIFT_REG),
	.valid_out(rnode_31to32_bb3_reduction_5_i38_0_valid_out_reg_32_NO_SHIFT_REG),
	.stall_out(rnode_31to32_bb3_reduction_5_i38_0_stall_out_reg_32_NO_SHIFT_REG),
	.data_in(local_bb3_reduction_5_i38),
	.data_out(rnode_31to32_bb3_reduction_5_i38_0_reg_32_NO_SHIFT_REG)
);

defparam rnode_31to32_bb3_reduction_5_i38_0_reg_32_fifo.DEPTH = 1;
defparam rnode_31to32_bb3_reduction_5_i38_0_reg_32_fifo.DATA_WIDTH = 64;
defparam rnode_31to32_bb3_reduction_5_i38_0_reg_32_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_31to32_bb3_reduction_5_i38_0_reg_32_fifo.IMPL = "shift_reg";

assign rnode_31to32_bb3_reduction_5_i38_0_reg_32_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_reduction_5_i38_stall_in = 1'b0;
assign rnode_31to32_bb3_reduction_5_i38_0_NO_SHIFT_REG = rnode_31to32_bb3_reduction_5_i38_0_reg_32_NO_SHIFT_REG;
assign rnode_31to32_bb3_reduction_5_i38_0_stall_in_reg_32_NO_SHIFT_REG = 1'b0;
assign rnode_31to32_bb3_reduction_5_i38_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_xor14_i_i_stall_local;
wire [63:0] local_bb3_xor14_i_i;

assign local_bb3_xor14_i_i = (rnode_31to32_bb3_reduction_5_i38_0_NO_SHIFT_REG ^ local_bb3_cond_i39_i);

// This section implements an unregistered operation.
// 
wire local_bb3_add19_i_i_stall_local;
wire [63:0] local_bb3_add19_i_i;

assign local_bb3_add19_i_i = (local_bb3_add_i40_i + local_bb3_xor14_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and_i_i_i_stall_local;
wire [63:0] local_bb3_and_i_i_i;

assign local_bb3_and_i_i_i = (local_bb3_add19_i_i & 64'hFFFF0000000000);

// This section implements an unregistered operation.
// 
wire local_bb3_and2_i_i_i_stall_local;
wire [63:0] local_bb3_and2_i_i_i;

assign local_bb3_and2_i_i_i = (local_bb3_add19_i_i & 64'hFFFF000000);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp_i_i_i_stall_local;
wire local_bb3_cmp_i_i_i;

assign local_bb3_cmp_i_i_i = (local_bb3_and_i_i_i != 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_shl_i57_i_valid_out_2;
wire local_bb3_shl_i57_i_stall_in_2;
 reg local_bb3_shl_i57_i_consumed_2_NO_SHIFT_REG;
wire local_bb3_add19_i_i_valid_out_2;
wire local_bb3_add19_i_i_stall_in_2;
 reg local_bb3_add19_i_i_consumed_2_NO_SHIFT_REG;
wire local_bb3_cmp_i_i_i_valid_out;
wire local_bb3_cmp_i_i_i_stall_in;
 reg local_bb3_cmp_i_i_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_cmp3_i_i_i_valid_out;
wire local_bb3_cmp3_i_i_i_stall_in;
 reg local_bb3_cmp3_i_i_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_cmp3_i_i_i_inputs_ready;
wire local_bb3_cmp3_i_i_i_stall_local;
wire local_bb3_cmp3_i_i_i;

assign local_bb3_cmp3_i_i_i_inputs_ready = (rnode_30to32_bb3__64_i_0_valid_out_NO_SHIFT_REG & rnode_30to32_bb3__65_i_0_valid_out_NO_SHIFT_REG & rnode_31to32_bb3_reduction_5_i38_0_valid_out_NO_SHIFT_REG & rnode_30to32_bb3__71_i_0_valid_out_NO_SHIFT_REG);
assign local_bb3_cmp3_i_i_i = (local_bb3_and2_i_i_i != 64'h0);
assign local_bb3_shl_i57_i_valid_out_2 = 1'b1;
assign local_bb3_add19_i_i_valid_out_2 = 1'b1;
assign local_bb3_cmp_i_i_i_valid_out = 1'b1;
assign local_bb3_cmp3_i_i_i_valid_out = 1'b1;
assign rnode_30to32_bb3__64_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_30to32_bb3__65_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_31to32_bb3_reduction_5_i38_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_30to32_bb3__71_i_0_stall_in_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_shl_i57_i_consumed_2_NO_SHIFT_REG <= 1'b0;
		local_bb3_add19_i_i_consumed_2_NO_SHIFT_REG <= 1'b0;
		local_bb3_cmp_i_i_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_cmp3_i_i_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3_shl_i57_i_consumed_2_NO_SHIFT_REG <= (local_bb3_cmp3_i_i_i_inputs_ready & (local_bb3_shl_i57_i_consumed_2_NO_SHIFT_REG | ~(local_bb3_shl_i57_i_stall_in_2)) & local_bb3_cmp3_i_i_i_stall_local);
		local_bb3_add19_i_i_consumed_2_NO_SHIFT_REG <= (local_bb3_cmp3_i_i_i_inputs_ready & (local_bb3_add19_i_i_consumed_2_NO_SHIFT_REG | ~(local_bb3_add19_i_i_stall_in_2)) & local_bb3_cmp3_i_i_i_stall_local);
		local_bb3_cmp_i_i_i_consumed_0_NO_SHIFT_REG <= (local_bb3_cmp3_i_i_i_inputs_ready & (local_bb3_cmp_i_i_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_cmp_i_i_i_stall_in)) & local_bb3_cmp3_i_i_i_stall_local);
		local_bb3_cmp3_i_i_i_consumed_0_NO_SHIFT_REG <= (local_bb3_cmp3_i_i_i_inputs_ready & (local_bb3_cmp3_i_i_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_cmp3_i_i_i_stall_in)) & local_bb3_cmp3_i_i_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_32to33_bb3_shl_i57_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_32to33_bb3_shl_i57_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_32to33_bb3_shl_i57_i_0_NO_SHIFT_REG;
 logic rnode_32to33_bb3_shl_i57_i_0_reg_33_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_32to33_bb3_shl_i57_i_0_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3_shl_i57_i_0_valid_out_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3_shl_i57_i_0_stall_in_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3_shl_i57_i_0_stall_out_reg_33_NO_SHIFT_REG;

acl_data_fifo rnode_32to33_bb3_shl_i57_i_0_reg_33_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_32to33_bb3_shl_i57_i_0_reg_33_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_32to33_bb3_shl_i57_i_0_stall_in_reg_33_NO_SHIFT_REG),
	.valid_out(rnode_32to33_bb3_shl_i57_i_0_valid_out_reg_33_NO_SHIFT_REG),
	.stall_out(rnode_32to33_bb3_shl_i57_i_0_stall_out_reg_33_NO_SHIFT_REG),
	.data_in(local_bb3_shl_i57_i),
	.data_out(rnode_32to33_bb3_shl_i57_i_0_reg_33_NO_SHIFT_REG)
);

defparam rnode_32to33_bb3_shl_i57_i_0_reg_33_fifo.DEPTH = 1;
defparam rnode_32to33_bb3_shl_i57_i_0_reg_33_fifo.DATA_WIDTH = 32;
defparam rnode_32to33_bb3_shl_i57_i_0_reg_33_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_32to33_bb3_shl_i57_i_0_reg_33_fifo.IMPL = "shift_reg";

assign rnode_32to33_bb3_shl_i57_i_0_reg_33_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_shl_i57_i_stall_in_2 = 1'b0;
assign rnode_32to33_bb3_shl_i57_i_0_NO_SHIFT_REG = rnode_32to33_bb3_shl_i57_i_0_reg_33_NO_SHIFT_REG;
assign rnode_32to33_bb3_shl_i57_i_0_stall_in_reg_33_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_shl_i57_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_32to33_bb3_add19_i_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_stall_in_0_NO_SHIFT_REG;
 logic [63:0] rnode_32to33_bb3_add19_i_i_0_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_stall_in_1_NO_SHIFT_REG;
 logic [63:0] rnode_32to33_bb3_add19_i_i_1_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_stall_in_2_NO_SHIFT_REG;
 logic [63:0] rnode_32to33_bb3_add19_i_i_2_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_stall_in_3_NO_SHIFT_REG;
 logic [63:0] rnode_32to33_bb3_add19_i_i_3_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_valid_out_4_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_stall_in_4_NO_SHIFT_REG;
 logic [63:0] rnode_32to33_bb3_add19_i_i_4_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_valid_out_5_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_stall_in_5_NO_SHIFT_REG;
 logic [63:0] rnode_32to33_bb3_add19_i_i_5_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_valid_out_6_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_stall_in_6_NO_SHIFT_REG;
 logic [63:0] rnode_32to33_bb3_add19_i_i_6_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_reg_33_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_32to33_bb3_add19_i_i_0_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_valid_out_0_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_stall_in_0_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3_add19_i_i_0_stall_out_reg_33_NO_SHIFT_REG;

acl_data_fifo rnode_32to33_bb3_add19_i_i_0_reg_33_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_32to33_bb3_add19_i_i_0_reg_33_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_32to33_bb3_add19_i_i_0_stall_in_0_reg_33_NO_SHIFT_REG),
	.valid_out(rnode_32to33_bb3_add19_i_i_0_valid_out_0_reg_33_NO_SHIFT_REG),
	.stall_out(rnode_32to33_bb3_add19_i_i_0_stall_out_reg_33_NO_SHIFT_REG),
	.data_in(local_bb3_add19_i_i),
	.data_out(rnode_32to33_bb3_add19_i_i_0_reg_33_NO_SHIFT_REG)
);

defparam rnode_32to33_bb3_add19_i_i_0_reg_33_fifo.DEPTH = 1;
defparam rnode_32to33_bb3_add19_i_i_0_reg_33_fifo.DATA_WIDTH = 64;
defparam rnode_32to33_bb3_add19_i_i_0_reg_33_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_32to33_bb3_add19_i_i_0_reg_33_fifo.IMPL = "shift_reg";

assign rnode_32to33_bb3_add19_i_i_0_reg_33_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_add19_i_i_stall_in_2 = 1'b0;
assign rnode_32to33_bb3_add19_i_i_0_stall_in_0_reg_33_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_add19_i_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3_add19_i_i_0_NO_SHIFT_REG = rnode_32to33_bb3_add19_i_i_0_reg_33_NO_SHIFT_REG;
assign rnode_32to33_bb3_add19_i_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3_add19_i_i_1_NO_SHIFT_REG = rnode_32to33_bb3_add19_i_i_0_reg_33_NO_SHIFT_REG;
assign rnode_32to33_bb3_add19_i_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3_add19_i_i_2_NO_SHIFT_REG = rnode_32to33_bb3_add19_i_i_0_reg_33_NO_SHIFT_REG;
assign rnode_32to33_bb3_add19_i_i_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3_add19_i_i_3_NO_SHIFT_REG = rnode_32to33_bb3_add19_i_i_0_reg_33_NO_SHIFT_REG;
assign rnode_32to33_bb3_add19_i_i_0_valid_out_4_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3_add19_i_i_4_NO_SHIFT_REG = rnode_32to33_bb3_add19_i_i_0_reg_33_NO_SHIFT_REG;
assign rnode_32to33_bb3_add19_i_i_0_valid_out_5_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3_add19_i_i_5_NO_SHIFT_REG = rnode_32to33_bb3_add19_i_i_0_reg_33_NO_SHIFT_REG;
assign rnode_32to33_bb3_add19_i_i_0_valid_out_6_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3_add19_i_i_6_NO_SHIFT_REG = rnode_32to33_bb3_add19_i_i_0_reg_33_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_32to33_bb3_cmp_i_i_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp_i_i_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp_i_i_i_0_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp_i_i_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp_i_i_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp_i_i_i_1_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp_i_i_i_0_reg_33_inputs_ready_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp_i_i_i_0_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp_i_i_i_0_valid_out_0_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp_i_i_i_0_stall_in_0_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp_i_i_i_0_stall_out_reg_33_NO_SHIFT_REG;

acl_data_fifo rnode_32to33_bb3_cmp_i_i_i_0_reg_33_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_32to33_bb3_cmp_i_i_i_0_reg_33_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_32to33_bb3_cmp_i_i_i_0_stall_in_0_reg_33_NO_SHIFT_REG),
	.valid_out(rnode_32to33_bb3_cmp_i_i_i_0_valid_out_0_reg_33_NO_SHIFT_REG),
	.stall_out(rnode_32to33_bb3_cmp_i_i_i_0_stall_out_reg_33_NO_SHIFT_REG),
	.data_in(local_bb3_cmp_i_i_i),
	.data_out(rnode_32to33_bb3_cmp_i_i_i_0_reg_33_NO_SHIFT_REG)
);

defparam rnode_32to33_bb3_cmp_i_i_i_0_reg_33_fifo.DEPTH = 1;
defparam rnode_32to33_bb3_cmp_i_i_i_0_reg_33_fifo.DATA_WIDTH = 1;
defparam rnode_32to33_bb3_cmp_i_i_i_0_reg_33_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_32to33_bb3_cmp_i_i_i_0_reg_33_fifo.IMPL = "shift_reg";

assign rnode_32to33_bb3_cmp_i_i_i_0_reg_33_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_cmp_i_i_i_stall_in = 1'b0;
assign rnode_32to33_bb3_cmp_i_i_i_0_stall_in_0_reg_33_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_cmp_i_i_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3_cmp_i_i_i_0_NO_SHIFT_REG = rnode_32to33_bb3_cmp_i_i_i_0_reg_33_NO_SHIFT_REG;
assign rnode_32to33_bb3_cmp_i_i_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3_cmp_i_i_i_1_NO_SHIFT_REG = rnode_32to33_bb3_cmp_i_i_i_0_reg_33_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_32to33_bb3_cmp3_i_i_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp3_i_i_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp3_i_i_i_0_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp3_i_i_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp3_i_i_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp3_i_i_i_1_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp3_i_i_i_0_reg_33_inputs_ready_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp3_i_i_i_0_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp3_i_i_i_0_valid_out_0_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp3_i_i_i_0_stall_in_0_reg_33_NO_SHIFT_REG;
 logic rnode_32to33_bb3_cmp3_i_i_i_0_stall_out_reg_33_NO_SHIFT_REG;

acl_data_fifo rnode_32to33_bb3_cmp3_i_i_i_0_reg_33_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_32to33_bb3_cmp3_i_i_i_0_reg_33_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_32to33_bb3_cmp3_i_i_i_0_stall_in_0_reg_33_NO_SHIFT_REG),
	.valid_out(rnode_32to33_bb3_cmp3_i_i_i_0_valid_out_0_reg_33_NO_SHIFT_REG),
	.stall_out(rnode_32to33_bb3_cmp3_i_i_i_0_stall_out_reg_33_NO_SHIFT_REG),
	.data_in(local_bb3_cmp3_i_i_i),
	.data_out(rnode_32to33_bb3_cmp3_i_i_i_0_reg_33_NO_SHIFT_REG)
);

defparam rnode_32to33_bb3_cmp3_i_i_i_0_reg_33_fifo.DEPTH = 1;
defparam rnode_32to33_bb3_cmp3_i_i_i_0_reg_33_fifo.DATA_WIDTH = 1;
defparam rnode_32to33_bb3_cmp3_i_i_i_0_reg_33_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_32to33_bb3_cmp3_i_i_i_0_reg_33_fifo.IMPL = "shift_reg";

assign rnode_32to33_bb3_cmp3_i_i_i_0_reg_33_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_cmp3_i_i_i_stall_in = 1'b0;
assign rnode_32to33_bb3_cmp3_i_i_i_0_stall_in_0_reg_33_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_cmp3_i_i_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3_cmp3_i_i_i_0_NO_SHIFT_REG = rnode_32to33_bb3_cmp3_i_i_i_0_reg_33_NO_SHIFT_REG;
assign rnode_32to33_bb3_cmp3_i_i_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3_cmp3_i_i_i_1_NO_SHIFT_REG = rnode_32to33_bb3_cmp3_i_i_i_0_reg_33_NO_SHIFT_REG;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_33to35_bb3_shl_i57_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_33to35_bb3_shl_i57_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_33to35_bb3_shl_i57_i_0_NO_SHIFT_REG;
 logic rnode_33to35_bb3_shl_i57_i_0_reg_35_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_33to35_bb3_shl_i57_i_0_reg_35_NO_SHIFT_REG;
 logic rnode_33to35_bb3_shl_i57_i_0_valid_out_reg_35_NO_SHIFT_REG;
 logic rnode_33to35_bb3_shl_i57_i_0_stall_in_reg_35_NO_SHIFT_REG;
 logic rnode_33to35_bb3_shl_i57_i_0_stall_out_reg_35_NO_SHIFT_REG;

acl_data_fifo rnode_33to35_bb3_shl_i57_i_0_reg_35_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_33to35_bb3_shl_i57_i_0_reg_35_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_33to35_bb3_shl_i57_i_0_stall_in_reg_35_NO_SHIFT_REG),
	.valid_out(rnode_33to35_bb3_shl_i57_i_0_valid_out_reg_35_NO_SHIFT_REG),
	.stall_out(rnode_33to35_bb3_shl_i57_i_0_stall_out_reg_35_NO_SHIFT_REG),
	.data_in(rnode_32to33_bb3_shl_i57_i_0_NO_SHIFT_REG),
	.data_out(rnode_33to35_bb3_shl_i57_i_0_reg_35_NO_SHIFT_REG)
);

defparam rnode_33to35_bb3_shl_i57_i_0_reg_35_fifo.DEPTH = 2;
defparam rnode_33to35_bb3_shl_i57_i_0_reg_35_fifo.DATA_WIDTH = 32;
defparam rnode_33to35_bb3_shl_i57_i_0_reg_35_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_33to35_bb3_shl_i57_i_0_reg_35_fifo.IMPL = "shift_reg";

assign rnode_33to35_bb3_shl_i57_i_0_reg_35_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_32to33_bb3_shl_i57_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_33to35_bb3_shl_i57_i_0_NO_SHIFT_REG = rnode_33to35_bb3_shl_i57_i_0_reg_35_NO_SHIFT_REG;
assign rnode_33to35_bb3_shl_i57_i_0_stall_in_reg_35_NO_SHIFT_REG = 1'b0;
assign rnode_33to35_bb3_shl_i57_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_and10_i_i_stall_local;
wire [63:0] local_bb3_and10_i_i;

assign local_bb3_and10_i_i = (rnode_32to33_bb3_add19_i_i_0_NO_SHIFT_REG & 64'h100000000000000);

// This section implements an unregistered operation.
// 
wire local_bb3_shr5_i_i_i_stall_local;
wire [63:0] local_bb3_shr5_i_i_i;

assign local_bb3_shr5_i_i_i = (rnode_32to33_bb3_add19_i_i_1_NO_SHIFT_REG >> 64'h1D);

// This section implements an unregistered operation.
// 
wire local_bb3_shr8_i_i_i_stall_local;
wire [63:0] local_bb3_shr8_i_i_i;

assign local_bb3_shr8_i_i_i = (rnode_32to33_bb3_add19_i_i_2_NO_SHIFT_REG >> 64'hD);

// This section implements an unregistered operation.
// 
wire local_bb3_shr35_i_i_stall_local;
wire [63:0] local_bb3_shr35_i_i;

assign local_bb3_shr35_i_i = (rnode_32to33_bb3_add19_i_i_4_NO_SHIFT_REG >> 64'h1);

// This section implements an unregistered operation.
// 
wire local_bb3_and38_i_i_stall_local;
wire [63:0] local_bb3_and38_i_i;

assign local_bb3_and38_i_i = (rnode_32to33_bb3_add19_i_i_5_NO_SHIFT_REG & 64'h1);

// This section implements an unregistered operation.
// 
wire local_bb3_cond19_i_i_i_stall_local;
wire [31:0] local_bb3_cond19_i_i_i;

assign local_bb3_cond19_i_i_i = (rnode_32to33_bb3_cmp3_i_i_i_1_NO_SHIFT_REG ? 32'h10 : 32'h1D);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_35to36_bb3_shl_i57_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_35to36_bb3_shl_i57_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_35to36_bb3_shl_i57_i_0_NO_SHIFT_REG;
 logic rnode_35to36_bb3_shl_i57_i_0_reg_36_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_35to36_bb3_shl_i57_i_0_reg_36_NO_SHIFT_REG;
 logic rnode_35to36_bb3_shl_i57_i_0_valid_out_reg_36_NO_SHIFT_REG;
 logic rnode_35to36_bb3_shl_i57_i_0_stall_in_reg_36_NO_SHIFT_REG;
 logic rnode_35to36_bb3_shl_i57_i_0_stall_out_reg_36_NO_SHIFT_REG;

acl_data_fifo rnode_35to36_bb3_shl_i57_i_0_reg_36_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_35to36_bb3_shl_i57_i_0_reg_36_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_35to36_bb3_shl_i57_i_0_stall_in_reg_36_NO_SHIFT_REG),
	.valid_out(rnode_35to36_bb3_shl_i57_i_0_valid_out_reg_36_NO_SHIFT_REG),
	.stall_out(rnode_35to36_bb3_shl_i57_i_0_stall_out_reg_36_NO_SHIFT_REG),
	.data_in(rnode_33to35_bb3_shl_i57_i_0_NO_SHIFT_REG),
	.data_out(rnode_35to36_bb3_shl_i57_i_0_reg_36_NO_SHIFT_REG)
);

defparam rnode_35to36_bb3_shl_i57_i_0_reg_36_fifo.DEPTH = 1;
defparam rnode_35to36_bb3_shl_i57_i_0_reg_36_fifo.DATA_WIDTH = 32;
defparam rnode_35to36_bb3_shl_i57_i_0_reg_36_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_35to36_bb3_shl_i57_i_0_reg_36_fifo.IMPL = "shift_reg";

assign rnode_35to36_bb3_shl_i57_i_0_reg_36_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_33to35_bb3_shl_i57_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_35to36_bb3_shl_i57_i_0_NO_SHIFT_REG = rnode_35to36_bb3_shl_i57_i_0_reg_36_NO_SHIFT_REG;
assign rnode_35to36_bb3_shl_i57_i_0_stall_in_reg_36_NO_SHIFT_REG = 1'b0;
assign rnode_35to36_bb3_shl_i57_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_tobool11_i_i_stall_local;
wire local_bb3_tobool11_i_i;

assign local_bb3_tobool11_i_i = (local_bb3_and10_i_i == 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_cond_i_i_i_stall_local;
wire [63:0] local_bb3_cond_i_i_i;

assign local_bb3_cond_i_i_i = (rnode_32to33_bb3_cmp3_i_i_i_0_NO_SHIFT_REG ? local_bb3_shr8_i_i_i : rnode_32to33_bb3_add19_i_i_3_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_or39_i_i_stall_local;
wire [63:0] local_bb3_or39_i_i;

assign local_bb3_or39_i_i = (local_bb3_shr35_i_i | local_bb3_and38_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3__80_i_stall_local;
wire [31:0] local_bb3__80_i;

assign local_bb3__80_i = (rnode_32to33_bb3_cmp_i_i_i_1_NO_SHIFT_REG ? 32'h0 : local_bb3_cond19_i_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_tobool11_i_not_i_stall_local;
wire local_bb3_tobool11_i_not_i;

assign local_bb3_tobool11_i_not_i = (local_bb3_tobool11_i_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb3__79_i_stall_local;
wire [63:0] local_bb3__79_i;

assign local_bb3__79_i = (rnode_32to33_bb3_cmp_i_i_i_0_NO_SHIFT_REG ? local_bb3_shr5_i_i_i : local_bb3_cond_i_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3__81_i_stall_local;
wire [63:0] local_bb3__81_i;

assign local_bb3__81_i = (local_bb3_tobool11_i_i ? rnode_32to33_bb3_add19_i_i_6_NO_SHIFT_REG : local_bb3_or39_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3__84_i_valid_out;
wire local_bb3__84_i_stall_in;
 reg local_bb3__84_i_consumed_0_NO_SHIFT_REG;
wire local_bb3__78_i_valid_out;
wire local_bb3__78_i_stall_in;
 reg local_bb3__78_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_tobool11_i_i_valid_out_2;
wire local_bb3_tobool11_i_i_stall_in_2;
 reg local_bb3_tobool11_i_i_consumed_2_NO_SHIFT_REG;
wire local_bb3__81_i_valid_out;
wire local_bb3__81_i_stall_in;
 reg local_bb3__81_i_consumed_0_NO_SHIFT_REG;
wire local_bb3__84_i_inputs_ready;
wire local_bb3__84_i_stall_local;
wire local_bb3__84_i;

assign local_bb3__84_i_inputs_ready = (rnode_32to33_bb3__67_i_0_valid_out_0_NO_SHIFT_REG & rnode_32to33_bb3_and64_i53_i_0_valid_out_NO_SHIFT_REG & rnode_32to33_bb3__67_i_0_valid_out_1_NO_SHIFT_REG & rnode_32to33_bb3__67_i_0_valid_out_2_NO_SHIFT_REG & rnode_32to33_bb3_add19_i_i_0_valid_out_0_NO_SHIFT_REG & rnode_32to33_bb3_add19_i_i_0_valid_out_6_NO_SHIFT_REG & rnode_32to33_bb3_add19_i_i_0_valid_out_4_NO_SHIFT_REG & rnode_32to33_bb3_add19_i_i_0_valid_out_5_NO_SHIFT_REG);
assign local_bb3__84_i = (local_bb3_cmp46_i_i & local_bb3_tobool11_i_not_i);
assign local_bb3__84_i_valid_out = 1'b1;
assign local_bb3__78_i_valid_out = 1'b1;
assign local_bb3_tobool11_i_i_valid_out_2 = 1'b1;
assign local_bb3__81_i_valid_out = 1'b1;
assign rnode_32to33_bb3__67_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_and64_i53_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3__67_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3__67_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_add19_i_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_add19_i_i_0_stall_in_6_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_add19_i_i_0_stall_in_4_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_add19_i_i_0_stall_in_5_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3__84_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3__78_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_tobool11_i_i_consumed_2_NO_SHIFT_REG <= 1'b0;
		local_bb3__81_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3__84_i_consumed_0_NO_SHIFT_REG <= (local_bb3__84_i_inputs_ready & (local_bb3__84_i_consumed_0_NO_SHIFT_REG | ~(local_bb3__84_i_stall_in)) & local_bb3__84_i_stall_local);
		local_bb3__78_i_consumed_0_NO_SHIFT_REG <= (local_bb3__84_i_inputs_ready & (local_bb3__78_i_consumed_0_NO_SHIFT_REG | ~(local_bb3__78_i_stall_in)) & local_bb3__84_i_stall_local);
		local_bb3_tobool11_i_i_consumed_2_NO_SHIFT_REG <= (local_bb3__84_i_inputs_ready & (local_bb3_tobool11_i_i_consumed_2_NO_SHIFT_REG | ~(local_bb3_tobool11_i_i_stall_in_2)) & local_bb3__84_i_stall_local);
		local_bb3__81_i_consumed_0_NO_SHIFT_REG <= (local_bb3__84_i_inputs_ready & (local_bb3__81_i_consumed_0_NO_SHIFT_REG | ~(local_bb3__81_i_stall_in)) & local_bb3__84_i_stall_local);
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3_cond11_tr_i_i_i_stall_local;
wire [31:0] local_bb3_cond11_tr_i_i_i;

assign local_bb3_cond11_tr_i_i_i = local_bb3__79_i[31:0];

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_33to35_bb3__84_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_33to35_bb3__84_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_33to35_bb3__84_i_0_NO_SHIFT_REG;
 logic rnode_33to35_bb3__84_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_33to35_bb3__84_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_33to35_bb3__84_i_1_NO_SHIFT_REG;
 logic rnode_33to35_bb3__84_i_0_reg_35_inputs_ready_NO_SHIFT_REG;
 logic rnode_33to35_bb3__84_i_0_reg_35_NO_SHIFT_REG;
 logic rnode_33to35_bb3__84_i_0_valid_out_0_reg_35_NO_SHIFT_REG;
 logic rnode_33to35_bb3__84_i_0_stall_in_0_reg_35_NO_SHIFT_REG;
 logic rnode_33to35_bb3__84_i_0_stall_out_reg_35_NO_SHIFT_REG;

acl_data_fifo rnode_33to35_bb3__84_i_0_reg_35_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_33to35_bb3__84_i_0_reg_35_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_33to35_bb3__84_i_0_stall_in_0_reg_35_NO_SHIFT_REG),
	.valid_out(rnode_33to35_bb3__84_i_0_valid_out_0_reg_35_NO_SHIFT_REG),
	.stall_out(rnode_33to35_bb3__84_i_0_stall_out_reg_35_NO_SHIFT_REG),
	.data_in(local_bb3__84_i),
	.data_out(rnode_33to35_bb3__84_i_0_reg_35_NO_SHIFT_REG)
);

defparam rnode_33to35_bb3__84_i_0_reg_35_fifo.DEPTH = 2;
defparam rnode_33to35_bb3__84_i_0_reg_35_fifo.DATA_WIDTH = 1;
defparam rnode_33to35_bb3__84_i_0_reg_35_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_33to35_bb3__84_i_0_reg_35_fifo.IMPL = "shift_reg";

assign rnode_33to35_bb3__84_i_0_reg_35_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3__84_i_stall_in = 1'b0;
assign rnode_33to35_bb3__84_i_0_stall_in_0_reg_35_NO_SHIFT_REG = 1'b0;
assign rnode_33to35_bb3__84_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_33to35_bb3__84_i_0_NO_SHIFT_REG = rnode_33to35_bb3__84_i_0_reg_35_NO_SHIFT_REG;
assign rnode_33to35_bb3__84_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_33to35_bb3__84_i_1_NO_SHIFT_REG = rnode_33to35_bb3__84_i_0_reg_35_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_33to34_bb3__78_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_33to34_bb3__78_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_33to34_bb3__78_i_0_NO_SHIFT_REG;
 logic rnode_33to34_bb3__78_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_33to34_bb3__78_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_33to34_bb3__78_i_1_NO_SHIFT_REG;
 logic rnode_33to34_bb3__78_i_0_reg_34_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_33to34_bb3__78_i_0_reg_34_NO_SHIFT_REG;
 logic rnode_33to34_bb3__78_i_0_valid_out_0_reg_34_NO_SHIFT_REG;
 logic rnode_33to34_bb3__78_i_0_stall_in_0_reg_34_NO_SHIFT_REG;
 logic rnode_33to34_bb3__78_i_0_stall_out_reg_34_NO_SHIFT_REG;

acl_data_fifo rnode_33to34_bb3__78_i_0_reg_34_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_33to34_bb3__78_i_0_reg_34_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_33to34_bb3__78_i_0_stall_in_0_reg_34_NO_SHIFT_REG),
	.valid_out(rnode_33to34_bb3__78_i_0_valid_out_0_reg_34_NO_SHIFT_REG),
	.stall_out(rnode_33to34_bb3__78_i_0_stall_out_reg_34_NO_SHIFT_REG),
	.data_in(local_bb3__78_i),
	.data_out(rnode_33to34_bb3__78_i_0_reg_34_NO_SHIFT_REG)
);

defparam rnode_33to34_bb3__78_i_0_reg_34_fifo.DEPTH = 1;
defparam rnode_33to34_bb3__78_i_0_reg_34_fifo.DATA_WIDTH = 32;
defparam rnode_33to34_bb3__78_i_0_reg_34_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_33to34_bb3__78_i_0_reg_34_fifo.IMPL = "shift_reg";

assign rnode_33to34_bb3__78_i_0_reg_34_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3__78_i_stall_in = 1'b0;
assign rnode_33to34_bb3__78_i_0_stall_in_0_reg_34_NO_SHIFT_REG = 1'b0;
assign rnode_33to34_bb3__78_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_33to34_bb3__78_i_0_NO_SHIFT_REG = rnode_33to34_bb3__78_i_0_reg_34_NO_SHIFT_REG;
assign rnode_33to34_bb3__78_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_33to34_bb3__78_i_1_NO_SHIFT_REG = rnode_33to34_bb3__78_i_0_reg_34_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_33to34_bb3_tobool11_i_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_33to34_bb3_tobool11_i_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_33to34_bb3_tobool11_i_i_0_NO_SHIFT_REG;
 logic rnode_33to34_bb3_tobool11_i_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_33to34_bb3_tobool11_i_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_33to34_bb3_tobool11_i_i_1_NO_SHIFT_REG;
 logic rnode_33to34_bb3_tobool11_i_i_0_reg_34_inputs_ready_NO_SHIFT_REG;
 logic rnode_33to34_bb3_tobool11_i_i_0_reg_34_NO_SHIFT_REG;
 logic rnode_33to34_bb3_tobool11_i_i_0_valid_out_0_reg_34_NO_SHIFT_REG;
 logic rnode_33to34_bb3_tobool11_i_i_0_stall_in_0_reg_34_NO_SHIFT_REG;
 logic rnode_33to34_bb3_tobool11_i_i_0_stall_out_reg_34_NO_SHIFT_REG;

acl_data_fifo rnode_33to34_bb3_tobool11_i_i_0_reg_34_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_33to34_bb3_tobool11_i_i_0_reg_34_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_33to34_bb3_tobool11_i_i_0_stall_in_0_reg_34_NO_SHIFT_REG),
	.valid_out(rnode_33to34_bb3_tobool11_i_i_0_valid_out_0_reg_34_NO_SHIFT_REG),
	.stall_out(rnode_33to34_bb3_tobool11_i_i_0_stall_out_reg_34_NO_SHIFT_REG),
	.data_in(local_bb3_tobool11_i_i),
	.data_out(rnode_33to34_bb3_tobool11_i_i_0_reg_34_NO_SHIFT_REG)
);

defparam rnode_33to34_bb3_tobool11_i_i_0_reg_34_fifo.DEPTH = 1;
defparam rnode_33to34_bb3_tobool11_i_i_0_reg_34_fifo.DATA_WIDTH = 1;
defparam rnode_33to34_bb3_tobool11_i_i_0_reg_34_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_33to34_bb3_tobool11_i_i_0_reg_34_fifo.IMPL = "shift_reg";

assign rnode_33to34_bb3_tobool11_i_i_0_reg_34_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_tobool11_i_i_stall_in_2 = 1'b0;
assign rnode_33to34_bb3_tobool11_i_i_0_stall_in_0_reg_34_NO_SHIFT_REG = 1'b0;
assign rnode_33to34_bb3_tobool11_i_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_33to34_bb3_tobool11_i_i_0_NO_SHIFT_REG = rnode_33to34_bb3_tobool11_i_i_0_reg_34_NO_SHIFT_REG;
assign rnode_33to34_bb3_tobool11_i_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_33to34_bb3_tobool11_i_i_1_NO_SHIFT_REG = rnode_33to34_bb3_tobool11_i_i_0_reg_34_NO_SHIFT_REG;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_33to35_bb3__81_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_33to35_bb3__81_i_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_33to35_bb3__81_i_0_NO_SHIFT_REG;
 logic rnode_33to35_bb3__81_i_0_reg_35_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_33to35_bb3__81_i_0_reg_35_NO_SHIFT_REG;
 logic rnode_33to35_bb3__81_i_0_valid_out_reg_35_NO_SHIFT_REG;
 logic rnode_33to35_bb3__81_i_0_stall_in_reg_35_NO_SHIFT_REG;
 logic rnode_33to35_bb3__81_i_0_stall_out_reg_35_NO_SHIFT_REG;

acl_data_fifo rnode_33to35_bb3__81_i_0_reg_35_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_33to35_bb3__81_i_0_reg_35_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_33to35_bb3__81_i_0_stall_in_reg_35_NO_SHIFT_REG),
	.valid_out(rnode_33to35_bb3__81_i_0_valid_out_reg_35_NO_SHIFT_REG),
	.stall_out(rnode_33to35_bb3__81_i_0_stall_out_reg_35_NO_SHIFT_REG),
	.data_in(local_bb3__81_i),
	.data_out(rnode_33to35_bb3__81_i_0_reg_35_NO_SHIFT_REG)
);

defparam rnode_33to35_bb3__81_i_0_reg_35_fifo.DEPTH = 2;
defparam rnode_33to35_bb3__81_i_0_reg_35_fifo.DATA_WIDTH = 64;
defparam rnode_33to35_bb3__81_i_0_reg_35_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_33to35_bb3__81_i_0_reg_35_fifo.IMPL = "shift_reg";

assign rnode_33to35_bb3__81_i_0_reg_35_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3__81_i_stall_in = 1'b0;
assign rnode_33to35_bb3__81_i_0_NO_SHIFT_REG = rnode_33to35_bb3__81_i_0_reg_35_NO_SHIFT_REG;
assign rnode_33to35_bb3__81_i_0_stall_in_reg_35_NO_SHIFT_REG = 1'b0;
assign rnode_33to35_bb3__81_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_conv_i_i_i_stall_local;
wire [31:0] local_bb3_conv_i_i_i;

assign local_bb3_conv_i_i_i = (local_bb3_cond11_tr_i_i_i & 32'h7FFFFFF);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_34to35_bb3__78_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_34to35_bb3__78_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_34to35_bb3__78_i_0_NO_SHIFT_REG;
 logic rnode_34to35_bb3__78_i_0_reg_35_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_34to35_bb3__78_i_0_reg_35_NO_SHIFT_REG;
 logic rnode_34to35_bb3__78_i_0_valid_out_reg_35_NO_SHIFT_REG;
 logic rnode_34to35_bb3__78_i_0_stall_in_reg_35_NO_SHIFT_REG;
 logic rnode_34to35_bb3__78_i_0_stall_out_reg_35_NO_SHIFT_REG;

acl_data_fifo rnode_34to35_bb3__78_i_0_reg_35_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_34to35_bb3__78_i_0_reg_35_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_34to35_bb3__78_i_0_stall_in_reg_35_NO_SHIFT_REG),
	.valid_out(rnode_34to35_bb3__78_i_0_valid_out_reg_35_NO_SHIFT_REG),
	.stall_out(rnode_34to35_bb3__78_i_0_stall_out_reg_35_NO_SHIFT_REG),
	.data_in(rnode_33to34_bb3__78_i_1_NO_SHIFT_REG),
	.data_out(rnode_34to35_bb3__78_i_0_reg_35_NO_SHIFT_REG)
);

defparam rnode_34to35_bb3__78_i_0_reg_35_fifo.DEPTH = 1;
defparam rnode_34to35_bb3__78_i_0_reg_35_fifo.DATA_WIDTH = 32;
defparam rnode_34to35_bb3__78_i_0_reg_35_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_34to35_bb3__78_i_0_reg_35_fifo.IMPL = "shift_reg";

assign rnode_34to35_bb3__78_i_0_reg_35_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_33to34_bb3__78_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_34to35_bb3__78_i_0_NO_SHIFT_REG = rnode_34to35_bb3__78_i_0_reg_35_NO_SHIFT_REG;
assign rnode_34to35_bb3__78_i_0_stall_in_reg_35_NO_SHIFT_REG = 1'b0;
assign rnode_34to35_bb3__78_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3__83_i_stall_local;
wire [31:0] local_bb3__83_i;

assign local_bb3__83_i = (rnode_33to34_bb3_tobool11_i_i_1_NO_SHIFT_REG ? 32'h0 : local_bb3_var__u33);

// This section implements an unregistered operation.
// 
wire local_bb3_and58_i_i_stall_local;
wire [63:0] local_bb3_and58_i_i;

assign local_bb3_and58_i_i = (rnode_33to35_bb3__81_i_0_NO_SHIFT_REG & 64'hFFFFFFFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_call_i_i_i_conv_i_i_i_stall_local;
wire [31:0] local_bb3_call_i_i_i_conv_i_i_i;

acl_optimized_clz_27 fpc_local_bb3_call_i_i_i_conv_i_i_i (
	.dataa(local_bb3_conv_i_i_i),
	.result(local_bb3_call_i_i_i_conv_i_i_i)
);



// This section implements an unregistered operation.
// 
wire local_bb3_add_i16_i_valid_out;
wire local_bb3_add_i16_i_stall_in;
wire local_bb3_add_i16_i_inputs_ready;
wire local_bb3_add_i16_i_stall_local;
wire [31:0] local_bb3_add_i16_i;

assign local_bb3_add_i16_i_inputs_ready = (rnode_33to34_bb3__67_i_0_valid_out_0_NO_SHIFT_REG & rnode_33to34_bb3_tobool11_i_i_0_valid_out_1_NO_SHIFT_REG & rnode_33to34_bb3__67_i_0_valid_out_1_NO_SHIFT_REG);
assign local_bb3_add_i16_i = (local_bb3__83_i + rnode_33to34_bb3__67_i_1_NO_SHIFT_REG);
assign local_bb3_add_i16_i_valid_out = 1'b1;
assign rnode_33to34_bb3__67_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_33to34_bb3_tobool11_i_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_33to34_bb3__67_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb3_add_i_i_i_valid_out;
wire local_bb3_add_i_i_i_stall_in;
wire local_bb3_add_i_i_i_inputs_ready;
wire local_bb3_add_i_i_i_stall_local;
wire [31:0] local_bb3_add_i_i_i;

assign local_bb3_add_i_i_i_inputs_ready = (rnode_32to33_bb3_add19_i_i_0_valid_out_1_NO_SHIFT_REG & rnode_32to33_bb3_cmp_i_i_i_0_valid_out_0_NO_SHIFT_REG & rnode_32to33_bb3_add19_i_i_0_valid_out_2_NO_SHIFT_REG & rnode_32to33_bb3_cmp3_i_i_i_0_valid_out_0_NO_SHIFT_REG & rnode_32to33_bb3_add19_i_i_0_valid_out_3_NO_SHIFT_REG & rnode_32to33_bb3_cmp_i_i_i_0_valid_out_1_NO_SHIFT_REG & rnode_32to33_bb3_cmp3_i_i_i_0_valid_out_1_NO_SHIFT_REG);
assign local_bb3_add_i_i_i = (local_bb3__80_i + local_bb3_call_i_i_i_conv_i_i_i);
assign local_bb3_add_i_i_i_valid_out = 1'b1;
assign rnode_32to33_bb3_add19_i_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_cmp_i_i_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_add19_i_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_cmp3_i_i_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_add19_i_i_0_stall_in_3_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_cmp_i_i_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_32to33_bb3_cmp3_i_i_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_34to35_bb3_add_i16_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_34to35_bb3_add_i16_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_34to35_bb3_add_i16_i_0_NO_SHIFT_REG;
 logic rnode_34to35_bb3_add_i16_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_34to35_bb3_add_i16_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_34to35_bb3_add_i16_i_1_NO_SHIFT_REG;
 logic rnode_34to35_bb3_add_i16_i_0_reg_35_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_34to35_bb3_add_i16_i_0_reg_35_NO_SHIFT_REG;
 logic rnode_34to35_bb3_add_i16_i_0_valid_out_0_reg_35_NO_SHIFT_REG;
 logic rnode_34to35_bb3_add_i16_i_0_stall_in_0_reg_35_NO_SHIFT_REG;
 logic rnode_34to35_bb3_add_i16_i_0_stall_out_reg_35_NO_SHIFT_REG;

acl_data_fifo rnode_34to35_bb3_add_i16_i_0_reg_35_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_34to35_bb3_add_i16_i_0_reg_35_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_34to35_bb3_add_i16_i_0_stall_in_0_reg_35_NO_SHIFT_REG),
	.valid_out(rnode_34to35_bb3_add_i16_i_0_valid_out_0_reg_35_NO_SHIFT_REG),
	.stall_out(rnode_34to35_bb3_add_i16_i_0_stall_out_reg_35_NO_SHIFT_REG),
	.data_in(local_bb3_add_i16_i),
	.data_out(rnode_34to35_bb3_add_i16_i_0_reg_35_NO_SHIFT_REG)
);

defparam rnode_34to35_bb3_add_i16_i_0_reg_35_fifo.DEPTH = 1;
defparam rnode_34to35_bb3_add_i16_i_0_reg_35_fifo.DATA_WIDTH = 32;
defparam rnode_34to35_bb3_add_i16_i_0_reg_35_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_34to35_bb3_add_i16_i_0_reg_35_fifo.IMPL = "shift_reg";

assign rnode_34to35_bb3_add_i16_i_0_reg_35_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_add_i16_i_stall_in = 1'b0;
assign rnode_34to35_bb3_add_i16_i_0_stall_in_0_reg_35_NO_SHIFT_REG = 1'b0;
assign rnode_34to35_bb3_add_i16_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_34to35_bb3_add_i16_i_0_NO_SHIFT_REG = rnode_34to35_bb3_add_i16_i_0_reg_35_NO_SHIFT_REG;
assign rnode_34to35_bb3_add_i16_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_34to35_bb3_add_i16_i_1_NO_SHIFT_REG = rnode_34to35_bb3_add_i16_i_0_reg_35_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_33to34_bb3_add_i_i_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_33to34_bb3_add_i_i_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_33to34_bb3_add_i_i_i_0_NO_SHIFT_REG;
 logic rnode_33to34_bb3_add_i_i_i_0_reg_34_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_33to34_bb3_add_i_i_i_0_reg_34_NO_SHIFT_REG;
 logic rnode_33to34_bb3_add_i_i_i_0_valid_out_reg_34_NO_SHIFT_REG;
 logic rnode_33to34_bb3_add_i_i_i_0_stall_in_reg_34_NO_SHIFT_REG;
 logic rnode_33to34_bb3_add_i_i_i_0_stall_out_reg_34_NO_SHIFT_REG;

acl_data_fifo rnode_33to34_bb3_add_i_i_i_0_reg_34_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_33to34_bb3_add_i_i_i_0_reg_34_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_33to34_bb3_add_i_i_i_0_stall_in_reg_34_NO_SHIFT_REG),
	.valid_out(rnode_33to34_bb3_add_i_i_i_0_valid_out_reg_34_NO_SHIFT_REG),
	.stall_out(rnode_33to34_bb3_add_i_i_i_0_stall_out_reg_34_NO_SHIFT_REG),
	.data_in(local_bb3_add_i_i_i),
	.data_out(rnode_33to34_bb3_add_i_i_i_0_reg_34_NO_SHIFT_REG)
);

defparam rnode_33to34_bb3_add_i_i_i_0_reg_34_fifo.DEPTH = 1;
defparam rnode_33to34_bb3_add_i_i_i_0_reg_34_fifo.DATA_WIDTH = 32;
defparam rnode_33to34_bb3_add_i_i_i_0_reg_34_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_33to34_bb3_add_i_i_i_0_reg_34_fifo.IMPL = "shift_reg";

assign rnode_33to34_bb3_add_i_i_i_0_reg_34_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_add_i_i_i_stall_in = 1'b0;
assign rnode_33to34_bb3_add_i_i_i_0_NO_SHIFT_REG = rnode_33to34_bb3_add_i_i_i_0_reg_34_NO_SHIFT_REG;
assign rnode_33to34_bb3_add_i_i_i_0_stall_in_reg_34_NO_SHIFT_REG = 1'b0;
assign rnode_33to34_bb3_add_i_i_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3__82_i_stall_local;
wire [31:0] local_bb3__82_i;

assign local_bb3__82_i = (rnode_33to34_bb3_tobool11_i_i_0_NO_SHIFT_REG ? rnode_33to34_bb3_add_i_i_i_0_NO_SHIFT_REG : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_and50_i_i_stall_local;
wire [31:0] local_bb3_and50_i_i;

assign local_bb3_and50_i_i = (local_bb3__82_i & 32'h40);

// This section implements an unregistered operation.
// 
wire local_bb3_tobool51_i14_i_stall_local;
wire local_bb3_tobool51_i14_i;

assign local_bb3_tobool51_i14_i = (local_bb3_and50_i_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_leading_zeros_1_i_i_stall_local;
wire [31:0] local_bb3_leading_zeros_1_i_i;

assign local_bb3_leading_zeros_1_i_i = (local_bb3_tobool51_i14_i ? local_bb3__82_i : 32'h3F);

// This section implements an unregistered operation.
// 
wire local_bb3_leading_zeros_1_i_i_valid_out_1;
wire local_bb3_leading_zeros_1_i_i_stall_in_1;
 reg local_bb3_leading_zeros_1_i_i_consumed_1_NO_SHIFT_REG;
wire local_bb3_cmp54_i_i_valid_out;
wire local_bb3_cmp54_i_i_stall_in;
 reg local_bb3_cmp54_i_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_cmp54_i_i_inputs_ready;
wire local_bb3_cmp54_i_i_stall_local;
wire local_bb3_cmp54_i_i;

assign local_bb3_cmp54_i_i_inputs_ready = (rnode_33to34_bb3_tobool11_i_i_0_valid_out_0_NO_SHIFT_REG & rnode_33to34_bb3_add_i_i_i_0_valid_out_NO_SHIFT_REG & rnode_33to34_bb3__78_i_0_valid_out_0_NO_SHIFT_REG);
assign local_bb3_cmp54_i_i = (local_bb3_leading_zeros_1_i_i > rnode_33to34_bb3__78_i_0_NO_SHIFT_REG);
assign local_bb3_leading_zeros_1_i_i_valid_out_1 = 1'b1;
assign local_bb3_cmp54_i_i_valid_out = 1'b1;
assign rnode_33to34_bb3_tobool11_i_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_33to34_bb3_add_i_i_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_33to34_bb3__78_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_leading_zeros_1_i_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb3_cmp54_i_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3_leading_zeros_1_i_i_consumed_1_NO_SHIFT_REG <= (local_bb3_cmp54_i_i_inputs_ready & (local_bb3_leading_zeros_1_i_i_consumed_1_NO_SHIFT_REG | ~(local_bb3_leading_zeros_1_i_i_stall_in_1)) & local_bb3_cmp54_i_i_stall_local);
		local_bb3_cmp54_i_i_consumed_0_NO_SHIFT_REG <= (local_bb3_cmp54_i_i_inputs_ready & (local_bb3_cmp54_i_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_cmp54_i_i_stall_in)) & local_bb3_cmp54_i_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_34to35_bb3_leading_zeros_1_i_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_34to35_bb3_leading_zeros_1_i_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_34to35_bb3_leading_zeros_1_i_i_0_NO_SHIFT_REG;
 logic rnode_34to35_bb3_leading_zeros_1_i_i_0_reg_35_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_34to35_bb3_leading_zeros_1_i_i_0_reg_35_NO_SHIFT_REG;
 logic rnode_34to35_bb3_leading_zeros_1_i_i_0_valid_out_reg_35_NO_SHIFT_REG;
 logic rnode_34to35_bb3_leading_zeros_1_i_i_0_stall_in_reg_35_NO_SHIFT_REG;
 logic rnode_34to35_bb3_leading_zeros_1_i_i_0_stall_out_reg_35_NO_SHIFT_REG;

acl_data_fifo rnode_34to35_bb3_leading_zeros_1_i_i_0_reg_35_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_34to35_bb3_leading_zeros_1_i_i_0_reg_35_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_34to35_bb3_leading_zeros_1_i_i_0_stall_in_reg_35_NO_SHIFT_REG),
	.valid_out(rnode_34to35_bb3_leading_zeros_1_i_i_0_valid_out_reg_35_NO_SHIFT_REG),
	.stall_out(rnode_34to35_bb3_leading_zeros_1_i_i_0_stall_out_reg_35_NO_SHIFT_REG),
	.data_in(local_bb3_leading_zeros_1_i_i),
	.data_out(rnode_34to35_bb3_leading_zeros_1_i_i_0_reg_35_NO_SHIFT_REG)
);

defparam rnode_34to35_bb3_leading_zeros_1_i_i_0_reg_35_fifo.DEPTH = 1;
defparam rnode_34to35_bb3_leading_zeros_1_i_i_0_reg_35_fifo.DATA_WIDTH = 32;
defparam rnode_34to35_bb3_leading_zeros_1_i_i_0_reg_35_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_34to35_bb3_leading_zeros_1_i_i_0_reg_35_fifo.IMPL = "shift_reg";

assign rnode_34to35_bb3_leading_zeros_1_i_i_0_reg_35_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_leading_zeros_1_i_i_stall_in_1 = 1'b0;
assign rnode_34to35_bb3_leading_zeros_1_i_i_0_NO_SHIFT_REG = rnode_34to35_bb3_leading_zeros_1_i_i_0_reg_35_NO_SHIFT_REG;
assign rnode_34to35_bb3_leading_zeros_1_i_i_0_stall_in_reg_35_NO_SHIFT_REG = 1'b0;
assign rnode_34to35_bb3_leading_zeros_1_i_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_34to35_bb3_cmp54_i_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_34to35_bb3_cmp54_i_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_34to35_bb3_cmp54_i_i_0_NO_SHIFT_REG;
 logic rnode_34to35_bb3_cmp54_i_i_0_reg_35_inputs_ready_NO_SHIFT_REG;
 logic rnode_34to35_bb3_cmp54_i_i_0_reg_35_NO_SHIFT_REG;
 logic rnode_34to35_bb3_cmp54_i_i_0_valid_out_reg_35_NO_SHIFT_REG;
 logic rnode_34to35_bb3_cmp54_i_i_0_stall_in_reg_35_NO_SHIFT_REG;
 logic rnode_34to35_bb3_cmp54_i_i_0_stall_out_reg_35_NO_SHIFT_REG;

acl_data_fifo rnode_34to35_bb3_cmp54_i_i_0_reg_35_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_34to35_bb3_cmp54_i_i_0_reg_35_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_34to35_bb3_cmp54_i_i_0_stall_in_reg_35_NO_SHIFT_REG),
	.valid_out(rnode_34to35_bb3_cmp54_i_i_0_valid_out_reg_35_NO_SHIFT_REG),
	.stall_out(rnode_34to35_bb3_cmp54_i_i_0_stall_out_reg_35_NO_SHIFT_REG),
	.data_in(local_bb3_cmp54_i_i),
	.data_out(rnode_34to35_bb3_cmp54_i_i_0_reg_35_NO_SHIFT_REG)
);

defparam rnode_34to35_bb3_cmp54_i_i_0_reg_35_fifo.DEPTH = 1;
defparam rnode_34to35_bb3_cmp54_i_i_0_reg_35_fifo.DATA_WIDTH = 1;
defparam rnode_34to35_bb3_cmp54_i_i_0_reg_35_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_34to35_bb3_cmp54_i_i_0_reg_35_fifo.IMPL = "shift_reg";

assign rnode_34to35_bb3_cmp54_i_i_0_reg_35_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_cmp54_i_i_stall_in = 1'b0;
assign rnode_34to35_bb3_cmp54_i_i_0_NO_SHIFT_REG = rnode_34to35_bb3_cmp54_i_i_0_reg_35_NO_SHIFT_REG;
assign rnode_34to35_bb3_cmp54_i_i_0_stall_in_reg_35_NO_SHIFT_REG = 1'b0;
assign rnode_34to35_bb3_cmp54_i_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_leading_zeros_2_i_i_stall_local;
wire [31:0] local_bb3_leading_zeros_2_i_i;

assign local_bb3_leading_zeros_2_i_i = (rnode_34to35_bb3_cmp54_i_i_0_NO_SHIFT_REG ? rnode_34to35_bb3__78_i_0_NO_SHIFT_REG : rnode_34to35_bb3_leading_zeros_1_i_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_and59_i_i_stall_local;
wire [31:0] local_bb3_and59_i_i;

assign local_bb3_and59_i_i = (local_bb3_leading_zeros_2_i_i & 32'h30);

// This section implements an unregistered operation.
// 
wire local_bb3_and61_i_i_stall_local;
wire [31:0] local_bb3_and61_i_i;

assign local_bb3_and61_i_i = (local_bb3_leading_zeros_2_i_i & 32'hC);

// This section implements an unregistered operation.
// 
wire local_bb3_and65_i_i_stall_local;
wire [31:0] local_bb3_and65_i_i;

assign local_bb3_and65_i_i = (local_bb3_leading_zeros_2_i_i & 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb3_sub68_i_i_stall_local;
wire [31:0] local_bb3_sub68_i_i;

assign local_bb3_sub68_i_i = (rnode_34to35_bb3_add_i16_i_0_NO_SHIFT_REG - local_bb3_leading_zeros_2_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp72_i_i_stall_local;
wire local_bb3_cmp72_i_i;

assign local_bb3_cmp72_i_i = (rnode_34to35_bb3_add_i16_i_1_NO_SHIFT_REG == local_bb3_leading_zeros_2_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_sh_prom_i_i_stall_local;
wire [63:0] local_bb3_sh_prom_i_i;

assign local_bb3_sh_prom_i_i[63:32] = 32'h0;
assign local_bb3_sh_prom_i_i[31:0] = local_bb3_and59_i_i;

// This section implements an unregistered operation.
// 
wire local_bb3_sh_prom62_i_i_stall_local;
wire [63:0] local_bb3_sh_prom62_i_i;

assign local_bb3_sh_prom62_i_i[63:32] = 32'h0;
assign local_bb3_sh_prom62_i_i[31:0] = local_bb3_and61_i_i;

// This section implements an unregistered operation.
// 
wire local_bb3_sh_prom66_i_i_stall_local;
wire [63:0] local_bb3_sh_prom66_i_i;

assign local_bb3_sh_prom66_i_i[63:32] = 32'h0;
assign local_bb3_sh_prom66_i_i[31:0] = local_bb3_and65_i_i;

// This section implements an unregistered operation.
// 
wire local_bb3_sub68_i_op_i_stall_local;
wire [31:0] local_bb3_sub68_i_op_i;

assign local_bb3_sub68_i_op_i = (local_bb3_sub68_i_i & 32'hFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_shl_i15_i39_stall_local;
wire [63:0] local_bb3_shl_i15_i39;

assign local_bb3_shl_i15_i39 = (local_bb3_and58_i_i << local_bb3_sh_prom_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and60_i_i_stall_local;
wire [63:0] local_bb3_and60_i_i;

assign local_bb3_and60_i_i = (local_bb3_shl_i15_i39 & 64'hFFFFFFFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_shl63_i_i_stall_local;
wire [63:0] local_bb3_shl63_i_i;

assign local_bb3_shl63_i_i = (local_bb3_and60_i_i << local_bb3_sh_prom62_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and64_i_i_stall_local;
wire [63:0] local_bb3_and64_i_i;

assign local_bb3_and64_i_i = (local_bb3_shl63_i_i & 64'hFFFFFFFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_shl67_i_i_stall_local;
wire [63:0] local_bb3_shl67_i_i;

assign local_bb3_shl67_i_i = (local_bb3_and64_i_i << local_bb3_sh_prom66_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and69_i_i_stall_local;
wire [63:0] local_bb3_and69_i_i;

assign local_bb3_and69_i_i = (local_bb3_shl67_i_i & 64'h80000000000000);

// This section implements an unregistered operation.
// 
wire local_bb3_and80_i_i_stall_local;
wire [63:0] local_bb3_and80_i_i;

assign local_bb3_and80_i_i = (local_bb3_shl67_i_i & 64'hFFFFFFFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_tobool70_i_i_stall_local;
wire local_bb3_tobool70_i_i;

assign local_bb3_tobool70_i_i = (local_bb3_and69_i_i == 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3__85_demorgan_i_stall_local;
wire local_bb3__85_demorgan_i;

assign local_bb3__85_demorgan_i = (local_bb3_tobool70_i_i | local_bb3_cmp72_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_not_tobool70_i_i_stall_local;
wire local_bb3_not_tobool70_i_i;

assign local_bb3_not_tobool70_i_i = (local_bb3_tobool70_i_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb3__89_i_stall_local;
wire [63:0] local_bb3__89_i;

assign local_bb3__89_i = (local_bb3__85_demorgan_i ? local_bb3_and80_i_i : local_bb3_shl67_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3__86_op_i_stall_local;
wire [31:0] local_bb3__86_op_i;

assign local_bb3__86_op_i = (local_bb3__85_demorgan_i ? 32'h0 : local_bb3_sub68_i_op_i);

// This section implements an unregistered operation.
// 
wire local_bb3__87_i_stall_local;
wire local_bb3__87_i;

assign local_bb3__87_i = (local_bb3_cmp72_i_i & local_bb3_not_tobool70_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3__90_i_stall_local;
wire [63:0] local_bb3__90_i;

assign local_bb3__90_i = (local_bb3__87_i ? local_bb3_shl67_i_i : local_bb3__89_i);

// This section implements an unregistered operation.
// 
wire local_bb3_exponent_0_op_i_i_stall_local;
wire [31:0] local_bb3_exponent_0_op_i_i;

assign local_bb3_exponent_0_op_i_i = (local_bb3__87_i ? 32'h1 : local_bb3__86_op_i);

// This section implements an unregistered operation.
// 
wire local_bb3_mantissa_3_i_i_stall_local;
wire [63:0] local_bb3_mantissa_3_i_i;

assign local_bb3_mantissa_3_i_i = (rnode_33to35_bb3__84_i_0_NO_SHIFT_REG ? 64'h80000000000000 : local_bb3__90_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and88_i_i_stall_local;
wire [31:0] local_bb3_and88_i_i;

assign local_bb3_and88_i_i = (rnode_33to35_bb3__84_i_1_NO_SHIFT_REG ? 32'hFFF : local_bb3_exponent_0_op_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_conv_i_i40_stall_local;
wire [63:0] local_bb3_conv_i_i40;

assign local_bb3_conv_i_i40 = (local_bb3_mantissa_3_i_i & 64'hF);

// This section implements an unregistered operation.
// 
wire local_bb3_and33_i_i_stall_local;
wire [63:0] local_bb3_and33_i_i;

assign local_bb3_and33_i_i = (local_bb3_mantissa_3_i_i & 64'h7);

// This section implements an unregistered operation.
// 
wire local_bb3_and44_i_i_stall_local;
wire [63:0] local_bb3_and44_i_i;

assign local_bb3_and44_i_i = (local_bb3_mantissa_3_i_i & 64'hFFFFFFFFFFFFF8);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp30_i_i_stall_local;
wire local_bb3_cmp30_i_i;

assign local_bb3_cmp30_i_i = (local_bb3_conv_i_i40 == 64'hC);

// This section implements an unregistered operation.
// 
wire local_bb3_and44_i_i_valid_out;
wire local_bb3_and44_i_i_stall_in;
 reg local_bb3_and44_i_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_cmp30_i_i_valid_out;
wire local_bb3_cmp30_i_i_stall_in;
 reg local_bb3_cmp30_i_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_cmp34_i_i_valid_out;
wire local_bb3_cmp34_i_i_stall_in;
 reg local_bb3_cmp34_i_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_and88_i_i_valid_out;
wire local_bb3_and88_i_i_stall_in;
 reg local_bb3_and88_i_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_cmp34_i_i_inputs_ready;
wire local_bb3_cmp34_i_i_stall_local;
wire local_bb3_cmp34_i_i;

assign local_bb3_cmp34_i_i_inputs_ready = (rnode_34to35_bb3_add_i16_i_0_valid_out_0_NO_SHIFT_REG & rnode_34to35_bb3_add_i16_i_0_valid_out_1_NO_SHIFT_REG & rnode_33to35_bb3__84_i_0_valid_out_0_NO_SHIFT_REG & rnode_33to35_bb3__84_i_0_valid_out_1_NO_SHIFT_REG & rnode_34to35_bb3_cmp54_i_i_0_valid_out_NO_SHIFT_REG & rnode_34to35_bb3_leading_zeros_1_i_i_0_valid_out_NO_SHIFT_REG & rnode_34to35_bb3__78_i_0_valid_out_NO_SHIFT_REG & rnode_33to35_bb3__81_i_0_valid_out_NO_SHIFT_REG);
assign local_bb3_cmp34_i_i = (local_bb3_and33_i_i > 64'h4);
assign local_bb3_and44_i_i_valid_out = 1'b1;
assign local_bb3_cmp30_i_i_valid_out = 1'b1;
assign local_bb3_cmp34_i_i_valid_out = 1'b1;
assign local_bb3_and88_i_i_valid_out = 1'b1;
assign rnode_34to35_bb3_add_i16_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_34to35_bb3_add_i16_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_33to35_bb3__84_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_33to35_bb3__84_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_34to35_bb3_cmp54_i_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_34to35_bb3_leading_zeros_1_i_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_34to35_bb3__78_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_33to35_bb3__81_i_0_stall_in_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_and44_i_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_cmp30_i_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_cmp34_i_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_and88_i_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3_and44_i_i_consumed_0_NO_SHIFT_REG <= (local_bb3_cmp34_i_i_inputs_ready & (local_bb3_and44_i_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_and44_i_i_stall_in)) & local_bb3_cmp34_i_i_stall_local);
		local_bb3_cmp30_i_i_consumed_0_NO_SHIFT_REG <= (local_bb3_cmp34_i_i_inputs_ready & (local_bb3_cmp30_i_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_cmp30_i_i_stall_in)) & local_bb3_cmp34_i_i_stall_local);
		local_bb3_cmp34_i_i_consumed_0_NO_SHIFT_REG <= (local_bb3_cmp34_i_i_inputs_ready & (local_bb3_cmp34_i_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_cmp34_i_i_stall_in)) & local_bb3_cmp34_i_i_stall_local);
		local_bb3_and88_i_i_consumed_0_NO_SHIFT_REG <= (local_bb3_cmp34_i_i_inputs_ready & (local_bb3_and88_i_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_and88_i_i_stall_in)) & local_bb3_cmp34_i_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_35to36_bb3_and44_i_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_35to36_bb3_and44_i_i_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_35to36_bb3_and44_i_i_0_NO_SHIFT_REG;
 logic rnode_35to36_bb3_and44_i_i_0_reg_36_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_35to36_bb3_and44_i_i_0_reg_36_NO_SHIFT_REG;
 logic rnode_35to36_bb3_and44_i_i_0_valid_out_reg_36_NO_SHIFT_REG;
 logic rnode_35to36_bb3_and44_i_i_0_stall_in_reg_36_NO_SHIFT_REG;
 logic rnode_35to36_bb3_and44_i_i_0_stall_out_reg_36_NO_SHIFT_REG;

acl_data_fifo rnode_35to36_bb3_and44_i_i_0_reg_36_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_35to36_bb3_and44_i_i_0_reg_36_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_35to36_bb3_and44_i_i_0_stall_in_reg_36_NO_SHIFT_REG),
	.valid_out(rnode_35to36_bb3_and44_i_i_0_valid_out_reg_36_NO_SHIFT_REG),
	.stall_out(rnode_35to36_bb3_and44_i_i_0_stall_out_reg_36_NO_SHIFT_REG),
	.data_in(local_bb3_and44_i_i),
	.data_out(rnode_35to36_bb3_and44_i_i_0_reg_36_NO_SHIFT_REG)
);

defparam rnode_35to36_bb3_and44_i_i_0_reg_36_fifo.DEPTH = 1;
defparam rnode_35to36_bb3_and44_i_i_0_reg_36_fifo.DATA_WIDTH = 64;
defparam rnode_35to36_bb3_and44_i_i_0_reg_36_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_35to36_bb3_and44_i_i_0_reg_36_fifo.IMPL = "shift_reg";

assign rnode_35to36_bb3_and44_i_i_0_reg_36_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and44_i_i_stall_in = 1'b0;
assign rnode_35to36_bb3_and44_i_i_0_NO_SHIFT_REG = rnode_35to36_bb3_and44_i_i_0_reg_36_NO_SHIFT_REG;
assign rnode_35to36_bb3_and44_i_i_0_stall_in_reg_36_NO_SHIFT_REG = 1'b0;
assign rnode_35to36_bb3_and44_i_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_35to36_bb3_cmp30_i_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_35to36_bb3_cmp30_i_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_35to36_bb3_cmp30_i_i_0_NO_SHIFT_REG;
 logic rnode_35to36_bb3_cmp30_i_i_0_reg_36_inputs_ready_NO_SHIFT_REG;
 logic rnode_35to36_bb3_cmp30_i_i_0_reg_36_NO_SHIFT_REG;
 logic rnode_35to36_bb3_cmp30_i_i_0_valid_out_reg_36_NO_SHIFT_REG;
 logic rnode_35to36_bb3_cmp30_i_i_0_stall_in_reg_36_NO_SHIFT_REG;
 logic rnode_35to36_bb3_cmp30_i_i_0_stall_out_reg_36_NO_SHIFT_REG;

acl_data_fifo rnode_35to36_bb3_cmp30_i_i_0_reg_36_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_35to36_bb3_cmp30_i_i_0_reg_36_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_35to36_bb3_cmp30_i_i_0_stall_in_reg_36_NO_SHIFT_REG),
	.valid_out(rnode_35to36_bb3_cmp30_i_i_0_valid_out_reg_36_NO_SHIFT_REG),
	.stall_out(rnode_35to36_bb3_cmp30_i_i_0_stall_out_reg_36_NO_SHIFT_REG),
	.data_in(local_bb3_cmp30_i_i),
	.data_out(rnode_35to36_bb3_cmp30_i_i_0_reg_36_NO_SHIFT_REG)
);

defparam rnode_35to36_bb3_cmp30_i_i_0_reg_36_fifo.DEPTH = 1;
defparam rnode_35to36_bb3_cmp30_i_i_0_reg_36_fifo.DATA_WIDTH = 1;
defparam rnode_35to36_bb3_cmp30_i_i_0_reg_36_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_35to36_bb3_cmp30_i_i_0_reg_36_fifo.IMPL = "shift_reg";

assign rnode_35to36_bb3_cmp30_i_i_0_reg_36_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_cmp30_i_i_stall_in = 1'b0;
assign rnode_35to36_bb3_cmp30_i_i_0_NO_SHIFT_REG = rnode_35to36_bb3_cmp30_i_i_0_reg_36_NO_SHIFT_REG;
assign rnode_35to36_bb3_cmp30_i_i_0_stall_in_reg_36_NO_SHIFT_REG = 1'b0;
assign rnode_35to36_bb3_cmp30_i_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_35to36_bb3_cmp34_i_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_35to36_bb3_cmp34_i_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_35to36_bb3_cmp34_i_i_0_NO_SHIFT_REG;
 logic rnode_35to36_bb3_cmp34_i_i_0_reg_36_inputs_ready_NO_SHIFT_REG;
 logic rnode_35to36_bb3_cmp34_i_i_0_reg_36_NO_SHIFT_REG;
 logic rnode_35to36_bb3_cmp34_i_i_0_valid_out_reg_36_NO_SHIFT_REG;
 logic rnode_35to36_bb3_cmp34_i_i_0_stall_in_reg_36_NO_SHIFT_REG;
 logic rnode_35to36_bb3_cmp34_i_i_0_stall_out_reg_36_NO_SHIFT_REG;

acl_data_fifo rnode_35to36_bb3_cmp34_i_i_0_reg_36_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_35to36_bb3_cmp34_i_i_0_reg_36_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_35to36_bb3_cmp34_i_i_0_stall_in_reg_36_NO_SHIFT_REG),
	.valid_out(rnode_35to36_bb3_cmp34_i_i_0_valid_out_reg_36_NO_SHIFT_REG),
	.stall_out(rnode_35to36_bb3_cmp34_i_i_0_stall_out_reg_36_NO_SHIFT_REG),
	.data_in(local_bb3_cmp34_i_i),
	.data_out(rnode_35to36_bb3_cmp34_i_i_0_reg_36_NO_SHIFT_REG)
);

defparam rnode_35to36_bb3_cmp34_i_i_0_reg_36_fifo.DEPTH = 1;
defparam rnode_35to36_bb3_cmp34_i_i_0_reg_36_fifo.DATA_WIDTH = 1;
defparam rnode_35to36_bb3_cmp34_i_i_0_reg_36_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_35to36_bb3_cmp34_i_i_0_reg_36_fifo.IMPL = "shift_reg";

assign rnode_35to36_bb3_cmp34_i_i_0_reg_36_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_cmp34_i_i_stall_in = 1'b0;
assign rnode_35to36_bb3_cmp34_i_i_0_NO_SHIFT_REG = rnode_35to36_bb3_cmp34_i_i_0_reg_36_NO_SHIFT_REG;
assign rnode_35to36_bb3_cmp34_i_i_0_stall_in_reg_36_NO_SHIFT_REG = 1'b0;
assign rnode_35to36_bb3_cmp34_i_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_35to36_bb3_and88_i_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_35to36_bb3_and88_i_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_35to36_bb3_and88_i_i_0_NO_SHIFT_REG;
 logic rnode_35to36_bb3_and88_i_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_35to36_bb3_and88_i_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_35to36_bb3_and88_i_i_1_NO_SHIFT_REG;
 logic rnode_35to36_bb3_and88_i_i_0_reg_36_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_35to36_bb3_and88_i_i_0_reg_36_NO_SHIFT_REG;
 logic rnode_35to36_bb3_and88_i_i_0_valid_out_0_reg_36_NO_SHIFT_REG;
 logic rnode_35to36_bb3_and88_i_i_0_stall_in_0_reg_36_NO_SHIFT_REG;
 logic rnode_35to36_bb3_and88_i_i_0_stall_out_reg_36_NO_SHIFT_REG;

acl_data_fifo rnode_35to36_bb3_and88_i_i_0_reg_36_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_35to36_bb3_and88_i_i_0_reg_36_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_35to36_bb3_and88_i_i_0_stall_in_0_reg_36_NO_SHIFT_REG),
	.valid_out(rnode_35to36_bb3_and88_i_i_0_valid_out_0_reg_36_NO_SHIFT_REG),
	.stall_out(rnode_35to36_bb3_and88_i_i_0_stall_out_reg_36_NO_SHIFT_REG),
	.data_in(local_bb3_and88_i_i),
	.data_out(rnode_35to36_bb3_and88_i_i_0_reg_36_NO_SHIFT_REG)
);

defparam rnode_35to36_bb3_and88_i_i_0_reg_36_fifo.DEPTH = 1;
defparam rnode_35to36_bb3_and88_i_i_0_reg_36_fifo.DATA_WIDTH = 32;
defparam rnode_35to36_bb3_and88_i_i_0_reg_36_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_35to36_bb3_and88_i_i_0_reg_36_fifo.IMPL = "shift_reg";

assign rnode_35to36_bb3_and88_i_i_0_reg_36_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and88_i_i_stall_in = 1'b0;
assign rnode_35to36_bb3_and88_i_i_0_stall_in_0_reg_36_NO_SHIFT_REG = 1'b0;
assign rnode_35to36_bb3_and88_i_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_35to36_bb3_and88_i_i_0_NO_SHIFT_REG = rnode_35to36_bb3_and88_i_i_0_reg_36_NO_SHIFT_REG;
assign rnode_35to36_bb3_and88_i_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_35to36_bb3_and88_i_i_1_NO_SHIFT_REG = rnode_35to36_bb3_and88_i_i_0_reg_36_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_or_cond_i_i_stall_local;
wire local_bb3_or_cond_i_i;

assign local_bb3_or_cond_i_i = (rnode_35to36_bb3_cmp30_i_i_0_NO_SHIFT_REG | rnode_35to36_bb3_cmp34_i_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_or89_i_i_stall_local;
wire [31:0] local_bb3_or89_i_i;

assign local_bb3_or89_i_i = (rnode_35to36_bb3_and88_i_i_0_NO_SHIFT_REG | rnode_35to36_bb3_shl_i57_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3__tr1_i_i_valid_out;
wire local_bb3__tr1_i_i_stall_in;
wire local_bb3__tr1_i_i_inputs_ready;
wire local_bb3__tr1_i_i_stall_local;
wire [15:0] local_bb3__tr1_i_i;

assign local_bb3__tr1_i_i_inputs_ready = rnode_35to36_bb3_and88_i_i_0_valid_out_1_NO_SHIFT_REG;
assign local_bb3__tr1_i_i = rnode_35to36_bb3_and88_i_i_1_NO_SHIFT_REG[15:0];
assign local_bb3__tr1_i_i_valid_out = 1'b1;
assign rnode_35to36_bb3_and88_i_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb3_increment_0_i_i_stall_local;
wire [63:0] local_bb3_increment_0_i_i;

assign local_bb3_increment_0_i_i = (local_bb3_or_cond_i_i ? 64'h8 : 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_conv90_i_i_stall_local;
wire [63:0] local_bb3_conv90_i_i;

assign local_bb3_conv90_i_i[63:32] = 32'h0;
assign local_bb3_conv90_i_i[31:0] = local_bb3_or89_i_i;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_36to37_bb3__tr1_i_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_36to37_bb3__tr1_i_i_0_stall_in_NO_SHIFT_REG;
 logic [15:0] rnode_36to37_bb3__tr1_i_i_0_NO_SHIFT_REG;
 logic rnode_36to37_bb3__tr1_i_i_0_reg_37_inputs_ready_NO_SHIFT_REG;
 logic [15:0] rnode_36to37_bb3__tr1_i_i_0_reg_37_NO_SHIFT_REG;
 logic rnode_36to37_bb3__tr1_i_i_0_valid_out_reg_37_NO_SHIFT_REG;
 logic rnode_36to37_bb3__tr1_i_i_0_stall_in_reg_37_NO_SHIFT_REG;
 logic rnode_36to37_bb3__tr1_i_i_0_stall_out_reg_37_NO_SHIFT_REG;

acl_data_fifo rnode_36to37_bb3__tr1_i_i_0_reg_37_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_36to37_bb3__tr1_i_i_0_reg_37_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_36to37_bb3__tr1_i_i_0_stall_in_reg_37_NO_SHIFT_REG),
	.valid_out(rnode_36to37_bb3__tr1_i_i_0_valid_out_reg_37_NO_SHIFT_REG),
	.stall_out(rnode_36to37_bb3__tr1_i_i_0_stall_out_reg_37_NO_SHIFT_REG),
	.data_in(local_bb3__tr1_i_i),
	.data_out(rnode_36to37_bb3__tr1_i_i_0_reg_37_NO_SHIFT_REG)
);

defparam rnode_36to37_bb3__tr1_i_i_0_reg_37_fifo.DEPTH = 1;
defparam rnode_36to37_bb3__tr1_i_i_0_reg_37_fifo.DATA_WIDTH = 16;
defparam rnode_36to37_bb3__tr1_i_i_0_reg_37_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_36to37_bb3__tr1_i_i_0_reg_37_fifo.IMPL = "shift_reg";

assign rnode_36to37_bb3__tr1_i_i_0_reg_37_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3__tr1_i_i_stall_in = 1'b0;
assign rnode_36to37_bb3__tr1_i_i_0_NO_SHIFT_REG = rnode_36to37_bb3__tr1_i_i_0_reg_37_NO_SHIFT_REG;
assign rnode_36to37_bb3__tr1_i_i_0_stall_in_reg_37_NO_SHIFT_REG = 1'b0;
assign rnode_36to37_bb3__tr1_i_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_and3_i5_i_stall_local;
wire [63:0] local_bb3_and3_i5_i;

assign local_bb3_and3_i5_i = (local_bb3_conv90_i_i >> 64'hB);

// This section implements an unregistered operation.
// 
wire local_bb3_conv50_i_i_stall_local;
wire [15:0] local_bb3_conv50_i_i;

assign local_bb3_conv50_i_i = (rnode_36to37_bb3__tr1_i_i_0_NO_SHIFT_REG & 16'hFFF);

// This section implements an unregistered operation.
// 
wire local_bb3__pre_i_i_stall_local;
wire [63:0] local_bb3__pre_i_i;

assign local_bb3__pre_i_i = (local_bb3_and3_i5_i & 64'h1);

// This section implements an unregistered operation.
// 
wire local_bb3_tobool40_i_i_stall_local;
wire local_bb3_tobool40_i_i;

assign local_bb3_tobool40_i_i = (local_bb3__pre_i_i == 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_tobool51_i_i_stall_local;
wire local_bb3_tobool51_i_i;

assign local_bb3_tobool51_i_i = (local_bb3__pre_i_i != 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_increment_1_i_i_stall_local;
wire [63:0] local_bb3_increment_1_i_i;

assign local_bb3_increment_1_i_i = (local_bb3_tobool40_i_i ? local_bb3_increment_0_i_i : 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_not_tobool51_i_i_stall_local;
wire local_bb3_not_tobool51_i_i;

assign local_bb3_not_tobool51_i_i = (local_bb3_tobool51_i_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb3_add_i_i_stall_local;
wire [63:0] local_bb3_add_i_i;

assign local_bb3_add_i_i = (local_bb3_increment_1_i_i + rnode_35to36_bb3_and44_i_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_and46_i_i_stall_local;
wire [63:0] local_bb3_and46_i_i;

assign local_bb3_and46_i_i = (local_bb3_add_i_i & 64'h100000000000000);

// This section implements an unregistered operation.
// 
wire local_bb3_tobool47_i_not_i_stall_local;
wire local_bb3_tobool47_i_not_i;

assign local_bb3_tobool47_i_not_i = (local_bb3_and46_i_i != 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3__91_i_stall_local;
wire local_bb3__91_i;

assign local_bb3__91_i = (local_bb3_tobool47_i_not_i & local_bb3_not_tobool51_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_shr59_i_i_stall_local;
wire [63:0] local_bb3_shr59_i_i;

assign local_bb3_shr59_i_i[63:1] = 63'h0;
assign local_bb3_shr59_i_i[0] = local_bb3__91_i;

// This section implements an unregistered operation.
// 
wire local_bb3_add57_i_i_stall_local;
wire [15:0] local_bb3_add57_i_i;

assign local_bb3_add57_i_i[15:1] = 15'h0;
assign local_bb3_add57_i_i[0] = local_bb3__91_i;

// This section implements an unregistered operation.
// 
wire local_bb3__92_i_stall_local;
wire [63:0] local_bb3__92_i;

assign local_bb3__92_i = (local_bb3_tobool51_i_i ? 64'h0 : local_bb3_shr59_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3__93_i_stall_local;
wire [63:0] local_bb3__93_i;

assign local_bb3__93_i = (local_bb3_add_i_i >> local_bb3__92_i);

// This section implements an unregistered operation.
// 
wire local_bb3_conv90_i_i_valid_out_1;
wire local_bb3_conv90_i_i_stall_in_1;
 reg local_bb3_conv90_i_i_consumed_1_NO_SHIFT_REG;
wire local_bb3_tobool51_i_i_valid_out_2;
wire local_bb3_tobool51_i_i_stall_in_2;
 reg local_bb3_tobool51_i_i_consumed_2_NO_SHIFT_REG;
wire local_bb3_add57_i_i_valid_out;
wire local_bb3_add57_i_i_stall_in;
 reg local_bb3_add57_i_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_result_0_i_op_i_valid_out;
wire local_bb3_result_0_i_op_i_stall_in;
 reg local_bb3_result_0_i_op_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_result_0_i_op_i_inputs_ready;
wire local_bb3_result_0_i_op_i_stall_local;
wire [63:0] local_bb3_result_0_i_op_i;

assign local_bb3_result_0_i_op_i_inputs_ready = (rnode_35to36_bb3_and88_i_i_0_valid_out_0_NO_SHIFT_REG & rnode_35to36_bb3_shl_i57_i_0_valid_out_NO_SHIFT_REG & rnode_35to36_bb3_and44_i_i_0_valid_out_NO_SHIFT_REG & rnode_35to36_bb3_cmp30_i_i_0_valid_out_NO_SHIFT_REG & rnode_35to36_bb3_cmp34_i_i_0_valid_out_NO_SHIFT_REG);
assign local_bb3_result_0_i_op_i = (local_bb3__93_i >> 64'h3);
assign local_bb3_conv90_i_i_valid_out_1 = 1'b1;
assign local_bb3_tobool51_i_i_valid_out_2 = 1'b1;
assign local_bb3_add57_i_i_valid_out = 1'b1;
assign local_bb3_result_0_i_op_i_valid_out = 1'b1;
assign rnode_35to36_bb3_and88_i_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_35to36_bb3_shl_i57_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_35to36_bb3_and44_i_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_35to36_bb3_cmp30_i_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_35to36_bb3_cmp34_i_i_0_stall_in_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_conv90_i_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb3_tobool51_i_i_consumed_2_NO_SHIFT_REG <= 1'b0;
		local_bb3_add57_i_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_result_0_i_op_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3_conv90_i_i_consumed_1_NO_SHIFT_REG <= (local_bb3_result_0_i_op_i_inputs_ready & (local_bb3_conv90_i_i_consumed_1_NO_SHIFT_REG | ~(local_bb3_conv90_i_i_stall_in_1)) & local_bb3_result_0_i_op_i_stall_local);
		local_bb3_tobool51_i_i_consumed_2_NO_SHIFT_REG <= (local_bb3_result_0_i_op_i_inputs_ready & (local_bb3_tobool51_i_i_consumed_2_NO_SHIFT_REG | ~(local_bb3_tobool51_i_i_stall_in_2)) & local_bb3_result_0_i_op_i_stall_local);
		local_bb3_add57_i_i_consumed_0_NO_SHIFT_REG <= (local_bb3_result_0_i_op_i_inputs_ready & (local_bb3_add57_i_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_add57_i_i_stall_in)) & local_bb3_result_0_i_op_i_stall_local);
		local_bb3_result_0_i_op_i_consumed_0_NO_SHIFT_REG <= (local_bb3_result_0_i_op_i_inputs_ready & (local_bb3_result_0_i_op_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_result_0_i_op_i_stall_in)) & local_bb3_result_0_i_op_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_36to37_bb3_conv90_i_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_36to37_bb3_conv90_i_i_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_36to37_bb3_conv90_i_i_0_NO_SHIFT_REG;
 logic rnode_36to37_bb3_conv90_i_i_0_reg_37_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_36to37_bb3_conv90_i_i_0_reg_37_NO_SHIFT_REG;
 logic rnode_36to37_bb3_conv90_i_i_0_valid_out_reg_37_NO_SHIFT_REG;
 logic rnode_36to37_bb3_conv90_i_i_0_stall_in_reg_37_NO_SHIFT_REG;
 logic rnode_36to37_bb3_conv90_i_i_0_stall_out_reg_37_NO_SHIFT_REG;

acl_data_fifo rnode_36to37_bb3_conv90_i_i_0_reg_37_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_36to37_bb3_conv90_i_i_0_reg_37_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_36to37_bb3_conv90_i_i_0_stall_in_reg_37_NO_SHIFT_REG),
	.valid_out(rnode_36to37_bb3_conv90_i_i_0_valid_out_reg_37_NO_SHIFT_REG),
	.stall_out(rnode_36to37_bb3_conv90_i_i_0_stall_out_reg_37_NO_SHIFT_REG),
	.data_in(local_bb3_conv90_i_i),
	.data_out(rnode_36to37_bb3_conv90_i_i_0_reg_37_NO_SHIFT_REG)
);

defparam rnode_36to37_bb3_conv90_i_i_0_reg_37_fifo.DEPTH = 1;
defparam rnode_36to37_bb3_conv90_i_i_0_reg_37_fifo.DATA_WIDTH = 64;
defparam rnode_36to37_bb3_conv90_i_i_0_reg_37_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_36to37_bb3_conv90_i_i_0_reg_37_fifo.IMPL = "shift_reg";

assign rnode_36to37_bb3_conv90_i_i_0_reg_37_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_conv90_i_i_stall_in_1 = 1'b0;
assign rnode_36to37_bb3_conv90_i_i_0_NO_SHIFT_REG = rnode_36to37_bb3_conv90_i_i_0_reg_37_NO_SHIFT_REG;
assign rnode_36to37_bb3_conv90_i_i_0_stall_in_reg_37_NO_SHIFT_REG = 1'b0;
assign rnode_36to37_bb3_conv90_i_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_36to37_bb3_tobool51_i_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_36to37_bb3_tobool51_i_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_36to37_bb3_tobool51_i_i_0_NO_SHIFT_REG;
 logic rnode_36to37_bb3_tobool51_i_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_36to37_bb3_tobool51_i_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_36to37_bb3_tobool51_i_i_1_NO_SHIFT_REG;
 logic rnode_36to37_bb3_tobool51_i_i_0_reg_37_inputs_ready_NO_SHIFT_REG;
 logic rnode_36to37_bb3_tobool51_i_i_0_reg_37_NO_SHIFT_REG;
 logic rnode_36to37_bb3_tobool51_i_i_0_valid_out_0_reg_37_NO_SHIFT_REG;
 logic rnode_36to37_bb3_tobool51_i_i_0_stall_in_0_reg_37_NO_SHIFT_REG;
 logic rnode_36to37_bb3_tobool51_i_i_0_stall_out_reg_37_NO_SHIFT_REG;

acl_data_fifo rnode_36to37_bb3_tobool51_i_i_0_reg_37_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_36to37_bb3_tobool51_i_i_0_reg_37_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_36to37_bb3_tobool51_i_i_0_stall_in_0_reg_37_NO_SHIFT_REG),
	.valid_out(rnode_36to37_bb3_tobool51_i_i_0_valid_out_0_reg_37_NO_SHIFT_REG),
	.stall_out(rnode_36to37_bb3_tobool51_i_i_0_stall_out_reg_37_NO_SHIFT_REG),
	.data_in(local_bb3_tobool51_i_i),
	.data_out(rnode_36to37_bb3_tobool51_i_i_0_reg_37_NO_SHIFT_REG)
);

defparam rnode_36to37_bb3_tobool51_i_i_0_reg_37_fifo.DEPTH = 1;
defparam rnode_36to37_bb3_tobool51_i_i_0_reg_37_fifo.DATA_WIDTH = 1;
defparam rnode_36to37_bb3_tobool51_i_i_0_reg_37_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_36to37_bb3_tobool51_i_i_0_reg_37_fifo.IMPL = "shift_reg";

assign rnode_36to37_bb3_tobool51_i_i_0_reg_37_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_tobool51_i_i_stall_in_2 = 1'b0;
assign rnode_36to37_bb3_tobool51_i_i_0_stall_in_0_reg_37_NO_SHIFT_REG = 1'b0;
assign rnode_36to37_bb3_tobool51_i_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_36to37_bb3_tobool51_i_i_0_NO_SHIFT_REG = rnode_36to37_bb3_tobool51_i_i_0_reg_37_NO_SHIFT_REG;
assign rnode_36to37_bb3_tobool51_i_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_36to37_bb3_tobool51_i_i_1_NO_SHIFT_REG = rnode_36to37_bb3_tobool51_i_i_0_reg_37_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_36to37_bb3_add57_i_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_36to37_bb3_add57_i_i_0_stall_in_NO_SHIFT_REG;
 logic [15:0] rnode_36to37_bb3_add57_i_i_0_NO_SHIFT_REG;
 logic rnode_36to37_bb3_add57_i_i_0_reg_37_inputs_ready_NO_SHIFT_REG;
 logic [15:0] rnode_36to37_bb3_add57_i_i_0_reg_37_NO_SHIFT_REG;
 logic rnode_36to37_bb3_add57_i_i_0_valid_out_reg_37_NO_SHIFT_REG;
 logic rnode_36to37_bb3_add57_i_i_0_stall_in_reg_37_NO_SHIFT_REG;
 logic rnode_36to37_bb3_add57_i_i_0_stall_out_reg_37_NO_SHIFT_REG;

acl_data_fifo rnode_36to37_bb3_add57_i_i_0_reg_37_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_36to37_bb3_add57_i_i_0_reg_37_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_36to37_bb3_add57_i_i_0_stall_in_reg_37_NO_SHIFT_REG),
	.valid_out(rnode_36to37_bb3_add57_i_i_0_valid_out_reg_37_NO_SHIFT_REG),
	.stall_out(rnode_36to37_bb3_add57_i_i_0_stall_out_reg_37_NO_SHIFT_REG),
	.data_in(local_bb3_add57_i_i),
	.data_out(rnode_36to37_bb3_add57_i_i_0_reg_37_NO_SHIFT_REG)
);

defparam rnode_36to37_bb3_add57_i_i_0_reg_37_fifo.DEPTH = 1;
defparam rnode_36to37_bb3_add57_i_i_0_reg_37_fifo.DATA_WIDTH = 16;
defparam rnode_36to37_bb3_add57_i_i_0_reg_37_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_36to37_bb3_add57_i_i_0_reg_37_fifo.IMPL = "shift_reg";

assign rnode_36to37_bb3_add57_i_i_0_reg_37_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_add57_i_i_stall_in = 1'b0;
assign rnode_36to37_bb3_add57_i_i_0_NO_SHIFT_REG = rnode_36to37_bb3_add57_i_i_0_reg_37_NO_SHIFT_REG;
assign rnode_36to37_bb3_add57_i_i_0_stall_in_reg_37_NO_SHIFT_REG = 1'b0;
assign rnode_36to37_bb3_add57_i_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_36to37_bb3_result_0_i_op_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_36to37_bb3_result_0_i_op_i_0_stall_in_NO_SHIFT_REG;
 logic [63:0] rnode_36to37_bb3_result_0_i_op_i_0_NO_SHIFT_REG;
 logic rnode_36to37_bb3_result_0_i_op_i_0_reg_37_inputs_ready_NO_SHIFT_REG;
 logic [63:0] rnode_36to37_bb3_result_0_i_op_i_0_reg_37_NO_SHIFT_REG;
 logic rnode_36to37_bb3_result_0_i_op_i_0_valid_out_reg_37_NO_SHIFT_REG;
 logic rnode_36to37_bb3_result_0_i_op_i_0_stall_in_reg_37_NO_SHIFT_REG;
 logic rnode_36to37_bb3_result_0_i_op_i_0_stall_out_reg_37_NO_SHIFT_REG;

acl_data_fifo rnode_36to37_bb3_result_0_i_op_i_0_reg_37_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_36to37_bb3_result_0_i_op_i_0_reg_37_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_36to37_bb3_result_0_i_op_i_0_stall_in_reg_37_NO_SHIFT_REG),
	.valid_out(rnode_36to37_bb3_result_0_i_op_i_0_valid_out_reg_37_NO_SHIFT_REG),
	.stall_out(rnode_36to37_bb3_result_0_i_op_i_0_stall_out_reg_37_NO_SHIFT_REG),
	.data_in(local_bb3_result_0_i_op_i),
	.data_out(rnode_36to37_bb3_result_0_i_op_i_0_reg_37_NO_SHIFT_REG)
);

defparam rnode_36to37_bb3_result_0_i_op_i_0_reg_37_fifo.DEPTH = 1;
defparam rnode_36to37_bb3_result_0_i_op_i_0_reg_37_fifo.DATA_WIDTH = 64;
defparam rnode_36to37_bb3_result_0_i_op_i_0_reg_37_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_36to37_bb3_result_0_i_op_i_0_reg_37_fifo.IMPL = "shift_reg";

assign rnode_36to37_bb3_result_0_i_op_i_0_reg_37_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_result_0_i_op_i_stall_in = 1'b0;
assign rnode_36to37_bb3_result_0_i_op_i_0_NO_SHIFT_REG = rnode_36to37_bb3_result_0_i_op_i_0_reg_37_NO_SHIFT_REG;
assign rnode_36to37_bb3_result_0_i_op_i_0_stall_in_reg_37_NO_SHIFT_REG = 1'b0;
assign rnode_36to37_bb3_result_0_i_op_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3__94_i_stall_local;
wire [15:0] local_bb3__94_i;

assign local_bb3__94_i = (rnode_36to37_bb3_tobool51_i_i_0_NO_SHIFT_REG ? 16'h0 : rnode_36to37_bb3_add57_i_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_result_0_i_op_op_i_stall_local;
wire [63:0] local_bb3_result_0_i_op_op_i;

assign local_bb3_result_0_i_op_op_i = (rnode_36to37_bb3_result_0_i_op_i_0_NO_SHIFT_REG & 64'hFFFFFFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3__95_i_stall_local;
wire [15:0] local_bb3__95_i;

assign local_bb3__95_i = (local_bb3_conv50_i_i + local_bb3__94_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp64_not_i_i_stall_local;
wire local_bb3_cmp64_not_i_i;

assign local_bb3_cmp64_not_i_i = (local_bb3__95_i != 16'h7FF);

// This section implements an unregistered operation.
// 
wire local_bb3_var__u34_stall_local;
wire [63:0] local_bb3_var__u34;

assign local_bb3_var__u34[63:16] = 48'h0;
assign local_bb3_var__u34[15:0] = local_bb3__95_i;

// This section implements an unregistered operation.
// 
wire local_bb3_brmerge_i_i_stall_local;
wire local_bb3_brmerge_i_i;

assign local_bb3_brmerge_i_i = (local_bb3_cmp64_not_i_i | rnode_36to37_bb3_tobool51_i_i_1_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_conv70_i_i_stall_local;
wire [63:0] local_bb3_conv70_i_i;

assign local_bb3_conv70_i_i = (local_bb3_brmerge_i_i ? local_bb3_var__u34 : 64'hFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_and4_i_i_stall_local;
wire [63:0] local_bb3_and4_i_i;

assign local_bb3_and4_i_i = (local_bb3_brmerge_i_i ? local_bb3_result_0_i_op_op_i : 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_or_i8_i_stall_local;
wire [63:0] local_bb3_or_i8_i;

assign local_bb3_or_i8_i = (local_bb3_conv70_i_i | rnode_36to37_bb3_conv90_i_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_and1_i_i_stall_local;
wire [63:0] local_bb3_and1_i_i;

assign local_bb3_and1_i_i = (local_bb3_conv70_i_i << 64'h34);

// This section implements an unregistered operation.
// 
wire local_bb3_and5_i_i_stall_local;
wire [63:0] local_bb3_and5_i_i;

assign local_bb3_and5_i_i = (local_bb3_conv70_i_i & 64'h800);

// This section implements an unregistered operation.
// 
wire local_bb3_var__u35_stall_local;
wire [63:0] local_bb3_var__u35;

assign local_bb3_var__u35 = (local_bb3_or_i8_i << 64'h33);

// This section implements an unregistered operation.
// 
wire local_bb3_shl2_i_i_stall_local;
wire [63:0] local_bb3_shl2_i_i;

assign local_bb3_shl2_i_i = (local_bb3_and1_i_i & 64'h7FF0000000000000);

// This section implements an unregistered operation.
// 
wire local_bb3_tobool_i_i_stall_local;
wire local_bb3_tobool_i_i;

assign local_bb3_tobool_i_i = (local_bb3_and5_i_i == 64'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_shl_i1_i_stall_local;
wire [63:0] local_bb3_shl_i1_i;

assign local_bb3_shl_i1_i = (local_bb3_var__u35 & 64'h8000000000000000);

// This section implements an unregistered operation.
// 
wire local_bb3_exponent_0_i2_i_stall_local;
wire [63:0] local_bb3_exponent_0_i2_i;

assign local_bb3_exponent_0_i2_i = (local_bb3_tobool_i_i ? local_bb3_shl2_i_i : 64'h7FF0000000000000);

// This section implements an unregistered operation.
// 
wire local_bb3_or_i3_i_stall_local;
wire [63:0] local_bb3_or_i3_i;

assign local_bb3_or_i3_i = (local_bb3_exponent_0_i2_i | local_bb3_and4_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_or6_i_i41_stall_local;
wire [63:0] local_bb3_or6_i_i41;

assign local_bb3_or6_i_i41 = (local_bb3_or_i3_i | local_bb3_shl_i1_i);

// This section implements an unregistered operation.
// 
wire local_bb3_astype_i4_i_valid_out;
wire local_bb3_astype_i4_i_stall_in;
wire local_bb3_astype_i4_i_inputs_ready;
wire local_bb3_astype_i4_i_stall_local;
wire [63:0] local_bb3_astype_i4_i;

assign local_bb3_astype_i4_i_inputs_ready = (rnode_36to37_bb3_conv90_i_i_0_valid_out_NO_SHIFT_REG & rnode_36to37_bb3_tobool51_i_i_0_valid_out_1_NO_SHIFT_REG & rnode_36to37_bb3_tobool51_i_i_0_valid_out_0_NO_SHIFT_REG & rnode_36to37_bb3_add57_i_i_0_valid_out_NO_SHIFT_REG & rnode_36to37_bb3__tr1_i_i_0_valid_out_NO_SHIFT_REG & rnode_36to37_bb3_result_0_i_op_i_0_valid_out_NO_SHIFT_REG);
assign local_bb3_astype_i4_i = local_bb3_or6_i_i41;
assign local_bb3_astype_i4_i_valid_out = 1'b1;
assign rnode_36to37_bb3_conv90_i_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_36to37_bb3_tobool51_i_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_36to37_bb3_tobool51_i_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_36to37_bb3_add57_i_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_36to37_bb3__tr1_i_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_36to37_bb3_result_0_i_op_i_0_stall_in_NO_SHIFT_REG = 1'b0;

// This section implements a registered operation.
// 
wire local_bb3_conv12_inputs_ready;
 reg local_bb3_conv12_valid_out_NO_SHIFT_REG;
wire local_bb3_conv12_stall_in;
wire local_bb3_conv12_output_regs_ready;
wire [31:0] local_bb3_conv12;
 reg local_bb3_conv12_valid_pipe_0_NO_SHIFT_REG;
 reg local_bb3_conv12_valid_pipe_1_NO_SHIFT_REG;
wire local_bb3_conv12_causedstall;

acl_fp_fptrunc fp_module_local_bb3_conv12 (
	.clock(clock),
	.dataa(local_bb3_astype_i4_i),
	.enable(local_bb3_conv12_output_regs_ready),
	.result(local_bb3_conv12)
);


assign local_bb3_conv12_inputs_ready = 1'b1;
assign local_bb3_conv12_output_regs_ready = 1'b1;
assign local_bb3_astype_i4_i_stall_in = 1'b0;
assign local_bb3_conv12_causedstall = (1'b1 && (1'b0 && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_conv12_valid_pipe_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_conv12_valid_pipe_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_conv12_output_regs_ready)
		begin
			local_bb3_conv12_valid_pipe_0_NO_SHIFT_REG <= 1'b1;
			local_bb3_conv12_valid_pipe_1_NO_SHIFT_REG <= local_bb3_conv12_valid_pipe_0_NO_SHIFT_REG;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_conv12_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_conv12_output_regs_ready)
		begin
			local_bb3_conv12_valid_out_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb3_conv12_stall_in))
			begin
				local_bb3_conv12_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3_c0_exi14_valid_out;
wire local_bb3_c0_exi14_stall_in;
wire local_bb3_c0_exi14_inputs_ready;
wire local_bb3_c0_exi14_stall_local;
wire [63:0] local_bb3_c0_exi14;

assign local_bb3_c0_exi14_inputs_ready = local_bb3_conv12_valid_out_NO_SHIFT_REG;
assign local_bb3_c0_exi14[31:0] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
assign local_bb3_c0_exi14[63:32] = local_bb3_conv12;
assign local_bb3_c0_exi14_valid_out = 1'b1;
assign local_bb3_conv12_stall_in = 1'b0;

// This section implements a registered operation.
// 
wire local_bb3_c0_exit5_c0_exi14_inputs_ready;
 reg local_bb3_c0_exit5_c0_exi14_valid_out_NO_SHIFT_REG;
wire local_bb3_c0_exit5_c0_exi14_stall_in;
 reg [63:0] local_bb3_c0_exit5_c0_exi14_NO_SHIFT_REG;
wire [63:0] local_bb3_c0_exit5_c0_exi14_in;
wire local_bb3_c0_exit5_c0_exi14_valid;
wire local_bb3_c0_exit5_c0_exi14_causedstall;

acl_stall_free_sink local_bb3_c0_exit5_c0_exi14_instance (
	.clock(clock),
	.resetn(resetn),
	.data_in(local_bb3_c0_exi14),
	.data_out(local_bb3_c0_exit5_c0_exi14_in),
	.input_accepted(local_bb3_c0_enter2_c0_eni11_input_accepted),
	.valid_out(local_bb3_c0_exit5_c0_exi14_valid),
	.stall_in(~(local_bb3_c0_exit5_c0_exi14_output_regs_ready)),
	.stall_entry(local_bb3_c0_exit5_c0_exi14_entry_stall),
	.valids(local_bb3_c0_exit5_c0_exi14_valid_bits),
	.IIphases(local_bb3_c0_exit5_c0_exi14_phases),
	.inc_pipelined_thread(local_bb3_c0_enter2_c0_eni11_inc_pipelined_thread),
	.dec_pipelined_thread(local_bb3_c0_enter2_c0_eni11_dec_pipelined_thread)
);

defparam local_bb3_c0_exit5_c0_exi14_instance.DATA_WIDTH = 64;
defparam local_bb3_c0_exit5_c0_exi14_instance.PIPELINE_DEPTH = 44;
defparam local_bb3_c0_exit5_c0_exi14_instance.SHARINGII = 1;
defparam local_bb3_c0_exit5_c0_exi14_instance.SCHEDULEII = 1;

assign local_bb3_c0_exit5_c0_exi14_inputs_ready = 1'b1;
assign local_bb3_c0_exit5_c0_exi14_output_regs_ready = (&(~(local_bb3_c0_exit5_c0_exi14_valid_out_NO_SHIFT_REG) | ~(local_bb3_c0_exit5_c0_exi14_stall_in)));
assign local_bb3_c0_exi14_stall_in = 1'b0;
assign local_bb3_c0_exit5_c0_exi14_causedstall = (1'b1 && (1'b0 && !(~(local_bb3_c0_exit5_c0_exi14_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_c0_exit5_c0_exi14_NO_SHIFT_REG <= 'x;
		local_bb3_c0_exit5_c0_exi14_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_c0_exit5_c0_exi14_output_regs_ready)
		begin
			local_bb3_c0_exit5_c0_exi14_NO_SHIFT_REG <= local_bb3_c0_exit5_c0_exi14_in;
			local_bb3_c0_exit5_c0_exi14_valid_out_NO_SHIFT_REG <= local_bb3_c0_exit5_c0_exi14_valid;
		end
		else
		begin
			if (~(local_bb3_c0_exit5_c0_exi14_stall_in))
			begin
				local_bb3_c0_exit5_c0_exi14_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3_c0_exe16_valid_out;
wire local_bb3_c0_exe16_stall_in;
wire local_bb3_c0_exe16_inputs_ready;
wire local_bb3_c0_exe16_stall_local;
wire [31:0] local_bb3_c0_exe16;

assign local_bb3_c0_exe16_inputs_ready = local_bb3_c0_exit5_c0_exi14_valid_out_NO_SHIFT_REG;
assign local_bb3_c0_exe16 = local_bb3_c0_exit5_c0_exi14_NO_SHIFT_REG[63:32];
assign local_bb3_c0_exe16_valid_out = local_bb3_c0_exe16_inputs_ready;
assign local_bb3_c0_exe16_stall_local = local_bb3_c0_exe16_stall_in;
assign local_bb3_c0_exit5_c0_exi14_stall_in = (|local_bb3_c0_exe16_stall_local);

// This section implements a staging register.
// 
wire rstag_45to45_bb3_c0_exe16_valid_out_0;
wire rstag_45to45_bb3_c0_exe16_stall_in_0;
 reg rstag_45to45_bb3_c0_exe16_consumed_0_NO_SHIFT_REG;
wire rstag_45to45_bb3_c0_exe16_valid_out_1;
wire rstag_45to45_bb3_c0_exe16_stall_in_1;
 reg rstag_45to45_bb3_c0_exe16_consumed_1_NO_SHIFT_REG;
wire rstag_45to45_bb3_c0_exe16_inputs_ready;
wire rstag_45to45_bb3_c0_exe16_stall_local;
 reg rstag_45to45_bb3_c0_exe16_staging_valid_NO_SHIFT_REG;
wire rstag_45to45_bb3_c0_exe16_combined_valid;
 reg [31:0] rstag_45to45_bb3_c0_exe16_staging_reg_NO_SHIFT_REG;
wire [31:0] rstag_45to45_bb3_c0_exe16;

assign rstag_45to45_bb3_c0_exe16_inputs_ready = local_bb3_c0_exe16_valid_out;
assign rstag_45to45_bb3_c0_exe16 = (rstag_45to45_bb3_c0_exe16_staging_valid_NO_SHIFT_REG ? rstag_45to45_bb3_c0_exe16_staging_reg_NO_SHIFT_REG : local_bb3_c0_exe16);
assign rstag_45to45_bb3_c0_exe16_combined_valid = (rstag_45to45_bb3_c0_exe16_staging_valid_NO_SHIFT_REG | rstag_45to45_bb3_c0_exe16_inputs_ready);
assign rstag_45to45_bb3_c0_exe16_stall_local = ((rstag_45to45_bb3_c0_exe16_stall_in_0 & ~(rstag_45to45_bb3_c0_exe16_consumed_0_NO_SHIFT_REG)) | (rstag_45to45_bb3_c0_exe16_stall_in_1 & ~(rstag_45to45_bb3_c0_exe16_consumed_1_NO_SHIFT_REG)));
assign rstag_45to45_bb3_c0_exe16_valid_out_0 = (rstag_45to45_bb3_c0_exe16_combined_valid & ~(rstag_45to45_bb3_c0_exe16_consumed_0_NO_SHIFT_REG));
assign rstag_45to45_bb3_c0_exe16_valid_out_1 = (rstag_45to45_bb3_c0_exe16_combined_valid & ~(rstag_45to45_bb3_c0_exe16_consumed_1_NO_SHIFT_REG));
assign local_bb3_c0_exe16_stall_in = (|rstag_45to45_bb3_c0_exe16_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_45to45_bb3_c0_exe16_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_45to45_bb3_c0_exe16_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_45to45_bb3_c0_exe16_stall_local)
		begin
			if (~(rstag_45to45_bb3_c0_exe16_staging_valid_NO_SHIFT_REG))
			begin
				rstag_45to45_bb3_c0_exe16_staging_valid_NO_SHIFT_REG <= rstag_45to45_bb3_c0_exe16_inputs_ready;
			end
		end
		else
		begin
			rstag_45to45_bb3_c0_exe16_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_45to45_bb3_c0_exe16_staging_valid_NO_SHIFT_REG))
		begin
			rstag_45to45_bb3_c0_exe16_staging_reg_NO_SHIFT_REG <= local_bb3_c0_exe16;
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_45to45_bb3_c0_exe16_consumed_0_NO_SHIFT_REG <= 1'b0;
		rstag_45to45_bb3_c0_exe16_consumed_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		rstag_45to45_bb3_c0_exe16_consumed_0_NO_SHIFT_REG <= (rstag_45to45_bb3_c0_exe16_combined_valid & (rstag_45to45_bb3_c0_exe16_consumed_0_NO_SHIFT_REG | ~(rstag_45to45_bb3_c0_exe16_stall_in_0)) & rstag_45to45_bb3_c0_exe16_stall_local);
		rstag_45to45_bb3_c0_exe16_consumed_1_NO_SHIFT_REG <= (rstag_45to45_bb3_c0_exe16_combined_valid & (rstag_45to45_bb3_c0_exe16_consumed_1_NO_SHIFT_REG | ~(rstag_45to45_bb3_c0_exe16_stall_in_1)) & rstag_45to45_bb3_c0_exe16_stall_local);
	end
end


// Register node:
//  * latency = 319
//  * capacity = 319
 logic rnode_45to364_bb3_c0_exe16_0_valid_out_NO_SHIFT_REG;
 logic rnode_45to364_bb3_c0_exe16_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_45to364_bb3_c0_exe16_0_NO_SHIFT_REG;
 logic rnode_45to364_bb3_c0_exe16_0_reg_364_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_45to364_bb3_c0_exe16_0_reg_364_NO_SHIFT_REG;
 logic rnode_45to364_bb3_c0_exe16_0_valid_out_reg_364_NO_SHIFT_REG;
 logic rnode_45to364_bb3_c0_exe16_0_stall_in_reg_364_NO_SHIFT_REG;
 logic rnode_45to364_bb3_c0_exe16_0_stall_out_reg_364_NO_SHIFT_REG;

acl_data_fifo rnode_45to364_bb3_c0_exe16_0_reg_364_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_45to364_bb3_c0_exe16_0_reg_364_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_45to364_bb3_c0_exe16_0_stall_in_reg_364_NO_SHIFT_REG),
	.valid_out(rnode_45to364_bb3_c0_exe16_0_valid_out_reg_364_NO_SHIFT_REG),
	.stall_out(rnode_45to364_bb3_c0_exe16_0_stall_out_reg_364_NO_SHIFT_REG),
	.data_in(rstag_45to45_bb3_c0_exe16),
	.data_out(rnode_45to364_bb3_c0_exe16_0_reg_364_NO_SHIFT_REG)
);

defparam rnode_45to364_bb3_c0_exe16_0_reg_364_fifo.DEPTH = 320;
defparam rnode_45to364_bb3_c0_exe16_0_reg_364_fifo.DATA_WIDTH = 32;
defparam rnode_45to364_bb3_c0_exe16_0_reg_364_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_45to364_bb3_c0_exe16_0_reg_364_fifo.IMPL = "ram";

assign rnode_45to364_bb3_c0_exe16_0_reg_364_inputs_ready_NO_SHIFT_REG = rstag_45to45_bb3_c0_exe16_valid_out_0;
assign rstag_45to45_bb3_c0_exe16_stall_in_0 = rnode_45to364_bb3_c0_exe16_0_stall_out_reg_364_NO_SHIFT_REG;
assign rnode_45to364_bb3_c0_exe16_0_NO_SHIFT_REG = rnode_45to364_bb3_c0_exe16_0_reg_364_NO_SHIFT_REG;
assign rnode_45to364_bb3_c0_exe16_0_stall_in_reg_364_NO_SHIFT_REG = rnode_45to364_bb3_c0_exe16_0_stall_in_NO_SHIFT_REG;
assign rnode_45to364_bb3_c0_exe16_0_valid_out_NO_SHIFT_REG = rnode_45to364_bb3_c0_exe16_0_valid_out_reg_364_NO_SHIFT_REG;

// This section implements a registered operation.
// 
wire local_bb3_st_c0_exe16_inputs_ready;
 reg local_bb3_st_c0_exe16_valid_out_NO_SHIFT_REG;
wire local_bb3_st_c0_exe16_stall_in;
wire local_bb3_st_c0_exe16_output_regs_ready;
wire local_bb3_st_c0_exe16_fu_stall_out;
wire local_bb3_st_c0_exe16_fu_valid_out;
wire [31:0] local_bb3_st_c0_exe16_lsu_wackout;
 reg local_bb3_st_c0_exe16_NO_SHIFT_REG;
wire local_bb3_st_c0_exe16_causedstall;

lsu_top lsu_local_bb3_st_c0_exe16 (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(),
	.stream_size(),
	.stream_reset(),
	.o_stall(local_bb3_st_c0_exe16_fu_stall_out),
	.i_valid(local_bb3_st_c0_exe16_inputs_ready),
	.i_address(rstag_45to45_bb3_arrayidx14),
	.i_writedata(rstag_45to45_bb3_c0_exe16),
	.i_cmpdata(),
	.i_predicate(1'b0),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb3_st_c0_exe16_output_regs_ready)),
	.o_valid(local_bb3_st_c0_exe16_fu_valid_out),
	.o_readdata(),
	.o_input_fifo_depth(),
	.o_writeack(local_bb3_st_c0_exe16_lsu_wackout),
	.i_atomic_op(3'h0),
	.o_active(local_bb3_st_c0_exe16_active),
	.avm_address(avm_local_bb3_st_c0_exe16_address),
	.avm_read(avm_local_bb3_st_c0_exe16_read),
	.avm_readdata(avm_local_bb3_st_c0_exe16_readdata),
	.avm_write(avm_local_bb3_st_c0_exe16_write),
	.avm_writeack(avm_local_bb3_st_c0_exe16_writeack),
	.avm_burstcount(avm_local_bb3_st_c0_exe16_burstcount),
	.avm_writedata(avm_local_bb3_st_c0_exe16_writedata),
	.avm_byteenable(avm_local_bb3_st_c0_exe16_byteenable),
	.avm_waitrequest(avm_local_bb3_st_c0_exe16_waitrequest),
	.avm_readdatavalid(avm_local_bb3_st_c0_exe16_readdatavalid),
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

defparam lsu_local_bb3_st_c0_exe16.AWIDTH = 30;
defparam lsu_local_bb3_st_c0_exe16.WIDTH_BYTES = 4;
defparam lsu_local_bb3_st_c0_exe16.MWIDTH_BYTES = 32;
defparam lsu_local_bb3_st_c0_exe16.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb3_st_c0_exe16.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb3_st_c0_exe16.READ = 0;
defparam lsu_local_bb3_st_c0_exe16.ATOMIC = 0;
defparam lsu_local_bb3_st_c0_exe16.WIDTH = 32;
defparam lsu_local_bb3_st_c0_exe16.MWIDTH = 256;
defparam lsu_local_bb3_st_c0_exe16.ATOMIC_WIDTH = 3;
defparam lsu_local_bb3_st_c0_exe16.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb3_st_c0_exe16.KERNEL_SIDE_MEM_LATENCY = 160;
defparam lsu_local_bb3_st_c0_exe16.MEMORY_SIDE_MEM_LATENCY = 10;
defparam lsu_local_bb3_st_c0_exe16.USE_WRITE_ACK = 1;
defparam lsu_local_bb3_st_c0_exe16.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb3_st_c0_exe16.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb3_st_c0_exe16.NUMBER_BANKS = 1;
defparam lsu_local_bb3_st_c0_exe16.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb3_st_c0_exe16.USEINPUTFIFO = 0;
defparam lsu_local_bb3_st_c0_exe16.USECACHING = 0;
defparam lsu_local_bb3_st_c0_exe16.USEOUTPUTFIFO = 1;
defparam lsu_local_bb3_st_c0_exe16.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb3_st_c0_exe16.HIGH_FMAX = 1;
defparam lsu_local_bb3_st_c0_exe16.ADDRSPACE = 1;
defparam lsu_local_bb3_st_c0_exe16.STYLE = "BURST-COALESCED";
defparam lsu_local_bb3_st_c0_exe16.USE_BYTE_EN = 0;

assign local_bb3_st_c0_exe16_inputs_ready = (rstag_45to45_bb3_c0_exe16_valid_out_1 & rstag_45to45_bb3_arrayidx14_valid_out);
assign local_bb3_st_c0_exe16_output_regs_ready = (&(~(local_bb3_st_c0_exe16_valid_out_NO_SHIFT_REG) | ~(local_bb3_st_c0_exe16_stall_in)));
assign rstag_45to45_bb3_c0_exe16_stall_in_1 = (local_bb3_st_c0_exe16_fu_stall_out | ~(local_bb3_st_c0_exe16_inputs_ready));
assign rstag_45to45_bb3_arrayidx14_stall_in = (local_bb3_st_c0_exe16_fu_stall_out | ~(local_bb3_st_c0_exe16_inputs_ready));
assign local_bb3_st_c0_exe16_causedstall = (local_bb3_st_c0_exe16_inputs_ready && (local_bb3_st_c0_exe16_fu_stall_out && !(~(local_bb3_st_c0_exe16_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_st_c0_exe16_NO_SHIFT_REG <= 'x;
		local_bb3_st_c0_exe16_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_st_c0_exe16_output_regs_ready)
		begin
			local_bb3_st_c0_exe16_NO_SHIFT_REG <= local_bb3_st_c0_exe16_lsu_wackout;
			local_bb3_st_c0_exe16_valid_out_NO_SHIFT_REG <= local_bb3_st_c0_exe16_fu_valid_out;
		end
		else
		begin
			if (~(local_bb3_st_c0_exe16_stall_in))
			begin
				local_bb3_st_c0_exe16_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_364to365_bb3_c0_exe16_0_valid_out_NO_SHIFT_REG;
 logic rnode_364to365_bb3_c0_exe16_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_364to365_bb3_c0_exe16_0_NO_SHIFT_REG;
 logic rnode_364to365_bb3_c0_exe16_0_reg_365_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_364to365_bb3_c0_exe16_0_reg_365_NO_SHIFT_REG;
 logic rnode_364to365_bb3_c0_exe16_0_valid_out_reg_365_NO_SHIFT_REG;
 logic rnode_364to365_bb3_c0_exe16_0_stall_in_reg_365_NO_SHIFT_REG;
 logic rnode_364to365_bb3_c0_exe16_0_stall_out_reg_365_NO_SHIFT_REG;

acl_data_fifo rnode_364to365_bb3_c0_exe16_0_reg_365_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_364to365_bb3_c0_exe16_0_reg_365_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_364to365_bb3_c0_exe16_0_stall_in_reg_365_NO_SHIFT_REG),
	.valid_out(rnode_364to365_bb3_c0_exe16_0_valid_out_reg_365_NO_SHIFT_REG),
	.stall_out(rnode_364to365_bb3_c0_exe16_0_stall_out_reg_365_NO_SHIFT_REG),
	.data_in(rnode_45to364_bb3_c0_exe16_0_NO_SHIFT_REG),
	.data_out(rnode_364to365_bb3_c0_exe16_0_reg_365_NO_SHIFT_REG)
);

defparam rnode_364to365_bb3_c0_exe16_0_reg_365_fifo.DEPTH = 2;
defparam rnode_364to365_bb3_c0_exe16_0_reg_365_fifo.DATA_WIDTH = 32;
defparam rnode_364to365_bb3_c0_exe16_0_reg_365_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_364to365_bb3_c0_exe16_0_reg_365_fifo.IMPL = "ll_reg";

assign rnode_364to365_bb3_c0_exe16_0_reg_365_inputs_ready_NO_SHIFT_REG = rnode_45to364_bb3_c0_exe16_0_valid_out_NO_SHIFT_REG;
assign rnode_45to364_bb3_c0_exe16_0_stall_in_NO_SHIFT_REG = rnode_364to365_bb3_c0_exe16_0_stall_out_reg_365_NO_SHIFT_REG;
assign rnode_364to365_bb3_c0_exe16_0_NO_SHIFT_REG = rnode_364to365_bb3_c0_exe16_0_reg_365_NO_SHIFT_REG;
assign rnode_364to365_bb3_c0_exe16_0_stall_in_reg_365_NO_SHIFT_REG = rnode_364to365_bb3_c0_exe16_0_stall_in_NO_SHIFT_REG;
assign rnode_364to365_bb3_c0_exe16_0_valid_out_NO_SHIFT_REG = rnode_364to365_bb3_c0_exe16_0_valid_out_reg_365_NO_SHIFT_REG;

// This section implements a staging register.
// 
wire rstag_205to205_bb3_st_c0_exe16_valid_out;
wire rstag_205to205_bb3_st_c0_exe16_stall_in;
wire rstag_205to205_bb3_st_c0_exe16_inputs_ready;
wire rstag_205to205_bb3_st_c0_exe16_stall_local;
 reg rstag_205to205_bb3_st_c0_exe16_staging_valid_NO_SHIFT_REG;
wire rstag_205to205_bb3_st_c0_exe16_combined_valid;
 reg rstag_205to205_bb3_st_c0_exe16_staging_reg_NO_SHIFT_REG;
wire rstag_205to205_bb3_st_c0_exe16;

assign rstag_205to205_bb3_st_c0_exe16_inputs_ready = local_bb3_st_c0_exe16_valid_out_NO_SHIFT_REG;
assign rstag_205to205_bb3_st_c0_exe16 = (rstag_205to205_bb3_st_c0_exe16_staging_valid_NO_SHIFT_REG ? rstag_205to205_bb3_st_c0_exe16_staging_reg_NO_SHIFT_REG : local_bb3_st_c0_exe16_NO_SHIFT_REG);
assign rstag_205to205_bb3_st_c0_exe16_combined_valid = (rstag_205to205_bb3_st_c0_exe16_staging_valid_NO_SHIFT_REG | rstag_205to205_bb3_st_c0_exe16_inputs_ready);
assign rstag_205to205_bb3_st_c0_exe16_valid_out = rstag_205to205_bb3_st_c0_exe16_combined_valid;
assign rstag_205to205_bb3_st_c0_exe16_stall_local = rstag_205to205_bb3_st_c0_exe16_stall_in;
assign local_bb3_st_c0_exe16_stall_in = (|rstag_205to205_bb3_st_c0_exe16_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_205to205_bb3_st_c0_exe16_staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_205to205_bb3_st_c0_exe16_staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_205to205_bb3_st_c0_exe16_stall_local)
		begin
			if (~(rstag_205to205_bb3_st_c0_exe16_staging_valid_NO_SHIFT_REG))
			begin
				rstag_205to205_bb3_st_c0_exe16_staging_valid_NO_SHIFT_REG <= rstag_205to205_bb3_st_c0_exe16_inputs_ready;
			end
		end
		else
		begin
			rstag_205to205_bb3_st_c0_exe16_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_205to205_bb3_st_c0_exe16_staging_valid_NO_SHIFT_REG))
		begin
			rstag_205to205_bb3_st_c0_exe16_staging_reg_NO_SHIFT_REG <= local_bb3_st_c0_exe16_NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3_c1_eni1_stall_local;
wire [95:0] local_bb3_c1_eni1;

assign local_bb3_c1_eni1[31:0] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
assign local_bb3_c1_eni1[63:32] = rnode_364to365_bb3_c0_exe16_0_NO_SHIFT_REG;
assign local_bb3_c1_eni1[95:64] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;

// This section implements a registered operation.
// 
wire local_bb3_ld__inputs_ready;
 reg local_bb3_ld__valid_out_NO_SHIFT_REG;
wire local_bb3_ld__stall_in;
wire local_bb3_ld__output_regs_ready;
wire local_bb3_ld__fu_stall_out;
wire local_bb3_ld__fu_valid_out;
wire [31:0] local_bb3_ld__lsu_dataout;
 reg [31:0] local_bb3_ld__NO_SHIFT_REG;
wire local_bb3_ld__causedstall;

lsu_top lsu_local_bb3_ld_ (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(),
	.stream_size(),
	.stream_reset(),
	.o_stall(local_bb3_ld__fu_stall_out),
	.i_valid(local_bb3_ld__inputs_ready),
	.i_address(local_bb3_arrayidx16),
	.i_writedata(),
	.i_cmpdata(),
	.i_predicate(1'b0),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb3_ld__output_regs_ready)),
	.o_valid(local_bb3_ld__fu_valid_out),
	.o_readdata(local_bb3_ld__lsu_dataout),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb3_ld__active),
	.avm_address(avm_local_bb3_ld__address),
	.avm_read(avm_local_bb3_ld__read),
	.avm_readdata(avm_local_bb3_ld__readdata),
	.avm_write(avm_local_bb3_ld__write),
	.avm_writeack(avm_local_bb3_ld__writeack),
	.avm_burstcount(avm_local_bb3_ld__burstcount),
	.avm_writedata(avm_local_bb3_ld__writedata),
	.avm_byteenable(avm_local_bb3_ld__byteenable),
	.avm_waitrequest(avm_local_bb3_ld__waitrequest),
	.avm_readdatavalid(avm_local_bb3_ld__readdatavalid),
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

defparam lsu_local_bb3_ld_.AWIDTH = 30;
defparam lsu_local_bb3_ld_.WIDTH_BYTES = 4;
defparam lsu_local_bb3_ld_.MWIDTH_BYTES = 32;
defparam lsu_local_bb3_ld_.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb3_ld_.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb3_ld_.READ = 1;
defparam lsu_local_bb3_ld_.ATOMIC = 0;
defparam lsu_local_bb3_ld_.WIDTH = 32;
defparam lsu_local_bb3_ld_.MWIDTH = 256;
defparam lsu_local_bb3_ld_.ATOMIC_WIDTH = 3;
defparam lsu_local_bb3_ld_.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb3_ld_.KERNEL_SIDE_MEM_LATENCY = 160;
defparam lsu_local_bb3_ld_.MEMORY_SIDE_MEM_LATENCY = 122;
defparam lsu_local_bb3_ld_.USE_WRITE_ACK = 0;
defparam lsu_local_bb3_ld_.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb3_ld_.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb3_ld_.NUMBER_BANKS = 1;
defparam lsu_local_bb3_ld_.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb3_ld_.USEINPUTFIFO = 0;
defparam lsu_local_bb3_ld_.USECACHING = 0;
defparam lsu_local_bb3_ld_.USEOUTPUTFIFO = 1;
defparam lsu_local_bb3_ld_.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb3_ld_.HIGH_FMAX = 1;
defparam lsu_local_bb3_ld_.ADDRSPACE = 1;
defparam lsu_local_bb3_ld_.STYLE = "BURST-COALESCED";

assign local_bb3_ld__inputs_ready = (local_bb3_arrayidx16_valid_out & rstag_205to205_bb3_st_c0_exe16_valid_out);
assign local_bb3_ld__output_regs_ready = (&(~(local_bb3_ld__valid_out_NO_SHIFT_REG) | ~(local_bb3_ld__stall_in)));
assign local_bb3_arrayidx16_stall_in = (local_bb3_ld__fu_stall_out | ~(local_bb3_ld__inputs_ready));
assign rstag_205to205_bb3_st_c0_exe16_stall_in = (local_bb3_ld__fu_stall_out | ~(local_bb3_ld__inputs_ready));
assign local_bb3_ld__causedstall = (local_bb3_ld__inputs_ready && (local_bb3_ld__fu_stall_out && !(~(local_bb3_ld__output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_ld__NO_SHIFT_REG <= 'x;
		local_bb3_ld__valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_ld__output_regs_ready)
		begin
			local_bb3_ld__NO_SHIFT_REG <= local_bb3_ld__lsu_dataout;
			local_bb3_ld__valid_out_NO_SHIFT_REG <= local_bb3_ld__fu_valid_out;
		end
		else
		begin
			if (~(local_bb3_ld__stall_in))
			begin
				local_bb3_ld__valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements a staging register.
// 
wire rstag_365to365_bb3_ld__valid_out;
wire rstag_365to365_bb3_ld__stall_in;
wire rstag_365to365_bb3_ld__inputs_ready;
wire rstag_365to365_bb3_ld__stall_local;
 reg rstag_365to365_bb3_ld__staging_valid_NO_SHIFT_REG;
wire rstag_365to365_bb3_ld__combined_valid;
 reg [31:0] rstag_365to365_bb3_ld__staging_reg_NO_SHIFT_REG;
wire [31:0] rstag_365to365_bb3_ld_;

assign rstag_365to365_bb3_ld__inputs_ready = local_bb3_ld__valid_out_NO_SHIFT_REG;
assign rstag_365to365_bb3_ld_ = (rstag_365to365_bb3_ld__staging_valid_NO_SHIFT_REG ? rstag_365to365_bb3_ld__staging_reg_NO_SHIFT_REG : local_bb3_ld__NO_SHIFT_REG);
assign rstag_365to365_bb3_ld__combined_valid = (rstag_365to365_bb3_ld__staging_valid_NO_SHIFT_REG | rstag_365to365_bb3_ld__inputs_ready);
assign rstag_365to365_bb3_ld__valid_out = rstag_365to365_bb3_ld__combined_valid;
assign rstag_365to365_bb3_ld__stall_local = rstag_365to365_bb3_ld__stall_in;
assign local_bb3_ld__stall_in = (|rstag_365to365_bb3_ld__staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_365to365_bb3_ld__staging_valid_NO_SHIFT_REG <= 1'b0;
		rstag_365to365_bb3_ld__staging_reg_NO_SHIFT_REG <= 'x;
	end
	else
	begin
		if (rstag_365to365_bb3_ld__stall_local)
		begin
			if (~(rstag_365to365_bb3_ld__staging_valid_NO_SHIFT_REG))
			begin
				rstag_365to365_bb3_ld__staging_valid_NO_SHIFT_REG <= rstag_365to365_bb3_ld__inputs_ready;
			end
		end
		else
		begin
			rstag_365to365_bb3_ld__staging_valid_NO_SHIFT_REG <= 1'b0;
		end
		if (~(rstag_365to365_bb3_ld__staging_valid_NO_SHIFT_REG))
		begin
			rstag_365to365_bb3_ld__staging_reg_NO_SHIFT_REG <= local_bb3_ld__NO_SHIFT_REG;
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3_c1_eni2_valid_out;
wire local_bb3_c1_eni2_stall_in;
wire local_bb3_c1_eni2_inputs_ready;
wire local_bb3_c1_eni2_stall_local;
wire [95:0] local_bb3_c1_eni2;

assign local_bb3_c1_eni2_inputs_ready = (rstag_365to365_bb3_ld__valid_out & rnode_364to365_bb3_c0_exe16_0_valid_out_NO_SHIFT_REG);
assign local_bb3_c1_eni2[63:0] = local_bb3_c1_eni1[63:0];
assign local_bb3_c1_eni2[95:64] = rstag_365to365_bb3_ld_;
assign local_bb3_c1_eni2_valid_out = local_bb3_c1_eni2_inputs_ready;
assign local_bb3_c1_eni2_stall_local = local_bb3_c1_eni2_stall_in;
assign rstag_365to365_bb3_ld__stall_in = (local_bb3_c1_eni2_stall_local | ~(local_bb3_c1_eni2_inputs_ready));
assign rnode_364to365_bb3_c0_exe16_0_stall_in_NO_SHIFT_REG = (local_bb3_c1_eni2_stall_local | ~(local_bb3_c1_eni2_inputs_ready));

// This section implements a registered operation.
// 
wire local_bb3_c1_enter_c1_eni2_inputs_ready;
 reg local_bb3_c1_enter_c1_eni2_valid_out_0_NO_SHIFT_REG;
wire local_bb3_c1_enter_c1_eni2_stall_in_0;
 reg local_bb3_c1_enter_c1_eni2_valid_out_1_NO_SHIFT_REG;
wire local_bb3_c1_enter_c1_eni2_stall_in_1;
wire local_bb3_c1_enter_c1_eni2_output_regs_ready;
 reg [95:0] local_bb3_c1_enter_c1_eni2_NO_SHIFT_REG;
wire local_bb3_c1_enter_c1_eni2_input_accepted;
wire local_bb3_c1_exit_c1_exi1_entry_stall;
wire local_bb3_c1_exit_c1_exi1_output_regs_ready;
wire [7:0] local_bb3_c1_exit_c1_exi1_valid_bits;
wire local_bb3_c1_exit_c1_exi1_phases;
wire local_bb3_c1_enter_c1_eni2_inc_pipelined_thread;
wire local_bb3_c1_enter_c1_eni2_dec_pipelined_thread;
wire local_bb3_c1_enter_c1_eni2_causedstall;

assign local_bb3_c1_enter_c1_eni2_inputs_ready = local_bb3_c1_eni2_valid_out;
assign local_bb3_c1_enter_c1_eni2_output_regs_ready = 1'b1;
assign local_bb3_c1_enter_c1_eni2_input_accepted = (local_bb3_c1_enter_c1_eni2_inputs_ready && !(local_bb3_c1_exit_c1_exi1_entry_stall));
assign local_bb3_c1_enter_c1_eni2_inc_pipelined_thread = 1'b1;
assign local_bb3_c1_enter_c1_eni2_dec_pipelined_thread = ~(1'b0);
assign local_bb3_c1_eni2_stall_in = ((~(local_bb3_c1_enter_c1_eni2_inputs_ready) | local_bb3_c1_exit_c1_exi1_entry_stall) | ~(1'b1));
assign local_bb3_c1_enter_c1_eni2_causedstall = (1'b1 && ((~(local_bb3_c1_enter_c1_eni2_inputs_ready) | local_bb3_c1_exit_c1_exi1_entry_stall) && !(1'b0)));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_c1_enter_c1_eni2_NO_SHIFT_REG <= 'x;
		local_bb3_c1_enter_c1_eni2_valid_out_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_c1_enter_c1_eni2_valid_out_1_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_c1_enter_c1_eni2_output_regs_ready)
		begin
			local_bb3_c1_enter_c1_eni2_NO_SHIFT_REG <= local_bb3_c1_eni2;
			local_bb3_c1_enter_c1_eni2_valid_out_0_NO_SHIFT_REG <= 1'b1;
			local_bb3_c1_enter_c1_eni2_valid_out_1_NO_SHIFT_REG <= 1'b1;
		end
		else
		begin
			if (~(local_bb3_c1_enter_c1_eni2_stall_in_0))
			begin
				local_bb3_c1_enter_c1_eni2_valid_out_0_NO_SHIFT_REG <= 1'b0;
			end
			if (~(local_bb3_c1_enter_c1_eni2_stall_in_1))
			begin
				local_bb3_c1_enter_c1_eni2_valid_out_1_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3_c1_ene1_stall_local;
wire [31:0] local_bb3_c1_ene1;

assign local_bb3_c1_ene1 = local_bb3_c1_enter_c1_eni2_NO_SHIFT_REG[63:32];

// This section implements an unregistered operation.
// 
wire local_bb3_c1_ene2_stall_local;
wire [31:0] local_bb3_c1_ene2;

assign local_bb3_c1_ene2 = local_bb3_c1_enter_c1_eni2_NO_SHIFT_REG[95:64];

// This section implements an unregistered operation.
// 
wire local_bb3_var__u36_stall_local;
wire [31:0] local_bb3_var__u36;

assign local_bb3_var__u36 = local_bb3_c1_ene1;

// This section implements an unregistered operation.
// 
wire local_bb3_var__u37_stall_local;
wire [31:0] local_bb3_var__u37;

assign local_bb3_var__u37 = local_bb3_c1_ene2;

// This section implements an unregistered operation.
// 
wire local_bb3_and2_i_stall_local;
wire [31:0] local_bb3_and2_i;

assign local_bb3_and2_i = (local_bb3_var__u36 >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb3_and12_i_stall_local;
wire [31:0] local_bb3_and12_i;

assign local_bb3_and12_i = (local_bb3_var__u36 & 32'hFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_xor_i1_stall_local;
wire [31:0] local_bb3_xor_i1;

assign local_bb3_xor_i1 = (local_bb3_var__u37 ^ 32'h80000000);

// This section implements an unregistered operation.
// 
wire local_bb3_shr3_i_stall_local;
wire [31:0] local_bb3_shr3_i;

assign local_bb3_shr3_i = (local_bb3_and2_i & 32'h7FFF);

// This section implements an unregistered operation.
// 
wire local_bb3_and_i2_stall_local;
wire [31:0] local_bb3_and_i2;

assign local_bb3_and_i2 = (local_bb3_xor_i1 >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb3_and10_i_stall_local;
wire [31:0] local_bb3_and10_i;

assign local_bb3_and10_i = (local_bb3_xor_i1 & 32'hFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_shr_i3_stall_local;
wire [31:0] local_bb3_shr_i3;

assign local_bb3_shr_i3 = (local_bb3_and_i2 & 32'h7FFF);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp13_i_stall_local;
wire local_bb3_cmp13_i;

assign local_bb3_cmp13_i = (local_bb3_and10_i > local_bb3_and12_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp_i4_stall_local;
wire local_bb3_cmp_i4;

assign local_bb3_cmp_i4 = (local_bb3_shr_i3 > local_bb3_shr3_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp8_i_stall_local;
wire local_bb3_cmp8_i;

assign local_bb3_cmp8_i = (local_bb3_shr_i3 == local_bb3_shr3_i);

// This section implements an unregistered operation.
// 
wire local_bb3___i_stall_local;
wire local_bb3___i;

assign local_bb3___i = (local_bb3_cmp8_i & local_bb3_cmp13_i);

// This section implements an unregistered operation.
// 
wire local_bb3__21_i_stall_local;
wire local_bb3__21_i;

assign local_bb3__21_i = (local_bb3_cmp_i4 | local_bb3___i);

// This section implements an unregistered operation.
// 
wire local_bb3__22_i_stall_local;
wire [31:0] local_bb3__22_i;

assign local_bb3__22_i = (local_bb3__21_i ? local_bb3_var__u36 : local_bb3_xor_i1);

// This section implements an unregistered operation.
// 
wire local_bb3__22_i_valid_out;
wire local_bb3__22_i_stall_in;
 reg local_bb3__22_i_consumed_0_NO_SHIFT_REG;
wire local_bb3__23_i_valid_out;
wire local_bb3__23_i_stall_in;
 reg local_bb3__23_i_consumed_0_NO_SHIFT_REG;
wire local_bb3__23_i_inputs_ready;
wire local_bb3__23_i_stall_local;
wire [31:0] local_bb3__23_i;

assign local_bb3__23_i_inputs_ready = (local_bb3_c1_enter_c1_eni2_valid_out_0_NO_SHIFT_REG & local_bb3_c1_enter_c1_eni2_valid_out_1_NO_SHIFT_REG);
assign local_bb3__23_i = (local_bb3__21_i ? local_bb3_xor_i1 : local_bb3_var__u36);
assign local_bb3__22_i_valid_out = 1'b1;
assign local_bb3__23_i_valid_out = 1'b1;
assign local_bb3_c1_enter_c1_eni2_stall_in_0 = 1'b0;
assign local_bb3_c1_enter_c1_eni2_stall_in_1 = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3__22_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3__23_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3__22_i_consumed_0_NO_SHIFT_REG <= (local_bb3__23_i_inputs_ready & (local_bb3__22_i_consumed_0_NO_SHIFT_REG | ~(local_bb3__22_i_stall_in)) & local_bb3__23_i_stall_local);
		local_bb3__23_i_consumed_0_NO_SHIFT_REG <= (local_bb3__23_i_inputs_ready & (local_bb3__23_i_consumed_0_NO_SHIFT_REG | ~(local_bb3__23_i_stall_in)) & local_bb3__23_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_366to367_bb3__22_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_366to367_bb3__22_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_366to367_bb3__22_i_0_NO_SHIFT_REG;
 logic rnode_366to367_bb3__22_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_366to367_bb3__22_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_366to367_bb3__22_i_1_NO_SHIFT_REG;
 logic rnode_366to367_bb3__22_i_0_reg_367_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_366to367_bb3__22_i_0_reg_367_NO_SHIFT_REG;
 logic rnode_366to367_bb3__22_i_0_valid_out_0_reg_367_NO_SHIFT_REG;
 logic rnode_366to367_bb3__22_i_0_stall_in_0_reg_367_NO_SHIFT_REG;
 logic rnode_366to367_bb3__22_i_0_stall_out_reg_367_NO_SHIFT_REG;

acl_data_fifo rnode_366to367_bb3__22_i_0_reg_367_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_366to367_bb3__22_i_0_reg_367_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_366to367_bb3__22_i_0_stall_in_0_reg_367_NO_SHIFT_REG),
	.valid_out(rnode_366to367_bb3__22_i_0_valid_out_0_reg_367_NO_SHIFT_REG),
	.stall_out(rnode_366to367_bb3__22_i_0_stall_out_reg_367_NO_SHIFT_REG),
	.data_in(local_bb3__22_i),
	.data_out(rnode_366to367_bb3__22_i_0_reg_367_NO_SHIFT_REG)
);

defparam rnode_366to367_bb3__22_i_0_reg_367_fifo.DEPTH = 1;
defparam rnode_366to367_bb3__22_i_0_reg_367_fifo.DATA_WIDTH = 32;
defparam rnode_366to367_bb3__22_i_0_reg_367_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_366to367_bb3__22_i_0_reg_367_fifo.IMPL = "shift_reg";

assign rnode_366to367_bb3__22_i_0_reg_367_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3__22_i_stall_in = 1'b0;
assign rnode_366to367_bb3__22_i_0_stall_in_0_reg_367_NO_SHIFT_REG = 1'b0;
assign rnode_366to367_bb3__22_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_366to367_bb3__22_i_0_NO_SHIFT_REG = rnode_366to367_bb3__22_i_0_reg_367_NO_SHIFT_REG;
assign rnode_366to367_bb3__22_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_366to367_bb3__22_i_1_NO_SHIFT_REG = rnode_366to367_bb3__22_i_0_reg_367_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_366to367_bb3__23_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_366to367_bb3__23_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_366to367_bb3__23_i_0_NO_SHIFT_REG;
 logic rnode_366to367_bb3__23_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_366to367_bb3__23_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_366to367_bb3__23_i_1_NO_SHIFT_REG;
 logic rnode_366to367_bb3__23_i_0_reg_367_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_366to367_bb3__23_i_0_reg_367_NO_SHIFT_REG;
 logic rnode_366to367_bb3__23_i_0_valid_out_0_reg_367_NO_SHIFT_REG;
 logic rnode_366to367_bb3__23_i_0_stall_in_0_reg_367_NO_SHIFT_REG;
 logic rnode_366to367_bb3__23_i_0_stall_out_reg_367_NO_SHIFT_REG;

acl_data_fifo rnode_366to367_bb3__23_i_0_reg_367_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_366to367_bb3__23_i_0_reg_367_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_366to367_bb3__23_i_0_stall_in_0_reg_367_NO_SHIFT_REG),
	.valid_out(rnode_366to367_bb3__23_i_0_valid_out_0_reg_367_NO_SHIFT_REG),
	.stall_out(rnode_366to367_bb3__23_i_0_stall_out_reg_367_NO_SHIFT_REG),
	.data_in(local_bb3__23_i),
	.data_out(rnode_366to367_bb3__23_i_0_reg_367_NO_SHIFT_REG)
);

defparam rnode_366to367_bb3__23_i_0_reg_367_fifo.DEPTH = 1;
defparam rnode_366to367_bb3__23_i_0_reg_367_fifo.DATA_WIDTH = 32;
defparam rnode_366to367_bb3__23_i_0_reg_367_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_366to367_bb3__23_i_0_reg_367_fifo.IMPL = "shift_reg";

assign rnode_366to367_bb3__23_i_0_reg_367_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3__23_i_stall_in = 1'b0;
assign rnode_366to367_bb3__23_i_0_stall_in_0_reg_367_NO_SHIFT_REG = 1'b0;
assign rnode_366to367_bb3__23_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_366to367_bb3__23_i_0_NO_SHIFT_REG = rnode_366to367_bb3__23_i_0_reg_367_NO_SHIFT_REG;
assign rnode_366to367_bb3__23_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_366to367_bb3__23_i_1_NO_SHIFT_REG = rnode_366to367_bb3__23_i_0_reg_367_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_shr18_i_stall_local;
wire [31:0] local_bb3_shr18_i;

assign local_bb3_shr18_i = (rnode_366to367_bb3__22_i_0_NO_SHIFT_REG >> 32'h17);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_367to368_bb3__22_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_367to368_bb3__22_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3__22_i_0_NO_SHIFT_REG;
 logic rnode_367to368_bb3__22_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_367to368_bb3__22_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3__22_i_1_NO_SHIFT_REG;
 logic rnode_367to368_bb3__22_i_0_reg_368_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3__22_i_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3__22_i_0_valid_out_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3__22_i_0_stall_in_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3__22_i_0_stall_out_reg_368_NO_SHIFT_REG;

acl_data_fifo rnode_367to368_bb3__22_i_0_reg_368_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_367to368_bb3__22_i_0_reg_368_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_367to368_bb3__22_i_0_stall_in_0_reg_368_NO_SHIFT_REG),
	.valid_out(rnode_367to368_bb3__22_i_0_valid_out_0_reg_368_NO_SHIFT_REG),
	.stall_out(rnode_367to368_bb3__22_i_0_stall_out_reg_368_NO_SHIFT_REG),
	.data_in(rnode_366to367_bb3__22_i_1_NO_SHIFT_REG),
	.data_out(rnode_367to368_bb3__22_i_0_reg_368_NO_SHIFT_REG)
);

defparam rnode_367to368_bb3__22_i_0_reg_368_fifo.DEPTH = 1;
defparam rnode_367to368_bb3__22_i_0_reg_368_fifo.DATA_WIDTH = 32;
defparam rnode_367to368_bb3__22_i_0_reg_368_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_367to368_bb3__22_i_0_reg_368_fifo.IMPL = "shift_reg";

assign rnode_367to368_bb3__22_i_0_reg_368_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_366to367_bb3__22_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3__22_i_0_stall_in_0_reg_368_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3__22_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_367to368_bb3__22_i_0_NO_SHIFT_REG = rnode_367to368_bb3__22_i_0_reg_368_NO_SHIFT_REG;
assign rnode_367to368_bb3__22_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_367to368_bb3__22_i_1_NO_SHIFT_REG = rnode_367to368_bb3__22_i_0_reg_368_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_shr16_i_stall_local;
wire [31:0] local_bb3_shr16_i;

assign local_bb3_shr16_i = (rnode_366to367_bb3__23_i_0_NO_SHIFT_REG >> 32'h17);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_367to368_bb3__23_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_367to368_bb3__23_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3__23_i_0_NO_SHIFT_REG;
 logic rnode_367to368_bb3__23_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_367to368_bb3__23_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3__23_i_1_NO_SHIFT_REG;
 logic rnode_367to368_bb3__23_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_367to368_bb3__23_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3__23_i_2_NO_SHIFT_REG;
 logic rnode_367to368_bb3__23_i_0_reg_368_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3__23_i_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3__23_i_0_valid_out_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3__23_i_0_stall_in_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3__23_i_0_stall_out_reg_368_NO_SHIFT_REG;

acl_data_fifo rnode_367to368_bb3__23_i_0_reg_368_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_367to368_bb3__23_i_0_reg_368_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_367to368_bb3__23_i_0_stall_in_0_reg_368_NO_SHIFT_REG),
	.valid_out(rnode_367to368_bb3__23_i_0_valid_out_0_reg_368_NO_SHIFT_REG),
	.stall_out(rnode_367to368_bb3__23_i_0_stall_out_reg_368_NO_SHIFT_REG),
	.data_in(rnode_366to367_bb3__23_i_1_NO_SHIFT_REG),
	.data_out(rnode_367to368_bb3__23_i_0_reg_368_NO_SHIFT_REG)
);

defparam rnode_367to368_bb3__23_i_0_reg_368_fifo.DEPTH = 1;
defparam rnode_367to368_bb3__23_i_0_reg_368_fifo.DATA_WIDTH = 32;
defparam rnode_367to368_bb3__23_i_0_reg_368_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_367to368_bb3__23_i_0_reg_368_fifo.IMPL = "shift_reg";

assign rnode_367to368_bb3__23_i_0_reg_368_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_366to367_bb3__23_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3__23_i_0_stall_in_0_reg_368_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3__23_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_367to368_bb3__23_i_0_NO_SHIFT_REG = rnode_367to368_bb3__23_i_0_reg_368_NO_SHIFT_REG;
assign rnode_367to368_bb3__23_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_367to368_bb3__23_i_1_NO_SHIFT_REG = rnode_367to368_bb3__23_i_0_reg_368_NO_SHIFT_REG;
assign rnode_367to368_bb3__23_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_367to368_bb3__23_i_2_NO_SHIFT_REG = rnode_367to368_bb3__23_i_0_reg_368_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_and19_i_stall_local;
wire [31:0] local_bb3_and19_i;

assign local_bb3_and19_i = (local_bb3_shr18_i & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb3_and21_i_stall_local;
wire [31:0] local_bb3_and21_i;

assign local_bb3_and21_i = (rnode_367to368_bb3__22_i_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_sub_i11_stall_local;
wire [31:0] local_bb3_sub_i11;

assign local_bb3_sub_i11 = (local_bb3_shr16_i - local_bb3_shr18_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and20_i_stall_local;
wire [31:0] local_bb3_and20_i;

assign local_bb3_and20_i = (rnode_367to368_bb3__23_i_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_and35_i_valid_out;
wire local_bb3_and35_i_stall_in;
wire local_bb3_and35_i_inputs_ready;
wire local_bb3_and35_i_stall_local;
wire [31:0] local_bb3_and35_i;

assign local_bb3_and35_i_inputs_ready = rnode_367to368_bb3__23_i_0_valid_out_1_NO_SHIFT_REG;
assign local_bb3_and35_i = (rnode_367to368_bb3__23_i_1_NO_SHIFT_REG & 32'h80000000);
assign local_bb3_and35_i_valid_out = 1'b1;
assign rnode_367to368_bb3__23_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb3_xor36_i_stall_local;
wire [31:0] local_bb3_xor36_i;

assign local_bb3_xor36_i = (rnode_367to368_bb3__23_i_2_NO_SHIFT_REG ^ rnode_367to368_bb3__22_i_1_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_lnot23_i_stall_local;
wire local_bb3_lnot23_i;

assign local_bb3_lnot23_i = (local_bb3_and19_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp27_i_stall_local;
wire local_bb3_cmp27_i;

assign local_bb3_cmp27_i = (local_bb3_and19_i == 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb3_lnot33_not_i_stall_local;
wire local_bb3_lnot33_not_i;

assign local_bb3_lnot33_not_i = (local_bb3_and21_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_or65_i_stall_local;
wire [31:0] local_bb3_or65_i;

assign local_bb3_or65_i = (local_bb3_and21_i << 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb3_and69_i_stall_local;
wire [31:0] local_bb3_and69_i;

assign local_bb3_and69_i = (local_bb3_sub_i11 & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb3_lnot30_i_stall_local;
wire local_bb3_lnot30_i;

assign local_bb3_lnot30_i = (local_bb3_and20_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_or_i7_stall_local;
wire [31:0] local_bb3_or_i7;

assign local_bb3_or_i7 = (local_bb3_and20_i << 32'h3);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_368to369_bb3_and35_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_368to369_bb3_and35_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_368to369_bb3_and35_i_0_NO_SHIFT_REG;
 logic rnode_368to369_bb3_and35_i_0_reg_369_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_368to369_bb3_and35_i_0_reg_369_NO_SHIFT_REG;
 logic rnode_368to369_bb3_and35_i_0_valid_out_reg_369_NO_SHIFT_REG;
 logic rnode_368to369_bb3_and35_i_0_stall_in_reg_369_NO_SHIFT_REG;
 logic rnode_368to369_bb3_and35_i_0_stall_out_reg_369_NO_SHIFT_REG;

acl_data_fifo rnode_368to369_bb3_and35_i_0_reg_369_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_368to369_bb3_and35_i_0_reg_369_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_368to369_bb3_and35_i_0_stall_in_reg_369_NO_SHIFT_REG),
	.valid_out(rnode_368to369_bb3_and35_i_0_valid_out_reg_369_NO_SHIFT_REG),
	.stall_out(rnode_368to369_bb3_and35_i_0_stall_out_reg_369_NO_SHIFT_REG),
	.data_in(local_bb3_and35_i),
	.data_out(rnode_368to369_bb3_and35_i_0_reg_369_NO_SHIFT_REG)
);

defparam rnode_368to369_bb3_and35_i_0_reg_369_fifo.DEPTH = 1;
defparam rnode_368to369_bb3_and35_i_0_reg_369_fifo.DATA_WIDTH = 32;
defparam rnode_368to369_bb3_and35_i_0_reg_369_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_368to369_bb3_and35_i_0_reg_369_fifo.IMPL = "shift_reg";

assign rnode_368to369_bb3_and35_i_0_reg_369_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and35_i_stall_in = 1'b0;
assign rnode_368to369_bb3_and35_i_0_NO_SHIFT_REG = rnode_368to369_bb3_and35_i_0_reg_369_NO_SHIFT_REG;
assign rnode_368to369_bb3_and35_i_0_stall_in_reg_369_NO_SHIFT_REG = 1'b0;
assign rnode_368to369_bb3_and35_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_cmp38_i_stall_local;
wire local_bb3_cmp38_i;

assign local_bb3_cmp38_i = ($signed(local_bb3_xor36_i) < $signed(32'h0));

// This section implements an unregistered operation.
// 
wire local_bb3_xor36_lobit_i_stall_local;
wire [31:0] local_bb3_xor36_lobit_i;

assign local_bb3_xor36_lobit_i = ($signed(local_bb3_xor36_i) >>> 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb3_and37_lobit_i_stall_local;
wire [31:0] local_bb3_and37_lobit_i;

assign local_bb3_and37_lobit_i = (local_bb3_xor36_i >> 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb3_shl66_i_stall_local;
wire [31:0] local_bb3_shl66_i;

assign local_bb3_shl66_i = (local_bb3_or65_i | 32'h4000000);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp70_i_stall_local;
wire local_bb3_cmp70_i;

assign local_bb3_cmp70_i = (local_bb3_and69_i > 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb3_lnot30_not_i_stall_local;
wire local_bb3_lnot30_not_i;

assign local_bb3_lnot30_not_i = (local_bb3_lnot30_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb3_shl_i8_stall_local;
wire [31:0] local_bb3_shl_i8;

assign local_bb3_shl_i8 = (local_bb3_or_i7 | 32'h4000000);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_369to370_bb3_and35_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and35_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_369to370_bb3_and35_i_0_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and35_i_0_reg_370_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_369to370_bb3_and35_i_0_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and35_i_0_valid_out_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and35_i_0_stall_in_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and35_i_0_stall_out_reg_370_NO_SHIFT_REG;

acl_data_fifo rnode_369to370_bb3_and35_i_0_reg_370_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_369to370_bb3_and35_i_0_reg_370_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_369to370_bb3_and35_i_0_stall_in_reg_370_NO_SHIFT_REG),
	.valid_out(rnode_369to370_bb3_and35_i_0_valid_out_reg_370_NO_SHIFT_REG),
	.stall_out(rnode_369to370_bb3_and35_i_0_stall_out_reg_370_NO_SHIFT_REG),
	.data_in(rnode_368to369_bb3_and35_i_0_NO_SHIFT_REG),
	.data_out(rnode_369to370_bb3_and35_i_0_reg_370_NO_SHIFT_REG)
);

defparam rnode_369to370_bb3_and35_i_0_reg_370_fifo.DEPTH = 1;
defparam rnode_369to370_bb3_and35_i_0_reg_370_fifo.DATA_WIDTH = 32;
defparam rnode_369to370_bb3_and35_i_0_reg_370_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_369to370_bb3_and35_i_0_reg_370_fifo.IMPL = "shift_reg";

assign rnode_369to370_bb3_and35_i_0_reg_370_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_368to369_bb3_and35_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3_and35_i_0_NO_SHIFT_REG = rnode_369to370_bb3_and35_i_0_reg_370_NO_SHIFT_REG;
assign rnode_369to370_bb3_and35_i_0_stall_in_reg_370_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3_and35_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_align_0_i_stall_local;
wire [31:0] local_bb3_align_0_i;

assign local_bb3_align_0_i = (local_bb3_cmp70_i ? 32'h1F : local_bb3_and69_i);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_370to371_bb3_and35_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_370to371_bb3_and35_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_370to371_bb3_and35_i_0_NO_SHIFT_REG;
 logic rnode_370to371_bb3_and35_i_0_reg_371_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_370to371_bb3_and35_i_0_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_and35_i_0_valid_out_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_and35_i_0_stall_in_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_and35_i_0_stall_out_reg_371_NO_SHIFT_REG;

acl_data_fifo rnode_370to371_bb3_and35_i_0_reg_371_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_370to371_bb3_and35_i_0_reg_371_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_370to371_bb3_and35_i_0_stall_in_reg_371_NO_SHIFT_REG),
	.valid_out(rnode_370to371_bb3_and35_i_0_valid_out_reg_371_NO_SHIFT_REG),
	.stall_out(rnode_370to371_bb3_and35_i_0_stall_out_reg_371_NO_SHIFT_REG),
	.data_in(rnode_369to370_bb3_and35_i_0_NO_SHIFT_REG),
	.data_out(rnode_370to371_bb3_and35_i_0_reg_371_NO_SHIFT_REG)
);

defparam rnode_370to371_bb3_and35_i_0_reg_371_fifo.DEPTH = 1;
defparam rnode_370to371_bb3_and35_i_0_reg_371_fifo.DATA_WIDTH = 32;
defparam rnode_370to371_bb3_and35_i_0_reg_371_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_370to371_bb3_and35_i_0_reg_371_fifo.IMPL = "shift_reg";

assign rnode_370to371_bb3_and35_i_0_reg_371_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_369to370_bb3_and35_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_and35_i_0_NO_SHIFT_REG = rnode_370to371_bb3_and35_i_0_reg_371_NO_SHIFT_REG;
assign rnode_370to371_bb3_and35_i_0_stall_in_reg_371_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_and35_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_and94_i_stall_local;
wire [31:0] local_bb3_and94_i;

assign local_bb3_and94_i = (local_bb3_align_0_i & 32'h1C);

// This section implements an unregistered operation.
// 
wire local_bb3_and96_i_stall_local;
wire [31:0] local_bb3_and96_i;

assign local_bb3_and96_i = (local_bb3_align_0_i & 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb3_and116_i_stall_local;
wire [31:0] local_bb3_and116_i;

assign local_bb3_and116_i = (local_bb3_align_0_i & 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb3_and131_i_stall_local;
wire [31:0] local_bb3_and131_i;

assign local_bb3_and131_i = (local_bb3_align_0_i & 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb3_shr16_i_valid_out_1;
wire local_bb3_shr16_i_stall_in_1;
 reg local_bb3_shr16_i_consumed_1_NO_SHIFT_REG;
wire local_bb3_lnot23_i_valid_out;
wire local_bb3_lnot23_i_stall_in;
 reg local_bb3_lnot23_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_cmp27_i_valid_out;
wire local_bb3_cmp27_i_stall_in;
 reg local_bb3_cmp27_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_and94_i_valid_out;
wire local_bb3_and94_i_stall_in;
 reg local_bb3_and94_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_and96_i_valid_out;
wire local_bb3_and96_i_stall_in;
 reg local_bb3_and96_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_and116_i_valid_out;
wire local_bb3_and116_i_stall_in;
 reg local_bb3_and116_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_and131_i_valid_out;
wire local_bb3_and131_i_stall_in;
 reg local_bb3_and131_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_and150_i_valid_out;
wire local_bb3_and150_i_stall_in;
 reg local_bb3_and150_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_and150_i_inputs_ready;
wire local_bb3_and150_i_stall_local;
wire [31:0] local_bb3_and150_i;

assign local_bb3_and150_i_inputs_ready = (rnode_366to367_bb3__22_i_0_valid_out_0_NO_SHIFT_REG & rnode_366to367_bb3__23_i_0_valid_out_0_NO_SHIFT_REG);
assign local_bb3_and150_i = (local_bb3_align_0_i & 32'h3);
assign local_bb3_shr16_i_valid_out_1 = 1'b1;
assign local_bb3_lnot23_i_valid_out = 1'b1;
assign local_bb3_cmp27_i_valid_out = 1'b1;
assign local_bb3_and94_i_valid_out = 1'b1;
assign local_bb3_and96_i_valid_out = 1'b1;
assign local_bb3_and116_i_valid_out = 1'b1;
assign local_bb3_and131_i_valid_out = 1'b1;
assign local_bb3_and150_i_valid_out = 1'b1;
assign rnode_366to367_bb3__22_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_366to367_bb3__23_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_shr16_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb3_lnot23_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_cmp27_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_and94_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_and96_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_and116_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_and131_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_and150_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3_shr16_i_consumed_1_NO_SHIFT_REG <= (local_bb3_and150_i_inputs_ready & (local_bb3_shr16_i_consumed_1_NO_SHIFT_REG | ~(local_bb3_shr16_i_stall_in_1)) & local_bb3_and150_i_stall_local);
		local_bb3_lnot23_i_consumed_0_NO_SHIFT_REG <= (local_bb3_and150_i_inputs_ready & (local_bb3_lnot23_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_lnot23_i_stall_in)) & local_bb3_and150_i_stall_local);
		local_bb3_cmp27_i_consumed_0_NO_SHIFT_REG <= (local_bb3_and150_i_inputs_ready & (local_bb3_cmp27_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_cmp27_i_stall_in)) & local_bb3_and150_i_stall_local);
		local_bb3_and94_i_consumed_0_NO_SHIFT_REG <= (local_bb3_and150_i_inputs_ready & (local_bb3_and94_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_and94_i_stall_in)) & local_bb3_and150_i_stall_local);
		local_bb3_and96_i_consumed_0_NO_SHIFT_REG <= (local_bb3_and150_i_inputs_ready & (local_bb3_and96_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_and96_i_stall_in)) & local_bb3_and150_i_stall_local);
		local_bb3_and116_i_consumed_0_NO_SHIFT_REG <= (local_bb3_and150_i_inputs_ready & (local_bb3_and116_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_and116_i_stall_in)) & local_bb3_and150_i_stall_local);
		local_bb3_and131_i_consumed_0_NO_SHIFT_REG <= (local_bb3_and150_i_inputs_ready & (local_bb3_and131_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_and131_i_stall_in)) & local_bb3_and150_i_stall_local);
		local_bb3_and150_i_consumed_0_NO_SHIFT_REG <= (local_bb3_and150_i_inputs_ready & (local_bb3_and150_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_and150_i_stall_in)) & local_bb3_and150_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_367to368_bb3_shr16_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_367to368_bb3_shr16_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3_shr16_i_0_NO_SHIFT_REG;
 logic rnode_367to368_bb3_shr16_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_367to368_bb3_shr16_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3_shr16_i_1_NO_SHIFT_REG;
 logic rnode_367to368_bb3_shr16_i_0_reg_368_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3_shr16_i_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_shr16_i_0_valid_out_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_shr16_i_0_stall_in_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_shr16_i_0_stall_out_reg_368_NO_SHIFT_REG;

acl_data_fifo rnode_367to368_bb3_shr16_i_0_reg_368_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_367to368_bb3_shr16_i_0_reg_368_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_367to368_bb3_shr16_i_0_stall_in_0_reg_368_NO_SHIFT_REG),
	.valid_out(rnode_367to368_bb3_shr16_i_0_valid_out_0_reg_368_NO_SHIFT_REG),
	.stall_out(rnode_367to368_bb3_shr16_i_0_stall_out_reg_368_NO_SHIFT_REG),
	.data_in(local_bb3_shr16_i),
	.data_out(rnode_367to368_bb3_shr16_i_0_reg_368_NO_SHIFT_REG)
);

defparam rnode_367to368_bb3_shr16_i_0_reg_368_fifo.DEPTH = 1;
defparam rnode_367to368_bb3_shr16_i_0_reg_368_fifo.DATA_WIDTH = 32;
defparam rnode_367to368_bb3_shr16_i_0_reg_368_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_367to368_bb3_shr16_i_0_reg_368_fifo.IMPL = "shift_reg";

assign rnode_367to368_bb3_shr16_i_0_reg_368_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_shr16_i_stall_in_1 = 1'b0;
assign rnode_367to368_bb3_shr16_i_0_stall_in_0_reg_368_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_shr16_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_367to368_bb3_shr16_i_0_NO_SHIFT_REG = rnode_367to368_bb3_shr16_i_0_reg_368_NO_SHIFT_REG;
assign rnode_367to368_bb3_shr16_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_367to368_bb3_shr16_i_1_NO_SHIFT_REG = rnode_367to368_bb3_shr16_i_0_reg_368_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_367to368_bb3_lnot23_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_367to368_bb3_lnot23_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_367to368_bb3_lnot23_i_0_NO_SHIFT_REG;
 logic rnode_367to368_bb3_lnot23_i_0_reg_368_inputs_ready_NO_SHIFT_REG;
 logic rnode_367to368_bb3_lnot23_i_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_lnot23_i_0_valid_out_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_lnot23_i_0_stall_in_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_lnot23_i_0_stall_out_reg_368_NO_SHIFT_REG;

acl_data_fifo rnode_367to368_bb3_lnot23_i_0_reg_368_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_367to368_bb3_lnot23_i_0_reg_368_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_367to368_bb3_lnot23_i_0_stall_in_reg_368_NO_SHIFT_REG),
	.valid_out(rnode_367to368_bb3_lnot23_i_0_valid_out_reg_368_NO_SHIFT_REG),
	.stall_out(rnode_367to368_bb3_lnot23_i_0_stall_out_reg_368_NO_SHIFT_REG),
	.data_in(local_bb3_lnot23_i),
	.data_out(rnode_367to368_bb3_lnot23_i_0_reg_368_NO_SHIFT_REG)
);

defparam rnode_367to368_bb3_lnot23_i_0_reg_368_fifo.DEPTH = 1;
defparam rnode_367to368_bb3_lnot23_i_0_reg_368_fifo.DATA_WIDTH = 1;
defparam rnode_367to368_bb3_lnot23_i_0_reg_368_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_367to368_bb3_lnot23_i_0_reg_368_fifo.IMPL = "shift_reg";

assign rnode_367to368_bb3_lnot23_i_0_reg_368_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_lnot23_i_stall_in = 1'b0;
assign rnode_367to368_bb3_lnot23_i_0_NO_SHIFT_REG = rnode_367to368_bb3_lnot23_i_0_reg_368_NO_SHIFT_REG;
assign rnode_367to368_bb3_lnot23_i_0_stall_in_reg_368_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_lnot23_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_367to368_bb3_cmp27_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_367to368_bb3_cmp27_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_367to368_bb3_cmp27_i_0_NO_SHIFT_REG;
 logic rnode_367to368_bb3_cmp27_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_367to368_bb3_cmp27_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_367to368_bb3_cmp27_i_1_NO_SHIFT_REG;
 logic rnode_367to368_bb3_cmp27_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_367to368_bb3_cmp27_i_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_367to368_bb3_cmp27_i_2_NO_SHIFT_REG;
 logic rnode_367to368_bb3_cmp27_i_0_reg_368_inputs_ready_NO_SHIFT_REG;
 logic rnode_367to368_bb3_cmp27_i_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_cmp27_i_0_valid_out_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_cmp27_i_0_stall_in_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_cmp27_i_0_stall_out_reg_368_NO_SHIFT_REG;

acl_data_fifo rnode_367to368_bb3_cmp27_i_0_reg_368_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_367to368_bb3_cmp27_i_0_reg_368_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_367to368_bb3_cmp27_i_0_stall_in_0_reg_368_NO_SHIFT_REG),
	.valid_out(rnode_367to368_bb3_cmp27_i_0_valid_out_0_reg_368_NO_SHIFT_REG),
	.stall_out(rnode_367to368_bb3_cmp27_i_0_stall_out_reg_368_NO_SHIFT_REG),
	.data_in(local_bb3_cmp27_i),
	.data_out(rnode_367to368_bb3_cmp27_i_0_reg_368_NO_SHIFT_REG)
);

defparam rnode_367to368_bb3_cmp27_i_0_reg_368_fifo.DEPTH = 1;
defparam rnode_367to368_bb3_cmp27_i_0_reg_368_fifo.DATA_WIDTH = 1;
defparam rnode_367to368_bb3_cmp27_i_0_reg_368_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_367to368_bb3_cmp27_i_0_reg_368_fifo.IMPL = "shift_reg";

assign rnode_367to368_bb3_cmp27_i_0_reg_368_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_cmp27_i_stall_in = 1'b0;
assign rnode_367to368_bb3_cmp27_i_0_stall_in_0_reg_368_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_cmp27_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_367to368_bb3_cmp27_i_0_NO_SHIFT_REG = rnode_367to368_bb3_cmp27_i_0_reg_368_NO_SHIFT_REG;
assign rnode_367to368_bb3_cmp27_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_367to368_bb3_cmp27_i_1_NO_SHIFT_REG = rnode_367to368_bb3_cmp27_i_0_reg_368_NO_SHIFT_REG;
assign rnode_367to368_bb3_cmp27_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_367to368_bb3_cmp27_i_2_NO_SHIFT_REG = rnode_367to368_bb3_cmp27_i_0_reg_368_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_367to368_bb3_and94_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and94_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3_and94_i_0_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and94_i_0_reg_368_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3_and94_i_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and94_i_0_valid_out_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and94_i_0_stall_in_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and94_i_0_stall_out_reg_368_NO_SHIFT_REG;

acl_data_fifo rnode_367to368_bb3_and94_i_0_reg_368_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_367to368_bb3_and94_i_0_reg_368_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_367to368_bb3_and94_i_0_stall_in_reg_368_NO_SHIFT_REG),
	.valid_out(rnode_367to368_bb3_and94_i_0_valid_out_reg_368_NO_SHIFT_REG),
	.stall_out(rnode_367to368_bb3_and94_i_0_stall_out_reg_368_NO_SHIFT_REG),
	.data_in(local_bb3_and94_i),
	.data_out(rnode_367to368_bb3_and94_i_0_reg_368_NO_SHIFT_REG)
);

defparam rnode_367to368_bb3_and94_i_0_reg_368_fifo.DEPTH = 1;
defparam rnode_367to368_bb3_and94_i_0_reg_368_fifo.DATA_WIDTH = 32;
defparam rnode_367to368_bb3_and94_i_0_reg_368_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_367to368_bb3_and94_i_0_reg_368_fifo.IMPL = "shift_reg";

assign rnode_367to368_bb3_and94_i_0_reg_368_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and94_i_stall_in = 1'b0;
assign rnode_367to368_bb3_and94_i_0_NO_SHIFT_REG = rnode_367to368_bb3_and94_i_0_reg_368_NO_SHIFT_REG;
assign rnode_367to368_bb3_and94_i_0_stall_in_reg_368_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_and94_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_367to368_bb3_and96_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and96_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3_and96_i_0_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and96_i_0_reg_368_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3_and96_i_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and96_i_0_valid_out_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and96_i_0_stall_in_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and96_i_0_stall_out_reg_368_NO_SHIFT_REG;

acl_data_fifo rnode_367to368_bb3_and96_i_0_reg_368_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_367to368_bb3_and96_i_0_reg_368_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_367to368_bb3_and96_i_0_stall_in_reg_368_NO_SHIFT_REG),
	.valid_out(rnode_367to368_bb3_and96_i_0_valid_out_reg_368_NO_SHIFT_REG),
	.stall_out(rnode_367to368_bb3_and96_i_0_stall_out_reg_368_NO_SHIFT_REG),
	.data_in(local_bb3_and96_i),
	.data_out(rnode_367to368_bb3_and96_i_0_reg_368_NO_SHIFT_REG)
);

defparam rnode_367to368_bb3_and96_i_0_reg_368_fifo.DEPTH = 1;
defparam rnode_367to368_bb3_and96_i_0_reg_368_fifo.DATA_WIDTH = 32;
defparam rnode_367to368_bb3_and96_i_0_reg_368_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_367to368_bb3_and96_i_0_reg_368_fifo.IMPL = "shift_reg";

assign rnode_367to368_bb3_and96_i_0_reg_368_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and96_i_stall_in = 1'b0;
assign rnode_367to368_bb3_and96_i_0_NO_SHIFT_REG = rnode_367to368_bb3_and96_i_0_reg_368_NO_SHIFT_REG;
assign rnode_367to368_bb3_and96_i_0_stall_in_reg_368_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_and96_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_367to368_bb3_and116_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and116_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3_and116_i_0_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and116_i_0_reg_368_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3_and116_i_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and116_i_0_valid_out_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and116_i_0_stall_in_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and116_i_0_stall_out_reg_368_NO_SHIFT_REG;

acl_data_fifo rnode_367to368_bb3_and116_i_0_reg_368_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_367to368_bb3_and116_i_0_reg_368_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_367to368_bb3_and116_i_0_stall_in_reg_368_NO_SHIFT_REG),
	.valid_out(rnode_367to368_bb3_and116_i_0_valid_out_reg_368_NO_SHIFT_REG),
	.stall_out(rnode_367to368_bb3_and116_i_0_stall_out_reg_368_NO_SHIFT_REG),
	.data_in(local_bb3_and116_i),
	.data_out(rnode_367to368_bb3_and116_i_0_reg_368_NO_SHIFT_REG)
);

defparam rnode_367to368_bb3_and116_i_0_reg_368_fifo.DEPTH = 1;
defparam rnode_367to368_bb3_and116_i_0_reg_368_fifo.DATA_WIDTH = 32;
defparam rnode_367to368_bb3_and116_i_0_reg_368_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_367to368_bb3_and116_i_0_reg_368_fifo.IMPL = "shift_reg";

assign rnode_367to368_bb3_and116_i_0_reg_368_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and116_i_stall_in = 1'b0;
assign rnode_367to368_bb3_and116_i_0_NO_SHIFT_REG = rnode_367to368_bb3_and116_i_0_reg_368_NO_SHIFT_REG;
assign rnode_367to368_bb3_and116_i_0_stall_in_reg_368_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_and116_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_367to368_bb3_and131_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and131_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3_and131_i_0_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and131_i_0_reg_368_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3_and131_i_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and131_i_0_valid_out_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and131_i_0_stall_in_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and131_i_0_stall_out_reg_368_NO_SHIFT_REG;

acl_data_fifo rnode_367to368_bb3_and131_i_0_reg_368_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_367to368_bb3_and131_i_0_reg_368_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_367to368_bb3_and131_i_0_stall_in_reg_368_NO_SHIFT_REG),
	.valid_out(rnode_367to368_bb3_and131_i_0_valid_out_reg_368_NO_SHIFT_REG),
	.stall_out(rnode_367to368_bb3_and131_i_0_stall_out_reg_368_NO_SHIFT_REG),
	.data_in(local_bb3_and131_i),
	.data_out(rnode_367to368_bb3_and131_i_0_reg_368_NO_SHIFT_REG)
);

defparam rnode_367to368_bb3_and131_i_0_reg_368_fifo.DEPTH = 1;
defparam rnode_367to368_bb3_and131_i_0_reg_368_fifo.DATA_WIDTH = 32;
defparam rnode_367to368_bb3_and131_i_0_reg_368_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_367to368_bb3_and131_i_0_reg_368_fifo.IMPL = "shift_reg";

assign rnode_367to368_bb3_and131_i_0_reg_368_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and131_i_stall_in = 1'b0;
assign rnode_367to368_bb3_and131_i_0_NO_SHIFT_REG = rnode_367to368_bb3_and131_i_0_reg_368_NO_SHIFT_REG;
assign rnode_367to368_bb3_and131_i_0_stall_in_reg_368_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_and131_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_367to368_bb3_and150_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and150_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3_and150_i_0_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and150_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and150_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3_and150_i_1_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and150_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and150_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3_and150_i_2_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and150_i_0_reg_368_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_367to368_bb3_and150_i_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and150_i_0_valid_out_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and150_i_0_stall_in_0_reg_368_NO_SHIFT_REG;
 logic rnode_367to368_bb3_and150_i_0_stall_out_reg_368_NO_SHIFT_REG;

acl_data_fifo rnode_367to368_bb3_and150_i_0_reg_368_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_367to368_bb3_and150_i_0_reg_368_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_367to368_bb3_and150_i_0_stall_in_0_reg_368_NO_SHIFT_REG),
	.valid_out(rnode_367to368_bb3_and150_i_0_valid_out_0_reg_368_NO_SHIFT_REG),
	.stall_out(rnode_367to368_bb3_and150_i_0_stall_out_reg_368_NO_SHIFT_REG),
	.data_in(local_bb3_and150_i),
	.data_out(rnode_367to368_bb3_and150_i_0_reg_368_NO_SHIFT_REG)
);

defparam rnode_367to368_bb3_and150_i_0_reg_368_fifo.DEPTH = 1;
defparam rnode_367to368_bb3_and150_i_0_reg_368_fifo.DATA_WIDTH = 32;
defparam rnode_367to368_bb3_and150_i_0_reg_368_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_367to368_bb3_and150_i_0_reg_368_fifo.IMPL = "shift_reg";

assign rnode_367to368_bb3_and150_i_0_reg_368_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and150_i_stall_in = 1'b0;
assign rnode_367to368_bb3_and150_i_0_stall_in_0_reg_368_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_and150_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_367to368_bb3_and150_i_0_NO_SHIFT_REG = rnode_367to368_bb3_and150_i_0_reg_368_NO_SHIFT_REG;
assign rnode_367to368_bb3_and150_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_367to368_bb3_and150_i_1_NO_SHIFT_REG = rnode_367to368_bb3_and150_i_0_reg_368_NO_SHIFT_REG;
assign rnode_367to368_bb3_and150_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_367to368_bb3_and150_i_2_NO_SHIFT_REG = rnode_367to368_bb3_and150_i_0_reg_368_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_and17_i_stall_local;
wire [31:0] local_bb3_and17_i;

assign local_bb3_and17_i = (rnode_367to368_bb3_shr16_i_0_NO_SHIFT_REG & 32'hFF);

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_368to370_bb3_shr16_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_368to370_bb3_shr16_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_368to370_bb3_shr16_i_0_NO_SHIFT_REG;
 logic rnode_368to370_bb3_shr16_i_0_reg_370_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_368to370_bb3_shr16_i_0_reg_370_NO_SHIFT_REG;
 logic rnode_368to370_bb3_shr16_i_0_valid_out_reg_370_NO_SHIFT_REG;
 logic rnode_368to370_bb3_shr16_i_0_stall_in_reg_370_NO_SHIFT_REG;
 logic rnode_368to370_bb3_shr16_i_0_stall_out_reg_370_NO_SHIFT_REG;

acl_data_fifo rnode_368to370_bb3_shr16_i_0_reg_370_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_368to370_bb3_shr16_i_0_reg_370_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_368to370_bb3_shr16_i_0_stall_in_reg_370_NO_SHIFT_REG),
	.valid_out(rnode_368to370_bb3_shr16_i_0_valid_out_reg_370_NO_SHIFT_REG),
	.stall_out(rnode_368to370_bb3_shr16_i_0_stall_out_reg_370_NO_SHIFT_REG),
	.data_in(rnode_367to368_bb3_shr16_i_1_NO_SHIFT_REG),
	.data_out(rnode_368to370_bb3_shr16_i_0_reg_370_NO_SHIFT_REG)
);

defparam rnode_368to370_bb3_shr16_i_0_reg_370_fifo.DEPTH = 2;
defparam rnode_368to370_bb3_shr16_i_0_reg_370_fifo.DATA_WIDTH = 32;
defparam rnode_368to370_bb3_shr16_i_0_reg_370_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_368to370_bb3_shr16_i_0_reg_370_fifo.IMPL = "shift_reg";

assign rnode_368to370_bb3_shr16_i_0_reg_370_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_367to368_bb3_shr16_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_368to370_bb3_shr16_i_0_NO_SHIFT_REG = rnode_368to370_bb3_shr16_i_0_reg_370_NO_SHIFT_REG;
assign rnode_368to370_bb3_shr16_i_0_stall_in_reg_370_NO_SHIFT_REG = 1'b0;
assign rnode_368to370_bb3_shr16_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3__28_i10_stall_local;
wire [31:0] local_bb3__28_i10;

assign local_bb3__28_i10 = (rnode_367to368_bb3_lnot23_i_0_NO_SHIFT_REG ? 32'h0 : local_bb3_shl66_i);

// This section implements an unregistered operation.
// 
wire local_bb3_brmerge_not_i_stall_local;
wire local_bb3_brmerge_not_i;

assign local_bb3_brmerge_not_i = (rnode_367to368_bb3_cmp27_i_0_NO_SHIFT_REG & local_bb3_lnot33_not_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp97_i_stall_local;
wire local_bb3_cmp97_i;

assign local_bb3_cmp97_i = (rnode_367to368_bb3_and96_i_0_NO_SHIFT_REG == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp117_i_stall_local;
wire local_bb3_cmp117_i;

assign local_bb3_cmp117_i = (rnode_367to368_bb3_and116_i_0_NO_SHIFT_REG == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp132_not_i_stall_local;
wire local_bb3_cmp132_not_i;

assign local_bb3_cmp132_not_i = (rnode_367to368_bb3_and131_i_0_NO_SHIFT_REG != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_Pivot20_i_stall_local;
wire local_bb3_Pivot20_i;

assign local_bb3_Pivot20_i = (rnode_367to368_bb3_and150_i_1_NO_SHIFT_REG < 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb3_SwitchLeaf_i_stall_local;
wire local_bb3_SwitchLeaf_i;

assign local_bb3_SwitchLeaf_i = (rnode_367to368_bb3_and150_i_2_NO_SHIFT_REG == 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb3_lnot_i5_stall_local;
wire local_bb3_lnot_i5;

assign local_bb3_lnot_i5 = (local_bb3_and17_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp25_i_stall_local;
wire local_bb3_cmp25_i;

assign local_bb3_cmp25_i = (local_bb3_and17_i == 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb3_and73_i_stall_local;
wire [31:0] local_bb3_and73_i;

assign local_bb3_and73_i = (local_bb3__28_i10 >> 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb3_and76_i_stall_local;
wire [31:0] local_bb3_and76_i;

assign local_bb3_and76_i = (local_bb3__28_i10 & 32'hF0);

// This section implements an unregistered operation.
// 
wire local_bb3_and79_i_stall_local;
wire [31:0] local_bb3_and79_i;

assign local_bb3_and79_i = (local_bb3__28_i10 & 32'hF00);

// This section implements an unregistered operation.
// 
wire local_bb3_shr95_i_stall_local;
wire [31:0] local_bb3_shr95_i;

assign local_bb3_shr95_i = (local_bb3__28_i10 >> rnode_367to368_bb3_and94_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_and91_i_stall_local;
wire [31:0] local_bb3_and91_i;

assign local_bb3_and91_i = (local_bb3__28_i10 & 32'h7000000);

// This section implements an unregistered operation.
// 
wire local_bb3_and88_i13_stall_local;
wire [31:0] local_bb3_and88_i13;

assign local_bb3_and88_i13 = (local_bb3__28_i10 & 32'hF00000);

// This section implements an unregistered operation.
// 
wire local_bb3_and85_i_stall_local;
wire [31:0] local_bb3_and85_i;

assign local_bb3_and85_i = (local_bb3__28_i10 & 32'hF0000);

// This section implements an unregistered operation.
// 
wire local_bb3_var__u38_stall_local;
wire [31:0] local_bb3_var__u38;

assign local_bb3_var__u38 = (local_bb3__28_i10 & 32'hFFF8);

// This section implements an unregistered operation.
// 
wire local_bb3_brmerge_not_not_i_stall_local;
wire local_bb3_brmerge_not_not_i;

assign local_bb3_brmerge_not_not_i = (local_bb3_brmerge_not_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb3__27_i9_stall_local;
wire [31:0] local_bb3__27_i9;

assign local_bb3__27_i9 = (local_bb3_lnot_i5 ? 32'h0 : local_bb3_shl_i8);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp25_not_i_stall_local;
wire local_bb3_cmp25_not_i;

assign local_bb3_cmp25_not_i = (local_bb3_cmp25_i ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb3_or_cond_not_i_stall_local;
wire local_bb3_or_cond_not_i;

assign local_bb3_or_cond_not_i = (local_bb3_cmp25_i & local_bb3_lnot30_not_i);

// This section implements an unregistered operation.
// 
wire local_bb3_var__u39_stall_local;
wire local_bb3_var__u39;

assign local_bb3_var__u39 = (local_bb3_cmp25_i | rnode_367to368_bb3_cmp27_i_2_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_and73_tr_i_stall_local;
wire [7:0] local_bb3_and73_tr_i;

assign local_bb3_and73_tr_i = local_bb3_and73_i[7:0];

// This section implements an unregistered operation.
// 
wire local_bb3_cmp77_i12_stall_local;
wire local_bb3_cmp77_i12;

assign local_bb3_cmp77_i12 = (local_bb3_and76_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp80_i_stall_local;
wire local_bb3_cmp80_i;

assign local_bb3_cmp80_i = (local_bb3_and79_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_and143_i_stall_local;
wire [31:0] local_bb3_and143_i;

assign local_bb3_and143_i = (local_bb3_shr95_i >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb3_shr151_i_stall_local;
wire [31:0] local_bb3_shr151_i;

assign local_bb3_shr151_i = (local_bb3_shr95_i >> rnode_367to368_bb3_and150_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_var__u40_stall_local;
wire [31:0] local_bb3_var__u40;

assign local_bb3_var__u40 = (local_bb3_shr95_i & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb3_and147_i_stall_local;
wire [31:0] local_bb3_and147_i;

assign local_bb3_and147_i = (local_bb3_shr95_i >> 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp92_i_stall_local;
wire local_bb3_cmp92_i;

assign local_bb3_cmp92_i = (local_bb3_and91_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp89_i_stall_local;
wire local_bb3_cmp89_i;

assign local_bb3_cmp89_i = (local_bb3_and88_i13 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp86_i_stall_local;
wire local_bb3_cmp86_i;

assign local_bb3_cmp86_i = (local_bb3_and85_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_var__u41_stall_local;
wire local_bb3_var__u41;

assign local_bb3_var__u41 = (local_bb3_var__u38 != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_reduction_7_i_stall_local;
wire local_bb3_reduction_7_i;

assign local_bb3_reduction_7_i = (local_bb3_cmp25_i & local_bb3_brmerge_not_not_i);

// This section implements an unregistered operation.
// 
wire local_bb3_add_i21_stall_local;
wire [31:0] local_bb3_add_i21;

assign local_bb3_add_i21 = (local_bb3__27_i9 | local_bb3_and37_lobit_i);

// This section implements an unregistered operation.
// 
wire local_bb3_or_cond_i_stall_local;
wire local_bb3_or_cond_i;

assign local_bb3_or_cond_i = (local_bb3_lnot30_i | local_bb3_cmp25_not_i);

// This section implements an unregistered operation.
// 
wire local_bb3__24_i6_stall_local;
wire local_bb3__24_i6;

assign local_bb3__24_i6 = (local_bb3_or_cond_not_i | local_bb3_brmerge_not_i);

// This section implements an unregistered operation.
// 
wire local_bb3_frombool75_i_stall_local;
wire [7:0] local_bb3_frombool75_i;

assign local_bb3_frombool75_i = (local_bb3_and73_tr_i & 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb3_var__u42_stall_local;
wire [31:0] local_bb3_var__u42;

assign local_bb3_var__u42 = (local_bb3_and147_i | local_bb3_shr95_i);

// This section implements an unregistered operation.
// 
wire local_bb3__31_v_i_stall_local;
wire local_bb3__31_v_i;

assign local_bb3__31_v_i = (local_bb3_cmp97_i ? local_bb3_cmp80_i : local_bb3_cmp92_i);

// This section implements an unregistered operation.
// 
wire local_bb3__30_v_i_stall_local;
wire local_bb3__30_v_i;

assign local_bb3__30_v_i = (local_bb3_cmp97_i ? local_bb3_cmp77_i12 : local_bb3_cmp89_i);

// This section implements an unregistered operation.
// 
wire local_bb3_frombool110_i_stall_local;
wire [7:0] local_bb3_frombool110_i;

assign local_bb3_frombool110_i[7:1] = 7'h0;
assign local_bb3_frombool110_i[0] = local_bb3_cmp86_i;

// This section implements an unregistered operation.
// 
wire local_bb3_or108_i_stall_local;
wire [31:0] local_bb3_or108_i;

assign local_bb3_or108_i[31:1] = 31'h0;
assign local_bb3_or108_i[0] = local_bb3_var__u41;

// This section implements an unregistered operation.
// 
wire local_bb3_reduction_8_i_stall_local;
wire local_bb3_reduction_8_i;

assign local_bb3_reduction_8_i = (rnode_367to368_bb3_cmp27_i_1_NO_SHIFT_REG & local_bb3_or_cond_i);

// This section implements an unregistered operation.
// 
wire local_bb3_or1606_i_stall_local;
wire [31:0] local_bb3_or1606_i;

assign local_bb3_or1606_i = (local_bb3_var__u42 | local_bb3_and143_i);

// This section implements an unregistered operation.
// 
wire local_bb3__31_i15_stall_local;
wire [7:0] local_bb3__31_i15;

assign local_bb3__31_i15[7:1] = 7'h0;
assign local_bb3__31_i15[0] = local_bb3__31_v_i;

// This section implements an unregistered operation.
// 
wire local_bb3__30_i_stall_local;
wire [7:0] local_bb3__30_i;

assign local_bb3__30_i[7:1] = 7'h0;
assign local_bb3__30_i[0] = local_bb3__30_v_i;

// This section implements an unregistered operation.
// 
wire local_bb3__29_i14_stall_local;
wire [7:0] local_bb3__29_i14;

assign local_bb3__29_i14 = (local_bb3_cmp97_i ? local_bb3_frombool75_i : local_bb3_frombool110_i);

// This section implements an unregistered operation.
// 
wire local_bb3__32_i16_stall_local;
wire [31:0] local_bb3__32_i16;

assign local_bb3__32_i16 = (local_bb3_cmp97_i ? 32'h0 : local_bb3_or108_i);

// This section implements an unregistered operation.
// 
wire local_bb3_reduction_9_i_stall_local;
wire local_bb3_reduction_9_i;

assign local_bb3_reduction_9_i = (local_bb3_reduction_7_i & local_bb3_reduction_8_i);

// This section implements an unregistered operation.
// 
wire local_bb3_or163_i_stall_local;
wire [31:0] local_bb3_or163_i;

assign local_bb3_or163_i = (local_bb3_or1606_i & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb3_or1247_i_stall_local;
wire [7:0] local_bb3_or1247_i;

assign local_bb3_or1247_i = (local_bb3__30_i | local_bb3__29_i14);

// This section implements an unregistered operation.
// 
wire local_bb3__33_i17_stall_local;
wire [7:0] local_bb3__33_i17;

assign local_bb3__33_i17 = (local_bb3_cmp117_i ? local_bb3__29_i14 : local_bb3__31_i15);

// This section implements an unregistered operation.
// 
wire local_bb3__26_i_stall_local;
wire local_bb3__26_i;

assign local_bb3__26_i = (local_bb3_reduction_9_i ? local_bb3_cmp38_i : local_bb3__24_i6);

// This section implements an unregistered operation.
// 
wire local_bb3__37_v_i_stall_local;
wire [31:0] local_bb3__37_v_i;

assign local_bb3__37_v_i = (local_bb3_Pivot20_i ? 32'h0 : local_bb3_or163_i);

// This section implements an unregistered operation.
// 
wire local_bb3_or124_i_stall_local;
wire [31:0] local_bb3_or124_i;

assign local_bb3_or124_i[31:8] = 24'h0;
assign local_bb3_or124_i[7:0] = local_bb3_or1247_i;

// This section implements an unregistered operation.
// 
wire local_bb3_var__u43_stall_local;
wire [7:0] local_bb3_var__u43;

assign local_bb3_var__u43 = (local_bb3__33_i17 & 8'h1);

// This section implements an unregistered operation.
// 
wire local_bb3__39_v_i_stall_local;
wire [31:0] local_bb3__39_v_i;

assign local_bb3__39_v_i = (local_bb3_SwitchLeaf_i ? local_bb3_var__u40 : local_bb3__37_v_i);

// This section implements an unregistered operation.
// 
wire local_bb3_or125_i_stall_local;
wire [31:0] local_bb3_or125_i;

assign local_bb3_or125_i = (local_bb3_cmp117_i ? 32'h0 : local_bb3_or124_i);

// This section implements an unregistered operation.
// 
wire local_bb3_conv136_i_stall_local;
wire [31:0] local_bb3_conv136_i;

assign local_bb3_conv136_i[31:8] = 24'h0;
assign local_bb3_conv136_i[7:0] = local_bb3_var__u43;

// This section implements an unregistered operation.
// 
wire local_bb3_reduction_3_i18_stall_local;
wire [31:0] local_bb3_reduction_3_i18;

assign local_bb3_reduction_3_i18 = (local_bb3__32_i16 | local_bb3_or125_i);

// This section implements an unregistered operation.
// 
wire local_bb3_or137_i_stall_local;
wire [31:0] local_bb3_or137_i;

assign local_bb3_or137_i = (local_bb3_cmp132_not_i ? local_bb3_conv136_i : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_reduction_5_i19_stall_local;
wire [31:0] local_bb3_reduction_5_i19;

assign local_bb3_reduction_5_i19 = (local_bb3_shr151_i | local_bb3_reduction_3_i18);

// This section implements an unregistered operation.
// 
wire local_bb3_reduction_4_i_stall_local;
wire [31:0] local_bb3_reduction_4_i;

assign local_bb3_reduction_4_i = (local_bb3_or137_i | local_bb3__39_v_i);

// This section implements an unregistered operation.
// 
wire local_bb3_reduction_6_i20_stall_local;
wire [31:0] local_bb3_reduction_6_i20;

assign local_bb3_reduction_6_i20 = (local_bb3_reduction_4_i | local_bb3_reduction_5_i19);

// This section implements an unregistered operation.
// 
wire local_bb3_xor189_i_stall_local;
wire [31:0] local_bb3_xor189_i;

assign local_bb3_xor189_i = (local_bb3_reduction_6_i20 ^ local_bb3_xor36_lobit_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp38_i_valid_out_1;
wire local_bb3_cmp38_i_stall_in_1;
 reg local_bb3_cmp38_i_consumed_1_NO_SHIFT_REG;
wire local_bb3__26_i_valid_out;
wire local_bb3__26_i_stall_in;
 reg local_bb3__26_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_add193_i_valid_out;
wire local_bb3_add193_i_stall_in;
 reg local_bb3_add193_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_and17_i_valid_out_2;
wire local_bb3_and17_i_stall_in_2;
 reg local_bb3_and17_i_consumed_2_NO_SHIFT_REG;
wire local_bb3_var__u39_valid_out;
wire local_bb3_var__u39_stall_in;
 reg local_bb3_var__u39_consumed_0_NO_SHIFT_REG;
wire local_bb3_add193_i_inputs_ready;
wire local_bb3_add193_i_stall_local;
wire [31:0] local_bb3_add193_i;

assign local_bb3_add193_i_inputs_ready = (rnode_367to368_bb3__22_i_0_valid_out_0_NO_SHIFT_REG & rnode_367to368_bb3_cmp27_i_0_valid_out_0_NO_SHIFT_REG & rnode_367to368_bb3_lnot23_i_0_valid_out_NO_SHIFT_REG & rnode_367to368_bb3_and94_i_0_valid_out_NO_SHIFT_REG & rnode_367to368_bb3__22_i_0_valid_out_1_NO_SHIFT_REG & rnode_367to368_bb3__23_i_0_valid_out_2_NO_SHIFT_REG & rnode_367to368_bb3__23_i_0_valid_out_0_NO_SHIFT_REG & rnode_367to368_bb3_cmp27_i_0_valid_out_1_NO_SHIFT_REG & rnode_367to368_bb3_shr16_i_0_valid_out_0_NO_SHIFT_REG & rnode_367to368_bb3_cmp27_i_0_valid_out_2_NO_SHIFT_REG & rnode_367to368_bb3_and150_i_0_valid_out_0_NO_SHIFT_REG & rnode_367to368_bb3_and96_i_0_valid_out_NO_SHIFT_REG & rnode_367to368_bb3_and150_i_0_valid_out_2_NO_SHIFT_REG & rnode_367to368_bb3_and116_i_0_valid_out_NO_SHIFT_REG & rnode_367to368_bb3_and131_i_0_valid_out_NO_SHIFT_REG & rnode_367to368_bb3_and150_i_0_valid_out_1_NO_SHIFT_REG);
assign local_bb3_add193_i = (local_bb3_add_i21 + local_bb3_xor189_i);
assign local_bb3_cmp38_i_valid_out_1 = 1'b1;
assign local_bb3__26_i_valid_out = 1'b1;
assign local_bb3_add193_i_valid_out = 1'b1;
assign local_bb3_and17_i_valid_out_2 = 1'b1;
assign local_bb3_var__u39_valid_out = 1'b1;
assign rnode_367to368_bb3__22_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_cmp27_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_lnot23_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_and94_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3__22_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3__23_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3__23_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_cmp27_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_shr16_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_cmp27_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_and150_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_and96_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_and150_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_and116_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_and131_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_367to368_bb3_and150_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_cmp38_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb3__26_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_add193_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_and17_i_consumed_2_NO_SHIFT_REG <= 1'b0;
		local_bb3_var__u39_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3_cmp38_i_consumed_1_NO_SHIFT_REG <= (local_bb3_add193_i_inputs_ready & (local_bb3_cmp38_i_consumed_1_NO_SHIFT_REG | ~(local_bb3_cmp38_i_stall_in_1)) & local_bb3_add193_i_stall_local);
		local_bb3__26_i_consumed_0_NO_SHIFT_REG <= (local_bb3_add193_i_inputs_ready & (local_bb3__26_i_consumed_0_NO_SHIFT_REG | ~(local_bb3__26_i_stall_in)) & local_bb3_add193_i_stall_local);
		local_bb3_add193_i_consumed_0_NO_SHIFT_REG <= (local_bb3_add193_i_inputs_ready & (local_bb3_add193_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_add193_i_stall_in)) & local_bb3_add193_i_stall_local);
		local_bb3_and17_i_consumed_2_NO_SHIFT_REG <= (local_bb3_add193_i_inputs_ready & (local_bb3_and17_i_consumed_2_NO_SHIFT_REG | ~(local_bb3_and17_i_stall_in_2)) & local_bb3_add193_i_stall_local);
		local_bb3_var__u39_consumed_0_NO_SHIFT_REG <= (local_bb3_add193_i_inputs_ready & (local_bb3_var__u39_consumed_0_NO_SHIFT_REG | ~(local_bb3_var__u39_stall_in)) & local_bb3_add193_i_stall_local);
	end
end


// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_368to370_bb3_cmp38_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_368to370_bb3_cmp38_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_368to370_bb3_cmp38_i_0_NO_SHIFT_REG;
 logic rnode_368to370_bb3_cmp38_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_368to370_bb3_cmp38_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_368to370_bb3_cmp38_i_1_NO_SHIFT_REG;
 logic rnode_368to370_bb3_cmp38_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_368to370_bb3_cmp38_i_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_368to370_bb3_cmp38_i_2_NO_SHIFT_REG;
 logic rnode_368to370_bb3_cmp38_i_0_reg_370_inputs_ready_NO_SHIFT_REG;
 logic rnode_368to370_bb3_cmp38_i_0_reg_370_NO_SHIFT_REG;
 logic rnode_368to370_bb3_cmp38_i_0_valid_out_0_reg_370_NO_SHIFT_REG;
 logic rnode_368to370_bb3_cmp38_i_0_stall_in_0_reg_370_NO_SHIFT_REG;
 logic rnode_368to370_bb3_cmp38_i_0_stall_out_reg_370_NO_SHIFT_REG;

acl_data_fifo rnode_368to370_bb3_cmp38_i_0_reg_370_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_368to370_bb3_cmp38_i_0_reg_370_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_368to370_bb3_cmp38_i_0_stall_in_0_reg_370_NO_SHIFT_REG),
	.valid_out(rnode_368to370_bb3_cmp38_i_0_valid_out_0_reg_370_NO_SHIFT_REG),
	.stall_out(rnode_368to370_bb3_cmp38_i_0_stall_out_reg_370_NO_SHIFT_REG),
	.data_in(local_bb3_cmp38_i),
	.data_out(rnode_368to370_bb3_cmp38_i_0_reg_370_NO_SHIFT_REG)
);

defparam rnode_368to370_bb3_cmp38_i_0_reg_370_fifo.DEPTH = 2;
defparam rnode_368to370_bb3_cmp38_i_0_reg_370_fifo.DATA_WIDTH = 1;
defparam rnode_368to370_bb3_cmp38_i_0_reg_370_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_368to370_bb3_cmp38_i_0_reg_370_fifo.IMPL = "shift_reg";

assign rnode_368to370_bb3_cmp38_i_0_reg_370_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_cmp38_i_stall_in_1 = 1'b0;
assign rnode_368to370_bb3_cmp38_i_0_stall_in_0_reg_370_NO_SHIFT_REG = 1'b0;
assign rnode_368to370_bb3_cmp38_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_368to370_bb3_cmp38_i_0_NO_SHIFT_REG = rnode_368to370_bb3_cmp38_i_0_reg_370_NO_SHIFT_REG;
assign rnode_368to370_bb3_cmp38_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_368to370_bb3_cmp38_i_1_NO_SHIFT_REG = rnode_368to370_bb3_cmp38_i_0_reg_370_NO_SHIFT_REG;
assign rnode_368to370_bb3_cmp38_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_368to370_bb3_cmp38_i_2_NO_SHIFT_REG = rnode_368to370_bb3_cmp38_i_0_reg_370_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_368to369_bb3__26_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_368to369_bb3__26_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_368to369_bb3__26_i_0_NO_SHIFT_REG;
 logic rnode_368to369_bb3__26_i_0_reg_369_inputs_ready_NO_SHIFT_REG;
 logic rnode_368to369_bb3__26_i_0_reg_369_NO_SHIFT_REG;
 logic rnode_368to369_bb3__26_i_0_valid_out_reg_369_NO_SHIFT_REG;
 logic rnode_368to369_bb3__26_i_0_stall_in_reg_369_NO_SHIFT_REG;
 logic rnode_368to369_bb3__26_i_0_stall_out_reg_369_NO_SHIFT_REG;

acl_data_fifo rnode_368to369_bb3__26_i_0_reg_369_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_368to369_bb3__26_i_0_reg_369_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_368to369_bb3__26_i_0_stall_in_reg_369_NO_SHIFT_REG),
	.valid_out(rnode_368to369_bb3__26_i_0_valid_out_reg_369_NO_SHIFT_REG),
	.stall_out(rnode_368to369_bb3__26_i_0_stall_out_reg_369_NO_SHIFT_REG),
	.data_in(local_bb3__26_i),
	.data_out(rnode_368to369_bb3__26_i_0_reg_369_NO_SHIFT_REG)
);

defparam rnode_368to369_bb3__26_i_0_reg_369_fifo.DEPTH = 1;
defparam rnode_368to369_bb3__26_i_0_reg_369_fifo.DATA_WIDTH = 1;
defparam rnode_368to369_bb3__26_i_0_reg_369_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_368to369_bb3__26_i_0_reg_369_fifo.IMPL = "shift_reg";

assign rnode_368to369_bb3__26_i_0_reg_369_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3__26_i_stall_in = 1'b0;
assign rnode_368to369_bb3__26_i_0_NO_SHIFT_REG = rnode_368to369_bb3__26_i_0_reg_369_NO_SHIFT_REG;
assign rnode_368to369_bb3__26_i_0_stall_in_reg_369_NO_SHIFT_REG = 1'b0;
assign rnode_368to369_bb3__26_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_368to369_bb3_add193_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_368to369_bb3_add193_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_368to369_bb3_add193_i_0_NO_SHIFT_REG;
 logic rnode_368to369_bb3_add193_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_368to369_bb3_add193_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_368to369_bb3_add193_i_1_NO_SHIFT_REG;
 logic rnode_368to369_bb3_add193_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_368to369_bb3_add193_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_368to369_bb3_add193_i_2_NO_SHIFT_REG;
 logic rnode_368to369_bb3_add193_i_0_valid_out_3_NO_SHIFT_REG;
 logic rnode_368to369_bb3_add193_i_0_stall_in_3_NO_SHIFT_REG;
 logic [31:0] rnode_368to369_bb3_add193_i_3_NO_SHIFT_REG;
 logic rnode_368to369_bb3_add193_i_0_reg_369_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_368to369_bb3_add193_i_0_reg_369_NO_SHIFT_REG;
 logic rnode_368to369_bb3_add193_i_0_valid_out_0_reg_369_NO_SHIFT_REG;
 logic rnode_368to369_bb3_add193_i_0_stall_in_0_reg_369_NO_SHIFT_REG;
 logic rnode_368to369_bb3_add193_i_0_stall_out_reg_369_NO_SHIFT_REG;

acl_data_fifo rnode_368to369_bb3_add193_i_0_reg_369_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_368to369_bb3_add193_i_0_reg_369_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_368to369_bb3_add193_i_0_stall_in_0_reg_369_NO_SHIFT_REG),
	.valid_out(rnode_368to369_bb3_add193_i_0_valid_out_0_reg_369_NO_SHIFT_REG),
	.stall_out(rnode_368to369_bb3_add193_i_0_stall_out_reg_369_NO_SHIFT_REG),
	.data_in(local_bb3_add193_i),
	.data_out(rnode_368to369_bb3_add193_i_0_reg_369_NO_SHIFT_REG)
);

defparam rnode_368to369_bb3_add193_i_0_reg_369_fifo.DEPTH = 1;
defparam rnode_368to369_bb3_add193_i_0_reg_369_fifo.DATA_WIDTH = 32;
defparam rnode_368to369_bb3_add193_i_0_reg_369_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_368to369_bb3_add193_i_0_reg_369_fifo.IMPL = "shift_reg";

assign rnode_368to369_bb3_add193_i_0_reg_369_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_add193_i_stall_in = 1'b0;
assign rnode_368to369_bb3_add193_i_0_stall_in_0_reg_369_NO_SHIFT_REG = 1'b0;
assign rnode_368to369_bb3_add193_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_368to369_bb3_add193_i_0_NO_SHIFT_REG = rnode_368to369_bb3_add193_i_0_reg_369_NO_SHIFT_REG;
assign rnode_368to369_bb3_add193_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_368to369_bb3_add193_i_1_NO_SHIFT_REG = rnode_368to369_bb3_add193_i_0_reg_369_NO_SHIFT_REG;
assign rnode_368to369_bb3_add193_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_368to369_bb3_add193_i_2_NO_SHIFT_REG = rnode_368to369_bb3_add193_i_0_reg_369_NO_SHIFT_REG;
assign rnode_368to369_bb3_add193_i_0_valid_out_3_NO_SHIFT_REG = 1'b1;
assign rnode_368to369_bb3_add193_i_3_NO_SHIFT_REG = rnode_368to369_bb3_add193_i_0_reg_369_NO_SHIFT_REG;

// Register node:
//  * latency = 2
//  * capacity = 2
 logic rnode_368to370_bb3_and17_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_368to370_bb3_and17_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_368to370_bb3_and17_i_0_NO_SHIFT_REG;
 logic rnode_368to370_bb3_and17_i_0_reg_370_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_368to370_bb3_and17_i_0_reg_370_NO_SHIFT_REG;
 logic rnode_368to370_bb3_and17_i_0_valid_out_reg_370_NO_SHIFT_REG;
 logic rnode_368to370_bb3_and17_i_0_stall_in_reg_370_NO_SHIFT_REG;
 logic rnode_368to370_bb3_and17_i_0_stall_out_reg_370_NO_SHIFT_REG;

acl_data_fifo rnode_368to370_bb3_and17_i_0_reg_370_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_368to370_bb3_and17_i_0_reg_370_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_368to370_bb3_and17_i_0_stall_in_reg_370_NO_SHIFT_REG),
	.valid_out(rnode_368to370_bb3_and17_i_0_valid_out_reg_370_NO_SHIFT_REG),
	.stall_out(rnode_368to370_bb3_and17_i_0_stall_out_reg_370_NO_SHIFT_REG),
	.data_in(local_bb3_and17_i),
	.data_out(rnode_368to370_bb3_and17_i_0_reg_370_NO_SHIFT_REG)
);

defparam rnode_368to370_bb3_and17_i_0_reg_370_fifo.DEPTH = 2;
defparam rnode_368to370_bb3_and17_i_0_reg_370_fifo.DATA_WIDTH = 32;
defparam rnode_368to370_bb3_and17_i_0_reg_370_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_368to370_bb3_and17_i_0_reg_370_fifo.IMPL = "shift_reg";

assign rnode_368to370_bb3_and17_i_0_reg_370_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and17_i_stall_in_2 = 1'b0;
assign rnode_368to370_bb3_and17_i_0_NO_SHIFT_REG = rnode_368to370_bb3_and17_i_0_reg_370_NO_SHIFT_REG;
assign rnode_368to370_bb3_and17_i_0_stall_in_reg_370_NO_SHIFT_REG = 1'b0;
assign rnode_368to370_bb3_and17_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_368to369_bb3_var__u39_0_valid_out_NO_SHIFT_REG;
 logic rnode_368to369_bb3_var__u39_0_stall_in_NO_SHIFT_REG;
 logic rnode_368to369_bb3_var__u39_0_NO_SHIFT_REG;
 logic rnode_368to369_bb3_var__u39_0_reg_369_inputs_ready_NO_SHIFT_REG;
 logic rnode_368to369_bb3_var__u39_0_reg_369_NO_SHIFT_REG;
 logic rnode_368to369_bb3_var__u39_0_valid_out_reg_369_NO_SHIFT_REG;
 logic rnode_368to369_bb3_var__u39_0_stall_in_reg_369_NO_SHIFT_REG;
 logic rnode_368to369_bb3_var__u39_0_stall_out_reg_369_NO_SHIFT_REG;

acl_data_fifo rnode_368to369_bb3_var__u39_0_reg_369_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_368to369_bb3_var__u39_0_reg_369_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_368to369_bb3_var__u39_0_stall_in_reg_369_NO_SHIFT_REG),
	.valid_out(rnode_368to369_bb3_var__u39_0_valid_out_reg_369_NO_SHIFT_REG),
	.stall_out(rnode_368to369_bb3_var__u39_0_stall_out_reg_369_NO_SHIFT_REG),
	.data_in(local_bb3_var__u39),
	.data_out(rnode_368to369_bb3_var__u39_0_reg_369_NO_SHIFT_REG)
);

defparam rnode_368to369_bb3_var__u39_0_reg_369_fifo.DEPTH = 1;
defparam rnode_368to369_bb3_var__u39_0_reg_369_fifo.DATA_WIDTH = 1;
defparam rnode_368to369_bb3_var__u39_0_reg_369_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_368to369_bb3_var__u39_0_reg_369_fifo.IMPL = "shift_reg";

assign rnode_368to369_bb3_var__u39_0_reg_369_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_var__u39_stall_in = 1'b0;
assign rnode_368to369_bb3_var__u39_0_NO_SHIFT_REG = rnode_368to369_bb3_var__u39_0_reg_369_NO_SHIFT_REG;
assign rnode_368to369_bb3_var__u39_0_stall_in_reg_369_NO_SHIFT_REG = 1'b0;
assign rnode_368to369_bb3_var__u39_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_not_cmp38_i_stall_local;
wire local_bb3_not_cmp38_i;

assign local_bb3_not_cmp38_i = (rnode_368to370_bb3_cmp38_i_1_NO_SHIFT_REG ^ 1'b1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_369to370_bb3__26_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_369to370_bb3__26_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_369to370_bb3__26_i_0_NO_SHIFT_REG;
 logic rnode_369to370_bb3__26_i_0_reg_370_inputs_ready_NO_SHIFT_REG;
 logic rnode_369to370_bb3__26_i_0_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3__26_i_0_valid_out_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3__26_i_0_stall_in_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3__26_i_0_stall_out_reg_370_NO_SHIFT_REG;

acl_data_fifo rnode_369to370_bb3__26_i_0_reg_370_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_369to370_bb3__26_i_0_reg_370_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_369to370_bb3__26_i_0_stall_in_reg_370_NO_SHIFT_REG),
	.valid_out(rnode_369to370_bb3__26_i_0_valid_out_reg_370_NO_SHIFT_REG),
	.stall_out(rnode_369to370_bb3__26_i_0_stall_out_reg_370_NO_SHIFT_REG),
	.data_in(rnode_368to369_bb3__26_i_0_NO_SHIFT_REG),
	.data_out(rnode_369to370_bb3__26_i_0_reg_370_NO_SHIFT_REG)
);

defparam rnode_369to370_bb3__26_i_0_reg_370_fifo.DEPTH = 1;
defparam rnode_369to370_bb3__26_i_0_reg_370_fifo.DATA_WIDTH = 1;
defparam rnode_369to370_bb3__26_i_0_reg_370_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_369to370_bb3__26_i_0_reg_370_fifo.IMPL = "shift_reg";

assign rnode_369to370_bb3__26_i_0_reg_370_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_368to369_bb3__26_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3__26_i_0_NO_SHIFT_REG = rnode_369to370_bb3__26_i_0_reg_370_NO_SHIFT_REG;
assign rnode_369to370_bb3__26_i_0_stall_in_reg_370_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3__26_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_and194_i_valid_out;
wire local_bb3_and194_i_stall_in;
wire local_bb3_and194_i_inputs_ready;
wire local_bb3_and194_i_stall_local;
wire [31:0] local_bb3_and194_i;

assign local_bb3_and194_i_inputs_ready = rnode_368to369_bb3_add193_i_0_valid_out_0_NO_SHIFT_REG;
assign local_bb3_and194_i = (rnode_368to369_bb3_add193_i_0_NO_SHIFT_REG & 32'hFFFFFFF);
assign local_bb3_and194_i_valid_out = 1'b1;
assign rnode_368to369_bb3_add193_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb3_and196_i_valid_out;
wire local_bb3_and196_i_stall_in;
wire local_bb3_and196_i_inputs_ready;
wire local_bb3_and196_i_stall_local;
wire [31:0] local_bb3_and196_i;

assign local_bb3_and196_i_inputs_ready = rnode_368to369_bb3_add193_i_0_valid_out_1_NO_SHIFT_REG;
assign local_bb3_and196_i = (rnode_368to369_bb3_add193_i_1_NO_SHIFT_REG >> 32'h1B);
assign local_bb3_and196_i_valid_out = 1'b1;
assign rnode_368to369_bb3_add193_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb3_and199_i_valid_out;
wire local_bb3_and199_i_stall_in;
wire local_bb3_and199_i_inputs_ready;
wire local_bb3_and199_i_stall_local;
wire [31:0] local_bb3_and199_i;

assign local_bb3_and199_i_inputs_ready = rnode_368to369_bb3_add193_i_0_valid_out_2_NO_SHIFT_REG;
assign local_bb3_and199_i = (rnode_368to369_bb3_add193_i_2_NO_SHIFT_REG & 32'h1);
assign local_bb3_and199_i_valid_out = 1'b1;
assign rnode_368to369_bb3_add193_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;

// This section implements an unregistered operation.
// 
wire local_bb3_and202_i_stall_local;
wire [31:0] local_bb3_and202_i;

assign local_bb3_and202_i = (rnode_368to369_bb3_add193_i_3_NO_SHIFT_REG & 32'h7FFFFFF);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_369to370_bb3_var__u39_0_valid_out_NO_SHIFT_REG;
 logic rnode_369to370_bb3_var__u39_0_stall_in_NO_SHIFT_REG;
 logic rnode_369to370_bb3_var__u39_0_NO_SHIFT_REG;
 logic rnode_369to370_bb3_var__u39_0_reg_370_inputs_ready_NO_SHIFT_REG;
 logic rnode_369to370_bb3_var__u39_0_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3_var__u39_0_valid_out_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3_var__u39_0_stall_in_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3_var__u39_0_stall_out_reg_370_NO_SHIFT_REG;

acl_data_fifo rnode_369to370_bb3_var__u39_0_reg_370_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_369to370_bb3_var__u39_0_reg_370_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_369to370_bb3_var__u39_0_stall_in_reg_370_NO_SHIFT_REG),
	.valid_out(rnode_369to370_bb3_var__u39_0_valid_out_reg_370_NO_SHIFT_REG),
	.stall_out(rnode_369to370_bb3_var__u39_0_stall_out_reg_370_NO_SHIFT_REG),
	.data_in(rnode_368to369_bb3_var__u39_0_NO_SHIFT_REG),
	.data_out(rnode_369to370_bb3_var__u39_0_reg_370_NO_SHIFT_REG)
);

defparam rnode_369to370_bb3_var__u39_0_reg_370_fifo.DEPTH = 1;
defparam rnode_369to370_bb3_var__u39_0_reg_370_fifo.DATA_WIDTH = 1;
defparam rnode_369to370_bb3_var__u39_0_reg_370_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_369to370_bb3_var__u39_0_reg_370_fifo.IMPL = "shift_reg";

assign rnode_369to370_bb3_var__u39_0_reg_370_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_368to369_bb3_var__u39_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3_var__u39_0_NO_SHIFT_REG = rnode_369to370_bb3_var__u39_0_reg_370_NO_SHIFT_REG;
assign rnode_369to370_bb3_var__u39_0_stall_in_reg_370_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3_var__u39_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_370to371_bb3__26_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_370to371_bb3__26_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_370to371_bb3__26_i_0_NO_SHIFT_REG;
 logic rnode_370to371_bb3__26_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_370to371_bb3__26_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_370to371_bb3__26_i_1_NO_SHIFT_REG;
 logic rnode_370to371_bb3__26_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_370to371_bb3__26_i_0_stall_in_2_NO_SHIFT_REG;
 logic rnode_370to371_bb3__26_i_2_NO_SHIFT_REG;
 logic rnode_370to371_bb3__26_i_0_reg_371_inputs_ready_NO_SHIFT_REG;
 logic rnode_370to371_bb3__26_i_0_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3__26_i_0_valid_out_0_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3__26_i_0_stall_in_0_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3__26_i_0_stall_out_reg_371_NO_SHIFT_REG;

acl_data_fifo rnode_370to371_bb3__26_i_0_reg_371_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_370to371_bb3__26_i_0_reg_371_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_370to371_bb3__26_i_0_stall_in_0_reg_371_NO_SHIFT_REG),
	.valid_out(rnode_370to371_bb3__26_i_0_valid_out_0_reg_371_NO_SHIFT_REG),
	.stall_out(rnode_370to371_bb3__26_i_0_stall_out_reg_371_NO_SHIFT_REG),
	.data_in(rnode_369to370_bb3__26_i_0_NO_SHIFT_REG),
	.data_out(rnode_370to371_bb3__26_i_0_reg_371_NO_SHIFT_REG)
);

defparam rnode_370to371_bb3__26_i_0_reg_371_fifo.DEPTH = 1;
defparam rnode_370to371_bb3__26_i_0_reg_371_fifo.DATA_WIDTH = 1;
defparam rnode_370to371_bb3__26_i_0_reg_371_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_370to371_bb3__26_i_0_reg_371_fifo.IMPL = "shift_reg";

assign rnode_370to371_bb3__26_i_0_reg_371_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_369to370_bb3__26_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3__26_i_0_stall_in_0_reg_371_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3__26_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_370to371_bb3__26_i_0_NO_SHIFT_REG = rnode_370to371_bb3__26_i_0_reg_371_NO_SHIFT_REG;
assign rnode_370to371_bb3__26_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_370to371_bb3__26_i_1_NO_SHIFT_REG = rnode_370to371_bb3__26_i_0_reg_371_NO_SHIFT_REG;
assign rnode_370to371_bb3__26_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_370to371_bb3__26_i_2_NO_SHIFT_REG = rnode_370to371_bb3__26_i_0_reg_371_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_369to370_bb3_and194_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and194_i_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_369to370_bb3_and194_i_0_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and194_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and194_i_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_369to370_bb3_and194_i_1_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and194_i_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and194_i_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_369to370_bb3_and194_i_2_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and194_i_0_reg_370_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_369to370_bb3_and194_i_0_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and194_i_0_valid_out_0_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and194_i_0_stall_in_0_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and194_i_0_stall_out_reg_370_NO_SHIFT_REG;

acl_data_fifo rnode_369to370_bb3_and194_i_0_reg_370_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_369to370_bb3_and194_i_0_reg_370_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_369to370_bb3_and194_i_0_stall_in_0_reg_370_NO_SHIFT_REG),
	.valid_out(rnode_369to370_bb3_and194_i_0_valid_out_0_reg_370_NO_SHIFT_REG),
	.stall_out(rnode_369to370_bb3_and194_i_0_stall_out_reg_370_NO_SHIFT_REG),
	.data_in(local_bb3_and194_i),
	.data_out(rnode_369to370_bb3_and194_i_0_reg_370_NO_SHIFT_REG)
);

defparam rnode_369to370_bb3_and194_i_0_reg_370_fifo.DEPTH = 1;
defparam rnode_369to370_bb3_and194_i_0_reg_370_fifo.DATA_WIDTH = 32;
defparam rnode_369to370_bb3_and194_i_0_reg_370_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_369to370_bb3_and194_i_0_reg_370_fifo.IMPL = "shift_reg";

assign rnode_369to370_bb3_and194_i_0_reg_370_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and194_i_stall_in = 1'b0;
assign rnode_369to370_bb3_and194_i_0_stall_in_0_reg_370_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3_and194_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_369to370_bb3_and194_i_0_NO_SHIFT_REG = rnode_369to370_bb3_and194_i_0_reg_370_NO_SHIFT_REG;
assign rnode_369to370_bb3_and194_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_369to370_bb3_and194_i_1_NO_SHIFT_REG = rnode_369to370_bb3_and194_i_0_reg_370_NO_SHIFT_REG;
assign rnode_369to370_bb3_and194_i_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_369to370_bb3_and194_i_2_NO_SHIFT_REG = rnode_369to370_bb3_and194_i_0_reg_370_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_369to370_bb3_and196_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and196_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_369to370_bb3_and196_i_0_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and196_i_0_reg_370_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_369to370_bb3_and196_i_0_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and196_i_0_valid_out_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and196_i_0_stall_in_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and196_i_0_stall_out_reg_370_NO_SHIFT_REG;

acl_data_fifo rnode_369to370_bb3_and196_i_0_reg_370_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_369to370_bb3_and196_i_0_reg_370_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_369to370_bb3_and196_i_0_stall_in_reg_370_NO_SHIFT_REG),
	.valid_out(rnode_369to370_bb3_and196_i_0_valid_out_reg_370_NO_SHIFT_REG),
	.stall_out(rnode_369to370_bb3_and196_i_0_stall_out_reg_370_NO_SHIFT_REG),
	.data_in(local_bb3_and196_i),
	.data_out(rnode_369to370_bb3_and196_i_0_reg_370_NO_SHIFT_REG)
);

defparam rnode_369to370_bb3_and196_i_0_reg_370_fifo.DEPTH = 1;
defparam rnode_369to370_bb3_and196_i_0_reg_370_fifo.DATA_WIDTH = 32;
defparam rnode_369to370_bb3_and196_i_0_reg_370_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_369to370_bb3_and196_i_0_reg_370_fifo.IMPL = "shift_reg";

assign rnode_369to370_bb3_and196_i_0_reg_370_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and196_i_stall_in = 1'b0;
assign rnode_369to370_bb3_and196_i_0_NO_SHIFT_REG = rnode_369to370_bb3_and196_i_0_reg_370_NO_SHIFT_REG;
assign rnode_369to370_bb3_and196_i_0_stall_in_reg_370_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3_and196_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_369to370_bb3_and199_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and199_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_369to370_bb3_and199_i_0_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and199_i_0_reg_370_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_369to370_bb3_and199_i_0_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and199_i_0_valid_out_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and199_i_0_stall_in_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3_and199_i_0_stall_out_reg_370_NO_SHIFT_REG;

acl_data_fifo rnode_369to370_bb3_and199_i_0_reg_370_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_369to370_bb3_and199_i_0_reg_370_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_369to370_bb3_and199_i_0_stall_in_reg_370_NO_SHIFT_REG),
	.valid_out(rnode_369to370_bb3_and199_i_0_valid_out_reg_370_NO_SHIFT_REG),
	.stall_out(rnode_369to370_bb3_and199_i_0_stall_out_reg_370_NO_SHIFT_REG),
	.data_in(local_bb3_and199_i),
	.data_out(rnode_369to370_bb3_and199_i_0_reg_370_NO_SHIFT_REG)
);

defparam rnode_369to370_bb3_and199_i_0_reg_370_fifo.DEPTH = 1;
defparam rnode_369to370_bb3_and199_i_0_reg_370_fifo.DATA_WIDTH = 32;
defparam rnode_369to370_bb3_and199_i_0_reg_370_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_369to370_bb3_and199_i_0_reg_370_fifo.IMPL = "shift_reg";

assign rnode_369to370_bb3_and199_i_0_reg_370_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and199_i_stall_in = 1'b0;
assign rnode_369to370_bb3_and199_i_0_NO_SHIFT_REG = rnode_369to370_bb3_and199_i_0_reg_370_NO_SHIFT_REG;
assign rnode_369to370_bb3_and199_i_0_stall_in_reg_370_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3_and199_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_shr_i_i22_stall_local;
wire [31:0] local_bb3_shr_i_i22;

assign local_bb3_shr_i_i22 = (local_bb3_and202_i >> 32'h1);

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_370to371_bb3_var__u39_0_valid_out_NO_SHIFT_REG;
 logic rnode_370to371_bb3_var__u39_0_stall_in_NO_SHIFT_REG;
 logic rnode_370to371_bb3_var__u39_0_NO_SHIFT_REG;
 logic rnode_370to371_bb3_var__u39_0_reg_371_inputs_ready_NO_SHIFT_REG;
 logic rnode_370to371_bb3_var__u39_0_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_var__u39_0_valid_out_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_var__u39_0_stall_in_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_var__u39_0_stall_out_reg_371_NO_SHIFT_REG;

acl_data_fifo rnode_370to371_bb3_var__u39_0_reg_371_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_370to371_bb3_var__u39_0_reg_371_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_370to371_bb3_var__u39_0_stall_in_reg_371_NO_SHIFT_REG),
	.valid_out(rnode_370to371_bb3_var__u39_0_valid_out_reg_371_NO_SHIFT_REG),
	.stall_out(rnode_370to371_bb3_var__u39_0_stall_out_reg_371_NO_SHIFT_REG),
	.data_in(rnode_369to370_bb3_var__u39_0_NO_SHIFT_REG),
	.data_out(rnode_370to371_bb3_var__u39_0_reg_371_NO_SHIFT_REG)
);

defparam rnode_370to371_bb3_var__u39_0_reg_371_fifo.DEPTH = 1;
defparam rnode_370to371_bb3_var__u39_0_reg_371_fifo.DATA_WIDTH = 1;
defparam rnode_370to371_bb3_var__u39_0_reg_371_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_370to371_bb3_var__u39_0_reg_371_fifo.IMPL = "shift_reg";

assign rnode_370to371_bb3_var__u39_0_reg_371_inputs_ready_NO_SHIFT_REG = 1'b1;
assign rnode_369to370_bb3_var__u39_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_var__u39_0_NO_SHIFT_REG = rnode_370to371_bb3_var__u39_0_reg_371_NO_SHIFT_REG;
assign rnode_370to371_bb3_var__u39_0_stall_in_reg_371_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_var__u39_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_cond293_i_stall_local;
wire [31:0] local_bb3_cond293_i;

assign local_bb3_cond293_i = (rnode_370to371_bb3__26_i_1_NO_SHIFT_REG ? 32'h400000 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_var__u44_stall_local;
wire [31:0] local_bb3_var__u44;

assign local_bb3_var__u44[31:1] = 31'h0;
assign local_bb3_var__u44[0] = rnode_370to371_bb3__26_i_2_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_shr217_i_stall_local;
wire [31:0] local_bb3_shr217_i;

assign local_bb3_shr217_i = (rnode_369to370_bb3_and194_i_1_NO_SHIFT_REG >> 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb3__pre_i_stall_local;
wire [31:0] local_bb3__pre_i;

assign local_bb3__pre_i = (rnode_369to370_bb3_and196_i_0_NO_SHIFT_REG & 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb3_or_i_i23_stall_local;
wire [31:0] local_bb3_or_i_i23;

assign local_bb3_or_i_i23 = (local_bb3_shr_i_i22 | local_bb3_and202_i);

// This section implements an unregistered operation.
// 
wire local_bb3_lnot_ext_i_stall_local;
wire [31:0] local_bb3_lnot_ext_i;

assign local_bb3_lnot_ext_i = (local_bb3_var__u44 ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb3_or220_i_stall_local;
wire [31:0] local_bb3_or220_i;

assign local_bb3_or220_i = (local_bb3_shr217_i | rnode_369to370_bb3_and199_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_tobool214_i_stall_local;
wire local_bb3_tobool214_i;

assign local_bb3_tobool214_i = (local_bb3__pre_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_shr1_i_i_stall_local;
wire [31:0] local_bb3_shr1_i_i;

assign local_bb3_shr1_i_i = (local_bb3_or_i_i23 >> 32'h2);

// This section implements an unregistered operation.
// 
wire local_bb3__40_demorgan_i_stall_local;
wire local_bb3__40_demorgan_i;

assign local_bb3__40_demorgan_i = (rnode_368to370_bb3_cmp38_i_0_NO_SHIFT_REG | local_bb3_tobool214_i);

// This section implements an unregistered operation.
// 
wire local_bb3__42_i_stall_local;
wire local_bb3__42_i;

assign local_bb3__42_i = (local_bb3_tobool214_i & local_bb3_not_cmp38_i);

// This section implements an unregistered operation.
// 
wire local_bb3_or2_i_i_stall_local;
wire [31:0] local_bb3_or2_i_i;

assign local_bb3_or2_i_i = (local_bb3_shr1_i_i | local_bb3_or_i_i23);

// This section implements an unregistered operation.
// 
wire local_bb3__43_i_stall_local;
wire [31:0] local_bb3__43_i;

assign local_bb3__43_i = (local_bb3__42_i ? 32'h0 : local_bb3__pre_i);

// This section implements an unregistered operation.
// 
wire local_bb3_shr3_i_i_stall_local;
wire [31:0] local_bb3_shr3_i_i;

assign local_bb3_shr3_i_i = (local_bb3_or2_i_i >> 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb3_or4_i_i_stall_local;
wire [31:0] local_bb3_or4_i_i;

assign local_bb3_or4_i_i = (local_bb3_shr3_i_i | local_bb3_or2_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_shr5_i_i_stall_local;
wire [31:0] local_bb3_shr5_i_i;

assign local_bb3_shr5_i_i = (local_bb3_or4_i_i >> 32'h8);

// This section implements an unregistered operation.
// 
wire local_bb3_or6_i_i_stall_local;
wire [31:0] local_bb3_or6_i_i;

assign local_bb3_or6_i_i = (local_bb3_shr5_i_i | local_bb3_or4_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_shr7_i_i_stall_local;
wire [31:0] local_bb3_shr7_i_i;

assign local_bb3_shr7_i_i = (local_bb3_or6_i_i >> 32'h10);

// This section implements an unregistered operation.
// 
wire local_bb3_or6_masked_i_i_stall_local;
wire [31:0] local_bb3_or6_masked_i_i;

assign local_bb3_or6_masked_i_i = (local_bb3_or6_i_i & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_neg_i_i_stall_local;
wire [31:0] local_bb3_neg_i_i;

assign local_bb3_neg_i_i = (local_bb3_or6_masked_i_i | local_bb3_shr7_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and_i_i24_stall_local;
wire [31:0] local_bb3_and_i_i24;

assign local_bb3_and_i_i24 = (local_bb3_neg_i_i ^ 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3__and_i_i24_valid_out;
wire local_bb3__and_i_i24_stall_in;
wire local_bb3__and_i_i24_inputs_ready;
wire local_bb3__and_i_i24_stall_local;
wire [31:0] local_bb3__and_i_i24;

thirtysix_six_comp local_bb3__and_i_i24_popcnt_instance (
	.data(local_bb3_and_i_i24),
	.sum(local_bb3__and_i_i24)
);


assign local_bb3__and_i_i24_inputs_ready = rnode_368to369_bb3_add193_i_0_valid_out_3_NO_SHIFT_REG;
assign local_bb3__and_i_i24_valid_out = 1'b1;
assign rnode_368to369_bb3_add193_i_0_stall_in_3_NO_SHIFT_REG = 1'b0;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_369to370_bb3__and_i_i24_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_369to370_bb3__and_i_i24_0_stall_in_0_NO_SHIFT_REG;
 logic [31:0] rnode_369to370_bb3__and_i_i24_0_NO_SHIFT_REG;
 logic rnode_369to370_bb3__and_i_i24_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_369to370_bb3__and_i_i24_0_stall_in_1_NO_SHIFT_REG;
 logic [31:0] rnode_369to370_bb3__and_i_i24_1_NO_SHIFT_REG;
 logic rnode_369to370_bb3__and_i_i24_0_valid_out_2_NO_SHIFT_REG;
 logic rnode_369to370_bb3__and_i_i24_0_stall_in_2_NO_SHIFT_REG;
 logic [31:0] rnode_369to370_bb3__and_i_i24_2_NO_SHIFT_REG;
 logic rnode_369to370_bb3__and_i_i24_0_reg_370_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_369to370_bb3__and_i_i24_0_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3__and_i_i24_0_valid_out_0_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3__and_i_i24_0_stall_in_0_reg_370_NO_SHIFT_REG;
 logic rnode_369to370_bb3__and_i_i24_0_stall_out_reg_370_NO_SHIFT_REG;

acl_data_fifo rnode_369to370_bb3__and_i_i24_0_reg_370_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_369to370_bb3__and_i_i24_0_reg_370_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_369to370_bb3__and_i_i24_0_stall_in_0_reg_370_NO_SHIFT_REG),
	.valid_out(rnode_369to370_bb3__and_i_i24_0_valid_out_0_reg_370_NO_SHIFT_REG),
	.stall_out(rnode_369to370_bb3__and_i_i24_0_stall_out_reg_370_NO_SHIFT_REG),
	.data_in(local_bb3__and_i_i24),
	.data_out(rnode_369to370_bb3__and_i_i24_0_reg_370_NO_SHIFT_REG)
);

defparam rnode_369to370_bb3__and_i_i24_0_reg_370_fifo.DEPTH = 1;
defparam rnode_369to370_bb3__and_i_i24_0_reg_370_fifo.DATA_WIDTH = 32;
defparam rnode_369to370_bb3__and_i_i24_0_reg_370_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_369to370_bb3__and_i_i24_0_reg_370_fifo.IMPL = "shift_reg";

assign rnode_369to370_bb3__and_i_i24_0_reg_370_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3__and_i_i24_stall_in = 1'b0;
assign rnode_369to370_bb3__and_i_i24_0_stall_in_0_reg_370_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3__and_i_i24_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_369to370_bb3__and_i_i24_0_NO_SHIFT_REG = rnode_369to370_bb3__and_i_i24_0_reg_370_NO_SHIFT_REG;
assign rnode_369to370_bb3__and_i_i24_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_369to370_bb3__and_i_i24_1_NO_SHIFT_REG = rnode_369to370_bb3__and_i_i24_0_reg_370_NO_SHIFT_REG;
assign rnode_369to370_bb3__and_i_i24_0_valid_out_2_NO_SHIFT_REG = 1'b1;
assign rnode_369to370_bb3__and_i_i24_2_NO_SHIFT_REG = rnode_369to370_bb3__and_i_i24_0_reg_370_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_and9_i_i_stall_local;
wire [31:0] local_bb3_and9_i_i;

assign local_bb3_and9_i_i = (rnode_369to370_bb3__and_i_i24_0_NO_SHIFT_REG & 32'h1F);

// This section implements an unregistered operation.
// 
wire local_bb3_and204_i_stall_local;
wire [31:0] local_bb3_and204_i;

assign local_bb3_and204_i = (rnode_369to370_bb3__and_i_i24_1_NO_SHIFT_REG & 32'h18);

// This section implements an unregistered operation.
// 
wire local_bb3_and207_i_stall_local;
wire [31:0] local_bb3_and207_i;

assign local_bb3_and207_i = (rnode_369to370_bb3__and_i_i24_2_NO_SHIFT_REG & 32'h7);

// This section implements an unregistered operation.
// 
wire local_bb3_sub240_i_stall_local;
wire [31:0] local_bb3_sub240_i;

assign local_bb3_sub240_i = (32'h0 - local_bb3_and9_i_i);

// This section implements an unregistered operation.
// 
wire local_bb3_shl205_i_stall_local;
wire [31:0] local_bb3_shl205_i;

assign local_bb3_shl205_i = (rnode_369to370_bb3_and194_i_0_NO_SHIFT_REG << local_bb3_and204_i);

// This section implements an unregistered operation.
// 
wire local_bb3_cond245_i_stall_local;
wire [31:0] local_bb3_cond245_i;

assign local_bb3_cond245_i = (rnode_368to370_bb3_cmp38_i_2_NO_SHIFT_REG ? local_bb3_sub240_i : local_bb3__43_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and206_i_stall_local;
wire [31:0] local_bb3_and206_i;

assign local_bb3_and206_i = (local_bb3_shl205_i & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_add246_i_stall_local;
wire [31:0] local_bb3_add246_i;

assign local_bb3_add246_i = (local_bb3_cond245_i + rnode_368to370_bb3_and17_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_fold_i_stall_local;
wire [31:0] local_bb3_fold_i;

assign local_bb3_fold_i = (local_bb3_cond245_i + rnode_368to370_bb3_shr16_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_shl208_i_stall_local;
wire [31:0] local_bb3_shl208_i;

assign local_bb3_shl208_i = (local_bb3_and206_i << local_bb3_and207_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and248_i_stall_local;
wire [31:0] local_bb3_and248_i;

assign local_bb3_and248_i = (local_bb3_add246_i & 32'h100);

// This section implements an unregistered operation.
// 
wire local_bb3_and251_i_stall_local;
wire [31:0] local_bb3_and251_i;

assign local_bb3_and251_i = (local_bb3_fold_i & 32'hFF);

// This section implements an unregistered operation.
// 
wire local_bb3_and270_i_stall_local;
wire [31:0] local_bb3_and270_i;

assign local_bb3_and270_i = (local_bb3_fold_i << 32'h17);

// This section implements an unregistered operation.
// 
wire local_bb3_and209_i_stall_local;
wire [31:0] local_bb3_and209_i;

assign local_bb3_and209_i = (local_bb3_shl208_i & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_notlhs_i_stall_local;
wire local_bb3_notlhs_i;

assign local_bb3_notlhs_i = (local_bb3_and248_i != 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_notrhs_i_stall_local;
wire local_bb3_notrhs_i;

assign local_bb3_notrhs_i = (local_bb3_and251_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3__44_i_stall_local;
wire [31:0] local_bb3__44_i;

assign local_bb3__44_i = (local_bb3__40_demorgan_i ? local_bb3_and209_i : local_bb3_or220_i);

// This section implements an unregistered operation.
// 
wire local_bb3_not__46_i_stall_local;
wire local_bb3_not__46_i;

assign local_bb3_not__46_i = (local_bb3_notrhs_i | local_bb3_notlhs_i);

// This section implements an unregistered operation.
// 
wire local_bb3__45_i_stall_local;
wire [31:0] local_bb3__45_i;

assign local_bb3__45_i = (local_bb3__42_i ? rnode_369to370_bb3_and194_i_2_NO_SHIFT_REG : local_bb3__44_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and226_i_stall_local;
wire [31:0] local_bb3_and226_i;

assign local_bb3_and226_i = (local_bb3__45_i & 32'h7FFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_and271_i_stall_local;
wire [31:0] local_bb3_and271_i;

assign local_bb3_and271_i = (local_bb3__45_i & 32'h7);

// This section implements an unregistered operation.
// 
wire local_bb3_shr272_i_stall_local;
wire [31:0] local_bb3_shr272_i;

assign local_bb3_shr272_i = (local_bb3__45_i >> 32'h3);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp227_i_stall_local;
wire local_bb3_cmp227_i;

assign local_bb3_cmp227_i = (local_bb3_and226_i == 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp297_i_stall_local;
wire local_bb3_cmp297_i;

assign local_bb3_cmp297_i = (local_bb3_and271_i > 32'h4);

// This section implements an unregistered operation.
// 
wire local_bb3_and270_i_valid_out;
wire local_bb3_and270_i_stall_in;
 reg local_bb3_and270_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_add246_i_valid_out_1;
wire local_bb3_add246_i_stall_in_1;
 reg local_bb3_add246_i_consumed_1_NO_SHIFT_REG;
wire local_bb3_not__46_i_valid_out;
wire local_bb3_not__46_i_stall_in;
 reg local_bb3_not__46_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_not_cmp38_i_valid_out_1;
wire local_bb3_not_cmp38_i_stall_in_1;
 reg local_bb3_not_cmp38_i_consumed_1_NO_SHIFT_REG;
wire local_bb3_shr272_i_valid_out;
wire local_bb3_shr272_i_stall_in;
 reg local_bb3_shr272_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_cmp227_i_valid_out;
wire local_bb3_cmp227_i_stall_in;
 reg local_bb3_cmp227_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_cmp297_i_valid_out;
wire local_bb3_cmp297_i_stall_in;
 reg local_bb3_cmp297_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_cmp300_i_valid_out;
wire local_bb3_cmp300_i_stall_in;
 reg local_bb3_cmp300_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_cmp300_i_inputs_ready;
wire local_bb3_cmp300_i_stall_local;
wire local_bb3_cmp300_i;

assign local_bb3_cmp300_i_inputs_ready = (rnode_368to370_bb3_shr16_i_0_valid_out_NO_SHIFT_REG & rnode_368to370_bb3_cmp38_i_0_valid_out_2_NO_SHIFT_REG & rnode_368to370_bb3_and17_i_0_valid_out_NO_SHIFT_REG & rnode_368to370_bb3_cmp38_i_0_valid_out_0_NO_SHIFT_REG & rnode_369to370_bb3_and194_i_0_valid_out_2_NO_SHIFT_REG & rnode_368to370_bb3_cmp38_i_0_valid_out_1_NO_SHIFT_REG & rnode_369to370_bb3_and196_i_0_valid_out_NO_SHIFT_REG & rnode_369to370_bb3_and194_i_0_valid_out_1_NO_SHIFT_REG & rnode_369to370_bb3_and199_i_0_valid_out_NO_SHIFT_REG & rnode_369to370_bb3_and194_i_0_valid_out_0_NO_SHIFT_REG & rnode_369to370_bb3__and_i_i24_0_valid_out_1_NO_SHIFT_REG & rnode_369to370_bb3__and_i_i24_0_valid_out_2_NO_SHIFT_REG & rnode_369to370_bb3__and_i_i24_0_valid_out_0_NO_SHIFT_REG);
assign local_bb3_cmp300_i = (local_bb3_and271_i == 32'h4);
assign local_bb3_and270_i_valid_out = 1'b1;
assign local_bb3_add246_i_valid_out_1 = 1'b1;
assign local_bb3_not__46_i_valid_out = 1'b1;
assign local_bb3_not_cmp38_i_valid_out_1 = 1'b1;
assign local_bb3_shr272_i_valid_out = 1'b1;
assign local_bb3_cmp227_i_valid_out = 1'b1;
assign local_bb3_cmp297_i_valid_out = 1'b1;
assign local_bb3_cmp300_i_valid_out = 1'b1;
assign rnode_368to370_bb3_shr16_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_368to370_bb3_cmp38_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_368to370_bb3_and17_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_368to370_bb3_cmp38_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3_and194_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_368to370_bb3_cmp38_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3_and196_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3_and194_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3_and199_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3_and194_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3__and_i_i24_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3__and_i_i24_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_369to370_bb3__and_i_i24_0_stall_in_0_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_and270_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_add246_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb3_not__46_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_not_cmp38_i_consumed_1_NO_SHIFT_REG <= 1'b0;
		local_bb3_shr272_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_cmp227_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_cmp297_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_cmp300_i_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3_and270_i_consumed_0_NO_SHIFT_REG <= (local_bb3_cmp300_i_inputs_ready & (local_bb3_and270_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_and270_i_stall_in)) & local_bb3_cmp300_i_stall_local);
		local_bb3_add246_i_consumed_1_NO_SHIFT_REG <= (local_bb3_cmp300_i_inputs_ready & (local_bb3_add246_i_consumed_1_NO_SHIFT_REG | ~(local_bb3_add246_i_stall_in_1)) & local_bb3_cmp300_i_stall_local);
		local_bb3_not__46_i_consumed_0_NO_SHIFT_REG <= (local_bb3_cmp300_i_inputs_ready & (local_bb3_not__46_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_not__46_i_stall_in)) & local_bb3_cmp300_i_stall_local);
		local_bb3_not_cmp38_i_consumed_1_NO_SHIFT_REG <= (local_bb3_cmp300_i_inputs_ready & (local_bb3_not_cmp38_i_consumed_1_NO_SHIFT_REG | ~(local_bb3_not_cmp38_i_stall_in_1)) & local_bb3_cmp300_i_stall_local);
		local_bb3_shr272_i_consumed_0_NO_SHIFT_REG <= (local_bb3_cmp300_i_inputs_ready & (local_bb3_shr272_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_shr272_i_stall_in)) & local_bb3_cmp300_i_stall_local);
		local_bb3_cmp227_i_consumed_0_NO_SHIFT_REG <= (local_bb3_cmp300_i_inputs_ready & (local_bb3_cmp227_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_cmp227_i_stall_in)) & local_bb3_cmp300_i_stall_local);
		local_bb3_cmp297_i_consumed_0_NO_SHIFT_REG <= (local_bb3_cmp300_i_inputs_ready & (local_bb3_cmp297_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_cmp297_i_stall_in)) & local_bb3_cmp300_i_stall_local);
		local_bb3_cmp300_i_consumed_0_NO_SHIFT_REG <= (local_bb3_cmp300_i_inputs_ready & (local_bb3_cmp300_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_cmp300_i_stall_in)) & local_bb3_cmp300_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_370to371_bb3_and270_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_370to371_bb3_and270_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_370to371_bb3_and270_i_0_NO_SHIFT_REG;
 logic rnode_370to371_bb3_and270_i_0_reg_371_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_370to371_bb3_and270_i_0_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_and270_i_0_valid_out_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_and270_i_0_stall_in_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_and270_i_0_stall_out_reg_371_NO_SHIFT_REG;

acl_data_fifo rnode_370to371_bb3_and270_i_0_reg_371_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_370to371_bb3_and270_i_0_reg_371_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_370to371_bb3_and270_i_0_stall_in_reg_371_NO_SHIFT_REG),
	.valid_out(rnode_370to371_bb3_and270_i_0_valid_out_reg_371_NO_SHIFT_REG),
	.stall_out(rnode_370to371_bb3_and270_i_0_stall_out_reg_371_NO_SHIFT_REG),
	.data_in(local_bb3_and270_i),
	.data_out(rnode_370to371_bb3_and270_i_0_reg_371_NO_SHIFT_REG)
);

defparam rnode_370to371_bb3_and270_i_0_reg_371_fifo.DEPTH = 1;
defparam rnode_370to371_bb3_and270_i_0_reg_371_fifo.DATA_WIDTH = 32;
defparam rnode_370to371_bb3_and270_i_0_reg_371_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_370to371_bb3_and270_i_0_reg_371_fifo.IMPL = "shift_reg";

assign rnode_370to371_bb3_and270_i_0_reg_371_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_and270_i_stall_in = 1'b0;
assign rnode_370to371_bb3_and270_i_0_NO_SHIFT_REG = rnode_370to371_bb3_and270_i_0_reg_371_NO_SHIFT_REG;
assign rnode_370to371_bb3_and270_i_0_stall_in_reg_371_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_and270_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_370to371_bb3_add246_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_370to371_bb3_add246_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_370to371_bb3_add246_i_0_NO_SHIFT_REG;
 logic rnode_370to371_bb3_add246_i_0_reg_371_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_370to371_bb3_add246_i_0_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_add246_i_0_valid_out_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_add246_i_0_stall_in_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_add246_i_0_stall_out_reg_371_NO_SHIFT_REG;

acl_data_fifo rnode_370to371_bb3_add246_i_0_reg_371_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_370to371_bb3_add246_i_0_reg_371_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_370to371_bb3_add246_i_0_stall_in_reg_371_NO_SHIFT_REG),
	.valid_out(rnode_370to371_bb3_add246_i_0_valid_out_reg_371_NO_SHIFT_REG),
	.stall_out(rnode_370to371_bb3_add246_i_0_stall_out_reg_371_NO_SHIFT_REG),
	.data_in(local_bb3_add246_i),
	.data_out(rnode_370to371_bb3_add246_i_0_reg_371_NO_SHIFT_REG)
);

defparam rnode_370to371_bb3_add246_i_0_reg_371_fifo.DEPTH = 1;
defparam rnode_370to371_bb3_add246_i_0_reg_371_fifo.DATA_WIDTH = 32;
defparam rnode_370to371_bb3_add246_i_0_reg_371_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_370to371_bb3_add246_i_0_reg_371_fifo.IMPL = "shift_reg";

assign rnode_370to371_bb3_add246_i_0_reg_371_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_add246_i_stall_in_1 = 1'b0;
assign rnode_370to371_bb3_add246_i_0_NO_SHIFT_REG = rnode_370to371_bb3_add246_i_0_reg_371_NO_SHIFT_REG;
assign rnode_370to371_bb3_add246_i_0_stall_in_reg_371_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_add246_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_370to371_bb3_not__46_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_370to371_bb3_not__46_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_370to371_bb3_not__46_i_0_NO_SHIFT_REG;
 logic rnode_370to371_bb3_not__46_i_0_reg_371_inputs_ready_NO_SHIFT_REG;
 logic rnode_370to371_bb3_not__46_i_0_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_not__46_i_0_valid_out_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_not__46_i_0_stall_in_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_not__46_i_0_stall_out_reg_371_NO_SHIFT_REG;

acl_data_fifo rnode_370to371_bb3_not__46_i_0_reg_371_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_370to371_bb3_not__46_i_0_reg_371_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_370to371_bb3_not__46_i_0_stall_in_reg_371_NO_SHIFT_REG),
	.valid_out(rnode_370to371_bb3_not__46_i_0_valid_out_reg_371_NO_SHIFT_REG),
	.stall_out(rnode_370to371_bb3_not__46_i_0_stall_out_reg_371_NO_SHIFT_REG),
	.data_in(local_bb3_not__46_i),
	.data_out(rnode_370to371_bb3_not__46_i_0_reg_371_NO_SHIFT_REG)
);

defparam rnode_370to371_bb3_not__46_i_0_reg_371_fifo.DEPTH = 1;
defparam rnode_370to371_bb3_not__46_i_0_reg_371_fifo.DATA_WIDTH = 1;
defparam rnode_370to371_bb3_not__46_i_0_reg_371_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_370to371_bb3_not__46_i_0_reg_371_fifo.IMPL = "shift_reg";

assign rnode_370to371_bb3_not__46_i_0_reg_371_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_not__46_i_stall_in = 1'b0;
assign rnode_370to371_bb3_not__46_i_0_NO_SHIFT_REG = rnode_370to371_bb3_not__46_i_0_reg_371_NO_SHIFT_REG;
assign rnode_370to371_bb3_not__46_i_0_stall_in_reg_371_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_not__46_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_370to371_bb3_not_cmp38_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_370to371_bb3_not_cmp38_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_370to371_bb3_not_cmp38_i_0_NO_SHIFT_REG;
 logic rnode_370to371_bb3_not_cmp38_i_0_reg_371_inputs_ready_NO_SHIFT_REG;
 logic rnode_370to371_bb3_not_cmp38_i_0_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_not_cmp38_i_0_valid_out_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_not_cmp38_i_0_stall_in_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_not_cmp38_i_0_stall_out_reg_371_NO_SHIFT_REG;

acl_data_fifo rnode_370to371_bb3_not_cmp38_i_0_reg_371_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_370to371_bb3_not_cmp38_i_0_reg_371_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_370to371_bb3_not_cmp38_i_0_stall_in_reg_371_NO_SHIFT_REG),
	.valid_out(rnode_370to371_bb3_not_cmp38_i_0_valid_out_reg_371_NO_SHIFT_REG),
	.stall_out(rnode_370to371_bb3_not_cmp38_i_0_stall_out_reg_371_NO_SHIFT_REG),
	.data_in(local_bb3_not_cmp38_i),
	.data_out(rnode_370to371_bb3_not_cmp38_i_0_reg_371_NO_SHIFT_REG)
);

defparam rnode_370to371_bb3_not_cmp38_i_0_reg_371_fifo.DEPTH = 1;
defparam rnode_370to371_bb3_not_cmp38_i_0_reg_371_fifo.DATA_WIDTH = 1;
defparam rnode_370to371_bb3_not_cmp38_i_0_reg_371_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_370to371_bb3_not_cmp38_i_0_reg_371_fifo.IMPL = "shift_reg";

assign rnode_370to371_bb3_not_cmp38_i_0_reg_371_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_not_cmp38_i_stall_in_1 = 1'b0;
assign rnode_370to371_bb3_not_cmp38_i_0_NO_SHIFT_REG = rnode_370to371_bb3_not_cmp38_i_0_reg_371_NO_SHIFT_REG;
assign rnode_370to371_bb3_not_cmp38_i_0_stall_in_reg_371_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_not_cmp38_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_370to371_bb3_shr272_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_370to371_bb3_shr272_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_370to371_bb3_shr272_i_0_NO_SHIFT_REG;
 logic rnode_370to371_bb3_shr272_i_0_reg_371_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_370to371_bb3_shr272_i_0_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_shr272_i_0_valid_out_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_shr272_i_0_stall_in_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_shr272_i_0_stall_out_reg_371_NO_SHIFT_REG;

acl_data_fifo rnode_370to371_bb3_shr272_i_0_reg_371_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_370to371_bb3_shr272_i_0_reg_371_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_370to371_bb3_shr272_i_0_stall_in_reg_371_NO_SHIFT_REG),
	.valid_out(rnode_370to371_bb3_shr272_i_0_valid_out_reg_371_NO_SHIFT_REG),
	.stall_out(rnode_370to371_bb3_shr272_i_0_stall_out_reg_371_NO_SHIFT_REG),
	.data_in(local_bb3_shr272_i),
	.data_out(rnode_370to371_bb3_shr272_i_0_reg_371_NO_SHIFT_REG)
);

defparam rnode_370to371_bb3_shr272_i_0_reg_371_fifo.DEPTH = 1;
defparam rnode_370to371_bb3_shr272_i_0_reg_371_fifo.DATA_WIDTH = 32;
defparam rnode_370to371_bb3_shr272_i_0_reg_371_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_370to371_bb3_shr272_i_0_reg_371_fifo.IMPL = "shift_reg";

assign rnode_370to371_bb3_shr272_i_0_reg_371_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_shr272_i_stall_in = 1'b0;
assign rnode_370to371_bb3_shr272_i_0_NO_SHIFT_REG = rnode_370to371_bb3_shr272_i_0_reg_371_NO_SHIFT_REG;
assign rnode_370to371_bb3_shr272_i_0_stall_in_reg_371_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_shr272_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_370to371_bb3_cmp227_i_0_valid_out_0_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp227_i_0_stall_in_0_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp227_i_0_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp227_i_0_valid_out_1_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp227_i_0_stall_in_1_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp227_i_1_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp227_i_0_reg_371_inputs_ready_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp227_i_0_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp227_i_0_valid_out_0_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp227_i_0_stall_in_0_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp227_i_0_stall_out_reg_371_NO_SHIFT_REG;

acl_data_fifo rnode_370to371_bb3_cmp227_i_0_reg_371_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_370to371_bb3_cmp227_i_0_reg_371_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_370to371_bb3_cmp227_i_0_stall_in_0_reg_371_NO_SHIFT_REG),
	.valid_out(rnode_370to371_bb3_cmp227_i_0_valid_out_0_reg_371_NO_SHIFT_REG),
	.stall_out(rnode_370to371_bb3_cmp227_i_0_stall_out_reg_371_NO_SHIFT_REG),
	.data_in(local_bb3_cmp227_i),
	.data_out(rnode_370to371_bb3_cmp227_i_0_reg_371_NO_SHIFT_REG)
);

defparam rnode_370to371_bb3_cmp227_i_0_reg_371_fifo.DEPTH = 1;
defparam rnode_370to371_bb3_cmp227_i_0_reg_371_fifo.DATA_WIDTH = 1;
defparam rnode_370to371_bb3_cmp227_i_0_reg_371_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_370to371_bb3_cmp227_i_0_reg_371_fifo.IMPL = "shift_reg";

assign rnode_370to371_bb3_cmp227_i_0_reg_371_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_cmp227_i_stall_in = 1'b0;
assign rnode_370to371_bb3_cmp227_i_0_stall_in_0_reg_371_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_cmp227_i_0_valid_out_0_NO_SHIFT_REG = 1'b1;
assign rnode_370to371_bb3_cmp227_i_0_NO_SHIFT_REG = rnode_370to371_bb3_cmp227_i_0_reg_371_NO_SHIFT_REG;
assign rnode_370to371_bb3_cmp227_i_0_valid_out_1_NO_SHIFT_REG = 1'b1;
assign rnode_370to371_bb3_cmp227_i_1_NO_SHIFT_REG = rnode_370to371_bb3_cmp227_i_0_reg_371_NO_SHIFT_REG;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_370to371_bb3_cmp297_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp297_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp297_i_0_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp297_i_0_reg_371_inputs_ready_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp297_i_0_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp297_i_0_valid_out_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp297_i_0_stall_in_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp297_i_0_stall_out_reg_371_NO_SHIFT_REG;

acl_data_fifo rnode_370to371_bb3_cmp297_i_0_reg_371_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_370to371_bb3_cmp297_i_0_reg_371_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_370to371_bb3_cmp297_i_0_stall_in_reg_371_NO_SHIFT_REG),
	.valid_out(rnode_370to371_bb3_cmp297_i_0_valid_out_reg_371_NO_SHIFT_REG),
	.stall_out(rnode_370to371_bb3_cmp297_i_0_stall_out_reg_371_NO_SHIFT_REG),
	.data_in(local_bb3_cmp297_i),
	.data_out(rnode_370to371_bb3_cmp297_i_0_reg_371_NO_SHIFT_REG)
);

defparam rnode_370to371_bb3_cmp297_i_0_reg_371_fifo.DEPTH = 1;
defparam rnode_370to371_bb3_cmp297_i_0_reg_371_fifo.DATA_WIDTH = 1;
defparam rnode_370to371_bb3_cmp297_i_0_reg_371_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_370to371_bb3_cmp297_i_0_reg_371_fifo.IMPL = "shift_reg";

assign rnode_370to371_bb3_cmp297_i_0_reg_371_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_cmp297_i_stall_in = 1'b0;
assign rnode_370to371_bb3_cmp297_i_0_NO_SHIFT_REG = rnode_370to371_bb3_cmp297_i_0_reg_371_NO_SHIFT_REG;
assign rnode_370to371_bb3_cmp297_i_0_stall_in_reg_371_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_cmp297_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_370to371_bb3_cmp300_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp300_i_0_stall_in_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp300_i_0_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp300_i_0_reg_371_inputs_ready_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp300_i_0_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp300_i_0_valid_out_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp300_i_0_stall_in_reg_371_NO_SHIFT_REG;
 logic rnode_370to371_bb3_cmp300_i_0_stall_out_reg_371_NO_SHIFT_REG;

acl_data_fifo rnode_370to371_bb3_cmp300_i_0_reg_371_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_370to371_bb3_cmp300_i_0_reg_371_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_370to371_bb3_cmp300_i_0_stall_in_reg_371_NO_SHIFT_REG),
	.valid_out(rnode_370to371_bb3_cmp300_i_0_valid_out_reg_371_NO_SHIFT_REG),
	.stall_out(rnode_370to371_bb3_cmp300_i_0_stall_out_reg_371_NO_SHIFT_REG),
	.data_in(local_bb3_cmp300_i),
	.data_out(rnode_370to371_bb3_cmp300_i_0_reg_371_NO_SHIFT_REG)
);

defparam rnode_370to371_bb3_cmp300_i_0_reg_371_fifo.DEPTH = 1;
defparam rnode_370to371_bb3_cmp300_i_0_reg_371_fifo.DATA_WIDTH = 1;
defparam rnode_370to371_bb3_cmp300_i_0_reg_371_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_370to371_bb3_cmp300_i_0_reg_371_fifo.IMPL = "shift_reg";

assign rnode_370to371_bb3_cmp300_i_0_reg_371_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_cmp300_i_stall_in = 1'b0;
assign rnode_370to371_bb3_cmp300_i_0_NO_SHIFT_REG = rnode_370to371_bb3_cmp300_i_0_reg_371_NO_SHIFT_REG;
assign rnode_370to371_bb3_cmp300_i_0_stall_in_reg_371_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_cmp300_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_shl274_i_stall_local;
wire [31:0] local_bb3_shl274_i;

assign local_bb3_shl274_i = (rnode_370to371_bb3_and270_i_0_NO_SHIFT_REG & 32'h7F800000);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp259_i_stall_local;
wire local_bb3_cmp259_i;

assign local_bb3_cmp259_i = ($signed(rnode_370to371_bb3_add246_i_0_NO_SHIFT_REG) > $signed(32'hFE));

// This section implements an unregistered operation.
// 
wire local_bb3_and273_i_stall_local;
wire [31:0] local_bb3_and273_i;

assign local_bb3_and273_i = (rnode_370to371_bb3_shr272_i_0_NO_SHIFT_REG & 32'h7FFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp227_not_i_stall_local;
wire local_bb3_cmp227_not_i;

assign local_bb3_cmp227_not_i = (rnode_370to371_bb3_cmp227_i_0_NO_SHIFT_REG ^ 1'b1);

// This section implements an unregistered operation.
// 
wire local_bb3__47_i_stall_local;
wire local_bb3__47_i;

assign local_bb3__47_i = (rnode_370to371_bb3_cmp227_i_1_NO_SHIFT_REG | rnode_370to371_bb3_not__46_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_cmp29749_i_stall_local;
wire [31:0] local_bb3_cmp29749_i;

assign local_bb3_cmp29749_i[31:1] = 31'h0;
assign local_bb3_cmp29749_i[0] = rnode_370to371_bb3_cmp297_i_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_conv301_i_stall_local;
wire [31:0] local_bb3_conv301_i;

assign local_bb3_conv301_i[31:1] = 31'h0;
assign local_bb3_conv301_i[0] = rnode_370to371_bb3_cmp300_i_0_NO_SHIFT_REG;

// This section implements an unregistered operation.
// 
wire local_bb3_or275_i_stall_local;
wire [31:0] local_bb3_or275_i;

assign local_bb3_or275_i = (local_bb3_and273_i | local_bb3_shl274_i);

// This section implements an unregistered operation.
// 
wire local_bb3_brmerge12_i_stall_local;
wire local_bb3_brmerge12_i;

assign local_bb3_brmerge12_i = (local_bb3_cmp227_not_i | rnode_370to371_bb3_not_cmp38_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_lnot263__i_stall_local;
wire local_bb3_lnot263__i;

assign local_bb3_lnot263__i = (local_bb3_cmp259_i & local_bb3_cmp227_not_i);

// This section implements an unregistered operation.
// 
wire local_bb3_var__u45_stall_local;
wire [31:0] local_bb3_var__u45;

assign local_bb3_var__u45[31:1] = 31'h0;
assign local_bb3_var__u45[0] = local_bb3__47_i;

// This section implements an unregistered operation.
// 
wire local_bb3_resultSign_0_i_stall_local;
wire [31:0] local_bb3_resultSign_0_i;

assign local_bb3_resultSign_0_i = (local_bb3_brmerge12_i ? rnode_370to371_bb3_and35_i_0_NO_SHIFT_REG : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_or2672_i_stall_local;
wire local_bb3_or2672_i;

assign local_bb3_or2672_i = (rnode_370to371_bb3_var__u39_0_NO_SHIFT_REG | local_bb3_lnot263__i);

// This section implements an unregistered operation.
// 
wire local_bb3_or276_i_stall_local;
wire [31:0] local_bb3_or276_i;

assign local_bb3_or276_i = (local_bb3_or275_i | local_bb3_resultSign_0_i);

// This section implements an unregistered operation.
// 
wire local_bb3_or2814_i_stall_local;
wire local_bb3_or2814_i;

assign local_bb3_or2814_i = (local_bb3__47_i | local_bb3_or2672_i);

// This section implements an unregistered operation.
// 
wire local_bb3_or2885_i_stall_local;
wire local_bb3_or2885_i;

assign local_bb3_or2885_i = (local_bb3_or2672_i | rnode_370to371_bb3__26_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_var__u46_stall_local;
wire [31:0] local_bb3_var__u46;

assign local_bb3_var__u46[31:1] = 31'h0;
assign local_bb3_var__u46[0] = local_bb3_or2672_i;

// This section implements an unregistered operation.
// 
wire local_bb3_cond283_i_stall_local;
wire [31:0] local_bb3_cond283_i;

assign local_bb3_cond283_i = (local_bb3_or2814_i ? 32'h80000000 : 32'hFFFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_cond290_i_stall_local;
wire [31:0] local_bb3_cond290_i;

assign local_bb3_cond290_i = (local_bb3_or2885_i ? 32'h7F800000 : 32'h0);

// This section implements an unregistered operation.
// 
wire local_bb3_lnot_ext311_i_stall_local;
wire [31:0] local_bb3_lnot_ext311_i;

assign local_bb3_lnot_ext311_i = (local_bb3_var__u46 ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb3_and294_i_stall_local;
wire [31:0] local_bb3_and294_i;

assign local_bb3_and294_i = (local_bb3_cond283_i & local_bb3_or276_i);

// This section implements an unregistered operation.
// 
wire local_bb3_or295_i_stall_local;
wire [31:0] local_bb3_or295_i;

assign local_bb3_or295_i = (local_bb3_cond290_i | local_bb3_cond293_i);

// This section implements an unregistered operation.
// 
wire local_bb3_reduction_0_i25_stall_local;
wire [31:0] local_bb3_reduction_0_i25;

assign local_bb3_reduction_0_i25 = (local_bb3_lnot_ext311_i & local_bb3_lnot_ext_i);

// This section implements an unregistered operation.
// 
wire local_bb3_and303_i_stall_local;
wire [31:0] local_bb3_and303_i;

assign local_bb3_and303_i = (local_bb3_conv301_i & local_bb3_and294_i);

// This section implements an unregistered operation.
// 
wire local_bb3_or296_i_stall_local;
wire [31:0] local_bb3_or296_i;

assign local_bb3_or296_i = (local_bb3_or295_i | local_bb3_and294_i);

// This section implements an unregistered operation.
// 
wire local_bb3_or296_i_valid_out;
wire local_bb3_or296_i_stall_in;
 reg local_bb3_or296_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_var__u45_valid_out;
wire local_bb3_var__u45_stall_in;
 reg local_bb3_var__u45_consumed_0_NO_SHIFT_REG;
wire local_bb3_lor_ext_i_valid_out;
wire local_bb3_lor_ext_i_stall_in;
 reg local_bb3_lor_ext_i_consumed_0_NO_SHIFT_REG;
wire local_bb3_reduction_0_i25_valid_out;
wire local_bb3_reduction_0_i25_stall_in;
 reg local_bb3_reduction_0_i25_consumed_0_NO_SHIFT_REG;
wire local_bb3_lor_ext_i_inputs_ready;
wire local_bb3_lor_ext_i_stall_local;
wire [31:0] local_bb3_lor_ext_i;

assign local_bb3_lor_ext_i_inputs_ready = (rnode_370to371_bb3_and35_i_0_valid_out_NO_SHIFT_REG & rnode_370to371_bb3_not_cmp38_i_0_valid_out_NO_SHIFT_REG & rnode_370to371_bb3_and270_i_0_valid_out_NO_SHIFT_REG & rnode_370to371_bb3_add246_i_0_valid_out_NO_SHIFT_REG & rnode_370to371_bb3_var__u39_0_valid_out_NO_SHIFT_REG & rnode_370to371_bb3__26_i_0_valid_out_0_NO_SHIFT_REG & rnode_370to371_bb3__26_i_0_valid_out_1_NO_SHIFT_REG & rnode_370to371_bb3_cmp227_i_0_valid_out_1_NO_SHIFT_REG & rnode_370to371_bb3_not__46_i_0_valid_out_NO_SHIFT_REG & rnode_370to371_bb3_shr272_i_0_valid_out_NO_SHIFT_REG & rnode_370to371_bb3__26_i_0_valid_out_2_NO_SHIFT_REG & rnode_370to371_bb3_cmp227_i_0_valid_out_0_NO_SHIFT_REG & rnode_370to371_bb3_cmp297_i_0_valid_out_NO_SHIFT_REG & rnode_370to371_bb3_cmp300_i_0_valid_out_NO_SHIFT_REG);
assign local_bb3_lor_ext_i = (local_bb3_cmp29749_i | local_bb3_and303_i);
assign local_bb3_or296_i_valid_out = 1'b1;
assign local_bb3_var__u45_valid_out = 1'b1;
assign local_bb3_lor_ext_i_valid_out = 1'b1;
assign local_bb3_reduction_0_i25_valid_out = 1'b1;
assign rnode_370to371_bb3_and35_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_not_cmp38_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_and270_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_add246_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_var__u39_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3__26_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3__26_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_cmp227_i_0_stall_in_1_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_not__46_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_shr272_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3__26_i_0_stall_in_2_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_cmp227_i_0_stall_in_0_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_cmp297_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_370to371_bb3_cmp300_i_0_stall_in_NO_SHIFT_REG = 1'b0;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_or296_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_var__u45_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_lor_ext_i_consumed_0_NO_SHIFT_REG <= 1'b0;
		local_bb3_reduction_0_i25_consumed_0_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		local_bb3_or296_i_consumed_0_NO_SHIFT_REG <= (local_bb3_lor_ext_i_inputs_ready & (local_bb3_or296_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_or296_i_stall_in)) & local_bb3_lor_ext_i_stall_local);
		local_bb3_var__u45_consumed_0_NO_SHIFT_REG <= (local_bb3_lor_ext_i_inputs_ready & (local_bb3_var__u45_consumed_0_NO_SHIFT_REG | ~(local_bb3_var__u45_stall_in)) & local_bb3_lor_ext_i_stall_local);
		local_bb3_lor_ext_i_consumed_0_NO_SHIFT_REG <= (local_bb3_lor_ext_i_inputs_ready & (local_bb3_lor_ext_i_consumed_0_NO_SHIFT_REG | ~(local_bb3_lor_ext_i_stall_in)) & local_bb3_lor_ext_i_stall_local);
		local_bb3_reduction_0_i25_consumed_0_NO_SHIFT_REG <= (local_bb3_lor_ext_i_inputs_ready & (local_bb3_reduction_0_i25_consumed_0_NO_SHIFT_REG | ~(local_bb3_reduction_0_i25_stall_in)) & local_bb3_lor_ext_i_stall_local);
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_371to372_bb3_or296_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_371to372_bb3_or296_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_371to372_bb3_or296_i_0_NO_SHIFT_REG;
 logic rnode_371to372_bb3_or296_i_0_reg_372_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_371to372_bb3_or296_i_0_reg_372_NO_SHIFT_REG;
 logic rnode_371to372_bb3_or296_i_0_valid_out_reg_372_NO_SHIFT_REG;
 logic rnode_371to372_bb3_or296_i_0_stall_in_reg_372_NO_SHIFT_REG;
 logic rnode_371to372_bb3_or296_i_0_stall_out_reg_372_NO_SHIFT_REG;

acl_data_fifo rnode_371to372_bb3_or296_i_0_reg_372_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_371to372_bb3_or296_i_0_reg_372_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_371to372_bb3_or296_i_0_stall_in_reg_372_NO_SHIFT_REG),
	.valid_out(rnode_371to372_bb3_or296_i_0_valid_out_reg_372_NO_SHIFT_REG),
	.stall_out(rnode_371to372_bb3_or296_i_0_stall_out_reg_372_NO_SHIFT_REG),
	.data_in(local_bb3_or296_i),
	.data_out(rnode_371to372_bb3_or296_i_0_reg_372_NO_SHIFT_REG)
);

defparam rnode_371to372_bb3_or296_i_0_reg_372_fifo.DEPTH = 1;
defparam rnode_371to372_bb3_or296_i_0_reg_372_fifo.DATA_WIDTH = 32;
defparam rnode_371to372_bb3_or296_i_0_reg_372_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_371to372_bb3_or296_i_0_reg_372_fifo.IMPL = "shift_reg";

assign rnode_371to372_bb3_or296_i_0_reg_372_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_or296_i_stall_in = 1'b0;
assign rnode_371to372_bb3_or296_i_0_NO_SHIFT_REG = rnode_371to372_bb3_or296_i_0_reg_372_NO_SHIFT_REG;
assign rnode_371to372_bb3_or296_i_0_stall_in_reg_372_NO_SHIFT_REG = 1'b0;
assign rnode_371to372_bb3_or296_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_371to372_bb3_var__u45_0_valid_out_NO_SHIFT_REG;
 logic rnode_371to372_bb3_var__u45_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_371to372_bb3_var__u45_0_NO_SHIFT_REG;
 logic rnode_371to372_bb3_var__u45_0_reg_372_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_371to372_bb3_var__u45_0_reg_372_NO_SHIFT_REG;
 logic rnode_371to372_bb3_var__u45_0_valid_out_reg_372_NO_SHIFT_REG;
 logic rnode_371to372_bb3_var__u45_0_stall_in_reg_372_NO_SHIFT_REG;
 logic rnode_371to372_bb3_var__u45_0_stall_out_reg_372_NO_SHIFT_REG;

acl_data_fifo rnode_371to372_bb3_var__u45_0_reg_372_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_371to372_bb3_var__u45_0_reg_372_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_371to372_bb3_var__u45_0_stall_in_reg_372_NO_SHIFT_REG),
	.valid_out(rnode_371to372_bb3_var__u45_0_valid_out_reg_372_NO_SHIFT_REG),
	.stall_out(rnode_371to372_bb3_var__u45_0_stall_out_reg_372_NO_SHIFT_REG),
	.data_in(local_bb3_var__u45),
	.data_out(rnode_371to372_bb3_var__u45_0_reg_372_NO_SHIFT_REG)
);

defparam rnode_371to372_bb3_var__u45_0_reg_372_fifo.DEPTH = 1;
defparam rnode_371to372_bb3_var__u45_0_reg_372_fifo.DATA_WIDTH = 32;
defparam rnode_371to372_bb3_var__u45_0_reg_372_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_371to372_bb3_var__u45_0_reg_372_fifo.IMPL = "shift_reg";

assign rnode_371to372_bb3_var__u45_0_reg_372_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_var__u45_stall_in = 1'b0;
assign rnode_371to372_bb3_var__u45_0_NO_SHIFT_REG = rnode_371to372_bb3_var__u45_0_reg_372_NO_SHIFT_REG;
assign rnode_371to372_bb3_var__u45_0_stall_in_reg_372_NO_SHIFT_REG = 1'b0;
assign rnode_371to372_bb3_var__u45_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_371to372_bb3_lor_ext_i_0_valid_out_NO_SHIFT_REG;
 logic rnode_371to372_bb3_lor_ext_i_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_371to372_bb3_lor_ext_i_0_NO_SHIFT_REG;
 logic rnode_371to372_bb3_lor_ext_i_0_reg_372_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_371to372_bb3_lor_ext_i_0_reg_372_NO_SHIFT_REG;
 logic rnode_371to372_bb3_lor_ext_i_0_valid_out_reg_372_NO_SHIFT_REG;
 logic rnode_371to372_bb3_lor_ext_i_0_stall_in_reg_372_NO_SHIFT_REG;
 logic rnode_371to372_bb3_lor_ext_i_0_stall_out_reg_372_NO_SHIFT_REG;

acl_data_fifo rnode_371to372_bb3_lor_ext_i_0_reg_372_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_371to372_bb3_lor_ext_i_0_reg_372_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_371to372_bb3_lor_ext_i_0_stall_in_reg_372_NO_SHIFT_REG),
	.valid_out(rnode_371to372_bb3_lor_ext_i_0_valid_out_reg_372_NO_SHIFT_REG),
	.stall_out(rnode_371to372_bb3_lor_ext_i_0_stall_out_reg_372_NO_SHIFT_REG),
	.data_in(local_bb3_lor_ext_i),
	.data_out(rnode_371to372_bb3_lor_ext_i_0_reg_372_NO_SHIFT_REG)
);

defparam rnode_371to372_bb3_lor_ext_i_0_reg_372_fifo.DEPTH = 1;
defparam rnode_371to372_bb3_lor_ext_i_0_reg_372_fifo.DATA_WIDTH = 32;
defparam rnode_371to372_bb3_lor_ext_i_0_reg_372_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_371to372_bb3_lor_ext_i_0_reg_372_fifo.IMPL = "shift_reg";

assign rnode_371to372_bb3_lor_ext_i_0_reg_372_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_lor_ext_i_stall_in = 1'b0;
assign rnode_371to372_bb3_lor_ext_i_0_NO_SHIFT_REG = rnode_371to372_bb3_lor_ext_i_0_reg_372_NO_SHIFT_REG;
assign rnode_371to372_bb3_lor_ext_i_0_stall_in_reg_372_NO_SHIFT_REG = 1'b0;
assign rnode_371to372_bb3_lor_ext_i_0_valid_out_NO_SHIFT_REG = 1'b1;

// Register node:
//  * latency = 1
//  * capacity = 1
 logic rnode_371to372_bb3_reduction_0_i25_0_valid_out_NO_SHIFT_REG;
 logic rnode_371to372_bb3_reduction_0_i25_0_stall_in_NO_SHIFT_REG;
 logic [31:0] rnode_371to372_bb3_reduction_0_i25_0_NO_SHIFT_REG;
 logic rnode_371to372_bb3_reduction_0_i25_0_reg_372_inputs_ready_NO_SHIFT_REG;
 logic [31:0] rnode_371to372_bb3_reduction_0_i25_0_reg_372_NO_SHIFT_REG;
 logic rnode_371to372_bb3_reduction_0_i25_0_valid_out_reg_372_NO_SHIFT_REG;
 logic rnode_371to372_bb3_reduction_0_i25_0_stall_in_reg_372_NO_SHIFT_REG;
 logic rnode_371to372_bb3_reduction_0_i25_0_stall_out_reg_372_NO_SHIFT_REG;

acl_data_fifo rnode_371to372_bb3_reduction_0_i25_0_reg_372_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_371to372_bb3_reduction_0_i25_0_reg_372_inputs_ready_NO_SHIFT_REG),
	.stall_in(rnode_371to372_bb3_reduction_0_i25_0_stall_in_reg_372_NO_SHIFT_REG),
	.valid_out(rnode_371to372_bb3_reduction_0_i25_0_valid_out_reg_372_NO_SHIFT_REG),
	.stall_out(rnode_371to372_bb3_reduction_0_i25_0_stall_out_reg_372_NO_SHIFT_REG),
	.data_in(local_bb3_reduction_0_i25),
	.data_out(rnode_371to372_bb3_reduction_0_i25_0_reg_372_NO_SHIFT_REG)
);

defparam rnode_371to372_bb3_reduction_0_i25_0_reg_372_fifo.DEPTH = 1;
defparam rnode_371to372_bb3_reduction_0_i25_0_reg_372_fifo.DATA_WIDTH = 32;
defparam rnode_371to372_bb3_reduction_0_i25_0_reg_372_fifo.ALLOW_FULL_WRITE = 1;
defparam rnode_371to372_bb3_reduction_0_i25_0_reg_372_fifo.IMPL = "shift_reg";

assign rnode_371to372_bb3_reduction_0_i25_0_reg_372_inputs_ready_NO_SHIFT_REG = 1'b1;
assign local_bb3_reduction_0_i25_stall_in = 1'b0;
assign rnode_371to372_bb3_reduction_0_i25_0_NO_SHIFT_REG = rnode_371to372_bb3_reduction_0_i25_0_reg_372_NO_SHIFT_REG;
assign rnode_371to372_bb3_reduction_0_i25_0_stall_in_reg_372_NO_SHIFT_REG = 1'b0;
assign rnode_371to372_bb3_reduction_0_i25_0_valid_out_NO_SHIFT_REG = 1'b1;

// This section implements an unregistered operation.
// 
wire local_bb3_lnot_ext315_i_stall_local;
wire [31:0] local_bb3_lnot_ext315_i;

assign local_bb3_lnot_ext315_i = (rnode_371to372_bb3_var__u45_0_NO_SHIFT_REG ^ 32'h1);

// This section implements an unregistered operation.
// 
wire local_bb3_reduction_1_i_stall_local;
wire [31:0] local_bb3_reduction_1_i;

assign local_bb3_reduction_1_i = (local_bb3_lnot_ext315_i & rnode_371to372_bb3_lor_ext_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_reduction_2_i26_stall_local;
wire [31:0] local_bb3_reduction_2_i26;

assign local_bb3_reduction_2_i26 = (rnode_371to372_bb3_reduction_0_i25_0_NO_SHIFT_REG & local_bb3_reduction_1_i);

// This section implements an unregistered operation.
// 
wire local_bb3_add321_i_stall_local;
wire [31:0] local_bb3_add321_i;

assign local_bb3_add321_i = (local_bb3_reduction_2_i26 + rnode_371to372_bb3_or296_i_0_NO_SHIFT_REG);

// This section implements an unregistered operation.
// 
wire local_bb3_and_i_i_stall_local;
wire [31:0] local_bb3_and_i_i;

assign local_bb3_and_i_i = (local_bb3_add321_i & 32'h7FFFFFFF);

// This section implements an unregistered operation.
// 
wire local_bb3_astype1_i_i_stall_local;
wire [31:0] local_bb3_astype1_i_i;

assign local_bb3_astype1_i_i = local_bb3_and_i_i;

// This section implements an unregistered operation.
// 
wire local_bb3_c1_exi1_valid_out;
wire local_bb3_c1_exi1_stall_in;
wire local_bb3_c1_exi1_inputs_ready;
wire local_bb3_c1_exi1_stall_local;
wire [63:0] local_bb3_c1_exi1;

assign local_bb3_c1_exi1_inputs_ready = (rnode_371to372_bb3_or296_i_0_valid_out_NO_SHIFT_REG & rnode_371to372_bb3_reduction_0_i25_0_valid_out_NO_SHIFT_REG & rnode_371to372_bb3_var__u45_0_valid_out_NO_SHIFT_REG & rnode_371to372_bb3_lor_ext_i_0_valid_out_NO_SHIFT_REG);
assign local_bb3_c1_exi1[31:0] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
assign local_bb3_c1_exi1[63:32] = local_bb3_astype1_i_i;
assign local_bb3_c1_exi1_valid_out = 1'b1;
assign rnode_371to372_bb3_or296_i_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_371to372_bb3_reduction_0_i25_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_371to372_bb3_var__u45_0_stall_in_NO_SHIFT_REG = 1'b0;
assign rnode_371to372_bb3_lor_ext_i_0_stall_in_NO_SHIFT_REG = 1'b0;

// This section implements a registered operation.
// 
wire local_bb3_c1_exit_c1_exi1_inputs_ready;
 reg local_bb3_c1_exit_c1_exi1_valid_out_NO_SHIFT_REG;
wire local_bb3_c1_exit_c1_exi1_stall_in;
 reg [63:0] local_bb3_c1_exit_c1_exi1_NO_SHIFT_REG;
wire [63:0] local_bb3_c1_exit_c1_exi1_in;
wire local_bb3_c1_exit_c1_exi1_valid;
wire local_bb3_c1_exit_c1_exi1_causedstall;

acl_stall_free_sink local_bb3_c1_exit_c1_exi1_instance (
	.clock(clock),
	.resetn(resetn),
	.data_in(local_bb3_c1_exi1),
	.data_out(local_bb3_c1_exit_c1_exi1_in),
	.input_accepted(local_bb3_c1_enter_c1_eni2_input_accepted),
	.valid_out(local_bb3_c1_exit_c1_exi1_valid),
	.stall_in(~(local_bb3_c1_exit_c1_exi1_output_regs_ready)),
	.stall_entry(local_bb3_c1_exit_c1_exi1_entry_stall),
	.valids(local_bb3_c1_exit_c1_exi1_valid_bits),
	.IIphases(local_bb3_c1_exit_c1_exi1_phases),
	.inc_pipelined_thread(local_bb3_c1_enter_c1_eni2_inc_pipelined_thread),
	.dec_pipelined_thread(local_bb3_c1_enter_c1_eni2_dec_pipelined_thread)
);

defparam local_bb3_c1_exit_c1_exi1_instance.DATA_WIDTH = 64;
defparam local_bb3_c1_exit_c1_exi1_instance.PIPELINE_DEPTH = 12;
defparam local_bb3_c1_exit_c1_exi1_instance.SHARINGII = 1;
defparam local_bb3_c1_exit_c1_exi1_instance.SCHEDULEII = 1;

assign local_bb3_c1_exit_c1_exi1_inputs_ready = 1'b1;
assign local_bb3_c1_exit_c1_exi1_output_regs_ready = (&(~(local_bb3_c1_exit_c1_exi1_valid_out_NO_SHIFT_REG) | ~(local_bb3_c1_exit_c1_exi1_stall_in)));
assign local_bb3_c1_exi1_stall_in = 1'b0;
assign local_bb3_c1_exit_c1_exi1_causedstall = (1'b1 && (1'b0 && !(~(local_bb3_c1_exit_c1_exi1_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_c1_exit_c1_exi1_NO_SHIFT_REG <= 'x;
		local_bb3_c1_exit_c1_exi1_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_c1_exit_c1_exi1_output_regs_ready)
		begin
			local_bb3_c1_exit_c1_exi1_NO_SHIFT_REG <= local_bb3_c1_exit_c1_exi1_in;
			local_bb3_c1_exit_c1_exi1_valid_out_NO_SHIFT_REG <= local_bb3_c1_exit_c1_exi1_valid;
		end
		else
		begin
			if (~(local_bb3_c1_exit_c1_exi1_stall_in))
			begin
				local_bb3_c1_exit_c1_exi1_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements an unregistered operation.
// 
wire local_bb3_c1_exe1_valid_out;
wire local_bb3_c1_exe1_stall_in;
wire local_bb3_c1_exe1_inputs_ready;
wire local_bb3_c1_exe1_stall_local;
wire [31:0] local_bb3_c1_exe1;

assign local_bb3_c1_exe1_inputs_ready = local_bb3_c1_exit_c1_exi1_valid_out_NO_SHIFT_REG;
assign local_bb3_c1_exe1 = local_bb3_c1_exit_c1_exi1_NO_SHIFT_REG[63:32];
assign local_bb3_c1_exe1_valid_out = local_bb3_c1_exe1_inputs_ready;
assign local_bb3_c1_exe1_stall_local = local_bb3_c1_exe1_stall_in;
assign local_bb3_c1_exit_c1_exi1_stall_in = (|local_bb3_c1_exe1_stall_local);

// This section implements a registered operation.
// 
wire local_bb3_st_c1_exe1_inputs_ready;
 reg local_bb3_st_c1_exe1_valid_out_NO_SHIFT_REG;
wire local_bb3_st_c1_exe1_stall_in;
wire local_bb3_st_c1_exe1_output_regs_ready;
wire local_bb3_st_c1_exe1_fu_stall_out;
wire local_bb3_st_c1_exe1_fu_valid_out;
wire local_bb3_st_c1_exe1_causedstall;

lsu_top lsu_local_bb3_st_c1_exe1 (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(),
	.stream_size(),
	.stream_reset(),
	.o_stall(local_bb3_st_c1_exe1_fu_stall_out),
	.i_valid(local_bb3_st_c1_exe1_inputs_ready),
	.i_address(rnode_376to377_bb3_arrayidx20_0_NO_SHIFT_REG),
	.i_writedata(local_bb3_c1_exe1),
	.i_cmpdata(),
	.i_predicate(1'b0),
	.i_bitwiseor(64'h0),
	.i_byteenable(),
	.i_stall(~(local_bb3_st_c1_exe1_output_regs_ready)),
	.o_valid(local_bb3_st_c1_exe1_fu_valid_out),
	.o_readdata(),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb3_st_c1_exe1_active),
	.avm_address(avm_local_bb3_st_c1_exe1_address),
	.avm_read(avm_local_bb3_st_c1_exe1_read),
	.avm_readdata(avm_local_bb3_st_c1_exe1_readdata),
	.avm_write(avm_local_bb3_st_c1_exe1_write),
	.avm_writeack(avm_local_bb3_st_c1_exe1_writeack),
	.avm_burstcount(avm_local_bb3_st_c1_exe1_burstcount),
	.avm_writedata(avm_local_bb3_st_c1_exe1_writedata),
	.avm_byteenable(avm_local_bb3_st_c1_exe1_byteenable),
	.avm_waitrequest(avm_local_bb3_st_c1_exe1_waitrequest),
	.avm_readdatavalid(avm_local_bb3_st_c1_exe1_readdatavalid),
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

defparam lsu_local_bb3_st_c1_exe1.AWIDTH = 30;
defparam lsu_local_bb3_st_c1_exe1.WIDTH_BYTES = 4;
defparam lsu_local_bb3_st_c1_exe1.MWIDTH_BYTES = 32;
defparam lsu_local_bb3_st_c1_exe1.WRITEDATAWIDTH_BYTES = 32;
defparam lsu_local_bb3_st_c1_exe1.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb3_st_c1_exe1.READ = 0;
defparam lsu_local_bb3_st_c1_exe1.ATOMIC = 0;
defparam lsu_local_bb3_st_c1_exe1.WIDTH = 32;
defparam lsu_local_bb3_st_c1_exe1.MWIDTH = 256;
defparam lsu_local_bb3_st_c1_exe1.ATOMIC_WIDTH = 3;
defparam lsu_local_bb3_st_c1_exe1.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb3_st_c1_exe1.KERNEL_SIDE_MEM_LATENCY = 4;
defparam lsu_local_bb3_st_c1_exe1.MEMORY_SIDE_MEM_LATENCY = 10;
defparam lsu_local_bb3_st_c1_exe1.USE_WRITE_ACK = 0;
defparam lsu_local_bb3_st_c1_exe1.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb3_st_c1_exe1.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb3_st_c1_exe1.NUMBER_BANKS = 1;
defparam lsu_local_bb3_st_c1_exe1.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb3_st_c1_exe1.USEINPUTFIFO = 0;
defparam lsu_local_bb3_st_c1_exe1.USECACHING = 0;
defparam lsu_local_bb3_st_c1_exe1.USEOUTPUTFIFO = 1;
defparam lsu_local_bb3_st_c1_exe1.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb3_st_c1_exe1.HIGH_FMAX = 1;
defparam lsu_local_bb3_st_c1_exe1.ADDRSPACE = 1;
defparam lsu_local_bb3_st_c1_exe1.STYLE = "BURST-COALESCED";
defparam lsu_local_bb3_st_c1_exe1.USE_BYTE_EN = 0;

assign local_bb3_st_c1_exe1_inputs_ready = (local_bb3_c1_exe1_valid_out & rnode_376to377_bb3_arrayidx20_0_valid_out_NO_SHIFT_REG);
assign local_bb3_st_c1_exe1_output_regs_ready = (&(~(local_bb3_st_c1_exe1_valid_out_NO_SHIFT_REG) | ~(local_bb3_st_c1_exe1_stall_in)));
assign local_bb3_c1_exe1_stall_in = (local_bb3_st_c1_exe1_fu_stall_out | ~(local_bb3_st_c1_exe1_inputs_ready));
assign rnode_376to377_bb3_arrayidx20_0_stall_in_NO_SHIFT_REG = (local_bb3_st_c1_exe1_fu_stall_out | ~(local_bb3_st_c1_exe1_inputs_ready));
assign local_bb3_st_c1_exe1_causedstall = (local_bb3_st_c1_exe1_inputs_ready && (local_bb3_st_c1_exe1_fu_stall_out && !(~(local_bb3_st_c1_exe1_output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb3_st_c1_exe1_valid_out_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (local_bb3_st_c1_exe1_output_regs_ready)
		begin
			local_bb3_st_c1_exe1_valid_out_NO_SHIFT_REG <= local_bb3_st_c1_exe1_fu_valid_out;
		end
		else
		begin
			if (~(local_bb3_st_c1_exe1_stall_in))
			begin
				local_bb3_st_c1_exe1_valid_out_NO_SHIFT_REG <= 1'b0;
			end
		end
	end
end


// This section implements a staging register.
// 
wire rstag_381to381_bb3_st_c1_exe1_valid_out;
wire rstag_381to381_bb3_st_c1_exe1_stall_in;
wire rstag_381to381_bb3_st_c1_exe1_inputs_ready;
wire rstag_381to381_bb3_st_c1_exe1_stall_local;
 reg rstag_381to381_bb3_st_c1_exe1_staging_valid_NO_SHIFT_REG;
wire rstag_381to381_bb3_st_c1_exe1_combined_valid;

assign rstag_381to381_bb3_st_c1_exe1_inputs_ready = local_bb3_st_c1_exe1_valid_out_NO_SHIFT_REG;
assign rstag_381to381_bb3_st_c1_exe1_combined_valid = (rstag_381to381_bb3_st_c1_exe1_staging_valid_NO_SHIFT_REG | rstag_381to381_bb3_st_c1_exe1_inputs_ready);
assign rstag_381to381_bb3_st_c1_exe1_valid_out = rstag_381to381_bb3_st_c1_exe1_combined_valid;
assign rstag_381to381_bb3_st_c1_exe1_stall_local = rstag_381to381_bb3_st_c1_exe1_stall_in;
assign local_bb3_st_c1_exe1_stall_in = (|rstag_381to381_bb3_st_c1_exe1_staging_valid_NO_SHIFT_REG);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_381to381_bb3_st_c1_exe1_staging_valid_NO_SHIFT_REG <= 1'b0;
	end
	else
	begin
		if (rstag_381to381_bb3_st_c1_exe1_stall_local)
		begin
			if (~(rstag_381to381_bb3_st_c1_exe1_staging_valid_NO_SHIFT_REG))
			begin
				rstag_381to381_bb3_st_c1_exe1_staging_valid_NO_SHIFT_REG <= rstag_381to381_bb3_st_c1_exe1_inputs_ready;
			end
		end
		else
		begin
			rstag_381to381_bb3_st_c1_exe1_staging_valid_NO_SHIFT_REG <= 1'b0;
		end
	end
end


// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
wire branch_var__output_regs_ready;

assign branch_var__inputs_ready = (rnode_380to381_input_acl_hw_wg_id_0_valid_out_NO_SHIFT_REG & rstag_381to381_bb3_st_c1_exe1_valid_out);
assign branch_var__output_regs_ready = ~(stall_in);
assign rnode_380to381_input_acl_hw_wg_id_0_stall_in_NO_SHIFT_REG = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign rstag_381to381_bb3_st_c1_exe1_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign valid_out = branch_var__inputs_ready;
assign lvb_input_acl_hw_wg_id = rnode_380to381_input_acl_hw_wg_id_0_NO_SHIFT_REG;

endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module fpgasort_function
	(
		input 		clock,
		input 		resetn,
		input [31:0] 		input_global_id_0,
		input [31:0] 		input_acl_hw_wg_id,
		output 		stall_out,
		input 		valid_in,
		output [31:0] 		output_0,
		output 		valid_out,
		input 		stall_in,
		input [31:0] 		workgroup_size,
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
		input [255:0] 		avm_local_bb2_ld__u1_readdata,
		input 		avm_local_bb2_ld__u1_readdatavalid,
		input 		avm_local_bb2_ld__u1_waitrequest,
		output [29:0] 		avm_local_bb2_ld__u1_address,
		output 		avm_local_bb2_ld__u1_read,
		output 		avm_local_bb2_ld__u1_write,
		input 		avm_local_bb2_ld__u1_writeack,
		output [255:0] 		avm_local_bb2_ld__u1_writedata,
		output [31:0] 		avm_local_bb2_ld__u1_byteenable,
		output [4:0] 		avm_local_bb2_ld__u1_burstcount,
		input [255:0] 		avm_local_bb3_st_c0_exe16_readdata,
		input 		avm_local_bb3_st_c0_exe16_readdatavalid,
		input 		avm_local_bb3_st_c0_exe16_waitrequest,
		output [29:0] 		avm_local_bb3_st_c0_exe16_address,
		output 		avm_local_bb3_st_c0_exe16_read,
		output 		avm_local_bb3_st_c0_exe16_write,
		input 		avm_local_bb3_st_c0_exe16_writeack,
		output [255:0] 		avm_local_bb3_st_c0_exe16_writedata,
		output [31:0] 		avm_local_bb3_st_c0_exe16_byteenable,
		output [4:0] 		avm_local_bb3_st_c0_exe16_burstcount,
		input [255:0] 		avm_local_bb3_ld__readdata,
		input 		avm_local_bb3_ld__readdatavalid,
		input 		avm_local_bb3_ld__waitrequest,
		output [29:0] 		avm_local_bb3_ld__address,
		output 		avm_local_bb3_ld__read,
		output 		avm_local_bb3_ld__write,
		input 		avm_local_bb3_ld__writeack,
		output [255:0] 		avm_local_bb3_ld__writedata,
		output [31:0] 		avm_local_bb3_ld__byteenable,
		output [4:0] 		avm_local_bb3_ld__burstcount,
		input [255:0] 		avm_local_bb3_st_c1_exe1_readdata,
		input 		avm_local_bb3_st_c1_exe1_readdatavalid,
		input 		avm_local_bb3_st_c1_exe1_waitrequest,
		output [29:0] 		avm_local_bb3_st_c1_exe1_address,
		output 		avm_local_bb3_st_c1_exe1_read,
		output 		avm_local_bb3_st_c1_exe1_write,
		input 		avm_local_bb3_st_c1_exe1_writeack,
		output [255:0] 		avm_local_bb3_st_c1_exe1_writedata,
		output [31:0] 		avm_local_bb3_st_c1_exe1_byteenable,
		output [4:0] 		avm_local_bb3_st_c1_exe1_burstcount,
		input 		start,
		input [31:0] 		input_N,
		input 		clock2x,
		input [63:0] 		input_a,
		input [63:0] 		input_p,
		input [63:0] 		input_output,
		input [63:0] 		input_error,
		output reg 		has_a_write_pending,
		output reg 		has_a_lsu_active
	);


wire [31:0] cur_cycle;
wire bb_0_stall_out;
wire bb_0_valid_out;
wire bb_0_lvb_bb0_cmp1;
wire bb_0_lvb_bb0_cmp1_NEG;
wire [31:0] bb_0_lvb_input_global_id_0;
wire [31:0] bb_0_lvb_input_acl_hw_wg_id;
wire bb_1_stall_out;
wire bb_1_valid_out;
wire [31:0] bb_1_lvb_bb1_var_;
wire [63:0] bb_1_lvb_bb1_var__u0;
wire [31:0] bb_1_lvb_bb1_add;
wire [31:0] bb_1_lvb_input_global_id_0;
wire [31:0] bb_1_lvb_input_acl_hw_wg_id;
wire bb_2_stall_out_0;
wire bb_2_stall_out_1;
wire bb_2_valid_out_0;
wire [31:0] bb_2_lvb_var__0;
wire [31:0] bb_2_lvb_add_0;
wire [63:0] bb_2_lvb_bb2_indvars_iv_next_0;
wire [31:0] bb_2_lvb_bb2_c0_exe1_0;
wire [31:0] bb_2_lvb_input_global_id_0_0;
wire [31:0] bb_2_lvb_input_acl_hw_wg_id_0;
wire bb_2_valid_out_1;
wire [31:0] bb_2_lvb_var__1;
wire [31:0] bb_2_lvb_add_1;
wire [63:0] bb_2_lvb_bb2_indvars_iv_next_1;
wire [31:0] bb_2_lvb_bb2_c0_exe1_1;
wire [31:0] bb_2_lvb_input_global_id_0_1;
wire [31:0] bb_2_lvb_input_acl_hw_wg_id_1;
wire bb_2_local_bb2_ld__active;
wire bb_2_local_bb2_ld__u1_active;
wire bb_3_stall_out;
wire bb_3_valid_out;
wire [31:0] bb_3_lvb_input_acl_hw_wg_id;
wire bb_3_local_bb3_st_c0_exe16_active;
wire bb_3_local_bb3_ld__active;
wire bb_3_local_bb3_st_c1_exe1_active;
wire loop_limiter_0_stall_out;
wire loop_limiter_0_valid_out;
wire [1:0] writes_pending;
wire [4:0] lsus_active;

fpgasort_basic_block_0 fpgasort_basic_block_0 (
	.clock(clock),
	.resetn(resetn),
	.start(start),
	.input_N(input_N),
	.valid_in(valid_in),
	.stall_out(bb_0_stall_out),
	.input_global_id_0(input_global_id_0),
	.input_acl_hw_wg_id(input_acl_hw_wg_id),
	.valid_out(bb_0_valid_out),
	.stall_in(bb_1_stall_out),
	.lvb_bb0_cmp1(bb_0_lvb_bb0_cmp1),
	.lvb_bb0_cmp1_NEG(bb_0_lvb_bb0_cmp1_NEG),
	.lvb_input_global_id_0(bb_0_lvb_input_global_id_0),
	.lvb_input_acl_hw_wg_id(bb_0_lvb_input_acl_hw_wg_id),
	.workgroup_size(workgroup_size)
);


fpgasort_basic_block_1 fpgasort_basic_block_1 (
	.clock(clock),
	.resetn(resetn),
	.input_N(input_N),
	.input_wii_cmp1(bb_0_lvb_bb0_cmp1),
	.input_wii_cmp1_NEG(bb_0_lvb_bb0_cmp1_NEG),
	.valid_in(bb_0_valid_out),
	.stall_out(bb_1_stall_out),
	.input_global_id_0(bb_0_lvb_input_global_id_0),
	.input_acl_hw_wg_id(bb_0_lvb_input_acl_hw_wg_id),
	.valid_out(bb_1_valid_out),
	.stall_in(loop_limiter_0_stall_out),
	.lvb_bb1_var_(bb_1_lvb_bb1_var_),
	.lvb_bb1_var__u0(bb_1_lvb_bb1_var__u0),
	.lvb_bb1_add(bb_1_lvb_bb1_add),
	.lvb_input_global_id_0(bb_1_lvb_input_global_id_0),
	.lvb_input_acl_hw_wg_id(bb_1_lvb_input_acl_hw_wg_id),
	.workgroup_size(workgroup_size),
	.start(start)
);


fpgasort_basic_block_2 fpgasort_basic_block_2 (
	.clock(clock),
	.resetn(resetn),
	.input_a(input_a),
	.input_p(input_p),
	.input_wii_cmp1(bb_0_lvb_bb0_cmp1),
	.input_wii_cmp1_NEG(bb_0_lvb_bb0_cmp1_NEG),
	.valid_in_0(bb_2_valid_out_1),
	.stall_out_0(bb_2_stall_out_0),
	.input_var__0(bb_2_lvb_var__1),
	.input_add_0(bb_2_lvb_add_1),
	.input_indvars_iv_0(bb_2_lvb_bb2_indvars_iv_next_1),
	.input_score_02_0(bb_2_lvb_bb2_c0_exe1_1),
	.input_global_id_0_0(bb_2_lvb_input_global_id_0_1),
	.input_acl_hw_wg_id_0(bb_2_lvb_input_acl_hw_wg_id_1),
	.valid_in_1(loop_limiter_0_valid_out),
	.stall_out_1(bb_2_stall_out_1),
	.input_var__1(bb_1_lvb_bb1_var_),
	.input_add_1(bb_1_lvb_bb1_add),
	.input_indvars_iv_1(bb_1_lvb_bb1_var__u0),
	.input_score_02_1(32'h0),
	.input_global_id_0_1(bb_1_lvb_input_global_id_0),
	.input_acl_hw_wg_id_1(bb_1_lvb_input_acl_hw_wg_id),
	.valid_out_0(bb_2_valid_out_0),
	.stall_in_0(bb_3_stall_out),
	.lvb_var__0(bb_2_lvb_var__0),
	.lvb_add_0(bb_2_lvb_add_0),
	.lvb_bb2_indvars_iv_next_0(bb_2_lvb_bb2_indvars_iv_next_0),
	.lvb_bb2_c0_exe1_0(bb_2_lvb_bb2_c0_exe1_0),
	.lvb_input_global_id_0_0(bb_2_lvb_input_global_id_0_0),
	.lvb_input_acl_hw_wg_id_0(bb_2_lvb_input_acl_hw_wg_id_0),
	.valid_out_1(bb_2_valid_out_1),
	.stall_in_1(bb_2_stall_out_0),
	.lvb_var__1(bb_2_lvb_var__1),
	.lvb_add_1(bb_2_lvb_add_1),
	.lvb_bb2_indvars_iv_next_1(bb_2_lvb_bb2_indvars_iv_next_1),
	.lvb_bb2_c0_exe1_1(bb_2_lvb_bb2_c0_exe1_1),
	.lvb_input_global_id_0_1(bb_2_lvb_input_global_id_0_1),
	.lvb_input_acl_hw_wg_id_1(bb_2_lvb_input_acl_hw_wg_id_1),
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
	.avm_local_bb2_ld__u1_readdata(avm_local_bb2_ld__u1_readdata),
	.avm_local_bb2_ld__u1_readdatavalid(avm_local_bb2_ld__u1_readdatavalid),
	.avm_local_bb2_ld__u1_waitrequest(avm_local_bb2_ld__u1_waitrequest),
	.avm_local_bb2_ld__u1_address(avm_local_bb2_ld__u1_address),
	.avm_local_bb2_ld__u1_read(avm_local_bb2_ld__u1_read),
	.avm_local_bb2_ld__u1_write(avm_local_bb2_ld__u1_write),
	.avm_local_bb2_ld__u1_writeack(avm_local_bb2_ld__u1_writeack),
	.avm_local_bb2_ld__u1_writedata(avm_local_bb2_ld__u1_writedata),
	.avm_local_bb2_ld__u1_byteenable(avm_local_bb2_ld__u1_byteenable),
	.avm_local_bb2_ld__u1_burstcount(avm_local_bb2_ld__u1_burstcount),
	.local_bb2_ld__u1_active(bb_2_local_bb2_ld__u1_active)
);


fpgasort_basic_block_3 fpgasort_basic_block_3 (
	.clock(clock),
	.resetn(resetn),
	.input_N(input_N),
	.input_output(input_output),
	.input_p(input_p),
	.input_error(input_error),
	.input_wii_cmp1(bb_0_lvb_bb0_cmp1),
	.valid_in(bb_2_valid_out_0),
	.stall_out(bb_3_stall_out),
	.input_c0_exe1(bb_2_lvb_bb2_c0_exe1_0),
	.input_global_id_0(bb_2_lvb_input_global_id_0_0),
	.input_acl_hw_wg_id(bb_2_lvb_input_acl_hw_wg_id_0),
	.valid_out(bb_3_valid_out),
	.stall_in(stall_in),
	.lvb_input_acl_hw_wg_id(bb_3_lvb_input_acl_hw_wg_id),
	.workgroup_size(workgroup_size),
	.start(start),
	.avm_local_bb3_st_c0_exe16_readdata(avm_local_bb3_st_c0_exe16_readdata),
	.avm_local_bb3_st_c0_exe16_readdatavalid(avm_local_bb3_st_c0_exe16_readdatavalid),
	.avm_local_bb3_st_c0_exe16_waitrequest(avm_local_bb3_st_c0_exe16_waitrequest),
	.avm_local_bb3_st_c0_exe16_address(avm_local_bb3_st_c0_exe16_address),
	.avm_local_bb3_st_c0_exe16_read(avm_local_bb3_st_c0_exe16_read),
	.avm_local_bb3_st_c0_exe16_write(avm_local_bb3_st_c0_exe16_write),
	.avm_local_bb3_st_c0_exe16_writeack(avm_local_bb3_st_c0_exe16_writeack),
	.avm_local_bb3_st_c0_exe16_writedata(avm_local_bb3_st_c0_exe16_writedata),
	.avm_local_bb3_st_c0_exe16_byteenable(avm_local_bb3_st_c0_exe16_byteenable),
	.avm_local_bb3_st_c0_exe16_burstcount(avm_local_bb3_st_c0_exe16_burstcount),
	.local_bb3_st_c0_exe16_active(bb_3_local_bb3_st_c0_exe16_active),
	.clock2x(clock2x),
	.avm_local_bb3_ld__readdata(avm_local_bb3_ld__readdata),
	.avm_local_bb3_ld__readdatavalid(avm_local_bb3_ld__readdatavalid),
	.avm_local_bb3_ld__waitrequest(avm_local_bb3_ld__waitrequest),
	.avm_local_bb3_ld__address(avm_local_bb3_ld__address),
	.avm_local_bb3_ld__read(avm_local_bb3_ld__read),
	.avm_local_bb3_ld__write(avm_local_bb3_ld__write),
	.avm_local_bb3_ld__writeack(avm_local_bb3_ld__writeack),
	.avm_local_bb3_ld__writedata(avm_local_bb3_ld__writedata),
	.avm_local_bb3_ld__byteenable(avm_local_bb3_ld__byteenable),
	.avm_local_bb3_ld__burstcount(avm_local_bb3_ld__burstcount),
	.local_bb3_ld__active(bb_3_local_bb3_ld__active),
	.avm_local_bb3_st_c1_exe1_readdata(avm_local_bb3_st_c1_exe1_readdata),
	.avm_local_bb3_st_c1_exe1_readdatavalid(avm_local_bb3_st_c1_exe1_readdatavalid),
	.avm_local_bb3_st_c1_exe1_waitrequest(avm_local_bb3_st_c1_exe1_waitrequest),
	.avm_local_bb3_st_c1_exe1_address(avm_local_bb3_st_c1_exe1_address),
	.avm_local_bb3_st_c1_exe1_read(avm_local_bb3_st_c1_exe1_read),
	.avm_local_bb3_st_c1_exe1_write(avm_local_bb3_st_c1_exe1_write),
	.avm_local_bb3_st_c1_exe1_writeack(avm_local_bb3_st_c1_exe1_writeack),
	.avm_local_bb3_st_c1_exe1_writedata(avm_local_bb3_st_c1_exe1_writedata),
	.avm_local_bb3_st_c1_exe1_byteenable(avm_local_bb3_st_c1_exe1_byteenable),
	.avm_local_bb3_st_c1_exe1_burstcount(avm_local_bb3_st_c1_exe1_burstcount),
	.local_bb3_st_c1_exe1_active(bb_3_local_bb3_st_c1_exe1_active)
);


acl_loop_limiter loop_limiter_0 (
	.clock(clock),
	.resetn(resetn),
	.i_valid(bb_1_valid_out),
	.i_stall(bb_2_stall_out_1),
	.i_valid_exit(bb_2_valid_out_0),
	.i_stall_exit(bb_3_stall_out),
	.o_valid(loop_limiter_0_valid_out),
	.o_stall(loop_limiter_0_stall_out)
);

defparam loop_limiter_0.ENTRY_WIDTH = 1;
defparam loop_limiter_0.EXIT_WIDTH = 1;
defparam loop_limiter_0.THRESHOLD = 180;

fpgasort_sys_cycle_time system_cycle_time_module (
	.clock(clock),
	.resetn(resetn),
	.cur_cycle(cur_cycle)
);


assign valid_out = bb_3_valid_out;
assign output_0 = bb_3_lvb_input_acl_hw_wg_id;
assign stall_out = bb_0_stall_out;
assign writes_pending[0] = bb_3_local_bb3_st_c0_exe16_active;
assign writes_pending[1] = bb_3_local_bb3_st_c1_exe1_active;
assign lsus_active[0] = bb_2_local_bb2_ld__active;
assign lsus_active[1] = bb_2_local_bb2_ld__u1_active;
assign lsus_active[2] = bb_3_local_bb3_st_c0_exe16_active;
assign lsus_active[3] = bb_3_local_bb3_ld__active;
assign lsus_active[4] = bb_3_local_bb3_st_c1_exe1_active;

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

module fpgasort_function_wrapper
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
		input [255:0] 		avm_local_bb2_ld__u1_inst0_readdata,
		input 		avm_local_bb2_ld__u1_inst0_readdatavalid,
		input 		avm_local_bb2_ld__u1_inst0_waitrequest,
		output [29:0] 		avm_local_bb2_ld__u1_inst0_address,
		output 		avm_local_bb2_ld__u1_inst0_read,
		output 		avm_local_bb2_ld__u1_inst0_write,
		input 		avm_local_bb2_ld__u1_inst0_writeack,
		output [255:0] 		avm_local_bb2_ld__u1_inst0_writedata,
		output [31:0] 		avm_local_bb2_ld__u1_inst0_byteenable,
		output [4:0] 		avm_local_bb2_ld__u1_inst0_burstcount,
		input [255:0] 		avm_local_bb3_st_c0_exe16_inst0_readdata,
		input 		avm_local_bb3_st_c0_exe16_inst0_readdatavalid,
		input 		avm_local_bb3_st_c0_exe16_inst0_waitrequest,
		output [29:0] 		avm_local_bb3_st_c0_exe16_inst0_address,
		output 		avm_local_bb3_st_c0_exe16_inst0_read,
		output 		avm_local_bb3_st_c0_exe16_inst0_write,
		input 		avm_local_bb3_st_c0_exe16_inst0_writeack,
		output [255:0] 		avm_local_bb3_st_c0_exe16_inst0_writedata,
		output [31:0] 		avm_local_bb3_st_c0_exe16_inst0_byteenable,
		output [4:0] 		avm_local_bb3_st_c0_exe16_inst0_burstcount,
		input [255:0] 		avm_local_bb3_ld__inst0_readdata,
		input 		avm_local_bb3_ld__inst0_readdatavalid,
		input 		avm_local_bb3_ld__inst0_waitrequest,
		output [29:0] 		avm_local_bb3_ld__inst0_address,
		output 		avm_local_bb3_ld__inst0_read,
		output 		avm_local_bb3_ld__inst0_write,
		input 		avm_local_bb3_ld__inst0_writeack,
		output [255:0] 		avm_local_bb3_ld__inst0_writedata,
		output [31:0] 		avm_local_bb3_ld__inst0_byteenable,
		output [4:0] 		avm_local_bb3_ld__inst0_burstcount,
		input [255:0] 		avm_local_bb3_st_c1_exe1_inst0_readdata,
		input 		avm_local_bb3_st_c1_exe1_inst0_readdatavalid,
		input 		avm_local_bb3_st_c1_exe1_inst0_waitrequest,
		output [29:0] 		avm_local_bb3_st_c1_exe1_inst0_address,
		output 		avm_local_bb3_st_c1_exe1_inst0_read,
		output 		avm_local_bb3_st_c1_exe1_inst0_write,
		input 		avm_local_bb3_st_c1_exe1_inst0_writeack,
		output [255:0] 		avm_local_bb3_st_c1_exe1_inst0_writedata,
		output [31:0] 		avm_local_bb3_st_c1_exe1_inst0_byteenable,
		output [4:0] 		avm_local_bb3_st_c1_exe1_inst0_burstcount
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
fpgasort_function fpgasort_function_inst0 (
	.clock(clock),
	.resetn(resetn),
	.input_global_id_0(global_id[0][0]),
	.input_acl_hw_wg_id(),
	.stall_out(stall_out),
	.valid_in(valid_in),
	.output_0(),
	.valid_out(valid_out),
	.stall_in(stall_in),
	.workgroup_size(workgroup_size_NO_SHIFT_REG),
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
	.avm_local_bb2_ld__u1_readdata(avm_local_bb2_ld__u1_inst0_readdata),
	.avm_local_bb2_ld__u1_readdatavalid(avm_local_bb2_ld__u1_inst0_readdatavalid),
	.avm_local_bb2_ld__u1_waitrequest(avm_local_bb2_ld__u1_inst0_waitrequest),
	.avm_local_bb2_ld__u1_address(avm_local_bb2_ld__u1_inst0_address),
	.avm_local_bb2_ld__u1_read(avm_local_bb2_ld__u1_inst0_read),
	.avm_local_bb2_ld__u1_write(avm_local_bb2_ld__u1_inst0_write),
	.avm_local_bb2_ld__u1_writeack(avm_local_bb2_ld__u1_inst0_writeack),
	.avm_local_bb2_ld__u1_writedata(avm_local_bb2_ld__u1_inst0_writedata),
	.avm_local_bb2_ld__u1_byteenable(avm_local_bb2_ld__u1_inst0_byteenable),
	.avm_local_bb2_ld__u1_burstcount(avm_local_bb2_ld__u1_inst0_burstcount),
	.avm_local_bb3_st_c0_exe16_readdata(avm_local_bb3_st_c0_exe16_inst0_readdata),
	.avm_local_bb3_st_c0_exe16_readdatavalid(avm_local_bb3_st_c0_exe16_inst0_readdatavalid),
	.avm_local_bb3_st_c0_exe16_waitrequest(avm_local_bb3_st_c0_exe16_inst0_waitrequest),
	.avm_local_bb3_st_c0_exe16_address(avm_local_bb3_st_c0_exe16_inst0_address),
	.avm_local_bb3_st_c0_exe16_read(avm_local_bb3_st_c0_exe16_inst0_read),
	.avm_local_bb3_st_c0_exe16_write(avm_local_bb3_st_c0_exe16_inst0_write),
	.avm_local_bb3_st_c0_exe16_writeack(avm_local_bb3_st_c0_exe16_inst0_writeack),
	.avm_local_bb3_st_c0_exe16_writedata(avm_local_bb3_st_c0_exe16_inst0_writedata),
	.avm_local_bb3_st_c0_exe16_byteenable(avm_local_bb3_st_c0_exe16_inst0_byteenable),
	.avm_local_bb3_st_c0_exe16_burstcount(avm_local_bb3_st_c0_exe16_inst0_burstcount),
	.avm_local_bb3_ld__readdata(avm_local_bb3_ld__inst0_readdata),
	.avm_local_bb3_ld__readdatavalid(avm_local_bb3_ld__inst0_readdatavalid),
	.avm_local_bb3_ld__waitrequest(avm_local_bb3_ld__inst0_waitrequest),
	.avm_local_bb3_ld__address(avm_local_bb3_ld__inst0_address),
	.avm_local_bb3_ld__read(avm_local_bb3_ld__inst0_read),
	.avm_local_bb3_ld__write(avm_local_bb3_ld__inst0_write),
	.avm_local_bb3_ld__writeack(avm_local_bb3_ld__inst0_writeack),
	.avm_local_bb3_ld__writedata(avm_local_bb3_ld__inst0_writedata),
	.avm_local_bb3_ld__byteenable(avm_local_bb3_ld__inst0_byteenable),
	.avm_local_bb3_ld__burstcount(avm_local_bb3_ld__inst0_burstcount),
	.avm_local_bb3_st_c1_exe1_readdata(avm_local_bb3_st_c1_exe1_inst0_readdata),
	.avm_local_bb3_st_c1_exe1_readdatavalid(avm_local_bb3_st_c1_exe1_inst0_readdatavalid),
	.avm_local_bb3_st_c1_exe1_waitrequest(avm_local_bb3_st_c1_exe1_inst0_waitrequest),
	.avm_local_bb3_st_c1_exe1_address(avm_local_bb3_st_c1_exe1_inst0_address),
	.avm_local_bb3_st_c1_exe1_read(avm_local_bb3_st_c1_exe1_inst0_read),
	.avm_local_bb3_st_c1_exe1_write(avm_local_bb3_st_c1_exe1_inst0_write),
	.avm_local_bb3_st_c1_exe1_writeack(avm_local_bb3_st_c1_exe1_inst0_writeack),
	.avm_local_bb3_st_c1_exe1_writedata(avm_local_bb3_st_c1_exe1_inst0_writedata),
	.avm_local_bb3_st_c1_exe1_byteenable(avm_local_bb3_st_c1_exe1_inst0_byteenable),
	.avm_local_bb3_st_c1_exe1_burstcount(avm_local_bb3_st_c1_exe1_inst0_burstcount),
	.start(start_out),
	.input_N(kernel_arguments_NO_SHIFT_REG[287:256]),
	.clock2x(clock2x),
	.input_a(kernel_arguments_NO_SHIFT_REG[63:0]),
	.input_p(kernel_arguments_NO_SHIFT_REG[127:64]),
	.input_output(kernel_arguments_NO_SHIFT_REG[191:128]),
	.input_error(kernel_arguments_NO_SHIFT_REG[255:192]),
	.has_a_write_pending(has_a_write_pending),
	.has_a_lsu_active(has_a_lsu_active)
);



endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module fpgasort_sys_cycle_time
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

