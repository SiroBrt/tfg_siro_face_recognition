clear;clc;

in_dataset = false;

%% initial parameters
resolution = [30,40];
pixels = resolution(1)*resolution(2);
chosen_people = randperm(200,10)
chosen_p = randperm(size(chosen_people,2),1);

% a bit of a cheat for easier recognition: all facing forward-ish
easy_emotions = [4,5,6,11,12,13,14];

emotions = easy_emotions;
chosen_e = randperm(size(emotions,2),1);

disp("Chosen person: " + chosen_people(chosen_p) + " with emotion " + easy_emotions(chosen_e))

if not(in_dataset)
    disp("deleting " + emotions(chosen_e) + " from training dataset")
    emotions(chosen_e) = []; 
end

disp(" ")

%% get the big tensor with all faces 
T = process_images(resolution,chosen_people,emotions);

%% create image to classify
img_name = "datasets/FEI_face_database/combined/"+ num2str(chosen_people(chosen_p)) + "-" + num2str(emotions(chosen_e),'%02d') +".jpg";
img = imread(img_name);
img_mod = rgb2gray(imresize(img,resolution));
z = double(img_mod(:));
%z = T(:,chosen_e,chosen_p);

%% classify
[p,e] = classify(T,z);

disp("detected person: " + chosen_people(p) + " with emotion " + emotions(e))