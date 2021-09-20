function mat=create_powerlaw_samples(nsamp,ntr,power,seed)

randn('state',seed);
temp=randn(nsamp,ntr);
temp1=fft(temp);
f=(0:nsamp)';
f=min(f(1:end-1),f(end:-1:2));
f(1)=eps;
f=f.^power;
f(1)=eps;
for ii=1:ntr
   temp1(:,ii)=temp1(:,ii).*f;
end
mat=ifft(temp1);
mat=real(mat);
for ii=1:ntr
   mat(:,ii)=mat(:,ii)*norm(temp(:,ii))/norm(mat(:,ii));
end
