function image_out = sketch_paint_image(image_in)
%实现素描效果
% --------------------------
% input 
% image_in:输入图像
% --------------------------
% input 
% image_in:输入图像
% --------------------------
% output 
% image_out:输出素描图像

    image_in = im2double(image_in);
    sx = fspecial('sobel');
    sy = sx';
    Rx = imfilter(image_in(:,:,1), sx, 'replicate');
    Ry = imfilter(image_in(:,:,1), sy, 'replicate');
    Gx = imfilter(image_in(:,:,2), sx, 'replicate');
    Gy = imfilter(image_in(:,:,2), sy, 'replicate');
    Bx = imfilter(image_in(:,:,3), sx, 'replicate');
    By = imfilter(image_in(:,:,3), sy, 'replicate');
    %求出三个通道的梯度幅度谱
    RG = sqrt(Rx.^2 + Ry.^2);
    GG = sqrt(Gx.^2 + Gy.^2);
    BG = sqrt(Bx.^2 + By.^2);
    %将梯度图转化为三通道RGB图像
    image_out = mat2gray(RG + GG + BG);
    image_out = im2uint8(image_out);
    image_out = 255 - image_out;
    image_out = repmat(image_out, [1,1,3]);
    image_out = rgb2hsv(image_out);
    %伽马校正降低亮度
    image_out(:,:,3) = image_out(:,:,3).^3;
    image_out = hsv2rgb(image_out);
    image_out = im2uint8(image_out);
end