function [start_ind,end_ind] = neroli_alt_find_time(data)

size_data = length(data);
first_max = max(data(1:size_data/2));
second_max = max(data(size_data/2:size_data));

tolerance = 0.0045;

start_ind = 1;
end_ind = length(data);

%%extent of baseline

for i = 1:floor(size_data/2)
    if(isalmost(first_max,data(i),first_max*tolerance))
    else
        start_ind = i;
        break
    end
end

for i = floor(size_data/2):size_data
    if(isalmost(second_max,data(i),second_max*tolerance))
        end_ind = i;
        break
    else
    end
end


end