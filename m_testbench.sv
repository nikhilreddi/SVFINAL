//////////////////////////////////////////////////////


class stimulus;  /// stimulus generation class
  randc bit a_sign,b_sign;
  randc bit [7:0] a_exponent,b_exponent;
  randc bit [22:0] a_mantissa, b_mantissa;
  
  
  //creating constraints
  constraint con{a_exponent>0 ;
                  a_exponent<255;
                b_exponent>0 ;
                  b_exponent<255;}

endclass

import specialcases::*; // import package



module top;
fp  a_operand ;
fp  b_operand;
logic  [31:0] dut_result;
integer linenum;

        
int pass_count =0;
int fail_count = 0;
int flag_count=0;
logic [31:0]Expected_output;
  
  
Multiplication DUT( a_operand,b_operand, dut_result); 
 
  
  initial begin
    

    
      ///corner test case for underflow ( 2^ -126 x  2^ -1) 
        a_operand=32'b00000000100000000000000000000000;
	b_operand=32'b00111111000000000000000000000000;
    
    
    #1;$display(" %t=time Corner test case for %s , underflow_flag = %b",$time,DUT.Number_form,DUT.underflow_flag);  
    
    				
    
     //corner test case for overflow ( 2^127 x 2^1)
    	#5;a_operand=32'b01111111000000000000000000000000;
	   b_operand=32'b01000000000000000000000000000000;
    #1 $display("  time=%t ,Corner test case for %s , overflow_flag = %b",$time, DUT.Number_form,DUT.overflow_flag);
    
 
  
       //condition to check NAN
    	#5 a_operand = 32'b01111111100001110011111000000000;
    	   b_operand = 32'b01000001100000000000000000000000;
    #1$display("  time=%tCorner test case for %s , NAN_flag = %b",$time ,DUT.Number_form,DUT.nan_flag);
  
    
  	//Test Case to zero flag
    	#5 a_operand = 32'b00000000000000000000000000000000;
    	   b_operand = 32'b01001101100000000000000000000000;
    #1
    $display("  time=%tDirect test case for  %s, Zero_flag = %b",$time,DUT.Number_form,DUT.zero_flag);
    
    
          //Test case for positive infinity
    	#5 a_operand = 32'b01111111100000000000000000000000;
    	   b_operand = 32'b01001101100000000000000000000000;
    #1
    $display("  time=%t Direct test case for  %s, positive _infinity _ flag =",$time,DUT.Number_form, DUT.positive_infinity_flag);
     
    
    	//Test case for negative infinity
    	#5  a_operand = 32'b11111111100000000000000000000000;
    	    b_operand = 32'b01001101100000000000000000000000;
    #1
    $display("  time=%tDirect test case for  %s, negative _infinity _ flag =",$time,DUT.Number_form, DUT.negative_infinity_flag);
    
  end

  
  
  
  
  
  
  
  
		
stimulus s; //creating object handle for class
  initial begin
     #50; 
    
    for(int i =0;i<500;i++)
      begin
        s=new();
        assert(s.randomize())
          else $fatal("error in randomization");
        
        a_operand = {s.a_sign,s.a_exponent,s.a_mantissa};
        b_operand = {s.b_sign,s.b_exponent,s.b_mantissa};
        Expected_output = $shortrealtobits(($bitstoshortreal(a_operand)*$bitstoshortreal(b_operand)));
        
        
        #10;
        
        $display("***********************************************************************");
        
        
        $display(" time=%t,a.sign = %b , a.exponent = %b , a.mantissa = %b \n b.sign = %b, b.exponent = %b , b.mantissa = %b \n Expected_ouput = %b,  dut_result = %b, product = %b, exponent_sum = %b, product_mantissa = %b,number_form = %s",$time, s.a_sign,s.a_exponent,s.a_mantissa,s.b_sign,s.b_exponent,s.b_mantissa,Expected_output,dut_result,DUT.product,DUT.exponent_sum ,DUT.product_mantissa,DUT.Number_form);
        
        
       
        
        $display(" time=%t overflow_flag = %b,underflow_flag = %b,nan_flag = %b, positive_infinity_flag = %b,negative_infinity_flag = %b, zero_flag =%b ",$time ,DUT.overflow_flag,DUT.underflow_flag,DUT.nan_flag, DUT.positive_infinity_flag,DUT.negative_infinity_flag, DUT.zero_flag);
       
        if(( DUT.overflow_flag == 1'b1) || (DUT.underflow_flag == 1'b1)  ||( DUT.nan_flag == 1'b1 ) || (DUT.positive_infinity_flag == 1'b1) || (DUT.negative_infinity_flag == 1'b1) || (DUT.zero_flag) == 1'b1)
        		flag_count = flag_count+1; //If any flags are activated we are not self  checking
        
        else if( Expected_output === dut_result) begin
          		pass_count = pass_count+1;
           	end
       	else  begin
          	   fail_count = fail_count+1;
                   $display(" time=%t failed at a_sign = %b , a_exponent = %b, a_mantissa= %b , b_sign = %b , b_exponent = %b, b_mantissa= %b ",$time,s.a_sign,s.a_exponent,s.a_mantissa,s.b_sign,s.b_exponent,s.b_mantissa);
                   
                   $display("***********************************************************************");
                   
        		end
      end
    
    
    $display(" time=%t pass_count %d, fail_count %d , flag_count %d",$time,pass_count,fail_count,flag_count);
        
#1000;
    
  end
  
 
 


endmodule




