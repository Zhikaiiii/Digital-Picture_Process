tic;
%�õ��ǵ�����
[corner_point,video_obj] = corner_track();
%��ȡҪ�滻�ķ���
new_cover = imread('new_cover.jpg');
new_cover_hsv = rgb2hsv(new_cover);
new_cover_hsv(:,:,3) = new_cover_hsv(:,:,3).^1.5;
new_cover = hsv2rgb(new_cover_hsv);
new_cover = im2uint8(new_cover);
%��Ƶ����
video_procecss(video_obj,1,new_cover,corner_point);
toc;






