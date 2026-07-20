function T = process_images(resize_param, people, emotions,randomize)
% From the image dataset creates an organized tensor. First coordinate is the image mode, second is the emotion mode and third is people mode
arguments
    resize_param = [48,64]; % decimal -> resize factor, array -> resolution
    people = [1,2,3,4,5];
    emotions = [4,5,6,11,12,13,14]; % the emotions facing more or less forward
    randomize = false;
end

% Choose the people we will be analyzing
T = ones([resize_param(1)*resize_param(2),size(emotions,2),size(people,2)]);

for i = 1:length(people)
    if randomize
        % for extra confusing
        emotions = emotions(randperm(length(emotions)));
    end

    for j = 1:length(emotions)
        img_name = "datasets/FEI_face_database/combined/" + num2str(people(i)) + "-" + num2str(emotions(j),'%02d') + ".jpg";
        img = imread(img_name);
        mod_img = rgb2gray(imresize(img,resize_param)); % to gray scale and to smaller size
        T(:,j,i) = mod_img(:);
    end
end