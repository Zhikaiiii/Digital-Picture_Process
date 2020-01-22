% 图片4 电视噪声效果
I_source = imread('./pic/my_image.jpg');
I_target = imread('./pic/targetImage4.jpg');
I_TV = TV_image(I_source);
imshow(I_TV);
[M,N,~] = size(I_target);
mask = ones(M,N);
[M1,N1,~] = size(I_source);
%目标图像的左上、右上、左下、右下四个点
y_target = [489;952;954;485];
x_target = [414;424;765;754];
x_source = [88,784];
y_source = [1,N1];
image_Out = perspective_transformation(I_TV,I_target,mask,x_target,y_target,x_source,y_source);
figure;
imshow(image_Out);