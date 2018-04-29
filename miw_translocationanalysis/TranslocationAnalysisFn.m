function [ Result ] = TranslocationAnalysisFn( Data, FileName, FolderName )
%TRANSLOCATIONANALYSISFN This is the function that will be called on each
%file of IV data.
% Works within the TDMS handling code described here:
% https://bitbucket.org/MiWalker/phd_tdmshandling
% https://bitbucket.org/keyserlab/tdmshandling
% There needs to be an alysis script that passes this function to the
% RunFnOverEveryFile or RunAnalysisOverDataset

% This function will return an array of translocation types
TranslocationLimits

PlotOn = 0;

%Will load from DB if it exists  - need to somehow test if installed.
[ TraceDate, TraceNo, TraceObj, TraceID ] = GetTraceDetailsByFName( FileName );
if(TraceID > 0)
    SampleRate = TraceObj.getSampleFreq();
else
    SampleRate = 2000;
end
%Must ensure that TraceID and sample Rate are set

%TracePlotAndSave(  Data, FileName, FolderName );

if TraceObj.getFilterFreq() > 50
    Data(:,2) = LowPassFilter( Data(:,2) , NumericalFilterFreq , SampleRate );
end

%Remove the base line from the signal
Highpass = HighPassFilter( Data(:,2) );

if PlotOn == 1
    figure(2)
    subplot(2,2,1);
    hold off;
    plot(Data(:,2),'b')
    subplot(2,2,2);
    hold off
    plot((Highpass),'r');
    hold on
end
%Now do a rough peak detection to remove peaks where there is a big change
%in the dc value
CleanHPF = OffsetPeakRemoval( Data(:,2), Highpass,120);
if PlotOn == 1
    subplot(2,2,3);
    hold off;
    plot((CleanHPF),'k');
    hold on;
end
%Now have a trace which is about 0 and have rmeoved both baseline and other
%effects
[ TranslocationLocations, noTranslocations ] = TranslocationIdentify( CleanHPF, SampleRate);
%Now analyse the located translocations  - Pass in botjh current and voltage

if noTranslocations > 0
    disp([num2str(noTranslocations) ' Transloations identified']);
    if PlotOn == 1
        u = 0; %Can be mean of trace to plot the points on
        U = u * ones(max(size(TranslocationLocations(:,1))));
        plot(TranslocationLocations(:,1),U,'or');
        plot(TranslocationLocations(:,2),U,'+r');
        subplot(2,2,4);
    end
    [ Translocations ] = AnalyseTranslocations( Data(:,2), TranslocationLocations, SampleRate, Data(:,1), FileName, TraceID );
else
    disp('No translocations identified');
    Translocations = [];
end

Result = Translocations;

%pause();
end

