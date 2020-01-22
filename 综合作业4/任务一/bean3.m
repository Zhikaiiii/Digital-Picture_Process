%图片3 扭曲效果
I_source = imread('./pic/sourceImage.jpg');
I_target = imread('./pic/targetImage3.jpg');
mask = imread('./pic/targetImagemask3.png');
imshow(I_source);
I_distort = distort_image(I_source,10,120);
imshow(I_distort);
%目标图像的左上、右上、左下、右下四个点
y_target = [351;570;604;396];
x_target = [117;87;541;651];
x_source = [32,1197];
y_source = [473,1403];
image_Out = perspective_transformation(I_distort,I_target,mask,x_target,y_target,x_source,y_source);
figure;
imshow(image_Out);