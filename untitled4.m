

[TF,P] = islocalmin(fil_current);
    
    for x = 1:length(TF)
        if(P(x)<2)
            TF(x) = 0;
        end
    end
    
    padValue= 0;
    
    for i = 1:length(TF)-1
        if(TF(i)== 1 && TF(i-1)==0)
            if(i<padValue)
                TF(1:i)=1;
            else
                TF(i-padValue:i)=1;
            end
        end
    end
    
    for i = length(TF)-1:-1:1
        if(TF(i)== 1 && TF(i+1)==0)
            if(i+padValue>length(TF))
                TF(i:length(TF))=1;
            else
                TF(i:i+padValue)=1;
            end
        end
    end
    
    plot(time,fil_current,time(TF),fil_current(TF),'r*');
    trans = 1;
    i=1;
    all_translocations = containers.Map('KeyType','double','ValueType','any');
    while ( i<length(TF))
        switch TF(i)
            case 1
                start = i;
                while (TF(i)==1)
                    i = i+1;
                end
                finish =i;
                all_translocations(trans) = [fil_current(start:finish)',time(start:finish)'];
                trans = trans+1;
            case 0
                i = i+1;
        end
    end