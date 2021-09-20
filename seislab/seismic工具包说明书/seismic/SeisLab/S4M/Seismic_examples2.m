% Seismic_examples2
%       Example of the usage of seismic functions 

clear all
presets
global S4M


%       Create a minimum-phase wavelet
wavelet=s_create_wavelet({'type','min-phase'},{'step',1});

%       Create constant-Q filters for Q = 150,100,80,60 and 1 sec tracel time
qfilters=s_create_qfilter({'q',[300,100,80,60]},{'times',1000},{'step',1});

%       Convolve the constant-Q filters with the wavelet
qwavelets=s_convolve(qfilters,wavelet);

%       Prepend the original wavelet (since the original wavelet is shorter 
%       than the filtered ones the missing samples are, by default, set to 
%       NaN's; this will give a warning in R 14, if the data set is plotted}
wavelets=s_append(wavelet,qwavelets);

%	Give the data set "wavelets" a descriptive name
wavelets.name='Original wavelet and its Q-filtered versions';

%       Plot the result with the following conditions:
%         plot only the first 200 ms;
%         annotate traces 2 to 5 with the Q-value of the filter (the Q-value
%             of the first trace is NaN as it is the original wavelet); 
%         fill the wiggle troughs with light gray
s_wplot(wavelets,{'times',0,200},{'aindex',2:5},{'annotation','Q'}, ...
       {'trough_fill',[0.7,0.7,0.7]});
