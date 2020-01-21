function [ DataOut, Thesholded, PeakLocations ] = neroli_excess_peak_beGone( RawData, HPFdata, fs)
%Remove peaks which are due to sudden changes in the data 
% ie as a result of transients or loos of contact
% Features wich cannot represent a translocation

ExtraDistance = fs/3;

[PeakLocations , Thesholded] = ThresholdPeakDetection( HPFdata);
% peaks1 = PeakLocations(1,:);
% peaks2= PeakLocations(2,:);
% 
% time = 0:1/150e3:((length(HPFdata)-1)/150e3);

%plot(time,HPFdata);hold on; plot(time(peaks1),HPFdata(peaks1),'*r');

noPeaks = size(PeakLocations,2);
nd = max(size(RawData));

for i = 1:noPeaks
    Pstart = PeakLocations(1,i)-ExtraDistance;
    Pend = PeakLocations(2,i)+ExtraDistance;
    
    if (Pstart < 1); Pstart = 1;end;
    if (Pend > nd); Pend = nd;end;
        
        
    Vstart = RawData(Pstart);
    Vend = RawData(Pend);
    
    %Now test if they are different values
    
    if abs(Vstart - Vend) > 2
        HPFdata(Pstart:Pend,1) = zeros((Pend - Pstart)+1,1);
    end
end

DataOut = HPFdata;

end

