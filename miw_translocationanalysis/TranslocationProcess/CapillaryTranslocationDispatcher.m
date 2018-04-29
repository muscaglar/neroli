function [ Results , C] = CapillaryTranslocationDispatcher( CapillaryID , FunctionToExecuteOnTranslocations )
%CAPILLARYTRANSLOCATIONDISPATCHER Summary of this function goes here
%   Detailed explanation goes here

Results = [];

%Load the Trace IDs for this capillary  - note could load only unsuppressed
%etc
DB = DBConnection;
C = Capillaries(DB,CapillaryID);
T = Traces(DB);
str = ['tcapillary = ''' num2str(CapillaryID) ''' AND tSuppressed = 0'];
T.SELECT(str);
%Can load the full result set and close the DB
%To Array will give an array of objects so need to make into a double array
TraceIDs = arrayfun(@(e)e,  T.ResultSetIDs.toArray() );

for t = TraceIDs'
    Results = [Results ; FunctionToExecuteOnTranslocations( t )];
    %pause
end


end

