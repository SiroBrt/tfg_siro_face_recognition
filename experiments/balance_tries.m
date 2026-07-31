clear;clc;

file_name = "data/accuracy_data.csv";

T_old = readtable(file_name);

names = T_old.Properties.VariableNames;
for i = 1:length(names)
    if names{i}=="resolution"
        v1 = split(string(T_old.resolution),"x");
        T_old = addvars(T_old, str2double(v1(:,1))/3,NewVariableNames="temp",After="resolution");
        T_old = removevars(T_old,"resolution");
        T_old = renamevars(T_old,"temp","resolution");
        break
    end
end

T_old = T_old(T_old.emotions == 14,:);
max_x = max(T_old.people);
max_y = max(T_old.resolution);
M = zeros([max_x, max_y]);
        
for i = 1:size(T_old,1)
    temp = T_old(i,:);
    M(temp.people,temp.resolution) = temp.tries;
end

mesh(M)
to_do = table(Size=[0,4],VariableTypes=["double", "double", "double", "double"]);
to_do.Properties.VariableNames = ["people", "resolution", "emotions", "tries"];

for i = 3:max_x-1
    advised_tries = min([M(i+1,1),M(i-1,1)]);
    if M(i,1) < advised_tries
        to_do(end+1,:) = {i,1,14,advised_tries-M(i,1)};
    end
    advised_tries = min([M(i+1,max_y),M(i-1,max_y)]);
    if M(i,max_y) < advised_tries
        to_do(end+1,:) = {i,max_y,14,advised_tries-M(i,max_y)};
    end
end



for j = 2:max_y-1
    advised_tries = min([M(2,j+1),M(2,j-1)]);
    if M(2,j) < advised_tries
        to_do(end+1,:) = {2,j,14,advised_tries-M(2,j)};
    end
    advised_tries = min([M(max_x,j+1),M(max_x,j-1)]);
    if M(max_x,j) < advised_tries
        to_do(end+1,:) = {max_x,j,14,advised_tries-M(max_x,j)};
    end
end


 for i = 3:max_x-1
     for j = 2:max_y-1
         advised_tries = min([M(i+1,j+1),M(i-1,j+1),M(i+1,j-1),M(i-1,j-1)]);
         if M(i,j) < advised_tries
             to_do(end+1,:) = {i,j,14,advised_tries-M(i,j)};
         end
     end
end

to_do
acc_table = table(Size=[0,5],VariableTypes=["string","string", "string", "double", "double"]);
acc_table.Properties.VariableNames = ["resolution","emotions","people","tries","successes"];

for i = 1:height(to_do)
    temp = to_do(i,:);
    resolution = [3,4] * temp.resolution;
    successes = 0;
    for t = 1:temp.tries
        chosen_people = randperm(200,temp.people);
        chosen_p = randperm(length(chosen_people),1);
        chosen_emotions = randperm(14,temp.emotions);
        chosen_e = randperm(temp.emotions,1);

        img_name = "datasets/FEI_face_database/combined/"+ num2str(chosen_people(chosen_p)) + "-" + num2str(chosen_emotions(chosen_e),'%02d') +".jpg";
        img = imread(img_name);
        img_mod = rgb2gray(imresize(img,resolution));
        z = double(img_mod(:));

        chosen_emotions(chosen_e) = [];
        T = process_images(resolution,chosen_people,chosen_emotions,true);
        [predicted_p,~] = classify(T,z);
        if predicted_p == chosen_p
            fprintf("✓")
            successes = successes + 1;
        else
            fprintf("x")
        end
    end
    acc_table(end+1,:) = {
        sprintf("%ix%i",resolution),...
        string(temp.emotions), ...
        string(temp.people), ...
        temp.tries, ...
        successes};

    fprintf("\n")
end


% add to whatever we had before
update_to_file(file_name,acc_table);

plot_tries_from_file(file_name,["emotions"],[14],false)
