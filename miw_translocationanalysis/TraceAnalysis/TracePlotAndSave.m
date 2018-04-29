function [ output_args ] = TracePlotAndSave(  Data, FileName, FolderName )
%TRACEPLOTANDSAVE Summary of this function goes here
%   Detailed explanation goes here


[ TraceDate, TraceNo, TraceObj, TraceID ] = GetTraceDetailsByFName( FileName );
if(TraceID > 0)
    SampleRate = TraceObj.getSampleFreq();
else
    %default to 20kHz
    SampleRate = 20e3;
end

n = size(Data(:,2),1);
[ T, ~, ~ ] = GetSampleTimes( n , SampleRate );

plot(T,Data(:,2));
xlabel('Time (S)')
ylabel('Current (nA)');
title(['No: ' num2str(TraceNo) ' Date: ' GetDateString(TraceDate) ' Section only']);

PathName = FolderName;
if exist([PathName '/TracePlots']) == 0
    mkdir(PathName,'TracePlots')
end
%print([PathName '/Analysis/Plots/' num2str(date) '_' num2str(no) '_' details '.jpg'],'-djpeg')
GraphKeyserify;
print([PathName '/TracePlots/' FileName '.jpg'],'-djpeg')


end

