clear;clc;

img_prop = [3,4];

peoples = 2:3;
emotions = 2:3;
resolution_multiplier = 1:2;

tries = 5;

acc_table = table(Size=[0,5],VariableTypes=["string","string", "string", "double", "double"]);
acc_table.Properties.VariableNames = ["resolution","emotions","people","tries","successes"];
for r = resolution_multiplier
    resolution = img_prop * r;
    fprintf("resoulution: %ix%i\n",resolution)
    for e = emotions
        for p = peoples
            successes = 0;
            total_time = 0;
            try
                for t = 1:tries
                    tic
                    chosen_people = randperm(200,p);
                    chosen_p = randperm(length(chosen_people),1);
                    chosen_emotions = randperm(14,e);
                    chosen_e = randperm(e,1);
            
                    img_name = "datasets/FEI_face_database/combined/"+ num2str(chosen_people(chosen_p)) + "-" + num2str(chosen_emotions(chosen_e),'%02d') +".jpg";
                    img = imread(img_name);
                    img_mod = rgb2gray(imresize(img,resolution));
                    z = double(img_mod(:));
            
                    chosen_emotions(chosen_e) = []; 
                    T = process_images(resolution,chosen_people,chosen_emotions,true);
                    [predicted_p,~] = classify(T,z);
                    total_time = total_time + toc;
                    if predicted_p == chosen_p
                        fprintf("✓")
                        successes = successes + 1;
                    else
                        fprintf("x")
                    end
                end
                acc_table(end+1,:) = {
                    sprintf("%ix%i",resolution),...
                    string(e), ...
                    string(p), ...
                    tries, ...
                    successes};
    
            catch
                fprintf(repmat('?',1,tries-t+1))
            end
            fprintf(" ")
        end
        fprintf("\n")
    end
end

% add to whatever we had before
update_to_file("data/test.csv",acc_table);

plot_from_file("data/test.csv",["emotions"],[2])


