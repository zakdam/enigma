module rotors
#(
  parameter R1_INIT_VALUE  = 1,
  parameter R2_INIT_VALUE  = 1,
  parameter R3_INIT_VALUE  = 1,

  parameter LETTERS = 26
)

(
  input              clk_i,               // synchrosignal
  input              rst_i,               // asynchronous reset
  input              rotors_rst_i,        // only rotors reset

  input              in_symb_val_i,       // incoming symbol is valid

  // rotors states (rX_s) and delayed states (rX_s_d)
  output logic      [6:0] r1_o,
  output logic [5:1][6:0] r1_d_o,

  output logic      [6:0] r2_o,
  output logic [4:1][6:0] r2_d_o,
 
  output logic      [6:0] r3_o,
  output logic [3:1][6:0] r3_d_o
);


// ROTOR I BLOCK
// r1_o - rotor definition (counter)
always_ff @( posedge clk_i/* or posedge rst_i or posedge rotors_rst_i*/ )   
  begin
    if( rst_i )                               // synchro reset (здесь и далее пункт 6)
      r1_o <= R1_INIT_VALUE;
    else
      if( rotors_rst_i )
        r1_o <= R1_INIT_VALUE;
    else 
      if( r1_o == LETTERS )
        r1_o <= 7'd1;
    else
      if( in_symb_val_i ) 
        r1_o <= r1_o + 7'd1;
  end

// r1_d_o delayed for N strokes
always_ff @( posedge clk_i )
  begin
    r1_d_o[1] <= r1_o;
    r1_d_o[2] <= r1_d_o[1];  
    r1_d_o[3] <= r1_d_o[2];
    r1_d_o[4] <= r1_d_o[3];
    r1_d_o[5] <= r1_d_o[4];
  end


// ROTOR II BLOCK
// r2_o - rotor definition (counter)
always_ff @( posedge clk_i/* or posedge rst_i or posedge rotors_rst_i*/ )
  begin
    if( rst_i )                               // synchro reset
      r2_o <= R2_INIT_VALUE;
    else 
      if( rotors_rst_i )
        r2_o <= R2_INIT_VALUE;
    else 
      if( r2_o == LETTERS )
        r2_o <= 7'd1;
    else 
      if( r1_o == LETTERS )
        r2_o <= r2_o + 7'd1;
  end

// r2_d_o delayed for N strokes
always_ff @( posedge clk_i )
  begin
    r2_d_o[1] <= r2_o;
    r2_d_o[2] <= r2_d_o[1];
    r2_d_o[3] <= r2_d_o[2];
    r2_d_o[4] <= r2_d_o[3];
  end


// ROTOR III BLOCK
// r3_o - rotor definition (counter)
always_ff @( posedge clk_i/* or posedge rst_i or posedge rotors_rst_i*/ )
  begin
    if( rst_i )                               // synchro reset
      r3_o <= R3_INIT_VALUE;
    else 
      if( rotors_rst_i )
        r3_o <= R3_INIT_VALUE;
    else 
      if( r3_o == LETTERS )
        r3_o <= 7'd1;
    else 
      if( r3_o == LETTERS )
        r3_o <= r3_o + 7'd1;
  end

// r3_d_o delayed for N strokes
always_ff @( posedge clk_i )
  begin
    r3_d_o[1] <= r3_o;
    r3_d_o[2] <= r3_d_o[1];
    r3_d_o[3] <= r3_d_o[2];
  end


endmodule
