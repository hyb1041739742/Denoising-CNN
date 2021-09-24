function wlog=l_switch_depth(wlog,new_depth)
% Function replaces "depth" column (1st column) of the log structure with another column
% Neither column may contain null values. 
% Generally used to convert from depth to time and vice versa
% Written by: E. R., November 7, 2000
% Last update:
%
%		wlog=l_switch_depth(wlog,new_depth)
% INPUT
% wlog         log structure whose depth column needs to be switched
% new_depth   mnemonic of column to be used as new depth
% OUTPUT
% wlog 	      log structure with the with the new "depth" column

if ~isstruct(wlog)
  error(' First input data set must be log structure')
end

index=curve_index1(wlog,new_depth);
if index == 1           % Requested depth column is already the first column in matrix "wlog.curves"
   return
end

temp=wlog.curves(:,index);
if isfield(wlog,'null')
   ilog=isnan(temp);
%    idx=find(ilog);
   if sum(ilog) > 0
      idx=find(~ilog);
      wlog.curves=wlog.curves(idx,:);
      temp=temp(idx);
      disp([' Alert from "l_switch_depth": Rows with null values in new depth column "',new_depth,'" have been dropped'])
   end
end
temp_info=wlog.curve_info(index,:);

wlog.curves(:,index)=wlog.curves(:,1);
wlog.curve_info(index,:)=wlog.curve_info(1,:);
wlog.curves(:,1)=temp;
wlog.curve_info(1,:)=temp_info;

wlog.first=temp(1);
wlog.last=temp(end);

dd=diff(temp);
mad=max(dd);
mid=min(dd);
if mid*(1+1.0e-6) < mad
   wlog.step=0;
else
   wlog.step=(mad+mid)*0.5;
end
            

