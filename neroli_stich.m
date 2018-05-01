function [TF] = neroli_stich(voltage)

TF = voltage>100;

padValue= 1000000; %for 100 downsampled

for i = 2:length(TF)-1
    if(TF(i)== 0 && TF(i-1)==1)
        if(i<padValue)
            TF(1:i)=0;
        else
            TF(i-padValue:i)=0;
        end
    end
end

for i = length(TF)-1:-1:1
    if(TF(i)== 0 && TF(i+1)==1)
        if(i+padValue>length(TF))
            TF(i:length(TF))=0;
        else
            TF(i:i+padValue)=0;
        end
    end
end

%z = 1;
% for i = 1:length(voltage)
%
%     if(voltage(i)>1)
%         current_trace(z) = current(i);
%         voltage_trace(z) = voltage(i);
%         z = z + 1;
%     end
%
% end

end