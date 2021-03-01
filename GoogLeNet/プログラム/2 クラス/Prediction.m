clc;
clear ;
close all;


% Specify the path using a dialog
% 

%--------------------------------          Configuration           -----------------------------------%
PredictionDatasetPath = uigetdir('D:\欠陥検出\画像データ\新しいデータ','入力データディレクトリを選択してください');
[ModelName,ModelPath] = uigetfile('D:\欠陥検出\GoogLeNet\モデル\2種類の分類\','モデルファイルを選択してください');
OutputFilePath = [PredictionDatasetPath,'\DataForClassification'];
FileExtensions = '.bmp';
ensembleNum = 7;
RejectThreshold = 0.9999;
VotingThreshold = 4;


%-------------------------------                End             -------------------------------------%

ImageData=imageDatastore(PredictionDatasetPath, 'IncludeSubFolders', true, 'FileExtensions', FileExtensions);
numRAW = numel(ImageData.Files);
OutputFileSize = [224 224];
OutputFileExtension = '.tif';
mkdir(OutputFilePath);
flist = dir(sprintf('%s/*%s', PredictionDatasetPath, FileExtensions));
for tmp = 1:min(length(flist), numRAW)
    fname = sprintf('%s/%s', PredictionDatasetPath, flist(tmp).name);
    sub_image = imread(fname);
    sub_image=cat(3,sub_image,sub_image,sub_image);
    sub_image=imresize(sub_image,OutputFileSize);
    OutputPath = sprintf('%s/%s', OutputFilePath, flist(tmp).name);
    [filepath,name,ext] = fileparts(OutputPath);
    OutputPath = sprintf('%s/%s%s', filepath, name, OutputFileExtension); 
    imwrite(sub_image,fullfile(OutputPath));
end

d = load([ModelPath,ModelName]);
netTransfer = d.netTransfer;
UncatData=imageDatastore(OutputFilePath, 'IncludeSubFolders', true, 'FileExtensions', OutputFileExtension);
inputSize = netTransfer(1).Layers(1).InputSize;
Uncatdata = augmentedImageDatastore(inputSize(1:2),UncatData);
NumRaw = numel(UncatData.Files);
VotingTable=cell(NumRaw,4);
for ii=1:ensembleNum
    [Ypred,scores]=classify(netTransfer(ii),Uncatdata);
    EnsembleScores{ii}=scores; %#ok
    for num=1:NumRaw
        filename=UncatData.Files(num);
        filename=char(filename);
        indfir=max(strfind(filename,'\'));   
        filename=filename(indfir+1:end);  
        VotingTable{num,1}=char(filename);
        if(EnsembleScores{ii}(num,1)>=RejectThreshold)
            if isempty(VotingTable{num,2})
                
                VotingTable{num,2}=1;  
            else
               VotingTable{num,2}=VotingTable{num,2}+1;
            end

        elseif(EnsembleScores{ii}(num,2)>=RejectThreshold)
            if isempty(VotingTable{num,3})
                VotingTable{num,3}=1;   
            else
               VotingTable{num,3}=VotingTable{num,3}+1;
            end       
         
        else
            if isempty(VotingTable{num,4})
                VotingTable{num,4}=1; % Rejection
            else
                VotingTable{num,4}=VotingTable{num,4}+1;
            end 

        end
    end

end
Rejection = 0;
unwater = 0;
water = 0;
index_dir = strfind(PredictionDatasetPath,'\');
dir = PredictionDatasetPath(1:index_dir(end)-1);
ImageID = PredictionDatasetPath(index_dir(end-1)+1:index_dir(end)-1);
WaterdirName=sprintf('%s\\水滴',dir);
UnwaterdirName=sprintf('%s\\その他',dir);
RejectiondirName=sprintf('%s\\除外',dir);
mkdir(WaterdirName);
mkdir(UnwaterdirName);
mkdir(RejectiondirName);


 for image=1:NumRaw
        if VotingTable{image,2}>=VotingThreshold
            copyfile(char(UncatData.Files(image)),UnwaterdirName);
            unwater=unwater+1;
            
        elseif VotingTable{image,3}>=VotingThreshold
            copyfile(char(UncatData.Files(image)),WaterdirName);
            water=water+1;
        else
            copyfile(char(UncatData.Files(image)),RejectiondirName);
            Rejection=Rejection+1;
        end
 end
 
VotesFileName=sprintf('Votes_%s.xlsx',ModelName);
TableTitle = {'画像','その他','水滴','除外'};
VotingTable = cat(1, TableTitle, VotingTable);
xlswrite([dir,VotesFileName],VotingTable);
index_dir = strfind(dir,'\');
xlsdir = dir(1:index_dir(end)-1);
SummaryExcelName = 'Summary';
xlsname = sprintf('%s\\%s.xlsx',xlsdir,SummaryExcelName);
try
   xlsread(xlsname);
catch
    TableTitle = {'ID','その他','水滴','除外'};
    xlswrite(xlsname,TableTitle);
end
[num, text, raw] = xlsread(xlsname);
[rowN, columnN]=size(raw);
sheet=1;
xlsRange=['A',num2str(rowN+1)];
Title = {ImageID,unwater,water,Rejection};
xlswrite(xlsname,Title,sheet,xlsRange);


