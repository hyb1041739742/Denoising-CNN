function [VALUE]=STA_LTA(NLTA,NSTA,x)
CF=0%%%%ÌØÕ÷º¯Êý³õÖµ
imax=length(x)
for i=1:imax
    if i>imax-NSTA
        STA=x(i:imax)
        STAENERGY=sum(STA.*STA)/(imax-i+1)
        STAENERGY=STAENERGY%+(CF-STAENERGY)/(imax-i+1)
    else
        STA=x(i:i+NSTA)
        STAENERGY=sum(STA.*STA)/NSTA
        STAENERGY=STAENERGY%+(CF-STAENERGY)/NSTA
    end
    
    if i>imax-NLTA
        LTA=x(i:imax)
        LTAENERGY=sum(LTA.*LTA)/(imax-i+1)
        LTAENERGY=LTAENERGY%+(CF-LTAENERGY)/(imax-i+1)
    else
        LTA=x(i:i+NLTA)
        LTAENERGY=sum(LTA.*LTA)/NLTA
        LTAENERGY=LTAENERGY%+(CF-LTAENERGY)/NLTA
    end
           CF=STAENERGY/LTAENERGY
           VALUE(i)=CF
end 
end