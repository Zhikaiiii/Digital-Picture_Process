function image_out = wall_paint_image(image_in)
%实现墙体效果
% --------------------------
% input
% image_in:输入图像
% --------------------------
% output
% image_out:变换效果
    
%利用hsv空间的亮度维度作变换实现墙体效果
    image_wall = imread('./pic/wall.jpg');
    [M,N,~] = size(image_in);
    image_wall = imresize(image_wall,[M,N]);
    image_wall_hsv = rgb2hsv(image_wall);
    image_hsv = rgb2hsv(image_in);
    %亮度通道相乘
    image_hsv(:,:,3) = image_hsv(:,:,3).*image_wall_hsv(:,:,3) + 0.1;
    image_out = hsv2rgb(image_hsv);
    image_out = im2uint8(image_out);
end
