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
function result = db_read_result(seq_id, frame_id, n_objs)
    res_file = fullfile(seq_id, frame_id);
    
    if ~exist(res_file,'file')
        error(['Error: ''' res_file ''' not found'])
    end
    result_im = imread(res_file);
    
    % Some sanity checks
    if (size(result_im,3)~=1)
        error('You are reading an image result with three channels, should have only one');
    end
    
    if db_sing_mult_obj()==0 % Single object
        if ~(all(ismember(unique(result_im),[0,255])) || all(ismember(unique(result_im),[0,1])))
            result = result_im>(max(result_im(:))/2.);
        else
            result = (result_im>0);
        end
    else % Multiple objects
        result = cell(n_objs,1);
        for ii=1:n_objs
            result{ii} = (result_im==ii);
        end
    end
end