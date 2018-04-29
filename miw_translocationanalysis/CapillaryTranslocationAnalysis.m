
function [ Result ] = CapillaryTranslocationAnalysis( CapillaryIDs , SuppressionCodes, MinFileNo)
%CAPILLARYTRANSLOCATIONANALYSIS Run the translocation analysis on all the
%Traces for a capillary or a vector of cacpillaries
%Note RunAnalysisOver Dataset doesn't return individual results
if nargin < 2
    SuppressionCodes = 0;
end

for CapillaryID = CapillaryIDs ;
    CapillaryID
    %Load the Trace IDs for this capillary  - note could load only unsuppressed
    DB = DBConnection;
    C = Capillaries(DB,CapillaryID);
    T = Traces(DB);
    if nargin < 3
        str = ['tcapillary = ''' num2str(CapillaryID) ''' AND ' ConcatVectorToSQL( SuppressionCodes, 'tSuppressed', 'OR' ) ' ORDER BY NO ASC'];
    else
        str = ['tcapillary = ''' num2str(CapillaryID) ''' AND ' ConcatVectorToSQL( SuppressionCodes, 'tSuppressed', 'OR' ) ' AND No > ' num2str(MinFileNo) ' ORDER BY NO ASC'];
    end
    T.SELECT(str);
    
    
    %Can load the full result set and close the DB
    %To Array will give an array of objects so need to make into a double array
    TraceIDs = arrayfun(@(e)e,  T.ResultSetIDs.toArray() );
    %See http://blog.matt-swain.com/post/31723249218/convert-java-lists-and-collections-into-matlab
    
    %NB cannot use returned results as they are for only the final Trace  - not
    %combined into 1
    if(not(isempty(TraceIDs)))
        RunTranslocationAnalysis( TraceIDs );
    end
    %May now want to look up the saved translcoation analysis from the DB - nb
    %not sure hwat form this will take
end

end

