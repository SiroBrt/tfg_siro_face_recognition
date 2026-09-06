function plot_from_file(file_name,fixed_vars,fixed_vals,extend,log_scale)
% Last 2 are taken as a proportion. 
% if resolution is fixed use resolution multiplier instead
arguments
    file_name
    fixed_vars = [];
    fixed_vals = [];
    extend = true;
    log_scale = false;
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

% select rows with values equal to the fixed ones
for i = 1:length(key_correspondance)
    T = T(table2array(T(:,key_correspondance(i))) == fixed_vals(i),:);
end

T = removevars(T,fixed_vars);

disp("checkpoint 1")
if isempty(fixed_vars)
    disp("rama 1")
    % 4d plot

    dot_size = T.tries;
    %dot_size = 40;

    scatter3(T.people,...
        T.resolution,...
        T.emotions,...
        dot_size,...
        T.true_z,...
        "filled")

    xlabel("people")
    ylabel("resolution")
    zlabel("number of emotions")
    cb = colorbar;
    cb.Label.String = "accuracy";

elseif all(size(fixed_vals) == [1 1])
    disp("rama 2")
    % 3d plot
    if extend
        [xq,yq] = meshgrid(min(table2array(T(:,1))):max(table2array(T(:,1))), min(table2array(T(:,2))):max(table2array(T(:,2))));
        vq = griddata(table2array(T(:,1)),table2array(T(:,2)),T.true_z,xq,yq);
        grafica = mesh(xq,yq,vq);
        grafica.FaceAlpha = 0.9;
        grafica.FaceColor = "interp";
        vars = T.Properties.VariableNames;
        xlabel(vars(1))
        ylabel(vars(2))
        zlabel("accuracy")
    else
        max_x = max(table2array(T(:,2)));
        max_y = max(table2array(T(:,1)));
        M = zeros([max_x, max_y]);
        
        for i = 1:size(T,1)
            temp = T(i,:);
            M(table2array(temp(1,2)),table2array(temp(1,1))) = temp.true_z;
        end
        grafica = mesh(M);
        grafica.FaceAlpha = 0.9;
        grafica.FaceColor = "flat";
        vars = T.Properties.VariableNames;
        xlabel(vars(1))
        ylabel(vars(2))
        zlabel("accuracy")
    end
    if log_scale
        zscale log
    end
elseif all(size(fixed_vals) == [1 2])
    % 2d plot
    stem(table2array(T(:,1)),T.true_z)
    xlabel(T.Properties.VariableNames(1))
    ylabel("accuracy")


end
