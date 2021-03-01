
clc; 
clear;
close all;
%-----------------------  Input image file configuration  ---------------------------%

InputFilePath = fullfile('D:','欠陥検出','正規化処理','入力データ');

RawFileExtension = '.bmp';

%-----------------------  Output image file configuration  --------------------------%

OutputFilePath = fullfile('D:','欠陥検出','正規化処理','出力データ');

OutputFileExtension = '.bmp';

%------------------------------          End         --------------------------------%
DIRinfo = dir(InputFilePath);
n_file=length(DIRinfo);
n_folder = -2;
for index = 1:n_file
   if DIRinfo(index).bytes == 0
       n_folder=n_folder+1;
   end
end
n_imagefile = n_file - n_folder;
for folderindex = 1:n_folder
    fodername = DIRinfo(folderindex+2,1).name;
    inputfodername=sprintf('%s\\%s',InputFilePath,fodername);
    outputfodername=sprintf('%s\\%s',OutputFilePath,fodername);
    ImageData=imageDatastore(inputfodername, 'IncludeSubFolders', true, 'FileExtensions', RawFileExtension, 'LabelSource', 'foldernames');
    numRAW = numel(ImageData.Files);
    OutputFileSize = [224 224];
    mkdir(outputfodername);
    flist = dir(sprintf('%s/*%s', inputfodername, RawFileExtension));
    for tmp = 1:min(length(flist), numRAW)
        fname = sprintf('%s/%s', inputfodername, flist(tmp).name);
        sub_image = imread(fname);
        sub_image=cat(3,sub_image,sub_image,sub_image);
        sub_image=imresize(sub_image,OutputFileSize);
        OutputPath = sprintf('%s/%s', outputfodername, flist(tmp).name);
        [filepath,name,ext] = fileparts(OutputPath);
        OutputPath = sprintf('%s/%s%s', filepath, name, OutputFileExtension); 
        imwrite(sub_image,fullfile(OutputPath));
    end
end

ImageData=imageDatastore(InputFilePath, 'IncludeSubFolders', true, 'FileExtensions', RawFileExtension, 'LabelSource', 'foldernames');
numRAW = numel(ImageData.Files);
OutputFileSize = [224 224];
mkdir(OutputFilePath);
flist = dir(sprintf('%s/*%s', InputFilePath, RawFileExtension));
for tmp = 1:min(length(flist), numRAW)
    fname = sprintf('%s/%s', InputFilePath, flist(tmp).name);
    sub_image = imread(fname);
    sub_image=cat(3,sub_image,sub_image,sub_image);
    sub_image=imresize(sub_image,OutputFileSize);
    OutputPath = sprintf('%s/%s', OutputFilePath, flist(tmp).name);
    [filepath,name,ext] = fileparts(OutputPath);
    OutputPath = sprintf('%s/%s%s', filepath, name, OutputFileExtension); 
    imwrite(sub_image,fullfile(OutputPath));
end




