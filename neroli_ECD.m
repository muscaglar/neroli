function [ecds,mean_drop,time_drop] = neroli_ECD(good_translocations)

ecds = [];
time = 0:1/150e3:400;
mean_drop = [];
time_drop = [];
dumped = 0;
movement = 50;

for i=1:length(good_translocations)
    data = good_translocations(i);
    x = data(:,1);
    t= time(1:length(x));
    % t = data(:,2);
    ind = find(x < -0.1);
    try
        if( min(ind) < movement)
            min_ind = 1;
        else
            min_ind = min(ind)-movement;
        end
        if ( max(ind)+movement > (length(x)))
            max_ind = length(x);
        else
            max_ind = max(ind)+movement;
        end
        x = x(min_ind:max_ind);
        time_drop(i) = time(max_ind)-time(min_ind);
        
        psdest = psd(spectrum.periodogram,x,'Fs',150e3,'NFFT',length(x));
        mean_drop(i) = -avgpower(psdest,[1 70e3]);
        
        if(mean_drop(i)<-0.5)
            time_drop(i)=0;
            mean_drop(i)=0;
            dumped = dumped+1;
        end
        
    catch
        dumped = dumped +1;
    end
    
    %[mean_drop(i),time_drop(i),ecds(i)]=neroli_crude_drop(data,time);
end
disp(['I threw away ' num2str(dumped) ' events']);
end




