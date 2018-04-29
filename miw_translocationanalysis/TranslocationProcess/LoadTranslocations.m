function [ Translocations, FileName, PathName ] = LoadTranslocations( InArg1, InArg2 )
%LOADTRANSLOCATIONS Load the array of translocations Objects from a file
% Might want to load by Date/Number, or trace No or by FileNamePath Name
FileRoots;

if nargin < 1
    %Show dialog to select file
    [FileName, PathName] = uigetfile({'*.mat','Matlab Data Files';},'Choose Translocations File', TranslocationRoot);
    FilePath = [PathName '/' FileName];
elseif nargin < 2
    if  isnumeric(InArg1)
        %Treat as Trace ID
        [ TraceDate, TraceNo, ~ ] = GetTraceDetails( InArg1 );
        %FilePath = [TranslocationRoot '/' GetDateString(TraceDate) '/' GetDateString(TraceDate) '_' num2str(TraceNo) '.mat'];
        PathName = [TranslocationRoot '/' GetDateString(TraceDate)];
        FileName = [GetDateString(TraceDate) '_' num2str(TraceNo) '.mat'];
        FilePath = [PathName '/' FileName];
    elseif ischar(InArg1)
        %Treat as a Path
        PathName = '';
        FileName = InArg1;
        FilePath = InArg1;
        %Could test if it exists!
    else
        warning('Don''t recognise input');
    end
else
    if nargin == 2
        if  isnumeric(InArg1)
            %Treat as Date and Number
            TraceDate = InArg1;
            TraceNo = InArg2;
            PathName = [TranslocationRoot '/' GetDateString(InArg1)];
            FileName = [GetDateString(InArg1) '_' num2str(InArg2) '.mat'];
            FilePath = [PathName '/' FileName];
        else
            %Treat as Path and file name
            PathName = InArg1;
            FileName = InArg2;
            FilePath = [PathName '/' FileName];
        end
    end
end

% Should check if it exists - but code will error anyway if it doesn't
if exist(FilePath,'file') == 2
    load(FilePath,'Translocations');
    %Translocations
elseif(TraceDate > 0 && TraceNo > 0)
    %Try to load from DataAccess
   [ FileName, PathName, FilePath ] = GetCloudTranslocations( TraceDate, TraceNo);
    if exist(FilePath,'file') == 2
        load(FilePath,'Translocations');
    else
        %Cannot find locally or on server so return null
        Translocations = [];
    end
else
    %Cannot find locally and don't have Date and No
    Translocations = [];
end
end

