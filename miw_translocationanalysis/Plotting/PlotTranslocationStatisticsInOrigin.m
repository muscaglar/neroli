function [ Results  ] = PlotTranslocationStatisticsInOrigin( TraceID, SelectVoltage, ECDBinSize )
%PLOTTRANSLOCATIONSTATISTICSINORIGIN Plot the translocation statisics for a
%trace at a given voltage only!
%Use ProcessTranslocation to generate saves images for all voltages for
%analysis

if nargin < 3
   ECDBinSize = 0.1 
end

[  Results  ] = ProcessTranslocations( TraceID );
if length(Results) > 1
    Voltage = Results(:,1)';
    Time =  Results(:,2)';
    Depth = Results(:,3)';
    ECD =  Results(:,4)';
    
    if nargin < 2
        SelectVoltage = Voltage(1);
    end
    
    DepthByV = Depth(Voltage == SelectVoltage);
    TimeByV = Time(Voltage == SelectVoltage);
    ECDbyV = ECD(Voltage == SelectVoltage);
    
    [ ECDbinCentres, ECDcounts, MinRange, MaxRange, PlotData ] =  SmartHistogramPlot( ECDbyV , ECDBinSize, 99 );
     [ TimebinCentres, Timecounts ] =  SmartHistogramPlot( TimeByV , 0.1, 99 );
    %Now need to actually do the plotting
    
    ORG = Matlab2OriginPlot();
    
    ORG.PlotScatter(TimeByV, DepthByV,['T' num2str(TraceID) 'Depth'],'red');
    ORG.yComment(['Tid ' num2str(TraceID) ]);
    ORG.ylabel('Mean Current Depth','pA');
    ORG.xlabel('Time','mS');
    ORG.yaxisTo(0)
    ORG.xaxisStart(0)
    ORG.HideActiveWkBk;
    
    ORG.title(['T' num2str(TraceID) 'Depth']);
    
    ORG.PlotColumn(ECDbinCentres, ECDcounts,['T' num2str(TraceID) 'ECD'],'blue');
    ORG.yComment(['Tid ' num2str(TraceID) ' ECD']);
    ORG.ylabel('Counts',' ');
    ORG.xlabel('E.C.D','C');
    ORG.logYScale;
    ORG.yaxisStart(0.8)
    ORG.xaxisTo(0);
    ORG.HideActiveWkBk;
    
    
    
    ORG.Figure(['Ttime' num2str(TraceID) '_' num2str(NoLengths)])
        ORG.PlotColumn(TimebinCentres, Timecounts,['Ti' num2str(TraceID) 'Etime'],c);
        ORG.yComment(['Tid ' num2str(TraceID) ' Time']);
        ORG.ylabel('Counts',' ');
        ORG.xlabel('Time','ms');
        ORG.logYScale;
        ORG.yaxisStart(0.8)
        ORG.xaxisTo(0);
        ORG.HideActiveWkBk;
        ORG.title(['T' num2str(TraceID) 'Time']);
    
    ORG.Disconnect;
    
   
end
end

