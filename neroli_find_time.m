function [time_drop] = neroli_find_time(data)

window = 2;

initial_data = mean(data(1:window));

time = (data(:,2));
data = (data(:,1));

start_data = 1;
end_data = length(data);

for i = length(time):-(window+1):1
    current_data = mean(data(i-window:i));
    if(isalmost(current_data,initial_data,initial_data*0.01))
        end_data = i;
        break
    end
end

for i = 1:window:length(time)-(window+1)
    current_data = mean(data(i:i+window-1));
    if(isalmost(current_data,initial_data,initial_data*0.01))
    else
        start_data = i;
        break
    end
end

time_drop = time(end_data)-time(start_data);

end