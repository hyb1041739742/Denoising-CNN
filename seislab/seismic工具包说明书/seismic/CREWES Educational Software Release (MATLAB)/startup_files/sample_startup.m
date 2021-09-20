declareGlobals
setGlobals

global defaultpath
if(isempty(defaultpath))
	oldpath=path;
   defaultpath=oldpath;
else
   oldpath=defaultpath;
end


prefix='$toolbox\CREWES3.2\';  
   newCREWES=[...
      prefix 'displaytools;'...
      prefix 'finitedif;'...
      prefix 'migration;'...
      prefix 'raytrace;'...
      prefix 'resolution;'...
      prefix 'seismic;'...
      prefix 'synsections;'...
      prefix 'syntraces;'...
      prefix 'utilities;'...
      prefix 'synth;'...
      prefix 'velocity;'...
      prefix 'crseisio;'...
      prefix 'segy;'...
];

prefix='$toolbox\CREWES3.2\z_legacy\';
oldCREWES=[
   prefix 'dataobjects;'...
   prefix 'dialogs;'...
   prefix 'geometric;'...
   prefix 'inversion;'...
   prefix 'io;'...
   prefix 'logedit;'...
   prefix 'logsec;'...
   prefix 'logtools;'...
   prefix 'migration;'...
   prefix 'raytrace;'...
   prefix 'refrac;'...
   prefix 'seismic;'...
   prefix 'tools;'...
   prefix 'utilities;'...
   prefix 'velocity;'...
   prefix 'wavelets;'...
];
 

   p =  [ newCREWES  oldCREWES ];

%--translate ---------------------------------------------------------
% copied from $toolbox/local/pathdef.m
%
% Can't use functions in startup.m, so we just inline the code...

%function p = translate(p);
%TRANSLATE Translate unix path to platform specific path
%   TRANSLATE fixes up the path so that it's valid on non-UNIX platforms

cname = computer;
% Look for VMS, this covers VAX_VMSxx as well as AXP_VMSxx.
if (length (cname) >= 7) & strcmp(cname(4:7),'_VMS')
  p = strrep(p,'/','.');
  p = strrep(p,':','],');
  p = strrep(p,'$toolbox.','toolbox:[');
  p = strrep(p,'$work.','work:[');
  p = strrep(p,'$','matlab:[');
  p = [p ']']; % Append a final ']'

% Look for PC
elseif strncmp(cname,'PC',2)
  p = strrep(p,'/','\');
  p = strrep(p,':',';');
  p = strrep(p,'$',[matlabroot '\']);

% Look for MAC
elseif strncmp(cname,'MAC',3)
  p = strrep(p,':',':;');
  p = strrep(p,'/',':');
  m = matlabroot;
  if m(end) ~= ':'
    p = strrep(p,'$',[matlabroot ':']);
  else
    p = strrep(p,'$',matlabroot);
  end
else
  p = strrep(p,'$',[matlabroot '/']);
end

%---------- END OF translate function ------

path([oldpath pathsep p])
   
clear  p prefix oldCREWES newCREWES cname

% you can set a line like this to automatically put you in the directory of your choice
%cd C:\matlab6p1\work
