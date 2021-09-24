function bmu=bmuph(B)
% 双谱相位重构BMU算法
% bmuph(B)：B-双谱数据

% -------------程序------------
phb=angle(B); % 提取双谱相位
[M,N]=size(B);% M,N都为奇数
N=N-1;
M=M-1;
%求s
for k1=2:N/2+1
    ss=0;
    for k2=2:k1
        ss=ss+phb(k2,k1-k2+1);% 使phb(0)不参加运算
    end
    s(k1)=ss;
end
%求ph(1)
ss=0;
for k=2:N/2
    ss=ss+(s(k)-s(k-1))/(k*(k-1));
end
ph=zeros(1,N+1);
ph(N/2+1)=0;%q(0)=pi
ph(N/2+2)=ss+1*pi/(N/2);% 应该是pi/(N/2)
%ph(n)
for k1=2:N/2
    ss=0;
    for k2=1:k1-1 %使q(0)不参加运算
        ss=ss+ph(k2+N/2+1);
    end
    ph(k1+N/2+1)=(2*ss-s(k1))/(k1-1);
end
ph(N/2+1:N+1);
%对称交换
for k=1:N/2
    ph(k)=-ph(N+2-k);
end
%输出赋值
bmu=ifftshift(ph);
%bmu=bmu+phb(1,1); %因为子波头朝上时phb=0,头朝下时phb=pi
