module enigma_1

#(
  parameter R1_PAR = 1,
  parameter R2_PAR = 1,
  parameter R3_PAR = 1
)

(
  input logic        clk_i,       //synchrosignal
  input logic        rst_i,       //asynchronous reset
  input logic  [6:0] in_symb_i,   //incoming NOT CODED letter, each letter is coded by its serial number
  output logic [6:0] out_symb_o   //outcoming CODED letter, each letter is coded by its serial number
);

//in-logic of ALL blocks (dominoes principal)
logic [6:0] r1;
logic [6:0] r2;
logic [6:0] r3;

logic signed [6:0] in_r1_presymb;
logic signed [6:0] in_r1_symb;
logic signed [6:0] out_r1_symb;
logic signed [6:0] in_r1_prebacksymb;
logic signed [6:0] in_r1_backsymb;
logic signed [6:0] out_r1_backsymb;

logic signed [6:0] in_r2_presymb;
logic signed [6:0] in_r2_symb;
logic signed [6:0] out_r2_symb;
logic signed [6:0] in_r2_prebacksymb;
logic signed [6:0] in_r2_backsymb;
logic signed [6:0] out_r2_backsymb;

logic signed [6:0] in_r3_presymb;
logic signed [6:0] in_r3_symb;
logic signed [6:0] out_r3_symb;
logic signed [6:0] in_r3_backsymb;
logic signed [6:0] out_r3_backsymb;

logic signed [6:0] out_presymb;

logic signed [6:0] str_r1_array [0:26] = '{ 0,2,4,6,8,10,12,3,16,18,20,24,22,26,14,25,5,9,23,7,1,11,13,21,19,17,15 };

logic signed [6:0] back_r1_array [0:26] = '{ 0,20,1,7,2,16,3,19,4,17,5,21,6,22,14,26,8,25,9,24,10,23,12,18,11,15,13 };

logic signed [6:0] str_r2_array [0:26] = '{ 0,1,10,4,11,19,9,18,21,24,2,12,8,23,20,13,3,17,7,26,14,16,25,6,22,15,5 };

logic signed [6:0] back_r2_array [0:26] = '{ 0,1,10,16,3,26,23,18,12,6,2,4,11,15,20,25,21,17,7,5,14,8,24,13,9,22,19 };

logic signed [6:0] str_r3_array [0:26] = '{ 0,5,11,13,6,12,7,4,17,22,26,14,20,15,23,25,8,24,21,19,16,1,9,2,18,3,10 };

logic signed [6:0] back_r3_array [0:26] = '{ 0,21,23,25,7,1,4,6,16,22,26,2,5,3,11,13,20,8,24,19,12,18,9,14,17,15,10 };

logic signed [6:0] refl_array [0:26] = '{ 0,25,18,21,8,17,19,12,4,16,24,14,7,15,11,13,9,5,2,6,26,3,23,22,10,1,20 };

//calculating symbol function
function signed [6:0] symb_calc(input logic signed [6:0] a);
logic signed [6:0] abs;
  begin
    if ( a < 1 )
      begin
        abs = a + 26;
          if ( abs > 0 )
            return abs;
          else if ( abs < 0 )
            return 0 - abs;
      end
    else if ( a > 26 )
      return a - 26;
    else 
      return a;
  end
endfunction	

//GATE BLOCK INPUT AND OUTPUT OF THE MACHINE
//gate incoming symbol addition operation (G + R1); (trigger is needed for r1 counter's trigger delay compensation)
assign in_r1_presymb = in_symb_i + r1;

always_ff @ (posedge clk_i or negedge rst_i)
begin
  if ( !rst_i )
    in_r1_symb <= 0;
  else if ( (in_symb_i > 0) && (in_symb_i < 27) )
    in_r1_symb <= symb_calc(in_r1_presymb);
end

assign out_presymb = out_r1_backsymb - (r1 - 1);
assign out_symb_o = ( (out_r1_backsymb > 0) && (out_r1_backsymb < 27) ) ? symb_calc(out_presymb) : 0;


//ROTOR I BLOCK
//r1 - rotor definition (counter)
always_ff @ (posedge clk_i or negedge rst_i)   
begin
  if ( !rst_i )
    r1 <= R1_PAR;
  else if ( r1 == 26 )
    r1 <= 0;
  else if ( (in_symb_i > 0) && (in_symb_i < 27) ) 
    r1 <= r1 + 1;
end

//special rotor I action
assign out_r1_symb = str_r1_array[in_r1_symb];

assign in_r2_presymb = out_r1_symb + (r2 - r1);
assign in_r2_symb = ( (out_r1_symb > 0) && (out_r1_symb < 27) ) ? symb_calc(in_r2_presymb) : 0; 
assign in_r1_prebacksymb = out_r2_backsymb - (r2 - r1);
assign in_r1_backsymb = ( (out_r2_backsymb > 0) && (out_r2_backsymb < 27) ) ? symb_calc(in_r1_prebacksymb) : 0;

//special rotor I REVERSE action
assign out_r1_backsymb = back_r1_array[in_r1_backsymb];

//ROTOR II BLOCK
//r2 - rotor definition (counter)
always_ff @ (posedge clk_i or negedge rst_i)
begin
  if ( !rst_i )
    r2 <= R2_PAR;
  else if ( r2 == 26 )
    r2 <= 0;
  else if ( r1 == 26 )
    r2 <= r2 + 1;
end

//special rotor II action
assign out_r2_symb = str_r2_array[in_r2_symb];

assign in_r3_presymb = out_r2_symb + (r3 - r2);
assign in_r3_symb = ( (out_r2_symb > 0) && (out_r2_symb < 27) ) ? symb_calc(in_r3_presymb) : 0;
assign in_r2_prebacksymb = out_r3_backsymb - (r3 - r2);
assign in_r2_backsymb = ( (out_r3_backsymb > 0) && (out_r3_backsymb < 27) ) ? symb_calc(in_r2_prebacksymb) : 0;

//special rotor II REVERSE action
assign out_r2_backsymb = back_r2_array [in_r2_backsymb];

//ROTOR III BLOCK
//r3 - rotor definition (counter)
always_ff @ (posedge clk_i or negedge rst_i)
begin
  if ( !rst_i )
    r3 <= R3_PAR;
  else if ( r3 == 26 )
    r3 <= 0;
  else if ( r2 == 26 )
    r3 <= r3 + 1;
end

//special rotor III action
assign out_r3_symb = str_r3_array[in_r3_symb];

//special rotor III REVERSE action
assign out_r3_backsymb = back_r3_array[in_r3_backsymb];


//REFLECTOR BLOCK
//special reflector action
assign in_r3_backsymb = refl_array[out_r3_symb];

endmodule
