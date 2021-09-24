function seisout=copy_fields(seisin,seisout)
% Function copies fields in structure "seisin" to "seisout" if they do not 
% exist in structure "seisout".
% A field "null" is added if fields "traces" or "curves" contain NaNs.
%
%              seisout=copy_fields(seisin,seisout)

if nargin == 1 | isempty(seisout)
  seisout=seisin;
  return
end

fieldsin=fieldnames(seisin);
fieldsout=[fieldnames(seisout);{'null'}];   % Do not copy 'null' field
index=find(~ismember(fieldsin,fieldsout));

for ii=1:length(index)
  seisout=setfield(seisout,fieldsin{index(ii)},getfield(seisin,fieldsin{index(ii)}));
end

if isfield(seisin,'curves')
%       Check for null values in log curves
  if ~isfield(seisout,'null') & sum(sum(isnan(seisout.curves(:,2:end)))) > 0
    seisout.null=NaN;
  end

elseif isfield(seisin,'traces')
%       Check for null values in seismic traces
  if ~isfield(seisout,'null') & sum(isnan(seisout.traces(:))) > 0
    seisout.null=NaN;
  end
end
