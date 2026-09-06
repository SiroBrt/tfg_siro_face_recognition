clear;clc;

file_name = "data/accuracy_data.csv";

to_do = table(Size=[0,4],VariableTypes=["double", "double", "double", "double"]);
to_do.Properties.VariableNames = ["people", "resolution", "emotions", "tries"];

to_do(end+1,:) = {3,2,2,1};
to_do

acc_table = run_tests(to_do);

update_to_file(file_name,acc_table);