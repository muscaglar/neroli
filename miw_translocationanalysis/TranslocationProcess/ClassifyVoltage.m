function [ ClassifiedVoltage ] = ClassifyVoltage( MeanVoltage )
%CLASSIFYVOLTAGE Return the applied voltage - ie 100, 150, 200 etc

ClassifiedVoltage = round(MeanVoltage,2,'significant');

end

