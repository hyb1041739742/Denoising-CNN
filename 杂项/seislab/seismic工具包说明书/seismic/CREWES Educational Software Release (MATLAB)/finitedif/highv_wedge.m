% HIGHV_WEDGE: model an anticline beneath a high velocity wedge
%
% high velocity wedge
% Just run the script
dx=5; %cdp interval
xmax=2500;zmax=1000; %maximum line length and maximum depth
xpinch=1500; % wedge pinchout coordinates
zwedge=zmax/2; % wedge maximum depth
x=0:dx:xmax; % x coordinate vector
z=0:dx:zmax; % z coordinate vector
vhigh=4000;vlow=2000; % high and low velocities

%initialize velocity matrix as a constant matrix full of vlow
vel=vlow*ones(length(z),length(x));

% define the wedge as a three point polygon
dx2=dx/2;
xpoly=[-dx2 xpinch -dx2];zpoly=[-1 -1 zwedge];

% install the wedge in the velocity matrix
vel=afd_vmodel(dx,vel,vhigh,xpoly,zpoly);

% define an anticline beneath the wedge

x0=xpinch/2;z0=zwedge+100; % x and z of the crest of the anticline
a=.0005; % a parameter that determines the steepness of the flanks
za=a*(x-x0).^2+z0; % model the anticline as a parabola

% build a polygon that models the anticline
ind=near(za,zmax+dx);
xpoly=[x(1:ind) 0 ];zpoly=[za(1:ind) za(ind)];

%install the anticline in the velocity model
vel=afd_vmodel(dx,vel,vhigh,xpoly,zpoly);

% bottom layer
xpoly=[0 xmax xmax 0];zpoly=[.9*zmax .9*zmax zmax+dx zmax+dx];

vel=afd_vmodel(dx,vel,vhigh,xpoly,zpoly);

%plot the velocity model
plotimage(vel-.5*(vhigh+vlow),z,x)
xlabel('meters');ylabel('meters')
velfig=gcf;

disp(' Type 1 for a shot record, 2 for a VSP, 3 for exploding reflector, <CR> to end')
r=input(' response -> ')

while ~isempty(r)
switch(r)
case{1}
	%do a shot record
	disp(' Type 1 for 2nd order Laplacian, 2 for 4th order Laplacian')
	lap=input(' response-> ');
	dt=.004; %temporal sample rate
	dtstep=.0005;%time step size
	tmax=2*zmax/vlow; %maximum time
	snap1=zeros(size(vel));
	xshot=max(x)/3;
	snap2=snap1; ix=near(x,xshot);
	snap2(1,ix(1))=1;
	[shotf,shot,t]=afd_shotrec(dx,dtstep,dt,tmax, ...
 		vel,snap1,snap2,x,zeros(size(x)),[5 10 40 50],0,lap);
	figure(velfig)
	line(xshot,0,1,'marker','*','markersize',6,'color','r');
	text(xshot+.02*(max(x)-min(x)),0,1,'shot point','color','r');
	%plot the seismogram
	plotimage(shotf,t,x-xshot)
   xlabel('offset');ylabel('seconds');
case{2}
	%do a vsp reflector model
	disp(' Type 1 for 2nd order Laplacian, 2 for 4th order Laplacian')
	lap=input(' response-> ');
	dt=.004; %temporal sample rate
	dtstep=.0005;%time step size
	tmax=2*zmax/vlow; %maximum time
	snap1=zeros(size(vel));
	xshot=max(x)/4;
	snap2=snap1; ix=near(x,xshot);
	snap2(1,ix(1))=1;
	izrec=near(z,max(z)/4,3*max(z)/4);
	zrec=z(izrec);
	xrec=(max(x)/3)*ones(size(zrec));
	[vspf,vsp,t]=afd_shotrec(dx,dtstep,dt,tmax, ...
 		vel,snap1,snap2,xrec,zrec,[5 10 40 50],0,lap);
	figure(velfig)
	line(xshot,0,1,'marker','*','markersize',6,'color','g');
	text(xshot+.02*(max(x)-min(x)),0,1,'vsp shot','color','g');
	line(xrec,zrec,ones(size(zrec)),'marker','v','markersize',6,'color','g');
	%plot the vsp
	plotimage(vspf',zrec,t)%vsp's are normally plotted with depth as vert coordinate
   ylabel('depth');xlabel('seconds');
case{3}
	%do an exploding reflector model
	disp(' Type 1 for 2nd order Laplacian, 2 for 4th order Laplacian')
	lap=input(' response-> ');
	dt=.004; %temporal sample rate
	dtstep=.001;
	tmax=2*zmax/vlow; %maximum time
	[seisfilt,seis,t]=afd_explode(dx,dtstep,dt,tmax, ...
 		vel,x,zeros(size(x)),[5 10 40 50],0,lap);
	%plot the seismogram
	plotimage(seisfilt,t,x)
   xlabel('meters');ylabel('seconds')
otherwise
	disp('invalid selection')
end

disp(' Type 1 for a shot record, 2 for a VSP, 3 for exploding reflector, <CR> to end')
r=input(' response ->')

end


