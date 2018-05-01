function [ecds,mean_drop,time_drop] = neroli_ECD(good_translocations)

ecds = [];
time = 1:1/250e3:10;
mean_drop = [];
time_drop = [];

for i=1:length(good_translocations)
    data = good_translocations(i);
    [mean_drop(i),time_drop(i),ecds(i)]=neroli_crude_drop(data,time);
end

end