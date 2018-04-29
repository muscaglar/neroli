function [ FileName, PathName ] = SaveTranslocations( Translocations, PathName, FileName)
%SAVETRANSLOCATIONS Summary of this function goes here
%   Detailed explanation goes here

if size(Translocations,1) > 0
    FName =  Translocations(1).FileName;
    [ date, no, ~] = FileNameInterpret( FName );
    
    if nargin < 2
        FileRoots;
        [ PathName, DateStr ] = ConstructDataPath( date, TranslocationRoot, 1 );
    else
        DateStr = GetDateString( date );
    end
    if nargin < 3
        FileName = [DateStr '_' num2str(no) '.mat'];
    end
    
    save([PathName '/' FileName], 'Translocations');
    
    UploadTranslocationToCloud( [PathName '/' FileName] );
    
end
end

