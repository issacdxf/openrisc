////////////////////////////////////////////////////////////////////
//         (C) Copyright 2008, SHHIC Corporation Ltd.             //
//                       ALL RIGHTS RESERVED                      //
//              SHHIC Corporation Ltd. CONFIDENTIAL               //
////////////////////////////////////////////////////////////////////
// Project:             HHIC2403                                  //
// File Name:           gray2bin.v                                //
// Author:              He YuMing                                 //
// Email:               heyuming@shhic.com                        //
// Description:                                                   //
// Hierarchy: parent:   afifo.v                                   //
//            child :                                             //
//                                                                //
// Revision History:                                              //
// Version   Date         By Who       Modification               //
// V1.0     06/10/2008   He YuMing     create                     //
//                                                                //
////////////////////////////////////////////////////////////////////

`timescale 1ns/10ps


module gray2bin(
  gray,
  bin
  );

input   [8:0] gray;
output  [8:0] bin;

  assign  bin[0] = gray[8] ^ gray[7] ^ gray[6] ^ gray[5] ^ gray[4] ^ gray[3] ^ gray[2] ^ gray[1] ^ gray[0];
  assign  bin[1] = gray[8] ^ gray[7] ^ gray[6] ^ gray[5] ^ gray[4] ^ gray[3] ^ gray[2] ^ gray[1];
  assign  bin[2] = gray[8] ^ gray[7] ^ gray[6] ^ gray[5] ^ gray[4] ^ gray[3] ^ gray[2];
  assign  bin[3] = gray[8] ^ gray[7] ^ gray[6] ^ gray[5] ^ gray[4] ^ gray[3];
  assign  bin[4] = gray[8] ^ gray[7] ^ gray[6] ^ gray[5] ^ gray[4];
  assign  bin[5] = gray[8] ^ gray[7] ^ gray[6] ^ gray[5];
  assign  bin[6] = gray[8] ^ gray[7] ^ gray[6];
  assign  bin[7] = gray[8] ^ gray[7];
  assign  bin[8] = gray[8];

endmodule
