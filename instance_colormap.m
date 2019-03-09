function colormap = instance_colormap()
if(exist('instance_colormap.mat', 'file'))
    load('instance_colormap.mat')
else
    colormap2 = [];
    step = 0.1;
    for i=0.1:step:0.9
        for j=0.1:step:0.9
            for k=0.1:step:0.9
                colormap2 = [colormap2; [i j k]];
            end
        end
    end
    colormap2 = colormap2(2:end-1,:);
    idx = randperm(size(colormap2,1));
    colormap2 = colormap2(idx,:);
    
%     colormap1 = [];
%     step = 1;
%     for i=0:step:1
%         for j=0:step:1
%             for k=0:step:1
%                 colormap1 = [colormap1; [i j k]];
%             end
%         end
%     end
%     colormap1 = colormap1(2:end-1,:);
%     idx = randperm(size(colormap1,1));
%     colormap1 = colormap1(idx,:);

colormap1 = [...
    1              1         0
    1              0         0
    0              0         1
    0              0.5       0
    1              0         1
    0.5            0         0
    0.5            0         0.5
    0              0.5       0.5
    0              0.7         0.7
    0              1         0
    0              0         0.6
    0.5            0.5       0];
    
    colormap = [[0 0 0]; colormap1; colormap2];
    save('instance_colormap.mat', 'colormap');
end
end