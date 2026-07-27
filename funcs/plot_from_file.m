function plot_from_file(file_name,extend)
arguments
    file_name
    extend = true;
end
T = readtable(file_name);

v1 = split(string(T.resolution),"x");
T = addvars(T, rdivide(table2array(T(:,4)),T.tries),str2double(v1(:,1))/3,NewVariableNames=["true_z","resolution_mult"]);

if extend
    [xq,yq] = meshgrid(0:max(T.resolution_mult), min(T.people):max(T.people));
    vq = griddata(T.resolution_mult,T.people,T.true_z,xq,yq);
    grafica = mesh(xq,yq,vq);
    grafica.FaceAlpha = 0.9;
    grafica.FaceColor = "interp";
else
    max_p = max(T.people);
    max_r = max(T.resolution_mult);
    M = zeros([max_p, max_r]);
    
    for i = 1:size(T,1)
        temp = T(i,:);
        M(temp.people,temp.resolution_mult) = temp.true_z;
    end
    grafica = mesh(M);
    grafica.FaceAlpha = 0.9;
    grafica.FaceColor = "flat";
end
