module enigma_top

(
  input                     clk_i,
  input                     rst_i,
  input                     rotors_rst_i,

  input               [7:0] symb_numb_i,

  input                     symb_val_i,
  input        signed [6:0] symbol_i,

  output logic              symb_val_o,
  output logic signed [6:0] symbol_o        
);

// transit ports
logic signed [6:0] noncod_symb_trans;       // non-coded symbol transit between in_symb_i and in_en_o
logic signed [6:0] cod_symb_trans;          // coded symbol transit between out_symb_o and out_en_i
logic              noncod_val_trans;        // non-coded symbol validity transit between en_val_o and en_val_i
logic              cod_val_trans;           // coded symbol validity transit between encod_val_o and encod_val_i

// transit ports to connect enigma_1 and rotors
logic      [6:0] r1_trans;
logic [5:1][6:0] r1_trans_d;

logic      [6:0] r2_trans;
logic [4:1][6:0] r2_trans_d;

logic      [6:0] r3_trans;
logic [3:1][6:0] r3_trans_d;


// portmap for wrapper
wrapper wr(
  .clk_i          ( clk_i             ),
  .rst_i          ( rst_i             ),
  .symb_val_i     ( symb_val_i        ),
  .symb_numb_i    ( symb_numb_i       ),
  .wrap_i         ( symbol_i          ),
  .out_en_i       ( cod_symb_trans    ),
  .encod_val_i    ( cod_val_trans     ),

  .wrap_o         ( symbol_o          ),
  .wrap_val_o     ( symb_val_o        ),
  .in_en_o        ( noncod_symb_trans ),
  .wrg_symb_o     ( wrg_symb_o        ),
  .en_val_o       ( noncod_val_trans  )
);


// portmap for enigma_1
enigma_1 en(
  .clk_i          ( clk_i             ),
  .rst_i          ( rst_i             ),
  .en_val_i       ( noncod_val_trans  ),
  .rotors_rst_i   ( rotors_rst_i      ),
  .in_symb_i      ( noncod_symb_trans ),
  
  .r1_i           ( r1_trans          ),
  .r1_d_i         ( r1_trans_d        ),
  .r2_i           ( r2_trans          ),
  .r2_d_i         ( r2_trans_d        ),
  .r3_i           ( r3_trans          ),
  .r3_d_i         ( r3_trans_d        ),

  .out_symb_o     ( cod_symb_trans    ),
  .encod_val_o    ( cod_val_trans     )
);


// portmap for rotors
rotors rs(
  .clk_i          ( clk_i        ),
  .rst_i          ( rst_i        ),
  .rotors_rst_i   ( rotors_rst_i ),
  .in_symb_val_i  ( symb_val_i   ),

  .r1_o           ( r1_trans     ),
  .r1_d_o         ( r1_trans_d   ),
  .r2_o           ( r2_trans     ),
  .r2_d_o         ( r2_trans_d   ),
  .r3_o           ( r3_trans     ),
  .r3_d_o         ( r3_trans_d   )
);


endmodule
