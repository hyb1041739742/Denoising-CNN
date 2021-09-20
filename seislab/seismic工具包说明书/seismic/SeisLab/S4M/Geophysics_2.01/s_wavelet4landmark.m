function s_wavelet4landmark(wavelet,filename)
% Function writes wavelet to ASCII file in Landmark format.
% Written by: E. R.:
% Last updated: February 14, 2004: error traps installed; 
%               leading/trailing null values and zeros removed
%
%           s_wavelet4landmark(wavelet,filename)
% INPUT
% wavelet   wavelet in form of a seismic structure
% filename  filename (optional)
%           Default: PROGRAM_lmg_wavelet.txt where PROGRAM is the 
%           name of the script which created it


%	Remove null values and leading/trailing zeros
wavelet=s_rm_zeros(s_rm_trace_nulls(wavelet));

[nsamp,ntr]=size(wavelet.traces);
if ntr > 1
   error(' Wavelet has more than one trace')
end

if nargin == 1
   filename=[deblank(wavelet.name),'.txt'];
end

zeroindex=-wavelet.first/wavelet.step;
% data=[nsamp;zeroindex;wavelet.step;wavelet.traces];
text={'Landmark ASCII Wavelet'; ...
       num2str(nsamp);num2str(zeroindex);num2str(wavelet.step)};

try
   wr_columns(filename,wavelet.traces,text)
catch
   fclose all
end

