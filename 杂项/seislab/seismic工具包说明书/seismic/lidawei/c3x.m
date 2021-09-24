function temp=c3x(data,maxlag,ifbiased,ifaverage)
% 计算三阶累积量
% temp=c3x(data,maxlag,ifbiased,ifaverage)
% data：输入数据（row）
% maxlag：最大延迟量
% ifbiased：ifbiased='biased'或ifbiased=0为有偏估计，无偏估计程序尚不完善（default=0）
% 如果ifaverage=0或ifbiased='y',则将输入取平均，否则不取平均（default=0）
% temp：数据输出

% ------------------程序--------------------
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
if(ifbiased==0 | ifbiased(1)=='b' | ifbiased(1)=='B') %判断偏插的有无，在这里初步判断，减少循环中判断次数   
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
                if(ifbiased==0)     %判断偏插的有无         
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
        elseif(t1<=0 & t2<=0 & t1>=t2)%三象线
            temp(m+1+t1,n+1+t2)=temp(m+1-t2,n+1+t1-t2);
        elseif(t1>=0 & t2<=0 & t1-t2<=n)
            temp(m+1+t1,n+1+t2)=temp(m+1+t1-t2,n+1-t2);
        elseif(t2>=0 & t1<=0 & t2-t1<=n)
            temp(m+1+t1,n+1+t2)=temp(m+1+t2-t1,n+1-t1);
        elseif(t1<=0 & t2>=t1 & t2<=0)%三象线
            temp(m+1+t1,n+1+t2)=temp(m+1-t1,n+1+t2-t1);
        end                    
    end
end