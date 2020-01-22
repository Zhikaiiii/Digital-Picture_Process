function image_out = perspective_transformation(image_source, image_target, mask, x_target, y_target, x_source, y_source)
%����ͶӰ�任����ͼƬ
% -----------------
% input
%image_source ԴͼƬ
%image_target Ŀ��ͼƬ
%mask ΪĿ��ͼ������Ҫȥ���Ĳ���
%x_target y_target Ŀ��ͼƬ�ϵ������  ˳��Ϊ���ϡ����ϡ����¡�����
%x_source y_source ԴͼƬ�ϵ������ ��Ҫ��Ϊ���޶���Χ
% -----------------
% output
% image_out ���ͼ����

image_out = image_target;
%
out_height = x_source(2)-x_source(1)+1;
out_width = y_source(2)-y_source(1)+1;

pointLT = [x_target(1),y_target(1)];
pointRT = [x_target(2),y_target(2)];
pointRB = [x_target(3),y_target(3)];
pointLB = [x_target(4),y_target(4)];

%Ŀ��ƽ��Ļ����� 
%xΪ���µķ���yΪ���ҵķ���
vector_x = pointLB - pointLT;
vector_y = pointRT - pointLT;
vector_s = pointRB - pointLT;
basis = [vector_x',vector_y'];
%�û�������ʾ����������
s_cord = basis \ vector_s';
s_cordx = s_cord(1);
s_cordy = s_cord(2);
for x = min(x_target):max(x_target)
    for y = min(y_target):max(y_target)
        %���������Ĳ���жϵ��Ƿ�λ��ѡ��������
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
            %�ж��Ƿ�λ��������
            if x1*y2-y1*x2<0
                flag = 1;
                break;
            end
        end
        if flag == 0
            vector_p = [x - x_target(1), y- y_target(1)];
            %���õ��Ӧ�����û�������ʾ
            p_cord = basis \ vector_p';
            p_cordx = p_cord(1);
            p_cordy = p_cord(2);
            dim = s_cordx*s_cordy+s_cordy*(s_cordy-1)*p_cordx+s_cordx*(s_cordx-1)*p_cordy;  %��ĸ
            %ͶӰ���������ʾ
            new_x = s_cordy*(s_cordy+s_cordx-1)*p_cordx/dim;
            new_y = s_cordx*(s_cordy+s_cordx-1)*p_cordy/dim;
            %���ݵõ��Ĳ����ҵ���Ӧ��Դͼ���е�����λ�ã�����ֵ
            source_cordx = x_source(1) + round(new_x*(out_height-1));
            source_cordy = y_source(1) + round(new_y*(out_width-1));
            for i = 1:3
                if mask(x,y) == 1
                %ʹ����������ֵ��ʹ�ø߼���ֵ����Ч�������
                    image_out(x,y,i) = image_source(source_cordx,source_cordy,i);
                end
            end
        end
    end
end
