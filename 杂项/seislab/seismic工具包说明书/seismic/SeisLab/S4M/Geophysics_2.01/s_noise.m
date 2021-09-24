function output=s_noise(seismic,varargin)
% Function computes zero-mean noise with the same structure as the input data set
% Depending on the option chosen the output is either the noise or the imput
% data with the noise added.
% Written by E. R., July 30, 2000
% Last updated: November 5, 2004: Create sample white Gaussion noise if there 
%                                 is no input argument
%
%            output=s_noise(seismic,varargin)
% INPUT
% seismic    seismic structure; (optional if none of the "varargin arguments are 
%            given either; in this case 12 traces if 1 sec of white Gaussian 
%            noise ware generated with 4 ms sample interval).
% varargin   one or more cell arrays; the first element of each cell array is a keyword,
%            the other elements are parameters. Presently, keywords are:
%            'ratio'   ratio of the amplitude of the noise to the "amplitude" of the 
%                 seismic. Default: {'amplitude',1}
%            'amplitude'  describes the way amplitude is measured. Possible options are:
%                 'max' (maximum absolute amplitude) or 'median' (median of the absolute
%                 amplitude). Default: {'type','median'}
%            'type'    type of noise. Possible options are: 'uniform' and 'gaussian'.
%                 Default: {'type','gaussian'}
%            'frequencies'   four corner frequencies of Ormsby filter to apply to the noise
%                 prior to amplitude scaling. 
%                 Default: {'freq',[]} (this implies white noise) 
%            'output'  type of output. Possible values are: 'noise' and 'seismic' (i.e.
%                 noise added to seismic. Default: {'output','noise'}
%            'rnstate'  initial state of the random number generator. Posssible values are 
%                    non-negative integers. Default: {'rnstate',0}        
% OUTPUT
% output     noise or seismic with noise

if nargin == 0
   seismic=s_convert(randn(251,12),0,4);
   seismic.name='Noise';

elseif ~isstruct(seismic)  
   error(' First input data set must be a structure')
end

%       Set defaults
param.amplitude='median';
param.frequencies=[];
param.output='noise';
param.ratio=1;
param.rnstate=0;
param.type='gaussian';

%       Decode and assign input arguments
param=assign_input(param,varargin);



[nsamp,ntr]=size(seismic.traces);

rand('state',param.rnstate);
if strcmpi(param.type,'gaussian')
   temp=randn(nsamp,ntr);
elseif strcmpi(param.type,'uniform')
   temp=rand(nsamp,ntr)-0.5;
else
   error([' Unknown type of noise (',param.type,')'])
end

%       Apply filter if required
if ~isempty(param.frequencies)
   temp=s_filter(s_convert(temp,seismic.first,seismic.step), ...
       {'ormsby',param.frequencies{1},param.frequencies{2}, ...
       param.frequencies{3},param.frequencies{4}});
   temp=temp.traces;
end

%       Determine amplitude scale
if strcmpi(param.amplitude,'median')
   amp=median(median(abs(seismic.traces)));
   ampn=median(median(abs(temp)));
elseif strcmpi(param.amplitude,'max')
   amp=max(max(abs(seismic.traces)));
   ampn=max(max(abs(temp)));
else
   error([' Unknown type of amplitude definition (',param.amplitude,')'])
end

%       Create output
htext=[param.type,' noise; amplitude ratio = ',num2str(param.ratio),' of ',param.amplitude];

if strcmpi(param.output,'seismic')
   output=seismic;
   output.traces=seismic.traces+(param.ratio*amp/ampn)*temp;
   output=s_history(seismic,'append',htext);

elseif strcmpi(param.output,'noise')
   output=s_convert((param.ratio*amp/ampn)*temp,seismic.first,seismic.step);
   output.units=seismic.units;
   output=s_history(output,'add',htext);
 
else
   error([' Unknown type of output (',param.output,')'])
end
                   

