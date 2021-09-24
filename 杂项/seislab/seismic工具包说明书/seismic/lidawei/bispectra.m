function B=bispectra(a,lag)  
% 计算双谱
% B=bispectra(a,lag)
% a：输入向量（row）
% lag：延迟（default=fix[length(a)/2]）

% ----------程序---------
% 首相保证双谱峰值朝上
kmax=max(a);
kmin=min(a);
if(kmax<-kmin)
    a=-a;
end
% 计算三阶累积量
c=c3x(a,lag,'b',0); %计算三阶累积量时采用有偏估计和零均值化  
% 计算双谱
B=fft2(ifftshift(c));