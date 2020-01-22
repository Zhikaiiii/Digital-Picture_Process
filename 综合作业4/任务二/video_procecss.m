function video_procecss(video_obj,flag,new_cover,corner_point)
    video_write = VideoWriter('temp3.avi','Motion JPEG AVI');
    open(video_write)
    [M1,N1,~] = size(new_cover);
    xs1 = [1 N1 N1 1]';
    ys1 = [1 1 M1 M1]';
    for k = 1:408
        frame_now = read(video_obj,k);
        corner_pointk = round(corner_point(1:2,:,k));
        if flag == 0  %��ʾ�ǵ���ȡ�Ľ��
            pic_name = ['��',num2str(k),'֡�ǵ���ȡ'];
            imshow(frame_now),title(pic_name);
            for i = 1:4
                if i == 4
                    line([corner_point(1,1,k),corner_point(1,4,k)],[corner_point(2,1,k),corner_point(2,4,k)],'Color','r','LineWidth',2);
                else
                    line(corner_point(1,i:i+1,k),corner_point(2,i:i+1,k),'Color','r','LineWidth',2);
                end
            end
            drawnow
            f = getframe(gcf);
            f.cdata = imresize(f.cdata,[834 1464]);
            writeVideo(video_write,f);
        else %�滻����
        k
        if k>260 && k<344
            %����ͼƬ�ߴ��Լӿ�����ٶ�
            frame_new = imresize(frame_now,1/3);
            [L,N] = superpixels(frame_new,1800,'NumIterations',20);
%             BW = boundarymask(L);
%             imshow(imoverlay(frame_new,BW,'cyan'),'InitialMagnification',67)
            %���ݷָ�����ÿ���ֵ
            average_image = zeros(size(frame_new),'like',frame_new);
            idx = label2idx(L);
            numRows = size(frame_new,1);
            numCols = size(frame_new,2);
            for labelVal = 1:N
                redIdx = idx{labelVal};
                greenIdx = idx{labelVal}+numRows*numCols;
                blueIdx = idx{labelVal}+2*numRows*numCols;
                average_image(redIdx) = mean(frame_new(redIdx));
                average_image(greenIdx) = mean(frame_new(greenIdx));
                average_image(blueIdx) = mean(frame_new(blueIdx));
            end
            %����RGB����ѡȡǰ���ͱ�����
            forepoint = find(abs(average_image(:,:,1)-109)<12 & ...
            abs(average_image(:,:,2)-95)<12 & abs(average_image(:,:,3)-88)<12);
            backpoint = find(abs(average_image(:,:,1)-102)<4 & ...
            abs(average_image(:,:,2)-185)<4 & abs(average_image(:,:,3)-214)<4);
            backpoint = [backpoint;find(abs(average_image(:,:,1)-36)<5 &... 
            abs(average_image(:,:,2)-70)<5 & abs(average_image(:,:,3)-75)<5)];
            backpoint = [backpoint;find(abs(average_image(:,:,1)-85)<5 &...
            abs(average_image(:,:,2)-61)<5 & abs(average_image(:,:,3)-62)<5)];
            %lazysnapping��ͼ�ָ��ֺͷ���
            BW = lazysnapping(frame_new,L,forepoint,backpoint);
            BW = imresize(BW,[1080 1920]);
            BW = ~BW;
        else
            BW = ones(1080,1920);
        end
        %����任
        %��任����
        tform = fitgeotrans([xs1 ys1],[corner_pointk(1,:)' corner_pointk(2,:)'],'projective');
        %�����任���ͼƬ
        cover_registered = imwarp(new_cover,tform,'OutputView',imref2d(size(frame_now)));
        %�����Ҫ�滻��mask
        BW2 = sum(cover_registered,3)~=0;
        if k>260 && k<344
            mask_final = ~BW&BW2;
        %����ͨ����ȥ��ɢ�� �õ�ֻ���ֵ�mask
            CC = bwconncomp(mask_final);
            numPixels = cellfun(@numel,CC.PixelIdxList);
            mask_final2 = false(size(mask_final));
            [~,num] = size(numPixels);
            for i = 1:num
                if numPixels(i)>1000
                    mask_final2(CC.PixelIdxList{i}) =1;
                end
            end
            [~,idx] = max(numPixels);
            mask_final2(CC.PixelIdxList{idx}) =1;
            mask_final = BW2&~mask_final2;
        else
            mask_final = BW2;
        end
        %�õ���Ҫ�滻��mask
        idx = find(mask_final) ;
        %ͼƬ�滻
        image_out = frame_now;
        image_out(idx) = cover_registered(idx);
        image_out(idx+1080*1920) = cover_registered(idx+1080*1920);
        image_out(idx+2*1080*1920) = cover_registered(idx+2*1080*1920);
%         figure;
%         imshow(image_out);
%         maskedImage = frame_now;
%         maskedImage(repmat(~mask_final,[1 1 3])) = 0;
%         figure;
%         imshow(maskedImage);
        writeVideo(video_write,image_out);
        end
    end
    close(video_write);
end