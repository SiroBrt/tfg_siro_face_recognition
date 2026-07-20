% Like standard but we reduce resolution until accuracy falls below a
% certain threshold.

clear;clc;

img_proportions = [3,4];
resolution_multipliers = 1:15;
peoples = 2:2:30;
tries = 20;
accuracies = zeros(length(resolution_multipliers),length(peoples));


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
                    successes = successes + 1;
                    fprintf("✓")
                else
                    fprintf("x")
                end
            end

        catch
            successes = 0;
        end
        accuracies(i,j) = successes/tries;
        fprintf(" ")
    end
    fprintf("\n")
end
%things


figure
mesh(accuracies)