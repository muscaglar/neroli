function [ Results, NoFiles ] = RunTranslocationAnalysis( Input, channels )
%RUNTRANSLOCATIONANALYSIS Summary of this function goes here
%   Detailed explanation goes here

%If input not present then will call and get path shown
%Check if the input is a path ir a number
if nargin < 2
    channels = [3 4];
end

if nargin < 1
    [ Results, NoFiles ] = RunFnOverEveryFile(@TranslocationAnalysisFn,channels);
else
    if  isnumeric(Input)
        %Treat as Trace ID - or a vector of TraceIDs  - note that if a
        %vector then Results is only the final file analysed   - not the
        %results from all files
        [ Results, NoFiles ] = RunAnalysisOverDataSet( Input, @TranslocationAnalysisFn,channels,@SaveTranslocations);
    elseif ischar(Input)
        %Treat as a Path
         [ Results, NoFiles ] = RunFnOverEveryFile(@TranslocationAnalysisFn, channels, Input);
    else
        warning('Don''t recognise input');
    end
end

%Tranlocation Analysis is now complete - could choose to do some processing
%on the result set

end

