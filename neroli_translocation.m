function [good_translocations,ecds] = neroli_translocation(fileroot,files)

% fileroot = uigetdir('CoolWater Mat File Selector');
% 
% files = dir(fullfile(fileroot, '*.mat'));
trans = 1;

all_translocations = containers.Map('KeyType','double','ValueType','any');
ecd = containers.Map('KeyType','double','ValueType','any');

voltage = [];
current = [];

for j = 1:length(files)
    
    if(ispc)
        filepath = char(strcat(fileroot,'\',files(j).name));
    else
        filepath = char(strcat(fileroot,'/',files(j).name));
    end
    
    load(filepath);
    
    time = 0:1/100000:2000;
    time = time(1:length(current));
    fil_current = butterworth_filter(300,100e3, current,'low');
    
%     [b,a] = butter(6,[32e3/(100e3/2) 40e3/(100e3/2)],'stop');
%     notch_current = filtfilt(b,a,current);
%     [b,a] = butter(1,[15/(100e3/2) 25/(100e3/2)],'stop');
%     notch_current = filtfilt(b,a,notch_current);
%     
%     wo = 50/(100e3/2);  bw = wo/35;
%     [b,a] = iirnotch(wo,bw);
    
%   notch_current = butterworth_filter(30e3,100e3, current,'low');
    
    [TF,P] = islocalmin(fil_current);
    
    for x = 1:length(TF)
        if(P(x)<0.006)
            TF(x) = 0;
        end
    end
    
    padValue= 125;
    
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
    
    %plot(time,current,time(TF),current(TF),'r*');
    
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
    
end

[good_translocations] = neroli_see_translocations(all_translocations);

[ecds] = neroli_ECD(good_translocations);

end