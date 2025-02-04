`timescale 1ns / 1ps
/**
 * $Id: red_pitaya_asg_tb.v 1271 2014-02-25 12:32:34Z matej.oblak $
 *
 * @brief Red Pitaya guitar module testbench.
 *
 * @Author Eva Šegatin
 *
 * (c) Red Pitaya  http://www.redpitaya.com
 *
 * This part of code is written in Verilog hardware description language (HDL).
 * Please visit http://en.wikipedia.org/wiki/Verilog
 * for more details on the language used herein.
 */


module red_pitaya_guitar_tb(
);

reg            adc_clk    ;
reg            adc_rstn   ;
reg  [14-1: 0] in_sound   ;  
reg  [14-1: 0] in_gen     ;
wire [14-1: 0] out_sound  ;

reg              sys_clk         ;
reg              sys_rstn        ;
wire  [ 32-1: 0] sys_addr        ;
wire  [ 32-1: 0] sys_wdata       ;
wire  [  4-1: 0] sys_sel         ;
wire             sys_wen         ;
wire             sys_ren         ;
wire  [ 32-1: 0] sys_rdata       ;
wire             sys_err         ;
wire             sys_ack         ;

reg [14-1: 0] dac_a             ;
reg [14-1: 0] dac_b             ;
wire [16-1: 0] guitar_dac        ;
//wire [16-1: 0] guitar_dac_n      ;

wire [14-1: 0] dac_dat          ;
wire           dac_wrt          ;
wire           dac_sel          ;
wire           dac_clk          ;
wire           dac_rst          ;


 


//red_pitaya_analog i_analog
//(
//  // ADC IC
//  .adc_dat_a_i        (        ),  // CH 1
//  .adc_dat_b_i        (        ),  // CH 2
//  .adc_clk_p_i        (  adc_clk      ),  // data clock
//  .adc_clk_n_i        (  !adc_clk      ),  // data clock
  
//  // DAC IC
//  .dac_dat_o          (  dac_dat        ),  // combined data
//  .dac_wrt_o          (  dac_wrt        ),  // write enable
//  .dac_sel_o          (  dac_sel        ),  // channel select
//  .dac_clk_o          (  dac_clk        ),  // clock
//  .dac_rst_o          (  dac_rst        ),  // reset
  
//  // PWM DAC
//  .dac_pwm_o          (          ),  // serial PWM DAC
  
  
//  // user interface
//  .adc_dat_a_o        (            ),  // ADC CH1
//  .adc_dat_b_o        (            ),  // ADC CH2
//  .adc_clk_o          (            ),  // ADC received clock
//  .adc_rst_i          (  adc_rstn ),  // reset - active low
//  .ser_clk_o          (            ),  // fast serial clock

//  .dac_dat_a_i        (  dac_a       ),  // DAC CH1      
//  .dac_dat_b_i        (  dac_b       ),  // DAC CH2

//  .dac_pwm_a_i        (          ),  // slow DAC CH1
//  .dac_pwm_b_i        (          ),  // slow DAC CH2
//  .dac_pwm_c_i        (          ),  // slow DAC CH3
//  .dac_pwm_d_i        (          ),  // slow DAC CH4
//  .dac_pwm_sync_o     (           )   // slow DAC sync
//);



red_pitaya_guitar_top i_guitar
(
    .clk_i        (   adc_clk                      ),
    .rstn_i       (   adc_rstn                     ),
    .in_sound_i   (   in_sound                     ),
    .in_gen_i     (   in_gen                       ),
    .out_sound_o  (   guitar_dac                   ),
    
    //axi
    .sys_clk_i       (  sys_clk                    ),  // clock
    .sys_rstn_i      (  sys_rstn                   ),  // reset - active low
    .sys_addr_i      (  sys_addr                   ),  // address
    .sys_wdata_i     (  sys_wdata                  ),  // write data
    .sys_sel_i       (  sys_sel                    ),  // write byte select
    .sys_wen_i       (  sys_wen                    ),  // write enable
    .sys_ren_i       (  sys_ren                    ),  // read enable
    .sys_rdata_o     (  sys_rdata                  ),  // read data
    .sys_err_o       (  sys_err                    ),  // error indicator
    .sys_ack_o       (  sys_ack                    )   // acknowledge signal
    
);


sys_bus_model i_bus
(
  .sys_clk_i      (  sys_clk      ),
  .sys_rstn_i     (  sys_rstn     ),
  .sys_addr_o     (  sys_addr     ),
  .sys_wdata_o    (  sys_wdata    ),
  .sys_sel_o      (  sys_sel      ),
  .sys_wen_o      (  sys_wen      ),
  .sys_ren_o      (  sys_ren      ),
  .sys_rdata_i    (  sys_rdata    ),
  .sys_err_i      (  sys_err      ),
  .sys_ack_i      (  sys_ack      ) 
);


//make overflow detection for output signal
//assign guitar_dac_n <= ~guitar_

//always @ (*)
//begin
//    if (|guitar_dac)
//    begin
//        if (guitar_dac[15:14] == 2'b10)
//            dac_a <= 14'h2000;
//        else if (guitar_dac[15:14] == 2'b01)
//            dac_a <= 14'h1FFF;
//        else
//            dac_a <= {guitar_dac[15], guitar_dac[12:0]};
            
//        if (guitar_dac[15:14] == 2'b10)
//            dac_b <= 14'h2000;
//        else if (guitar_dac[15:14] == 2'b01)
//            dac_b <= 14'h1FFF;
//        else
//            dac_b <= {guitar_dac[15], guitar_dac[12:0]};
//     end                          
//end


// signal generation

initial begin
   sys_clk  <= 1'b0 ;
   sys_rstn <= 1'b0 ;
   repeat(20) @(posedge sys_clk);
      sys_rstn <= 1'b1  ;
end

always begin
   #5  sys_clk <= !sys_clk ;
end



initial begin
   adc_clk  <= 1'b0  ;
   adc_rstn <= 1'b0  ;
   repeat(20) @(posedge adc_clk);
      adc_rstn <= 1'b1  ;
end

always begin
   #4  adc_clk <= !adc_clk ;
end

//execute bench
initial begin
fork
    sine();
    begin
    wait (sys_rstn);
    
//system
    @(posedge adc_clk)
        i_bus.bus_write(32'h0, 32'h1);
    @(posedge adc_clk)
        i_bus.bus_write(32'h8, 32'h1);
    
    #500000;
    @(posedge adc_clk)
        i_bus.bus_write(32'h8, 32'h2);
//    @(posedge adc_clk)
//        i_bus.bus_write(32'h18, 32'h1);
////read back
//    @(posedge adc_clk)
//        i_bus.bus_read(32'h0);
//    @(posedge adc_clk)
//        i_bus.bus_read(32'h8);
//    @(posedge adc_clk)
//        i_bus.bus_read(32'h18);
        
////distortion settings
//    @(posedge adc_clk)
//        i_bus.bus_write(32'h10, 32'h0);
    @(posedge adc_clk)
        i_bus.bus_write(32'h88, 32'h5);
    @(posedge adc_clk)
         i_bus.bus_write(32'h90, 32'h2);
//    @(posedge adc_clk)
//        i_bus.bus_write(32'h90, 32'h0);   
////read back
//    @(posedge adc_clk)
//        i_bus.bus_read(32'h10);
//    @(posedge adc_clk)
//        i_bus.bus_read(32'h88);
//    @(posedge adc_clk)
//        i_bus.bus_read(32'h90);

////delay settings
//    @(posedge adc_clk)
//        i_bus.bus_write(32'h100, 32'hf);
//    @(posedge adc_clk)
//        i_bus.bus_write(32'h108, 32'hf);
////read back
//    @(posedge adc_clk)
//        i_bus.bus_read(32'h100);
//    @(posedge adc_clk)
//        i_bus.bus_read(32'h108);

////octaver settings
//    @(posedge adc_clk)
//        i_bus.bus_write(32'h180, 32'hff);
////read back
//    @(posedge adc_clk)
//        i_bus.bus_read(32'h180);
    
    end
join
end



//input sine

task sine;
    reg     [31: 0] cnt        ;
    reg     [31: 0] sin_cnt    ;
    real            sin_time   ;
    real            sin_a      ;
    integer         sin_aa     ;
    real            sin_cnta   ;
    reg    [31: 0] freq       ;
    //wire     [31: 0] freq = 32'd979553945
begin
    freq     <= 32'h20000;
    cnt      <= 32'h0   ;
    sin_cnt  <= 0       ;

    #20

    while ( cnt < 1000000 ) 
    begin

        @(posedge adc_clk) 
        begin
            cnt <= cnt + 1  ;
            if (cnt > 32'd10) 
            begin
                sin_cnt  = sin_cnt + freq         ;
//                $display("sin_cnt %b", sin_cnt);
                sin_cnta = {1'b0,sin_cnt[31:22]} ;
//                $display("sin_cnta %d", sin_cnt[31:22])       ;
                sin_time = sin_cnta/1024 * 2 *  3.141592           ;
                sin_a    = $sin(sin_time) * 1000  ;
                sin_aa   = sin_a;
            end

           in_sound <= sin_aa[13:0]  ;
       end
    end
end
endtask
 
 
endmodule
