module wrapper
  
(
  input                     clk_i,
  input                     rst_i,

  input                     symb_val_i,
  input               [7:0] symb_numb_i,           // number of symbols that will be encoded
  input               [6:0] wrap_i,                // wrapper input 
  input        signed [6:0] out_en_i,              // receiving encoded symbol from enigma
  input                     encod_val_i,           // incoming encoded symbols are valid

  output logic signed [6:0] wrap_o,                // wrapper output
  output logic              wrap_val_o,            // wrapper output is valid
  output logic signed [6:0] in_en_o,               // generating incoming symbol for enigma
  output logic              err_symb_o,            // if incoming symbol is wrong
  output logic              en_val_o               // incoming symbol for enigma is valid
);

// input memory variables and buses
logic [6:0]  in_mem [127:0];                       // input memory array
logic [63:0] in_mem_wr_addr;                       // used for writing input memory
logic        in_mem_wr_en;                         // "writing is enable" signal
logic [63:0] in_mem_rd_addr;
logic        in_mem_rd_en;

// output memory variables and buses
logic [6:0]  out_mem [127:0];                      // output memory array 
logic [63:0] out_mem_wr_addr;                      // writing address
logic        out_mem_wr_en;                        // "writing is enable"
logic [63:0] out_mem_rd_addr;                      // reading address
logic        out_mem_rd_en;

logic [2:1]  encod_val_d;

// incoming symbol is wrong signal
always_comb
  begin
    if( ( symb_val_i ) && ( ( wrap_i > 0 ) && ( wrap_i < 27 ) ) )
      err_symb_o = 1'b0;
    else
      if( ( symb_val_i ) && !( ( wrap_i > 0 ) && ( wrap_i < 27 ) ) )
        err_symb_o = 1'b1;
    else
      err_symb_o = 1'b0;
  end

// INPUT MEMORY BLOCKS 
// input memory
always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( in_mem_wr_en )
      in_mem[in_mem_wr_addr] <= wrap_i;
  end

// counter for writing in the input memory (generates addresses)
always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      in_mem_wr_addr <= 0;
    else 
      if( ( symb_val_i == 1'b1 ) && ( ( wrap_i > 0 ) && ( wrap_i < 27 ) ) )
        in_mem_wr_addr <= in_mem_wr_addr + 1;
  end

// "writing is enable" signal
always_comb
  begin
    if( ( symb_val_i == 1'b1 ) && ( ( wrap_i > 0 ) && ( wrap_i < 27 ) ) )
      in_mem_wr_en = 1;
    else
      in_mem_wr_en = 0; 
  end

// "reading is enable" signal
always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      begin
        in_mem_rd_en <= 0;
      end
    else 
      if( ( in_mem_wr_addr == ( symb_numb_i + 1 ) ) && ( in_mem_rd_addr < symb_numb_i ) )	
        begin
          in_mem_rd_en <= 1; 
        end
    else
        in_mem_rd_en <= 0;
  end

// special counter for reading from input memory (generating addresses)
always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      in_mem_rd_addr <= 0;
    else 
      if( in_mem_rd_en )
        in_mem_rd_addr <= in_mem_rd_addr + 1;
  end

// generating incoming symbol for enigma
always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      in_en_o <= 0;
    else 
      if( in_mem_rd_en )
        in_en_o <= in_mem[in_mem_rd_addr];
    else 
      in_en_o <= 0;                  
  end

// incoming symbol for enigma is valid
always_comb
  begin
    if( ( in_mem_rd_en ) && ( in_en_o != 0 ) )
      en_val_o = 1'b1;
    else 
      en_val_o = 1'b0;
  end


// OUTPUT MEMORY BLOCKS-------------------------------------------
// output memory
always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( out_mem_wr_en )
      begin
        out_mem[out_mem_wr_addr] <= out_en_i;                            
      end
  end

// counter for writing in the output memory (generates addresses)
always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      out_mem_wr_addr <= 0;
    else 
      if( ( out_mem_wr_en ) && ( out_mem_wr_addr < symb_numb_i ) )
        out_mem_wr_addr <= out_mem_wr_addr + 1;
  end

// output memory reading address
always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      out_mem_rd_addr <= 0;
    else
      out_mem_rd_addr <= out_mem_wr_addr;
  end

assign out_mem_wr_en = encod_val_i;

// "reading is enable" signal
always_ff @( posedge clk_i )
  begin
    if( ( out_mem_wr_en ) && ( out_mem_wr_addr < symb_numb_i ) )
      out_mem_rd_en <= 1;
    else 
      out_mem_rd_en <= 0; 
  end

// generating outcoming symbols "wrapper output"
always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      wrap_o <= 0;
    else 
      if( out_mem_rd_en )
        wrap_o <= out_mem[out_mem_rd_addr];
    else
      wrap_o <= 0;                  
  end

// delaying valid signal for top
always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      encod_val_d <= 2'b0;
    else
      begin
        encod_val_d[1] <= encod_val_i;
        encod_val_d[2] <= encod_val_d[1];
      end
  end

assign wrap_val_o = encod_val_i_d[2];

endmodule
