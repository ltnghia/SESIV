function exportMatchIOU(dir_img0, dir_gt0, dir_output0)

videos = dir(dir_img0);
colormap=instance_colormap();

for k=3:length(videos)
    video = videos(k).name;
    %disp(video);

    %dir_img = [dir_img0 '/' video '/'];
    dir_img = [dir_img0 '/' video '/ins/'];
    dir_gt = [dir_gt0 '/' video];
    dir_output = [dir_output0 '/' video];

    if(~exist(dir_output, 'dir'))
        mkdir(dir_output);
    end

    files = dir([dir_gt '/*.png']);
    im = [];
    gt = [];
    for i=1:length(files)
        file = files(i).name;
        im = cat(3, im, imread([dir_img '/' file]));
        gt = cat(3, gt, imread([dir_gt '/' file]));
    end

    new_ins = matchIOU(im, gt);
    for i=1:length(files)
        file = files(i).name;
        imwrite(new_ins(:,:,i), colormap(1:256,:), [dir_output '/' file]);
    end

end

end