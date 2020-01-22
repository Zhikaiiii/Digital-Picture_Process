function I_trim = fingerprint_trim(I_thin,length)
%修剪算法
    I_temp = I_thin;
    %结构元素                
    B = {[0 -1 -1;1 1 -1;0 -1 -1],[-1 -1 -1;-1 1 -1;0 1 0],[-1 -1 0;-1 1 1;-1 -1 0],[0 1 0;-1 1 -1;-1 -1 -1],...
         [1 -1 -1;-1 1 -1;-1 -1 -1],[-1 -1 -1;-1 1 -1;1 -1 -1],[-1 -1 -1;-1 1 -1;-1 -1 1],[-1 -1 1;-1 1 -1;-1 -1 -1]};
     %做L次细化
    for j = 1:length
        for i = 1:8
            I_temp = I_temp- bwhitmiss(I_temp, B{i});
        end
    end
    %求出端点集合
    I_temp2 = bwhitmiss(I_temp, B{1});
    for i = 1:length
        I_temp2 = I_temp2 | bwhitmiss(I_temp, B{i});
    end
    %作膨胀
    H = strel([1 1 1;1 1 1;1 1 1]);
    I_temp3 = imdilate(I_temp2,H) & I_thin;
    for j = 1:length-1
        I_temp3 = imdilate(I_temp3,H) & I_thin;
    end
    I_trim = I_temp3 | I_temp;
end