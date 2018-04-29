function [ DataOut, Thesholded, PeakLocations ] = OffsetPeakRemoval( RawData, HPFdata, ExtraDistance)
%Remove peaks which are due to sudden changes in the data 
% ie as a result of transients or loos of contact
% Features wich cannot represent a translocation

if nargin < 3
ExtraDistance = 100;
end

[PeakLocations , Thesholded] = ThresholdPeakDetection( HPFdata);
plot((Thesholded),'k');
%plot(PeakLocations,'or');
%Now use these peak locations to remove them

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

