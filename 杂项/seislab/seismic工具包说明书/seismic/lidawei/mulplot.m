function mu=mulplot(a,b,c)
% �ص�ͼ����໭����
% mulplot(a,b,c)
% a,b,c�����ݳ�����ͬ��������
% ��ɫ�ֱ�Ϊ���ڡ��졢�̣�����Ϊʵ�ߡ��㻭�ߡ�˫����

% --------����--------
n=length(a);
x=1:n;
if(exist('b')~=1 & exist('c')~=1)
    plot(a,'k-');
elseif(exist('c')~=1)
    if(length(b)~=n)
        error('���ݳ��ȱ�����ͬ');
    end
    plot(x,a,'k-',x,b,'r-.');
else      
    if(length(b)~=n | length(c)~=n)
        error('���ݳ��ȱ�����ͬ');
    end
    plot(x,a,'k-',x,b,'r-.',x,c,'g--');
end