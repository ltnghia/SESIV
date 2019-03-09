function png2gif(dir_input, dir_output, colormap)

files = [dir([dir_input '/*.jpg']), dir([dir_input '/*.png'])];
for i=1:length(files)
    im = imread([dir_input '/' files(i).name]);
    im = imresize(im, 0.5, 'nearest');
    if(nargin<3)
        if (size(im,3) == 1)
            im = uint8(cat(3, im, im, im)) * 255;
        end
        [im,colormap] = rgb2ind(im,256); 
    end
    if(i==1)
        imwrite(im,colormap,dir_output,'gif', 'Loopcount',inf, 'DelayTime', 0.05); 
    else
        imwrite(im,colormap,dir_output,'gif','WriteMode','append', 'DelayTime', 0.05); 
    end
end

% , 'Compression','rle'

end