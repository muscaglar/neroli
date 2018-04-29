function [ PeakLocations, DataOut ] = ThresholdPeakDetection( DataIn, value, Mode)
%THRSHOLDPEAKDETECTION 
% Do a very rough peak detection this can be used to find the peaks in the
% HPF signal which are due to changes in the over all current - not
% translocations

if nargin < 3
    Mode =2;
end
if nargin <2
    value = 0.6;
end

[ DataOut ] = Threshold( DataIn , value, Mode );

PeakLocations = [];
PeakStart = 1;
PeakEnd = 1;
n = max(size(DataIn));
t = 0;
for i = 1:n
   if(abs(DataOut(i)) > 0 && t == 0)
       %Start Peak
       t = 1;
       PeakStart = i;
   elseif(DataOut(i) ==  0 && t ==1)
        %end Peak
        t = 0;
        PeakEnd = i;
        PeakLocations = [PeakLocations, [PeakStart; PeakEnd]];
   end
end
if ( t ==1)
   %ends on a peak
   PeakLocations = [PeakLocations, [PeakStart; n]];
end

end

