function seismic=s_zero_phase(seismic)
% Create the zero-phase equivalent of the input data set
% The output data set is centered at time 0; if the input data set has an
% even number of samples the output data set has one more sample.
% Written by: E. R.: August 3, 2004
% Last updated: 
%
%          seismic=s_zero_phase(seismic)
% INPUT
% seismic  seismic data set to zero-phase
% OUTPUT
% seismic  seismic data set zero-phased

seismic=s_rm_trace_nulls(seismic);

nsamp=size(seismic.traces,1);
if mod(nsamp,2) == 0
   nsamph=nsamp/2+1;
   nsamp=nsamp+1;
else
   nsamph=(nsamp+1)/2;
end
temp=fft(seismic.traces,nsamp);
%       Remove zeros in spectrum
temp=abs(temp);
llimit=max(temp)*1.0e-4;
temp(temp < llimit)=llimit;

temp=complex(temp,zeros(size(temp)));
temp=real(ifft(temp));
seismic.traces=[temp(nsamph+1:end,:);temp(1:nsamph,:)];
seismic.first=-(nsamph-1)*seismic.step;
seismic.last=-seismic.first;

