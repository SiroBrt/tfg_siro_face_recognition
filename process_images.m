function [T,chosen_people] = process_images()
% Takes the image dataset and creates an organized tensor

resize_thing = [48,64]; % decimal -> resize factor, array -> resolution

% Choose the people we will be analyzing
size_people = 10;
chosen_people = randperm(200,size_people);

size_emotion = 13;
test_size = 1;
T = ones([resize_thing(1)*resize_thing(2),size_emotion-test_size,size_people]);

for i = 1:size_people
    
    % Choose a subset of emotions for training and leave some for testing.
    % They are unsorted
    chosen_emotions = randperm(size_emotion,size_emotion-test_size);
    
    %chosen_emotions = 1:size_emotion;

    for j = 1:size_emotion-test_size
        img_name = "datasets/FEI_face_database/combined/" + num2str(chosen_people(i)) + "-" + num2str(chosen_emotions(j),'%02d') + ".jpg";
        img = imread(img_name);
        mod_img = rgb2gray(imresize(img,resize_thing)); % to gray scale and to smaller size
        T(:,j,i) = mod_img(:);
    end
end