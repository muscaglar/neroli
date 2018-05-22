function [good_translocations, ecds,mean_drop,time_drop] = neroli_run()

fileroot = uigetdir('CoolWater Mat File Selector');
%
files = dir(fullfile(fileroot, '*.mat'));

current = [];
voltage = [];

all_translocations = containers.Map('KeyType','double','ValueType','any');
ecd = containers.Map('KeyType','double','ValueType','any');

fs=150e3;
fc = 1e3;
order = 2;
trans = 1;

all_time = 1:1/150e3:100;

for j = 1:length(files)
    
    if(ispc)
        filepath = char(strcat(fileroot,'\',files(j).name));
    else
        filepath = char(strcat(fileroot,'/',files(j).name));
    end
    
    load(filepath);
    
    if(sum(isnan(voltage))<1)
        voltage = voltage_cut;
        current = current_cut;
    end
    
    [trace_runs] = neroli_compartmentalise(current,voltage);
    
    for i=1:length(trace_runs)
        
        current = trace_runs(i);
        
        if(length(current)>10)
            
            time = all_time(1:length(current));
          
            fil_current  = neroli_filter(fc,fs,current,'low',order);
                     
            [TF,P] = islocalmin(fil_current,'MinProminence',0.8);
            

            plot(time,fil_current,time(TF),fil_current(TF),'r*');
            figure;
            plot(time,current,time(TF),current(TF),'r*');
            padValue= 200;
            
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
                        all_translocations(trans) = [current(start:finish),time(start:finish)'];
                        %plot(time(start:finish)',current(start:finish)');
                        trans = trans+1;
                    case 0
                        i = i+1;
                end
            end
        else
        end
    end
end

override = 1;

[good_translocations] = neroli_see_translocations(all_translocations,override);

[ecds,mean_drop,time_drop] = neroli_ECD(good_translocations);

end
