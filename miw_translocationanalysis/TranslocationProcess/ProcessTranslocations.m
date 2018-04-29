function [  Results, n   ] = ProcessTranslocations( InArg1, InArg2 )
%PROCESSTRANSLOCATIONS Take a vector of Translocation objects and analyse
%Within this area also want to provide functionality for saving
%translocations out  - either to DB or dat files - but need them to be
%retrievable

if nargin == 1
    if ~isa(InArg1,'Translocation')
        %Treat as numeric or Path arg
        Translocations = LoadTranslocations(InArg1);
    else
        Translocations = InArg1;
    end
elseif nargin == 2
    %Treat as Date No
    Translocations = LoadTranslocations(InArg1, InArg2);
else
    %Display the UI and load
    Translocations = LoadTranslocations();
end

n = size(Translocations,1);
if n > 0
    Time = [];
    Depth = [];
    MeanDepth = [];
    ECD = [];
    Voltage = [];
    Current = [];
    no_t = 0;
    for i = 1:n
        if Translocations(i).isValid > 0
            Time =  [Time Translocations(i).getTime];
            Depth =  [Depth Translocations(i).getDepth];
            MeanDepth = [MeanDepth Translocations(i).getMeanDepth];
            ECD =  [ECD Translocations(i).getECD];
            Voltage = [Voltage ClassifyVoltage(Translocations(i).getVoltageMean)];
            Current = [Current Translocations(i).getCurrentMean];
            no_t = no_t+1;
        end
    end

    if Translocations(1).TraceID > 0
         [rValue, rStringValue, rid] = UpdateNameValueTrace( Translocations(1).TraceID, 'noValidTranslocations',  no_t );
    end
    
    %Now split by voltage  - need to plot in different colours for each
    %voltage - so I can see affects properly  - ie need to plot
    %translocations separately for each!
    if no_t > 0
        [Date, fNo] = FileNameInterpret(char(Translocations(1).FileName));
        
        DepthToPlot = -1 * MeanDepth;  %THis could also be Depth but doesn't work as well
        
        PlotTranslocationStatistics( Voltage, DepthToPlot, Time, ECD, ['ID: ' num2str(Translocations(1).TraceID) ' FileName: ' GetDateString( Date ) '_ ' num2str(fNo)], 3, Date, fNo );
        
        Results = [Voltage' Time' DepthToPlot' ECD' Current'];
        
    else
        %Might want to record that there are no valid translocations
         Results = [];
    end
else
    %No translocations - so if I know the translocation ID Record this
    if n == 0 && nargin == 1 && isnumeric(InArg1)
        no_t = 0;
        %Use the known TraceID in InArg 1 to write 0 as no translocations
        %at all - let alone valid!
        [rValue, rStringValue, rid] = UpdateNameValue(0, InArg1, 0, 0, 'noValidTranslocations', no_t );
    end
    Results = [];
end
end

