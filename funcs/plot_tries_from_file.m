function plot_tries_from_file(file_name,fixed_vars,fixed_vals,extend)
% first arguments are x and y, last 2 are taken as a proportion. Since it is a tensor and we can only plot up to 3d we need to fix variables. if variable fixed is resolution use resolution multiplier instead
arguments
    file_name
    fixed_vars
    fixed_vals
    extend = true;
end

if size(fixed_vars) ~= size(fixed_vals)
    disp("error: fixed variables don't match")
    return
end

T = readtable(file_name);

names = T.Properties.VariableNames;
key_correspondance = [];
for i = fixed_vars
    key_correspondance = [key_correspondance find(strcmp(i,names))];
end

T = addvars(T, rdivide(table2array(T(:,length(names))),table2array(T(:,length(names)-1))),NewVariableNames="true_z");

% just in case i decide to change order it's general, but it should be one iteration
for i = 1:length(names)
    if names{i}=="resolution"
        v1 = split(string(T.resolution),"x");
        T = addvars(T, str2double(v1(:,1))/3,NewVariableNames="temp",After="resolution");
        T = removevars(T,"resolution");
        T = renamevars(T,"temp","resolution");
        break
    end
end

% select rows with values equal to the fixed ones
for i = 1:length(key_correspondance)
    T = T(table2array(T(:,key_correspondance(i))) == fixed_vals(i),:);
end

T = removevars(T,fixed_vars);

if all(size(fixed_vals) == [1 1])
    % 3d plot
    if extend
        [xq,yq] = meshgrid(min(table2array(T(:,1))):max(table2array(T(:,1))), min(table2array(T(:,2))):max(table2array(T(:,2))));
        vq = griddata(table2array(T(:,1)),table2array(T(:,2)),T.tries,xq,yq);
        grafica = mesh(xq,yq,vq);
        grafica.FaceAlpha = 0.9;
        grafica.FaceColor = "interp";
    else
        max_x = max(table2array(T(:,2)));
        max_y = max(table2array(T(:,1)));
        M = zeros([max_x, max_y]);
        
        for i = 1:size(T,1)
            temp = T(i,:);
            M(table2array(temp(1,2)),table2array(temp(1,1))) = temp.tries;
        end
        grafica = mesh(M);
        grafica.FaceAlpha = 0.9;
        grafica.FaceColor = "flat";
    end
elseif all(size(fixed_vals) == [1 2])
    % 2d plot
    stem(table2array(T(:,1)),T.tries)

end
