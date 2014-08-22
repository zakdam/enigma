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

logic signed [6:0] abs1;
logic signed [6:0] abs2;
logic signed [6:0] abs3;
logic signed [6:0] abs4;
logic signed [6:0] abs5;
logic signed [6:0] abs6;

//GATE BLOCK INPUT AND OUTPUT OF THE MACHINE
//gate incoming symbol addition operation (G + R1); (trigger is needed for r1 counter's trigger delay compensation)

assign in_r1_presymb = in_symb_i + r1;

always_ff @ (posedge clk_i or negedge rst_i)
begin
  if ( !rst_i )
    in_r1_symb <= 0;
  else if ( (in_symb_i > 0) && (in_symb_i < 27) )
    begin
      if ( in_r1_presymb < 1 )
        begin
        abs1 = in_r1_presymb + 26;
          if ( abs1 > 0 )
            in_r1_symb = abs1;
          else if ( abs1 < 0 )
            in_r1_symb = 0 - abs1;
        end
      else if ( in_r1_presymb > 26 )
        in_r1_symb <= in_r1_presymb - 26;
      else 
        in_r1_symb <= in_r1_presymb;
    end
end

//gate outcoming symbol subtraction operation (R1I - R1)

assign out_presymb = out_r1_backsymb - (r1 - 1);

always_comb
begin
  if ( (out_r1_backsymb > 0) && (out_r1_backsymb < 27) )
    begin
      if ( out_presymb < 1 )
        begin
        abs2 = out_presymb + 26;
          if ( abs2 > 0 )
            out_symb_o = abs2;
          else if ( abs2 < 0 )
            out_symb_o = 0 - abs2;
        end
      else if ( out_presymb > 26 )
        out_symb_o = out_presymb - 26;
      else
        out_symb_o = out_presymb;
    end
end


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
always_comb
begin
  case ( in_r1_symb[4:0] )
    7'd1    : out_r1_symb = 7'd2;
    7'd2    : out_r1_symb = 7'd4;
    7'd3    : out_r1_symb = 7'd6;
    7'd4    : out_r1_symb = 7'd8;
    7'd5    : out_r1_symb = 7'd10;
    7'd6    : out_r1_symb = 7'd12;
    7'd7    : out_r1_symb = 7'd3;
    7'd8    : out_r1_symb = 7'd16;
    7'd9    : out_r1_symb = 7'd18;
    7'd10   : out_r1_symb = 7'd20;
    7'd11   : out_r1_symb = 7'd24;
    7'd12   : out_r1_symb = 7'd22;
    7'd13   : out_r1_symb = 7'd26;
    7'd14   : out_r1_symb = 7'd14;
    7'd15   : out_r1_symb = 7'd25;
    7'd16   : out_r1_symb = 7'd5;
    7'd17   : out_r1_symb = 7'd9;
    7'd18   : out_r1_symb = 7'd23;
    7'd19   : out_r1_symb = 7'd7;
    7'd20   : out_r1_symb = 7'd1;
    7'd21   : out_r1_symb = 7'd11;
    7'd22   : out_r1_symb = 7'd13;
    7'd23   : out_r1_symb = 7'd21;
    7'd24   : out_r1_symb = 7'd19;
    7'd25   : out_r1_symb = 7'd17;
    7'd26   : out_r1_symb = 7'd15;
    default : out_r1_symb = 7'd0;
  endcase
end

assign in_r2_presymb = out_r1_symb + (r2 - r1);

always_comb
begin
  if ( (out_r1_symb > 0) && (out_r1_symb < 27) )
    begin
      if ( in_r2_presymb < 1 )
        begin
        abs3 = in_r2_presymb + 26;
          if ( abs3 > 0 )
            in_r2_symb = abs3;
          else if ( abs3 < 0 )
            in_r2_symb = 0 - abs3;
        end
      else if ( in_r2_presymb > 26 )
        in_r2_symb = in_r2_presymb - 26;
      else
        in_r2_symb = in_r2_presymb;
    end
end

assign in_r1_prebacksymb = out_r2_backsymb - (r2 - r1);

always_comb
begin
  if ( (out_r2_backsymb > 0) && (out_r2_backsymb < 27) )
    begin
      if ( in_r1_prebacksymb < 1 )
        begin
        abs4 = in_r1_prebacksymb + 26;
          if ( abs4 > 0 )
            in_r1_backsymb = abs4;
          else if ( abs4 < 0 )
            in_r1_backsymb = 0 - abs4;
        end
      else if ( in_r1_prebacksymb > 26 )
        in_r1_backsymb = in_r1_prebacksymb - 26;
      else 
        in_r1_backsymb = in_r1_prebacksymb;
    end
end

//special rotor I REVERSE action
always_comb
begin
  case ( in_r1_backsymb[4:0] )
    7'd1    : out_r1_backsymb = 7'd20;
    7'd2    : out_r1_backsymb = 7'd1;
    7'd3    : out_r1_backsymb = 7'd7;
    7'd4    : out_r1_backsymb = 7'd2;
    7'd5    : out_r1_backsymb = 7'd16;
    7'd6    : out_r1_backsymb = 7'd3;
    7'd7    : out_r1_backsymb = 7'd19;
    7'd8    : out_r1_backsymb = 7'd4;
    7'd9    : out_r1_backsymb = 7'd17;
    7'd10   : out_r1_backsymb = 7'd5;
    7'd11   : out_r1_backsymb = 7'd21;
    7'd12   : out_r1_backsymb = 7'd6;
    7'd13   : out_r1_backsymb = 7'd22;
    7'd14   : out_r1_backsymb = 7'd14;
    7'd15   : out_r1_backsymb = 7'd26;
    7'd16   : out_r1_backsymb = 7'd8;
    7'd17   : out_r1_backsymb = 7'd25;
    7'd18   : out_r1_backsymb = 7'd9;
    7'd19   : out_r1_backsymb = 7'd24;
    7'd20   : out_r1_backsymb = 7'd10;
    7'd21   : out_r1_backsymb = 7'd23;
    7'd22   : out_r1_backsymb = 7'd12;
    7'd23   : out_r1_backsymb = 7'd18;
    7'd24   : out_r1_backsymb = 7'd11;
    7'd25   : out_r1_backsymb = 7'd15;
    7'd26   : out_r1_backsymb = 7'd13;
    default : out_r1_backsymb = 7'd0;
  endcase
end


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
always_comb
begin
  case ( in_r2_symb[4:0] )
    7'd1    : out_r2_symb = 7'd1;
    7'd2    : out_r2_symb = 7'd10;
    7'd3    : out_r2_symb = 7'd4;
    7'd4    : out_r2_symb = 7'd11;
    7'd5    : out_r2_symb = 7'd19;
    7'd6    : out_r2_symb = 7'd9;
    7'd7    : out_r2_symb = 7'd18;
    7'd8    : out_r2_symb = 7'd21;
    7'd9    : out_r2_symb = 7'd24;
    7'd10   : out_r2_symb = 7'd2;
    7'd11   : out_r2_symb = 7'd12;
    7'd12   : out_r2_symb = 7'd8;
    7'd13   : out_r2_symb = 7'd23;
    7'd14   : out_r2_symb = 7'd20;
    7'd15   : out_r2_symb = 7'd13;
    7'd16   : out_r2_symb = 7'd3;
    7'd17   : out_r2_symb = 7'd17;
    7'd18   : out_r2_symb = 7'd7;
    7'd19   : out_r2_symb = 7'd26;
    7'd20   : out_r2_symb = 7'd14;
    7'd21   : out_r2_symb = 7'd16;
    7'd22   : out_r2_symb = 7'd25;
    7'd23   : out_r2_symb = 7'd6;
    7'd24   : out_r2_symb = 7'd22;
    7'd25   : out_r2_symb = 7'd15;
    7'd26   : out_r2_symb = 7'd5;
    default : out_r2_symb = 7'd0; 
  endcase
end

assign in_r3_presymb = out_r2_symb + (r3 - r2);

always_comb
begin
  if ( (out_r2_symb > 0) && (out_r2_symb < 27) )
    begin
      if ( in_r3_presymb < 1 )
        begin
        abs5 = in_r3_presymb + 26;
          if ( abs5 > 0 )
            in_r3_symb = abs5;
          else if ( abs5 < 0 )
            in_r3_symb = 0 - abs5;
        end
      else if ( in_r3_presymb > 26 )
        in_r3_symb = in_r3_presymb - 26;
      else
        in_r3_symb = in_r3_presymb;
    end
end

assign in_r2_prebacksymb = out_r3_backsymb - (r3 - r2);

always_comb
begin
  if ( (out_r3_backsymb > 0) && (out_r3_backsymb < 27) )
    begin
      if ( in_r2_prebacksymb < 1 )
        begin
        abs6 = in_r2_prebacksymb + 26;
          if ( abs6 > 0 )
            in_r2_backsymb = abs6;
          else if ( abs6 < 0 )
            in_r2_backsymb = 0 - abs6;
        end
      else if ( in_r2_prebacksymb > 26 )
        in_r2_backsymb = in_r2_prebacksymb - 26;
      else
        in_r2_backsymb = in_r2_prebacksymb;
    end
end

//special rotor II REVERSE action
always_comb
begin
  case ( in_r2_backsymb[4:0] )
    7'd1    : out_r2_backsymb = 7'd1;
    7'd2    : out_r2_backsymb = 7'd10;
    7'd3    : out_r2_backsymb = 7'd16;
    7'd4    : out_r2_backsymb = 7'd3;
    7'd5    : out_r2_backsymb = 7'd26;
    7'd6    : out_r2_backsymb = 7'd23;
    7'd7    : out_r2_backsymb = 7'd18;
    7'd8    : out_r2_backsymb = 7'd12;
    7'd9    : out_r2_backsymb = 7'd6;
    7'd10   : out_r2_backsymb = 7'd2;
    7'd11   : out_r2_backsymb = 7'd4;
    7'd12   : out_r2_backsymb = 7'd11;
    7'd13   : out_r2_backsymb = 7'd15;
    7'd14   : out_r2_backsymb = 7'd20;
    7'd15   : out_r2_backsymb = 7'd25;
    7'd16   : out_r2_backsymb = 7'd21;
    7'd17   : out_r2_backsymb = 7'd17;
    7'd18   : out_r2_backsymb = 7'd7;
    7'd19   : out_r2_backsymb = 7'd5;
    7'd20   : out_r2_backsymb = 7'd14;
    7'd21   : out_r2_backsymb = 7'd8;
    7'd22   : out_r2_backsymb = 7'd24;
    7'd23   : out_r2_backsymb = 7'd13;
    7'd24   : out_r2_backsymb = 7'd9;
    7'd25   : out_r2_backsymb = 7'd22;
    7'd26   : out_r2_backsymb = 7'd19;
    default : out_r2_backsymb = 7'd0;
  endcase
end


//ROTOR III BLOCK
//r3 - rotor definition (counter)
always_ff @ (posedge clk_i or negedge rst_i)
begin
  if ( !rst_i )
    r3 <= R3_PAR;
  else if ( r3 == 26 )
    r3 <= 0;
  else if ( r3 == 26 )
    r3 <= r3 + 1;
end

//special rotor III action
always_comb
begin
  case ( in_r3_symb[4:0] )
    7'd1    : out_r3_symb = 7'd5;
    7'd2    : out_r3_symb = 7'd11;
    7'd3    : out_r3_symb = 7'd13;
    7'd4    : out_r3_symb = 7'd6;
    7'd5    : out_r3_symb = 7'd12;
    7'd6    : out_r3_symb = 7'd7;
    7'd7    : out_r3_symb = 7'd4;
    7'd8    : out_r3_symb = 7'd17;
    7'd9    : out_r3_symb = 7'd22;
    7'd10   : out_r3_symb = 7'd26;
    7'd11   : out_r3_symb = 7'd14;
    7'd12   : out_r3_symb = 7'd20;
    7'd13   : out_r3_symb = 7'd15;
    7'd14   : out_r3_symb = 7'd23;
    7'd15   : out_r3_symb = 7'd25;
    7'd16   : out_r3_symb = 7'd8;
    7'd17   : out_r3_symb = 7'd24;
    7'd18   : out_r3_symb = 7'd21;
    7'd19   : out_r3_symb = 7'd19;
    7'd20   : out_r3_symb = 7'd16;
    7'd21   : out_r3_symb = 7'd1;
    7'd22   : out_r3_symb = 7'd9;
    7'd23   : out_r3_symb = 7'd2;
    7'd24   : out_r3_symb = 7'd18;
    7'd25   : out_r3_symb = 7'd3;
    7'd26   : out_r3_symb = 7'd10;
    default : out_r3_symb = 7'd0;
  endcase
end

//special rotor III REVERSE action
always_comb
begin
  case ( in_r3_backsymb[4:0] )
    7'd1    : out_r3_backsymb = 7'd21;
    7'd2    : out_r3_backsymb = 7'd23;
    7'd3    : out_r3_backsymb = 7'd25;
    7'd4    : out_r3_backsymb = 7'd7;
    7'd5    : out_r3_backsymb = 7'd1;
    7'd6    : out_r3_backsymb = 7'd4;
    7'd7    : out_r3_backsymb = 7'd6;
    7'd8    : out_r3_backsymb = 7'd16;
    7'd9    : out_r3_backsymb = 7'd22;
    7'd10   : out_r3_backsymb = 7'd26;
    7'd11   : out_r3_backsymb = 7'd2;
    7'd12   : out_r3_backsymb = 7'd5;
    7'd13   : out_r3_backsymb = 7'd3;
    7'd14   : out_r3_backsymb = 7'd11;
    7'd15   : out_r3_backsymb = 7'd13;
    7'd16   : out_r3_backsymb = 7'd20;
    7'd17   : out_r3_backsymb = 7'd8;
    7'd18   : out_r3_backsymb = 7'd24;
    7'd19   : out_r3_backsymb = 7'd19;
    7'd20   : out_r3_backsymb = 7'd12;
    7'd21   : out_r3_backsymb = 7'd18;
    7'd22   : out_r3_backsymb = 7'd9;
    7'd23   : out_r3_backsymb = 7'd14;
    7'd24   : out_r3_backsymb = 7'd17;
    7'd25   : out_r3_backsymb = 7'd15;
    7'd26   : out_r3_backsymb = 7'd10;
    default : out_r3_backsymb = 7'd0;
  endcase
end

//REFLECTOR BLOCK
//special reflector action
always_comb
begin
  case ( out_r3_symb[4:0] )
    7'd1    : in_r3_backsymb = 7'd25;
    7'd2    : in_r3_backsymb = 7'd18;
    7'd3    : in_r3_backsymb = 7'd21;
    7'd4    : in_r3_backsymb = 7'd8;
    7'd5    : in_r3_backsymb = 7'd17;
    7'd6    : in_r3_backsymb = 7'd19;
    7'd7    : in_r3_backsymb = 7'd12;
    7'd8    : in_r3_backsymb = 7'd4;
    7'd9    : in_r3_backsymb = 7'd16;
    7'd10   : in_r3_backsymb = 7'd24;
    7'd11   : in_r3_backsymb = 7'd14;
    7'd12   : in_r3_backsymb = 7'd7;
    7'd13   : in_r3_backsymb = 7'd15;
    7'd14   : in_r3_backsymb = 7'd11;
    7'd15   : in_r3_backsymb = 7'd13;
    7'd16   : in_r3_backsymb = 7'd9;
    7'd17   : in_r3_backsymb = 7'd5;
    7'd18   : in_r3_backsymb = 7'd2;
    7'd19   : in_r3_backsymb = 7'd6;
    7'd20   : in_r3_backsymb = 7'd26;
    7'd21   : in_r3_backsymb = 7'd3;
    7'd22   : in_r3_backsymb = 7'd23;
    7'd23   : in_r3_backsymb = 7'd22;
    7'd24   : in_r3_backsymb = 7'd10;
    7'd25   : in_r3_backsymb = 7'd1;
    7'd26   : in_r3_backsymb = 7'd20;
    default : in_r3_backsymb = 7'd0;
  endcase
end

endmodule
