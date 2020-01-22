function image_out = perspective_transformation(image_source, image_target, mask, x_target, y_target, x_source, y_source)
%利用投影变换处理图片
% -----------------
% input
%image_source 源图片
%image_target 目标图片
%mask 为目标图像中需要去除的部分
%x_target y_target 目标图片上的坐标点  顺序为左上、右上、右下、左下
%x_source y_source 源图片上的坐标点 主要是为了限定范围
% -----------------
% output
% image_out 输出图像结果

image_out = image_target;
%
out_height = x_source(2)-x_source(1)+1;
out_width = y_source(2)-y_source(1)+1;

pointLT = [x_target(1),y_target(1)];
pointRT = [x_target(2),y_target(2)];
pointRB = [x_target(3),y_target(3)];
pointLB = [x_target(4),y_target(4)];

%目标平面的基向量 
%x为向下的方向、y为向右的方向
vector_x = pointLB - pointLT;
vector_y = pointRT - pointLT;
vector_s = pointRB - pointLT;
basis = [vector_x',vector_y'];
%用基向量表示第三个向量
s_cord = basis \ vector_s';
s_cordx = s_cord(1);
s_cordy = s_cord(2);
for x = min(x_target):max(x_target)
    for y = min(y_target):max(y_target)
        %利用向量的叉乘判断点是否位于选中区域内
        flag = 0;
        for i = 1:4
            x1 = x - x_target(i);
            y1 = y - y_target(i);
            if i==4
                x2 = x_target(1)-x_target(4);
                y2 = y_target(1)-y_target(4);
            else
                x2 = x_target(i+1)-x_target(i);
                y2 = y_target(i+1)-y_target(i);
            end
            %判断是否位于区域内
            if x1*y2-y1*x2<0
                flag = 1;
                break;
            end
        end
        if flag == 0
            vector_p = [x - x_target(1), y- y_target(1)];
            %将该点对应向量用基向量表示
            p_cord = basis \ vector_p';
            p_cordx = p_cord(1);
            p_cordy = p_cord(2);
            dim = s_cordx*s_cordy+s_cordy*(s_cordy-1)*p_cordx+s_cordx*(s_cordx-1)*p_cordy;  %分母
            %投影后的向量表示
            new_x = s_cordy*(s_cordy+s_cordx-1)*p_cordx/dim;
            new_y = s_cordx*(s_cordy+s_cordx-1)*p_cordy/dim;
            %根据得到的参数找到对应的源图像中的坐标位置，并赋值
            source_cordx = x_source(1) + round(new_x*(out_height-1));
            source_cordy = y_source(1) + round(new_y*(out_width-1));
            for i = 1:3
                if mask(x,y) == 1
                %使用最近邻域插值，使用高级插值方法效果会更好
                    image_out(x,y,i) = image_source(source_cordx,source_cordy,i);
                end
            end
        end
    end
end
