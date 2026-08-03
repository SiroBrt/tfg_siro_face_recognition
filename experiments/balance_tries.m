% easier tests should have more tries than any test harder than itself

clear;clc;

file_name = "data/accuracy_data.csv";
file_name = "data/test.csv";

while true

    old_acc = readtable(file_name);

    max_x = max(old_acc.people);
    max_y = max(old_acc.resolution);
    max_z = max(old_acc.emotions);

    M = zeros([max_x+1, max_y+1,max_z+1]);

    for i = 1:size(old_acc,1)
        temp = old_acc(i,:);
        M(temp.people,temp.resolution,temp.emotions) = temp.tries;
    end

    clear to_do;
    to_do = table(Size=[0,4],VariableTypes=["double", "double", "double", "double"]);
    to_do.Properties.VariableNames = ["people", "resolution", "emotions", "tries"];

    for p = 2:max_x
        for r = 1:max_y
            for e = 2:max_z
                advised_tries = max([M(p+1,r,e),M(p,r+1,e),M(p,r,e+1),...
                    M(p+1,r+1,e),M(p+1,r,e+1),M(p,r+1,e+1),...
                    M(p+1,r+1,e+1)]);
                if M(p,r,e) < advised_tries
                    to_do(end+1,:) = {p,r,e,advised_tries-M(p,r,e)};
                end
            end
        end
    end

    to_do
    if height(to_do) == 0
        break
    end
    acc_table = run_tests(to_do);

    % add to whatever we had before
    update_to_file(file_name,acc_table);
end

plot_from_file(file_name)
