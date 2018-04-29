function [ Times_ms, CurrentTrace, VoltageTrace, ORG] = PlotTranslocationsInOrigin( TraceID, TranslocationNos,  nPointsExtra, PlotName )
%PLOTTRANSLOCATIONSINORIGIN Summary of this function goes here
%   Detailed explanation goes here

Translocations = LoadTranslocations(TraceID);

for t = TranslocationNos
    
    T = Translocations(t);
    
    if nargin < 4
        PlotName = ['Trans' num2str(t) 'Tid' num2str(TraceID) ];
        if nargin < 3
            nPointsExtra = T.nPointsExtra;
        end
    end
    
    n = length(T.VoltageTrace);
    TimePeriod = 1/T.SampleFreq;
    Times = 0:TimePeriod:(n-1)*TimePeriod;
    
    Times_ms = 1e3 * Times;
    
    %Now shorten the data if N point extra not required
    if nPointsExtra < T.nPointsExtra
        
        d = T.TStart - nPointsExtra ;
        e = T.TEnd + nPointsExtra;
        CurrentTrace = T.CurrentTrace(d:e);
        VoltageTrace = T.VoltageTrace(d:e);
        Times_ms = Times_ms(d:e);
        Times_ms = Times_ms - Times_ms(1); %Set the first value to 0 again
    else
        CurrentTrace = T.CurrentTrace;
        VoltageTrace = T.VoltageTrace;
    end
    
    %Now plot the data in T - note could use trace plotting code....
    ORG = Matlab2OriginPlot();
    ORG.HoldOff;
    
    PlotName = ORG.PlotLine(Times_ms,CurrentTrace',PlotName, 'blue' );  
    ORG.yComment(['Tid' num2str(TraceID) 'Translocation ' num2str(t) ]);
    ORG.ylabel('Current','nA');
    ORG.xlabel('Time','mS');
    ORG.HideActiveWkBk;
    
    ORG.title(PlotName);
    
    ORG.HoldOn;
    ORG.NewLayer(1,0);
    
    %PLot abs of frame data - to match the AC sweeps
    ORG.PlotLine(Times_ms,VoltageTrace',PlotName , 'red' );
    ORG.yComment(['Tid' num2str(TraceID) 'Translocation ' num2str(t) ]);
    ORG.ylabel('Voltage','mV');
    ORG.xlabel('Time','ms ');
    ORG.HideActiveWkBk;
    
    
end

end

