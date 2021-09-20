clc
clear all
S=read_segy_file('E:\File00180.sgy')
%%%%%STA_LTA%%%%%%
x=S.traces(:,5)
CF=0%%%%特征函数初值
imax=length(x)
NSTA=20
NLTA=400%%%%长短时窗大小
for i=1:imax
    if i>imax-NSTA
        STA=x(i:imax)
        STAENERGY=sum(STA.*STA)/(imax-i+1)
        STAENERGY=STAENERGY+(CF-STAENERGY)/(imax-i+1)
    else
        STA=x(i:i+NSTA)
        STAENERGY=sum(STA.*STA)/NSTA
        STAENERGY=STAENERGY+(CF-STAENERGY)/NSTA
    end
    
    if i>imax-NLTA
        LTA=x(i:imax)
        LTAENERGY=sum(LTA.*LTA)/(imax-i+1)
        LTAENERGY=LTAENERGY+(CF-LTAENERGY)/(imax-i+1)
    else
        LTA=x(i:i+NLTA)
        LTAENERGY=sum(LTA.*LTA)/NLTA
        LTAENERGY=LTAENERGY+(CF-LTAENERGY)/NLTA
    end
        CF=STAENERGY/LTAENERGY
        VALUE(i)=CF
end 
   plot(VALUE)
   
