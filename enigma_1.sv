module enigma_1
  
#(
parameter R1_PAR = 1,
parameter R2_PAR = 1,
parameter R3_PAR = 1
)

(
input logic        clk_i,       //synchrosignal
input logic        rst_i,       //asynchronous reset
input logic  [5:0] in_symb_i,   //incoming NOT CODED letter, each letter is coded by its serial number
output logic [5:0] out_symb_o   //outcoming CODED letter, each letter is coded by its serial number
);

//in-logic of ALL blocks (dominoes principal)
logic [5:0] r1;
logic [5:0] r2;
logic [5:0] r3;

logic signed [5:0] r1_presymb_i;
logic        [5:0] r1_symb_i;
logic        [5:0] r1_symb_o;
logic signed [5:0] r1_prebacksymb_i;
logic        [5:0] r1_backsymb_i;
logic        [5:0] r1_backsymb_o;

logic signed [5:0] r2_presymb_i;
logic        [5:0] r2_symb_i;
logic        [5:0] r2_symb_o;
logic signed [5:0] r2_prebacksymb_i;
logic        [5:0] r2_backsymb_i;
logic        [5:0] r2_backsymb_o;

logic signed [5:0] r3_presymb_i;
logic        [5:0] r3_symb_i;
logic        [5:0] r3_symb_o;
logic        [5:0] r3_backsymb_i;
logic        [5:0] r3_backsymb_o;

logic signed [5:0] out_presymb_o;

//GATE BLOCK INPUT AND OUTPUT OF THE MACHINE
//gate incoming symbol addition operation (G + R1); (trigger is needed for r1 counter's trigger delay compensation)

assign r1_presymb_i = in_symb_i + r1;

always_ff @ (posedge clk_i or negedge rst_i)
begin
  if ( !rst_i )
    r1_symb_i <= 0;
  else if ( (in_symb_i > 0) && (in_symb_i < 27) )
    begin
      if ( r1_presymb_i < 1 )
        r1_symb_i <= r1_presymb_i + 26;
      else if ( r1_presymb_i > 26 )
        r1_symb_i <= r1_presymb_i - 26;
      else 
        r1_symb_i <= r1_presymb_i;
    end
end

//gate outcoming symbol subtraction operation (R1I - R1)

assign out_presymb_o = r1_backsymb_o - (r1 - 1);

always_comb
begin
  if ( (r1_backsymb_o > 0) && (r1_backsymb_o < 27) )
    begin
      if ( out_presymb_o < 1 )
        out_symb_o = out_presymb_o + 26;
      else if ( out_presymb_o > 26 )
        out_symb_o = out_presymb_o - 26;
      else
        out_symb_o = out_presymb_o;
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
  case ( r1_symb_i[4:0] )
    5'd1    : r1_symb_o = 5'd2;
    5'd2    : r1_symb_o = 5'd4;
    5'd3    : r1_symb_o = 5'd6;
    5'd4    : r1_symb_o = 5'd8;
    5'd5    : r1_symb_o = 5'd10;
    5'd6    : r1_symb_o = 5'd12;
    5'd7    : r1_symb_o = 5'd3;
    5'd8    : r1_symb_o = 5'd16;
    5'd9    : r1_symb_o = 5'd18;
    5'd10   : r1_symb_o = 5'd20;
    5'd11   : r1_symb_o = 5'd24;
    5'd12   : r1_symb_o = 5'd22;
    5'd13   : r1_symb_o = 5'd26;
    5'd14   : r1_symb_o = 5'd14;
    5'd15   : r1_symb_o = 5'd25;
    5'd16   : r1_symb_o = 5'd5;
    5'd17   : r1_symb_o = 5'd9;
    5'd18   : r1_symb_o = 5'd23;
    5'd19   : r1_symb_o = 5'd7;
    5'd20   : r1_symb_o = 5'd1;
    5'd21   : r1_symb_o = 5'd11;
    5'd22   : r1_symb_o = 5'd13;
    5'd23   : r1_symb_o = 5'd21;
    5'd24   : r1_symb_o = 5'd19;
    5'd25   : r1_symb_o = 5'd17;
    5'd26   : r1_symb_o = 5'd15;
    default : r1_symb_o = 5'd0;
  endcase
end

assign r2_presymb_i = r1_symb_o + (r2 - r1);

always_comb
begin
  if ( (r1_symb_o > 0) && (r1_symb_o < 27) )
    begin
      if ( r2_presymb_i < 1 )
        r2_symb_i = r2_presymb_i + 26;
      else if ( r2_presymb_i > 26 )
        r2_symb_i = r2_presymb_i - 26;
      else
        r2_symb_i = r2_presymb_i;
    end
end

assign r1_prebacksymb_i = r2_backsymb_o - (r2 - r1);

always_comb
begin
  if ( (r2_backsymb_o > 0) && (r2_backsymb_o < 27) )
    begin
      if ( r1_prebacksymb_i < 1 )
        r1_backsymb_i = r1_prebacksymb_i + 26;
      else if ( r1_prebacksymb_i > 26 )
        r1_backsymb_i = r1_prebacksymb_i - 26;
      else 
        r1_backsymb_i = r1_prebacksymb_i;
    end
end

//special rotor I REVERSE action
always_comb
begin
  case ( r1_backsymb_i[4:0] )
    5'd1    : r1_backsymb_o = 5'd20;
    5'd2    : r1_backsymb_o = 5'd1;
    5'd3    : r1_backsymb_o = 5'd7;
    5'd4    : r1_backsymb_o = 5'd2;
    5'd5    : r1_backsymb_o = 5'd16;
    5'd6    : r1_backsymb_o = 5'd3;
    5'd7    : r1_backsymb_o = 5'd19;
    5'd8    : r1_backsymb_o = 5'd4;
    5'd9    : r1_backsymb_o = 5'd17;
    5'd10   : r1_backsymb_o = 5'd5;
    5'd11   : r1_backsymb_o = 5'd21;
    5'd12   : r1_backsymb_o = 5'd6;
    5'd13   : r1_backsymb_o = 5'd22;
    5'd14   : r1_backsymb_o = 5'd14;
    5'd15   : r1_backsymb_o = 5'd26;
    5'd16   : r1_backsymb_o = 5'd8;
    5'd17   : r1_backsymb_o = 5'd25;
    5'd18   : r1_backsymb_o = 5'd9;
    5'd19   : r1_backsymb_o = 5'd24;
    5'd20   : r1_backsymb_o = 5'd10;
    5'd21   : r1_backsymb_o = 5'd23;
    5'd22   : r1_backsymb_o = 5'd12;
    5'd23   : r1_backsymb_o = 5'd18;
    5'd24   : r1_backsymb_o = 5'd11;
    5'd25   : r1_backsymb_o = 5'd15;
    5'd26   : r1_backsymb_o = 5'd13;
    default : r1_backsymb_o = 5'd0;
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
  case ( r2_symb_i[4:0] )
    5'd1    : r2_symb_o = 5'd1;
    5'd2    : r2_symb_o = 5'd10;
    5'd3    : r2_symb_o = 5'd4;
    5'd4    : r2_symb_o = 5'd11;
    5'd5    : r2_symb_o = 5'd19;
    5'd6    : r2_symb_o = 5'd9;
    5'd7    : r2_symb_o = 5'd18;
    5'd8    : r2_symb_o = 5'd21;
    5'd9    : r2_symb_o = 5'd24;
    5'd10   : r2_symb_o = 5'd2;
    5'd11   : r2_symb_o = 5'd12;
    5'd12   : r2_symb_o = 5'd8;
    5'd13   : r2_symb_o = 5'd23;
    5'd14   : r2_symb_o = 5'd20;
    5'd15   : r2_symb_o = 5'd13;
    5'd16   : r2_symb_o = 5'd3;
    5'd17   : r2_symb_o = 5'd17;
    5'd18   : r2_symb_o = 5'd7;
    5'd19   : r2_symb_o = 5'd26;
    5'd20   : r2_symb_o = 5'd14;
    5'd21   : r2_symb_o = 5'd16;
    5'd22   : r2_symb_o = 5'd25;
    5'd23   : r2_symb_o = 5'd6;
    5'd24   : r2_symb_o = 5'd22;
    5'd25   : r2_symb_o = 5'd15;
    5'd26   : r2_symb_o = 5'd5;
    default : r2_symb_o = 5'd0; 
  endcase
end

assign r3_presymb_i = r2_symb_o + (r3 - r2);

always_comb
begin
  if ( (r2_symb_o > 0) && (r2_symb_o < 27) )
    begin
      if ( r3_presymb_i < 1 )
        r3_symb_i = r3_presymb_i + 26;
      else if ( r3_presymb_i > 26 )
        r3_symb_i = r3_presymb_i - 26;
      else
        r3_symb_i = r3_presymb_i;
    end
end

assign r2_prebacksymb_i = r3_backsymb_o - (r3 - r2);

always_comb
begin
  if ( (r3_backsymb_o > 0) && (r3_backsymb_o < 27) )
    begin
      if ( r2_prebacksymb_i < 1 )
        r2_backsymb_i = r2_prebacksymb_i + 26;
      else if ( r2_prebacksymb_i > 26 )
        r2_backsymb_i = r2_prebacksymb_i - 26;
      else
        r2_backsymb_i = r2_prebacksymb_i;
    end
end

//special rotor II REVERSE action
always_comb
begin
  case ( r2_backsymb_i[4:0] )
    5'd1    : r2_backsymb_o = 5'd1;
    5'd2    : r2_backsymb_o = 5'd10;
    5'd3    : r2_backsymb_o = 5'd16;
    5'd4    : r2_backsymb_o = 5'd3;
    5'd5    : r2_backsymb_o = 5'd26;
    5'd6    : r2_backsymb_o = 5'd23;
    5'd7    : r2_backsymb_o = 5'd18;
    5'd8    : r2_backsymb_o = 5'd12;
    5'd9    : r2_backsymb_o = 5'd6;
    5'd10   : r2_backsymb_o = 5'd2;
    5'd11   : r2_backsymb_o = 5'd4;
    5'd12   : r2_backsymb_o = 5'd11;
    5'd13   : r2_backsymb_o = 5'd15;
    5'd14   : r2_backsymb_o = 5'd20;
    5'd15   : r2_backsymb_o = 5'd25;
    5'd16   : r2_backsymb_o = 5'd21;
    5'd17   : r2_backsymb_o = 5'd17;
    5'd18   : r2_backsymb_o = 5'd7;
    5'd19   : r2_backsymb_o = 5'd5;
    5'd20   : r2_backsymb_o = 5'd14;
    5'd21   : r2_backsymb_o = 5'd8;
    5'd22   : r2_backsymb_o = 5'd24;
    5'd23   : r2_backsymb_o = 5'd13;
    5'd24   : r2_backsymb_o = 5'd9;
    5'd25   : r2_backsymb_o = 5'd22;
    5'd26   : r2_backsymb_o = 5'd19;
    default : r2_backsymb_o = 5'd0;
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
  case ( r3_symb_i[4:0] )
    5'd1    : r3_symb_o = 5'd5;
    5'd2    : r3_symb_o = 5'd11;
    5'd3    : r3_symb_o = 5'd13;
    5'd4    : r3_symb_o = 5'd6;
    5'd5    : r3_symb_o = 5'd12;
    5'd6    : r3_symb_o = 5'd7;
    5'd7    : r3_symb_o = 5'd4;
    5'd8    : r3_symb_o = 5'd17;
    5'd9    : r3_symb_o = 5'd22;
    5'd10   : r3_symb_o = 5'd26;
    5'd11   : r3_symb_o = 5'd14;
    5'd12   : r3_symb_o = 5'd20;
    5'd13   : r3_symb_o = 5'd15;
    5'd14   : r3_symb_o = 5'd23;
    5'd15   : r3_symb_o = 5'd25;
    5'd16   : r3_symb_o = 5'd8;
    5'd17   : r3_symb_o = 5'd24;
    5'd18   : r3_symb_o = 5'd21;
    5'd19   : r3_symb_o = 5'd19;
    5'd20   : r3_symb_o = 5'd16;
    5'd21   : r3_symb_o = 5'd1;
    5'd22   : r3_symb_o = 5'd9;
    5'd23   : r3_symb_o = 5'd2;
    5'd24   : r3_symb_o = 5'd18;
    5'd25   : r3_symb_o = 5'd3;
    5'd26   : r3_symb_o = 5'd10;
    default : r3_symb_o = 5'd0;
  endcase
end

//special rotor III REVERSE action
always_comb
begin
  case ( r3_backsymb_i[4:0] )
    5'd1    : r3_backsymb_o = 5'd21;
    5'd2    : r3_backsymb_o = 5'd23;
    5'd3    : r3_backsymb_o = 5'd25;
    5'd4    : r3_backsymb_o = 5'd7;
    5'd5    : r3_backsymb_o = 5'd1;
    5'd6    : r3_backsymb_o = 5'd4;
    5'd7    : r3_backsymb_o = 5'd6;
    5'd8    : r3_backsymb_o = 5'd16;
    5'd9    : r3_backsymb_o = 5'd22;
    5'd10   : r3_backsymb_o = 5'd26;
    5'd11   : r3_backsymb_o = 5'd2;
    5'd12   : r3_backsymb_o = 5'd5;
    5'd13   : r3_backsymb_o = 5'd3;
    5'd14   : r3_backsymb_o = 5'd11;
    5'd15   : r3_backsymb_o = 5'd13;
    5'd16   : r3_backsymb_o = 5'd20;
    5'd17   : r3_backsymb_o = 5'd8;
    5'd18   : r3_backsymb_o = 5'd24;
    5'd19   : r3_backsymb_o = 5'd19;
    5'd20   : r3_backsymb_o = 5'd12;
    5'd21   : r3_backsymb_o = 5'd18;
    5'd22   : r3_backsymb_o = 5'd9;
    5'd23   : r3_backsymb_o = 5'd14;
    5'd24   : r3_backsymb_o = 5'd17;
    5'd25   : r3_backsymb_o = 5'd15;
    5'd26   : r3_backsymb_o = 5'd10;
    default : r3_backsymb_o = 5'd0;
  endcase
end

//REFLECTOR BLOCK
//special reflector action
always_comb
begin
  case ( r3_symb_o[4:0] )
    5'd1    : r3_backsymb_i = 5'd25;
    5'd2    : r3_backsymb_i = 5'd18;
    5'd3    : r3_backsymb_i = 5'd21;
    5'd4    : r3_backsymb_i = 5'd8;
    5'd5    : r3_backsymb_i = 5'd17;
    5'd6    : r3_backsymb_i = 5'd19;
    5'd7    : r3_backsymb_i = 5'd12;
    5'd8    : r3_backsymb_i = 5'd4;
    5'd9    : r3_backsymb_i = 5'd16;
    5'd10   : r3_backsymb_i = 5'd24;
    5'd11   : r3_backsymb_i = 5'd14;
    5'd12   : r3_backsymb_i = 5'd7;
    5'd13   : r3_backsymb_i = 5'd15;
    5'd14   : r3_backsymb_i = 5'd11;
    5'd15   : r3_backsymb_i = 5'd13;
    5'd16   : r3_backsymb_i = 5'd9;
    5'd17   : r3_backsymb_i = 5'd5;
    5'd18   : r3_backsymb_i = 5'd2;
    5'd19   : r3_backsymb_i = 5'd6;
    5'd20   : r3_backsymb_i = 5'd26;
    5'd21   : r3_backsymb_i = 5'd3;
    5'd22   : r3_backsymb_i = 5'd23;
    5'd23   : r3_backsymb_i = 5'd22;
    5'd24   : r3_backsymb_i = 5'd10;
    5'd25   : r3_backsymb_i = 5'd1;
    5'd26   : r3_backsymb_i = 5'd20;
    default : r3_backsymb_i = 5'd0;
  endcase
end

endmodule
