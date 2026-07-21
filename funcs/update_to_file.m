function update_to_file(file_name,tabla)
% put keys as string, anything else will get combined (added) between the file and the new table
if isfile(file_name)
    prev = readtable('data/resolution_vs_people_accuracy.csv');
    prev.Properties.VariableTypes = tabla.Properties.VariableTypes;

    writetable(union(prev,tabla),file_name);
    
else
    writetable(tabla,file_name)
end