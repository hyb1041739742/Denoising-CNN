function ds=rdivide(i1,i2)
% Function divides traces of a seismic dataset by a constant or matrix
% a constsnt or matrix by a seismic data set
% Written by: E. R.: September 11, 2005
% Last updated:

if isstruct(i1)  &  strcmp(i1.type,'seismic')  &  isnumeric(i2)
   ds=i1;
   sz=size(i2);
   [nsamp,ntr]=size(i1.traces);

   if prod(sz) == 1  |  all(sz == [nsamp,ntr])
      ds.traces=ds.traces./i2;

   else
      if all(sz == [1,ntr])
         for ii=1:nsamp
            ds.traces(ii,:)=ds.traces(ii,:)./i2;
         end
      
      elseif all(sz == [nsamp,1])
         for ii=1:ntr
            ds.traces(:,ii)=ds.traces(:,ii)./i2;
         end
      
      else
         error('Operator "-" is not defined for this size of scaler.')
      
      end
   end   
         

elseif  isstruct(i2)  &  strcmp(i2.type,'seismic')  &  isnumeric(i1)
   ds=i2;
   sz=size(i1);
   [nsamp,ntr]=size(i2.traces);

   if prod(sz) == 1   |  all(sz == [nsamp,ntr])
      ds.traces=i1./ds.traces;

   else
      
      if all(sz == [1,ntr])
         for ii=1:nsamp
            ds.traces(ii,:)=i1./ds.traces(ii,:);
         end
      
      elseif all(sz == [nsamp,1])
         for ii=1:ntr
            ds.traces(:,ii)=i1./ds.traces(:,ii);
         end

      else
         error('Operator "-" is not defined for this size of scaler.')
      
      end
   end   
         

else
   error('Operator "-" is not defined for these arguments.')
end

