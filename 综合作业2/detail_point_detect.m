function detail_point = detail_point_detect(input_image,mask)
%细节点检测
    [M,N] = size(input_image);
    input_image = double(input_image);
    detail_point = zeros(M,N);
    for i=2:M-1
        for j = 2:N-1
           %计算cn(p)
           sum_neighborhood = abs(input_image(i-1,j)-input_image(i-1,j-1)) + abs(input_image(i-1,j+1)-input_image(i-1,j))...
               + abs(input_image(i,j+1)-input_image(i-1,j+1)) + abs(input_image(i+1,j+1)-input_image(i,j+1))...
               + abs(input_image(i+1,j)-input_image(i+1,j+1)) + abs(input_image(i+1,j-1)-input_image(i+1,j))...
               + abs(input_image(i,j-1)-input_image(i+1,j-1)) + abs(input_image(i-1,j-1)-input_image(i,j-1));
           sum_neighborhood = sum_neighborhood/2;
           if sum_neighborhood == 1 %端点
               if mask(i,j) == 1 && input_image(i,j) == 1
                    detail_point(i,j) = 1;
               end
           elseif sum_neighborhood == 3 %分叉点
               if mask(i,j) == 1 && input_image(i,j) == 1
                    detail_point(i,j) = -1;
               end
           else
               detail_point(i,j) = 0;
           end
        end
    end
end

