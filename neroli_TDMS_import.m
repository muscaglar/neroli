function [] = neroli_TDMS_import(fileroot,files)

% [baseName, folder] = uigetfile({'*.dat';'*.mat';},'CoolWater File Selector');
% filepath = fullfile(folder, baseName);

if(ispc)
    savepath = char(strcat(fileroot,'\'));
else
    savepath = char(strcat(fileroot,'/'));
end
v_mat = matfile([savepath 'v_mat'],'Writable',isWritable);
i_mat = matfile([savepath 'i_mat'],'Writable',isWritable);

v_mat.v = [];
i_mat.i = [];

for i = 1:numel(files)
    if(ispc)
        filepath = char(strcat(fileroot,'\',files(i).name));
    else
        filepath = char(strcat(fileroot,'/',files(i).name));
    end
    
    result = convertTDMS(0,filepath);
    v_mat.v = [v_mat.v,result.Data.MeasuredData(3).Data'];
    i_mat.i = [i_mat.i,result.Data.MeasuredData(4).Data'];    
end

end