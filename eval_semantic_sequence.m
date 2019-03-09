function eval = eval_semantic_sequence(mask_res, mask_gt, measures, sem, sem_gt)
    
    % Check measures
    if ischar(measures)
        measures = {measures};
    end
    if ~iscell(measures)
        error('Measures must be a cell or a single char')
    end
    if ~all(ismember(measures,{'JS','FS'}))
        error('Measures not valid, must be in: ''JS'',''FS''')
    end
    
    % Get all frames of the sequence
    frame_ids = length(mask_res);
    
    if iscell(mask_gt{1})
        n_obj = length(mask_gt{1});
    else
        n_obj = 1;
    end
    
    % Allocate
    for ii=1:length(measures)
        frame_eval.(measures{ii}) = zeros(length(frame_ids),n_obj);
    end 
    
    for f_id = 1:frame_ids
        %fprintf('.');
        %disp(f_id)
       
        % Check size of the mask and logical values
        if iscell(mask_gt{1})
            if length(mask_res{f_id})>length(mask_gt{1})
                error('The number of objects in the result is not the same than in the ground truth');
            elseif ~isequal(size(mask_res{f_id}{1}),size(mask_gt{1}{1}))
                error('Size of results and ground truth are not the same');
            elseif ~islogical(mask_res{f_id}{1})
                error('The input mask must be a logical value');
            end
        else
            if ~isequal(size(mask_res{f_id}),size(mask_gt{1}))
                error('Size of results and ground truth are not the same');
            elseif ~islogical(mask_res{f_id})
                error('The input mask must be a logical value');
            end
        end
        
        % Compute the measures in this particular frame
        tmp_eval = eval_semantic_frame(mask_res{f_id}, measures, mask_gt{f_id}, n_obj, sem{f_id}, sem_gt{f_id});
        for ii=1:length(measures)
            frame_eval.(measures{ii})(f_id,:) = tmp_eval.(measures{ii});
        end
    end
    %fprintf('\n');
    
    % F for boundaries
    if ismember('FS',measures)
        assert(~all(isnan(frame_eval.FS(:))));
        
        eval.FS.mean   = mean(frame_eval.FS,1);
        eval.FS.std    = std(frame_eval.FS,1);
        eval.FS.recall = sum(frame_eval.FS>0.5,1)/size(frame_eval.FS,1);
        
        for ii=1:n_obj
            tmp = get_mean_values(frame_eval.FS(:,ii),4);
            eval.FS.decay(ii)  = tmp(1)-tmp(end);
        end
        
        % Store per-frame results
        eval.FS.raw = frame_eval.FS;
    end
    
    % Jaccard
    if ismember('JS',measures)
        eval.JS.mean   = mean(frame_eval.JS,1);
        eval.JS.std    = std(frame_eval.JS,1);
        eval.JS.recall = sum(frame_eval.JS>0.5,1)/size(frame_eval.JS,1);
        
        for ii=1:n_obj
            tmp = get_mean_values(frame_eval.JS(:,ii),4);
            eval.JS.decay(ii)  = tmp(1)-tmp(end);
        end
        
        % Store per-frame results
        eval.JS.raw = frame_eval.JS;
    end
end

function mvals = get_mean_values(values,N_bins)
    % Get four mean values to see how the quality evolves with time
    ids = round(linspace(1, length(values),N_bins+1));
    mvals = zeros(1,length(ids)-1);
    for jj=1:(length(ids)-1)
       mvals(jj) = mean(values(ids(jj):ids(jj+1)));
    end
end