function [D,H] = readsegy(filename,hw,min,max)
%READSEGY: Read SU-SEGY data
%          The data and headers can be  extracted  in 
%          a range given by hw (header words).
%   
%  [D,H] = readsegy(filename,hw,mi,max) returns the data D and
%
%  IN   filename: name of segy
%       hw:       header word to limit number of traces to read
%       min, max: min and maximum value of hw
%
%  OUT  D:        the data (in a matrix) 
%       H:        the header in a structure
%
%
%  example:    [D,H] = readsegy('data','cdp',500,550) will provide
%              the traces and associated headers for traces with the 
%              header word cdp goes from 500 to 550.
%
%  example:    [D,H] = readsegy('data','offset',250,510) like the above
%              example but now the header word 'offset' is used to
%              read traces with offsets in the range 250-500mts.
%
%  example:    [D,H] = readsegy('data') reads everything until end
%              of file.
% 
%  example:    suppose you want to read and extract the offset of
%              each trace:
%              [D,H]=readsegy('data');
%              my_offsets = [D.offset];
%
%
%  Author(s): M.D.Sacchi (sacchi@phys.ualberta.ca)
%  Copyright 1998-2003 SeismicLab
%  Revision: 1.2  Date: Dec/2002
%
%  Signal Analysis and Imaging Group (SAIG)
%  Department of Physics, UofA
%
 
  FID = fopen(filename,'r','n');       % n means native, local machine format


   segy=segy_struct;                   % load the definitions of 
                                       % the header words

   count=count_struct;                 % load the position of 
                                       % each word in the header (in bytes)

   status = fseek(FID,count.ns,'bof'); % go to the beggining of file

   ns = fread(FID,1,segy.ns);          % read ns from first trace
                                       % ns is the number of traces per trace

   total = 60+ns;                      % total nuber of 4bytes words


   max_traces=9999999;                 % maximum number of traces (will
                                       % stop before). The variable status
                                       % will make the code stop when
                                       % the end of file is reached  

 if nargin~=1;
   hc=eval(strcat('count.',hw));       % assigned the header word required  
   hp=eval(strcat('segy.',hw));        % to extract the traces.
 j = 1;                                % counter 
 for k =1:max_traces
   position = total*(k-1)*4+hc;        % where in bytes is the header word
   status = fseek(FID,position,'bof'); 
  if status == 0                       % stop when end of file is reached
    w = fread(FID,1,hp);
     if  w>=min                        % pick traces with a given range
      if w<=max                        % of the desired header word
       position = total*(k-1)*4+count.trace;
       status = fseek(FID,position,'bof'); 
       trace = fread(FID,ns,segy.trace);
       j = j + 1;  
       D(:,j-1)  = trace(:);           % load traces into D
       H(j-1)  = header(FID,ns,k);     % load each header in a structure H
%       disp(j-1)
      end
     end
   else
   sprintf(' Number of traces =  %d',j-1)
  return
 end
 end 


 else 

% when no hw and bounds are given, reads evrything

 for k =1:max_traces
       position = total*(k-1)*4+count.trace;
       status = fseek(FID,position,'bof'); 
       if status == 0                 
       trace = fread(FID,ns,segy.trace);
       D(:,k)  = trace(:);           % load traces into D
       H(k)  = header(FID,ns,k);     % load each header in a structure H
%      disp(k)
   else
   sprintf(' Number of traces =  %d',k-1)
  return
  end
 end 
Ntraces=k-1;
 end 



 [message,errnum] = ferror(FID)
 fclose(FID);

