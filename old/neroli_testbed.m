s_freq = 150000;
current_pos = current(current>0);

[fil_data] = neroli_filter(50e3, 150e3,current_pos,'low',2);
[fil_data] = neroli_filter(10, 150e3,fil_data,'high',2);

clean_trace = OffsetPeakRemoval(current_pos', fil_data',120);


time = 0:1/100000:2000;
time = time(1:length(clean_trace));
[TF,P] = islocalmin(clean_trace,'MinProminence',1);

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
plot(new_time,new_current);
%plot(time,clean_trace,time(TF),clean_trace(TF),'r*');