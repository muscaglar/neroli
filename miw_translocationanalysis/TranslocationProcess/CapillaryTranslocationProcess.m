function [ Results ] = CapillaryTranslocationProcess( CapillaryIDs )
%CAPILLARYTRANSLOCATIONPROCESS For a capillary load the save analysis and
%Note returns only the last result

for CapillaryID = CapillaryIDs
    
    [Results, C] = CapillaryTranslocationDispatcher( CapillaryID , @ProcessTranslocations );
    
    %Read the Data out from results
    
    %Results = [Voltages', Time', Depth', ECD'];
    if(size(Results,2) == 4)
        Voltage = Results(:,1)';
        Time =  Results(:,2)';
        Depth = Results(:,3)';
        ECD =  Results(:,4)';
        
        %Now plot all the translocations for this capillary - colour coded by
        %voltage
        %if no_t > 0
        
        PlotTranslocationStatistics( Voltage, Depth, Time, ECD, ['Capillary: ' num2str(CapillaryID)], 4, GetNumericDate(C.getDate), C.getid, 1 );
        
    end
    
end

end