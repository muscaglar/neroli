function [ no_t ] = PlotTranslocations( Translocations, InArg2 )
%PLOTTRANSLOCATION Summary of this function goes here
%   Detailed explanation goes here

if nargin == 1
    if ~isa(Translocations,'Translocation')
        %Treat as numeric or Path arg
        Translocations = LoadTranslocations(Translocations);
    end
elseif nargin == 2
    %Treat as Date No
    Translocations = LoadTranslocations(Translocations, InArg2);
else
    %Display the UI and load
    Translocations = LoadTranslocations();
end

w = 3;
h = 3;
i = 1;

n = max(size(Translocations));
no_t = 0;
for t = 1:n
    T = Translocations(t);
    if T.isValid > 0
        hold off;
        subplot(h,w,i);
        
        %T.AnalyseTrace();
        %Actualy Plot
        TranslocationTraceAnalyse( T.CurrentTrace, T.SampleFreq, T.nPointsExtra , 1 ); 
        
        % *********************
        if T.isValid ~= 0
            i = i+1;
        end
        title(num2str(t));
        %plot(T.CurrentTrace)
        hold on;
        no_t  = no_t  +1;
        if (i > (w*h))
            pause;
            i = 1;
        end
    end
end
no_t;
end

