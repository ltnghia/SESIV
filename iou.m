function [score] = iou(mask1, mask2)
    m1 = mask1 > 0;
    m2 = mask2 > 0;
    
    tp = sum(m1(m2));
    fp = sum(m1(~m2));
    fn = sum(~m1(m2));
    score = tp / (tp + fp + fn + eps);
end