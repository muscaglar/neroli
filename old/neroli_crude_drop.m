function [mean_drop,time_drop,area] = neroli_crude_drop(data,time)

current_trans = smooth(data(:,1));

time_short = time(1:length(current_trans));

[TF,P] = islocalmin(current_trans,'MinProminence',0.1);

plot(time_short,current_trans,time_short(TF),current_trans(TF),'r*');

%mean_drop = abs(mean(data(1:5))-mean(data(TF)));

%[time_drop,~,~] = neroli_find_time(data,time);

[start_ind,end_ind] = neroli_alt_find_time(data);
if(end_ind == length(data))
    disp('fudge')
end
time_drop = time(end_ind)-time(start_ind);
mean_drop = mean(data(start_ind:end_ind))-mean(data(1:start_ind));

area = neroli_integrate(data,time,start_ind,end_ind);

function [area] = neroli_integrate(data,time,start_ind,end_ind)
        area = 0;        
        current = data;
        if(start_ind ==1)
            start_ind = 2;
        end
        for x = start_ind:2:end_ind
            step = time(x)-time(x-1);
            area = area + (step*(current(x)-current(x-1)));
        end
    end

end