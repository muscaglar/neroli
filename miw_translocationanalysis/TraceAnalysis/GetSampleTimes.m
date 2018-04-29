function [ Times, dt, MaxTime ] = GetSampleTimes( nPoints, SampleRate )
%GETSAMPLETIMES Summary of this function goes here
%   Detailed explanation goes here

dt = 1/SampleRate;
MaxTime = (nPoints-1) * dt;
Times = 0:dt:MaxTime;

end

