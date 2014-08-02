module full_enigma_tb;
  
logic       clk_i;

logic       rst_i;
logic [3:0] symb_numb;
//logic [5:0] output_s;    //receiving encoded symbol from enigma
//logic [5:0] input_s;     //generatin incoming symbol for enigma


//default RAM ports
logic       dr_we_i;
logic [5:0] dr_data_i;
logic [3:0] dr_addr_i;
logic [5:0] dr_data_o;

logic [5:0] trans;

//clock
initial                               
  begin
    clk_i = 1'b0;
    forever
      begin
        #10.0 clk_i = ~clk_i;
      end
  end
  
//reset  
initial                               
  begin
    rst_i = 1'b0;
    #10;
    rst_i = 1'b1;
  end

//symbols' number
initial
  begin
    symb_numb = 4'd2;
  end

//------------default RAM signal definition  
//"writing is enable" signal
initial
  begin
    #20;
    @(posedge clk_i);
    dr_we_i = 1'b1;
    #20;
    @(posedge clk_i);
    dr_we_i = 1'b0;
    #80;
    @(posedge clk_i);
    dr_we_i = 1'b1;
    #20;
    @(posedge clk_i);
    dr_we_i = 1'b0;
    #80;
    @(posedge clk_i);
    dr_we_i = 1'b1;
    #20;
    @(posedge clk_i);
    dr_we_i = 1'b0;
  end
  
//incoming data definition
initial
  begin
    #20;
    @(posedge clk_i);
    dr_data_i = 6'd1;
    #20;
    @(posedge clk_i);
    dr_data_i = 6'd0;
    #80;
    @(posedge clk_i);
    dr_data_i = 6'd2;
    #20;
    @(posedge clk_i);
    dr_data_i = 6'd0;
    #80;
    @(posedge clk_i);
    dr_data_i = 6'd3;
    #20;
    @(posedge clk_i);
    dr_data_i = 6'd0;
  end  
  
//address definition
initial
  begin
    #20;
    @(posedge clk_i);
    dr_addr_i = 6'd0;
    #20;
    @(posedge clk_i);
    dr_addr_i = 6'bX;
    #80;
    @(posedge clk_i);
    dr_addr_i = 6'd1;
    #20;
    @(posedge clk_i);
    dr_addr_i = 6'bX;
    #80;
    @(posedge clk_i);
    dr_addr_i = 6'd2;
    #20;
    @(posedge clk_i);
    dr_addr_i = 6'bX;
  end  

enigma_wrapper ew(
.clk_i         (clk_i),

.rst_i         (rst_i),

.symb_numb     (symb_numb),
.input_s       (trans),

.dr_we_i       (dr_we_i),
.dr_data_i     (dr_data_i),
.dr_addr_i     (dr_addr_i),
.dr_data_o     (dr_data_o)
);

enigma_1 eg(
.clk_i          (clk_i),
.rst_i          (rst_i),
.in_symb_i      (trans),

.out_symb_o     (out_symb_o)
);

endmodule
