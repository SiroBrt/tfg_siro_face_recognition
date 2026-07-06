function T = process_images()
% Takes the image dataset and creates an organized tensor
resize_thing = [48,64]; % decimal -> resize factor, array -> resolution
size_people = 50;

chosen_people = 1:50; % in the future it will be random

size_emotion = 13;
T = ones([resize_thing(1)*resize_thing(2),size_emotion,size_people]);

for person = chosen_people
    chosen_emotions = 1:size_emotion; % could be different for each person 
    for emotion = chosen_emotions
        img_name = "datasets/FEI_face_database/combined/" + num2str(person) + "-" + num2str(emotion,'%02d') + ".jpg";
        img = imread(img_name);
        mod_img = rgb2gray(imresize(img,resize_thing)); % to gray scale and to smaller size
        T(:,emotion,person) = mod_img(:);
    end
end