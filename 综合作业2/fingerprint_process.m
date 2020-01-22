close all;
I_origin = imread('./r2_5.bmp');
I_origin = im2double(I_origin);
imshow(I_origin),title('ԭͼ');
%ͼ���ֵ������
I_bin=imbinarize(I_origin,0.5); 
figure;
imshow(I_bin),title('��ֵ�����');
%����ǰ����
fun1 = @(x) mean2(x);
mean_local = nlfilter(I_bin,[5 5],fun1);
%���ݾֲ���ֵ�жϱ���
mask = (mean_local<1);
se = strel('square',10);
%��������ն�,��ʴ��΢��С�߽�
mask = imclose(mask,se);
mask = imerode(mask,se);
mask = imerode(mask,se);
figure;
imshow(mask),title('ǰ����ͼ');
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

%��������ȡ
%��һ�μ��������ȥ���ŽӺͶ���
detail_point = detail_point_detect(I_thin,mask);
[I_thin_new, ~] = remove_false_point(I_thin, detail_point); 
%�޼�
I_trim = fingerprint_trim(I_thin_new,5);
figure;
ax(1) = subplot(1,3,1);
imshow(~I_thin),title('ϸ��');
ax(2) = subplot(1,3,2);
imshow(~I_thin_new),title('ȥ�Ž�');
ax(3) = subplot(1,3,3);
imshow(~I_trim),title('�޼�');
linkaxes(ax,'xy');
detail_point = detail_point_detect(I_trim,mask);
[I_remove, detail_point_new] = remove_false_point(I_trim, detail_point); 
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