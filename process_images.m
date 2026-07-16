function [T,chosen_people] = process_images(resize_param, size_people, size_emotion,randomize)
% Takes the image dataset and creates an organized tensor. First coordinate is the image mode, second is the emotion mode and third is people mode
arguments
    resize_param = [48,64]; % decimal -> resize factor, array -> resolution
    size_people = 10;
    size_emotion = 13; % all but one are used for training
    randomize = false;
end

% Choose the people we will be analyzing
chosen_people = randperm(200,size_people);
T = ones([resize_param(1)*resize_param(2),size_emotion,size_people]);

for i = 1:size_people
    if randomize
        % Choose a subset of emotions for training and leave some for testing.
        % They are unsorted
        chosen_emotions = randperm(size_emotion,size_emotion);
    else
        chosen_emotions = [4,5,6,11,12,13,14];
    end

    for j = 1:size(chosen_emotions,2)
        img_name = "datasets/FEI_face_database/combined/" + num2str(chosen_people(i)) + "-" + num2str(chosen_emotions(j),'%02d') + ".jpg";
        img = imread(img_name);
        mod_img = rgb2gray(imresize(img,resize_param)); % to gray scale and to smaller size
        T(:,j,i) = mod_img(:);
    end
end