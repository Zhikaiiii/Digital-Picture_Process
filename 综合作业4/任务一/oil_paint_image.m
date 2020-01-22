function image_out = oil_paint_image(image_in,k)
%利用超像素分割实现油画效果
% --------------------------
% input
% image_in:输入图像
% k: 超像素个数
% --------------------------
% output
% image_out:油画变换效果

    [L,N] = superpixels(image_in,k);
    idx = label2idx(L);
    [rows, cols, ~ ] = size(image_in);
    image_out = zeros(rows,cols,3);
    %求每块均值
    for labelVal = 1:N
        redIdx = idx{labelVal};
        greenIdx = idx{labelVal}+rows*cols;
        blueIdx = idx{labelVal}+2*rows*cols;
        image_out(redIdx) = mean(image_in(redIdx));
        image_out(greenIdx) = mean(image_in(greenIdx));
        image_out(blueIdx) = mean(image_in(blueIdx));
    end
end

