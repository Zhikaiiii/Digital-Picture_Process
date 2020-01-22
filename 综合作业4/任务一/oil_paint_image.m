function image_out = oil_paint_image(image_in,k)
%���ó����طָ�ʵ���ͻ�Ч��
% --------------------------
% input
% image_in:����ͼ��
% k: �����ظ���
% --------------------------
% output
% image_out:�ͻ��任Ч��

    [L,N] = superpixels(image_in,k);
    idx = label2idx(L);
    [rows, cols, ~ ] = size(image_in);
    image_out = zeros(rows,cols,3);
    %��ÿ���ֵ
    for labelVal = 1:N
        redIdx = idx{labelVal};
        greenIdx = idx{labelVal}+rows*cols;
        blueIdx = idx{labelVal}+2*rows*cols;
        image_out(redIdx) = mean(image_in(redIdx));
        image_out(greenIdx) = mean(image_in(greenIdx));
        image_out(blueIdx) = mean(image_in(blueIdx));
    end
end

