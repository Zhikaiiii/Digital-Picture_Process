tic;
%得到角点坐标
[corner_point,video_obj] = corner_track();
%读取要替换的封面
new_cover = imread('new_cover.jpg');
new_cover_hsv = rgb2hsv(new_cover);
new_cover_hsv(:,:,3) = new_cover_hsv(:,:,3).^1.5;
new_cover = hsv2rgb(new_cover_hsv);
new_cover = im2uint8(new_cover);
%视频处理
video_procecss(video_obj,1,new_cover,corner_point);
toc;






