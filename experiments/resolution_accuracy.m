% Like standard but we reduce resolution until accuracy falls below a
% certain threshold.

clear;clc;

img_proportions = [3,4];
people = 50;
tries = 50;

for multiplier = 1:5
    successes = 0;
    resolution = img_proportions * multiplier;
    
    for i = 1:tries
        emotions = 1:14; % we remove 1 emotion every round, careful
        chosen_people = randperm(200,people);
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
    accuracy = successes/tries;
    disp(" " + num2str(accuracy*100) + "% accuracy for " + num2str(multiplier*img_proportions(1)) + "x" + num2str(multiplier*img_proportions(2)))
end
