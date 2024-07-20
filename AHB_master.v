module AHB_master( input [31:0]Hrdata,
		   output reg Hclk,Hwrite,Hresetn,Hreadyin,[1:0]Htrans,[31:0]Haddr,[31:0]Hwdata);

always  begin
	Hclk = 1'b1;
	forever #10 Hclk = ~Hclk;
	end


task s_write();
begin   #21;
	Hresetn = 1;
	Htrans = 2'b10;
	Hreadyin = 1;
	Haddr = 32'h80000001;
	Hwrite = 1;
	

	#20;
	Htrans = 2'b00;
	Hreadyin = 0;
	Hwdata = 32'h1234;
	Hwrite = 0;
	
end
endtask

	
end
endtask

endmodule
