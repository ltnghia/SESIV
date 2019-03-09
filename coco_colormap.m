function colormap = coco_colormap()
if(exist('coco_colormap.mat', 'file'))
    load('coco_colormap.mat')
else
    colormap = [];
    colormap = pascal_colormap();
    %colormap = colormap(2:257, :);
    idx = randperm(size(colormap,1));
    colormap = colormap(idx,:);
    colormap = colormap(1:255,:);
    colormap = [[0 0 0; colormap]];
    save('coco_colormap.mat', 'colormap');
end
end