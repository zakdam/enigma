module full_enigma_tb;
  
logic       clk_i;

logic       rst_i;
logic [3:0] symb_numb;
//logic [5:0] output_s;    //receiving encoded symbol from enigma
//logic [5:0] input_s;     //generatin incoming symbol for enigma
//logic [5:0] out_symb_o;

//default RAM ports
logic       dr_we_i;
logic [5:0] dr_data_i;
logic [3:0] dr_addr_i;
logic [5:0] dr_data_o;

//final RAM ports
logic [5:0] fr_data_o;

logic [5:0] trans1;        //transition between input_s and in_symb_i
logic [5:0] trans2;        //transition between output_s and out_symb_o

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
    symb_numb = 4'd6;
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
    #80;
    
  end
  
//incoming data definition
initial
  begin
    #20;
    
    //E
    @(posedge clk_i);
    dr_data_i = 6'd5;
    #20;
    @(posedge clk_i);
    dr_data_i = 6'd0;
    #80;
    
    //N
    @(posedge clk_i);
    dr_data_i = 6'd14;
    #20;
    @(posedge clk_i);
    dr_data_i = 6'd0;
    #80;
    
    //I
    @(posedge clk_i);
    dr_data_i = 6'd9;
    #20;
    @(posedge clk_i);
    dr_data_i = 6'd0;
    #80;
    
    //G
    @(posedge clk_i);
    dr_data_i = 6'd7;
    #20;
    @(posedge clk_i);
    dr_data_i = 6'd0;
    #80;
    
    //M
    @(posedge clk_i);
    dr_data_i = 6'd13;
    #20;
    @(posedge clk_i);
    dr_data_i = 6'd0;
    #80;
    
    //A
    @(posedge clk_i);
    dr_data_i = 6'd1;
    #20;
    @(posedge clk_i);
    dr_data_i = 6'd0;
    #80;
    
    //Q
    @(posedge clk_i);
    dr_data_i = 6'd17;
    #20;
    @(posedge clk_i);
    dr_data_i = 6'd0;
    #80;
    
    //W
    @(posedge clk_i);
    dr_data_i = 6'd23;
    #20;
    @(posedge clk_i);
    dr_data_i = 6'd0;
    #80;
    
    //E
    @(posedge clk_i);
    dr_data_i = 6'd5;
    #20;
    @(posedge clk_i);
    dr_data_i = 6'd0;
    #80;
    
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
    #80;
    
    @(posedge clk_i);
    dr_addr_i = 6'd3;
    #20;
    @(posedge clk_i);
    dr_addr_i = 6'bX;
    #80;
    
    @(posedge clk_i);
    dr_addr_i = 6'd4;
    #20;
    @(posedge clk_i);
    dr_addr_i = 6'bX;
    #80;
    
    @(posedge clk_i);
    dr_addr_i = 6'd5;
    #20;
    @(posedge clk_i);
    dr_addr_i = 6'bX;
    #80;
    
    @(posedge clk_i);
    dr_addr_i = 6'd6;
    #20;
    @(posedge clk_i);
    dr_addr_i = 6'bX;
    #80;
    
    @(posedge clk_i);
    dr_addr_i = 6'd7;
    #20;
    @(posedge clk_i);
    dr_addr_i = 6'bX;
    #80;
    
    @(posedge clk_i);
    dr_addr_i = 6'd8;
    #20;
    @(posedge clk_i);
    dr_addr_i = 6'bX;
    #80;
    
  end  

enigma_wrapper ew(
.clk_i         (clk_i),
.rst_i         (rst_i),
.symb_numb     (symb_numb),
.input_s       (trans1),
.output_s      (trans2),
.dr_we_i       (dr_we_i),
.dr_data_i     (dr_data_i),
.dr_addr_i     (dr_addr_i),
.dr_data_o     (dr_data_o),
.fr_data_o     (fr_data_o)
);

enigma_1 eg(
.clk_i          (clk_i),
.rst_i          (rst_i),
.in_symb_i      (trans1),

.out_symb_o     (trans2)
);

endmodule
