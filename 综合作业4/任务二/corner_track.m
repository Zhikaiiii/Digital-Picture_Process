function [corner_point,video_obj] = corner_track()
% 根据第一帧的标记角点逐帧求取角点对应坐标
% -----------------
% output
% corner_point: 角点坐标
    video_obj = VideoReader('targetVideo.MP4');
    %视频的长宽
    height = video_obj.Height;
    width = video_obj.Width;
    frame_num = video_obj.NumberOfFrames;
    %读取第一帧
    frame1 = read(video_obj,1);
    frame1_gray = rgb2gray(frame1);
    corner_point = zeros(3,4,frame_num);
    %第一帧角点
    corner_point(:,:,1) = [60,150,1;671,105,1;783,804,1;77 897,1]';
    %第一帧特征点提取
    p1 = detectSURFFeatures(frame1_gray);
    p1 = selectStrongest(p1,400);
    point1 = p1.Location;
    [f1, point1] = extractFeatures(frame1_gray, point1);
    for i = 2:frame_num
        frame2 = read(video_obj,i);
        frame2_gray = rgb2gray(frame2);
        % SURF提取特征点
        p2 = detectSURFFeatures(frame2_gray);
        p2 = selectStrongest(p2,400);
        point2 = p2.Location;
        %计算特征
        [f2, point2] = extractFeatures(frame2_gray, point2);
        %匹配特征点
        pair = matchFeatures(f1, f2);
        match1 = point1(pair(:,1),:);
        match2 = point2(pair(:,2),:);
        %求变换矩阵
        hh = estimateGeometricTransform(match1,match2,'projective');
        TT = hh.T';
        %求新一帧的角点
        corner_point2 = TT*corner_point(:,:,i-1);
        corner_point(1,:,i)= corner_point2(1,:)./corner_point2(3,:);
        corner_point(2,:,i)= corner_point2(2,:)./corner_point2(3,:);
        corner_point(3,:,i)= 1;
        %为下一次迭代作准备
        point1 = point2;
        f1 = f2;
    end
end