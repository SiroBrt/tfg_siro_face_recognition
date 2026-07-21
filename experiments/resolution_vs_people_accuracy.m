% Like standard but we reduce resolution until accuracy falls below a
% certain threshold.

clear;clc;

img_proportions = [3,4];
resolution_multipliers = 1:2;
peoples = 2:2:4;
tries = 2;
successes = zeros(length(resolution_multipliers),length(peoples));


for i = 1:length(resolution_multipliers)
    for j = 1:length(peoples)
        fail = 0;
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
                else
                    fprintf("x")
                    fail = fail + 1;
                end
            end

        catch
            fail = 0;
        end
        successes(i,j) = tries-fail;
        fprintf(" ")
    end
    fprintf("\n")
end
%things


figure
%mesh(successes)
fileID = fopen('data/resolution_vs_people_accuracy.csv','a+');
%fprintf(fileID, "people, resolution, tries, successes\n");
for i = 1:length(resolution_multipliers)
    for j = 1:length(peoples)
        fprintf(fileID, "%i, %ix%i, %i, %i\n", ...
            peoples(j), ...
            resolution_multipliers(i)*img_proportions(1), ...
            resolution_multipliers(i)*img_proportions(2), ...
            tries, ...
            successes(i,j));
    end
end