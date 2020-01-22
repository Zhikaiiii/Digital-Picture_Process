close all;
I = imread('.\3.bmp');
I = im2double(I);
[M,N]= size(I);

P = max(2*[M N]);% Padding size. 
[DX, DY] = meshgrid(1:P);
H = ones(P,P);
D0 = 40;
n = 2;
F1 = fftshift(fft2(I,P,P));
F2 = log(1+abs(F1));
figure;
subplot(2,2,1),imshow(F2,[]),title('原图傅里叶变换');
%用notch滤波器去除原图中的黑点
notch = [616,237;252,54;60,440;425,608;240,987;614,1176;60,1421;444,1552];
for k = 1:8
    Dk1 = sqrt((DX-notch(k,1)).^2+(DY-notch(k,2)).^2);
    Dk2 = sqrt((DX-P-2+notch(k,1)).^2+(DY-P-2+notch(k,2)).^2);
    H1 = 1./(1+(D0./Dk1).^(2*n));
    H2 = 1./(1+(D0./Dk2).^(2*n));
    H = H.*H1.*H2;
end
subplot(2,2,2),imshow(H,[]),title('滤波器1');
G = H.*F1;
%去除黑线
H_2 = ones(P,P);
H_2(780:850,:)=0;
H_2(780:850,740:890) = 1;
angle = atan2(816-709,1340-816);
H_2 = imrotate(H_2,angle*180/pi,'nearest','crop');
G2 = G.*H_2;
subplot(2,2,3),imshow(H_2,[]),title('滤波器2');
subplot(2,2,4),imshow(log(1+abs(G2)),[]),title('处理后的傅里图');
%反变换得到原图
I2 = real(ifft2(ifftshift(G2)));
I2 = I2(1:M,1:N);
figure;
subplot(1,2,1),imshow(I,[]),title('原图');
subplot(1,2,2),imshow(I2,[]),title('结果');
imwrite(I2,'.\333.bmp');
