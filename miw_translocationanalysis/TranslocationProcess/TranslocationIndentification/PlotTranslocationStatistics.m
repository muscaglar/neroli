function [ ECDbinCentres, ECDcounts ] = PlotTranslocationStatistics( Voltage, Depth, Time, ECD, title_text, FigNo, Date, No, CompositResult )
%PLOTTRANSLOCATIONSTATISITCS Take the numerical values and plot the data
%for these  - ie after all processing - this is just a plot function
%and possibly also fitting  - where known could save fit value to DB - but
%pass in trace ID - or just pas out to be saved elsewhere

%Could also do the fiting to these plots and return the fit parameters

%Note depth may be mean depth or depth - depending on whats being passed
%in!
        if nargin < 9
            CompositResult = 0;
        end

        V = unique(Voltage);
        
        PlotRows = 2;
        PlotCols = 2;
        
        NoTranslocationByVoltage = [];
        
        TimeRange = linspace(min(Time), max(Time), 100);
        
        figure(FigNo);
        hold off;
        for n = 1:size(V,2)
            hold off;
            
            DepthByV = Depth(Voltage == V(n));
            TimeByV = Time(Voltage == V(n));
            ECDbyV = ECD(Voltage == V(n));
            
            subplot(PlotRows ,PlotCols,1);
            hold off;
            plot(TimeByV', DepthByV',['+' ColourWheel(n)]);
            %plot(Time', Depth','+');
            xlabel('Time (mS)');
            ylabel('Depth (pA)');
            %GraphKeyserify();
            title([title_text ' ' num2str(V(n))]);
            hold all;
            
            %No point fitting the hyperbolae when
%            [ A,B,pow, Y_fitted ] = hyperbolaeFit( Time(Voltage == V(n))',Depth(Voltage == V(n))', 1, 1, 1, TimeRange);
%            plot(TimeRange, Y_fitted,'--k');
           
           axis_limits = [0 (1.1*max(TimeByV)+1) 1.05*min(DepthByV)-1 1.05*max(DepthByV)+1];
           axis([0 20 -250 0]);
            
            subplot(PlotRows ,PlotCols,2);
            hold all;
            [ ECDbinCentres, ECDcounts, MinRange, MaxRange, PlotData ] =  SmartHistogramPlot( ECDbyV,0.1, 99, FigNo, PlotRows ,PlotCols,2, 0  );
             set(get(gca,'child'),'FaceColor',ColourWheel(n),'EdgeColor',ColourWheel(n));
            xlabel('ECD');
            %GraphKeyserify();
            
            %Add point to voltage/no translocations
            NoTranslocationByVoltage = [ NoTranslocationByVoltage; V(n) size(DepthByV,2)];
            
            
            subplot(PlotRows ,PlotCols,3);
            hold all;
            SmartHistogramPlot( DepthByV,1, 99, FigNo, PlotRows ,PlotCols,3, 0  );
            set(get(gca,'child'),'FaceColor',ColourWheel(n),'EdgeColor',ColourWheel(n));
            xlabel('Depth');
            %GraphKeyserify();
            hold all;
            
            subplot(PlotRows ,PlotCols,4);
            hold all;
            SmartHistogramPlot( TimeByV,0.1, 99, FigNo, PlotRows ,PlotCols,4, 0  );
            set(get(gca,'child'),'FaceColor',ColourWheel(n),'EdgeColor',ColourWheel(n));
            xlabel('Time');
            %GraphKeyserify();
            hold all;
            
            %Save the plot as an image
            FileRoots;
            DateStr = GetDateString(Date);
            if CompositResult > 0
                FileName = [DateStr '_C' num2str(No)];
            else
                FileName = [DateStr '_' num2str(No)];
            end
            if exist([TranslocationRoot '/' DateStr],'dir') == 0
                mkdir([TranslocationRoot],DateStr);
            end
            if exist([TranslocationRoot '/' DateStr '/' FileName],'dir') == 0
                mkdir([TranslocationRoot '/' DateStr],FileName);
            end
            print([TranslocationRoot '/' DateStr '/' FileName '/' FileName '_' num2str(V(n)) '.jpg'],'-djpeg');
        end
        hold off;
        figure(FigNo+1);
        subplot(1,1,1);
        hold off;
        semilogy(NoTranslocationByVoltage(:,1),NoTranslocationByVoltage(:,2),'or');
        xlabel('Voltage (V)');
        ylabel('No Translocations');
        
        print([TranslocationRoot '/' DateStr '/' FileName '/' FileName '_Summary' '.jpg'],'-djpeg');
        
end

