function bmu=bmuph(B)
% ˫����λ�ع�BMU�㷨
% bmuph(B)��B-˫������

% -------------����------------
phb=angle(B); % ��ȡ˫����λ
[M,N]=size(B);% M,N��Ϊ����
N=N-1;
M=M-1;
%��s
for k1=2:N/2+1
    ss=0;
    for k2=2:k1
        ss=ss+phb(k2,k1-k2+1);% ʹphb(0)���μ�����
    end
    s(k1)=ss;
end
%��ph(1)
ss=0;
for k=2:N/2
    ss=ss+(s(k)-s(k-1))/(k*(k-1));
end
ph=zeros(1,N+1);
ph(N/2+1)=0;%q(0)=pi
ph(N/2+2)=ss+1*pi/(N/2);% Ӧ����pi/(N/2)
%ph(n)
for k1=2:N/2
    ss=0;
    for k2=1:k1-1 %ʹq(0)���μ�����
        ss=ss+ph(k2+N/2+1);
    end
    ph(k1+N/2+1)=(2*ss-s(k1))/(k1-1);
end
ph(N/2+1:N+1);
%�Գƽ���
for k=1:N/2
    ph(k)=-ph(N+2-k);
end
%�����ֵ
bmu=ifftshift(ph);
%bmu=bmu+phb(1,1); %��Ϊ�Ӳ�ͷ����ʱphb=0,ͷ����ʱphb=pi
