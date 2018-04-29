function [ecds] = neroli_ECD(good_translocations)

ecds = [];

for i=1:length(good_translocations)
    data = good_translocations(i);
    ecds(i) = neroli_integrate(data);
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

end