function [mean_drop,time_drop,good_translocations] = untitled4(current)
trans = 1;

all_translocations = containers.Map('KeyType','double','ValueType','any');
ecd = containers.Map('KeyType','double','ValueType','any');
time = 0:1/150e3:(length(current)-1)/150e3;
fs=150e3;
fc = 500;
order = 2;
[new_time,fil_current] = neroli_clean_currentTrace(current);
%time = 0:1/fs:(length(current)-1)/fs;
%[current, ~] = neroli_remove_base(current,fs);
%fil_current  = neroli_filter(fc,fs,current,'low',order);

[TF,P] = islocalmin(fil_current,'MinProminence',0.5);
%plot(new_time,fil_current,new_time(TF),fil_current(TF),'r*');
padValue= 250;

for i = 1:length(TF)-1
    if(TF(i)== 1 && TF(i-1)==0)
        if(i<padValue)
            TF(1:i)=1;
        else
            TF(i-padValue:i)=1;
        end
    end
end

for i = length(TF)-1:-1:1
    if(TF(i)== 1 && TF(i+1)==0)
        if(i+padValue>length(TF))
            TF(i:length(TF))=1;
        else
            TF(i:i+padValue)=1;
        end
    end
end

%plot(new_time,fil_current,new_time(TF),fil_current(TF),'r*');

i=1;
while ( i<length(TF))
    switch TF(i)
        case 1
            start = i;
            while (TF(i)==1)
                if ( i<length(TF))
                i = i+1;
                else
                    break
                end
            end
            finish =i;
            all_translocations(trans) = [fil_current(start:finish),time(start:finish)];
            trans = trans+1;
        case 0
            i = i+1;
    end
end


[good_translocations] = neroli_see_translocations(all_translocations,1);

[ecds,mean_drop,time_drop] = neroli_ECD(good_translocations);

scatter(time_drop,mean_drop);

end