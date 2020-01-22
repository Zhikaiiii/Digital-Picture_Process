function image_out =TV_image(image_in)
%实现电视噪声效果
% --------------------------
% input
% image_in:输入图像
% --------------------------
% output
% image_out:变换效果
    
%利用hsv空间的亮度维度作变换实现噪音效果
    image_wall = imread('./pic/TV.jpg');
    [M,N,~] = size(image_in);
    image_wall = imresize(image_wall,[M,N]);
    image_wall_hsv = rgb2hsv(image_wall);
    image_hsv = rgb2hsv(image_in);
    image_hsv(:,:,3) = 0.7*image_hsv(:,:,3).*image_wall_hsv(:,:,3);
    image_out = hsv2rgb(image_hsv);
    image_out = im2uint8(image_out);
end
