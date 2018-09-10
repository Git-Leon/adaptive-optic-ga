%% force_delete; No 'permission denied' nonsense.
function force_delete(filename)   

    % find all file IDs for meta file,
    %     might be open for reading and writing so may have more than one file ID
    fID = find_fID_for(filename); 
    if all(fID ~= -1)
        pmax = length(fID);
        for p = 1:pmax
            % close all file IDs relating to the meta file,
            %     the meta file can now be deleted
            fclose(fID(p)); 
        end
    end
    try
        delete(filename); 
    catch exception
        warning(sprintf('Could not delete %s', s))
    end
end

%% gives vector of all active file IDs for filename
%     returns -1 if there are no active file IDs
function [fID] = find_fID_for(filename)   
    
    % remove backslash from end of filename (if present)
    if strcmp(filename(end),filesep)
        filename = filename(1:end-1);
    end
        
    fIDs = fopen('all'); % get all open file IDs
    nmax = length(fIDs);
    
    found = false;
    m = 0;
    
    for n=1:nmax 
        filename_comp = fopen(fIDs(n)); % get coresponding filename
        if strcmp(filename_comp,filename) % if this is the filename we are looking for
            found = true; % mark as found
            m=m+1;                                  
            index(m) = n; %#ok<AGROW> % keep record of the current index
        end
    end
    
    if found
        fID = fIDs(index); % if found parse back file IDs
    else
        fID = -1; % if not found parse back -1
    end
end