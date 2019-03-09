function [annot, annot_sem] = db_read_annot_with_semantic(seq_id, frame_id, seq_sem_id)
    annot_file = fullfile(seq_id, frame_id);
    sem_file = fullfile(seq_sem_id, frame_id);
    if ~exist(annot_file,'file')
        error(['Error: ''' annot_file ''' not found'])
    end
    if ~exist(sem_file,'file')
        error(['Error: ''' sem_file ''' not found'])
    end
    im_annot = imread(annot_file);
    im_sem = imread(sem_file);
    
    assert(size(im_annot,3)==1)
    assert(size(im_sem,3)==1)
    
    % Get the number of objects from the first frame
    fr_ids = db_frame_ids(seq_id);
    im_first = imread(fullfile(seq_id, fr_ids{1}));
    n_objs = max(im_first(:));
    
    % If single object
    if db_sing_mult_obj==0
        n_objs = 1;
        im_annot = (im_annot>0);
    end
    
    % Transform it into a cell of masks
    if db_sing_mult_obj==1
        annot = cell(n_objs,1);
        annot_sem = cell(n_objs,1);
        for ii=1:n_objs
            annot{ii} = (im_annot==ii);
            annot_sem{ii} = unique(im_sem(annot{ii}));
            if(isempty(annot_sem{ii}))
                annot_sem{ii} = 0;
            end
            if(length(annot_sem{ii}) > 1)
                error('semantic instance has multiple labels');
            end
        end
    else
        annot = im_annot;
        annot_sem = unique(im_sem(annot));
        if(isempty(annot_sem))
            annot_sem = 0;
        end
        if(length(annot_sem) > 1)
            error('semantic instance has multiple labels');
        end
    end
        
end