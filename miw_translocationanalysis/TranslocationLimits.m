 %Define the settings for whats accepted as a translocation
%Time in mS
MaxTranslocationTime_ms = 100;
MinTranslocationTime_ms = 0.5;
% Depth in pA
MaxTranslocationDepth = 3000;
MinTranslocationDepth = 20;
%
MinTranslocationECD = 1;
MaxTranslocationECD = 2;
%
NoStardardDevToDetect=4;%Note usually 5 but relax sometimes  % How many SD outside mean to allow for postive event
%
TimeEitherSide_ms = 5;
%
NumericalFilterFreq = 55000;