I = imread('./data/3.jpg');
tic;
num = 1000;
%�Լ��ĳ����طָ���
[L,N] = SLIC_superpixels(I,num);
toc;
figure;
BW = boundarymask(L);
imshow(imoverlay(I,BW,'cyan'),'InitialMagnification',67)
[L1,N1] = superpixels(I,num); % ����matlab�Դ�
%��ʾ�߽�ͼ
figure;
BW1 = boundarymask(L1);
imshow(imoverlay(I,BW1,'cyan'),'InitialMagnification',67)
