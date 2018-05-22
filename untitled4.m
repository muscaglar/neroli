
trans = 1;

all_translocations = containers.Map('KeyType','double','ValueType','any');
ecd = containers.Map('KeyType','double','ValueType','any');

fs=100000;
fc = 500;
order = 2;

time = 0:1/fs:(length(current)-1)/fs;
[current, ~] = neroli_remove_base(current,fs);
fil_current  = neroli_filter(fc,fs,current,'low',order);

[TF,P] = islocalmin(fil_current,'MinProminence',0.15);

padValue= 1;

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

plot(time,current,time(TF),current(TF),'r*');

i=1;
while ( i<length(TF))
    switch TF(i)
        case 1
            start = i;
            while (TF(i)==1)
                i = i+1;
            end
            finish =i;
            all_translocations(trans) = [current(start:finish)',time(start:finish)'];
            trans = trans+1;
        case 0
            i = i+1;
    end
end


[good_translocations] = neroli_see_translocations(all_translocations);

[ecds] = neroli_ECD(good_translocations);
