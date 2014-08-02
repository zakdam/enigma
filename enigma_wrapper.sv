module enigma_wrapper

(
input logic        clk_i,
input logic        rst_i,
input logic  [3:0] symb_numb,
//input logic  [5:0] output_s,    //receiving encoded symbol from enigma
output logic [5:0] input_s,      //generatin incoming symbol for enigma

//default RAM ports
input logic        dr_we_i,   //write enable signal
input logic  [5:0] dr_data_i, //data input
input logic  [3:0] dr_addr_i, //incoming address
output logic [5:0] dr_data_o  //data output
);

logic [3:0] cnt;

logic [5:0] dr_ram [7:0];
logic [3:0] dr_addr_reg;

//input symbol definition block
always_ff @ (posedge clk_i or negedge rst_i)
begin
  if ( !rst_i )
    input_s <= 0;
  if ( ( dr_data_o > 0 ) && (dr_data_o < 27) )
    begin
      if ( cnt < symb_numb )
        input_s <= dr_data_o;
    end
  else 
    input_s <= 0;
end

//counter block
always_ff @ (posedge clk_i or negedge rst_i)
begin
  if ( !rst_i )
    cnt <= 0;
  else
    begin
      if ( (dr_data_o > 0) && (dr_data_o < 27) )
        cnt <= cnt + 1;
    end
end


//---------------default RAM--------------

always_ff @ (posedge clk_i)
begin
  if ( dr_we_i )
    dr_ram[dr_addr_i] <= dr_data_i;
  dr_addr_reg <= dr_addr_i;
end

assign dr_data_o = dr_ram[dr_addr_reg];

endmodule
