function B=bispectra(a,lag)  
% ����˫��
% B=bispectra(a,lag)
% a������������row��
% lag���ӳ٣�default=fix[length(a)/2]��

% ----------����---------
% ���ౣ֤˫�׷�ֵ����
kmax=max(a);
kmin=min(a);
if(kmax<-kmin)
    a=-a;
end
% ���������ۻ���
c=c3x(a,lag,'b',0); %���������ۻ���ʱ������ƫ���ƺ����ֵ��  
% ����˫��
B=fft2(ifftshift(c));