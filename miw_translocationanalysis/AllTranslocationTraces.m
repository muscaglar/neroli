
%Run over all the traces in a path - ie actually select each folrder and
%treat as a set of traces
Path = '';

for i = 1:100
[ Results, NoFiles ] = RunTranslocationAnalysis( Path );
end
%Once the code has run over all your data files the Results Matrxi will
%contain anything you have passed out - though you could also consider
%saving from within your analysis function
noPoints = sum(Results);

disp(['There are ' num2str(noPoints) ' data points in ' num2str(NoFiles) ' files.']);