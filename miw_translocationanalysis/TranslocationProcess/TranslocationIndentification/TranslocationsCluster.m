function [ Results, mu, sigma, Assignment] = TranslocationsCluster( TranslocationResults, NoLengths, V )
%TRANSLOCATIONSCLUSTER Separate all identified translocations (for a given voltage)
%into different lengths - then return the same data with an additional column.
if nargin > 2
    TranslocationResultsByV = TranslocationResults(TranslocationResults(:,1) == V,:);
else
    if length(unique(TranslocationResults(:,1))) > 1
        %Havn't selected a voltage
        error('Need to define a voltage');
    else
        TranslocationResultsByV = TranslocationResults;
    end
end

%TranslocationResultsByV = TranslocationResultsByV(TranslocationResultsByV(:,3) > -100,:);

if(size(TranslocationResultsByV,2) >= 4)
    Voltage = TranslocationResultsByV(:,1)';
    Time =  TranslocationResultsByV(:,2)';
    Depth = TranslocationResultsByV(:,3)';
    ECD =  TranslocationResultsByV(:,4)';
    
    % [ mu, sigma, Assignment  ] = AssignFitNormals( ECD, NoLengths );
   % [ mu, sigma, Assignment  ] = AssignFitNormals_MultiVariate( [1./Time; Depth], NoLengths  );
   [ mu, sigma, Assignment  ] = AssignFitNormals_MultiVariate( [1./Time; Depth; ECD ], NoLengths  );

    %Now fit the data to find the best way to work with it
    TimeRange = linspace(0.1, 30, 20);
    FigNo = 0;
    PlotRows = 2;
    PlotCols = 2;
    hold off;
    for n = 1:NoLengths
        S = TranslocationResultsByV(Assignment == n,:);
        
        
        subplot(PlotRows ,PlotCols,1);
        hold all;
        %Insert 1./ to see clustering better
        plot(S(:,2),S(:,3),'+')
        xlabel('Time (mS)');
        ylabel('Depth (pA)');
        %title([title_text ' ' num2str(V(n))]);
        axis([0 20 -150 0]);
        hold all;
        
        TimeRange = linspace(0.1,20,40);
        [ A,B,pow, Y_fitted ] = hyperbolaeFit( S(:,2),-1*S(:,3), 1, 1, 1, TimeRange);
        plot(TimeRange, -1*Y_fitted,'--k');
        axis([0 20 -150 0]);
        
        subplot(PlotRows ,PlotCols,2);
        hold all;
        [ ECDbinCentres, ECDcounts, MinRange, MaxRange, PlotData ] =  SmartHistogramPlot( S(:,4),0.1, 99, FigNo, PlotRows ,PlotCols,2, 1  );
        xlabel('ECD');
        
        subplot(PlotRows ,PlotCols,3);
        SmartHistogramPlot(S(:,3),1, 99, FigNo, PlotRows ,PlotCols,3, 1 );
        xlabel('Depth');
        
        subplot(PlotRows ,PlotCols,4);
        
        SmartHistogramPlot( S(:,2),0.1, 99, FigNo, PlotRows ,PlotCols,4, 1  );
        xlabel('Time');
        
        Results = [TranslocationResultsByV Assignment];
        
        %Note can't plot here as don't have the necessary file name data -
        %and donw't want to get it.
        
    end
    subplot(PlotRows ,PlotCols,1);
    plot(1./mu(1,:),mu(2,:),'ok');
else
    Results = TranslocationResultsByV;
    
end
end

