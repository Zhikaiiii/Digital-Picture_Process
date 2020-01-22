function varargout = Segmentation(varargin)
% SEGMENTATION MATLAB code for Segmentation.fig
%      SEGMENTATION, by itself, creates a new SEGMENTATION or raises the existing
%      singleton*.
%
%      H = SEGMENTATION returns the handle to a new SEGMENTATION or the handle to
%      the existing singleton*.
%
%      SEGMENTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGMENTATION.M with the given input arguments.
%
%      SEGMENTATION('Property','Value',...) creates a new SEGMENTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Segmentation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Segmentation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Segmentation

% Last Modified by GUIDE v2.5 18-Dec-2019 00:08:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Segmentation_OpeningFcn, ...
                   'gui_OutputFcn',  @Segmentation_OutputFcn, ...
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


% --- Executes just before Segmentation is made visible.
function Segmentation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Segmentation (see VARARGIN)

% Choose default command line output for Segmentation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
type = get(handles.popupmenu_pic, 'value');
path = ['.\data\',num2str(type),'.jpg'];
pic = imread(path);
ax(1) = handles.axes1;
ax(2) = handles.axes2;
ax(3) = handles.axes3;
axes(handles.axes1);
linkaxes(ax,'xy');
imshow(pic);
%前景图的点
global fore_point ;
fore_point = [];
%背景图的点
global back_point ;
back_point = [];
%聚类图和结果
global L;
L = [];
global num;
num = 0;
global originImage;
originImage=pic;
global maskImage;
%结果
maskImage = [];
% UIWAIT makes Segmentation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Segmentation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in radiobutton_fore.
function radiobutton_fore_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_fore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fore_point ;
global back_point;
global originImage;
set(handles.radiobutton_back,'value',0);
axes(handles.axes1);
[M,N,~] = size(originImage);
while 1
%     axes(handles.axes1);
%     imshow(originImage);
    state = get(handles.radiobutton_back, 'value');
    state2 = get(handles.radiobutton_fore,'value');
    if state == 1 || state2 == 0
        break;
    end
    h1 = drawpoint;
    if round(h1.Position(1)) <= N && round(h1.Position(2))<=M
        fore_point = [fore_point;round(h1.Position)];
    end
    delete(h1);
    [num1,~] = size(fore_point);
    [num2,~] = size(back_point);
    for i=1:num1
       originImage(fore_point(i,2)-3:fore_point(i,2)+3,fore_point(i,1)-3:fore_point(i,1)+3,1) = 255;
       originImage(fore_point(i,2)-3:fore_point(i,2)+3,fore_point(i,1)-3:fore_point(i,1)+3,2) = 0;
       originImage(fore_point(i,2)-3:fore_point(i,2)+3,fore_point(i,1)-3:fore_point(i,1)+3,3) = 0;
    end
    for i=1:num2
       originImage(back_point(i,2)-3:back_point(i,2)+3,back_point(i,1)-3:back_point(i,1)+3,1) = 0;
       originImage(back_point(i,2)-3:back_point(i,2)+3,back_point(i,1)-3:back_point(i,1)+3,2) = 0;
       originImage(back_point(i,2)-3:back_point(i,2)+3,back_point(i,1)-3:back_point(i,1)+3,3) = 255;
    end
    imshow(originImage);
%     h1 = impoly(gca,fore_point,'Closed',false);

end
% Hint: get(hObject,'Value') returns toggle state of radiobutton_fore


% --- Executes on button press in radiobutton_back.
function radiobutton_back_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global back_point;
global fore_point;
global originImage;
[M,N,~] = size(originImage);
set(handles.radiobutton_fore,'value',0);
axes(handles.axes1);
% imshow(originImage);
while 1
    state = get(handles.radiobutton_fore, 'value');
    state2 = get(handles.radiobutton_back,'value');
    if state == 1 || state2 == 0
        break;
    end
    h1 = drawpoint;
    if round(h1.Position(1)) <= N && round(h1.Position(2))<=M
        back_point = [back_point;round(h1.Position)];
    end
    delete(h1);
    [num1,~] = size(fore_point);
    [num2,~] = size(back_point);
    %显示点
    for i=1:num1
       originImage(fore_point(i,2)-3:fore_point(i,2)+3,fore_point(i,1)-3:fore_point(i,1)+3,1) = 255;
       originImage(fore_point(i,2)-3:fore_point(i,2)+3,fore_point(i,1)-3:fore_point(i,1)+3,2) = 0;
       originImage(fore_point(i,2)-3:fore_point(i,2)+3,fore_point(i,1)-3:fore_point(i,1)+3,3) = 0;
%         scatter(fore_point(i,2),fore_point(i,1));
    end
    for i=1:num2
%         scatter(back_point(i,2),back_point(i,1));
       originImage(back_point(i,2)-3:back_point(i,2)+3,back_point(i,1)-3:back_point(i,1)+3,1) = 0;
       originImage(back_point(i,2)-3:back_point(i,2)+3,back_point(i,1)-3:back_point(i,1)+3,2) = 0;
       originImage(back_point(i,2)-3:back_point(i,2)+3,back_point(i,1)-3:back_point(i,1)+3,3) = 255;
    end
%     scatter(fore_point(:,2),fore_point(:,1));
%     scatter(back_point(:,2),back_point(:,1));
%     imshow(originImage);
    imshow(originImage);
end
% Hint: get(hObject,'Value') returns toggle state of radiobutton_back


% --- Executes on button press in pushbutton_confirm.
function pushbutton_confirm_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_confirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global originImage;
set(handles.radiobutton_fore,'value',0);
set(handles.radiobutton_back,'value',0);
imshow(originImage);


% --- Executes on button press in pushbutton_begin.
function pushbutton_begin_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_begin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global back_point;
global fore_point;
global L;
global num;
global maskImage;
set(handles.radiobutton_fore,'value',0);
set(handles.radiobutton_back,'value',0);

back_point = round(back_point);
fore_point = round(fore_point);
type = get(handles.popupmenu_pic, 'value');
path = ['.\data\',num2str(type),'.jpg'];
I = imread(path);
new_num = str2num(get(handles.edit_num,'string'));
if new_num ~= num
    %超像素分割
    axes(handles.axes3);
    [M,N,~] = size(I);
    %初始化 标签为-1，距离为无穷
    label = -ones(M,N);
    distance = 1000000*ones(M,N);
    I_gray = rgb2gray(I);
    %图像转到lab空间
    I_lab = rgb2lab(I);
    %计算超像素边长
    initial_step = round(sqrt(M*N/new_num));
    row_cord = initial_step:initial_step:M-1;
    column_cord = initial_step:initial_step:N-1;
    %得到初始中心点的坐标
    [columns,rows] = meshgrid(column_cord,row_cord);
    %得到初始聚类中心
    idxs = sub2ind([M,N],rows,columns);
    idxs = reshape(idxs,1,size(row_cord,2)*size(column_cord,2));
    idxs = sort(idxs);
    %求梯度
    [gx,gy] = imgradient(I_gray);
    g = gx.^2 + gy.^2;
    Label_Num = size(idxs,2);
    for i=1:Label_Num
        a = rows(i);
        b = columns(i);
        %找出梯度最小值点对应索引
        neighborhood_c = g(a-1:a+1,b-1:b+1);
        [~,idx_min] = min(neighborhood_c(:));
        [a1,b1] = ind2sub([3,3],idx_min);
        %确定新的聚类中心
        rows(i) = a-(2-a1);
        columns(i) = b-(2-b1);
    end
    m = 30;
    %表示迭代次数
    k = 1;
    while 1
    %聚类
        for i = 1:Label_Num
            row = rows(i);
            column = columns(i);
            %找出2s×2s邻域
            row_min = max(row - initial_step + 1,1);
            row_max = min(row + initial_step,M);
            column_min = max(column - initial_step + 1,1);
            column_max = min(column + initial_step,N);
            %取出邻域部分
            neighborhood_c = I_lab(row_min:row_max,column_min:column_max,:);%颜色邻域矩阵 
            neighborhood_d = distance(row_min:row_max,column_min:column_max);%距离邻域矩阵
            neighborhood_l = label(row_min:row_max,column_min:column_max);%标签邻域矩阵
            %计算dc
            dc = sqrt((neighborhood_c(:,:,1)-I_lab(row,column,1)).^2 ...
                + (neighborhood_c(:,:,2)-I_lab(row,column,2)).^2 ...
                + (neighborhood_c(:,:,3)-I_lab(row,column,3)).^2);
            %计算ds
            [x,y] = meshgrid(column_min:column_max,row_min:row_max);
            ds = sqrt((x-column).^2 + (y-row).^2);
            %计算距离
            D = sqrt(dc.^2 + m^2*(ds./initial_step).^2);
            %找出距离减小的坐标
            idx_change = find(D<neighborhood_d);
            neighborhood_d(idx_change) = D(idx_change);
            neighborhood_l(idx_change) = i;
            %更改原图
            distance(row_min:row_max,column_min:column_max) = neighborhood_d;
            label(row_min:row_max,column_min:column_max) = neighborhood_l;
        end
        %更新聚类中心
        res_all = 0;
        I_temp = I;
        for i = 1:Label_Num
            idx_i = find(label == i);
            if ~isempty(idx_i)
                [all_y,all_x]= ind2sub([M,N],idx_i);
                %求该类所有点坐标的平均值
                avery = round(mean(all_y,'all'));
                averx = round(mean(all_x,'all'));
                %计算残差
                res_all = res_all + (avery-rows(i))^2 + (averx-columns(i))^2;
                rows(i) = avery;
                columns(i) = averx;
                I_temp(avery-1:avery+1,averx-1:averx+1,1) = 255;
                I_temp(avery-1:avery+1,averx-1:averx+1,2) = 0;
                I_temp(avery-1:avery+1,averx-1:averx+1,3) = 0;
            end
        end
        %显示迭代过程
        if mod(k,2)==0
            BW = boundarymask(label);
            axes(handles.axes3);
            imshow(imoverlay(I_temp,BW,'cyan'),'InitialMagnification',67);
            k
        end
        k = k+1;
        if res_all<0.01
            break;
        end
    end
    %去除孤立点
    se = strel('square',5);
    I_temp = I;
    for i =1:Label_Num
        mask = zeros(M,N);
        idx_origin = find(label == i);
        mask(idx_origin) = 1;
        %闭运算处理
        mask2 = imclose(mask,se);
        idx_new = find(mask2);
        label(idx_new) = i;
        I_temp(rows(i)-1:rows(i)+1,columns(i)-1:columns(i)+1,1) = 255;
        I_temp(rows(i)-1:rows(i)+1,columns(i)-1:columns(i)+1,2) = 0;
        I_temp(rows(i)-1:rows(i)+1,columns(i)-1:columns(i)+1,3) = 0;
    end
    BW = boundarymask(label);
    imshow(imoverlay(I_temp,BW,'cyan'),'InitialMagnification',67);
    L = label;
    num = new_num;
end
%Lazysnapping
foregroundInd = sub2ind(size(I),fore_point(:,2),fore_point(:,1));
backgroundInd = sub2ind(size(I),back_point(:,2),back_point(:,1));
BW = lazysnapping(I,L,foregroundInd,backgroundInd);
axes(handles.axes2);
cla;
maskImage = I;
maskImage(repmat(~BW,[1 1 3])) = 0;
imshow(maskImage);

% --- Executes on selection change in popupmenu_pic.
function popupmenu_pic_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%         all = get(handles.popupmenu_pic, 'string');
global fore_point ;
fore_point = [];
global back_point ;
back_point = [];
global originImage;
axes(handles.axes3);
cla;
axes(handles.axes2);
cla;
type = get(handles.popupmenu_pic, 'value');
path = ['.\data\',num2str(type),'.jpg'];
pic = imread(path);
originImage = pic;
axes(handles.axes1);
imshow(originImage);
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_pic contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_pic


% --- Executes during object creation, after setting all properties.
function popupmenu_pic_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_num_Callback(hObject, eventdata, handles)
% hObject    handle to edit_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_num as text
%        str2double(get(hObject,'String')) returns contents of edit_num as a double


% --- Executes during object creation, after setting all properties.
function edit_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_save.
function pushbutton_save_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global maskImage;
I_save = maskImage;
pic_name = ['result',num2str(get(handles.popupmenu_pic, 'value')),'.jpg'];
imwrite(I_save,pic_name);


% --- Executes on button press in pushbutton_remove.
function pushbutton_remove_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_remove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
