 %Define the settings for whats accepted as a translocation
%Time in mS
MaxTranslocationTime_ms = 6;
MinTranslocationTime_ms = 0.2;
% Depth in pA
MaxTranslocationDepth = 600;
MinTranslocationDepth = 50;
%
MinTranslocationECD = 1;
MaxTranslocationECD = 2;
%
NoStardardDevToDetect= 4;   %Note usually 5 but relax sometimes  % How many SD outside mean to allow for postive event
%
TimeEitherSide_ms = 5;
%
NumericalFilterFreq = 55000;