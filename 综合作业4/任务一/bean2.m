%图片2 墙体效果
I_source = imread('./pic/sourceImage.jpg');
I_target = imread('./pic/targetImage2.jpg');
imshow(I_source);
mask = imread('./pic/targetImagemask2.png');
I_wall = wall_paint_image(I_source);
imshow(I_wall);
%目标图像的左上、右上、左下、右下四个点
y_target = [42;541;593;14];
x_target = [47;48;413;370];
x_source = [1,1200];
y_source = [1,1920];
[M,N,~] = size(I_source);
image_Out = perspective_transformation(I_wall,I_target,mask,x_target,y_target,x_source,y_source);
figure;
imshow(image_Out);
