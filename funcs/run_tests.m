function acc_table = run_tests(to_do)

img_prop = [3,4];

acc_table = table(Size=[0,5],VariableTypes=["string","string", "string", "double", "double"]);
acc_table.Properties.VariableNames = ["resolution","emotions","people","tries","successes"];

for i = 1:height(to_do)
    temp = to_do(i,:);
    resolution = img_prop * temp.resolution;
    successes = 0;
    try
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
            string(temp.resolution),...
            string(temp.emotions), ...
            string(temp.people), ...
            temp.tries, ...
            successes};
    catch
        fprintf(repmat('?',1,temp.tries-t+1))
    end

    fprintf("\n")
end