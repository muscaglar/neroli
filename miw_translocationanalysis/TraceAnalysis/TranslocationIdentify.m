function [ TranslocationLocations, t ] = TranslocationIdentify( Trace, SampleFreq )
%TranslocationIdentify Identify translocations
%   Run through the trace and use some logic to find translocations  - not
%   sure what logic to use or what to return
%   Could just return the translocation start and end positions
%   Then another piece of code can use those start and end points to
%   analyse
L = max(size(Trace));
TranslocationLocations = [];
if(L > 2)
    TranslocationLimits;
    %Could use Translocation Limits  - but am happy for identify to be more
    %generous and then test validity later
    MinTranslocationTime = (MinTranslocationTime_ms / 1000) * SampleFreq; %mS
    MaxTranslocationTime = (MaxTranslocationTime_ms / 1000) * SampleFreq; %mS
    
    a = 5/SampleFreq;
    %Calc An envelope based on the square C.f. with Variance as mean is 0
    M2 = 0;
    S_Vec = [];
    nStds = NoStardardDevToDetect; %Loaded From Translocation Limits
    %plot([1 L], [S S],'-r');
    
    Ahead = 2000;
    if Ahead > L
        Ahead = L - 1;
        if(Ahead < 1)
            Ahead = 1;
        end
    end
    x = flipud(Trace(1:Ahead));
    z = Trace(end-Ahead:end);
    Data = [x; Trace; z];
    
    InTrans = 0;
    t = 0;
    for n = 1:Ahead
        %Run in on M2 to get the term set up - then it will continue to run
        %ahead anyway
        M2 =  (1-a) * M2 + a*((Data(n) - 0) * (Data(n) - 0 ));
    end
    for n = 1:L+Ahead;
        
        %Run over the trace and search for translocations  - note assume that the
        %trace has been adequately filtered  - so just apply some logic to indetify
        %trace
        
        %Need to average for all points otherwise a step will not be adapted
        %for sast enough
        %NB Assuming 0 mean - as data has been HPF
        M2 =  (1-a) * M2 + a*((Data(n+Ahead) - 0) * (Data(n+Ahead) - 0 ));
        
        S = sqrt(M2);
        T = nStds*S;
        S_Vec = [S_Vec T];
        
        if InTrans == 0
            % Not in translocation look for start.
            if (abs(Data(n)) > ( nStds*S )) && n > Ahead;
                % Start of a translocation
                tStart = n - Ahead;
                InTrans = 1;
            end
            
        elseif n > Ahead
            
            %in translocation - look for end
            if abs(Data(n)) < ( (nStds / 4)*S )
                % End of translocation
                tEnd = n - Ahead;
                InTrans = 0;
                if (tEnd - tStart) > MinTranslocationTime
                    %If Happy with translocation  - could set a min width
                    TranslocationLocations = [TranslocationLocations; tStart tEnd];
                    t = t + 1;
                end
                if (n-Ahead - tStart) > MaxTranslocationTime
                    InTrans = 0;
                end
            end
            %End of in Translocation
        end
        
        %End of For loop
    end
    
%     plot(S_Vec(Ahead:end),'-r');
%     plot(0.5*S_Vec(Ahead:end),'-b');
%     plot(-1*S_Vec(Ahead:end),'-r');
    %max(size(S_Vec(Ahead:end)));
    %  figure(1);
    %  plot(Trace, 'r');
    % hold on;
    %  plot(limit,'k');
    
    % if t < 100
    %     u = mean(Trace);
    %     U = u * ones(max(size(TranslocationLocations(:,1))));
    %     plot(TranslocationLocations(:,1),U,'o')
    %     plot(TranslocationLocations(:,2),U,'+')
    % end
else
    t = 0;
end

end

