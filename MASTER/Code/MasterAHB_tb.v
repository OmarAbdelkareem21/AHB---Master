`timescale 1ns/100ps

module MasterAHB_tb #(parameter AddresseWidth = 32 , parameter DataWidth = 32 , parameter InWidth = 32  , parameter ControlWidth = 16) ();

	
	
	// Addresse and Control Bus
	 reg [AddresseWidth -1 : 0] InAddresse;
	// Write Data Bus
	 reg [InWidth -1 : 0] InWData;
	// Control Bus 
	 reg [ControlWidth - 1 : 0] InCotrol;
	// OutData
	 wire [DataWidth - 1 : 0] OutRData;
	
	
	// Transfer Response 
	 reg HREADY;
	 reg HRESP;
	
	// Global Signals
	 reg HRESETn;
	 reg HCLK;
	
	//Data
	 reg [DataWidth - 1 : 0] HRDATA;
	
	 wire [AddresseWidth - 1 : 0] HADDR;
	 wire HWRITE;
	 wire [2 : 0] HSIZE;
	 wire [2 : 0] HBURST;
	 wire [1 : 0] HTRANS;
	 wire [DataWidth -1 : 0] HWDATA;
	 
	 integer y = 0;
	// Master Lock and Protection aren't Covered 
	// reg HMASTLOCK,
    // reg [3 : 0] HPORT,	
	
	
	MasterAHB Moo (
	.InAddresse (InAddresse),
	.InWData(InWData),
	.InCotrol(InCotrol),
	.OutRData(OutRData),
	.HREADY(HREADY),
	.HRESP(HRESP),
	.HRESETn(HRESETn),
	.HCLK(HCLK),
	.HRDATA(HRDATA),
	.HADDR(HADDR),
	.HWRITE(HWRITE),
	.HSIZE(HSIZE),
	.HBURST(HBURST),
	.HTRANS(HTRANS),
	.HWDATA(HWDATA)
	);
	
	integer clock = 5;
	always #(clock) HCLK = !HCLK;
	
	reg [2 : 0] WoedSize ;
	reg [2 : 0] SingleBurst ;
	reg [2 : 0] INCRBurst ;
	reg [7 : 0] WriteOp ;
	reg [7 : 0] ReadOp  ;
	reg StopINCR ;
	
	task initialze ;
	begin
		InAddresse = 'D0;
		InCotrol = 'D0;
		InWData = 'd0;
		HREADY = 'd1;
		HRESP = 'D0;
		HCLK = 'd0;
		HRDATA = 'd0;
		WoedSize = 3'b010;
		SingleBurst = 3'b000;
		INCRBurst = 3'b001;
		WriteOp = 8'hAA;
		ReadOp =  8'hBB ;
		StopINCR = 1'd0;
	end
	endtask
	
	task reset ;
	begin
		HRESETn = 'd1;
		#2
		HRESETn = 'd0;
		#2
		#1
		HRESETn = 'd1;
		#5;
	end
	endtask
	
	task TestCase1 ;
	begin
		// Write Two Single Burst Is single No Overlapping 
		InCotrol [10 : 8] = SingleBurst;
		InCotrol [14 : 12] = WoedSize;
		InCotrol [15] = StopINCR;
		InCotrol [11] = 1'd0;
		InCotrol [7 : 0] = WriteOp;
		
		InAddresse = 'hBBCD;
		#10
		InWData = 'h7689;
		InCotrol [7 : 0] = 'h00;
		#10
		if (HWDATA == 'h7689)
			$display ("Test Case 1 is Valid");
		else
			$display ("Test Case 1 isn't Valid");
		
		InCotrol [7 : 0] = 'hAA;
		InAddresse = 'hBcA4;
		#10 ;
		InCotrol [7 : 0] = 'h00;
		InWData = 'h7600;
		#10
	
		if (HWDATA == 'h7600)
			$display ("Test Case 1 is Valid");
		else
			$display ("Test Case 1 isn't Valid");
			
		#10 ;
	end
	endtask
	
	task TestCase2 ;
	begin
			// Write Three Single Burst Is single Overlapping 
		InCotrol [10 : 8] = SingleBurst;
		InCotrol [14 : 12] = WoedSize;
		InCotrol [15] = StopINCR;
		InCotrol [11] = 1'd0;
		InCotrol [7 : 0] = WriteOp;
		
		InAddresse = 'hBBCD;
		#10
		InWData = 'h7689;
		InAddresse = 'hBd6e;
		//InCotrol [7 : 0] = 'h00;
		#10
		if (HWDATA == 'h7689)
			$display ("Test Case 2 is Valid");
		else
			$display ("Test Case 2 isn't Valid");
			

		
		InAddresse = 'hBcA4;
				InWData = 'h7444;
		//InCotrol [7 : 0] = 'h00;
		#10
		if (HWDATA == 'h7444)
			$display ("Test Case 2 is Valid");
		else
			$display ("Test Case 2 isn't Valid");
		
	
		InCotrol [7 : 0] = 'h00;
		InWData = 'h7600;
		#10
	
		if (HWDATA == 'h7600)
			$display ("Test Case 2 is Valid");
		else
			$display ("Test Case 2 isn't Valid");
			
		#10 ;
	end
	endtask
	
	task TestCase3 ;
	begin
			// Write Two Single Burst Is single Overlapping 
		InCotrol [10 : 8] = SingleBurst;
		InCotrol [14 : 12] = WoedSize;
		InCotrol [15] = StopINCR;
		InCotrol [11] = 1'd0;
		InCotrol [7 : 0] = WriteOp;
		
		InAddresse = 'hBBCD;
		#10
		InWData = 'h7689;
		InAddresse = 'hBd6e;
		//InCotrol [7 : 0] = 'h00;
		#10
		if (HWDATA == 'h7689)
			$display ("Test Case 3 is Valid");
		else
			$display ("Test Case 3 isn't Valid");
	
		InCotrol [7 : 0] = 'h00;
		InWData = 'h7600;
		#10
	
		if (HWDATA == 'h7600)
			$display ("Test Case 3 is Valid");
		else
			$display ("Test Case 3 isn't Valid");
			
		#10 ;
	end
	endtask
	

	
	task TestCase4 ;
	begin
		// Write  INCR Burst No Overlapping 
		InCotrol [10 : 8] = INCRBurst;
		InCotrol [14 : 12] = WoedSize;
		InCotrol [15] = StopINCR;
		InCotrol [11] = 1'd0;
		InCotrol [7 : 0] = WriteOp;
		
		InAddresse = 'hBBCD;
		#10
		InWData = 'h7689;
		InCotrol [7 : 0] = 'h00;
		#10
		if (HWDATA == 'h7689)
			$display ("Test Case 4 is Valid");
		else
			$display ("Test Case 4 isn't Valid");
		
		
		InWData = 'h7600;
		#10
		if (HWDATA == 'h7600)
			$display ("Test Case 4 is Valid");
		else
			$display ("Test Case 4 isn't Valid");
			
		InWData = 'h8800;
		#10
		if (HWDATA == 'h8800)
			$display ("Test Case 4 is Valid");
		else
			$display ("Test Case 4 isn't Valid");
			
		InWData = 'h7699;
		InCotrol [15] = 1'd1;
		#10
		if (HWDATA == 'h7699)
			$display ("Test Case 4 is Valid");
		else
			$display ("Test Case 4 isn't Valid");
			
		
			
		#10 ;
	end
	endtask
	
	task TestCase5 ;
	begin
		// Write  INCR Burst No Overlapping 
		InCotrol [10 : 8] = INCRBurst;
		InCotrol [14 : 12] = WoedSize;
		InCotrol [15] = StopINCR;
		InCotrol [11] = 1'd0;
		InCotrol [7 : 0] = WriteOp;
		
		InAddresse = 'hBBCD;
		#10
		InWData = 'h7689;
		InCotrol [7 : 0] = 'h00;
		#10
		if (HWDATA == 'h7689)
			$display ("Test Case 5 is Valid");
		else
			$display ("Test Case 5 isn't Valid");
		
		
		InWData = 'h7600;
		#10
		if (HWDATA == 'h7600)
			$display ("Test Case 5 is Valid");
		else
			$display ("Test Case 5 isn't Valid");
			
		InWData = 'h8800;
		#10
		if (HWDATA == 'h8800)
			$display ("Test Case 5 is Valid");
		else
			$display ("Test Case 5 isn't Valid");
			
		InWData = 'haaaa;
		#10
		if (HWDATA == 'haaaa)
			$display ("Test Case 5 is Valid");
		else
			$display ("Test Case 5 isn't Valid");
			
		InWData = 'hbbbb;
		#10
		if (HWDATA == 'hbbbb)
			$display ("Test Case 5 is Valid");
		else
			$display ("Test Case 5 isn't Valid");
			
		InWData = 'hcccc;
		#10
		if (HWDATA == 'hcccc)
			$display ("Test Case 5 is Valid");
		else
			$display ("Test Case 5 isn't Valid");
			
		InWData = 'h7699;
		InCotrol [15] = 1'd1;
		InCotrol [7 : 0] = 'h00;
		#10
		if (HWDATA == 'h7699)
			$display ("Test Case 5 is Valid");
		else
			$display ("Test Case 5 isn't Valid");
		
			
		#10 ;
	end
	endtask
	
	task TestCase6 ;
	begin
		// Write  INCR Burst Overlapping 
		InCotrol [10 : 8] = INCRBurst;
		InCotrol [14 : 12] = WoedSize;
		InCotrol [15] = StopINCR;
		InCotrol [11] = 1'd0;
		InCotrol [7 : 0] = WriteOp;
		
		InAddresse = 'hBBCD;
		#10
		InWData = 'h7689;
		InCotrol [7 : 0] = 'h00;
		#10
		if (HWDATA == 'h7689)
			$display ("Test Case 6 is Valid");
		else
			$display ("Test Case 6 isn't Valid");
		
		
		InWData = 'h7600;
		#10
		if (HWDATA == 'h7600)
			$display ("Test Case 6 is Valid");
		else
			$display ("Test Case 6 isn't Valid");
			
		InWData = 'h8800;
		#10
		if (HWDATA == 'h8800)
			$display ("Test Case 6 is Valid");
		else
			$display ("Test Case 6 isn't Valid");
			
		InWData = 'h7699;
		InCotrol [15] = 1'd1;
		InCotrol [7 : 0] = 'haa;
		InAddresse = 'hBBCD;
		#10
		InCotrol [15] = 1'd0;
		if (HWDATA == 'h7699)
			$display ("Test Case 6 is Valid");
		else
			$display ("Test Case 6 isn't Valid");
		
		InWData = 'h7689;
		InCotrol [7 : 0] = 'h00;
		#10
		if (HWDATA == 'h7689)
			$display ("Test Case 6 is Valid");
		else
			$display ("Test Case 6 isn't Valid");
		
		
		InWData = 'h7600;
		#10
		if (HWDATA == 'h7600)
			$display ("Test Case 6 is Valid");
		else
			$display ("Test Case 6 isn't Valid");
			
		InWData = 'h8800;
		#10
		if (HWDATA == 'h8800)
			$display ("Test Case 6 is Valid");
		else
			$display ("Test Case 6 isn't Valid");
			
		InWData = 'h7699;
		InCotrol [15] = 1'd1;
		#10
		if (HWDATA == 'h7699)
			$display ("Test Case 6 is Valid");
		else
			$display ("Test Case 6 isn't Valid");
			
		
			
		#10 ;
	end
	endtask
	
	task TestCase7 ;
	begin
		// Read Two Single Burst Is single No Overlapping 
		InCotrol [10 : 8] = SingleBurst;
		InCotrol [14 : 12] = WoedSize;
		InCotrol [15] = StopINCR;
		InCotrol [11] = 1'd0;
		InCotrol [7 : 0] = ReadOp;
		
		InAddresse = 'hBBCD;
		#10
		HRDATA = 'h7689;
		InCotrol [7 : 0] = 'h00;
		#10
		if (OutRData == 'h7689)
			$display ("Test Case 7 is Valid");
		else
			$display ("Test Case 7 isn't Valid");
		
		InCotrol [7 : 0] = ReadOp;
		InAddresse = 'hBcA4;
		#10 ;
		InCotrol [7 : 0] = 'h00;
		HRDATA = 'h7600;
		#10
	
		if (OutRData == 'h7600)
			$display ("Test Case 7 is Valid");
		else
			$display ("Test Case 7 isn't Valid");
			
		#10 ;
	end
	endtask
	
	task TestCase8 ;
	begin
		// Read Three Single Burst Is single Overlapping 
		InCotrol [10 : 8] = SingleBurst;
		InCotrol [14 : 12] = WoedSize;
		InCotrol [15] = StopINCR;
		InCotrol [11] = 1'd0;
		InCotrol [7 : 0] = ReadOp;
		
		InAddresse = 'hBBCD;
		#10
		HRDATA = 'h7689;
		InAddresse = 'hBd6e;
		//InCotrol [7 : 0] = 'h00;
		#10
		if (OutRData == 'h7689)
			$display ("Test Case 8 is Valid");
		else
			$display ("Test Case 8 isn't Valid");
			

		
		InAddresse = 'hBcA4;
		HRDATA = 'h7444;
		//InCotrol [7 : 0] = 'h00;
		#10
		if (OutRData == 'h7444)
			$display ("Test Case 8 is Valid");
		else
			$display ("Test Case 8 isn't Valid");
		
	
		InCotrol [7 : 0] = 'h00;
		HRDATA = 'h7600;
		#10
	
		if (OutRData == 'h7600)
			$display ("Test Case 8 is Valid");
		else
			$display ("Test Case 8 isn't Valid");
			
		#10 ;
	end
	endtask
	
	task TestCase9 ;
	begin
		// Read Two Single Burst Is single Overlapping 
		InCotrol [10 : 8] = SingleBurst;
		InCotrol [14 : 12] = WoedSize;
		InCotrol [15] = StopINCR;
		InCotrol [11] = 1'd0;
		InCotrol [7 : 0] = ReadOp;
		
		InAddresse = 'hBBCD;
		#10
		HRDATA = 'h7689;
		InAddresse = 'hBd6e;
		//InCotrol [7 : 0] = 'h00;
		#10
		if (OutRData == 'h7689)
			$display ("Test Case 9 is Valid");
		else
			$display ("Test Case 9 isn't Valid");
	
		InCotrol [7 : 0] = 'h00;
		HRDATA = 'h7600;
		#10
	
		if (OutRData == 'h7600)
			$display ("Test Case 9 is Valid");
		else
			$display ("Test Case 9 isn't Valid");
			
		#10 ;
	end
	endtask
	

	
	task TestCase10 ;
	begin
		// Read INCR Burst No Overlapping 
		InCotrol [10 : 8] = INCRBurst;
		InCotrol [14 : 12] = WoedSize;
		InCotrol [15] = StopINCR;
		InCotrol [11] = 1'd0;
		InCotrol [7 : 0] = ReadOp;
		
		InAddresse = 'hBBCD;
		#10
		HRDATA = 'h7689;
		InCotrol [7 : 0] = 'h00;
		#10
		if (OutRData == 'h7689)
			$display ("Test Case 10 is Valid");
		else
			$display ("Test Case 10 isn't Valid");
		
		
		HRDATA = 'h7600;
		#10
		if (OutRData == 'h7600)
			$display ("Test Case 10 is Valid");
		else
			$display ("Test Case 10 isn't Valid");
			
		HRDATA = 'h8800;
		#10
		if (OutRData == 'h8800)
			$display ("Test Case 10 is Valid");
		else
			$display ("Test Case 10 isn't Valid");
			
		HRDATA = 'h7699;
		InCotrol [15] = 1'd1;
		#10
		if (OutRData == 'h7699)
			$display ("Test Case 10 is Valid");
		else
			$display ("Test Case 10 isn't Valid");
			
		
			
		#10 ;
	end
	endtask
	
	task TestCase11 ;
	begin
		// Read  INCR Burst No Overlapping 
		InCotrol [10 : 8] = INCRBurst;
		InCotrol [14 : 12] = WoedSize;
		InCotrol [15] = StopINCR;
		InCotrol [11] = 1'd0;
		InCotrol [7 : 0] = ReadOp;
		
		InAddresse = 'hBBCD;
		#10
		HRDATA = 'h7689;
		InCotrol [7 : 0] = 'h00;
		#10
		if (OutRData == 'h7689)
			$display ("Test Case 11 is Valid");
		else
			$display ("Test Case 11 isn't Valid");
		
		
		HRDATA = 'h7600;
		#10
		if (OutRData == 'h7600)
			$display ("Test Case 11 is Valid");
		else
			$display ("Test Case 11 isn't Valid");
			
		HRDATA = 'h8800;
		#10
		if (OutRData == 'h8800)
			$display ("Test Case 11 is Valid");
		else
			$display ("Test Case 11 isn't Valid");
			
		HRDATA = 'haaaa;
		#10
		if (OutRData == 'haaaa)
			$display ("Test Case 11 is Valid");
		else
			$display ("Test Case 11 isn't Valid");
			
		HRDATA = 'hbbbb;
		#10
		if (OutRData == 'hbbbb)
			$display ("Test Case 11 is Valid");
		else
			$display ("Test Case 11 isn't Valid");
			
		HRDATA = 'hcccc;
		#10
		if (OutRData == 'hcccc)
			$display ("Test Case 11 is Valid");
		else
			$display ("Test Case 11 isn't Valid");
			
		HRDATA = 'h7699;
		InCotrol [15] = 1'd1;
		InCotrol [7 : 0] = 'h00;
		#10
		if (OutRData == 'h7699)
			$display ("Test Case 11 is Valid");
		else
			$display ("Test Case 11 isn't Valid");
		
			
		#10 ;
	end
	endtask
	
	task TestCase12 ;
	begin
		// Read  INCR Burst Overlapping 
		InCotrol [10 : 8] = INCRBurst;
		InCotrol [14 : 12] = WoedSize;
		InCotrol [15] = StopINCR;
		InCotrol [11] = 1'd0;
		InCotrol [7 : 0] = ReadOp;
		
		InAddresse = 'hBBCD;
		#10
		HRDATA = 'h7689;
		InCotrol [7 : 0] = 'h00;
		#10
		if (OutRData == 'h7689)
			$display ("Test Case 12 is Valid");
		else
			$display ("Test Case 12 isn't Valid");
		
		
		HRDATA = 'h7600;
		#10
		if (OutRData == 'h7600)
			$display ("Test Case 12 is Valid");
		else
			$display ("Test Case 12 isn't Valid");
			
		HRDATA = 'h8800;
		#10
		if (OutRData == 'h8800)
			$display ("Test Case 12 is Valid");
		else
			$display ("Test Case 12 isn't Valid");
			
		HRDATA = 'h7699;
		InCotrol [15] = 1'd1;
		InCotrol [7 : 0] = ReadOp;
		InAddresse = 'hBBCD;
		#10
		InCotrol [15] = 1'd0;
		if (OutRData == 'h7699)
			$display ("Test Case 12 is Valid");
		else
			$display ("Test Case 12 isn't Valid");
		
		HRDATA = 'h7689;
		InCotrol [7 : 0] = 'h00;
		#10
		if (OutRData == 'h7689)
			$display ("Test Case 12 is Valid");
		else
			$display ("Test Case 12 isn't Valid");
		
		
		HRDATA = 'h7600;
		#10
		if (OutRData == 'h7600)
			$display ("Test Case 12 is Valid");
		else
			$display ("Test Case 12 isn't Valid");
			
		HRDATA = 'h8800;
		#10
		if (OutRData == 'h8800)
			$display ("Test Case 12 is Valid");
		else
			$display ("Test Case 12 isn't Valid");
			
		HRDATA = 'h7699;
		InCotrol [15] = 1'd1;
		#10
		if (OutRData == 'h7699)
			$display ("Test Case 12 is Valid");
		else
			$display ("Test Case 12 isn't Valid");
			
		
			
		#10 ;
	end
	endtask
	
	task TestCase13 ;
	begin
		// Write Two Single Burst Is single No Overlapping - HREADY
		InCotrol [10 : 8] = SingleBurst;
		InCotrol [14 : 12] = WoedSize;
		InCotrol [15] = StopINCR;
		InCotrol [11] = 1'd0;
		InCotrol [7 : 0] = WriteOp;
		
		InAddresse = 'hBBCD;
		#10
		InWData = 'h7689;
		InCotrol [7 : 0] = 'h00;
		#10
		if (HWDATA == 'h7689)
			$display ("Test Case 13 is Valid");
		else
			$display ("Test Case 13 isn't Valid");
		
		
		InCotrol [7 : 0] = 'hAA;
		InAddresse = 'hBcA4;
		#10 ;
		HREADY = 1'D0;
		InCotrol [7 : 0] = 'h00;
		InWData = 'h7600;
		#10
		if (HWDATA != 'h7600)
			$display ("Test Case 13 is Valid");
		else
			$display ("Test Case 13 isn't Valid");
		HREADY = 1'D1;	
		#10 ;
		
		if (HWDATA == 'h7600)
			$display ("Test Case 13 is Valid");
		else
			$display ("Test Case 13 isn't Valid");
			
		#10 ;
		
	end
	endtask
	
	task TestCase14 ;
	begin
		// Read  INCR Burst No Overlapping - HREADY
		InCotrol [10 : 8] = INCRBurst;
		InCotrol [14 : 12] = WoedSize;
		InCotrol [15] = StopINCR;
		InCotrol [11] = 1'd0;
		InCotrol [7 : 0] = ReadOp;
		
		InAddresse = 'hBBCD;
		#10
		HRDATA = 'h7689;
		InCotrol [7 : 0] = 'h00;
		#10
		if (OutRData == 'h7689)
			$display ("Test Case 14 is Valid");
		else
			$display ("Test Case 14 isn't Valid");
		
		
		HRDATA = 'h7600;
		#10
		if (OutRData == 'h7600)
			$display ("Test Case 14 is Valid");
		else
			$display ("Test Case 14 isn't Valid");
			
		HRDATA = 'h8800;
		HREADY = 1'D0;
		#20
		if (OutRData != 'h8800)
			$display ("Test Case 14 is Valid");
		else
			$display ("Test Case 14 isn't Valid");
			
		HREADY = 1'D1;
		#10
		if (OutRData == 'h8800)
			$display ("Test Case 14 is Valid");
		else
			$display ("Test Case 14 isn't Valid");
			
		
			
		HRDATA = 'h7699;
		InCotrol [15] = 1'd1;
		InCotrol [7 : 0] = 'h00;
		#10
		if (OutRData == 'h7699)
			$display ("Test Case 14 is Valid");
		else
			$display ("Test Case 14 isn't Valid");
		
			
		#10 ;
	end
	endtask
	
	task TestCase15 ;
	begin
		// Read INCR Burst No Overlapping - Busy Back to ideal
		InCotrol [10 : 8] = INCRBurst;
		InCotrol [14 : 12] = WoedSize;
		InCotrol [15] = StopINCR;
		InCotrol [11] = 1'd0;
		InCotrol [7 : 0] = ReadOp;
		
		InAddresse = 'hBBCD;
		#10
		HRDATA = 'h7689;
		InCotrol [7 : 0] = 'h00;
		#10
		
		HRDATA = 'h7600;
		#10
			
		InCotrol [11] = 1'D1;	
		HRDATA = 'h8800;
		#10
		if (HADDR == 'hBBCD +12)
			$display ("Test Case 15 is Valid");
		else
			$display ("Test Case 15 isn't Valid");
		
		if (OutRData == 'h8800)
			$display ("Test Case 15 is Valid");
		else
			$display ("Test Case 15 isn't Valid");
		
		InCotrol [11] = 1'D0;
		#10
	
			
		HRDATA = 'h7699;
		InCotrol [15] = 1'd1;
		#10
		
			
		#10 ;
	end
	endtask
	
	task TestCase16 ;
	begin
		// Read INCR Burst No Overlapping - Busy Back to SEQ
		InCotrol [10 : 8] = INCRBurst;
		InCotrol [14 : 12] = WoedSize;
		InCotrol [15] = StopINCR;
		InCotrol [11] = 1'd0;
		InCotrol [7 : 0] = ReadOp;
		
		InAddresse = 'hBBCD;
		#10
		HRDATA = 'h7689;
		InCotrol [7 : 0] = 'h00;
		#10
		
		HRDATA = 'h7600;
		#10
			
		InCotrol [11] = 1'D1;
		HREADY = 1'D0;
		HRDATA = 'h8800;
		#10
		if (HADDR == 'hBBCD +12)
			$display ("Test Case 16 is Valid");
		else
			$display ("Test Case 16 isn't Valid");
		
		if (OutRData == 'h8800)
			$display ("Test Case 16 is Valid");
		else
			$display ("Test Case 16 isn't Valid");
		
		InCotrol [11] = 1'D0;
		InCotrol [7 : 0] = 'hcc;
		HRDATA = 'h8899;
		#10
		if (OutRData == 'h8800)
			$display ("Test Case 16 is Valid");
		else
			$display ("Test Case 16 isn't Valid");
			
		HRDATA = 'h7699;
		HREADY = 1'D1;
		InCotrol [15] = 1'd1;
		#10
		if (OutRData == 'h7699)
			$display ("Test Case 16 is Valid");
		else
			$display ("Test Case 16 isn't Valid");
		#10
		
			
		#10 ;
	end
	endtask
	
	
	
	
	initial
	begin
	
		
		initialze ();
		reset ();
		
		// Write Operation Tests
		TestCase1 ();
		TestCase2 ();
		TestCase3 ();
		TestCase4 ();
		TestCase5 ();
		TestCase6 ();
		
		// Read Operartion Tests 
		TestCase7 ();
		TestCase8 ();
		TestCase9 ();
		TestCase10 ();
		TestCase11 ();
		TestCase12 ();
		
		// HREADY
		TestCase13 ();
		TestCase14 ();
		TestCase15();
		TestCase16();
		$stop;
		
	end
	
endmodule 