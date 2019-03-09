function new_ins = matchIOU(ins, gt0, frame_idx)

if(nargin < 3)
    frame_idx = 1;
end

%disp(frame_idx);

new_ins = ins;

im = ins(:,:,frame_idx);
gt = gt0(:,:,frame_idx);

ins_im = unique(im);
ins_gt = unique(gt);

ins_im(ins_im==0) = [];
ins_gt(ins_gt==0) = [];

ins_im0 = unique(ins);
ins_im0(ins_im0==0) = [];

new_ins_im = zeros(size(ins_im0));

if(isempty(ins_im))
    if(frame_idx < size(gt0,3))
        frame_idx = frame_idx + 1;
        new_ins = matchIOU(ins, gt0, frame_idx);
    end
    return
end

ht = length(ins_im);
wd = length(ins_gt);

iou_score = zeros(ht, wd);
for i=1:ht
    for j=1:wd
        iou_score(i,j) = iou(im==ins_im(i), gt==ins_gt(j));
    end
end

for j=1:wd
    max_score = max(iou_score(:));
    ind = find(max_score == iou_score);
    [row,col] = ind2sub([ht,wd],ind(1));
    
    if (max_score > 0)
        new_ins_im(ins_im0==ins_im(row)) = ins_gt(col);
    end
    
    iou_score(:, col) = -1;
    iou_score(row, :) = -1;
end

ins_im1 = ins_im0;
ins_im1(ismember(ins_im1, new_ins_im)) = 0;

idx0 = find(ins_im1>0);
if(~isempty(idx0))
    for i=1:length(new_ins_im)
        if(new_ins_im(i)==0)
            idx = idx0(1);
            new_ins_im(i) = ins_im1(idx);
            idx0(1) = [];
        end
    end  
end

ins_im = unique(ins);
ins_im(ins_im==0) = [];
for i=1:length(ins_im)
    new_ins(ins == ins_im(i)) = new_ins_im(i);
end

end