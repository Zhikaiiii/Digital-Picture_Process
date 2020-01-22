function image_out = distort_image(image_in,amplitude,cycle)
%ʵ��Ť��Ч��
% --------------------------
% input
% image_in:����ͼ��
% amplitude:����
% cycle:����
% --------------------------
% output
% image_out:�任Ч��
    
% ��������ȡ��Ӧ�任������겢��ֵ
% Ť��ͼƬ
    [M,N,D] = size(image_in);
    image_in = im2double(image_in);
    image_out = zeros(M,N,D);
    for y=1:M
        for x=1:N
            %����任�������
            y_new=round(y-(amplitude*cos(2*pi/cycle*x)));
            x_new=round(x-(amplitude*cos(2*pi/cycle*y)));
           if y_new>=1 && y_new<=M && x_new>=1 && x_new<=N
               for k = 1:D
                    image_out(y,x,k)=image_in(y_new,x_new,k);
               end
           end
        end
    end
    image_out = im2uint8(image_out);
end