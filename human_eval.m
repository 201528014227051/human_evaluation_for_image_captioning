function varargout = human_eval(varargin)
% HUMAN_EVAL MATLAB code for human_eval.fig
%      HUMAN_EVAL, by itself, creates a new HUMAN_EVAL or raises the existing
%      singleton*.
%
%      H = HUMAN_EVAL returns the handle to a new HUMAN_EVAL or the handle to
%      the existing singleton*.
%
%      HUMAN_EVAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HUMAN_EVAL.M with the given input arguments.
%
%      HUMAN_EVAL('Property','Value',...) creates a new HUMAN_EVAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before human_eval_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to human_eval_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help human_eval

% Last Modified by GUIDE v2.5 07-Aug-2018 12:25:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @human_eval_OpeningFcn, ...
                   'gui_OutputFcn',  @human_eval_OutputFcn, ...
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


% --- Executes just before human_eval is made visible.
function human_eval_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to human_eval (see VARARGIN)

% Choose default command line output for human_eval
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
setappdata(handles.human_eval,'input_ucm',0);

% UIWAIT makes human_eval wait for user response (see UIRESUME)
% uiwait(handles.human_eval);


% --- Outputs from this function are returned to the command line.
function varargout = human_eval_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function UCM_Callback(hObject, eventdata, handles)
% hObject    handle to UCM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
input_ucm = str2num(get(hObject,'String'));
if input_ucm == 1%unrelated
elseif input_ucm == 2
elseif input_ucm ==3%right
else
    helpdlg('input must be 1,2 or 3','hint');
end
setappdata(handles.human_eval,'input_ucm',input_ucm);
% Hints: get(hObject,'String') returns contents of UCM as text
%        str2double(get(hObject,'String')) returns contents of UCM as a double


% --- Executes during object creation, after setting all properties.
function UCM_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UCM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in begin.
function begin_Callback(hObject, eventdata, handles)
% hObject    handle to begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[ucm_result_txt, file_path] = uigetfile('*.txt' ,'open captions txt');
img_path = uigetdir('/home/user2/qubo_captions/data/');%'/home/user2/qubo_captions/data/RSICD/imgs/
[tasks_txt, task_path] = uigetfile('*.txt','open test image names');%'./rsicd/rsicd_test.txt';
% using three list to store the 1 2 3
% get the number of test
lentask = 0;
fid_tasks = fopen(fullfile(task_path, tasks_txt));
while ~feof(fid_tasks)
        [~] = fgetl(fid_tasks);
        lentask = lentask + 1;
end
fclose(fid_tasks);

list_ucm = zeros(lentask,1);

% hint of input
str = 'input the number(1,2 or 3):';
 
i = 1;
set(handles.indeximg,'String',num2str(i));
fid_tasks_txt = fopen(fullfile(task_path, tasks_txt));
fid_ucm = fopen(fullfile(file_path, ucm_result_txt));
f_i = 1;
    img_name = fgetl(fid_tasks_txt);
    axes(handles.imgs);
    img_src=imread(fullfile(img_path,img_name));
    imshow(img_src);
    ucm_line = fgetl(fid_ucm);
    set(handles.UCMtxt,'String',ucm_line); 

setappdata(handles.human_eval,'fid_ucm',fid_ucm);
setappdata(handles.human_eval,'f_i',f_i);
setappdata(handles.human_eval,'fid_tasks_txt',fid_tasks_txt);
setappdata(handles.human_eval,'list_ucm',list_ucm);
setappdata(handles.human_eval,'img_path',img_path);
setappdata(handles.human_eval,'lentask',lentask);



% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fid_ucm=getappdata(handles.human_eval,'fid_ucm');
f_i=getappdata(handles.human_eval,'f_i');
fid_tasks_txt=getappdata(handles.human_eval,'fid_tasks_txt');
list_ucm=getappdata(handles.human_eval,'list_ucm');
img_path=getappdata(handles.human_eval,'img_path');
lentask = getappdata(handles.human_eval,'lentask');
i = f_i;
set(handles.indeximg,'String',num2str(i+1));
if i<=(lentask-1)          
        list_ucm(i,1) = getappdata(handles.human_eval,'input_ucm');
        img_name = fgetl(fid_tasks_txt);
        axes(handles.imgs);
        img_src=imread(fullfile(img_path,img_name));
        imshow(img_src);
        ucm_line = fgetl(fid_ucm);
        set(handles.UCMtxt,'String',ucm_line); 
        set(handles.UCM,'String','');
    %disp(strcat('refer:',refer_line));
        f_i = f_i +1; 
    
elseif i==lentask
        list_ucm(i,1) = getappdata(handles.human_eval,'input_ucm');
        set(handles.UCM,'String','');
        fclose(fid_ucm);
        fclose(fid_tasks_txt);
    %    assert(i==1,'please click statistics button');
        helpdlg('please click statistics button','hint');
else
        fclose(fid_ucm);
        fclose(fid_sydney);
        fclose(fid_rsicd);
        fclose(fid_tasks_txt);
        assert('please click statistics button');
     
end
setappdata(handles.human_eval,'fid_ucm',fid_ucm);
setappdata(handles.human_eval,'f_i',f_i);
setappdata(handles.human_eval,'fid_tasks_txt',fid_tasks_txt);
setappdata(handles.human_eval,'list_ucm',list_ucm);


% --- Executes on button press in statistics.
function statistics_Callback(hObject, eventdata, handles)
% hObject    handle to statistics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list_ucm=getappdata(handles.human_eval,'list_ucm');
lentask = getappdata(handles.human_eval,'lentask');
dataset_name = getappdata(handles.human_eval,'dataset_name');
path_save = uigetdir('/home/user2/','path to save');
f_result = fopen(fullfile(path_save,strcat(dataset_name,'_caculate_result.txt')),'a+');
% caculate the number of different kinds
%ucm_list
i_ucm_1 = 0;
i_ucm_2 = 0;
i_ucm_3 = 0;
for i_ucm=1:lentask
    fwrite(f_result,num2str(list_ucm(i_ucm,1)));
    if (list_ucm(i_ucm,1) == 1)
        i_ucm_1 = i_ucm_1 + 1;
    elseif (list_ucm(i_ucm,1) == 2)
        i_ucm_2 = i_ucm_2 + 1;
    elseif (list_ucm(i_ucm,1) == 3)
        i_ucm_3 = i_ucm_3 + 1;
    end
end
ucm_1 = strcat(dataset_name,'-unrelated:',num2str(i_ucm_1),'\r\n');
ucm_2 = strcat(dataset_name,'-related:',num2str(i_ucm_2),'\r\n');
ucm_3 = strcat(dataset_name,'-totally related:',num2str(i_ucm_3),'\r\n');
fwrite(f_result,ucm_1);
fwrite(f_result,ucm_2);
fwrite(f_result,ucm_3);
fclose(f_result);



function nameDataset_Callback(hObject, eventdata, handles)
% hObject    handle to nameDataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nameDataset as text
%        str2double(get(hObject,'String')) returns contents of nameDataset as a double
dataset_name = get(hObject,'String');
set(handles.nameDataset,'String',dataset_name); 
setappdata(handles.human_eval,'dataset_name',dataset_name);

% --- Executes during object creation, after setting all properties.
function nameDataset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nameDataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
