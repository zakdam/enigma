module enigma_wrapper

(
input logic               clk_i,
input logic               rst_i,
input logic         [3:0] symb_numb,
input logic  signed [5:0] output_s,    //receiving encoded symbol from enigma
output logic signed [5:0] input_s,     //generatin incoming symbol for enigma

//default RAM ports
input logic               dr_we_i,     //write enable signal
input logic  signed [5:0] dr_data_i,   //data input
input logic         [3:0] dr_addr_i,   //incoming address
output logic signed [5:0] dr_data_o,   //data output

//final RAM ports
output logic signed [5:0] fr_data_o   //data output
);

logic [3:0] cnt;

logic [5:0] dr_ram [7:0];
logic [3:0] dr_addr_reg;

logic [5:0] fr_ram [7:0];
logic [3:0] fr_addr_reg;
logic       fr_we_i;     //write enable signal
logic [3:0] fr_addr_i;

//input symbol block
always_ff @ (posedge clk_i or negedge rst_i)
begin
  if ( !rst_i )
    input_s <= 0;
  if ( (dr_data_o > 0) && (dr_data_o < 27) )
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

//final RAM "write is enable signal"
always_ff @ (posedge clk_i or negedge rst_i)
begin
  if ( !rst_i )
    fr_we_i <= 0;
  if ( (dr_data_o > 0) && (dr_data_o < 27) )
    begin
      if ( cnt < symb_numb )
        fr_we_i <= 1;
      else
        fr_we_i <= 0;
    end
end

//final RAM address
always_ff @ (posedge clk_i or negedge rst_i)
begin
  if ( !rst_i )
    fr_addr_i <= 0;
  else if (cnt > symb_numb)
    fr_addr_i <= 0;
  else if ( (dr_data_o > 0) && (dr_data_o < 27) )
    begin
      if ( cnt < symb_numb )
        fr_addr_i <= fr_addr_i + 1;
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

//---------------final RAM----------------
always_ff @ (posedge clk_i)
begin
  if ( fr_we_i )
    fr_ram[fr_addr_i] <= output_s;
  fr_addr_reg <= fr_addr_i;
end

assign fr_data_o = fr_ram[fr_addr_reg];

endmodule
