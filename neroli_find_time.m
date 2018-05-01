function [time_drop,end_data,start_data] = neroli_find_time(data,time)

window = 20;

initial_data = mean(data(1:window));

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
end_time = time(end_data);
start_time = time(start_data);
time_drop = end_time-start_time;

end