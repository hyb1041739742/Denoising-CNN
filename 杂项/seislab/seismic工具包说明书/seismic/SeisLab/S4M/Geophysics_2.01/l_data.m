function wlog=l_data
% Create a synthetic well log for test and demo purposes; the log curves are not
% based on any rock physics; 
% Written by: E. R.: October 1, 2005;
% Last updated: October 30, 2005: Use power-law to generate curves
%
%      wlog=l_data

param.seed=1111;
param.stdev=2;
param.first=5000;
param.last=10000;
param.step=0.5;
depth=(param.first:param.step:param.last)';
nsamp=length(depth);

%	Set seed for random number generator to assure that the same log 
%       is created each time the function is run
randn('state',param.seed);

curves=zeros(nsamp,6);
curves(:,1)=depth;

temp=create_powerlaw_samples(nsamp,1,-0.5,param.seed);
dt=3000*depth.^(-0.33)+(500./sqrt(depth)).*temp;

vp=1.0e6./dt;

vclay=max((min((3.5+temp),6)/6),0).^0.5;
vclay(vclay < 0.5)=vclay(vclay < 0.5).^2;


curves(:,2)=dt;
curves(:,3)=vp;
curves(:,4)=0.23*curves(:,3).^0.25 + 0.02*randn(nsamp,1);
curves(:,5)=0.7742*vp-884/0.3 + 100*randn(nsamp,1);
curves(:,6)=vclay;

wlog=l_convert(curves,{'depth','ft','Depth';
                       'DTp','us/ft','P-sonic';
		       'Vp','ft/s','P-velocity';
		       'rho','g/cm3','Bulk density';
		       'Vs','ft/s','S-velocity';
		       'Vclay','fraction','Clay volume fraction'});

wlog.name='Synthetic log';

