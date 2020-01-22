close all;
I_origin = imread('./r96_4.bmp');
I_origin = im2double(I_origin);
imshow(I_origin);
%ͼ���ֵ������
I_bin=imbinarize(I_origin,0.5); 
% ����ǰ����
fun1 = @(x) mean2(x);
mean_local = nlfilter(I_origin,[5 5],fun1);
se = strel('square',6);
mask1 = (abs(mean_local-0.4980)<0.001);
%ȥ��ɢ�㣬�����͵õ���������ͼ
mask1 = imopen(mask1,se);
mask1 = imdilate(mask1,se);
%������Ϊ��ɫ
I_bin(mask1)=1;
figure;
imshow(I_bin),title('��ֵ�����');
%���ݾֲ���ֵ�жϱ���
mask2 = ~mask1;
se2 = strel('square',10);
%��������ն�,��ʴ��΢��С�߽�
mask2 = imclose(mask2,se);
mask2 = imerode(mask2,se2);
mask2 = imerode(mask2,se2);
figure;
imshow(mask2),title('ǰ����ͼ');
%����
I_bin = ~I_bin;
%��̬ѧ����
CC1 = bwconncomp(I_bin,4);
numPixels = cellfun(@numel,CC1.PixelIdxList);
[~,num] = size(numPixels);
%ȥ�µ�
marker1 = false(size(I_bin));
%ͨ����ͨ�����ظ����ж��Ƿ�Ϊ�µ�
for i = 1:num
    if numPixels(i)<50
        marker1(CC1.PixelIdxList{i}) =1;
    end
end
%��ȡ���µ�
I_remove = imreconstruct(marker1,I_bin,4);
I_bin = I_bin - I_remove;
figure;
imshow(~I_bin),title('ȥ�µ�');
%ȥ�ն�
marker2 = false(size(I_bin));
%ȡI_bin����ͼƬ����ͨ��
CC2 = bwconncomp(~I_bin,4);
numPixels2 = cellfun(@numel,CC2.PixelIdxList);
[~,num2] = size(numPixels2);
for i = 1:num2
    if numPixels2(i)<70
        marker2(CC2.PixelIdxList{i}) =1;
    end
end
%��ȡ���ն�
I_fill = imreconstruct(marker2, ~I_bin,4);
I_bin = I_bin + I_fill;
figure;
imshow(~I_bin),title('��ն�');
%ϸ��
I_thin = bwmorph(I_bin,'thin',inf);
%��һ�μ��������ȥ���ŽӺͶ���
detail_point = detail_point_detect(I_thin,mask2);
[I_thin_new, ~] = remove_false_point(I_thin, detail_point); 
%�޼�ȥ��ë��
I_trim = fingerprint_trim(I_thin_new,5);
%������ȡ������
detail_point = detail_point_detect(I_trim, mask2);
[I_remove, detail_point_new] = remove_false_point(I_trim, detail_point);
figure;
ax(1) = subplot(1,3,1);
imshow(~I_thin),title('ϸ��');
ax(2) = subplot(1,3,2);
imshow(~I_thin_new),title('ȥ�Ž�');
ax(3) = subplot(1,3,3);
imshow(~I_remove),title('�޼�');
linkaxes(ax,'xy');
I_result = ~I_remove;
idx = find(detail_point_new ==1)';
idx2 = find(detail_point_new ==-1)';
[M,N] = size(I_remove);
figure;
imshow(I_result),title('��������');
for i = idx
    [m,n] = ind2sub([M,N],i);
    rectangle('Position',[n-2,m-2,5,5],'LineWidth',1,'EdgeColor','r');
end
for j = idx2
    [m,n] = ind2sub([M,N],j);
    rectangle('Position',[n-2,m-2,5,5],'LineWidth',1,'EdgeColor','g');
end
