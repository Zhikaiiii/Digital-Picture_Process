%图片5 素描效果
I_source = imread('./pic/my_image.jpg');
I_target = imread('./pic/targetImage5.jpg');
mask = imread('./pic/targetImagemask5.png');
[M,N,~] = size(I_source);
imshow(I_target);
I_sketch = sketch_paint_image(I_source);
imshow(I_sketch);
%目标图像的左上、右上、左下、右下四个点
y_target = [230;1001;1013;236];
x_target = [538;550;1317;1314];
x_source = [1,M];
y_source = [1,N];
image_Out = perspective_transformation(I_sketch,I_target,mask,x_target,y_target,x_source,y_source);
figure;
imshow(image_Out);