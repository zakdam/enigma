module enigma_1
#(
  parameter  R1_INIT_VALUE  = 1,
  parameter  R2_INIT_VALUE  = 1,
  parameter  R3_INIT_VALUE  = 1,

  localparam LETTERS = 26
)

(
  input              clk_i,               // synchrosignal
  input              rst_i,               // asynchronous reset
  input              rotors_rst_i,        // only rotors reset

  input        [6:0] in_symb_i,           // incoming NOT CODED letter, each letter is coded by its serial number
  input              in_symb_val_i,       // incoming symbol is valid

  output logic [6:0] out_symb_o,          // outcoming CODED letter, each letter is coded by its serial number
  output logic       out_symb_val_o       // outcoming encoded symbols are valid
);

// rotors states (rX_s) and delayed states (rX_s_d)
logic      [6:0] r1_s;
logic [5:1][6:0] r1_s_d;

logic      [6:0] r2_s;
logic [4:1][6:0] r2_s_d;

logic      [6:0] r3_s;
logic [3:1][6:0] r3_s_d;

/*logic [5:0][6:0]   r1_s;                //0 - non-delayed, 1 - delayed for one stroke,...
logic [4:0][6:0]   r2_s;                //same numeration
logic [3:0][6:0]   r3_s;                //same numeration*/

logic signed [5:0][6:0] r1_acts;

logic signed [5:0][6:0] r2_acts;

logic signed [5:0][6:0] r3_acts;

logic signed [6:0] out_presymb;

logic signed [6:0][6:0] result;          // triggers to save pipeline stages' results

logic signed [6:0] r1_array_str  [0:LETTERS] = '{ 0,2,4,6,8,10,12,3,16,18,20,24,22,26,14,25,5,9,23,7,1,11,13,21,19,17,15 };
logic signed [6:0] r1_array_back [0:LETTERS] = '{ 0,20,1,7,2,16,3,19,4,17,5,21,6,22,14,26,8,25,9,24,10,23,12,18,11,15,13 };
logic signed [6:0] r2_array_str  [0:LETTERS] = '{ 0,1,10,4,11,19,9,18,21,24,2,12,8,23,20,13,3,17,7,26,14,16,25,6,22,15,5 };
logic signed [6:0] r2_array_back [0:LETTERS] = '{ 0,1,10,16,3,26,23,18,12,6,2,4,11,15,20,25,21,17,7,5,14,8,24,13,9,22,19 };
logic signed [6:0] r3_array_str  [0:LETTERS] = '{ 0,5,11,13,6,12,7,4,17,22,26,14,20,15,23,25,8,24,21,19,16,1,9,2,18,3,10 };
logic signed [6:0] r3_array_back [0:LETTERS] = '{ 0,21,23,25,7,1,4,6,16,22,26,2,5,3,11,13,20,8,24,19,12,18,9,14,17,15,10 };
logic signed [6:0] refl_array    [0:LETTERS] = '{ 0,25,18,21,8,17,19,12,4,16,24,14,7,15,11,13,9,5,2,6,26,3,23,22,10,1,20 };
  
// triggers for delaying in_symb_val_i
  logic        [5:0] en_val_i_d;

// delaying en_val_o for 6 strokes
always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      begin
        en_val_i_d <= 6'b0;
      end
    else
      begin
        en_val_i_d[0] <= in_symb_val_i;
        for( int i = 1; i < 6; i++ )
          begin
            en_val_i_d[i] <= en_val_i_d[i-1];
        /*en_val_i_d[0] <= in_symb_val_i;
        en_val_i_d[1] <= en_val_i_d[0];
        en_val_i_d[2] <= en_val_i_d[1];
        en_val_i_d[3] <= en_val_i_d[2];
        en_val_i_d[4] <= en_val_i_d[3];
        en_val_i_d[5] <= en_val_i_d[4];*/
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

// ROTOR I BLOCK
// r1_s - rotor definition (counter)
always_ff @( posedge clk_i or posedge rst_i or posedge rotors_rst_i )   
  begin
    if( rst_i )
      r1_s <= R1_INIT_VALUE;
    else
      if( rotors_rst_i )
        r1_s <= R1_INIT_VALUE;
    else 
      if( r1_s == LETTERS )
        r1_s <= 7'd1;
    else
      if( in_symb_val_i ) 
        r1_s <= r1_s + 6'd1;
/*//start delaying
      r1_s_d[1] <= r1_s;
      r1_s_d[2] <= r1_s_d[1];
      r1_s_d[3] <= r1_s_d[2];
      r1_s_d[4] <= r1_s_d[3];
      r1_s_d[5] <= r1_s_d[4];*/
  end

// r1_s_d delayed for N strokes
always_ff @( posedge clk_i )
  begin
    r1_s_d[1] <= r1_s;
    r1_s_d[2] <= r1_s_d[1];  
    r1_s_d[3] <= r1_s_d[2];
    r1_s_d[4] <= r1_s_d[3];
    r1_s_d[5] <= r1_s_d[4];
  end


// ROTOR II BLOCK
// r2_s - rotor definition (counter)
always_ff @( posedge clk_i or posedge rst_i or posedge rotors_rst_i )
  begin
    if( rst_i )
      r2_s <= R2_INIT_VALUE;
    else 
      if( rotors_rst_i )
        r2_s <= R2_INIT_VALUE;
    else 
      if( r2_s == LETTERS )
        r2_s <= 7'd1;
    else 
      if( r1_s == LETTERS )
        r2_s <= r2_s + 7'd1;
/*//start delaying
      r2_s_d[1] <= r2_s;
      r2_s_d[2] <= r2_s_d[1];
      r2_s_d[3] <= r2_s_d[2];
      r2_s_d[4] <= r2_s_d[3];*/
  end

// r2_s_d delayed for N strokes
always_ff @( posedge clk_i )
  begin
    r2_s_d[1] <= r2_s;
    r2_s_d[2] <= r2_s_d[1];
    r2_s_d[3] <= r2_s_d[2];
    r2_s_d[4] <= r2_s_d[3];
  end


// ROTOR III BLOCK
// r3_s - rotor definition (counter)
always_ff @( posedge clk_i or posedge rst_i or posedge rotors_rst_i)
  begin
    if( rst_i )
      r3_s <= R3_INIT_VALUE;
    else 
      if( rotors_rst_i )
        r3_s <= R3_INIT_VALUE;
    else 
      if( r3_s == LETTERS )
        r3_s <= 7'd1;
    else 
      if( r3_s == LETTERS )
        r3_s <= r3_s + 7'd1;
/*//start delaying
      r3_s_d[1] <= r3_s;
      r3_s_d[2] <= r3_s_d[1];
      r3_s_d[3] <= r3_s_d[2];*/
  end

// r3_s_d delayed for N strokes
always_ff @( posedge clk_i )
  begin
    r3_s_d[1] <= r3_s;
    r3_s_d[2] <= r3_s_d[1];
    r3_s_d[3] <= r3_s_d[2];
  end


// rotor 1 straight movement
always_comb
  begin
    r1_acts[0] = in_symb_i + r1_s;
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
    r2_acts[0] = result[0] + ( r2_s - r1_s );
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
    r3_acts[0] = result[1] + ( r3_s_d[1] - r2_s_d[1] );
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
    r2_acts[3] = result[3] - ( r3_s_d[3] - r2_s_d[3] );	
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
    r1_acts[3] = result[4] - ( r2_s_d[4] - r1_s_d[4] );
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
    out_presymb = result[5] - ( r1_s_d[5] - 7'b1 );
    out_symb_o  = symb_calc( out_presymb );
  end

always_ff @( posedge clk_i or posedge rst_i )
  begin
    if( rst_i )
      result[6] <= 7'b0;
    else
      result[6] <= out_symb_o;
  end

// coded symbols are valid
assign out_symb_val_o = en_val_i_d[5];

endmodule
