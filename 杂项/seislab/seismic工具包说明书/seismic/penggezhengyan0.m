clc;clear;
dt=0.001;%rickerwavlet%
f0=5;
t=-63*dt:dt:63*dt;
wb=(1-2*(pi*f0*t).^2).*exp(-(pi*f0*t).^2);
vp1=1000;p1=1;h1=1000;
vp2=2000;p2=1.5;h2=1000;
vp3=3000;p3=2;h3=1000;
t1=2*h1/vp1;
t2=2*h1/vp1+2*h2/vp2;
R1=(p2*vp2-p1*vp1)/(p2*vp2+p1*vp1);
R2=(p3*vp3-p2*vp2)/(p3*vp3+p2*vp2);
n1=round(t1/dt);
n2=round(t2/dt);
R=zeros(n2+round(length(t)/2),16);
for i=1:16
R(n1,i)=R1;
R(n2,i)=R2;
end
for i=1:16
   s(:,i)=conv(R(:,i),wb);
%s=s(round(length(t)/2):length(s),i);
end
plotseis(s);
