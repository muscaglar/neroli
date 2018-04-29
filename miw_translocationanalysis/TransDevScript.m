% Development script

[ RawData ] = ConcatentateRawData([3 4], 'N');
Voltage = RawData(:,1);
Current = RawData(:,2);
clear('RawData');

SampleFreq = 20000;

%plot data
figure(1)
plot(Current);

%[ ~,f ,Abs_Val,~ ] = MyFFT( Current, 20000 );
%plot(f,Abs_Val,'b-');



%Low pass
%CurrentFiltered = LowPassFilter(Current);
 %[ ~,f ,Abs_Val,~ ] = MyFFT( CurrentFiltered, 20000 );
% plot(f,Abs_Val,'r-');

%High pass  filter
%CurrentHigh = HighPassFilter(Current);
%[ ~,f ,Abs_Val,~ ] = MyFFT( CurrentHigh, 20000 );
%plot(f,Abs_Val,'k-');

BaseLine = Smooth(Current, 1000);

Trace = Current - BaseLine; 
hold on;
plot(BaseLine);
plot(Trace);
error('Stop');

%Translocation Analysis
%Find translocations
[ TranslocationLocations ] = TranslocationIdentify( Current, SampleFreq);
%Plot translocation positions

%Analyse all translocations
[ Time, Depth, ECD ] = AnalyseTranslocations( Trace, TranslocationLocations, SampleFreq )

%Do something with data - ie plot
figure;
subplot(1,2,1);
plot(Time, -Depth,'.');
subplot(1,2,2);
hist(ECD);

