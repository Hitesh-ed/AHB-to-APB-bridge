module APB_Slave(input Penable,Pwrite,
		 input [2:0]Pselx,[31:0]Pwdata,Paddr,
		 output reg [31:0]Prdata);

always@(posedge Penable,Pwrite)
begin

	if(Penable&&~Pwrite) Prdata = ($random)%256; 
	
end

endmodule 