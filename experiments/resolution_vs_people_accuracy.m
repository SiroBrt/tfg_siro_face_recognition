% Like standard but we reduce resolution until accuracy falls below a
% certain threshold.

clear;clc;

img_proportions = [3,4];
resolution_multipliers = 10:15;
peoples = 2:4;
tries = 10;
%successes = zeros(length(resolution_multipliers),length(peoples));

Tabla = table(Size=[0,4],VariableTypes=["string", "string", "double", "double"]);
Tabla.Properties.VariableNames = ["resolution","people","tries","successes"];


for i = 1:length(resolution_multipliers)
    for j = 1:length(peoples)
        successes = 0;
        resolution = img_proportions * resolution_multipliers(i);
        try

            for k = 1:tries
                emotions = 1:14;
                chosen_people = randperm(200,peoples(j));
                chosen_p = randperm(length(chosen_people),1);
                chosen_e = randperm(length(emotions),1);
        
                img_name = "datasets/FEI_face_database/combined/"+ num2str(chosen_people(chosen_p)) + "-" + num2str(emotions(chosen_e),'%02d') +".jpg";
                img = imread(img_name);
                img_mod = rgb2gray(imresize(img,resolution));
                z = double(img_mod(:));
        
                emotions(chosen_e) = []; 
                T = process_images(resolution,chosen_people,emotions,true);
                [p,~] = classify(T,z);
                if p == chosen_p
                    fprintf("✓")
                    successes = successes + 1;
                else
                    fprintf("x")
                end
            end

        catch
            successes = 0;
        end
        Tabla(end+1,:) = {sprintf("%ix%i",resolution), ...
            string(peoples(j)), ...
            tries, ...
            successes};

        fprintf(" ")
    end
    fprintf("\n")
end

% add to whatever we had before
update_to_file("data/resolution_vs_people_accuracy.csv",Tabla);

% get all data
T = readtable("data/resolution_vs_people_accuracy.csv");

v1 = split(string(T.resolution),"x");
T = addvars(T, rdivide(T.successes,T.tries),str2double(v1(:,1))/3,NewVariableNames=["accuracy","resolution_mult"]);

% to see it better
z_limit = 0.5;
T(end+1,:) = {{"0x0"} 2 0 0 z_limit 0};


[xq,yq] = meshgrid(0:max(T.resolution_mult), min(T.people):max(T.people));
vq = griddata(T.resolution_mult,T.people,T.accuracy,xq,yq);
grafica = mesh(xq,yq,vq);
grafica.FaceAlpha = 0.7;
grafica.FaceColor = "flat";

