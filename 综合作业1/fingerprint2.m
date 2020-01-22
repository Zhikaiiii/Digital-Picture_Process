close all;
clear all;
I = imread('.\23_2.bmp');
I = im2double(I);
imshow(I)
% [orientation, wavelengths, I1] = local_DFT(I);
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
threshold2 = 0.035;
for i = 1:(M+a)/8
    for j = 1:(N+b)/8
        pic(8*i-6:8*i-1,8*j-4) = 1;
        temp_F = fftshift(fft2(I2(8*i-7:8*i+24,8*j-7:8*j+24)));
        temp_FF=log(1+abs(temp_F)); 
        %���ݷֿ�DFT�ľ�ֵ�ͷ����ж��Ƿ�Ϊָ��
        average = mean2(temp_FF(13:20,13:20));
        std = std2(I1(8*i-7:8*i,8*j-7:8*j));
        if average > threshold && std >threshold2
           mask(i,j)= 1;
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
        else
           I1(8*i-7:8*i,8*j-7:8*j) = 0;
        end 
    end
end
%�ֿ�DFTͼ
F1 = log(1+abs(F));
I3 = I1+pic;
%ƽ������ͼ
orientation_double = 2*orientation;
orientation_cos = cos(orientation_double);
orientation_sin = sin(orientation_double); 
w = fspecial('gaussian',[5,5],1);
w2 = fspecial('gaussian',[3,3],1);
orientation_cos2 = imfilter(orientation_cos,w);
orientation_sin2 = imfilter(orientation_sin,w);    
orientation_new = 0.5*atan2(orientation_sin2,orientation_cos2);
figure;
subplot(2,3,1),imshow(F1,[]),title('�ֿ�DFTͼ');
subplot(2,3,2),quiver(cos(orientation+pi/2), sin(orientation+pi/2)),title('ƽ��ǰ�ķ���ͼ');
axis ij;
set(gca,'YLim',[0 40]);
set(gca,'XLim',[0 40]);
subplot(2,3,3),quiver(cos(orientation_new+pi/2), sin(orientation_new+pi/2)),title('ƽ����ķ���ͼ');
axis ij;
set(gca,'YLim',[0 40]);
set(gca,'XLim',[0 40]);
subplot(2,3,4),imshow(mask),title('ǰ����ͼ');
%ƽ��Ƶ��ͼ
frequency_new = imfilter(frequency,w);
subplot(2,3,5),imshow(frequency),title('ƽ��ǰ��Ƶ��ͼ');
subplot(2,3,6),imshow(frequency_new),title('ƽ�����Ƶ��ͼ');
%����ͼ
wavelengths =1./(frequency+eps);
[M,N] = size(I1);
I_result = zeros(M,N);
pic2 = zeros(M,N);  
for i =1:M/8
    for j=1:N/8
        pic2(8*i-6:8*i-1,8*j-4) = 1;
        if mean2(I1(8*i-7:8*i,8*j-7:8*j))~=0 && wavelengths(i,j) < 1000
            if wavelengths(i,j) >8.8 && i>M/16 
                wavelengths(i,j) = 8;
            end
            pic2(8*i-7:8*i,8*j-7:8*j) = imrotate(pic2(8*i-7:8*i,8*j-7:8*j),-orientation_new(i,j)*180/pi,'nearest','crop');
            %��ÿһ�����Gabor�˲�
            [msg,pha] = imgaborfilt(I1(i*8-7:i*8,j*8-7:j*8),wavelengths(i,j),-180*orientation_new(i,j)/pi,'SpatialFrequencyBandwidth' ,0.5);
            I_result(i*8-7:i*8,j*8-7:j*8) = msg.*cos(pha);
            gaborfilter = generate_gabor(4,-180*orientation_new(i,j)/pi,wavelengths(i,j));
            I_mygabor(8*i-7:8*i,8*j-7:8*j) = imfilter(I1(8*i-7:8*i,8*j-7:8*j),gaborfilter);
        end
    end
end
I1 = I1 +pic2;
figure;
subplot(1,2,1),imshow(I3),title('ƽ��ǰ�ķ���ͼ2');
subplot(1,2,2),imshow(I1),title('ƽ����ķ���ͼ2');
%�����ս���ٽ���ƽ��
w = fspecial('gaussian',[5,5],1);
figure;
subplot(1,3,1),imshow(I_result),title('ƽ��ǰ�Ľ��');
I_result_bin=imbinarize(I_result,0.3); 
subplot(1,3,2),imshow(I_result_bin),title('��ֵ���Ľ��');
I_result_smooth = imfilter(I_result_bin,w);
subplot(1,3,3),imshow(I_result_smooth),title('ƽ����Ľ��');
figure;
imshow(I_mygabor),title('ʹ���Լ���gabor');
imwrite(I_result_smooth,'.\2_result.bmp');