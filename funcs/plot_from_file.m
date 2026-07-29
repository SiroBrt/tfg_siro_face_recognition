function plot_from_file(file_name,extend)
% first 2 arguments are x and y, next 2 are taken as a proportion
arguments
    file_name
    extend = true;
end


T = readtable(file_name);

T = addvars(T, rdivide(table2array(T(:,4)),T.tries),NewVariableNames=["true_z"]);

names = T.Properties.VariableNames;

for i = 1:length(names)
    if names{i}=="resolution"
        v1 = split(string(T.resolution),"x");
        T = addvars(T, str2double(v1(:,1))/3,NewVariableNames=["resolution_mult"],After="resolution");
        T = removevars(T,"resolution");
        break
    end
end

if extend
    [xq,yq] = meshgrid(0:max(table2array(T(:,1))), min(table2array(T(:,2))):max(table2array(T(:,2))));
    vq = griddata(table2array(T(:,1)),table2array(T(:,2)),T.true_z,xq,yq);
    grafica = mesh(xq,yq,vq);
    grafica.FaceAlpha = 0.9;
    grafica.FaceColor = "interp";
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
end
