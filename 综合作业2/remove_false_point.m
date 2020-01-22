function [I_remove, detail_point] = remove_false_point(I, origin_point)
%去除桥接、断裂等假分叉点
idx = find(origin_point);
detail_point = origin_point;
%sobel算子
sy = [1 2 1;0 0 0 ;-1 -2 -1];
sx = [-1 0 1;-2 0 2;-1 0 1];
[length,~] = size(idx);
I_remove = double(I);
for k=1:length
    %取出每个点的11x11邻域
    [i,j] = ind2sub(size(I),idx(k));
    neighborhood = I_remove(i-5:i+5,j-5:j+5);
    neighborhood2 = detail_point(i-5:i+5,j-5:j+5);
    idx2 = find(neighborhood2);
    [num,~] = size(idx2);
    for l = 1:num
        if neighborhood2(idx2(l)) == neighborhood2(6,6)  && idx2(l)~=61
            [m,n] = ind2sub([11,11],idx2(l));
            gx = imfilter(neighborhood, sx);
            gy = imfilter(neighborhood, sy);
            %计算方向
            orientation = atan2(gy,gx) - pi/2;
            indx = find(orientation>pi/2);
            indx2 = find(orientation<-pi/2);
            orientation(indx) = orientation(indx) - pi;
            orientation(indx2) = orientation(indx2) + pi;            
            %为端点
            if neighborhood2(6,6) == 1
                detail_point(i,j) = 0;
                detail_point(i-(6-m),j-(6-n)) = 0;
                x1 = min(j,j-(6-n));
                x2 = max(j,j-(6-n));
                y1 = min(i,i-(6-m));
                y2 = max(i,i-(6-m));
                se = strel('line',6,-orientation(6,6)*180/pi);
                I_remove(y1:y2,x1:x2) = imdilate(I_remove(y1:y2,x1:x2),se);
            %为分叉点
            elseif neighborhood2(6,6) == -1 
                detail_point(i,j) = 0;
                x1 = min(j,j-(6-n));
                x2 = max(j,j-(6-n));
                y1 = min(i,i-(6-m));
                y2 = max(i,i-(6-m));
                %去除两个交叉点之间的像素
                I_remove(y1:y2,x1:x2) = 0;
                I_remove(i,j) = 1;
                I_remove(i-(6-m),j-(6-n)) = 1;
                if(x2 - x1 >0 && y2-y1 > 0)
                    detail_point(i-(6-m),j-(6-n)) = 0;
                end

            end
        end
    end
end
%I_remove = I;
end

