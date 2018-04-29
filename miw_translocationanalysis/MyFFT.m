function [ Y1, f1, Abs_Val, Img_Val ] = MyFFT( Signal, SampleFreq )
%MYFFT Summary of this function goes here
%   Detailed explanation goes here

L = max(size(Signal));
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y1 = fft(Signal,NFFT)/L;
Y1_norm = Y1 ./ norm(Y1);
f1 = SampleFreq/2*linspace(0,1,NFFT/2+1);

Abs_Val = 2* abs(Y1_norm(1:NFFT/2+1));
Img_Val = (angle(Y1(1:NFFT/2+1))); 

%plot(f1,2*abs(Y1_norm(1:NFFT/2+1)),'b-');


end

