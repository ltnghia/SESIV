function [result, result_sem] = db_read_result_with_semantic(seq_id, frame_id, n_objs, seq_sem_id)
    res_file = fullfile(seq_id, frame_id);
    sem_file = fullfile(seq_sem_id, frame_id);
    
    if ~exist(res_file,'file')
        error(['Error: ''' res_file ''' not found'])
    end
    if ~exist(sem_file,'file')
        error(['Error: ''' sem_file ''' not found'])
    end
    result_im = imread(res_file);
    result_im_sem = imread(sem_file);
    
    % Some sanity checks
    if (size(result_im,3)~=1)
        error('You are reading an image result with three channels, should have only one');
    end
    if (size(result_im_sem,3)~=1)
        error('You are reading a semantic image result with three channels, should have only one');
    end
    
    if db_sing_mult_obj()==0 % Single object
        if ~(all(ismember(unique(result_im),[0,255])) || all(ismember(unique(result_im),[0,1])))
            result = result_im>(max(result_im(:))/2.);
        else
            result = (result_im>0);
        end
        result_sem = unique(result_im_sem(result));
        if(isempty(result_sem))
            result_sem = 0;
        end
        if(length(result_sem) > 1)
            error('semantic instance has multiple labels');
        end
    else % Multiple objects
        result = cell(n_objs,1);
        result_sem = cell(n_objs,1);
        for ii=1:n_objs
            result{ii} = (result_im==ii);
            result_sem{ii} = unique(result_im_sem(result{ii}));
            if(isempty(result_sem{ii}))
                result_sem{ii} = 0;
            end
            if(length(result_sem{ii}) > 1)
                [a, b] = hist(double(result_im_sem(result{ii})), double(unique(result_im_sem(result{ii}))));
                idx = find(a == max(a));
                idx = idx(1);
                result_sem{ii} = result_sem{ii}(idx);
            end
            
            if(length(result_sem{ii}) > 1)
                error('semantic instance has multiple labels');
            end
        end
    end
end