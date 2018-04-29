function [ Time, Depth, ECD, TStart, TEnd, Valid, MeanDepth] = TranslocationTraceAnalyse( TranslocationTrace, SampleFreq , nPoints, PlotOn )
%UNTITLED2 Summary of this function goes here
%   Take The raw trace and analyse it  - but need to know where trace
%   starts and stops.
TranslocationLimits;

Valid = 1;
if nargin < 4
    PlotOn = 0;
end

%Note need to re find the edges - then set a mean value  - then calaulate
%the ECD, depth and width.  - or use the existing edges...
n = size(TranslocationTrace,1);
InitialThreshold = mean([TranslocationTrace(1:nPoints); TranslocationTrace((n - nPoints ):n)]);
TStart = nPoints;

if InitialThreshold > 0
    Sign = 1;
else
    Sign = -1;
end

%Check the translocation doesn't actually start earlier
InTrans = 0;
for i = 1:nPoints
    if(abs(TranslocationTrace(i)) < (abs(InitialThreshold))) && InTrans == 0;
        TStart = i;
        InTrans = 1;
    end
    if(abs(TranslocationTrace(i)) > (abs(InitialThreshold))) && InTrans == 1;
        %Gone back over trheshold so not actually in the translocation
        TStart = i;
        InTrans = 0;
    end
end

InTrans = 0;
TEnd = n - nPoints;   %Had removed the minus but should start in the correct place
MinValue = abs(InitialThreshold);
for i = nPoints:n
    if InTrans == 1 || InTrans == 3
        if abs(TranslocationTrace(i)) < MinValue
            MinValue = abs(TranslocationTrace(i));
            InTrans = 1;
        end
        if abs(TranslocationTrace(i)) >= (abs(InitialThreshold) - 0.2*(abs(InitialThreshold) - MinValue)) && InTrans ~= 2
            %Need to ensure this happens after the minima!
            TEnd = i;
            InTrans = 3;
            %Break
        end
        
        
        if abs(TranslocationTrace(i)) >= abs(InitialThreshold)
            TEnd = i;
            InTrans = 2;
            %Break
        end
    elseif  (abs(TranslocationTrace(i)) < abs(InitialThreshold)) && InTrans == 0
        InTrans = 1;
    end
end

if InTrans < 2
    %Didn't find end
    Valid = 0;
end

Th = mean([TranslocationTrace(1:TStart) ; TranslocationTrace(TEnd:end)]);

Time = 0;
Depth = 0;
ECD = 0;

ECD = sum(TranslocationTrace(TStart:TEnd) - Th);
Depth = (Th - min(Sign*(TranslocationTrace(TStart:TEnd)))) * 1000;   % in pA
MeanDepth = (Th - mean(TranslocationTrace(TStart:TEnd))) * 1000;
if(Sign*MeanDepth < 0)
    Valid = 0;
end
%Need to calc the time
Time = TEnd - TStart;
%Convert to mS
Time = Time * (1/SampleFreq) * 1000;

%Now Test Valididty %using values loaded in TranslocationLimits;
if(Time < MinTranslocationTime_ms || Time > MaxTranslocationTime_ms)
    Valid = 0;
end
if(abs(Depth) > MaxTranslocationDepth || abs(Depth) < MinTranslocationDepth )
    Valid = 0;
end

if PlotOn == 1
    %subplot(2,2,4);
    hold off;
    %plotrange = nPoints-20:n-3*nPoints/4;
    plot(TranslocationTrace)
    hold on
    %PLot the base line of the transloation - found locally
    plot([1 (n)],[InitialThreshold InitialThreshold],'r');
    plot([1 (n)],[Th Th],'k');
    %plot([TStart TEnd],[Th-Sign*(Depth/1000) Th-Sign*(Depth/1000)],'r');
    %PLot the identified start and end points
    plot([TStart (TEnd)],[Th InitialThreshold],'or');
    title(['Valid :' num2str(Valid) ' Depth: ' num2str(Depth) ' Time: ' num2str(Time) ' EDC: ' num2str(ECD)]);
    hold off
end

end

