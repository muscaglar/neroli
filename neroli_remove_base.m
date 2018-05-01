function [current_fitted,time] = neroli_remove_base(current,fs)

time = 0:1/fs:length(current)/fs;
time(length(time)) = [];
time = time';
%current_fitted_1 = detrend(current);
current_fitted_1 = current;

opol = 6;
[p,s,mu] = polyfit(time,current_fitted_1,opol);
f_y = polyval(p,time,[],mu);

current_fitted = current_fitted_1 - f_y;

end