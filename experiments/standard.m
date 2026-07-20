% Take n random people with all emotions, choose a subject chosen_p and
% emotion chosen_e, remove chosen_e from dataset and look for closest match

clear;clc;

in_dataset = false;

%% initial parameters
% limit is around 30 people, 30x40 and 14 emotions
resolution = [30,40];
people = 30; 
chosen_people = randperm(200,people);
chosen_p = randperm(length(chosen_people),1);

emotions = 1:14;
% a bit of a cheat for easier recognition: all facing forward-ish
%easy_emotions = [4,5,6,11,12,13,14];
%emotions = easy_emotions;

chosen_e = randperm(length(emotions),1);

disp("Chosen person: " + chosen_people(chosen_p) + " with emotion " + emotions(chosen_e))
disp(" ")

%% create image to classify

img_name = "datasets/FEI_face_database/combined/"+ num2str(chosen_people(chosen_p)) + "-" + num2str(emotions(chosen_e),'%02d') +".jpg";
img = imread(img_name);
img_mod = rgb2gray(imresize(img,resolution));
z = double(img_mod(:));
%z = T(:,chosen_e,chosen_p);

%% delete emotion
if not(in_dataset)
    disp("deleting emotion " + emotions(chosen_e) + " from training dataset")
    disp(" ")
    emotions(chosen_e) = []; 
end


%% get the big tensor with all faces 
T = process_images(resolution,chosen_people,emotions,true);

%% classify
[p,e] = classify(T,z);

disp("detected person: " + chosen_people(p) + " with emotion " + emotions(e))