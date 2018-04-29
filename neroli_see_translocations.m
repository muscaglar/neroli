function [good_translocations] = neroli_see_translocations(all_translocations)

good_translocations = containers.Map('KeyType','double','ValueType','any');
x = 1;
for i = 1:length(all_translocations)
    data = all_translocations(i);
    plot(data(:,2),data(:,1));
    answer = coolwater_questdlg( [ 0.5 , 0.3 ],'Is this a good translocation?','Translocation Picker','Yes','No','Cancel','Cancel');
    switch answer
        case 'No'     
        case 'Yes'
            good_translocations(x) = data;
            x=x+1;
        case 'Cancel'
            break;
    end
end
% area = [];
%
% for i=1:length(all_translocations)
%     new_area = coolwater_integrate(all_translocations(i));
%     area = [area, new_area];
% end
%
%     function [area] = coolwater_integrate(data)
%         area = 0;
%         time = data(:,2);
%         current = data(:,1);
%         for x = 2:2:length(current)
%             step = time(x)-time(x-1);
%             area = area + (step*(current(x)-current(x-1)));
%         end
%     end

end