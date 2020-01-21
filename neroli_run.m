function [good_translocations,all_translocations, ecds,mean_drop,time_drop] = neroli_run()

%fileroot = uigetdir('CoolWater Mat File Selector');
%
fileroot = 'C:\Users\mc934\Desktop\DataBackup_030718\Data_Axopatch\040718\Mix\Try';
files = dir(fullfile(fileroot, '*.mat'));

current = [];
voltage = [];
time = [];
trans = 1;

all_translocations = containers.Map('KeyType','double','ValueType','any');
ecd = containers.Map('KeyType','double','ValueType','any');

fs=150e3;

all_time = 0:1/fs:300;

for j = 1:length(files)
    
    if(ispc)
        filepath = char(strcat(fileroot,'\',files(j).name))
    else
        filepath = char(strcat(fileroot,'/',files(j).name))
    end
    
    load(filepath);
    split_factor = 5;
    current_length = length(current);
    split_ind = 1:floor(current_length/split_factor):current_length;
    if(isempty(current))
    else
    for split=1:1:(split_factor-1)
        
        split_current = current(split_ind(split):split_ind(split+1));
        [new_time,new_current] = neroli_clean_currentTrace(split_current,fs);
        if(size(new_current,1) == 1)
            new_current = new_current';
        end
        if(size(new_time,1) == 1)
            new_time = new_time';
        end
        [pks,locs] = findpeaks(-new_current,'MinPeakHeight',0.25,'MinPeakDistance',fs*0.01);
        TF = zeros([1,length(new_time)]);
        TF(locs) = 1;
        TF = logical(TF);
        padValue= fs*0.0015;
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
        %close all; plot(new_time,new_current);hold on; plot(new_time(TF),new_current(TF),'*r');
        i=1;
        while ( i<length(TF))
            switch TF(i)
                case 1
                    start = i;
                    while (TF(i)==1)
                        if(i<length(TF))
                            i = i+1;
                        else
                            break;
                        end
                    end
                    finish =i;
                    all_translocations(trans) = [new_current(start:finish);new_time(start:finish)];
                    %plot(time(start:finish)',current(start:finish)');
                    trans = trans+1;
                case 0
                    i = i+1;
            end
        end
    end
    end
end

override = 1;

[good_translocations] = neroli_see_translocations(all_translocations,override);

[ecds,mean_drop,time_drop] = neroli_ECD(good_translocations);
close all; scatter(time_drop,mean_drop);
end
