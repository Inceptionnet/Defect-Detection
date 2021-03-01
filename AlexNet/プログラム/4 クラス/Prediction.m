clc;
clear ;
close all;



%--------------------------------          Configuration           -----------------------------------%
PredictionDatasetPath = uigetdir('D:\Ƿꈗʳ�\����ǩ`��\�¤����ǩ`��','�����ǩ`���ǥ��쥯�ȥ���x�k���Ƥ�������');
[ModelName,ModelPath] = uigetfile('D:\Ƿꈗʳ�\AlexNet\��ǥ�\4�Nη��\','��ǥ�ե�������x�k���Ƥ�������');
OutputFilePath = [PredictionDatasetPath,'\DataForClassification'];
FileExtensions = '.bmp';
ensembleNum = 7;
RejectThreshold = 0.9;
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
VotingTable=cell(NumRaw,6);
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
            
         elseif(EnsembleScores{ii}(num,3)>=RejectThreshold)
            if isempty(VotingTable{num,4})
                VotingTable{num,4}=1;   
            else
               VotingTable{num,4}=VotingTable{num,4}+1;
            end  
            
        elseif(EnsembleScores{ii}(num,4)>=RejectThreshold)
            if isempty(VotingTable{num,5})
                VotingTable{num,5}=1;   
            else
               VotingTable{num,5}=VotingTable{num,5}+1;
            end 
            
        else
            if isempty(VotingTable{num,6})
                VotingTable{num,6}=1; % Rejection
            else
                VotingTable{num,6}=VotingTable{num,6}+1;
            end 

        end
    end

end
Rejection = 0;
Knife = 0;
Scratches = 0;
Droplet = 0;
Other = 0;
index_dir = strfind(PredictionDatasetPath,'\');
dir = PredictionDatasetPath(1:index_dir(end)-1);
ImageID = PredictionDatasetPath(index_dir(end-1)+1:index_dir(end)-1);
ScratchesdirName=sprintf('%s\\2.�˥å��E',dir);
KnifedirName=sprintf('%s\\1.������',dir);
DropletdirName=sprintf('%s\\3.ˮ��',dir);
OtherdirName=sprintf('%s\\4.������',dir);
RejectiondirName=sprintf('%s\\5.����',dir);
mkdir(ScratchesdirName);
mkdir(KnifedirName);
mkdir(DropletdirName);
mkdir(OtherdirName);
mkdir(RejectiondirName);


 for image=1:NumRaw
        if VotingTable{image,2}>=VotingThreshold
            copyfile(char(UncatData.Files(image)),KnifedirName);
            Knife=Knife+1;
            
        elseif VotingTable{image,3}>=VotingThreshold
            copyfile(char(UncatData.Files(image)),ScratchesdirName);
            Scratches=Scratches+1;
            
        elseif VotingTable{image,4}>=VotingThreshold
            copyfile(char(UncatData.Files(image)),DropletdirName);
            Droplet=Droplet+1;
            
        elseif VotingTable{image,5}>=VotingThreshold
            copyfile(char(UncatData.Files(image)),OtherdirName);
            Other=Other+1; 
            
        else
            copyfile(char(UncatData.Files(image)),RejectiondirName);
            Rejection=Rejection+1;
        end
 end
 
VotesFileName=sprintf('Votes_%s.xlsx',ModelName);
TableTitle = {'����','������','�˥å��E','ˮ��','������','����'};
VotingTable = cat(1, TableTitle, VotingTable);
xlswrite([dir,VotesFileName],VotingTable);

index_dir = strfind(dir,'\');
xlsdir = dir(1:index_dir(end)-1);
SummaryExcelName = 'Summary';
xlsname = sprintf('%s\\%s.xlsx',xlsdir,SummaryExcelName);
try
   xlsread(xlsname);
catch
    TableTitle = {'ID','������','�˥å��E','ˮ��','������','����'};
    xlswrite(xlsname,TableTitle);
end
[num, text, raw] = xlsread(xlsname);
[rowN, columnN]=size(raw);
sheet=1;
xlsRange=['A',num2str(rowN+1)];
Title = {ImageID,Knife,Scratches,Droplet,Other,Rejection};
xlswrite(xlsname,Title,sheet,xlsRange);


