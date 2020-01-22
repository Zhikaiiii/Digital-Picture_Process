close all;
clear all;
I = imread('.\333.bmp');
I = im2double(I);
figure;
imshow(I)
%��ͼ��ֿ�DFT
[M,N] = size(I);
a = 8 - mod(M,8);
b = 8 - mod(N,8);
%ͼ�񳤿�Ϊ8�ı���
I1 = padarray(I,[a b],'replicate', 'post');
%��ͼ����Χ����
I2 = padarray(I1,[12 12],'replicate','both');
F = zeros(M+a,N+b);
%����ͼ
orientation = zeros((M+a)/8,(N+b)/8);
%Ƶ��ͼ
frequency = zeros((M+a)/8,(N+b)/8);
%ǰ����ͼ
mask = zeros((M+a)/8,(N+b)/8);
pic = zeros(M+a,N+b);    
%������ֵ
threshold = 1.5;
for i = 1:(M+a)/8
    for j = 1:(N+b)/8
        pic(8*i-6:8*i-1,8*j-4) = 1;
        temp_F = fftshift(fft2(I2(8*i-7:8*i+24,8*j-7:8*j+24)));
        temp_FF=log(1+abs(temp_F));
        dc_freq = temp_FF(17,17);
        %���㷽��ͼ ��Ҫ��ֱ��������0
        temp_FF(17,17) = 0;
        [~, index] = max(temp_FF(:));
        [y1, x1] = ind2sub([32,32],index);
        orientation_local = atan2(y1-17, x1-17);
        frequency_local = sqrt((y1-17)^2+(x1-17)^2)/32;
        orientation(i,j) = orientation_local;
        frequency(i,j) = frequency_local;
        temp_FF(17,17) = dc_freq;
        F(8*i-7:8*i,8*j-7:8*j) = temp_F(13:20,13:20);
        pic(8*i-7:8*i,8*j-7:8*j) = imrotate(pic(8*i-7:8*i,8*j-7:8*j),-orientation_local*180/pi,'nearest','crop');
    end
end
%�ֿ�DFTͼ
F1 = log(1+abs(F));
I3 = I1+pic;
%ƽ������ͼ
orientation_double = 2*orientation;
orientation_cos = cos(orientation_double);
orientation_sin = sin(orientation_double); 
w = fspecial('gaussian',[3,3],1);
w2 = fspecial('gaussian',[3,3],0.2);
orientation_cos = imfilter(orientation_cos,w);
orientation_sin = imfilter(orientation_sin,w);    
orientation_new = 0.5*atan2(orientation_sin,orientation_cos);

%ƽ��Ƶ��ͼ
frequency_new = imfilter(frequency,w2);

%����ͼ
wavelengths =1./(frequency_new+eps);
for i = 1:(M+a)/8
    for j = 1:(N+b)/8
        %ͨ���趨��ֵ����Ƶ��ͼ����mask
        if((frequency_new(i,j)>0.09&&frequency_new(i,j)<0.15))
            mask(i,j)=1;
        else 
            mask(i,j)=0;
        end
    end
end
%Ѱ��mask����ͨ��
CC = bwconncomp(mask);
numPixels = cellfun(@numel,CC.PixelIdxList);
[~,num] = size(numPixels);
mask2 = false(size(mask));
for i = 1:num
    if numPixels(i)>5%�����ͨ�����ظ�������5
        mask2(CC.PixelIdxList{i}) = 1;
    end
end

se=strel('square',20);
mask3=imclose(mask2,se);%���б����㣬������ͨ���ڵĵ�
se2=strel('disk',6);%Բ��-�뾶6
mask4=imdilate(mask3,se2);%�������ͣ���΢���ű�Ե
CC2 = bwconncomp(mask4);
numPixels2 = cellfun(@numel,CC2.PixelIdxList);
[biggest,idx] = max(numPixels2);
%��ȡһ�������ͨ��
mask5 = false(size(mask));
mask5(CC2.PixelIdxList{idx}) = 1;
figure;
subplot(2,3,1),imshow(F1,[]),title('�ֿ�DFTͼ');
subplot(2,3,2),quiver(cos(orientation+pi/2), sin(orientation+pi/2)),title('ƽ��ǰ�ķ���ͼ');
axis ij;
subplot(2,3,3),quiver(cos(orientation_new+pi/2), sin(orientation_new+pi/2)),title('ƽ����ķ���ͼ');
axis ij;
subplot(2,3,4),imshow(mask5),title('ǰ����ͼ');
subplot(2,3,5),imshow(frequency,[]),title('ƽ��ǰ��Ƶ��ͼ');
subplot(2,3,6),imshow(frequency_new,[]),title('ƽ�����Ƶ��ͼ');
I4=I1;
for i = 1:(M+a)/8
    for j = 1:(N+b)/8
        if(mask5(i,j))
        else
            I4(8*i-7:8*i,8*j-7:8*j)=0;
        end
    end
end
figure;
imshow(I4);
[M,N] = size(I1);
I_result = zeros(M,N);
pic2 = zeros(M,N);  
%�ֿ�gabor�˲�
for i =1:M/8
    for j=1:N/8
        pic2(8*i-6:8*i-1,8*j-4) = 1;
        if mask5(i,j) && wavelengths(i,j) < 100
            pic2(8*i-7:8*i,8*j-7:8*j) = imrotate(pic2(8*i-7:8*i,8*j-7:8*j),-orientation(i,j)*180/pi,'nearest','crop');
            [msg,phase] = imgaborfilt(I1(i*8-7:i*8,j*8-7:j*8),wavelengths(i,j),-180*orientation(i,j)/pi);
            I_result(i*8-7:i*8,j*8-7:j*8) = msg.*cos(phase);
        end
    end
end
I4 = I4 +pic2;
figure;
imshow(I4),title('ƽ����ķ���ͼ');
%�����ս���ٽ���ƽ��
w = fspecial('gaussian',[5,5],1);
figure;
ax(1)=subplot(1,3,1),imshow(I_result),title('ƽ��ǰ�Ľ��');
I_result_bin=imbinarize(I_result,0.45); 
ax(2)=subplot(1,3,2),imshow(I_result_bin),title('��ֵ���Ľ��');
I_result_smooth = imfilter(I_result_bin,w);
ax(3)=subplot(1,3,3),imshow(I_result_smooth),title('ƽ����Ľ��');
linkaxes(ax,'xy');
imwrite(I_result_smooth,'.\3_result.bmp');