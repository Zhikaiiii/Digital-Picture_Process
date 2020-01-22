function [L,Label_Num] = SLIC_superpixels(I, k)
%SLIC-�����طָ�
%IΪ����ͼ��kΪ�����ظ���
%LΪ����ĳ����طָ���
[M,N,~] = size(I);
%��ʼ�� ��ǩΪ-1������Ϊ����
label = -ones(M,N);
distance = 1000000*ones(M,N);
I_gray = rgb2gray(I);
% wavelength = [4 8 16 32];
% orientation = [0 45 90 135];
%gabor�˲���
% g = gabor(wavelength,orientation); 
% I_gabor = imgaborfilt(I_gray,g);
%ͼ��ת��lab�ռ�
I_lab = rgb2lab(I);
%���㳬���ر߳�
initial_step = round(sqrt(M*N/k));
row_cord = initial_step:initial_step:M-1;
column_cord = initial_step:initial_step:N-1;
%�õ���ʼ���ĵ������
[columns,rows] = meshgrid(column_cord,row_cord);
%�õ���ʼ��������
idxs = sub2ind([M,N],rows,columns);
idxs = reshape(idxs,1,size(row_cord,2)*size(column_cord,2));
idxs = sort(idxs);
%���ݶ�
[gx,gy] = imgradient(I_gray);
g = gx.^2 + gy.^2;
Label_Num = size(idxs,2);
imshow(I);
for i=1:Label_Num
    a = rows(i);
    b = columns(i);
    %�ҳ��ݶ���Сֵ���Ӧ����
    neighborhood_c = g(a-1:a+1,b-1:b+1);
    [~,idx_min] = min(neighborhood_c(:));
    [a1,b1] = ind2sub([3,3],idx_min);
    %ȷ���µľ�������
    rows(i) = a-(2-a1);
    columns(i) = b-(2-b1);
end
m = 30;
%��ʾ��������
k = 1;
while 1
    %����
    for i = 1:Label_Num
        row = rows(i);
        column = columns(i);
        %�ҳ�2s��2s����
        row_min = max(row - initial_step + 1,1);
        row_max = min(row + initial_step,M);
        column_min = max(column - initial_step + 1,1);
        column_max = min(column + initial_step,N);
        %ȡ�����򲿷�
        neighborhood_c = I_lab(row_min:row_max,column_min:column_max,:);%��ɫ������� 
        neighborhood_d = distance(row_min:row_max,column_min:column_max);%�����������
        neighborhood_l = label(row_min:row_max,column_min:column_max);%��ǩ�������
%         neighborhood_g = I_gabor(row_min:row_max,column_min:column_max,:); 
%         neighborhood_g = reshape(neighborhood_g,[],16);
        %����dc
        dc = sqrt((neighborhood_c(:,:,1)-I_lab(row,column,1)).^2 ...
            + (neighborhood_c(:,:,2)-I_lab(row,column,2)).^2 ...
            + (neighborhood_c(:,:,3)-I_lab(row,column,3)).^2);
        %����ds
        [x,y] = meshgrid(column_min:column_max,row_min:row_max);
        ds = sqrt((x-column).^2 + (y-row).^2);
%         dg_center = reshape(I_gabor(row,column,:),[],16);
%         dg = pdist2(neighborhood_g,dg_center)/sqrt(sum(dg_center.*dg_center));
%         dg = reshape(dg,row_max-row_min+1,column_max-column_min+1);
        %�������
%         D = sqrt(dc.^2 + m^2*(ds./initial_step).^2 + m^2*dg.^2);
        D = sqrt(dc.^2 + m^2*(ds./initial_step).^2);
        %�ҳ������С������
        idx_change = find(D<neighborhood_d);
        neighborhood_d(idx_change) = D(idx_change);
        neighborhood_l(idx_change) = i;
        %����ԭͼ
        distance(row_min:row_max,column_min:column_max) = neighborhood_d;
        label(row_min:row_max,column_min:column_max) = neighborhood_l;
    end
    %���¾�������
    res_all = 0;
    I_temp = I;
    for i = 1:Label_Num
        idx_i = find(label == i);
        if ~isempty(idx_i)
            [all_y,all_x]= ind2sub([M,N],idx_i);
            %��������е������ƽ��ֵ
            avery = round(mean(all_y,'all'));
            averx = round(mean(all_x,'all'));
            %����в�
            res_all = res_all + (avery-rows(i))^2 + (averx-columns(i))^2;
            rows(i) = avery;
            columns(i) = averx;
            I_temp(avery-1:avery+1,averx-1:averx+1,1) = 255;
            I_temp(avery-1:avery+1,averx-1:averx+1,2) = 0;
            I_temp(avery-1:avery+1,averx-1:averx+1,3) = 0;
        end
    end
    %��ʾ��������
    if mod(k,2)==0
        figure;
        BW = boundarymask(label);
        title_pic = ['��������',num2str(k)];
        imshow(imoverlay(I_temp,BW,'cyan'),'InitialMagnification',67),title(title_pic);
    end
    k = k+1;
    if res_all<0.01
        break;
    end
end
%ȥ��������
se = strel('square',5);
I_temp = I;
for i =1:Label_Num
    mask = zeros(M,N);
    idx_origin = find(label == i);
    mask(idx_origin) = 1;
    %�����㴦��
    mask2 = imclose(mask,se);
    idx_new = find(mask2);
    label(idx_new) = i;
    I_temp(rows(i)-1:rows(i)+1,columns(i)-1:columns(i)+1,1) = 255;
    I_temp(rows(i)-1:rows(i)+1,columns(i)-1:columns(i)+1,2) = 0;
    I_temp(rows(i)-1:rows(i)+1,columns(i)-1:columns(i)+1,3) = 0;
end
L = label;
end

