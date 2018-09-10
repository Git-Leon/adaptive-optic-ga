

%% Define convergence as similarity between profiles
function grade = fitness(member, pad_size, min_grade, technique, recursion_limit, mygrades)
    propagate = @() LaserPropagation(member, pad_size, technique);
    [grade phase] = getGrade(propagate);
       
    iter = length(mygrades)+1;
	mygrades(iter) = grade;
    
    % if unsuitable for environment, mutate until suitable    
    if min(mygrades) >= min_grade && iter < recursion_limit
        global myfuns;
        
        % FUNCTION HANDLE; nested fitness function
        fit = @(member)...
            fitness(member, pad_size, min_grade, technique, recursion_limit, mygrades);
        
        if rand > .5 % create new member
            mygrades(iter+1) = fit(myfuns.createOne());
        else % mutate current member            
            mygrades(iter+1) = fit(myfuns.mutate(member));
        end
    elseif iter >= recursion_limit
        %display(mygrades);
    end

    grade = min(mygrades);
    plot(phase())
end


function [grade, phase] = getGrade(propagate)
    [I1,I2,I3,phase] = propagate();
	F12=sum(abs(I1-I2));
	F13=sum(abs(I1-I3));
	F23=sum(abs(I2-I3));
	plot(I1,'b'); hold on;
	plot(I2, 'r'); hold on;
	plot(I3,'k'); hold off
    grade = abs(1 - (F12+F13+F23)/3);
end