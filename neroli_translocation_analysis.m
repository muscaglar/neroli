function [good_translocations,ecds] = neroli_translocation_analysis(varargin)

%Currently, TDMS files must be present in the directory to run this
%analysis. Once Mat files are generated alongside the TDMS files, they need
%to still be present but will not be re-analysed.
%Fix coming soon.
%In the meantime provide the argument '1' to override this and alayse all
%MAT files in a directory.

fileroot = uigetdir('CoolWater File Selector');

if isempty(varargin)
    
    [files,keep_mat_files] = neroli_file_process(fileroot);
    
    coolwater_TDMS_import(fileroot,files,0);
    
    [files,keep_mat_files] = coolwater_file_process(fileroot);
else
    keep_mat_files = dir(fullfile(fileroot, '*.mat'));
end
[good_translocations,ecds] = neroli_translocation(fileroot,keep_mat_files);

end