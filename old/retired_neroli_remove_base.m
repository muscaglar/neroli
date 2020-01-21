function [current_fitted,time] = retired_neroli_remove_base(current,fs)
 
time = 0:1/fs:(length(current)-1)/fs;
current_fitted_1 = detrend(current);
%current_fitted_1 = current;
 
opol = round(length(current)/50000);
[p,s,mu] = polyfit(time',current_fitted_1,opol);
f_y = polyval(p,time,[],mu);
 
current_fitted = current_fitted_1 - f_y;
 
end