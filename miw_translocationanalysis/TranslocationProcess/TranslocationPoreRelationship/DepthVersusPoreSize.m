function [Sizes, Depths, Currents, dG, Times, Voltages] = DepthVersusPoreSize(CapillaryIDs)

Voltages = [200 400 500 600];
MinNoTranslocations = 20;

i = 1;
for CapillaryID = CapillaryIDs
    %[ Diameter_nm, R_NewPore, R_Membrane, BareID, BeforeID, BrokenIDs ] = VBreakPoreSizeByCapillary( CapillaryID );
    [ Diameter_nm, ~,~ ] = UpdateNameValueCapillary( CapillaryID, 'VBreakPoreDiameter');
    
    Sizes(i) = Diameter_nm(1);
    
    [ Results ] = CapillaryTranslocationProcess( CapillaryID );
    
    Voltage = Results(:,1)';
    %     Time =  Results(:,2)';
    %     Depth = Results(:,3)';
    %     ECD =  Results(:,4)';
    
    MaxDepth = -2000;
    
    for V = 1:length(Voltages)
        Depth = Results(Voltage == Voltages(V),3)';
        Current = Results(Voltage == Voltages(V),5)';
        Time = Results(Voltage == Voltages(V),2)';
        if length(Depth) > MinNoTranslocations
            DepthMean = mean(Depth(Depth > MaxDepth));
            Depths(i,V) = DepthMean;
            CurrentMean = mean(Current(Depth > MaxDepth));
            Currents(i,V) = CurrentMean;
            Times(i,V) =  mean(Time(Depth > MaxDepth));
            dG(i,V) = ( CurrentMean/Voltages(V) ) - ( ( CurrentMean + DepthMean)/Voltages(V) ) ;
            
        else
            Depths(i,V) = 0;
            Currents(i,V) = 0;
            dG(i,V) = 0;
        end
    end
    
    i = i + 1;
end


end