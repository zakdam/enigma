module enigma_1
#(
  parameter LETTERS = 26
)

(
  input              clk_i,               // synchrosignal
  input              rst_i,               // asynchronous reset
  input              rotors_rst_i,        // only rotors reset

  input        [6:0] in_symb_i,           // incoming NOT CODED letter, each letter is coded by its serial number
  input              en_val_i,            // incoming symbol is valid

  // connecting rotors signals
  input        [6:0] r1_i,
  input   [5:1][6:0] r1_d_i,

  input        [6:0] r2_i,
  input   [4:1][6:0] r2_d_i,
 
  input        [6:0] r3_i,
  input   [3:1][6:0] r3_d_i,

  output logic [6:0] out_symb_o,          // outcoming CODED letter, each letter is coded by its serial number
  output logic       encod_val_o          // outcoming encoded symbols are valid
);

logic signed [5:0][6:0] r1_acts;
logic signed [5:0][6:0] r2_acts;
logic signed [5:0][6:0] r3_acts;
logic signed [6:0]      out_presymb;
logic signed [6:0][6:0] result;           // triggers to save pipeline stages' results
logic        [6:0]      en_val_i_d;       // triggers for delaying en_val_i

logic signed [6:0] r1_array_str  [0:LETTERS] = '{ 0,2,4,6,8,10,12,3,16,18,20,24,22,26,14,25,5,9,23,7,1,11,13,21,19,17,15 };
logic signed [6:0] r1_array_back [0:LETTERS] = '{ 0,20,1,7,2,16,3,19,4,17,5,21,6,22,14,26,8,25,9,24,10,23,12,18,11,15,13 };
logic signed [6:0] r2_array_str  [0:LETTERS] = '{ 0,1,10,4,11,19,9,18,21,24,2,12,8,23,20,13,3,17,7,26,14,16,25,6,22,15,5 };
logic signed [6:0] r2_array_back [0:LETTERS] = '{ 0,1,10,16,3,26,23,18,12,6,2,4,11,15,20,25,21,17,7,5,14,8,24,13,9,22,19 };
logic signed [6:0] r3_array_str  [0:LETTERS] = '{ 0,5,11,13,6,12,7,4,17,22,26,14,20,15,23,25,8,24,21,19,16,1,9,2,18,3,10 };
logic signed [6:0] r3_array_back [0:LETTERS] = '{ 0,21,23,25,7,1,4,6,16,22,26,2,5,3,11,13,20,8,24,19,12,18,9,14,17,15,10 };
logic signed [6:0] refl_array    [0:LETTERS] = '{ 0,25,18,21,8,17,19,12,4,16,24,14,7,15,11,13,9,5,2,6,26,3,23,22,10,1,20 };

logic signed [6:0]      cod_symb;  

// delaying en_val_o for 6 strokes
always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      begin
        en_val_i_d <= 7'b0;
      end
    else
      begin
        en_val_i_d[0] <= en_val_i;
        for( int i = 1; i < 7; i++ )
          begin
            en_val_i_d[i] <= en_val_i_d[i-1];
          end
      end
  end

// calculating symbol function
function signed [6:0] symb_calc( input logic signed [6:0] a );
logic signed [6:0] abs;
  begin
    if( a < 1 )
      begin
        abs = a + LETTERS;
          if( abs > 0 )
            return abs;
          else 
            if( abs < 0 )
              return 0 - abs;
      end
    else
      if( a > LETTERS )
        return a - LETTERS;
    else 
      return a;
  end
endfunction

// rotor 1 straight movement
always_comb
  begin
    r1_acts[0] = in_symb_i + r1_i;
    r1_acts[1] = symb_calc( r1_acts[0] );
    r1_acts[2] = r1_array_str[r1_acts[1]];
  end

// saving result of the pipeline stage
always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      result[0] <= 7'b0;
    else
      result[0] <= r1_acts[2];
  end

// rotor 2 straight movement
always_comb
  begin
    r2_acts[0] = result[0] + ( r2_i - r1_i );
    r2_acts[1] = symb_calc( r2_acts[0] );
    r2_acts[2] = r2_array_str[r2_acts[1]];
  end

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      result[1] <= 7'b0;
    else
      result[1] <= r2_acts[2];
  end

// rotor 3 straight movement
always_comb
  begin
    r3_acts[0] = result[1] + ( r3_d_i[1] - r2_d_i[1] );
    r3_acts[1] = symb_calc( r3_acts[0] );
    r3_acts[2] = r3_array_str[r3_acts[1]];
  end

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      result[2] <= 7'b0;
    else
      result[2] <= r3_acts[2];
  end

// rotor 3 back movement
always_comb
  begin
    r3_acts[4] = refl_array[result[2]];
    r3_acts[5] = r3_array_back[r3_acts[4]];
  end

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      result[3] <= 7'b0;
    else
      result[3] <= r3_acts[5];
  end

// rotor 2 back movement
always_comb
  begin
    r2_acts[3] = result[3] - ( r3_d_i[3] - r2_d_i[3] );	
    r2_acts[4] = symb_calc( r2_acts[3] );
    r2_acts[5] = r2_array_back[r2_acts[4]];
  end

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      result[4] <= 7'b0;
    else
      result[4] <= r2_acts[5];
  end

// rotor 1 back movement
always_comb
  begin
    r1_acts[3] = result[4] - ( r2_d_i[4] - r1_d_i[4] );
    r1_acts[4] = symb_calc( r1_acts[3] );
    r1_acts[5] = r1_array_back[r1_acts[4]];
  end

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      result[5] <= 7'b0;
    else
      result[5] <= r1_acts[5];
  end
 
// out
always_comb
  begin
    out_presymb = result[5] - ( r1_d_i[5] - 7'b1 );
    cod_symb    = symb_calc( out_presymb );
  end

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      result[6] <= 7'b0;
    else
      result[6] <= cod_symb;
  end

assign out_symb_o = result[6];

// coded symbols are valid
assign encod_val_o = en_val_i_d[6];

endmodule
