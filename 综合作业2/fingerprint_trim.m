function I_trim = fingerprint_trim(I_thin,length)
%�޼��㷨
    I_temp = I_thin;
    %�ṹԪ��                
    B = {[0 -1 -1;1 1 -1;0 -1 -1],[-1 -1 -1;-1 1 -1;0 1 0],[-1 -1 0;-1 1 1;-1 -1 0],[0 1 0;-1 1 -1;-1 -1 -1],...
         [1 -1 -1;-1 1 -1;-1 -1 -1],[-1 -1 -1;-1 1 -1;1 -1 -1],[-1 -1 -1;-1 1 -1;-1 -1 1],[-1 -1 1;-1 1 -1;-1 -1 -1]};
     %��L��ϸ��
    for j = 1:length
        for i = 1:8
            I_temp = I_temp- bwhitmiss(I_temp, B{i});
        end
    end
    %����˵㼯��
    I_temp2 = bwhitmiss(I_temp, B{1});
    for i = 1:length
        I_temp2 = I_temp2 | bwhitmiss(I_temp, B{i});
    end
    %������
    H = strel([1 1 1;1 1 1;1 1 1]);
    I_temp3 = imdilate(I_temp2,H) & I_thin;
    for j = 1:length-1
        I_temp3 = imdilate(I_temp3,H) & I_thin;
    end
    I_trim = I_temp3 | I_temp;
end