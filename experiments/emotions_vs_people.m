% We change amount of emotions and people to see changes in acc and time

clear;clc;

resolution= [30,40];

peoples = 2:10;
% this is not the emotions used, but the amount of emotions. Need at least
% 2 since one will be erased from training dataset
emotions = 2:14;
tries = 10;

acc_table = table(Size=[0,4],VariableTypes=["string", "string", "double", "double"]);
acc_table.Properties.VariableNames = ["emotions","people","tries","successes"];

for i = 1:length(emotions)
    for j = 1:length(peoples)
        successes = 0;
        total_time = 0;
        try
            for k = 1:tries
                tic
                chosen_people = randperm(200,peoples(j));
                chosen_p = randperm(length(chosen_people),1);
                chosen_emotions = randperm(14,emotions(i));
                chosen_e = randperm(emotions(i),1);
        
                img_name = "datasets/FEI_face_database/combined/"+ num2str(chosen_people(chosen_p)) + "-" + num2str(chosen_emotions(chosen_e),'%02d') +".jpg";
                img = imread(img_name);
                img_mod = rgb2gray(imresize(img,resolution));
                z = double(img_mod(:));
        
                chosen_emotions(chosen_e) = []; 
                T = process_images(resolution,chosen_people,chosen_emotions,true);
                [p,~] = classify(T,z);
                total_time = total_time + toc;
                if p == chosen_p
                    fprintf("✓")
                    successes = successes + 1;
                else
                    fprintf("x")
                end
            end
            acc_table(end+1,:) = {string(emotions(i)), ...
                string(peoples(j)), ...
                tries, ...
                successes};

        catch
            fprintf(repmat('?',1,tries-k+1))
        end
        

        fprintf(" ")
    end
    fprintf("\n")
end

% add to whatever we had before
update_to_file("data/emotions_vs_people_accuracy.csv",acc_table);

plot_from_file("data/emotions_vs_people_accuracy.csv")


