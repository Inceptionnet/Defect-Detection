
clc;
clear ;
close all;

%--------------------------------          Configuration           -----------------------------------%

EvaluationDatasetPath = fullfile('D:','欠陥検出','画像データ','2種類の分類','評価データ');
VotesFilePath = 'D:\欠陥検出\GoogLeNet\評価投票結果\2種類の分類\';
ModelPath = 'D:\欠陥検出\GoogLeNet\モデル\2種類の分類\';
ModelName = 'GModel_Jan_28_2019_20_32';
FileExtensions = '.tif';
ensembleNum = 7;
RejectThreshold = 0.9999;    
VotingThreshold = 4;
FNErrors = false;
FPErrors = false;

%-------------------------------                End             -------------------------------------%

d = load([ModelPath,ModelName]);
netTransfer = d.netTransfer;
UncatData=imageDatastore(EvaluationDatasetPath, 'IncludeSubFolders', true, 'FileExtensions', FileExtensions , 'LabelSource', 'foldernames');
inputSize = netTransfer(1).Layers(1).InputSize;
NumRaw = numel(UncatData.Files);
Uncatdata = augmentedImageDatastore(inputSize(1:2),UncatData);

VotingTable=cell(NumRaw,5);
for ii=1:ensembleNum
    [Ypred,scores]=classify(netTransfer(ii),Uncatdata);
    EnsembleScores{ii}=scores; %#ok
    for num=1:NumRaw
        filename=UncatData.Files(num);
        filename=char(filename);
        indfir=max(strfind(filename,'\'));  
        indlas=strfind(filename,'.');  
        filename=filename(indfir+1:indlas-1);  
        VotingTable{num,1}=filename;
        if(EnsembleScores{ii}(num,1)>=RejectThreshold)
            if isempty(VotingTable{num,3})
                
                VotingTable{num,3}=1;  % Knife
            else
               VotingTable{num,3}=VotingTable{num,3}+1;
            end

            VotingTable{num,2}=char(UncatData.Labels(num));

        elseif(EnsembleScores{ii}(num,2)>=RejectThreshold)
            if isempty(VotingTable{num,4})
                VotingTable{num,4}=1;  % Scratch
            else
               VotingTable{num,4}=VotingTable{num,4}+1;
            end
            
            VotingTable{num,2}=char(UncatData.Labels(num));
        else
            if isempty(VotingTable{num,5})
                VotingTable{num,5}=1; % Rejection
            else
                VotingTable{num,5}=VotingTable{num,5}+1;
            end
            
            VotingTable{num,2}=char(UncatData.Labels(num));

        end
    end

end



Rejection = 0;
clear TLable;
clear ALable;
location = 0;
 for image=1:NumRaw
        if VotingTable{image,3}>=VotingThreshold
            TLable(image+location)="その他"; %#ok  
            ALable(image+location)=cellstr(UncatData.Labels(image)); %#ok
            Inum(image+location)=image; %#ok
        elseif VotingTable{image,4}>=VotingThreshold
            TLable(image+location)="水滴"; %#ok
            ALable(image+location)=cellstr(UncatData.Labels(image)); %#ok
            Inum(image+location)=image; %#ok
        else 
            Rejection=Rejection+1;
            location=location-1;
        end
 end
  
 VotesFileName=sprintf('Votes_%s.xlsx',ModelName);
TableTitle = {'画像','正解','その他','水滴','除外'};
VotingTable = cat(1, TableTitle, VotingTable);
xlswrite([VotesFilePath,VotesFileName],VotingTable);

TLable=categorical(TLable);
ALable=categorical(ALable);
FinalConfMat = confusionmat(ALable, TLable) %#ok
FinalConf = bsxfun(@rdivide,FinalConfMat,sum(FinalConfMat,2)) %#ok
FinalAccuracy = sum(TLable==ALable)/numel(ALable) %#ok
Rejection  %#ok

if FNErrors == true
    for i=1:numel(ALable(1,:))
        if TLable(i)~=ALable(i) && TLable(i)=="水滴"
            file=UncatData.Files(Inum(i));
            filename=char(file);
            indfir=max(strfind(filename,'\'));
            indlas=strfind(filename,'.');
            filename=filename(indfir+1:indlas-1);
            figure('Name','From その他 to 水滴','NumberTitle','off')
            imshow(file{1,1})
            xlabel(filename)
        end
    end
end

if FPErrors == true
    for i=1:numel(ALable(1,:))
        if TLable(i)~=ALable(i) && TLable(i)=="その他"
            file=UncatData.Files(Inum(i));
            filename=char(file);
            indfir=max(strfind(filename,'\'));
            indlas=strfind(filename,'.');
            filename=filename(indfir+1:indlas-1);
            figure('Name','From 水滴 to その他','NumberTitle','off')
            imshow(file{1,1})
            xlabel(filename)
        end
    end
end