function [ output_args ] = CapillaryTranslocationReAnalyse( CapillaryID )
%CAPILLARYTRANSLOCATIONReAnalyse Run the Translocation analysis again - ie
%to get new depth values etc  - but without having to reload the original
%full trace file - only work with the part of the trace saved into the file

Results = CapillaryTranslocationDispatcher( CapillaryID , @ReAnalyseTranslocations );


end