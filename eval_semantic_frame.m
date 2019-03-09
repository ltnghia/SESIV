function eval = eval_semantic_frame(mask, measures, mask_gt, num_objects, sem, sem_gt)

    if ~exist('num_objects','var')
        num_objects = max(length(mask), length(mask_gt));
    end
    
    % Compute measures
    if ismember('JS',measures)
        eval.J = jaccard_region(mask, mask_gt, num_objects); 
        if iscell(mask) % multiple objects
            for i=1:length(eval.J)
                eval.JS(i) = eval.J(i) * (sem{i}==sem_gt{i}) * (sem{i} > 0) * (sem_gt{i} > 0);
            end
        else
            eval.JS = eval.J * (sem==sem_gt) * (sem > 0) * (sem_gt > 0);
        end
    end
    if ismember('FS',measures)
        eval.F = f_boundary(mask, mask_gt, num_objects);    
        if iscell(mask) % multiple objects
            for i=1:length(eval.F)
                eval.FS(i) = eval.F(i) * (sem{i}==sem_gt{i}) * (sem{i} > 0) * (sem_gt{i} > 0);
            end
        else
            eval.FS = eval.F * (sem==sem_gt) * (sem > 0) * (sem_gt > 0);
        end
    end
end