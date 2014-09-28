module wrapper
  
(
  input  logic              clk_i,
  input  logic              rst_i,
  input  logic              symb_val_i,
  input  logic        [7:0] symb_numb_i,           //number of symbols that will be encoded
  input  logic        [6:0] wrap_i,                //wrapper input 
  input  logic signed [6:0] out_en_i,              //receiving encoded symbol from enigma
  input  logic              encod_val_i,           //incoming encoded symbols are valid

  output logic signed [6:0] wrap_o,                //wrapper output
  output logic              wrap_val_o,            //wrapper output is valid
  output logic signed [6:0] in_en_o,               //generating incoming symbol for enigma
  output logic              wrg_symb_o,            //if incoming symbol is wrong
  output logic              en_val_o               //incoming symbol for enigma is valid
);

//input memory variables and buses
  logic [6:0]  in_mem [127:0];                      //input memory array
  logic [63:0] im_wr_ad;                            //used for writing input memory
  logic        im_wr_en;                            //"writing is enable" signal
  logic        im_rd_en;
  logic [63:0] im_rd_ad;


//output memory variables and buses
  logic [6:0]  out_mem [127:0];                     //output memory array 
  logic [63:0] om_wr_ad;                            //writing address
  logic        om_wr_en;                            //"writing is enable"
  logic        om_rd_en;
  logic [63:0] om_rd_ad;                            //reading address

  logic [1:0]  encod_val_i_d;

//incoming symbol is wrong signal
always_comb
  begin
    if ( ( symb_val_i == 1'b1 ) && ( ( wrap_i > 0 ) && ( wrap_i < 27 ) ) )
      wrg_symb_o = 1'b0;
    else if ( ( symb_val_i == 1'b1 ) && !( ( wrap_i > 0 ) && ( wrap_i < 27 ) ) )
      wrg_symb_o = 1'b1;
    else
      wrg_symb_o = 1'b0;
  end

//INPUT MEMORY BLOCKS-------------------------------------------------- 
//input memory
always_ff @( posedge clk_i or negedge rst_i )
  begin
    if ( im_wr_en )
      in_mem[im_wr_ad] <= wrap_i;
  end

//counter for writing in the input memory (generates addresses)
always_ff @( posedge clk_i or negedge rst_i )
  begin
    if ( !rst_i )
      im_wr_ad <= 0;
    else if ( ( symb_val_i == 1'b1 ) && ( ( wrap_i > 0 ) && ( wrap_i < 27 ) ) )
      im_wr_ad <= im_wr_ad + 1;
  end

//"writing is enable" signal
always_comb
  begin
    if ( ( symb_val_i == 1'b1 ) && ( ( wrap_i > 0 ) && ( wrap_i < 27 ) ) )
      im_wr_en = 1;
    else
      im_wr_en = 0; 
  end

//"reading is enable" signal
always_ff @( posedge clk_i or negedge rst_i )
  begin
    if ( !rst_i )
      begin
        im_rd_en <= 0;
      end
    else if ( ( im_wr_ad == ( symb_numb_i + 1 ) ) && ( im_rd_ad < symb_numb_i ) )	
      begin
        im_rd_en <= 1; 
      end
    else
        im_rd_en <= 0;
  end

//special counter for reading from input memory (generating addresses)
always_ff @( posedge clk_i or negedge rst_i )
  begin
    if ( !rst_i )
      im_rd_ad <= 0;
    else if ( im_rd_en )
      im_rd_ad <= im_rd_ad + 1;
  end

//generating incoming symbol for enigma
always_ff @( posedge clk_i or negedge rst_i )
  begin
    if ( !rst_i )
      in_en_o <= 0;
    else if ( im_rd_en )
      in_en_o <= in_mem[im_rd_ad];
    else 
      in_en_o <= 0;                  
  end

//incoming symbol for enigma is valid
always_comb
  begin
    if ( ( im_rd_en ) && ( in_en_o != 0 ) )
      en_val_o = 1'b1;
    else 
      en_val_o = 1'b0;
  end


//OUTPUT MEMORY BLOCKS-------------------------------------------
//output memory
always_ff @( posedge clk_i or negedge rst_i )
  begin
    if ( om_wr_en )
      begin
        out_mem[om_wr_ad] <= out_en_i;                            
      end
  end

//counter for writing in the output memory (generates addresses)
always_ff @( posedge clk_i or negedge rst_i )
  begin
    if ( !rst_i )
      om_wr_ad <= 0;
    else if ( ( om_wr_en ) && ( om_wr_ad < symb_numb_i ) )
      om_wr_ad <= om_wr_ad + 1;
  end

//output memory reading address
always_ff @( posedge clk_i or negedge rst_i )
  begin
    if ( !rst_i )
      om_rd_ad <= 0;
    else
      om_rd_ad <= om_wr_ad;
  end

assign om_wr_en = encod_val_i;

//"reading is enable" signal
always_ff @( posedge clk_i )
  begin
    if ( ( om_wr_en ) && ( om_wr_ad < symb_numb_i ) )
      om_rd_en <= 1;
    else 
      om_rd_en <= 0; 
  end

//generating outcoming symbols "wrapper output"
always_ff @( posedge clk_i or negedge rst_i )
  begin
    if ( !rst_i )
      wrap_o <= 0;
    else if ( om_rd_en )
      wrap_o <= out_mem[om_rd_ad];
    else
      wrap_o <= 0;                  
  end

//delaying valid signal for top
always_ff @( posedge clk_i or negedge rst_i )
  begin
    if ( !rst_i )
      encod_val_i_d <= 0;
    else
      encod_val_i_d[0] <= encod_val_i;
      encod_val_i_d[1] <= encod_val_i_d[0];
  end

assign wrap_val_o = encod_val_i_d[1];

endmodule
