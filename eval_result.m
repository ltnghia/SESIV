% ------------------------------------------------------------------------ 
% Jordi Pont-Tuset - http://jponttuset.github.io/
% April 2016
% ------------------------------------------------------------------------ 
% This file is part of the DAVIS package presented in:
%   Federico Perazzi, Jordi Pont-Tuset, Brian McWilliams,
%   Luc Van Gool, Markus Gross, Alexander Sorkine-Hornung
%   A Benchmark Dataset and Evaluation Methodology for Video Object Segmentation
%   CVPR 2016
% Please consider citing the paper if you use this code.
% ------------------------------------------------------------------------
function [eval, raw_eval] = eval_result(measures, index_file, dir_mask, dir_gt)

if ~iscell(measures)
    measures = {measures};
end

if ~isempty(measures)   
    seq_ids = read_list_from_file( index_file );

    % Sweep all sequences
    for s_id = 1:length(seq_ids)
        %disp(seq_ids{s_id});

        % Get all frame ids for that sequence
        frame_ids = db_frame_ids([dir_gt '/' seq_ids{s_id}]);
        
        % Allocate gt
        mask_gt = cell(length(frame_ids),1);
        for f_id = 1:length(frame_ids)
            [mask_gt{f_id}] = db_read_annot([dir_gt '/' seq_ids{s_id}], frame_ids{f_id});
        end
        
        if iscell(mask_gt{1})
            n_obj = length(mask_gt{1});
        else
            n_obj = 1;
        end

        % Allocate mask
        mask_res = cell(length(frame_ids),1);
        for f_id = 1:length(frame_ids)
            mask_res{f_id} = db_read_result([dir_mask '/' seq_ids{s_id}], frame_ids{f_id}, n_obj);
        end
        
        % Evaluate these masks
        tmp_eval = eval_sequence(mask_res, mask_gt, measures);
        
        %disp(tmp_eval.F.mean);
        %disp(tmp_eval.J.mean);
        
        for ii=1:length(measures)
            raw_eval.(measures{ii})(s_id) = tmp_eval.(measures{ii});
        end
    end
end
    
%% Put everything in a single matrix
for ii=1:length(measures)
    eval.(measures{ii}).mean = [raw_eval.(measures{ii}).mean];
    if ~strcmp(measures{ii},'T')
        eval.(measures{ii}).recall = [raw_eval.(measures{ii}).recall];
        eval.(measures{ii}).decay = [raw_eval.(measures{ii}).decay];
    end
    
    % Store per-frame results
    eval.(measures{ii}).raw = cell(1,length(seq_ids));
    for jj=1:length(seq_ids)
        eval.(measures{ii}).raw{jj} = raw_eval.(measures{ii})(jj).raw;
    end
end

end
