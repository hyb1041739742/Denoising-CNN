function thead = SEGY_GetTextHeader
% thead = SEGY_GETTEXTHEADER
% 
% This function returns a simple text header that can be stuck on top of
% a SEGY file. Don't worry about ebcdic or ascii at this point. You will
% get an ascii text header, and that's just fine. When this header is
% written to the SEGY file with the function SEGY_WRITETEXTHEADER then it
% will be converted to ebcdic if necessary.
%
% Chad Hogan, 2004
% $Id: SEGY_GetTextHeader.m,v 1.2 2004/07/30 21:23:34 kwhall Exp $

%      12345678901234567890123456789012345678901234567890123456789012345678901234567890
C1  = 'C 1 CLIENT                        COMPANY  CREWES               CREW NO         ';
C2  = 'C 2 LINE            AREA                        MAP ID                          ';
C3  = 'C 3 REEL NO           DAY-START OF REEL     YEAR      OBSERVER                  ';
C4  = 'C 4 INSTRUMENT: MFG            MODEL            SERIAL NO                       ';
C5  = 'C 5 DATA TRACES/RECORD        AUXILIARY TRACES/RECORD         CDP FOLD          ';
C6  = 'C 6 SAMPLE INTERVAL         SAMPLES/TRACE       BITS/IN      BYTES/SAMPLE       ';
C7  = 'C 7 RECORDING FORMAT        FORMAT THIS REEL        MEASUREMENT SYSTEM          ';
C8  = 'C 8 SAMPLE CODE: FLOATING PT     FIXED PT     FIXED PT-GAIN     CORRELATED      ';
C9  = 'C 9 GAIN  TYPE: FIXED     BINARY     FLOATING POINT     OTHER                   ';
C10 = 'C10 FILTERS: ALIAS     HZ  NOTCH     HZ  BAND     -     HZ  SLOPE    -    DB/OCT';
C11 = 'C11 SOURCE: TYPE            NUMBER/POINT        POINT INTERVAL                  ';
C12 = 'C12     PATTERN:                           LENGTH        WIDTH                  ';
C13 = 'C13 SWEEP: START     HZ  END     HZ  LENGTH      MS  CHANNEL NO     TYPE        ';
C14 = 'C14 TAPER: START LENGTH       MS  END LENGTH       MS  TYPE                     ';
C15 = 'C15 SPREAD: OFFSET        MAX DISTANCE        GROUP INTERVAL                    ';
C16 = 'C16 GEOPHONES: PER GROUP     SPACING     FREQUENCY     MFG          MODEL       ';
C17 = 'C17     PATTERN:                           LENGTH        WIDTH                  ';
C18 = 'C18 TRACES SORTED BY: RECORD     CDP     OTHER                                  ';
C19 = 'C19 AMPLITUDE RECOVERY: NONE      SPHERICAL DIV       AGC    OTHER              ';
C20 = 'C20 MAP PROJECTION                      ZONE ID       COORDINATE UNITS          ';
C21 = 'C21 PROCESSING:                                                                 ';
C22 = 'C22 PROCESSING:                                                                 ';
C23 = '                                                                                ';
C24 = '                                                                                ';
C25 = '                                                                                ';
C26 = '                                                                                ';
C27 = '                                                                                ';
C28 = '                                                                                ';
C29 = '                                                                                ';
C30 = '                                                                                ';
C31 = '                                                                                ';
C32 = '                                                                                ';
C33 = '                                                                                ';
C34 = '                                                                                ';
C35 = '                                                                                ';
C36 = '                                                                                ';
C37 = '                                                                                ';
C38 = '                                                                                ';
C39 = '                                                                                ';
C40 = 'END EBCDIC                                                                      ';

thead = [C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 C16 C17 C18 ...
         C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C30 C31 C32 C33 C34 ...
         C35 C36 C37 C38 C39 C40];
