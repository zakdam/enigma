module wrapper
  
(
input logic               clk_i,
input logic               rst_i,
input logic         [5:0] symb_numb_i,    //number of symbols that will be encoded
input logic         [5:0] wrap_i,         //wrapper input 
input logic  signed [5:0] out_en_i,       //receiving encoded symbol from enigma

output logic signed [5:0] wrap_o,        //wrapper output
output logic signed [5:0] in_en_o        //generating incoming symbol for enigma
);

//input memory variables and buses
logic[5:0]in_mem[15:0];          //input memory array

//logic r           [4:0];       //used for reseting the memory array
logic im_wr_ad      [7:0];       //used for writing input memory
logic im_wr_en;		       //"writing is enable" signal
logic im_rd_en_cnt  [1:0];
logic im_rd_en;
logic im_rd_ad      [7:0];


/*
//output memory variables and buses
reg[5:0]out_mem[15:0];        //output memory array 
logic om_addr_reg [4:0];      //address register
logic z           [4:0];      //used for "zeroing" the memory array
logic p           [4:0];      //used for "putting" to output memory
*/


//INPUT MEMORY BLOCKS-------------------------------------------------- 
//input memory
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  /*if ( !rst_i )
    for ( r; r<16; r=r+1 )
      in_mem[r] <= 6'b000000;*/
  if ( (wrap_i > 0) && (wrap_i < 27) )
 	  in_mem[im_wr_ad] <= wrap_i;                      //writing in input memory	      
end

//counter for writing in the input memory (generates addresses)
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( rst_i )
    im_wr_ad <= 0;
  else if ( (wrap_i > 0) && (wrap_i < 27) )
    im_wr_ad <= im_wr_ad + 1;
end

//"writing is enable" signal				//COMB???
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( !rst_i )
    im_wr_en <= 0;
  else if ( (wrap_i > 0) && (wrap_o < 27) )
    im_wr_en <= 1;
  else
    im_wr_en <= 0; 
end

//special small counter for "reading is enable" signal
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( !rst_i )
    im_rd_en_cnt <= 2'b00;
  else if ( im_wr_ad == (symb_numb_i - 1) )		//flag - writing in input memory is ended, now you can read symbols to enigma
    im_rd_en_cnt <= im_rd_en_cnt + 1;
end

//"reading is enable" signal				//COMB???
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( !rst_i )
    im_rd_en <= 0;
  else if ( im_rd_en_cnt == 2'b11 )
    im_rd_en <= 1;
  else
    im_rd_en <= 0;    
end

//special counter for reading from input memory (generating addresses)
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( !rst_i )
    im_rd_ad <= 0;
  else if ( im_wr_ad == (symb_numb_i - 1) && (im_rd_en_cnt == 2'b11) )
    im_rd_ad <= im_rd_ad + 1;
end

//generating incoming symbol for enigma
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( !rst_i )
    in_en_o <= 0;
  else if ( im_rd_en )
    in_en_o <= in_mem[im_rd_ad];                    //OR ZERO IN SPACES?
end

/*
//OUTPUT MEMORY BLOCKS-------------------------------------------
//output memory
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  /*if ( !rst_i )
    for ( z; z<16; z=z+1 )
      out_mem[z] <= 6'b000000;*/
 /* if ( (out_en_i > 0) && (out_en_i < 27) )
    begin
        out_mem[p] <= out_en_i;                      //writing in output memory        
    end
end

//generating outcoming symbols "wrapper output"
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( !rst_i )
    wrap_o <= 6'b0;
  else
    wrap_o <= out_mem[om_addr_reg];                    //OR ZERO IN SPACES?
end
*/

assign wrap_o = out_en_i;

endmodule

