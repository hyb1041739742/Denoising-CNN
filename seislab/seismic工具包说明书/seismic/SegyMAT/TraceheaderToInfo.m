% TraceHeaderToInfo : Extract traceheader values from structures into an array 
%
%[HeaderInfo]=TraceheaderToInfo(SegyTraceHeaders)

%
% (C) 2001-2002, Thomas Mejer Hansen, tmh@gfy.ku.dk/thomas@cultpenguin.com
%
% OBSOLETE 
%
function [HeaderInfo]=TraceheaderToInfo(SegyTraceHeaders)

     SingleSegyTraceHeaders=SegyTraceHeaders(1);

     S=size(SegyTraceHeaders,2);
     cdp=zeros(1,S);
     offset=zeros(1,S);

     HeaderInfo.cdp=[SegyTraceHeaders.cdp];
     HeaderInfo.offset=[SegyTraceHeaders.offset];
     HeaderInfo.Inline3D= [SegyTraceHeaders.Inline3D];
     HeaderInfo.Crossline3D=[SegyTraceHeaders.Crossline3D];
     HeaderInfo.SourceX=[SegyTraceHeaders.SourceX];
     HeaderInfo.SourceY=[SegyTraceHeaders.SourceY];
     HeaderInfo.GroupX=[SegyTraceHeaders.GroupX];
     HeaderInfo.GroupY=[SegyTraceHeaders.GroupY];    
     HeaderInfo.cdpX=[SegyTraceHeaders.cdpX];
     HeaderInfo.cdpY=[SegyTraceHeaders.cdpY];
     
  HeaderInfo.t = [1:1:SingleSegyTraceHeaders.ns]*SingleSegyTraceHeaders.dt*1e-6 - SingleSegyTraceHeaders.DelayRecordingTime./1000;

