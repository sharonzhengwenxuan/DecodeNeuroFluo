function rename(newnum, oldnum, varargin) 
%name the folder [newnum], but pics are [oldnum]
%P: :)

%strip only works with R2016b and later
%trim? use varargin.
%one strip can only strip 1 character
%oldnum must be one character
%multiple strips for multiple digit numbers?
tic
fils = dir(['D:\test\' num2str(newnum) '\*.tif']);
switch nargin
    case 2
        
for id = 1:length(fils)
    % Get the file name (minus the extensions)
    [~, name] = fileparts(fils(id).name);
    
%strip-oldnum--------
    oldnum=num2str(oldnum);
    for i = 1:length(oldnum)
        name = strip(name, 'left', oldnum(i));
    end
%--------------------
      newname = strcat(num2str(newnum), name, '.tif') ;
      % rename the file
      movefile(['D:\test\' num2str(newnum) '\' fils(id).name], ['D:\test\' num2str(newnum) '\' newname]);
end

    case 3
for id = 1:length(fils)

    [~, name] = fileparts(fils(id).name);
    

    justname = trim(name, 1, num2str(oldnum));

    

      newname = strcat(num2str(newnum), justname, '.tif') ;

      movefile(['D:\test\' num2str(newnum) '\' fils(id).name], ['P:\test\' num2str(newnum) '\' newname]);
end
        
end
toc
end