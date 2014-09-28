module project_tb;

//input ports
  logic              clk_i;
  logic              rst_i;
  logic              symb_val_i;
  logic              rrs_rst_i;
  logic        [7:0] symb_numb_i;
  logic signed [6:0] symbol_i;

//output ports
  logic              symb_val_o;
  logic signed [6:0] symbol_o;

	integer i;
  integer j;

  logic [6:0] def_mem [127:0];
  
  integer outfile;

//clock
initial                               
  begin
    clk_i = 1'b0;
    forever
      begin
        #10.0 clk_i = ~clk_i;
      end
  end
  
//reset  
initial                               
  begin
    rst_i = 1'b0;
    #10;
    rst_i = 1'b1;
  end

//only rotors reset  
initial                               
  begin
    rrs_rst_i = 1'b0;
    #10;
    rrs_rst_i = 1'b1;
  end

//incoming symbol is valid
initial
  begin
    symb_val_i = 1'b0;
    @( posedge clk_i );
    @( posedge clk_i );
    symb_val_i = 1'b1;
    #2010;
    @( posedge clk_i );
    symb_val_i = 1'b0;
  end

//symbols' number
initial
  begin
    symb_numb_i = 8'd100;
  end

//reading from file to memory (reading file to wrapper input memory)
initial 
  begin
    symbol_i = 0;
    @( posedge clk_i );
    @( posedge clk_i );
    $readmemb( "in_file.txt", def_mem );
    for ( i = 0; i <= symb_numb_i; i = i + 1 )                      
      begin
        symbol_i = 0;
        symbol_i = def_mem[i];
        @( posedge clk_i );
        symbol_i = 0;
      end
  end
  
//writing final symbols in the file
initial
  begin
    outfile = $fopen( "out_file.txt", "w" );
    j = 0;
      forever begin
        #10 if ( symb_val_o )
          begin
            j = j + 1;
            $fwrite ( outfile, "%b\t", symbol_o );
            @( posedge clk_i );
          end
      end
    $fclose( outfile );
  end

enigma_top et(
  .clk_i        ( clk_i       ),
  .rst_i        ( rst_i       ),
  .symb_val_i   ( symb_val_i  ),
  .rrs_rst_i    ( rrs_rst_i   ),
  .symb_numb_i  ( symb_numb_i ),
  .symbol_i     ( symbol_i    ),

  .symb_val_o   ( symb_val_o  ),
  .symbol_o     ( symbol_o    )
);


endmodule
