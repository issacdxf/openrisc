////////////////////////////////////////////////////////////////////
//         (C) Copyright 2008, SHHIC Corporation Ltd.             //
//                       ALL RIGHTS RESERVED                      //
//              SHHIC Corporation Ltd. CONFIDENTIAL               //
////////////////////////////////////////////////////////////////////
// Project:             HHIC2403                                  //
// File Name:           bin2gray.v                                //
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


module bin2gray(
  bin,
  gray
  );
input   [8:0] bin;
output  [8:0] gray;

  assign  gray = (bin>>1) ^ bin;

endmodule

