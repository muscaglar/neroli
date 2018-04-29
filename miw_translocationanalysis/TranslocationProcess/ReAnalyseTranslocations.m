function [  no_t  ] = ReAnalyseTranslocations( InArg1, InArg2 )
%REANALYSETRANSLOCATIONS - re run the trace analysis on each tranalocation
%- that has already been pulled out - eg to update with new parameters etc
% then save the translcoations file back again

if nargin == 1
    if ~isa(InArg1,'Translocation')
        %Treat as numeric or Path arg
        [ Translocations, FileName, PathName ] = LoadTranslocations(InArg1);
    else
        Translocations = InArg1;
    end
elseif nargin == 2
    %Treat as Date No
    [ Translocations, FileName, PathName ] = LoadTranslocations(InArg1, InArg2);
else
    %Display the UI and load
    [ Translocations, FileName, PathName ] = LoadTranslocations();
end

n = size(Translocations,1);
if n > 0
    no_t = 0;
    %On each translocation re run the analysis code
    for i = 1:n
        Translocations(i).AnalyseTrace();
    end
    
    %Now re save out all the translocations - to the same location
    SaveTranslocations( Translocations, PathName, FileName);

else
   %No translocations
   no_t = 0;
end
end

