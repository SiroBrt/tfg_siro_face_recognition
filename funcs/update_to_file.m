function update_to_file(file_name,tabla)
% put keys as string at the beginning, anything else will get combined (added) between the file and the new table
if isfile(file_name)
    prev = readtable('data/resolution_vs_people_accuracy.csv');
    prev.Properties.VariableTypes = tabla.Properties.VariableTypes;
    
    % identify columns
    strings = tabla.Properties.VariableTypes == "string";
    keys = tabla.Properties.VariableNames(strings);
    values = tabla.Properties.VariableNames(~strings);

    % join
    combined = outerjoin(tabla,prev,Keys=keys,MergeKeys=true);
    
    % combine things
    for i = 1:length(values)
        v =  transpose(sum(transpose(table2array([combined(:,length(keys)+i) combined(:,length(keys)+i+length(values))])),'omitnan'));
        combined = addvars(combined,v,NewVariableNames=values(i));
    end
    
    %remove unnecesary columns
    combined(:,length(keys)+1:length(keys)+2*length(values)) = [];

    writetable(combined,file_name)
else
    writetable(tabla,file_name)
end