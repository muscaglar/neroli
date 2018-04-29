classdef Translocation < handle
    %Code to hold the data for a translocation and to carry out analysis on
    %it etc
    
    properties
        SampleFreq;
        Time;
        Depth;
        MeanDepth;
        ECD;
        isValid;
        CurrentMean;
        VoltageMean;
        TStart;
        TEnd;
        
        %Raw Translocation Data
        CurrentTrace
        VoltageTrace
        nPointsExtra
        
        %Identification Data
        FileName
        TranslocationLocation
        TraceID
        
    end
    
    methods
        function obj = Translocation(Arg1, Arg2, Arg3, Arg4, Arg5, Arg6, Arg7)
            if nargin == 3
                obj.Time = Arg1;
                obj.ECD = Arg2;
                obj.Depth = Arg3;
            elseif nargin > 3
                obj.CurrentTrace = Arg1;
                obj.VoltageTrace = Arg2;
                obj.SampleFreq = Arg3;
                obj.nPointsExtra = Arg4;
                AnalyseTrace(obj);
            end
            if nargin > 4
                obj.FileName = Arg5;
            end
            if nargin > 5
                obj.TranslocationLocation = Arg6;
            end
            if nargin > 6
                obj.TraceID = Arg7;
            end
        end
        function Depth = getDepth(obj)
            Depth = obj.Depth;
        end
        function MeanDepth = getMeanDepth(obj)
            MeanDepth = obj.MeanDepth;
        end
        function Time = getTime(obj)
            Time = obj.Time;
        end
        function ECD = getECD(obj)
            ECD = obj.ECD;
        end
        function VoltageMean = getVoltageMean(obj)
            VoltageMean = obj.VoltageMean;
        end
        function CurrentMean = getCurrentMean(obj)
            CurrentMean = obj.CurrentMean;
        end
        function AnalyseTrace(obj)
            [obj.Time, obj.Depth, obj.ECD, obj.TStart, obj.TEnd, obj.isValid, obj.MeanDepth] = TranslocationTraceAnalyse( obj.CurrentTrace, obj.SampleFreq, obj.nPointsExtra );     
           
            obj.CurrentMean = mean(obj.CurrentTrace([1:obj.TStart obj.TEnd:end]));
            obj.VoltageMean = mean(obj.VoltageTrace);
        end
    end
    
end

