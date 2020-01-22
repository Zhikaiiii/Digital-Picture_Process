%图片1 油画效果
I_source = imread('./pic/sourceImage.jpg');
I_target = imread('./pic/targetImage1.jpg');
mask = imread('./pic/targetImagemask1.png');
I_oilpaint = oil_paint_image(I_source,4000);
%目标图像的左上、右上、左下、右下四个点
y_target = [183;667;667;183];
x_target = [180;180;794;794];
x_source = [32,1197];
y_source = [493,1453];
image_Out = perspective_transformation(I_oilpaint,I_target,mask,x_target,y_target,x_source,y_source);
figure;
imshow(image_Out);