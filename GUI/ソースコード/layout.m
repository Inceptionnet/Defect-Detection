function varargout = layout(varargin)
% LAYOUT MATLAB code for layout.fig
%      LAYOUT, by itself, creates a new LAYOUT or raises the existing
%      singleton*.
%
%      H = LAYOUT returns the handle to a new LAYOUT or the handle to
%      the existing singleton*.
%
%      LAYOUT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LAYOUT.M with the given input arguments.
%
%      LAYOUT('Property','Value',...) creates a new LAYOUT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before layout_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to layout_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help layout

% Last Modified by GUIDE v2.5 09-Feb-2019 23:38:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @layout_OpeningFcn, ...
    'gui_OutputFcn',  @layout_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before layout is made visible.
function layout_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to layout (see VARARGIN)

% Choose default command line output for layout
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes layout wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = layout_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in selmodel.
function selmodel_Callback(hObject, eventdata, handles)
% hObject    handle to selmodel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disk = pwd;
disk = disk(1:1);
global ModelName;
global ModelPath;
for close=1:1
    if get(handles.google,'value')
        if get(handles.two,'value')
            [ModelName, ModelPath] = uigetfile([disk,':\欠陥検出\GoogLeNet\モデル\2 クラス\'],'モデルファイルを選択してください');
            if ModelName==0
                break
            end
        end
        if get(handles.three,'value')
            [ModelName, ModelPath] = uigetfile([disk,':\欠陥検出\GoogLeNet\モデル\3 クラス\'],'モデルファイルを選択してください');
            if ModelName==0
                break
            end
        end
        if get(handles.four,'value')
            [ModelName, ModelPath] = uigetfile([disk,':\欠陥検出\GoogLeNet\モデル\4 クラス\'],'モデルファイルを選択してください');
            if ModelName==0
                break
            end
        end
    end
    if get(handles.alexnet,'value')
        if get(handles.two,'value')
            [ModelName, ModelPath] = uigetfile([disk,':\欠陥検出\AlexNet\モデル\2 クラス\'],'モデルファイルを選択してください');
            if ModelName==0
                break
            end
        end
        if get(handles.three,'value')
            [ModelName, ModelPath] = uigetfile([disk,':\欠陥検出\AlexNet\モデル\3 クラス\'],'モデルファイルを選択してください');
            if ModelName==0
                break
            end
        end
        if get(handles.four,'value')
            [ModelName, ModelPath] = uigetfile([disk,':\欠陥検出\AlexNet\モデル\4 クラス\'],'モデルファイルを選択してください');
            if ModelName==0
                break
            end
        end
    end
    set(handles.text9,'Visible','Off')
    if strcmp(get(handles.text8,'Visible'),'off')==1
        set(handles.predict,'Enable','on');
    end
    ModelName_dir = strfind(ModelName,'.');
    ModelNamedir = ModelName(1:ModelName_dir(end)-1);
    set(handles.text15,'String',ModelNamedir); 
end
% --- Executes on button press in selimage.
function selimage_Callback(hObject, eventdata, handles)
% hObject    handle to selimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
for close=1:1
    disk = pwd;
    disk = disk(1:1);
    global PredictionDatasetPath;
    if get(handles.two,'value')
        PredictionDatasetPath = uigetdir([disk,':\欠陥検出\画像データ\新しいデータ'],'予測画像フォルダを選択してください');
        if PredictionDatasetPath == 0
            break
        end
    end
    if get(handles.three,'value')
        PredictionDatasetPath = uigetdir([disk,':\欠陥検出\画像データ\新しいデータ'],'予測画像フォルダを選択してください');
        if PredictionDatasetPath == 0
            break
        end
    end
    if get(handles.four,'value')
        PredictionDatasetPath = uigetdir([disk,':\欠陥検出\画像データ\新しいデータ'],'予測画像フォルダを選択してください');
        if PredictionDatasetPath == 0
            break
        end
    end
    set(handles.text8,'Visible','Off')
    if strcmp(get(handles.text9,'Visible'),'off')==1
        set(handles.predict,'Enable','on');
    end
    
    
    index_dir = strfind(PredictionDatasetPath,'\');
    datapath = PredictionDatasetPath(index_dir(end-1)+1:index_dir(end)-1);
    set(handles.text14,'String',datapath);
end
% --- Executes on button press in predict.
function predict_Callback(hObject, eventdata, handles)
% hObject    handle to predict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ModelName
global ModelPath
global PredictionDatasetPath
FileExtensions = get(handles.extension,'String');
ensembleNum = get(handles.netN,'String');
ensembleNum = str2double(ensembleNum);
RejectThreshold = get(handles.rejectT,'String');
RejectThreshold = str2double(RejectThreshold);
VotingThreshold = get(handles.VotingT,'String');
VotingThreshold = str2double(VotingThreshold);

trinwaitbar=waitbar(0,'予測開始');
OutputFilePath = [PredictionDatasetPath,'\DataForClassification']
ImageData=imageDatastore(PredictionDatasetPath, 'IncludeSubFolders', true, 'FileExtensions', FileExtensions);
numRAW = numel(ImageData.Files)
OutputFileSize = [224 224];
OutputFileExtension = '.tif';
if ~exist(OutputFilePath, 'dir')
    mkdir(OutputFilePath);
end
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
waitbar(7/100,trinwaitbar,['しばらくお待ちください  ' num2str(7) '%']);
d = load([ModelPath,ModelName]);
netTransfer = d.netTransfer;
waitbar(10/100,trinwaitbar,['しばらくお待ちください  ' num2str(10) '%']);
proportion = 90/ensembleNum;
try
    UncatData=imageDatastore(OutputFilePath, 'IncludeSubFolders', true, 'FileExtensions', OutputFileExtension);
catch
    s = sprintf(['\n               無効な画像パス \n\n','  パラメータを確認してください.\n']);
    msgbox(s,'Notification','help');
end
inputSize = netTransfer(1).Layers(1).InputSize;
Uncatdata = augmentedImageDatastore(inputSize(1:2),UncatData);
NumRaw = numel(UncatData.Files);
if get(handles.two,'value')
    VotingTable=cell(NumRaw,5);
    for ii=1:ensembleNum
        [Ypred,scores]=classify(netTransfer(ii),Uncatdata);
        if (10+proportion*ii)>=99
            waitbar((10+proportion*ii)/100,trinwaitbar,['予測終了  ' num2str(10+proportion*ii) '%']);
            pause(4);
            delete(trinwaitbar)
            msgbox('     　    予測結果を確認してください');
        else
            waitbar((10+proportion*ii)/100,trinwaitbar,['しばらくお待ちください  ' num2str(10+proportion*ii) '%']);
            pause(1);
        end
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
    dirimage = PredictionDatasetPath(1:index_dir(end)-1);
    ImageID = PredictionDatasetPath(index_dir(end-1)+1:index_dir(end)-1);
    WaterdirName=sprintf('%s\\水滴',dirimage);
    UnwaterdirName=sprintf('%s\\その他',dirimage);
    RejectiondirName=sprintf('%s\\除外',dirimage);
    mkdir(WaterdirName);
    mkdir(UnwaterdirName);
    mkdir(RejectiondirName);
    
    
    for image=1:NumRaw
        if VotingTable{image,2}>=VotingThreshold
            copyfile(char(UncatData.Files(image)),UnwaterdirName);
            unwater=unwater+1;
            if isempty(VotingTable{image,5})
               VotingTable{image,5}=1; 
            else
               VotingTable{image,5}=1;
            end
        elseif VotingTable{image,3}>=VotingThreshold
            copyfile(char(UncatData.Files(image)),WaterdirName);
            water=water+1;
             if isempty(VotingTable{image,5})
                VotingTable{image,5}=2; 
             else
                VotingTable{image,5}=2;
             end
        else
            copyfile(char(UncatData.Files(image)),RejectiondirName);
            Rejection=Rejection+1;
            if isempty(VotingTable{image,5})
               VotingTable{image,5}=3; 
            else
               VotingTable{image,5}=3;
            end
        end
    end
    
    VotesFileName=sprintf('Votes_%s.xlsx',ModelName);
    TableTitle = {'画像','その他','水滴','除外','判定'};
    VotingTable = cat(1, TableTitle, VotingTable);
    UpperTitle = {'分類No','1','2','3',''};
    VotingTable = cat(1, UpperTitle, VotingTable);
    try
        xlswrite([dirimage,VotesFileName],VotingTable);
    catch
        s = sprintf(['\n         Excelファイル書き込みエラー.\n']);
        msgbox(s,'Notification','help');
    end
    index_dir = strfind(dirimage,'\');
    xlsdir = dirimage(1:index_dir(end)-1);
    SummaryExcelName = '2 クラス分類要約';
    xlsname = sprintf('%s\\%s.xlsx',xlsdir,SummaryExcelName);
    try
        xlsread(xlsname);
    catch
        TableTitle = {'ID','その他','水滴','除外'};
        try
            xlswrite(xlsname,TableTitle);
        catch
            s = sprintf(['\n         Excelファイル書き込みエラー.\n']);
            msgbox(s,'Notification','help');
        end
    end
    [num, text, raw] = xlsread(xlsname);
    [rowN, columnN]=size(raw);
    sheet=1;
    xlsRange=['A',num2str(rowN+1)];
    Title = {ImageID,unwater,water,Rejection};
    try
        xlswrite(xlsname,Title,sheet,xlsRange);
    catch
        s = sprintf(['\n         Excelファイル書き込みエラー.\n']);
        msgbox(s,'Notification','help');
    end
end

if get(handles.three,'value')
    VotingTable=cell(NumRaw,6);
    for ii=1:ensembleNum
        [Ypred,scores]=classify(netTransfer(ii),Uncatdata);
        if (10+proportion*ii)>=99
            waitbar((10+proportion*ii)/100,trinwaitbar,['予測終了  ' num2str(10+proportion*ii) '%']);
            pause(4);
            delete(trinwaitbar)
            msgbox('     　    予測結果を確認してください');
        else
            waitbar((10+proportion*ii)/100,trinwaitbar,['しばらくお待ちください  ' num2str(10+proportion*ii) '%']);
            pause(1);
        end
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
                
            else
                if isempty(VotingTable{num,5})
                    VotingTable{num,5}=1; % Rejection
                else
                    VotingTable{num,5}=VotingTable{num,5}+1;
                end
                
            end
        end
        
    end
    Rejection = 0;
    Knife = 0;
    Scratches = 0;
    Droplet = 0;
    index_dir = strfind(PredictionDatasetPath,'\');
    dirimage = PredictionDatasetPath(1:index_dir(end)-1);
    ImageID = PredictionDatasetPath(index_dir(end-1)+1:index_dir(end)-1);
    ScratchesdirName=sprintf('%s\\2.ニック跡',dirimage);
    KnifedirName=sprintf('%s\\1.カス付',dirimage);
    DropletdirName=sprintf('%s\\3.水滴',dirimage);
    RejectiondirName=sprintf('%s\\4.除外',dirimage);
    mkdir(ScratchesdirName);
    mkdir(KnifedirName);
    mkdir(DropletdirName);
    mkdir(RejectiondirName);
    
    
    for image=1:NumRaw
        if VotingTable{image,2}>=VotingThreshold
            copyfile(char(UncatData.Files(image)),KnifedirName);
            Knife=Knife+1;
            if isempty(VotingTable{image,6})
               VotingTable{image,6}=1; 
            else
               VotingTable{image,6}=1;
            end
        elseif VotingTable{image,3}>=VotingThreshold
            copyfile(char(UncatData.Files(image)),ScratchesdirName);
            Scratches=Scratches+1;
            if isempty(VotingTable{image,6})
               VotingTable{image,6}=2; 
            else
               VotingTable{image,6}=2;
            end
        elseif VotingTable{image,4}>=VotingThreshold
            copyfile(char(UncatData.Files(image)),DropletdirName);
            Droplet=Droplet+1;
            if isempty(VotingTable{image,6})
               VotingTable{image,6}=3; 
            else
               VotingTable{image,6}=3;
            end
        else
            copyfile(char(UncatData.Files(image)),RejectiondirName);
            Rejection=Rejection+1;
            if isempty(VotingTable{image,6})
               VotingTable{image,6}=4; 
            else
               VotingTable{image,6}=4;
            end
        end
    end
    
    VotesFileName=sprintf('Votes_%s.xlsx',ModelName);
    TableTitle = {'画像','カス付','ニック跡','水滴','除外','判定'};
    VotingTable = cat(1, TableTitle, VotingTable);
    UpperTitle = {'分類No','1','2','3','4',''};
    VotingTable = cat(1, UpperTitle, VotingTable);
    try
       xlswrite([dirimage,VotesFileName],VotingTable);
    catch
        s = sprintf(['\n         Excelファイル書き込みエラー.\n']);
        msgbox(s,'Notification','help');
    end
    index_dir = strfind(dirimage,'\');
    xlsdir = dirimage(1:index_dir(end)-1);
    SummaryExcelName = '3 クラス分類要約';
    xlsname = sprintf('%s\\%s.xlsx',xlsdir,SummaryExcelName);
    try
        xlsread(xlsname);
    catch
        TableTitle = {'ID','カス付','ニック跡','水滴','除外'};
        try
           xlswrite(xlsname,TableTitle);
        catch
            s = sprintf(['\n         Excelファイル書き込みエラー.\n']);
            msgbox(s,'Notification','help');
        end
    end
    [num, text, raw] = xlsread(xlsname);
    [rowN, columnN]=size(raw);
    sheet=1;
    xlsRange=['A',num2str(rowN+1)];
    Title = {ImageID,Knife,Scratches,Droplet,Rejection};
    try
        xlswrite(xlsname,Title,sheet,xlsRange);
    catch
        s = sprintf(['\n         Excelファイル書き込みエラー.\n']);
        msgbox(s,'Notification','help');
    end
        
end
if get(handles.four,'value')
    VotingTable=cell(NumRaw,7);
    for ii=1:ensembleNum
        [Ypred,scores]=classify(netTransfer(ii),Uncatdata);
        if (10+proportion*ii)>=99
            waitbar((10+proportion*ii)/100,trinwaitbar,['予測終了  ' num2str(10+proportion*ii) '%']);
            pause(4);
            delete(trinwaitbar)
            msgbox('     　    予測結果を確認してください');
        else
            waitbar((10+proportion*ii)/100,trinwaitbar,['しばらくお待ちください  ' num2str(10+proportion*ii) '%']);
            pause(1);
        end
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
    dirimage = PredictionDatasetPath(1:index_dir(end)-1);
    ImageID = PredictionDatasetPath(index_dir(end-1)+1:index_dir(end)-1);
    ScratchesdirName=sprintf('%s\\2.ニック跡',dirimage);
    KnifedirName=sprintf('%s\\1.カス付',dirimage);
    DropletdirName=sprintf('%s\\3.水滴',dirimage);
    OtherdirName=sprintf('%s\\4.その他',dirimage);
    RejectiondirName=sprintf('%s\\5.除外',dirimage);
    mkdir(ScratchesdirName);
    mkdir(KnifedirName);
    mkdir(DropletdirName);
    mkdir(OtherdirName);
    mkdir(RejectiondirName);
    
    
    for image=1:NumRaw
        if VotingTable{image,2}>=VotingThreshold
            copyfile(char(UncatData.Files(image)),KnifedirName);
            Knife=Knife+1;
            if isempty(VotingTable{image,7})
               VotingTable{image,7}=1; 
            else
               VotingTable{image,7}=1;
            end
        elseif VotingTable{image,3}>=VotingThreshold
            copyfile(char(UncatData.Files(image)),ScratchesdirName);
            Scratches=Scratches+1;
            if isempty(VotingTable{image,7})
               VotingTable{image,7}=2; 
            else
               VotingTable{image,7}=2;
            end
        elseif VotingTable{image,4}>=VotingThreshold
            copyfile(char(UncatData.Files(image)),DropletdirName);
            Droplet=Droplet+1;
            if isempty(VotingTable{image,7})
               VotingTable{image,7}=3; 
            else
               VotingTable{image,7}=3;
            end
        elseif VotingTable{image,5}>=VotingThreshold
            copyfile(char(UncatData.Files(image)),OtherdirName);
            Other=Other+1;
            if isempty(VotingTable{image,7})
               VotingTable{image,7}=4; 
            else
               VotingTable{image,7}=4;
            end
        else
            copyfile(char(UncatData.Files(image)),RejectiondirName);
            Rejection=Rejection+1;
            if isempty(VotingTable{image,7})
               VotingTable{image,7}=5; 
            else
               VotingTable{image,7}=5;
            end
        end
    end
    
    VotesFileName=sprintf('Votes_%s.xlsx',ModelName);
    TableTitle = {'画像','カス付','ニック跡','水滴','その他','除外','判定'};
    VotingTable = cat(1, TableTitle, VotingTable);
    UpperTitle = {'分類No','1','2','3','4','5',''};
    VotingTable = cat(1, UpperTitle, VotingTable);
    try
        xlswrite([dirimage,VotesFileName],VotingTable);
    catch
        s = sprintf(['\n         Excelファイル書き込みエラー.\n']);
        msgbox(s,'Notification','help');
    end
    index_dir = strfind(dirimage,'\');
    xlsdir = dirimage(1:index_dir(end)-1);
    SummaryExcelName = '4 クラス分類要約';
    xlsname = sprintf('%s\\%s.xlsx',xlsdir,SummaryExcelName);
    try
        xlsread(xlsname);
    catch
        TableTitle = {'ID','カス付','ニック跡','水滴','その他','除外'};
        try
            xlswrite(xlsname,TableTitle);
        catch
            s = sprintf(['\n         Excelファイル書き込みエラー.\n']);
            msgbox(s,'Notification','help');
        end
    end
    [num, text, raw] = xlsread(xlsname);
    [rowN, columnN]=size(raw);
    sheet=1;
    xlsRange=['A',num2str(rowN+1)];
    Title = {ImageID,Knife,Scratches,Droplet,Other,Rejection};
    try
        xlswrite(xlsname,Title,sheet,xlsRange);
    catch
        s = sprintf(['\n         Excelファイル書き込みエラー.\n']);
        msgbox(s,'Notification','help');
    end

end




function extension_Callback(hObject, eventdata, handles)
% hObject    handle to extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of extension as text
%        str2double(get(hObject,'String')) returns contents of extension as a double


% --- Executes during object creation, after setting all properties.
function extension_CreateFcn(hObject, eventdata, handles)
% hObject    handle to extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rejectT_Callback(hObject, eventdata, handles)
% hObject    handle to rejectT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rejectT as text
%        str2double(get(hObject,'String')) returns contents of rejectT as a double


% --- Executes during object creation, after setting all properties.
function rejectT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rejectT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function VotingT_Callback(hObject, eventdata, handles)
% hObject    handle to VotingT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VotingT as text
%        str2double(get(hObject,'String')) returns contents of VotingT as a double


% --- Executes during object creation, after setting all properties.
function VotingT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VotingT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function netN_Callback(hObject, eventdata, handles)
% hObject    handle to netN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of netN as text
%        str2double(get(hObject,'String')) returns contents of netN as a double


% --- Executes during object creation, after setting all properties.
function netN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to netN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in three.
function three_Callback(hObject, eventdata, handles)
% hObject    handle to three (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.google,'value')
    set(handles.rejectT,'String','0.99989')
else
    set(handles.rejectT,'String','0.99')
end
% Hint: get(hObject,'Value') returns toggle state of three


% --- Executes on button press in two.
function two_Callback(hObject, eventdata, handles)
% hObject    handle to two (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.google,'value')
    set(handles.rejectT,'String','0.9999')
else
    set(handles.rejectT,'String','0.980')
end
% Hint: get(hObject,'Value') returns toggle state of two


% --- Executes on button press in four.
function four_Callback(hObject, eventdata, handles)
% hObject    handle to four (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.google,'value')
    set(handles.rejectT,'String','0.994')
else
    set(handles.rejectT,'String','0.90')
end
% Hint: get(hObject,'Value') returns toggle state of four


% --- Executes on button press in google.
function google_Callback(hObject, eventdata, handles)
% hObject    handle to google (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.two,'value')
    set(handles.rejectT,'String','0.9999')
end
if get(handles.three,'value')
    set(handles.rejectT,'String','0.99989')
end
if get(handles.four,'value')
    set(handles.rejectT,'String','0.994')
end
% Hint: get(hObject,'Value') returns toggle state of google


% --- Executes on button press in alexnet.
function alexnet_Callback(hObject, eventdata, handles)
% hObject    handle to alexnet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.two,'value')
    set(handles.rejectT,'String','0.980')
end
if get(handles.three,'value')
    set(handles.rejectT,'String','0.99')
end
if get(handles.four,'value')
    set(handles.rejectT,'String','0.90')
end
% Hint: get(hObject,'Value') returns toggle state of alexnet


% --- Executes during object creation, after setting all properties.
function google_CreateFcn(hObject, eventdata, handles)
% hObject    handle to google (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function alexnet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to google (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel4,"Visible","On");

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel4,"Visible","Off");



function extensiont_Callback(hObject, eventdata, handles)
% hObject    handle to extensiont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of extensiont as text
%        str2double(get(hObject,'String')) returns contents of extensiont as a double


% --- Executes during object creation, after setting all properties.
function extensiont_CreateFcn(hObject, eventdata, handles)
% hObject    handle to extensiont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function learnrate_Callback(hObject, eventdata, handles)
% hObject    handle to learnrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of learnrate as text
%        str2double(get(hObject,'String')) returns contents of learnrate as a double


% --- Executes during object creation, after setting all properties.
function learnrate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to learnrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numt_Callback(hObject, eventdata, handles)
% hObject    handle to numt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numt as text
%        str2double(get(hObject,'String')) returns contents of numt as a double


% --- Executes during object creation, after setting all properties.
function numt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Traint.
function Traint_Callback(hObject, eventdata, handles)
% hObject    handle to Traint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ModelName;
global ModelPath;
disk = pwd;
disk = disk(1:1);
FileExtensions = get(handles.extensiont,'String');
LearnRate = get(handles.learnrate, 'String');
ensembleNum = get(handles.numt, 'String');
LearnRate = str2double(LearnRate);
ensembleNum = str2double(ensembleNum);
for close =1:1
    if get(handles.googlet,'Value')
        if get(handles.twot,'Value')
            TrainingDatasetPath = uigetdir([disk,':\欠陥検出\画像データ\2 クラス\'],'トレーニングデータセットを選択してください');
            if TrainingDatasetPath == 0
                break
            end
            ModelPath = [disk,':\欠陥検出\GoogLeNet\モデル\2 クラス\'];
        elseif get(handles.threet,'Value')
            TrainingDatasetPath = uigetdir([disk,':\欠陥検出\画像データ\3 クラス\'],'トレーニングデータセットを選択してください');
            if TrainingDatasetPath == 0
                break
            end
            ModelPath = [disk,':\欠陥検出\GoogLeNet\モデル\3 クラス\'];
        else
            TrainingDatasetPath = uigetdir([disk,':\欠陥検出\画像データ\4 クラス\'],'トレーニングデータセットを選択してください');
            if TrainingDatasetPath == 0
                break
            end
            ModelPath = [disk,':\欠陥検出\GoogLeNet\モデル\4 クラス\'];
        end
        mkdir(ModelPath);
        Optimizer = 'sgdm';
        LearnRateDropFactor = 0.5;
        LearnRateDropPeriod = 3;
        miniBatchSize = 10;
        Epochs = 12;
        trinwaitbar=waitbar(0,'トレーニングを開始');
        pause(1);
        net=load('google.mat');
        net=net.net;
        waitbar(10/100,trinwaitbar,['トレーニングプロセス、しばらくお待ちください  ' num2str(10) '%']);
        proportion = 90/ensembleNum;
        for ii=1:ensembleNum
            try
                digitData=imageDatastore(TrainingDatasetPath, 'IncludeSubFolders', true, 'FileExtensions', FileExtensions , 'LabelSource', 'foldernames');
            catch
                s = sprintf(['\n                   無効な画像パス \n\n','        画像パスを確認してください.\n']);
                msgbox(s,'Notification','help');
                delete(trinwaitbar)
            end
            [trainDB,checkDB] = splitEachLabel(digitData,0.7,'randomize');
            lgraph = layerGraph(net);
            lgraph = removeLayers(lgraph, {'loss3-classifier','prob','output'});
            numClasses = numel(categories(trainDB.Labels));
            newLayers = [
                fullyConnectedLayer(numClasses,'Name','fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10)
                softmaxLayer('Name','softmax')
                classificationLayer('Name','classoutput')];
            lgraph = addLayers(lgraph,newLayers);
            lgraph = connectLayers(lgraph,'pool5-drop_7x7_s1','fc');
            inputSize = net.Layers(1).InputSize;
            augimdsTrain = augmentedImageDatastore(inputSize(1:2),trainDB);
            augimdsValidation = augmentedImageDatastore(inputSize(1:2),checkDB);
            numIterationsPerEpoch = floor(numel(trainDB.Labels)/miniBatchSize);
            options = trainingOptions(Optimizer, ...
                'LearnRateSchedule','piecewise',...
                'LearnRateDropFactor',LearnRateDropFactor,...
                'LearnRateDropPeriod',LearnRateDropPeriod,...
                'MiniBatchSize',miniBatchSize, ...
                'MaxEpochs',Epochs, ...
                'InitialLearnRate',LearnRate, ...
                'ValidationData',augimdsValidation, ...
                'ValidationFrequency',numIterationsPerEpoch, ...
                'ValidationPatience',Inf, ...
                'Verbose',false ,...
                'Plots','none');
            try
                netTransfer(ii) = trainNetwork(augimdsTrain,lgraph,options);   %#ok
            catch
                s = sprintf(['\n                無効なパラメータ \n\n','        パラメータを確認してください.\n']);
                msgbox(s,'Notification','help');
                delete(trinwaitbar)
            end
           
            if (10+proportion*ii)>=99
                waitbar((10+proportion*ii)/100,trinwaitbar,['トレーニング終了  ' num2str(10+proportion*ii) '%']);
                pause(4);
                delete(trinwaitbar)
                msgbox('     モデルファイルを確認してください');
            else
                waitbar((10+proportion*ii)/100,trinwaitbar,['トレーニングプロセス、しばらくお待ちください  ' num2str(10+proportion*ii) '%']);
                pause(1);
            end
        end
        
        ModelName = sprintf('GModel_%s.mat',datestr(now, 'mmm_dd_yyyy_HH_MM'));
        save([ModelPath,ModelName],'netTransfer');
        
        
    end
    
    
    if get(handles.alexnett,'Value')
        if get(handles.twot,'Value')
            TrainingDatasetPath = uigetdir([disk,':\欠陥検出\画像データ\2 クラス\'],'トレーニングデータセットを選択してください');
            if TrainingDatasetPath == 0
                break
            end
            ModelPath = [disk,':\欠陥検出\AlexNet\モデル\2 クラス\'];
        elseif get(handles.threet,'Value')
            TrainingDatasetPath = uigetdir([disk,':\欠陥検出\画像データ\3 クラス\'],'トレーニングデータセットを選択してください');
            if TrainingDatasetPath == 0
                break
            end
            ModelPath = [disk,':\欠陥検出\AlexNet\モデル\3 クラス\'];
        else
            TrainingDatasetPath = uigetdir([disk,':\欠陥検出\画像データ\4 クラス\'],'トレーニングデータセットを選択してください');
            if TrainingDatasetPath == 0
                break
            end
            ModelPath = [disk,':\欠陥検出\AlexNet\モデル\4 クラス\'];
        end
        mkdir(ModelPath);
        Optimizer = 'sgdm';
        LearnRateDropFactor = 0.5;
        LearnRateDropPeriod = 3;
        Epochs = 12;
        trinwaitbar=waitbar(0,'Start training');
        pause(1);
        net=load('alex.mat');
        net=net.net;
        waitbar(10/100,trinwaitbar,['トレーニングプロセス、しばらくお待ちください  ' num2str(10) '%']);
        proportion = 90/ensembleNum;
        for ii=1:ensembleNum
            try
                 digitData=imageDatastore(TrainingDatasetPath, 'IncludeSubFolders', true, 'FileExtensions', FileExtensions , 'LabelSource', 'foldernames');
            catch
                s = sprintf(['\n                   無効な画像パス \n\n','        画像パスを確認してください.\n']);
                msgbox(s,'Notification','help');
                delete(trinwaitbar)
            end
            
            [trainDB,checkDB] = splitEachLabel(digitData,0.7,'randomize');
            layersTransfer = net.Layers(1:end-3);
            numClasses = numel(categories(trainDB.Labels));
            layers = [ ...
                layersTransfer
                fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
                softmaxLayer
                classificationLayer];
            miniBatchSize = 10;
            inputSize = net.Layers(1).InputSize;
            augimdsTrain = augmentedImageDatastore(inputSize(1:2),trainDB);
            augimdsValidation = augmentedImageDatastore(inputSize(1:2),checkDB);
            numIterationsPerEpoch = floor(numel(trainDB.Labels)/miniBatchSize);
            options = trainingOptions(Optimizer, ...
                'LearnRateSchedule','piecewise',...
                'LearnRateDropFactor',LearnRateDropFactor,...
                'LearnRateDropPeriod',LearnRateDropPeriod,...
                'MiniBatchSize',miniBatchSize, ...
                'MaxEpochs',Epochs, ...
                'InitialLearnRate',LearnRate, ...
                'ValidationData',augimdsValidation, ...
                'ValidationFrequency',numIterationsPerEpoch, ...
                'ValidationPatience',Inf, ...
                'Verbose',false ,...
                'Plots','none');
                 
            try
                netTransfer(ii) = trainNetwork(augimdsTrain,layers,options);   
            catch
                s = sprintf(['\n                無効なパラメータ \n\n','        パラメータを確認してください.\n']);
                msgbox(s,'Notification','help');
                delete(trinwaitbar)
            end
            
            if (10+proportion*ii)>=99
                waitbar((10+proportion*ii)/100,trinwaitbar,['トレーニング終了  ' num2str(10+proportion*ii) '%']);
                pause(4);
                delete(trinwaitbar)
                msgbox('     モデルファイルを確認してください');
            else
                waitbar((10+proportion*ii)/100,trinwaitbar,['トレーニングプロセス、しばらくお待ちください  ' num2str(10+proportion*ii) '%']);
                pause(1);
            end
        end
        
        ModelName = sprintf('AModel_%s.mat',datestr(now, 'mmm_dd_yyyy_HH_MM'));
        save([ModelPath,ModelName],'netTransfer');
        
    end
ModelName_dir = strfind(ModelName,'.');
ModelNamedir = ModelName(1:ModelName_dir(end)-1);
set(handles.text15,'String',ModelNamedir);  
set(handles.text9,'Visible','Off')
end

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text14,'String','予測画像未選択'); 
set(handles.text15,'String','予測モデル未選択');
set(handles.predict,'Enable','off');
clc;
clear ;
set(findobj('style','edit'),'string','');

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
clear ;
close all;

% --- Executes on button press in googlet.
function googlet_Callback(hObject, eventdata, handles)
% hObject    handle to googlet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.learnrate,'String','0.001');
% Hint: get(hObject,'Value') returns toggle state of googlet


% --- Executes on button press in alexnett.
function alexnett_Callback(hObject, eventdata, handles)
% hObject    handle to alexnett (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.learnrate,'String','0.0001');
% Hint: get(hObject,'Value') returns toggle state of alexnett
