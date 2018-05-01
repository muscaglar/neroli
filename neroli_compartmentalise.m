function [trace_runs] = neroli_compartmentalise(current,voltage)


TF = neroli_stich(voltage);
trace_runs = containers.Map('KeyType','double','ValueType','any');
runs = 1;
fs = 150e3;

i=1;

while(i<=length(TF))
    if (TF(i)==1)   
        start = i;
        while (TF(i)==1)
            if(i+1<length(TF))
                i = i+1;
            else
                i = i+1;
                break
            end
        end
        finish =i-1;
        [current_fitted,~] = neroli_remove_base(current(start:finish)',fs);
        trace_runs(runs) = current_fitted;
        runs = runs+1;
    else
        i=i+1;
    end
end

end