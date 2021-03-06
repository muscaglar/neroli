
close all;

s_i = current_trace;

f_s=150e3;
fc = 500;
order = 6;

N=length(s_i);
s_t=[0:N-1]/f_s;

s_i_f = neroli_filter(fc,f_s,s_i,'low',order);

figure, plot(s_t,s_i,'r'); title('Plotting a small section')
xlabel('time')
ylabel('amplitude')
hold on
plot(s_t,s_i_f,'g');
legend('ORIGINAL SIGNAL',' Flitered SIGNAL')
hold off
