function image_out = cartoon_paint_image(image_in, smooth_degree, sigma)
%ʵ�ֿ�ͨЧ��
% --------------------------
% input
% image_in:����ͼ��
% smooth_degree: ƽ���̶�
% sigma: ��˹����˵ķ���
% --------------------------
% output
% image_out:�任Ч��

    %����˫���˲�
    image_lab = rgb2lab(image_in);
    for i = 1:20
        image_lab = imbilatfilt(image_lab, smooth_degree,sigma);
    end
    image_rgb = lab2rgb(image_lab);
    image_gray = rgb2gray(image_in);
    image_rgb = im2uint8(image_rgb);
    %��ȡ��Ե
    edge_mask = uint8(edge(image_gray, 'canny', 0.3, 3));
    image_out(:,:,1) = image_rgb(:,:,1) - image_rgb(:,:,1) .* edge_mask;
    image_out(:,:,2) = image_rgb(:,:,2) - image_rgb(:,:,2) .* edge_mask;
    image_out(:,:,3) = image_rgb(:,:,3) - image_rgb(:,:,3) .* edge_mask;
    %����ͼ�񱥺Ͷ�
    image_out = rgb2hsv(image_out);
    image_out(:,:,2) = 1.5*image_out(:,:,2);
    image_out(image_out>1) = 1;
    image_out = hsv2rgb(image_out);
    image_out = im2uint8(image_out);
end