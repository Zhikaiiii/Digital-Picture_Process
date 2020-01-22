function [orientation_new, wavelengths_new, I1] = local_DFT(I)
%对图像分块DFT
    [M,N] = size(I);
    a = 8 - mod(M,8);
    b = 8 - mod(N,8);
    I1 = padarray(I,[a b],'replicate', 'post');
    %对图像周围补零
    I2 = padarray(I1,[12 12],'replicate','both');
    F = zeros(M+a,N+b);
    %方向图
    orientation = zeros((M+a)/8,(N+b)/8);
    %频率图
    frequency = zeros((M+a)/8,(N+b)/8);
    pic = zeros(M+a,N+b);    
    %背景阈值
    threshold = 1.5;
    for i = 1:(M+a)/8
        for j = 1:(N+b)/8
            pic(8*i-6:8*i-1,8*j-4) = 1;
            temp_F = fftshift(fft2(I2(8*i-7:8*i+24,8*j-7:8*j+24)));
            temp_FF=log(1+abs(temp_F));
%             [max_freq, index] = max(temp_FF(:));
%             [y1, x1] = ind2sub([32,32],index);
            average = mean2(temp_FF(13:20,13:20));
            std = std2(I1(8*i-7:8*i,8*j-7:8*j));
            if average > threshold && std >0.035
               %mask(i:i+7,j:j+7)= 0;
               dc_freq = temp_FF(17,17);
               %计算方向图 需要将直流分量置0
               temp_FF(17,17) = 0;
               [orientation_local, frequency_local] = cal_local(temp_FF);
%                orientation(i:i+7,j:j+7) = orientation_local;
%                frequency(i:i+7,j:j+7) = frequency_local;
               orientation(i,j) = orientation_local;
               frequency(i,j) = frequency_local;
               temp_FF(17,17) = dc_freq;
               F(8*i-7:8*i,8*j-7:8*j) = temp_FF(13:20,13:20);
               pic(8*i-7:8*i,8*j-7:8*j) = imrotate(pic(8*i-7:8*i,8*j-7:8*j),-orientation_local*180/pi,'nearest','crop');
               %计算频率图

            else
%                mask(i:i+7,j:j+7)= 1;
               I1(8*i-7:8*i,8*j-7:8*j) = 0;
            end 
        end
    end
    F1 = log(1+abs(F));
    figure;
    imshow(F1,[]);
    figure;
    I3 = I1+pic;
    imshow(I3);
%     for i = 1:8:M
%         for j =1:8:N
%             average = mean2(F1(i:i+7,j:j+7));
%             std = std2(I1(i:i+7,j:j+7));
%             if average > threshold && std >0.035
%                mask(i:i+7,j:j+7)= 0;
%             else
%                mask(i:i+7,j:j+7)= 1;
%             end 
%         end
%     end
%     F2 = mask .* F;
%     mask = logical(mask);
%     I1(mask) = 0;
%     I1 = I1+pic;
    figure;
    subplot(1,2,1),imshow(I,[]);
    subplot(1,2,2),imshow(I1,[]);
%     figure;
%     quiver(cos(orientation(1:8:end,1:8:end)), sin( orientation(1:8:end,1:8:end)));
    %平滑方向图
    orientation_double = 2*orientation;
    orientation_cos = cos(orientation_double);
    orientation_sin = sin(orientation_double); 
    w = fspecial('gaussian',[3,3],0.5);
    w2 = fspecial('gaussian',[3,3],0.2);
    orientation_cos = imfilter(orientation_cos,fspecial('gaussian',5));
    orientation_sin = imfilter(orientation_sin,fspecial('gaussian',5));    
%     orientation_temp=cos(orientation_double)+1i*sin(orientation_double);
% %     orientation_temp = imfilter(orientation_temp,fspecial('gaussian',5));
%     figure;
% %     orientation_new = 0.5*angle(orientation_temp);
%     quiver(cos(orientation_new),sin(orientation_new));

%     axis([0 blkwt 0 blkht]); 
    orientation_new = 0.5*atan2(orientation_sin,orientation_cos);
    figure;
    subplot(1,2,1),quiver(cos(orientation+pi/2), sin(orientation+pi/2));
    axis ij;
    subplot(1,2,2),quiver(cos(orientation_new+pi/2), sin(orientation_new+pi/2));
    axis ij;
    %平滑频率图
    frequency_new = imfilter(frequency,w);

    wavelengths_new =1./(frequency_new+eps);
end


