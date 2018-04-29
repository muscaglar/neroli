function [ Translocations ] = AnalyseTranslocations( Trace, TranslocationLocations, SampleFreq, VoltageTrace, FileName, TraceID )
%UNTITLED4 Analyse all found translocations
%   Analyse all found locations and return vectors of Time, Depth and ECD
%   Could also carry out any other analysis on each individual
%   translocation
TranslocationLimits
NoTrans = max(size(TranslocationLocations(:,1)));
Translocations = [];
L = max(size(Trace));
nPointsExtra = (TimeEitherSide_ms/1000) * SampleFreq;

for n = 1:NoTrans
    if (TranslocationLocations(n,1)-nPointsExtra) > 0 && (TranslocationLocations(n,2)+nPointsExtra) < L
        
        tTrace = Trace(TranslocationLocations(n,1)-nPointsExtra:TranslocationLocations(n,2)+nPointsExtra);
        
        if nargin >= 4
            vTrace = VoltageTrace(TranslocationLocations(n,1)-nPointsExtra:TranslocationLocations(n,2)+nPointsExtra);
        else
            vTrace = [];
        end
        
        T = Translocation(tTrace,vTrace, SampleFreq, nPointsExtra, FileName, TranslocationLocations(n,1), TraceID);
        
        %Do anyother analysis on this translocation
        
        %Store this translocation into the array to be returned
        Translocations = [Translocations; T];
    else
        % Doens't fit  - could re do so uses the edges
    end
end


% %Do a plot
% figure(4);
% subplot(1,2,1);
% plot(Time, Depth, 'b.');
% xlabel('Duration (mS)');
% ylabel('Depth (pA)');
% subplot(1,2,2);
% bins = min(ECD):0.1:max(ECD);
% hist(ECD,bins);

end

