close all;
I_origin = imread('./r96_4.bmp');
I_origin = im2double(I_origin);
imshow(I_origin);
%图像二值化处理
I_bin=imbinarize(I_origin,0.5); 
% 分离前背景
fun1 = @(x) mean2(x);
mean_local = nlfilter(I_origin,[5 5],fun1);
se = strel('square',6);
mask1 = (abs(mean_local-0.4980)<0.001);
%去除散点，并膨胀得到完整背景图
mask1 = imopen(mask1,se);
mask1 = imdilate(mask1,se);
%背景置为白色
I_bin(mask1)=1;
figure;
imshow(I_bin),title('二值化结果');
%根据局部均值判断背景
mask2 = ~mask1;
se2 = strel('square',10);
%闭运算填补空洞,腐蚀稍微减小边界
mask2 = imclose(mask2,se);
mask2 = imerode(mask2,se2);
mask2 = imerode(mask2,se2);
figure;
imshow(mask2),title('前背景图');
%反相
I_bin = ~I_bin;
%形态学处理
CC1 = bwconncomp(I_bin,4);
numPixels = cellfun(@numel,CC1.PixelIdxList);
[~,num] = size(numPixels);
%去孤岛
marker1 = false(size(I_bin));
%通过连通域像素个数判断是否为孤岛
for i = 1:num
    if numPixels(i)<50
        marker1(CC1.PixelIdxList{i}) =1;
    end
end
%提取出孤岛
I_remove = imreconstruct(marker1,I_bin,4);
I_bin = I_bin - I_remove;
figure;
imshow(~I_bin),title('去孤岛');
%去空洞
marker2 = false(size(I_bin));
%取I_bin反相图片的连通域
CC2 = bwconncomp(~I_bin,4);
numPixels2 = cellfun(@numel,CC2.PixelIdxList);
[~,num2] = size(numPixels2);
for i = 1:num2
    if numPixels2(i)<70
        marker2(CC2.PixelIdxList{i}) =1;
    end
end
%提取出空洞
I_fill = imreconstruct(marker2, ~I_bin,4);
I_bin = I_bin + I_fill;
figure;
imshow(~I_bin),title('填空洞');
%细化
I_thin = bwmorph(I_bin,'thin',inf);
%第一次检测特征点去除桥接和断裂
detail_point = detail_point_detect(I_thin,mask2);
[I_thin_new, ~] = remove_false_point(I_thin, detail_point); 
%修剪去除毛刺
I_trim = fingerprint_trim(I_thin_new,5);
%重新提取特征点
detail_point = detail_point_detect(I_trim, mask2);
[I_remove, detail_point_new] = remove_false_point(I_trim, detail_point);
figure;
ax(1) = subplot(1,3,1);
imshow(~I_thin),title('细化');
ax(2) = subplot(1,3,2);
imshow(~I_thin_new),title('去桥接');
ax(3) = subplot(1,3,3);
imshow(~I_remove),title('修剪');
linkaxes(ax,'xy');
I_result = ~I_remove;
idx = find(detail_point_new ==1)';
idx2 = find(detail_point_new ==-1)';
[M,N] = size(I_remove);
figure;
imshow(I_result),title('找特征点');
for i = idx
    [m,n] = ind2sub([M,N],i);
    rectangle('Position',[n-2,m-2,5,5],'LineWidth',1,'EdgeColor','r');
end
for j = idx2
    [m,n] = ind2sub([M,N],j);
    rectangle('Position',[n-2,m-2,5,5],'LineWidth',1,'EdgeColor','g');
end
