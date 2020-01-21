% function [] = neroli_TDMS_import(fileroot,files,s_freq)
%  
% % [baseName, folder] = uigetfile({'*.dat';'*.mat';},'CoolWater File Selector');
% % filepath = fullfile(folder, baseName);
%  
% if(ispc)
%     savepath = char(strcat(fileroot,'\'));
% else
%     savepath = char(strcat(fileroot,'/'));
% end
% v_mat = matfile([savepath 'v_mat'],'Writable',true);
% i_mat = matfile([savepath 'i_mat'],'Writable',true);
%  
% v_mat.v = [];
% i_mat.i = [];
%  
% for j = 1:numel(files)
%     if(ispc)
%         filepath = char(strcat(fileroot,'\',files(j).name));
%     else
%         filepath = char(strcat(fileroot,'/',files(j).name));
%     end
%     
%     result = convertTDMS(0,filepath);
%     i = result.Data.MeasuredData(4).Data;
%     v = result.Data.MeasuredData(3).Data;
%     
%     TF = v<0.5*mean(v);
%     padValue= 3*s_freq;
%     for j = 2:length(TF)-1
%         if(TF(j)== 1 && TF(j-1)==0)
%             if(j<padValue)
%                 TF(1:j)=1;
%             else
%                 TF(j-padValue:j)=1;
%             end
%         end
%     end
%     for j = length(TF)-1:-1:1
%         if(TF(j)== 1 && TF(j+1)==0)
%             if(j+padValue>length(TF))
%                 TF(j:length(TF))=1;
%             else
%                 TF(j:j+padValue)=1;
%             end
%         end
%     end
%     TF = ~TF;
%     
%     i = i(TF);
%     v = v(TF);
%     
%     [i,~] = neroli_remove_base(i,s_freq);
%     v = round(v)';
%     i = round(i*1000000)';
%     
%     v_mat.v = [v_mat.v,int16(v)];
%     i_mat.i = [i_mat.i,int32(i)];
% end
%  
% end

function [] = neroli_TDMS_import(fileroot,files,s_freq)

% [baseName, folder] = uigetfile({'*.dat';'*.mat';},'CoolWater File Selector');
% filepath = fullfile(folder, baseName);

if(ispc)
    savepath = char(strcat(fileroot,'\'));
else
    savepath = char(strcat(fileroot,'/'));
end
v_mat = matfile([savepath 'v_mat'],'Writable',true);
i_mat = matfile([savepath 'i_mat'],'Writable',true);

v_mat.v = [];
i_mat.i = [];

for j = 1:numel(files)
    if(ispc)
        filepath = char(strcat(fileroot,'\',files(j).name));
    else
        filepath = char(strcat(fileroot,'/',files(j).name));
    end
    
    result = convertTDMS(0,filepath);
    i = result.Data.MeasuredData(4).Data;
    v = result.Data.MeasuredData(3).Data;
    
   
    TF = v>0;
    
    i = i(TF);
    v = v(TF);
    
    %[i,~] = neroli_remove_base(i,s_freq);
    
    v_mat.v = [v_mat.v;int16(v)];
    i_mat.i = [i_mat.i;i];
end

end