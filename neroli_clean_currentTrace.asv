function [new_time,new_current] = neroli_clean_currentTrace(current,s_freq)

[fil_data] = neroli_filter(50e3, s_freq,current,'low',2);
[fil_data] = neroli_filter(10, s_freq,fil_data,'high',2);

clean_trace = neroli_excess_peak_beGone(current', fil_data',150e3);

plot(fil_data);hold on; plot(clean_trace);

time = 0:1/s_freq:2000;
time = time(1:length(clean_trace));
[TF,P] = islocalmin(clean_trace,'MinProminence',1);
%plot(time,clean_trace);hold on; plot(time(TF),clean_trace(TF),'*r');
padValue= 500;

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

new_current = clean_trace(~TF);
new_time = time(~TF);
close all;
%plot(new_time,new_current);
end