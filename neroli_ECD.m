function [ecds,mean_drop,time_drop] = neroli_ECD(good_translocations)

ecds = [];
time = 1:1/250e3:10;
mean_drop = [];
time_drop = [];

for i=1:length(good_translocations)
    data = good_translocations(i);
    ecds(i) = neroli_integrate(data);
    [mean_drop(i),time_drop(i)]=neroli_crude_drop(data,time);
end

    function [area] = neroli_integrate(data)
        area = 0;
        time = data(:,2);
        current = data(:,1);
        for x = 2:2:length(current)
            step = time(x)-time(x-1);
            area = area + (step*(current(x)-current(x-1)));
        end
    end

    function [mean_drop,time_drop] = neroli_crude_drop(data,time)
        current_trans = smooth(data(:,1));
      
        time_short = time(1:length(current_trans));
        [TF,P] = islocalmin(current_trans);
        
        for x = 1:length(TF)
            if(P(x)<0.06)
                TF(x) = 0;
            end
        end
        
        mean_drop = abs(mean(data(1:15))-mean(data(TF)));
        
        time_drop = neroli_find_time(data);
        
    end

end