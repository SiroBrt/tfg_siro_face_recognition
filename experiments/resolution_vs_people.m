% We change resolution and amount of peopleto see changes in acc and time

clear;clc;

img_proportions = [3,4];
resolution_multipliers = 1:10;
peoples = 2:20;
tries = 2;

acc_table = table(Size=[0,4],VariableTypes=["string", "string", "double", "double"]);
acc_table.Properties.VariableNames = ["resolution","people","tries","successes"];

time_table = table(Size=[0,4],VariableTypes=["string", "string", "double", "double"]);
time_table.Properties.VariableNames = ["resolution","people","tries","time"];

for i = 1:length(resolution_multipliers)
    for j = 1:length(peoples)
        successes = 0;
        resolution = img_proportions * resolution_multipliers(i);
        total_time = 0;
        try

            for k = 1:tries
                tic
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
                total_time = total_time + toc;
                if p == chosen_p
                    fprintf("✓")
                    successes = successes + 1;
                else
                    fprintf("x")
                end
            end
            acc_table(end+1,:) = {sprintf("%ix%i",resolution), ...
                string(peoples(j)), ...
                tries, ...
                successes};
            time_table(end+1,:) = {sprintf("%ix%i",resolution), ...
                string(peoples(j)), ...
                tries, ...
                total_time};

        catch
            fprintf(repmat('?',1,tries-k+1))
        end
        

        fprintf(" ")
    end
    fprintf("\n")
end

% add to whatever we had before
update_to_file("data/resolution_vs_people_accuracy.csv",acc_table);
update_to_file("data/resolution_vs_people_time.csv",time_table);

plot_from_file("data/resolution_vs_people_time.csv")

