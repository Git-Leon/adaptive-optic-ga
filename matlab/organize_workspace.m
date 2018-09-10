function organize_workspace()
    % move autosave files to back up directory
    mvs('./backups', '*.asv')
    
    % move images to images directory
    mvs('./images', '*.jpg', '*.jpeg', '*.png', '*.bmp', '*.fig');
    
    % move documents to html folder
    mvs('./html', '*.pdf', '*.html', '*.doc', '*.docx');
end

function files = mvs(directory, varargin)
    for j = 1:nargin-1
        try
            movefile(varargin{j}, directory)
        catch exception
        end
    end
end