% Log_examples1
%       Example of the usage of log-related functions 

clear all
presets
global S4M
S4M.interactive=0;	% Run without user intervention (turn-off some pop-up 
                        % windows requesting user intervention)

%	Create a synthetic log with a sonic made up from Gaussian noise;
depth=(5000:0.5:10000)';
nsamp=length(depth);
dt=150+25*randn(nsamp,1);
wlog=l_convert([depth,dt],{'depth','ft','Depth';'DTp','us/ft','P-sonic'});
wlog.name='Synthetic log';

%	Add Kelley bushing elevation as a parameter
wlog=add_parameter(wlog,84,{'KBE','ft','Kelly bushing elevation'});

%	Add a trend to the sonic log
wlog=l_curve_math(wlog,'replace','dtp=dtp*(5000/depth)^0.333');

%	Extract sonic curve from log
dtp=l_gc(wlog,'dtp');

%	Use "dtp" to add a curve with P-velocity (curve mnemonic 'Vp')
wlog=l_curve(wlog,'add','Vp',1.0e6./dtp,'ft/s','P-velocity');

%	Use an alternative method to add a density curve computed 
%       via Gardner's formula
wlog=l_curve_math(wlog,'add_ne','rho=0.23*vp^0.25','g/cm3','Density');

%	Plot curves
l_plot(wlog)

%	Change the units of measurement from feet to meter
wlog=l_unit_conversion(wlog,{'ft','m'});

%	Change the units of measurement from feet/second to meters/second
%       and from microseconds/foot to microseconds/meter.
wlog=l_unit_conversion(wlog,{'ft/s','m/s'},{'us/ft','us/m'});

%	Display summary information about the log curves
l_curve(wlog)


%	Compute density trend (requires the Optimization Toolbox)
if exist('fmincon') > 0
   [wlog,aux]=l_regression(wlog,'rho=x1*depth^x2',{'lbounds',0,0}, ...
              {'ubounds',10,1});

%	Compare density with density trend
   l_plot1(wlog,{'curves','rho','rho_pred'})
end
