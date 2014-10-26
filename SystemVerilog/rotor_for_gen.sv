module rotor_for_gen
#(
  parameter R_INIT_VALUE = 1,
  parameter LETTERS      = 26,

  parameter DEL_STR_NUM  = 5             // переопределяемая в generate
)

(
  input              clk_i,               // synchrosignal
  input              rst_i,               // asynchronous reset
  input              rotors_rst_i,        // only rotors reset
  input        [6:0] r_p_i,               // previous rotors definitions

  input              in_symb_val_i,       // incoming symbol is valid

  // rotor states (r_s) and delayed states (r_s_d)
  output logic      [6:0]                      r_o,
  output logic      [(6 - DEL_STR_NUM ):1][6:0] r_d_o
);
  
  
// r_o - rotor definition (counter)
always_ff @( posedge clk_i )   
  begin
    if( rst_i )
      r_o <= R_INIT_VALUE;
    else
      if( rotors_rst_i )
        r_o <= R_INIT_VALUE;
      else 
        if( r_o == LETTERS )
          r_o <= 7'd1;
        else
          if( ( ( DEL_STR_NUM + 2 ) == 3 ) && in_symb_val_i ) 
            r_o <= r_o + 7'd1;
          else
            if( ( ( DEL_STR_NUM + 2 ) == 4 ) && ( r_p_i == LETTERS ) )
              r_o <= r_o + 7'd1;
            else
              if( ( ( DEL_STR_NUM + 2 ) == 5 ) && ( r_p_i == LETTERS ) )
                r_o <= r_o + 7'd1;
  end

// r_d_o delayed for DEL_STR_NUM strokes
always_ff @( posedge clk_i )
  begin
    r_d_o[1] <= r_o;
    for ( int i = 2; i < ( 7 - DEL_STR_NUM ); i = i + 1 )
      begin
        r_d_o[i] <= r_d_o[i-1];
      end
  end


endmodule
