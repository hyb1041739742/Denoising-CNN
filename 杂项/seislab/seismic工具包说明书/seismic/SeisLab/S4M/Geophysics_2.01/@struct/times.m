function ds=times(i1,i2)
% Function multiplies a constant or matrix elementwise with traces 
% of a seismic dataset 
% Written by: E. R.: September 11, 2005
% Last updated:

if isstruct(i1)  &  strcmp(i1.type,'seismic')  &  isnumeric(i2)
   ds=i1;
   sz=size(i2);
   [nsamp,ntr]=size(i1.traces);

   if prod(sz) == 1
      ds.traces=ds.traces.*i2;

   else
      if all(sz == [1,ntr])
         for ii=1:nsamp
            ds.traces(ii,:)=ds.traces(ii,:).*i2;
         end
      
      elseif all(sz == [nsamp,1])
         for ii=1:ntr
            ds.traces(:,ii)=ds.traces(:,ii).*i2;
         end
      
      elseif all(sz == [nsamp,ntr])
         ds.traces=ds.traces.*i2;
      
      else
         error('Operator "*" is not defined for this size of scaler.')
      
      end
   end   
         


elseif  isstruct(i2)  &  strcmp(i2.type,'seismic')  &  isnumeric(i1)
   ds=i2;
   sz=size(i1);
   [nsamp,ntr]=size(i2.traces);
   if prod(sz) == 1   |  all(sz == [nsamp,ntr])
      ds.traces=ds.traces.*i1;

   else
      if all(sz == [1,ntr])
         for ii=1:nsamp
            ds.traces(ii,:)=ds.traces(ii,:).*i1;
         end
      
      elseif all(sz == [nsamp,1])
         for ii=1:ntr
            ds.traces(:,ii)=ds.traces(:,ii).*i1;
         end
      
      elseif all(sz == [nsamp,ntr])
         ds.traces=ds.traces.*i1;
      
      else
         error('Operator "*" is not defined for this size of scaler.')
      
      end
   end   
         

else
   error('Operator "*" is not defined for these arguments.')
end

