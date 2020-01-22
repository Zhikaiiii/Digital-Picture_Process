%图片6 卡通效果
I_source = imread('./pic/my_image.jpg');
I_target = imread('./pic/targetImage6.jpg');
imshow(I_target);
[M,N,~] = size(I_target);
[M1,N1,~] = size(I_source);
mask = ones(M,N);
I_cartoon = cartoon_paint_image(I_source,10,3);
imshow(I_cartoon);
%目标图像的左上、右上、左下、右下四个点
y_target = [333;966;969;333];
x_target = [303;309;1142;1134];
x_source = [1,M1];
y_source = [1,N1];
image_Out = perspective_transformation(I_cartoon,I_target,mask,x_target,y_target,x_source,y_source);
figure;
imshow(image_Out);