module enigma_top

(
  input  logic              clk_i,
  input  logic              rst_i,
  input  logic              symb_val_i,
  input  logic              rrs_rst_i,
  input  logic        [7:0] symb_numb_i,
  input  logic signed [6:0] symbol_i,

  output logic              symb_val_o,
  output logic signed [6:0] symbol_o        
);

//transit ports
logic signed [6:0] trans1;         //transit between in_symb_i and in_en_o
logic signed [6:0] trans2;         //transit between out_symb_o and out_en_i
logic              trans3;         //transit between en_val_o and en_val_i
logic              trans4;         //transit between encod_val_o and encod_val_i

//portmap for wrapper
wrapper wr(
  .clk_i          ( clk_i         ),
  .rst_i          ( rst_i         ),
  .symb_val_i     ( symb_val_i    ),
  .symb_numb_i    ( symb_numb_i   ),
  .wrap_i         ( symbol_i      ),
  .out_en_i       ( trans2        ),
  .encod_val_i    ( trans4        ),

  .wrap_o         ( symbol_o      ),
  .wrap_val_o     ( symb_val_o    ),
  .in_en_o        ( trans1        ),
  .wrg_symb_o     ( wrg_symb_o    ),
  .en_val_o       ( trans3        )
);

//portmap for enigma_1
enigma_1 en(
  .clk_i          ( clk_i         ),
  .rst_i          ( rst_i         ),
  .en_val_i       ( trans3        ),
  .rrs_rst_i      ( rrs_rst_i     ),
  .in_symb_i      ( trans1        ),

  .out_symb_o     ( trans2        ),
  .encod_val_o    ( trans4        )
);

endmodule
