function a=lkzb(n,f0,m)
%�����׿��Ӳ�
%��ʽ(1-2*(pi*f0*t)^2)*exp(-(pi*f0*t)^2)
%mΪ���������ȱʡΪ1
%f0Ϊ��Ƶ
%t��λΪ��
if(exist('f0') ~= 1)
    f0=30;
end
if(exist('m') ~= 1) 
    m=1;      
end
if(mod(n,2)>0)   
    for t=-(n-1)/2:(n-1)/2
       f(t+(n-1)/2+1)=(1-2*(pi*f0*(m*t/1000))^2)*exp(-(pi*f0*(m*t/1000))^2);       
   end
else    
    for t=(-n/2+1):n/2
        f(t+n/2)=(1-2*(pi*f0*(m*t/1000))^2)*exp(-(pi*f0*(m*t/1000))^2);
    end
end
a=f;