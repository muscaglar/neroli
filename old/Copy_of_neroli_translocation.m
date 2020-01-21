function [good_translocations,ecds] = Copy_of_neroli_translocation(current)

trans = 1;

%No  = inputdlg('Enter the sampling rate in kHz');
%fs = str2double(No{1,1});
fs = 150000;
fs = fs*1000;
% No  = inputdlg('Enter the filter corner frequency in kHz');
% fc = str2double(No{1,1});
fc = 1;
fc = fc *1000;

all_translocations = containers.Map('KeyType','double','ValueType','any');
ecd = containers.Map('KeyType','double','ValueType','any');

current = current(current>0);
current = current(current < 1.1*mean(current));
current = current(current > 0.7*mean(current));
order = 2;
    
b=polyfit(x(ix),y(ix),2); % fit second order baseline
ysub=y-polyval(b,x);   

     time = 0:1/fs:(length(current)-1)/fs;

    fil_current  = neroli_filter(fc,fs,current,'low',order);
    
    [TF,P] = islocalmin(fil_current,'MinProminence',0.005);
     plot(time,current,time(TF),current(TF),'r*');
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
    

[good_translocations] = neroli_see_translocations(all_translocations,0);

[ecds] = neroli_ECD(good_translocations);

end