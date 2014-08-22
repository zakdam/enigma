module wrapper
  
(
input logic               clk_i,
input logic               rst_i,
input logic         [7:0] symb_numb_i,    //number of symbols that will be encoded
input logic         [6:0] wrap_i,         //wrapper input 
input logic  signed [6:0] out_en_i,       //receiving encoded symbol from enigma

output logic signed [6:0] wrap_o,         //wrapper output
output logic signed [6:0] in_en_o         //generating incoming symbol for enigma
);

//input memory variables and buses
logic[6:0]in_mem[127:0];          //input memory array

logic [63:0] im_wr_ad;            //used for writing input memory
logic        im_wr_en;		          //"writing is enable" signal
logic [1:0]  im_rd_en_cnt;
logic        im_rd_en;
logic [63:0] im_rd_ad;


//output memory variables and buses
logic[6:0]out_mem[127:0];        //output memory array 
logic [63:0] om_wr_ad;		         //writing address
logic	     om_wr_en;	           	//"writing is enable"
logic [1:0]  om_wr_en_cnt;	      //special small counter for writing 
logic 	     om_rd_en;
logic [63:0] om_rd_ad;		         //reading address



//INPUT MEMORY BLOCKS-------------------------------------------------- 
//input memory
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( im_wr_en )
    in_mem[im_wr_ad] <= wrap_i;         	      
end

//counter for writing in the input memory (generates addresses)
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( !rst_i )
    im_wr_ad <= 0;
  else if ( (wrap_i > 0) && (wrap_i < 27) )
    im_wr_ad <= im_wr_ad + 1;
end

//"writing is enable" signal
always_comb
begin
  if ( (wrap_i > 0) && (wrap_i < 27) )
    im_wr_en = 1;
  else
    im_wr_en = 0; 
end

//special small counter for "reading is enable" signal
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( !rst_i )
    im_rd_en_cnt <= 2'b00;
  else if ( (im_wr_ad == (symb_numb_i + 1)) && (im_rd_ad < symb_numb_i) )	
    im_rd_en_cnt <= im_rd_en_cnt + 1;
end

//"reading is enable" signal		
always_comb
begin
  if ( im_rd_en_cnt == 2'b11 )
    im_rd_en = 1;
  else
    im_rd_en = 0;    
end

//special counter for reading from input memory (generating addresses)
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( !rst_i )
    im_rd_ad <= 0;
  else if ( im_wr_ad == (symb_numb_i + 1) && (im_rd_en_cnt == 2'b11) && ( im_rd_ad < symb_numb_i ) )
    im_rd_ad <= im_rd_ad + 1;
end

//generating incoming symbol for enigma
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( !rst_i )
    in_en_o <= 0;
  else if ( im_rd_en )
    in_en_o <= in_mem[im_rd_ad];
  else 
    in_en_o <= 0;                  
end


//OUTPUT MEMORY BLOCKS-------------------------------------------
//output memory
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( om_wr_en )
    begin
      out_mem[om_wr_ad] <= out_en_i;                            
    end
end

//counter for writing in the output memory (generates addresses)
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( !rst_i )
    om_wr_ad <= 0;
  else if ( (om_wr_en) && (om_wr_ad < symb_numb_i) )
    om_wr_ad <= om_wr_ad + 1;
end

//output memory reading address
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( !rst_i )
    om_rd_ad <= 0;
  else
    om_rd_ad <= om_wr_ad;
end

//special small counter for writing
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( !rst_i )
    om_wr_en_cnt <= 2'b00;
  else if ( (out_en_i > 0) && (out_en_i < 27) && (om_wr_ad < symb_numb_i) )
    om_wr_en_cnt <=  om_wr_en_cnt + 1;
end

//"writing is enable" signal
always_comb
begin
  if ( (om_wr_en_cnt == 2'b00) && ((out_en_i > 0) && (out_en_i < 27)) && (om_wr_ad < symb_numb_i) )
    om_wr_en = 1;
  else
    om_wr_en = 0; 
end

//"reading is enable" signal
always_ff @ ( posedge clk_i )
begin
  if ( (om_wr_en) && (om_wr_ad < symb_numb_i) )
    om_rd_en <= 1;
  else 
    om_rd_en <= 0; 
end

//generating outcoming symbols "wrapper output"
always_ff @ ( posedge clk_i or negedge rst_i )
begin
  if ( !rst_i )
    wrap_o <= 0;
  else if ( om_rd_en )
    wrap_o <= out_mem[om_rd_ad];
  else
    wrap_o <= 0;                  
end


endmodule
