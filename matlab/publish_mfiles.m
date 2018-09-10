clear; clc; close all;

mfiles = dir('*.m');
[path, curfile, ext] = fileparts(mfilename('fullpath'));
curfile = strcat(curfile, '.m');

for j = 1:length(mfiles);
    fname = mfiles(j).name;    
    
    if strmatch(fname, curfile);
        display('match!');
    else
        try
            display('Publishing!')
            publish(fname, 'doc')
        catch exception
            warning(sprintf('Could not publish file\t%s', fname));
        end
    end
end