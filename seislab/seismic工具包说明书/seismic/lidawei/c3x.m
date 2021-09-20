function temp=c3x(data,maxlag,ifbiased,ifaverage)
% ���������ۻ���
% temp=c3x(data,maxlag,ifbiased,ifaverage)
% data���������ݣ�row��
% maxlag������ӳ���
% ifbiased��ifbiased='biased'��ifbiased=0Ϊ��ƫ���ƣ���ƫ���Ƴ����в����ƣ�default=0��
% ���ifaverage=0��ifbiased='y',������ȡƽ��������ȡƽ����default=0��
% temp���������

% ------------------����--------------------
if(exist('maxlag')~=1)
    maglag=fix(length(data)/2);
end
if(exist('ifbiased')~=1)
    ifbiased=0;
end
if(exist('ifaverage')~=1)
    ifaverage=0;
end
x=data;
m=maxlag;
n=m;
N=length(x);
if(ifaverage==0 | ifaverage(1)=='y' | ifaverage(1)=='Y')
    aa=mean(x);
    x=x-aa;
end                
if(ifbiased==0 | ifbiased(1)=='b' | ifbiased(1)=='B') %�ж�ƫ������ޣ�����������жϣ�����ѭ�����жϴ���   
    ifbiased=0;
end
temp(1:2*m+1,1:2*n+1)=0;
for t1=-m:m
    for t2=-n:n 
        if((t1>=t2 & t2>=0) | (t1<=0 & t2>=0 & t2-t1>=n) | (t1>0 & t2<0 & t1-t2>=n))               
            k1=max(0,max(-t1,-t2));
            k2=min(N-1,min(N-1-t1,N-1-t2));
            s=0;
            for k=k1:k2   
                if(ifbiased==0)     %�ж�ƫ�������         
                    nn=N;   
                else
                    nn=k2-k1;
                end
                s=s+x(k+1)*x(k+t1+1)*x(k+t2+1)/nn;
            end        
            temp(m+1+t1,n+1+t2)=s;            
        end
    end
end
for t1=-m:m
    for t2=-n:n 
        if(t2>t1 & t1>=0)                 
            temp(m+1+t1,n+1+t2)=temp(m+1+t2,n+1+t1);            
        elseif(t1<=0 & t2<=0 & t1>=t2)%������
            temp(m+1+t1,n+1+t2)=temp(m+1-t2,n+1+t1-t2);
        elseif(t1>=0 & t2<=0 & t1-t2<=n)
            temp(m+1+t1,n+1+t2)=temp(m+1+t1-t2,n+1-t2);
        elseif(t2>=0 & t1<=0 & t2-t1<=n)
            temp(m+1+t1,n+1+t2)=temp(m+1+t2-t1,n+1-t1);
        elseif(t1<=0 & t2>=t1 & t2<=0)%������
            temp(m+1+t1,n+1+t2)=temp(m+1-t1,n+1+t2-t1);
        end                    
    end
end