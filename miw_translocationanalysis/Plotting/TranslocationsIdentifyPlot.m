function [ R_Assigned, mu, sigma] = TranslocationsIdentifyPlot( TraceID, V , NoLengths, Prefix)
close all;
 R = ProcessTranslocations( TraceID );
[R_Assigned, mu, sigma, Assignment ] = TranslocationsCluster( R, NoLengths ,V);


%Save the plot as an image
FileRoots;
[ TraceDate, TraceNo, ~,~] = GetTraceDetails( TraceID );
DateStr = GetDateString(TraceDate);

subplot(2,2,1);
FileName = [DateStr '_' num2str(TraceNo)];
title([num2str(TraceID) ' ' FileName ' ' num2str(V) ' L:' num2str(NoLengths)]);

if exist([TranslocationRoot '/' DateStr],'dir') == 0
    mkdir([TranslocationRoot],DateStr);
end
if exist([TranslocationRoot '/' DateStr '/' FileName],'dir') == 0
    mkdir([TranslocationRoot '/' DateStr],FileName);
end
print([TranslocationRoot '/' DateStr '/' FileName '/' FileName '_' num2str(V) '_T' num2str(NoLengths) '.jpg'],'-djpeg');

if nargin > 3
    %Also plot into Origin
    ORG = Matlab2OriginPlot();
    
    
    %Assignment = R_Assigned(:,5);
    for n = 1:NoLengths;
        %For each length get the translocations
        
    VoltageByL = R_Assigned(Assignment == n,1)';
    TimeByL =  R_Assigned(Assignment == n,2)';
    DepthByL = R_Assigned(Assignment == n,3)';
    ECDByL =  R_Assigned(Assignment == n,4)';
        
        [ ECDbinCentres, ECDcounts, MinRange, MaxRange, PlotData ] =  SmartHistogramPlot( ECDByL , 0.1, 99 );
        [ TimebinCentres, Timecounts ] =  SmartHistogramPlot( TimeByL , 0.1, 99 );
        
        %Now need to actually do the plotting
        
        ORG = Matlab2OriginPlot();
        ORG.HoldOn
        c = ORG.ColourPicker(n);
        ORG.Figure(['Ti' num2str(TraceID) '_' num2str(NoLengths)])
        plotname = ORG.PlotScatter(TimeByL, DepthByL,['Ti' num2str(TraceID) 'Depth'],c);
        ORG.yComment(['Tid ' num2str(TraceID) ]);
        ORG.ylabel('Mean Current Depth','pA');
        ORG.xlabel('Time','mS');
        ORG.yaxisTo(0)
        ORG.xaxisStart(0)
        ORG.HideActiveWkBk;
        
        
        TimeRange = linspace(0.1,20,40);
        [ A,B,pow, Y_fitted ] = hyperbolaeFit( TimeByL,-1*DepthByL, 1, 1, 1, TimeRange);
        %plot(TimeRange, -1*Y_fitted,'--k');
        axis([0 20 -250 0]);
        
        ORG.PlotLine(TimeRange, -1*Y_fitted,plotname ,c);
        ORG.yComment(['HyperTid ' num2str(TraceID) ]);
        ORG.ylabel('Mean Current Depth','pA');
        ORG.xlabel('Time','mS');
        ORG.yaxisTo(0)
        ORG.xaxisStart(0)
        ORG.HideActiveWkBk;
        ORG.yaxisStart(-150);
        ORG.xaxisTo(20)
        
        ORG.title(['T' num2str(TraceID) 'Depth']);
        
        ORG.Figure(['TECD' num2str(TraceID) '_' num2str(NoLengths)])
        ORG.PlotColumn(ECDbinCentres, ECDcounts,['Ti' num2str(TraceID) 'ECD'],c);
        ORG.yComment(['Tid ' num2str(TraceID) ' ECD']);
        ORG.ylabel('Counts',' ');
        ORG.xlabel('E.C.D','C');
        ORG.logYScale;
        ORG.yaxisStart(0.8)
        ORG.xaxisTo(0);
        ORG.HideActiveWkBk;
        ORG.title(['T' num2str(TraceID) 'ECD']);
        
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
        
    end
    
    ORG.Disconnect;
    
end


end